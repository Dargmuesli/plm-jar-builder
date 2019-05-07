[String] $ModuleAuthor = "Jonas Thelemann"
[String] $ModuleAuthorUsername = "dargmuesli"
[String] $ModuleName = "PLM-Jar-Builder"

[String] $ConfigPath = (Join-Path -Path $PSScriptRoot -ChildPath ".." | Join-Path -ChildPath "Config")
[String] $ConfigFileName = "$ModuleName.json"
[String] $ConfigFilePath = (Join-Path -Path $ConfigPath -ChildPath $ConfigFileName)
[String] $NoteFileName = "$ModuleName-Note.md"
[String] $NoteFilePath = (Join-Path -Path $ConfigPath -ChildPath $NoteFileName)

[String] $ExerciseNumberFormat = "00"
[String] $PlmPageIdFormat = "000"

[String] $PlmUri = "https://www.plm.eecs.uni-kassel.de"
[Int] $PlmLoginPageId = "1"
[Int] $PlmUploadPageId = "102"
[Int] $PlmDownloadPageId = "103"

<#
    .SYNOPSIS
    Gets the PLM-Jar-Builder configuration.

    .DESCRIPTION
    The "Get-PlmJarBuilderConfig" cmdlet returns the PLM-Jar-Builder configuration file's JSON object representation or null if it cannot be found.

    .EXAMPLE
    Get-PlmJarBuilderConfig

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJarBuilderConfig.md
#>
Function Get-PlmJarBuilderConfig {
    $ConfigFilePath = Get-PlmJarBuilderVariable -Name "ConfigFilePath"

    If (Test-Path -Path $ConfigFilePath) {
        Return Get-Content -Path $ConfigFilePath -Encoding "UTF8" |
            ConvertFrom-Json
    } Else {
        Return $Null
    }
}

