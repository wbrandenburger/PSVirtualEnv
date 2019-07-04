# ==============================================================================
#   PSVirtualEnv.Tests.Prep.ps1 ------------------------------------------------
# ==============================================================================

#   settings -------------------------------------------------------------------
# ------------------------------------------------------------------------------

#   powershell module ----------------------------------------------------------
# ------------------------------------------------------------------------------

    # install necessary powershell modules
    if (Get-Module -ListAvailable -Name PSIni) {
        Write-Host "SUCCESS: Module PSIni exists" -ForegroundColor Green
    } 
    else {
        Write-Host "ERROR: Module does not exist" -ForegroundColor Red
        Install-Module PSIni -Force -Verbose
    }

#   python distribution --------------------------------------------------------
# ------------------------------------------------------------------------------
    # get module name and directory
    $Script:moduleName = "PSVirtualEnv"
    $Script:moduleDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

    # check existing python distribution
    Write-Host "PROCESS: Check existing python distribution." -ForegroundColor Yellow

    $Script:pythonDir = $Env:PYTHONHOME
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

#   test environment -----------------------------------------------------------
# ------------------------------------------------------------------------------

    $Script:testWorkDir = "A:\Tests\PSVirtualEnv"
    if (-not (Test-Path -Path $Script:testWorkDir)) {
        New-Item -Path $Script:testWorkDir -ItemType Directory
    }

    $Script:testWorkSubDir = Get-ChildItem -Path $Script:testWorkDir -Directory

    @(
        "venv-1", "venv-2", "venv-3"
    ) | ForEach-Object {
        $Script:testEnvDir = Join-Path -Path $Script:testWorkDir -ChildPath $_

        if (-not (Test-Path -Path  (Join-Path -Path $Script:testEnvDir -ChildPath "Scripts\python.exe"))) {
            Remove-Item -Path $Script:testEnvDir -Recurse
        }
        if (-not (Test-Path -Path $Script:testEnvDir)) {
            Write-Host "PROCESS: Creating the virtual environment '$_'." -ForegroundColor Yellow
            . $Script:python -m virtualenv $Script:testEnvDir --verbose
        }
        
        Write-Host "SUCCESS: Virtual environment '$_' exists." -ForegroundColor Green
    }

#   packages of test environment -----------------------------------------------
# ------------------------------------------------------------------------------
    $Script:Package = @( 
        'Click-7.0-py2.py3-none-any.whl'
        'cycler-0.10.0-py2.py3-none-any.whl'
        'kiwisolver-1.1.0-cp37-none-win_amd64.whl'
        'matplotlib-3.1.0-cp37-cp37m-win_amd64.whl'
        'numpy-1.16.4-cp37-cp37m-win_amd64.whl'
        'pyparsing-2.4.0-py2.py3-none-any.whl'
        'python_dateutil-2.8.0-py2.py3-none-any.whl'
        'setuptools-41.0.1-py2.py3-none-any.whl'
        'six-1.12.0-py2.py3-none-any.whl'
    )