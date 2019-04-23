<#
    .SYNOPSIS
    Downloads a PLM-Jar from the PLM webservice.

    .DESCRIPTION
    The "Get-PlmJar" cmdlet searched for download links on the PLM's submissions page and filters them according to the given parameters.
    It either returns all available download options or downloads the specified archives.

    .PARAMETER Session
    A web session to the PLM website.

    .PARAMETER UserUsername
    The user's username authenticate for download permissions.

    .PARAMETER UserPassword
    The user's password authenticate for download permissions.

    .PARAMETER DownloadPath
    The path to which the jar files are to be downloaded to.

    .PARAMETER ExerciseNumber
    The exercise numbers for which jar files are to be downloaded.

    .PARAMETER All
    Whether to download all available jar files.

    .PARAMETER ListAvailable
    Whether to list all available download options.

    .EXAMPLE
    $UserUsername = "123456789"
    $Session = Initialize-PlmSession -PlmUsername "PLM" -UserUsername $UserUsername

    Get-PlmJar -Session $Session -Username $UserUsername -DownloadPath "D:\Downloads"
    Get-PlmJar -Session $Session -Username $UserUsername -DownloadPath "D:\Downloads" -ExerciseNumber @(1, 2)
    Get-PlmJar -Session $Session -Username $UserUsername -ListAvailable

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJar.md
#>
Function Get-PlmJar {
    [CmdletBinding(DefaultParametersetName = "Newest")]

    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestSession] $Session,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String] $UserUsername,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [SecureString] $UserPassword,

        [Parameter(
            ParameterSetName = "Newest"
        )]
        [Parameter(
            ParameterSetName = "ExerciseNumber"
        )]
        [Parameter(
            ParameterSetName = "All"
        )]
        [ValidateScript({Test-Path -Path $PSItem})]
        [String] $DownloadPath = (Get-DownloadFolder),

        [Parameter(
            ParameterSetName = "ExerciseNumber"
        )]
        [ValidateNotNullOrEmpty()]
        [Int[]] $ExerciseNumber,

        [Parameter(
            ParameterSetName = "All"
        )]
        [Switch] $All,

        [Parameter(
            ParameterSetName = "ListAvailable",
            Mandatory = $True
        )]
        [Switch] $ListAvailable
    )

    # Fetch available download options
    $PlmDownloadUri = Get-PlmUri -Type "Download"
    $Request = Invoke-WebRequest `
        -Uri $PlmDownloadUri `
        -WebSession $Session
    $DownloadLinks = $Request.ParsedHtml.Body.GetElementsByTagName("a") |
        Where-Object {
        $PSItem.getAttribute("href") -Match "^about:/uebung/upload/\d+/\d+_\d{2}.jar$"
    } |
        ForEach-Object {
        [PSCustomObject] @{
            $PSItem.innerText = $PSItem.getAttribute("href").TrimStart("about:")
        }
    }

    Switch ($PSCmdlet.ParameterSetName) {
        "ExerciseNumber" {

            # Filter exercise numbers
            $DownloadLinks = $DownloadLinks |
                Where-Object {
                $ExerciseNumber -Contains $PSItem.PSObject.Properties.Name
            }
            Break
        }
        "ListAvailable" {

            # Return download options if desired
            Return $DownloadLinks
        }
    }

    $PlmUri = Get-PlmJarBuilderVariable -Name "PlmUri"

    # Download either the newest, all available and filtered jar files or return false
    If (-Not $DownloadLinks) {
        Return $False
    } Else {
        $UserCredential = New-Object PSCredential($UserUsername, $UserPassword)

        Switch ($PSCmdlet.ParameterSetName) {
            "Newest" {
                Get-FileFromWeb -Url "$PlmUri$($DownloadLinks[$DownloadLinks.Length - 1].PSObject.Properties.Value)" -LocalPath $DownloadPath -Credential $UserCredential
                Break
            }
            {@("ExerciseNumber", "All") -Contains $PSItem} {
                ForEach ($DownloadLink In $DownloadLinks) {
                    Get-FileFromWeb -Url "$PlmUri$($DownloadLink.PSObject.Properties.Value)" -LocalPath $DownloadPath -Credential $UserCredential
                }

                Break
            }
        }
    }
}

<#
    .SYNOPSIS
    Gets a PLM-URI.

    .DESCRIPTION
    The "Get-PlmUri" cmdlet builds a PLM-URI from its base components and the given type that is translated to a pageID number.

    .PARAMETER Type
    The URI's type that is to be returned.

    .EXAMPLE
    Get-PlmUri -Type "Login"
    Get-PlmUri -Type "Upload"
    Get-PlmUri -Type "Download"

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmUri.md
#>
Function Get-PlmUri {
    Param (
        [Parameter(
            Mandatory = $True,
            Position = 0
        )]
        [ValidateSet("Login", "Upload", "Download")]
        [String] $Type
    )

    # Compose PLM-URIs
    $PlmUri = Get-PlmJarBuilderVariable -Name "PlmUri"
    $PlmPageIdFormat = Get-PlmJarBuilderVariable -Name "PlmPageIdFormat"
    $PageId = (Get-PlmJarBuilderVariable -Name "Plm${Type}PageId").ToString($PlmPageIdFormat)

    Return "${PlmUri}/uebung/index.php?pageID=$PageId"
}

