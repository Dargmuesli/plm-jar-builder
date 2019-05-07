Set-StrictMode -Version Latest

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath ".." | Join-Path -ChildPath ".." | Join-Path -ChildPath "PLM-Jar-Builder" | Join-Path -ChildPath "PLM-Jar-Builder.psd1") -Force

Describe "PLM-Jar-Builder" {
    $NestedModules = (Get-Module PLM-Jar-Builder).NestedModules

    ForEach ($NestedModule In $NestedModules) {
        Context $NestedModule {
            $ModuleFileContent = $Null
            $ModuleFunctionNames = $Null
            $ModuleFunctionNamesSorted = $Null

            Import-Module -Name $NestedModule.Path -Force

            $ModuleFileContent = Get-Content -Path $NestedModule.Path -Raw
            $ModuleFunctionNames = [Object[]] (Read-FunctionNames -InputString $ModuleFileContent)
            $ModuleFunctionNamesSorted = [Object[]] ($ModuleFunctionNames | Sort-Object)

            It "contains functions in alphabetical order" {
                $ModuleFunctionNames = $ModuleFunctionNames
                $ModuleFunctionNamesSorted = $ModuleFunctionNamesSorted

                For ($I = 0; $I -Lt $ModuleFunctionNames.Length; $I++) {
                    $ModuleFunctionNamesSorted.Get_Item($I) | Should Be $ModuleFunctionNames.Get_Item($I)
                }
            }

            ForEach ($ModuleFunctionName In $ModuleFunctionNamesSorted) {
                $ModuleFunctionsHelp = Get-Help -Name $ModuleFunctionName -Full

                It "has a correct `".LINK`" for function $($ModuleFunctionsHelp.Name)" {
                    Test-PropertyExists -Object $ModuleFunctionsHelp -PropertyName "relatedLinks.navigationLink.uri" |
                        Should Be $True

                    $ModuleFunctionsHelp.relatedLinks.navigationLink.uri |
                        Should Match "^https:\/\/github\.com\/Dargmuesli\/plm-jar-builder\/blob\/master\/PLM-Jar-Builder\/Docs\/$($ModuleFunctionsHelp.Name)\.md$"
                }
            }
        }
    }
}
