Param (
    [Parameter(Mandatory = $False)]
    [ValidateSet('Default', 'CI', 'Install-Dependencies', 'Test-Pester', 'Clear-BuildFolders', 'New-Help', 'New-Readme')]
    [String] $Task = "Default"
)

Set-StrictMode -Version Latest

$ModuleName = "PLM-Jar-Builder"
$RequirementsPath = Join-Path -Path $PSScriptRoot -ChildPath $ModuleName | Join-Path -ChildPath "Requirements.psd1"
$PackageDependencies = @()

Function Import-RootModule {
    Param (
        [Switch] $Only
    )

    Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath $ModuleName | Join-Path -ChildPath "$ModuleName.psd1") -Force
}

Function Install-Dependencies {
    Param (
        [Switch] $Only
    )

    Write-Host "Installing dependencies..." -ForegroundColor "Cyan"

    If (-Not (Get-Module -Name "PSDepend" -ListAvailable)) {
        Install-Module -Name "PSDepend" -Scope "CurrentUser" -Force
    }

    Invoke-PSDepend -Path $RequirementsPath -Force

    If ($PackageDependencies) {
        Install-PackageOnce -Name $PackageDependencies -Destination "Packages" -Force
    }
}

Function Test-Pester {
    Param (
        [Switch] $Only
    )

    Write-Host "Running Tests..." -ForegroundColor "Cyan"
    $Pester = Invoke-Pester -PassThru

    If ($Pester.FailedCount -Gt 0) {
        Throw "$(${Pester}.FailedCount) tests failed."
    }
}

Function Clear-BuildFolders {
    Param (
        [Switch] $Only
    )

    Write-Host "Clearing build folders..." -ForegroundColor "Cyan"
    $BuildFolders = @((Join-Path -Path $ModuleName -ChildPath "Docs"), (Join-Path -Path $ModuleName -ChildPath "en-US"))

    ForEach ($BuildFolder In $BuildFolders) {
        If (-Not (Test-Path $BuildFolder)) {
            New-Item -Path $BuildFolder -ItemType "Directory" -Force
        }

        Get-ChildItem -Path (Join-Path -Path $BuildFolder -ChildPath "*") | ForEach-Object {
            Get-ChildItem -Path $PSItem
            Remove-Item -Path $PSItem
        }
    }
}

Function New-Help {
    Param (
        [Switch] $Only
    )

    If (-Not $Only) {
        Install-Dependencies
        Clear-BuildFolders
    }

    Write-Host "Generating markdown help..." -ForegroundColor "Cyan"
    New-MarkdownHelp -Module "$ModuleName" -OutputFolder (Join-Path -Path $PSScriptRoot -ChildPath $ModuleName | Join-Path -ChildPath "Docs") -Locale "en-US"
    Write-Host "Generating external help..." -ForegroundColor "Cyan"
    New-ExternalHelp -Path (Join-Path -Path $PSScriptRoot -ChildPath $ModuleName | Join-Path -ChildPath "Docs") -OutputPath (Join-Path -Path $PSScriptRoot -ChildPath $ModuleName | Join-Path -ChildPath "en-US")
}

Function New-Readme {
    Param (
        [Switch] $Only
    )

    Write-Host "Generating README..." -ForegroundColor "Cyan"
    $ReadmeRoot = Get-Content -Path (Join-Path -Path $PSScriptRoot -ChildPath "README" | Join-Path -ChildPath "root.md") -Raw -Encoding "UTF8"
    $ReadmeModules = New-ModuleMarkdown -SourcePath @(Join-Path -Path $PSScriptRoot -ChildPath $ModuleName | Join-Path -ChildPath "Modules") -DocPath "$ModuleName/Docs"
    $Readme = Join-MultiLineStrings -MultiLineStrings @($ReadmeRoot, $ReadmeModules) -Newline
    [System.IO.File]::WriteAllLines((Join-Path -Path $PSScriptRoot -ChildPath "README.md"), $Readme)
}

Switch ($Task) {
    "Default" {
        Install-Dependencies -Only
        Test-Pester -Only
        Clear-BuildFolders -Only
        Import-RootModule -Only
        New-Help -Only
        New-Readme -Only
        Break
    }
    "CI" {
        Install-Dependencies -Only
        Clear-BuildFolders -Only
        Import-RootModule -Only
        New-Help -Only
        New-Readme -Only
        Break
    }
    Default {
        Invoke-Expression -Command $Task
        Break
    }
}

Write-Host "Done!" -ForegroundColor "Green"
