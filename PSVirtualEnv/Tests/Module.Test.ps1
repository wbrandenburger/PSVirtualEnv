# ==============================================================================
#   Module.Test.ps1 ------------------------------------------------------------
# ==============================================================================

#   test -----------------------------------------------------------------------
# ------------------------------------------------------------------------------
Describe -Tags 'Module' "General module functionality" {

    Context "Load module $($ModuleVar.Name)" {

        # act
        Import-Module $ModuleVar.ModuleDir -Force

        # assert
        It "loads the module" {
            (Get-Module).name -contains $ModuleVar.Name | Should Be $true
        }

    }

    Context  "$($ModuleVar.Name) manifest" {
        
        # act
        $Script:manifest = $Null
        It "has a valid manifest" {
            {
                $Script:manifest = Test-ModuleManifest -Path $ModuleVar.Manifest -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should Not Throw
        }

        # assert
        It "has a valid name in the manifest" {
            $Script:manifest.Name | Should Be $ModuleVar.Name
        }

        # assert
        It "has a valid guid in the manifest" {
            $Script:manifest.Guid | Should Be '41a9e505-d878-4b65-a8bf-b90bd2f2ddf6'
        }

        # assert
        It "has a valid version in the manifest" {
            $Script:manifest.Version -as [Version] | Should Not BeNullOrEmpty
        }
    }
}