<#
    .SYNOPSIS
    Gets a PLM-Jar-Builder configuration property.

    .DESCRIPTION
    The "Get-PlmJarBuilderConfigProperty" cmdlet reads the PLM-Jar-Builder configuration and creates one if none exists.
    Then, it gets the correct PLM-Jar-Builder configuration property path and returns its value.

    .PARAMETER PropertyName
    The property name of the property whose value is to be returned.

    .PARAMETER PropertyPath
    The property path of the property whose value is to be returned.

    .EXAMPLE
    (Get-PlmJarBuilderConfigProperty -PropertyName "ExerciseRootPath").ExerciseRootPath
    Get-PlmJarBuilderConfigProperty -PropertyPath "Custom.ExerciseRootPath"

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJarBuilderConfigProperty.md
#>
Function Get-PlmJarBuilderConfigProperty {
    Param (
        [Parameter(
            ParameterSetName = "PropertyName",
            Mandatory = $True,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String] $PropertyName,

        [Parameter(
            ParameterSetName = "PropertyPath",
            Mandatory = $True,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String] $PropertyPath
    )

    $ConfigFilePath = Get-PlmJarBuilderVariable -Name "ConfigFilePath"

    # Create config file if it does not exist already
    If (-Not (Test-Path -Path $ConfigFilePath)) {
        New-PlmJarConfig
    }

    $PlmJarConfig = Get-PlmJarBuilderConfig
    $LocalPlmJarConfigPropertyPath = $Null

    Switch ($PSCmdlet.ParameterSetName) {
        "PropertyName" {
            $LocalPlmJarConfigPropertyPath = Get-PlmJarBuilderConfigPropertyPath -PropertyName $PropertyName
            Break
        }
        "PropertyPath" {
            $LocalPlmJarConfigPropertyPath = $PropertyPath
            Break
        }
    }

    If ($LocalPlmJarConfigPropertyPath) {
        $TestResult = Test-PropertyExists -Object $PlmJarConfig -PropertyName $LocalPlmJarConfigPropertyPath -PassThrough

        If ($TestResult) {
            Return $TestResult
        } Else {
            Return $Null
        }
    } Else {
        Return $Null
    }
}

<#
    .SYNOPSIS
    Gets a PLM-Jar-Builder configuration property path.

    .DESCRIPTION
    The "Get-PlmJarBuilderConfigPropertyPath" cmdlet returns property name's PLM-Jar-Builder configuration property's path.

    .PARAMETER PropertyName
    The property name of the property path that is to be returned.

    .EXAMPLE
    Get-PlmJarBuilderConfigPropertyPath -PropertyName "ExerciseRootPath"

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJarBuilderConfigPropertyPath.md
#>
Function Get-PlmJarBuilderConfigPropertyPath {
    Param (
        [Parameter(
            Mandatory = $True,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        $PropertyName
    )

    $PropertyDictionary = @{
        "ExerciseRootPath"    = "Custom.ExerciseRootPath"
        "DownloadPath"        = "Custom.DownloadPath"
        "Exclude"             = "Custom.Exclude"
        "NoNote"              = "Custom.NoNote"
        "PlmUsername"         = "Custom.PLM.Username"
        "PlmPassword"         = "Custom.PLM.EncryptedPassword"
        "MatriculationNumber" = "Custom.User.Matriculationnumber"
        "UserPassword"        = "Custom.User.EncryptedPassword"
        "SolutionPath"        = "Default.SolutionPath"
        "ExerciseSheetRegex"  = "Default.ExerciseSheetRegex"
        "JarFileRegex"        = "Default.JarFileRegex"
    }

    Return $PropertyDictionary[$PropertyName]
}

<#
    .SYNOPSIS
    Gets a PLM-Jar-Builder variable.

    .DESCRIPTION
    The "Get-PlmJarBuilderVariable" cmdlet returns a local script variable or lists all available.

    .PARAMETER Name
    The variable's name whose value is to be returned.

    .PARAMETER ListAvailable
    Whether all available options are to be returned.

    .EXAMPLE
    Get-PlmJarBuilderVariable -Name "ModuleName"
    Get-PlmJarBuilderVariable -ListAvailable

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJarBuilderVariable.md
#>
Function Get-PlmJarBuilderVariable {
    [CmdletBinding(DefaultParametersetName = "Name")]

    Param (
        [Parameter(
            ParameterSetName = "Name",
            Mandatory = $True,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String] $Name,

        [Parameter(ParameterSetName = "ListAvailable")]
        [Switch] $ListAvailable
    )

    Switch ($PSCmdlet.ParameterSetName) {
        "Name" {
            Return Get-Variable -Name $Name -Scope "Script" -ValueOnly
        }
        "ListAvailable" {
            Return Get-Variable -Scope "Script"
        }
    }
}

<#
    .SYNOPSIS
    Creates a new PLM-Jar-Builder config.

    .DESCRIPTION
    The "New-PlmJarConfig" cmdlet creates a new PLM-Jar-Builder configuration file containing the specified values.

    .PARAMETER ExerciseRootPath
    The path to the directory that contains the exercise folders.

    .PARAMETER DownloadPath
    The path to download jar files to.

    .PARAMETER Exclude
    A list of file extensions to exclude when packing the jar.

    .PARAMETER NoNote
    Whether to exclude a note regarding this tool in the jar.

    .PARAMETER PlmUsername
    The username for PLM's basic authentication.

    .PARAMETER PlmPasswordEncrypted
    The password for PLM's basic authentication.

    .PARAMETER MatriculationNumber
    The user's matriculation number / PLM username.

    .PARAMETER UserPasswordEncrypted
    The user's PLM password.

    .PARAMETER SolutionPath
    The relative path from an exercise folder to its solution folder.

    .PARAMETER ExerciseSheetRegex
    The regular expression that is used when looking for exercise folders.

    .PARAMETER JarFileRegex
    The regular expression that is used when looking for jar files.

    .EXAMPLE
    New-PlmJarConfig

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/New-PlmJarConfig.md
#>
Function New-PlmJarConfig {
    Param (
        [ValidateScript( { Test-Path -Path $PSItem })]
        [String] $ExerciseRootPath = (Join-Path -Path $([Environment]::GetFolderPath("MyDocuments")) -ChildPath "Universität" | Join-Path -ChildPath "Informatik" | Join-Path -ChildPath "Semester 1" | Join-Path -ChildPath "Einführung in die Programmierung" | Join-Path -ChildPath "Übungen"),

        [ValidateScript( { Test-Path -Path $PSItem })]
        [String] $DownloadPath = (Get-DownloadFolder),

        [ValidateNotNull()]
        [Object] $Exclude = @(".*\.class", ".*\.eml", ".*\.iml", ".*\.jar", ".*\.odt", ".*\.odg", ".*\.ods", ".*\.old", "[^\\]+\\\.idea\\.*", ".*\\In\.java", "[^\\]+\\out\\.*", ".*\\Out\.java"),

        [ValidateNotNullOrEmpty()]
        [Switch] $NoNote,

        [ValidateNotNullOrEmpty()]
        [String] $PlmUsername,

        [ValidateNotNullOrEmpty()]
        [SecureString] $PlmPasswordEncrypted,

        [ValidateNotNullOrEmpty()]
        [String] $MatriculationNumber,

        [ValidateNotNullOrEmpty()]
        [SecureString] $UserPasswordEncrypted,

        [ValidateNotNullOrEmpty()]
        [String] $SolutionPath = "Lösung",

        [ValidateNotNullOrEmpty()]
        [String] $ExerciseSheetRegex = "^Aufgabenblatt (\d{1,2})$",

        [ValidateNotNullOrEmpty()]
        [String] $JarFileRegex = "^(\d+|.*)_(\d{2}).jar$"
    )

    $ConfigFilePath = Get-PlmJarBuilderVariable -Name "ConfigFilePath"

    $Json = ConvertTo-Json ([Ordered] @{
            "Custom"  = [Ordered] @{
                "ExerciseRootPath" = $ExerciseRootPath
                "DownloadPath"     = $DownloadPath
                "Exclude"          = $Exclude
                "NoNote"           = $NoNote.IsPresent
                "PLM"              = [Ordered] @{
                    "Username"          = $PlmUsername
                    "EncryptedPassword" = $PlmPasswordEncrypted
                }
                "User"             = [Ordered] @{
                    "MatriculationNumber" = $MatriculationNumber
                    "EncryptedPassword"   = $UserPasswordEncrypted
                }
            }
            "Default" = [Ordered] @{
                "SolutionPath"       = $SolutionPath
                "ExerciseSheetRegex" = $ExerciseSheetRegex
                "JarFileRegex"       = $JarFileRegex
            }
        })

    [System.IO.File]::WriteAllLines($ConfigFilePath, $Json)
}

<#
    .SYNOPSIS
    Sets a PLM-Jar-Builder configuration property.

    .DESCRIPTION
    The "Set-PlmJarBuilderConfigProperty" cmdlet gets the correct PLM-Jar-Builder configuration property path and sets its value.

    .PARAMETER PropertyName
    The property name of the property whose value is to be set.

    .PARAMETER PropertyPath
    The property path of the property whose value is to be set.

    .PARAMETER Value
    The value that the property is to be set to.

    .EXAMPLE
    Set-PlmJarBuilderConfigProperty

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Set-PlmJarBuilderConfigProperty.md
#>
Function Set-PlmJarBuilderConfigProperty {
    Param (
        [Parameter(
            ParameterSetName = "PropertyName",
            Mandatory = $True,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String] $PropertyName,

        [Parameter(
            ParameterSetName = "PropertyPath",
            Mandatory = $True,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String] $PropertyPath,

        [Parameter(
            Mandatory = $True,
            Position = 1
        )]
        [ValidateNotNull()]
        [String] $Value
    )

    $ConfigFilePath = Get-PlmJarBuilderVariable -Name "ConfigFilePath"
    $PlmJarConfig = Get-PlmJarBuilderConfig
    $LocalPlmJarConfigPropertyPath = $Null

    Switch ($PSCmdlet.ParameterSetName) {
        "PropertyName" {
            $LocalPlmJarConfigPropertyPath = Get-PlmJarBuilderConfigPropertyPath -PropertyName $PropertyName
            Break
        }
        "PropertyPath" {
            $LocalPlmJarConfigPropertyPath = $PropertyPath
            Break
        }
    }

    If ($LocalPlmJarConfigPropertyPath) {
        If (Test-PropertyExists -Object $PlmJarConfig -PropertyName $LocalPlmJarConfigPropertyPath) {
            $Expression = "`$PlmJarConfig.$LocalPlmJarConfigPropertyPath = $Value"
            Invoke-Expression $Expression
            [System.IO.File]::WriteAllLines($ConfigFilePath, ($PlmJarConfig | ConvertTo-Json))
        }
    }
}

<#
    .SYNOPSIS
    Sets a PLM-Jar-Builder variable.

    .DESCRIPTION
    The "Set-PlmJarBuilderVariable" cmdlet sets a local script variable to a specified value.

    .PARAMETER Name
    The variable's name whose value is to be set.

    .PARAMETER Value
    The value to which the variable's name is to be set.

    .EXAMPLE
    Set-PlmJarBuilderVariable -Name "ModuleName" -Value "PLM-Jar-Builder"

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Set-PlmJarBuilderVariable.md
#>
Function Set-PlmJarBuilderVariable {
    Param (
        [Parameter(
            Mandatory = $True,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String] $Name,

        [Parameter(
            Mandatory = $True,
            Position = 1
        )]
        [ValidateNotNullOrEmpty()]
        [String] $Value
    )

    Set-Variable -Name $Name -Value $Value -Scope "Script"
}

Export-ModuleMember -Function *
