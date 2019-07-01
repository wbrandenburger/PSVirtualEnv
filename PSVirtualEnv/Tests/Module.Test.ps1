# ==============================================================================
#   Module.Test.ps1 ------------------------------------------------------------
# ==============================================================================

#   test -----------------------------------------------------------------------
# ------------------------------------------------------------------------------
Describe -Tags 'Module' "General module functionality" {

    Context "Load module $($ModuleVar.Name)" {

        # act
        Import-Module $ModuleVar.ModuleDir -Force -ErrorAction Stop

        # assert
        It "loads the module" {
            (Get-Module).name -contains $ModuleVar.Name | Should Be $true
        }

    }

    Context "Aliases of module $($ModuleVar.Name)" {
        # act
        It "Set-VirtualEnvLocation alias exists" {
            Get-Alias -Definition Set-VirtualEnvLocation | Where-Object {$_.name -eq "cdvenv"} | Measure-Object | Select-Object -ExpandProperty Count | Should Be 1
        }
        # act
        It "Copy-VirtualEnv alias exists" {
            Get-Alias -Definition Copy-VirtualEnv | Where-Object {$_.name -eq "cpvenv"} | Measure-Object | Select-Object -ExpandProperty Count | Should Be 1
        }
        # act
        It "Get-VirtualEnv alias exists" {
            Get-Alias -Definition Get-VirtualEnv | Where-Object {$_.name -eq "lsvenv"} | Measure-Object | Select-Object -ExpandProperty Count | Should Be 1
        }
        # act
        It "New-VirtualEnv alias exists" {
            Get-Alias -Definition New-VirtualEnv | Where-Object {$_.name -eq "mkvenv"} | Measure-Object | Select-Object -ExpandProperty Count | Should Be 1
        }
        # act
        It "Remove-VirtualEnv alias exists" {
            Get-Alias -Definition Remove-VirtualEnv | Where-Object {$_.name -eq "rmvenv"} | Measure-Object | Select-Object -ExpandProperty Count | Should Be 1
        }
        # act
        It "Start-VirtualEnv alias exists" {
            Get-Alias -Definition Start-VirtualEnv | Where-Object {$_.name -eq "runvenv"} | Measure-Object | Select-Object -ExpandProperty Count | Should Be 1
        }
        # act
        It "Stop-VirtualEnv alias exists" {
            Get-Alias -Definition Stop-VirtualEnv | Where-Object {$_.name -eq "stvenv"} | Measure-Object | Select-Object -ExpandProperty Count | Should Be 1
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