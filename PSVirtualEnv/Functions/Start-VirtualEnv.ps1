# ==============================================================================
#   Start-VirtualEnv.ps1 -------------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Start-VirtualEnv {

    <#
    .SYNOPSIS
        Starts a specific virtual environment.

    .DESCRIPTION
        Starts a specific virtual environment in the predefined system directory.

    .PARAMETER Name

    .EXAMPLE
        PS C:\> Start-VirtualEnv -Name venv

        -----------
        Description
        Starts the virtual environment 'venv', which must exist in the predefined system directory.

    .INPUTS
        System.String. Name of virtual environment, which should be started.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="None", PositionalBinding=$True)]

    [OutputType([Void])]

    Param(        
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Name of virtual environment, which should be started.")]
        [System.String] $Name
    )

    Process {

        $virtualEnv = $Name

        # check whether the specified virtual environment exists
        if (-not (Test-VirtualEnv -Name $virtualEnv -Verbose)){
            Get-VirtualEnv
            return
        }

        # deactivation of a running virtual environment
        if (Get-ActiveVirtualEnv) {
            Deactivate
        }

        # get the full path of the specified virtual environment, which is located in the predefined system path
        $virtualEnvDir = Get-VirtualEnvPath -Name $virtualEnv

        # activate specified virtual environment
        $activationPath = "$virtualEnvDir\Scripts\Activate.ps1"
        . $activationPath
        Write-FormatedSuccess -Message "$virtualEnv was started." -Space
        
        $Env:OLD_PYTHON_PATH = $Env:PYTHON_PATH
        $Env:VIRTUAL_ENV = "$virtualEnvDir"

        return
    }
}

#   alias ----------------------------------------------------------------------
# ------------------------------------------------------------------------------
Set-Alias -Name runvenv -Value Start-VirtualEnv