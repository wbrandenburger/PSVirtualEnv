# ==============================================================================
#   PSVirtualEnv.psm1 ----------------------------------------------------------
# ==============================================================================

#
# Python virtual environment manager inspired by VirtualEnvWrapper
#
# Copyright (c) 2017 Regis Floret
# Copyright (c) 2019 Wolfgang Brandenburger
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

#   settings -------------------------------------------------------------------
# ------------------------------------------------------------------------------
    $PSVIRTUALENV = "PSVirtualEnv"

    # get directory of the module and generate the directory with the function to be loaded
    $PSVirtualEnvHome = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

    # get the path of the config file with the module settings
    $PSVirtualEnvConfig = Join-Path -Path $PSVirtualEnvHome -ChildPath $PSVIRTUALENV 

    $PSVirtualEnvConfig = Get-IniContent -FilePath (Join-Path -Path $PSVirtualEnvHome -ChildPath ("$PSVIRTUALENV" + ".ini") ) 

    # set the default path where virtual environments are located
    $VENVDIR = $PSVirtualEnvConfig["directories"]["venv-dir"]
    if (-not $VENVDIR) {
        Write-Host "The path of the directory vor virtual envrionments are not given." -ForegroundColor Red
        return
    }
    if (-not (Test-Path $VENVDIR)) {
        mkdir $VENVDIR
    }

    $VENVCONFIGDIR = Join-Path -Path $VENVDIR -ChildPath $PSVirtualEnvConfig["directories"]["venv-config-dir"]
    if (-not (Test-Path $VENVCONFIGDIR)) {
        mkdir $VENVDIR
    }

    $VENVLOCALDIR = Join-Path -Path $VENVDIR -ChildPath $PSVirtualEnvConfig["directories"]["venv-local-dir"]
    if (-not (Test-Path $VENVLOCALDIR)) {
        mkdir $VENVDIR
    }

    # set the default python distribution, virtual environment executable and 
    $PYTHONEXE = $PSVirtualEnvConfig["files"]["python-exe"]
    $VENVEXE = $PSVirtualEnvConfig["files"]["venv-exe"]
    $VENVACTIVATION = $PSVirtualEnvConfig["files"]["venv-activation"]
    $VENVDEACTIVATION = $PSVirtualEnvConfig["files"]["venv-deactivation"]
    $VENVREQUIREMENT = Join-Path -Path $VENVLOCALDIR -ChildPath $PSVirtualEnvConfig["files"]["venv-requirement"]

    # set the default virtual environment package manager
    $VIRTUALENVPCKG = $PSVirtualEnvConfig["settings"]["venv-pckg"]

    # define the replace patter
    $REPLACEPATTERN = $PSVirtualEnvConfig["settings"]["replace-pattern"]
#   functions ------------------------------------------------------------------
# ------------------------------------------------------------------------------

    # get the directory with the function to be loaded
    $PSVirtualEnvFunction = Join-Path -Path $PSVirtualEnvHome -ChildPath "Functions"

    @(
        "Clear-VirtualEnvLocal.ps1"     # public function
        "Find-Python.ps1",              # public function
        "Get-VirtualEnv.ps1",           # public function
        "Get-VirtualEnvAlias.ps1",      # public function
        "Get-VirtualEnvLocal.ps1",      # public function
        "New-VirtualEnv.ps1",           # public function
        "Remove-VirtualEnv.ps1",        # public function
        "Set-VirtualEnvLocation.ps1"    # public function
        "Start-VirtualEnv.ps1",         # public function
        "Stop-VirtualEnv.ps1",          # public function
        "Test-VirtualEnv.ps1",          # public function

        "AdditionalTools.ps1",          # private set of functions 
        "PythonTools.ps1",              # private set of functions
        "RequirementTools.ps1"          # private set of functions

    ) | ForEach-Object {
        . (Join-Path -Path $PSVirtualEnvFunction -ChildPath $_)
    }

#   alias ----------------------------------------------------------------------
# ------------------------------------------------------------------------------
@(
    
    @{ Name = "cdvenv";     Value =  "Set-VirtualEnvLocation"}
    @{ Name = "lsvenv";     Value =  "Get-VirtualEnv"}
    @{ Name = "mkvenv";     Value =  "New-VirtualEnv"}
    @{ Name = "rmvenv";     Value =  "Remove-VirtualEnv"}
    @{ Name = "runvenv";    Value =  "Start-VirtualEnv"}
    @{ Name = "stvenv";     Value =  "Stop-VirtualEnv"}

) | ForEach-Object {
    Set-Alias -Name $_.Name -Value $_.Value
}
