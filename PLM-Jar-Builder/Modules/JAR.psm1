<#
    .SYNOPSIS
    Finds a matriculation number.

    .DESCRIPTION
    The "Find-MatriculationNumber" cmdlet searches an exercise root path for files matching the jar file regular expression, then extracts included matriculation numbers.

    .PARAMETER ExerciseRootPath
    The path to the directory that contains the exercise folders.

    .PARAMETER All
    Whether to return all findings.
    Without this switch only unique values are returned.

    .EXAMPLE
    Find-MatriculationNumber -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen"
    Find-MatriculationNumber -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen" -All

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Find-MatriculationNumber.md
#>
Function Find-MatriculationNumber {
    Param (
        [Parameter(
            Mandatory = $True,
            Position = 0
        )]
        [ValidateScript({Test-Path -Path $PSItem})]
        [String] $ExerciseRootPath,

        [Switch] $All
    )

    # Search jar files matching a pattern and extract the matriculation numbers
    $JarFileRegex = [Regex] (Get-PlmJarBuilderConfigProperty -PropertyName "JarFileRegex").JarFileRegex
    $FoundMatriculationNumbers = Get-ChildItem -Path $ExerciseRootPath -Filter "*.jar" -File -Recurse |
        ForEach-Object {
        Return $JarFileRegex.Match($PSItem.Name).Groups[1].Value
    }

    $MatriculationNumber = @()

    # Filter found matriculation numbers
    ForEach ($FoundMatriculationNumber In $FoundMatriculationNumbers) {
        If ($FoundMatriculationNumber -And ($All -Or (-Not ($MatriculationNumber -Contains $FoundMatriculationNumber)))) {
            $MatriculationNumber += [Int] $FoundMatriculationNumber
        }
    }

    Return $MatriculationNumber
}

<#
    .SYNOPSIS
    Gets exercise folders.

    .DESCRIPTION
    The "Get-ExerciseFolder" cmdlet searches an exercise root path for folders matching the exercise folder regular expression and returns its findings.

    .PARAMETER ExerciseRootPath
    The path to the directory that contains the exercise folders.

    .PARAMETER ExerciseNumber
    The exercise numbers for which folders are to be found.

    .PARAMETER Newest
    Whether to return only the exercise folder with the highest exercise number.

    .EXAMPLE
    Get-ExerciseFolder -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen"
    Get-ExerciseFolder -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen" -ExerciseNumbers @(1, 2)
    Get-ExerciseFolder -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen" -Newest
    Get-ExerciseFolder -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen" -ListAvailable

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-ExerciseFolder.md
#>
Function Get-ExerciseFolder {
    [CmdletBinding(DefaultParametersetName = "All")]

    Param (
        [Parameter(
            ParameterSetName = "All",
            Mandatory = $True,
            Position = 0
        )]
        [Parameter(
            ParameterSetName = "ExerciseNumber"
        )]
        [Parameter(
            ParameterSetName = "Newest"
        )]
        [ValidateScript({Test-Path -Path $PSItem})]
        [String] $ExerciseRootPath,

        [Parameter(
            ParameterSetName = "ExerciseNumber",
            Mandatory = $True,
            Position = 1
        )]
        [ValidateNotNullOrEmpty()]
        [Int[]] $ExerciseNumber,

        [Parameter(
            ParameterSetName = "Newest",
            Mandatory = $True,
            Position = 1
        )]
        [Switch] $Newest
    )

    $ExerciseSheetRegex = [Regex] (Get-PlmJarBuilderConfigProperty -PropertyName "ExerciseSheetRegex").ExerciseSheetRegex

    # Get all exercise directories
    $ExercisePath = Get-ChildItem -Path $ExerciseRootPath -Directory |
        Where-Object {
        $PSItem.Name -Match $ExerciseSheetRegex
    }

    # Filter exercise numbers
    If ($ExerciseNumber.Length) {
        $ExercisePath = $ExercisePath |
            Where-Object {
            $ExerciseNumber -Contains $ExerciseSheetRegex.Match($PSItem.Name).Groups[1].Value
        }
    }

    # Return (filtered) path(s) or null
    If ($ExercisePath) {
        If ($Newest) {
            $BiggestNumber = 0
            $BiggestNumberIndex = 0

            For ($I = 0; $I -Lt $ExercisePath.Length; $I++) {
                $CurrentNumber = [Int] $ExerciseSheetRegex.Match($ExercisePath[$I]).Groups[1].Value

                If ($CurrentNumber -Gt $BiggestNumber) {
                    $BiggestNumber = $CurrentNumber
                    $BiggestNumberIndex = $I
                }
            }

            Return $ExercisePath[$BiggestNumberIndex]
        } Else {
            Return $ExercisePath
        }
    } Else {
        Return $Null
    }
}