<#
    .SYNOPSIS
    Initializes a PLM session.

    .DESCRIPTION
    The "Initialize-PlmSession" cmdlet request PLM's login site using basic authentication.
    It fills the login site's form elements and submits that form.
    The user should be logged in then, otherwise an error is thrown.

    .PARAMETER PlmUsername
    The username for PLM's basic authentication.

    .PARAMETER PlmPassword
    The password for PLM's basic authentication.

    .PARAMETER UserUsername
    The user's username authenticate for download permissions.

    .PARAMETER UserPassword
    The user's password authenticate for download permissions.

    .EXAMPLE
    Initialize-PlmSession -PlmUsername "PLM" -UserUsername 123456789

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Initialize-PlmSession.md

    .NOTES
    The user's password is trimmed to 15 characters, because PLM ... wants it this way.
#>
Function Initialize-PlmSession {
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String] $PlmUsername,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [SecureString] $PlmPassword,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String] $UserUsername,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [SecureString] $UserPassword
    )

    # Reset session
    $Session = $Null

    $LoginUri = Get-PlmUri -Type "Login"

    # Limit password to 15 characters (given PLM restriction)
    $UserPasswordLocal = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($UserPassword)
    )

    If ($UserPasswordLocal.Length -Gt 15) {
        $UserPasswordLocal = $UserPasswordLocal.Substring(0, 15)
    }

    # Basic authentication credentials
    $PlmCredential = New-Object PSCredential($PlmUsername, $PlmPassword)

    # Request login site to generate session
    $Request = Invoke-WebRequest `
        -Uri $LoginUri `
        -Credential $PlmCredential `
        -SessionVariable "Session"

    # Fill login form's fields
    $Form = $Request.Forms[0]
    $Form.Fields["UserID"] = $UserUsername
    $Form.Fields["Password"] = $UserPasswordLocal
    # Due to bad weblayout the default is to send a new password to your email!
    # This unwanted effect is hereby corrected.
    $Form.Fields["action"] = "Anmelden"

    # Post the login form
    $Request = Invoke-WebRequest `
        -Uri $LoginUri `
        -WebSession $Session `
        -Method "Post" `
        -ContentType "application/x-www-form-urlencoded" `
        -Body $Form.Fields `
        -MaximumRedirection 0 `
        -ErrorAction SilentlyContinue

    # Verify that we are redirected to the greeting (login successful) page
    If (-Not ($Request.Headers.Location -Match "^https:\/\/www\.plm\.eecs\.uni-kassel\.de\/uebung\/index\.php\?pageID=100$")) {
        Throw "Login failed!"
    }

    Return $Session
}

