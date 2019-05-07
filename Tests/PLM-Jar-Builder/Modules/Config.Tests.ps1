Set-StrictMode -Version Latest

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath ".." | Join-Path -ChildPath ".." | Join-Path -ChildPath ".." | Join-Path -ChildPath "PLM-Jar-Builder" | Join-Path -ChildPath "PLM-Jar-Builder.psd1") -Force
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath ".." | Join-Path -ChildPath ".." | Join-Path -ChildPath ".." | Join-Path -ChildPath "PLM-Jar-Builder" | Join-Path -ChildPath "Modules" | Join-Path -ChildPath "Config.psm1") -Force

$ConfigFilePath = "TestDrive:\config.json"

Describe "Get-PlmJarBuilderVariable" {
    It "returns a variable's value" {
        # Parameters: "Name"
        $PlmJarBuilderVariable = Get-PlmJarBuilderVariable -Name "ModuleName"
        $PlmJarBuilderVariable | Should Be "PLM-Jar-Builder"

        # Parameters: "ListAvailable"
        $PlmJarBuilderVariable = Get-PlmJarBuilderVariable -ListAvailable
        $PlmJarBuilderVariable | Should BeOfType [System.Management.Automation.PSVariable]
        $PlmJarBuilderVariable["0"].Name | Should Be "args"
    }
}

Describe "Get-PlmJarBuilderConfig" {
    Set-Content $ConfigFilePath -Value "{`"Test`":1}"

    Context "Config file exists" {
        Mock Get-PlmJarBuilderVariable {
            Return "TestDrive:\config.json"
        } -ModuleName "Config"

        It "returns the config json" {
            # Parameters: None
            $PlmJarConfig = Get-PlmJarBuilderConfig
            $PlmJarConfig | Should BeOfType [PSCustomObject]
            $PlmJarConfig.Test | Should Be 1
        }
    }

    Context "Config file does not exists" {
        Mock Get-PlmJarBuilderVariable {
            Return "TestDrive:\doesnotexist.json"
        } -ModuleName "Config"

        It "returns null" {
            # Parameters: None
            Get-PlmJarBuilderConfig | Should Be $Null
        }
    }
}

Describe "Get-PlmJarBuilderConfigPropertyPath" {
    It "returns the config json" {
        # Parameters: PropertyName
        Get-PlmJarBuilderConfigPropertyPath -PropertyName "MatriculationNumber" | Should Be "Custom.User.Matriculationnumber"
    }
}

Describe "Get-PlmJarBuilderConfigProperty" {
    Mock Get-PlmJarBuilderVariable {
        Return "TestDrive:\config.json"
    } -ModuleName "Config"

    Mock Get-PlmJarBuilderConfig {
        Return "{`"Test`":1,`"ABC`":{`"Test`":1}}" | ConvertFrom-Json
    } -ModuleName "Config"

    Set-Content $ConfigFilePath -Value "{`"Test`":1,`"ABC`":{`"Test`"=1}}"

    Context "Property exists" {
        Mock Get-PlmJarBuilderConfigPropertyPath {
            Return "ABC.Test"
        } -ModuleName "Config"

        It "returns the property" {
            # Parameters: "PropertyName"
            $PlmJarConfigProperty = (Get-PlmJarBuilderConfigProperty -PropertyName "Test")
            $PlmJarConfigProperty | ConvertTo-Json | Should Be (@{"Test" = 1 } | ConvertTo-Json)

            # Parameters: "PropertyPath"
            $PlmJarConfigProperty = Get-PlmJarBuilderConfigProperty -PropertyPath "ABC.Test"
            $PlmJarConfigProperty | ConvertTo-Json | Should Be (@{"Test" = 1 } | ConvertTo-Json)
        }
    }

    Context "Property does not exists" {
        It "returns null" {
            # Parameters: "PropertyName"
            (Get-PlmJarBuilderConfigProperty -PropertyName "doesnotexist") | Should Be $Null

            # Parameters: "PropertyPath"
            Get-PlmJarBuilderConfigProperty -PropertyPath "does.not.exist" | Should Be $Null
        }
    }
}