<#
    .SYNOPSIS
    Create new PLM-Jar archives.

    .DESCRIPTION
    The "New-PlmJar" cmdlet retrieves exercise folder paths and creates a jar file, containing the folder's contents, in each folder.

    .PARAMETER ExerciseRootPath
    The path to the directory that contains the exercise folders.

    .PARAMETER ExerciseNumber
    The exercise numbers for which jar files are to be generated.

    .PARAMETER All
    Whether to create jar files for all exercise folders.
    Default is to generate a jar only for the newest folder / the folder with the highest exercise number.

    .PARAMETER NoNote
    Whether to exclude a note regarding this tool in the jar.

    .PARAMETER Exclude
    A list of file extensions to exclude when packing the jar.

    .PARAMETER MatriculationNumber
    The user's matriculation number.

    .EXAMPLE
    New-PlmJar -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen"

    .LINK
    https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/New-PlmJar.md
#>
Function New-PlmJar {
    [CmdletBinding(DefaultParametersetName = "Newest")]

    Param (
        [Parameter(Mandatory = $True)]
        [ValidateScript({Test-Path -Path $PSItem})]
        [String] $ExerciseRootPath,

        [Parameter(
            ParameterSetName = "ExerciseNumber",
            Mandatory = $True
        )]
        [ValidateNotNullOrEmpty()]
        [Int[]] $ExerciseNumber,

        [Parameter(
            ParameterSetName = "All",
            Mandatory = $True
        )]
        [Switch] $All,

        [Switch] $NoNote,

        [ValidateNotNull()]
        [String[]] $Exclude = @(".*\.class", ".*\.eml", ".*\.iml", ".*\.jar", ".*\.odt", ".*\.odg", ".*\.ods", ".*\.old", "[^\\]+\\\.idea\\.*", ".*\\In\.java", "[^\\]+\\out\\.*", ".*\\Out\.java"),

        [ValidateNotNullOrEmpty()]
        [Int] $MatriculationNumber
    )

    # Get the exercise folders in scope
    $ExercisePaths = $Null

    Switch ($PSCmdlet.ParameterSetName) {
        "ExerciseNumber" {
            $ExercisePaths = Get-ExerciseFolder -ExerciseRootPath $ExerciseRootPath -ExerciseNumber $ExerciseNumber
            Break
        }
        "All" {
            $ExercisePaths = Get-ExerciseFolder -ExerciseRootPath $ExerciseRootPath
            Break
        }
        "Newest" {
            $ExercisePaths = Get-ExerciseFolder -ExerciseRootPath $ExerciseRootPath -Newest
            Break
        }
    }

    # Create the jar file(s)
    ForEach ($ExercisePath In $ExercisePaths) {
        $NoteFilePath = Get-PlmJarBuilderVariable -Name "NoteFilePath"
        $ExerciseSheetRegex = [Regex] (Get-PlmJarBuilderConfigProperty -PropertyName "ExerciseSheetRegex").ExerciseSheetRegex
        $ExerciseNumberFormat = [String] (Get-PlmJarBuilderVariable -Name "ExerciseNumberFormat")
        $ExerciseNumberZeroed = ([Int] $ExerciseSheetRegex.Match($ExercisePath.Name).Groups[1].Value).ToString($ExerciseNumberFormat)
        $SolutionPath = (Get-PlmJarBuilderConfigProperty -PropertyName "SolutionPath").SolutionPath
        $SolutionPathAbsolute = "$($ExercisePath.FullName)\$SolutionPath"

        If (-Not (Test-Path $SolutionPathAbsolute)) {
            # Solution path does not exist
            Throw "Solution path does not exist!"
        }

        $Files = @(
            Get-ChildItem -Path "$SolutionPathAbsolute" -Recurse -File |
                Where-Object {
                $FullNameDiff = $PSItem.FullName.TrimStart($SolutionPathAbsolute)

                For ($I = 0; $I -Lt $Exclude.Count; $I++) {
                    If ($PSItem.FullName -Match $Exclude[$I]) {
                        Return $False
                    }
                }

                Return $True
            }
        )

        # Add an optional note
        If (-Not $NoNote) {
            $Files += Get-Item -Path $NoteFilePath
        }

        # Create the jar command
        $FileString = $Null

        ForEach ($File In $Files) {
            $IsSolutionPathSubdirectory = ($File.DirectoryName).StartsWith($SolutionPathAbsolute)
            If ($IsSolutionPathSubdirectory) {
                $RelativeFilePath = ($File.FullName).Replace("$SolutionPathAbsolute\", "")
                $FileString += " -C `"$SolutionPathAbsolute`" `"$RelativeFilePath`""
            } Else {
                $FileString += " -C `"$($File.DirectoryName)`" `"$($File.Name)`""
            }
        }

        $JarName = $Null

        If ($MatriculationNumber) {
            $JarName = "${MatriculationNumber}_$ExerciseNumberZeroed.jar"
        } Else {
            $JarName = "Lösung_$ExerciseNumberZeroed.jar"
        }

        $JarFullName = "$SolutionPathAbsolute\$JarName"

        Write-Verbose "Executing `"jar cvf`""
        Invoke-Expression "jar cvfM `"$JarFullName`"$FileString"
    }
}

Export-ModuleMember -Function *