<#
    .SYNOPSIS
    Publishs a PLM-Jar.

    .DESCRIPTION
    The "Publish-PlmJar" cmdlet extracts the exercise number from the jar file's name and requests the PLM's upload site.
    If the upload site currently does allow uploads a HTTPS post request for the given jar file is constructed and sent.

    .PARAMETER Session
    A web session to the PLM website.

    .PARAMETER Path
    The path directly to an exercise root folder or to the jar file that is to be uploaded.

    .EXAMPLE
    $Session = Initialize-PlmSession -PlmUsername "PLM" -UserUsername $UserUsername

    Publish-PlmJar -Session $Session -Path "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen"
    Publish-PlmJar -Session $Session -Path "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen\Aufgabenblatt 1\Lösung\123456789_01.jar"

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Publish-PlmJar.md
#>
Function Publish-PlmJar {
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestSession] $Session,

        [Parameter(Mandatory = $True)]
        [ValidateScript({Test-Path -Path $PSItem})]
        [String] $Path
    )

    $JarFileRegex = [Regex] (Get-PlmJarBuilderConfigProperty -PropertyName "JarFileRegex").JarFileRegex

    # Resolve exercise root path to newest jar file path
    If (Test-Path -Path $Path -PathType "Container") {
        $ExerciseFolder = Get-ExerciseFolder -ExerciseRootPath $Path -Newest
        $SolutionPath = (Get-PlmJarBuilderConfigProperty -PropertyName "SolutionPath").SolutionPath
        $JarFile = Get-ChildItem -Path "$($ExerciseFolder.FullName)\$SolutionPath" -Filter "*.jar" -File |
            Where-Object {
            $PSItem.Name -Match $JarFileRegex
        }

        If ($JarFile.Count -Ne 1) {

            # More than one newest .jar file found!
            Throw "Mehr als eine neueste .jar-Datei gefunden!"
        } Else {
            $Path = $JarFile[0].FullName
        }
    }

    # Get the exercise number from file name
    $JarFileName = (Get-Item -Path $Path).Name
    $ExerciseNumber = $JarFileRegex.Match($JarFileName).Groups[2].Value

    # Request upload site to check upload availability
    $UploadUri = Get-PlmUri -Type "Upload"
    $Request = Invoke-WebRequest `
        -Uri $UploadUri `
        -WebSession $Session

    If (Test-PlmUploadAvailable -Request $Request) {
        $Form = $Request.Forms[0]

        If ((-Not $ExerciseNumber) -Or $Form.Fields.ContainsKey("exercise_$ExerciseNumber")) {

            # http://blog.majcica.com/2016/01/13/powershell-tips-and-tricks-multipartform-data-requests/
            Add-Type -AssemblyName "System.Web"

            $ContentType = [System.Web.MimeMapping]::GetMimeMapping($Path)
            $Boundary = "---------------------------$([GUID]::NewGuid().ToString())"
            $FileBin = [System.IO.File]::ReadAllBytes($Path)
            $EncodingIso = [System.Text.Encoding]::GetEncoding("ISO-8859-1")
            $EncodingUtf = [System.Text.Encoding]::GetEncoding("UTF-8")
            $JarBytes = $EncodingUtf.GetBytes($JarFileName)

            $Body = @"
--$Boundary
Content-Disposition: form-data; name="MAX_FILE_SIZE"

5000000
--$Boundary
Content-Disposition: form-data; name="exercise_$ExerciseNumber"; filename="$($EncodingIso.GetString($JarBytes))"
Content-Type: $($ContentType)

$($EncodingIso.GetString($FileBin))
--$Boundary
Content-Disposition: form-data; name="overwrite"

on
--$Boundary--
"@

            $Request = Invoke-WebRequest `
                -Uri $UploadUri `
                -WebSession $Session `
                -Method "Post" `
                -ContentType "multipart/form-data; boundary=$Boundary" `
                -Body $Body
        } Else {
            Write-ErrorRecord `
                -Exception "InvalidOperationException" `
                -ErrorId "ExerciseNumberError" `
                -ErrorCategory "InvalidOperation" `
                -TargetObject $Form `
                -Message (
                -join (
                    "Aus dem Dateinamen der Datei, die hochgeladen werden soll, folgt die Übungsnummer $ExerciseNumber. ",
                    "Diese kann aktuell nicht hochgeladen werden. ",
                    "Für den Upload freigegeben ist `"$(($Form.Fields.GetEnumerator() | Select-Object -Expand "Key")[1])`"."
                )
            )
        }
    } Else {
        Write-ErrorRecord `
            -Exception "InvalidOperationException" `
            -ErrorId "UploadAvailableError" `
            -ErrorCategory "InvalidOperation" `
            -TargetObject $Request `
            -Message (
            -join (
                "Es steht keine Abgabe von Lösungen an."
            )
        )
    }
}

<#
    .SYNOPSIS
    Tests the availability of PLM-Jar uploads.

    .DESCRIPTION
    The "Test-PlmUploadAvailable" cmdlet optionally requests PLM's upload site and searches for the information that uploads are currently disabled.
    If they are $False is returned, otherwise $True.

    .PARAMETER Session
    A web session to the PLM website.

    .PARAMETER Request
    A web request to PLM's upload site.

    .EXAMPLE
    $UploadUri = Get-PlmUri -Type "Upload"
    $Session = Initialize-PlmSession -PlmUsername "PLM" -UserUsername $UserUsername
    $Request = Invoke-WebRequest `
        -Uri $UploadUri `
        -WebSession $Session

    Test-PlmUploadAvailable -Session $Session
    Test-PlmUploadAvailable -Request $Request

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Test-PlmUploadAvailable.md
#>
Function Test-PlmUploadAvailable {
    [CmdletBinding(DefaultParametersetName = "Session")]

    Param (
        [Parameter(
            ParameterSetName = "Session",
            Mandatory = $True,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestSession] $Session,

        [Parameter(
            ParameterSetName = "Request",
            Mandatory = $True,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $Request
    )

    $LocalRequest = $Null

    Switch ($PSCmdlet.ParameterSetName) {
        "Session" {
            $PlmUploadUri = Get-PlmUri -Type "Upload"

            $LocalRequest = Invoke-WebRequest `
                -Uri $PlmUploadUri `
                -WebSession $Session
            Break
        }
        "Request" {
            $LocalRequest = $Request
            Break
        }
    }

    $MatchFound = $False

    $LocalRequest.ParsedHtml.Body.GetElementsByClassName("info") |
        ForEach-Object {
        If ($PSItem.innerText.Trim() -Match "Es steht keine Abgabe von Lösungen an") {
            $MatchFound = $True
        }
    }

    If ($MatchFound) {
        Return $False
    } Else {
        Return $True
    }
}

Export-ModuleMember -Function *
