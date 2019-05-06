Set-StrictMode -Version Latest

Import-Module -Name (Join-Path -Path $PSScriptRoot ".." ".." ".." "PLM-Jar-Builder" "PLM-Jar-Builder.psd1") -Force
Import-Module -Name (Join-Path -Path $PSScriptRoot ".." ".." ".." "PLM-Jar-Builder" "Modules" "JAR.psm1") -Force

Describe "Find-MatriculationNumber" {
    $CorrectPath = "TestDrive:\Correct"
    $WrongPath = "TestDrive:\Wrong"

    New-Item -Path @(
        $CorrectPath
        $WrongPath
    ) -ItemType "Directory" -Force
    Set-Content @(
        "$CorrectPath\123_01.jar"
        "$CorrectPath\123_02.jar"
        "$CorrectPath\987_01.jar"
    ) -Value ""

    Context "Matriculation numbers not available" {
        It "returns an array of matriculation numbers" {
            # Parameters: "ExerciseRootPath"
            $PlmJarConfig = Find-MatriculationNumber -ExerciseRootPath $CorrectPath
            $PlmJarConfig | Should Be @("123", "987")

            # Parameters: "ExerciseRootPath", "All"
            $PlmJarConfig = Find-MatriculationNumber -ExerciseRootPath $CorrectPath -All
            $PlmJarConfig | Should Be @("123", "123", "987")
        }
    }

    Context "Matriculation numbers available" {
        It "returns an empty array" {
            # Parameters: "ExerciseRootPath"
            $PlmJarConfig = Find-MatriculationNumber -ExerciseRootPath $WrongPath
            $PlmJarConfig | Should Be @()

            # Parameters: "ExerciseRootPath", "All"
            $PlmJarConfig = Find-MatriculationNumber -ExerciseRootPath $WrongPath -All
            $PlmJarConfig | Should Be @()
        }
    }
}

Describe "Get-ExerciseFolder" {
    $CorrectExerciseRootPath = "TestDrive:\Subfolder\CorrectExerciseRootPath"
    $WrongExerciseRootPath = "TestDrive:\Subfolder\WrongExerciseRootPath"

    New-Item -Path @(
        Join-Path -Path $CorrectExerciseRootPath "Aufgabenblatt 1"
        Join-Path -Path $CorrectExerciseRootPath "Aufgabenblatt 2"
        Join-Path -Path $CorrectExerciseRootPath "Aufgabenblatt 10"
        Join-Path -Path $CorrectExerciseRootPath "Aufgabenblatt 100"
        Join-Path -Path $CorrectExerciseRootPath "x"
        $WrongExerciseRootPath
    ) -ItemType "Directory" -Force

    Context "Exercise folders exist" {
        It "returns an array of all exercise folders" {
            # Parameters: "ExerciseRootPath"
            $ExerciseFolder = Get-ExerciseFolder -ExerciseRootPath $CorrectExerciseRootPath
            $ExerciseFolder | Should Be @("Aufgabenblatt 1", "Aufgabenblatt 10", "Aufgabenblatt 2")
        }

        It "returns an array of selected exercise folders" {
            # Parameters: "ExerciseRootPath", "ExerciseNumber"
            $ExerciseFolder = Get-ExerciseFolder -ExerciseRootPath $CorrectExerciseRootPath -ExerciseNumber @(1, 10)
            $ExerciseFolder | Should Be @("Aufgabenblatt 1", "Aufgabenblatt 10")
        }

        It "returns an the newest exercise folder" {
            # Parameters: "ExerciseRootPath"
            $ExerciseFolder = Get-ExerciseFolder -ExerciseRootPath $CorrectExerciseRootPath -Newest
            $ExerciseFolder | Should Be @("Aufgabenblatt 10")
        }
    }

    Context "Exercise folders do not exist" {
        It "returns null" {
            # Parameters: "ExerciseRootPath"
            $ExerciseFolder = Get-ExerciseFolder -ExerciseRootPath $WrongExerciseRootPath
            $ExerciseFolder | Should Be $Null

            # Parameters: "ExerciseRootPath", "ExerciseNumber"
            $ExerciseFolder = Get-ExerciseFolder -ExerciseRootPath $WrongExerciseRootPath -ExerciseNumber @(1, 10)
            $ExerciseFolder | Should Be $Null

            # Parameters: "ExerciseRootPath"
            $ExerciseFolder = Get-ExerciseFolder -ExerciseRootPath $WrongExerciseRootPath -Newest
            $ExerciseFolder | Should Be $Null
        }
    }
}
