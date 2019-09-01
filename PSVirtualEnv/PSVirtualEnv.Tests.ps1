# ===========================================================================
#   PSVirtualEnv.Tests.ps1 -----------------------------------------------------
# ===========================================================================
#   dependencies ---------------------------------------------------------------
# ---------------------------------------------------------------------------

#   settings -------------------------------------------------------------------
# ---------------------------------------------------------------------------
    
    # get module name and directory
    $Script:moduleName = "PSVirtualEnv"
    $Script:moduleDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
    
    # set test flag
    $Env:PSVirtualEnv = 1

    # execute file with the specific module settings
    . (Join-Path -Path $Script:moduleDir -ChildPath ($Script:moduleName + ".Module.ps1"))

    # load essential functions
    . $ModuleVar.FunctionsFile

#   test environment -----------------------------------------------------------
# ---------------------------------------------------------------------------

#   module test ----------------------------------------------------------------
# ---------------------------------------------------------------------------

    # test general settings of module
    Describe -Tags 'ModuleSettings' "$Script:moduleName manifest" {
        It "has a valid module name" {
            Test-Path -Path $ModuleVar.Name | Should Not BeNullOrEmpty
        }
        
        It "has a valid directory" {
            {
                Test-Path -Path $ModuleVar.ModuleDir 
            } | Should Not Throw
        }

        It "has a valid function directory" {
            {
                Test-Path -Path $ModuleVar.FunctionsDir
            } | Should Not Throw
        }

        It "has a valid test directory" {
            {
                Test-Path -Path $ModuleVar.TestsDir
            } | Should Not Throw
        }

        It "has a valid configuration file" {
            {
                Test-Path -Path $ModuleVar.ConfigFile 
            } | Should Not Throw
        }

        It "has a valid module scrip" {
            {
                Test-Path -Path $ModuleVar.ModuleFile 
            } | Should Not Throw
        }

        It "has a valid functions script" {
            {
                Test-Path -Path $ModuleVar.FunctionsFile 
            } | Should Not Throw
        }

    }

#   tests ----------------------------------------------------------------------
# ---------------------------------------------------------------------------

    # invoke all scripts below listed with pester
    Get-ChildItem -Path $ModuleVar.TestsDir -Filter "*.ps1" | ForEach-Object {
        Invoke-Pester -Script  $_.FullName
    }

#   end of tests ---------------------------------------------------------------
# ---------------------------------------------------------------------------
    $Env:PSVirtualEnv = $Null
