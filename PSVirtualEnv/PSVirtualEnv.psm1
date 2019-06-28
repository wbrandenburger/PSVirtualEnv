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

#   settings -------------------------------------------------------------------
# ------------------------------------------------------------------------------
    $PSVIRTUALENV = "PSVirtualEnv"

    # get directory of the module and generate the directory with the function to be loaded
    $PSVirtualEnvHome = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

    # get the path of the config file with the module settings
    $PSVirtualEnvConfig = Join-Path -Path $PSVirtualEnvHome -ChildPath $PSVIRTUALENV 

    Write-Host  (Join-Path -Path $PSVirtualEnvHome -ChildPath ("$PSVIRTUALENV" + ".ini") )
    $PSVirtualEnvConfig = Get-IniContent -FilePath (Join-Path -Path $PSVirtualEnvHome -ChildPath ("$PSVIRTUALENV" + ".ini") ) 

    # set the default python distribution
    $PYTHONEXE = $PSVirtualEnvConfig["settings"]["python-exe"]

    # set the default virtual environment package manager
    $PYTHONVIRTUALENV = $PSVirtualEnvConfig["settings"]["package-virtualenv"]

    # set the default path where virtual environments are located
    $VIRTUALENVSYSTEM = $PSVirtualEnvConfig["settings"]["dir-virtualenv"]
    if (!$VIRTUALENVSYSTEM) {
        $VIRTUALENVSYSTEM = "$Env:USERPROFILE\Envs"
    }

    if ((Test-Path $VIRTUALENVSYSTEM) -eq $false) {
        mkdir $VIRTUALENVSYSTEM
    }

#   functions ------------------------------------------------------------------
# ------------------------------------------------------------------------------

    # get the directory with the function to be loaded
    $PSVirtualEnvFunction = Join-Path -Path $PSVirtualEnvHome -ChildPath "Functions"

    @(
        "Find-Python.ps1",          # public function
        "Get-VirtualEnv.ps1",       # public function
        "Get-VirtualEnvAlias.ps1",  # public function
        "New-VirtualEnv.ps1",       # public function
        "Remove-VirtualEnv.ps1",    # public function
        "Start-VirtualEnv.ps1",     # public function
        "Test-VirtualEnv.ps1",      # public function
        "AdditionalTools.ps1"       # private function
    ) | ForEach-Object {
        . (Join-Path -Path $PSVirtualEnvFunction -ChildPath $_)
    }
