# ==============================================================================
#   PSVirtualEnv.Tests.Prep.ps1 ------------------------------------------------
# ==============================================================================

#   settings -------------------------------------------------------------------
# ------------------------------------------------------------------------------

#   python distribution --------------------------------------------------------
# ------------------------------------------------------------------------------
    # get module name and directory
    $Script:moduleName = "PSVirtualEnv"
    $Script:moduleDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

    # check existing python distribution
    Write-Host "PROCESS: Check existing python distribution." -ForegroundColor Yellow

    $Script:pythonDir = $Env:PYTHONTEMP
    if (-not  $Script:pythonDir -or -not (Test-Path -Path  $Script:pythonDir)){
        Write-Host "ERROR: Please set environment variable 'PYTHONHOME' to existing python distribution (Python>3 is recommended)." -ForegroundColor Red
        exit
    }

    $Script:python = Join-Path -Path $Script:pythonDir -ChildPath "python.exe"
    if (-not (Test-Path -Path  $Script:python)){
        Write-Host "ERROR: The python distribution seems to be corrupted, 'python.exe' was not found in python directory." -ForegroundColor Red
        exit
    }

    Write-Host "SUCCESS: Python distribution detected: '$Script:python'." -ForegroundColor Green

#   package virtualenv ---------------------------------------------------------
# ------------------------------------------------------------------------------

    # check whether package virtualenv exists in system pathon distribution
    function Test-VirtualEnv {
        $pythonPckg = . $Script:python -m pip list
        if (-not ($pythonPckg  -match "virtualenv\s")) {
            Write-Host "ERROR: Package virtualenv can not be found." -ForegroundColor Red

            $choices  = "&Yes", "&No"
            if ($Host.UI.PromptForChoice($Null, "Install package virtualenv from local?", $choices, 1) -eq 0) { 
                Write-Host "PROCESS: Installation of package virtualenv." -ForegroundColor Yellow
                $virtualEnvPckg = Get-ChildItem -Path (Join-Path -Path $moduleDir -ChildPath "Binaries\virtualenv") -Filter "*.whl" -File

                . $Script:python -m pip install (Join-Path -Path $moduleDir -ChildPath "Binaries\virtualenv\$virtualEnvPckg")
                
                Test-VirtualEnv
            } 
            else { exit }        
        }

        Write-Host "SUCCESS: Pckg virtualenv detected." -ForegroundColor Green
    }
    
    Test-VirtualEnv