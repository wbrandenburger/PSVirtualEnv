# ===========================================================================
#   Stop-VirtualEnv.ps1 -----------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Stop-VirtualEnv {

    <#
    .SYNOPSIS
        Stops current running  virtual environment.

    .DESCRIPTION
        Stops current running virtual environment.

    .PARAMETER Silent
    
    .EXAMPLE
        [venv] PS C:\> Stop-VirtualEnv

        [PSVirtualEnv]::SUCCESS: Virtual enviroment 'venv' was stopped.

        PS C:\>

        -----------
        Description
        Stops current virtual environment. 

    .EXAMPLE
        [venv] PS C:\> Stop-venv

        SUCCESS: Virtual enviroment 'venv' was stopped.

        PS C:\>
        
        -----------
        Description
        Stops current virtual environment with predefined alias of command.

    .INPUTS
        None.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    Process { 

        # get a running environment
        $old_venv = Get-ActiveVirtualEnv
        if (-not $old_venv){
            if (-not $Silent) {
                Write-FormattedSuccess -Message "There is no running virtual enviroment ." -Module $PSVirtualEnv.Name -Space
            }
        }

        # deactivation of a running virtual environment
        Restore-VirtualEnv

        # if the environment variable is not empty, deavtivation failed
        if ($old_venv -eq $(Get-ActiveVirtualEnv)) {
            if (-not $Silent) {
                Write-FormattedSuccess -Message "Virtual enviroment '$virtual_env' was stopped." -Module $PSVirtualEnv.Name -Space
            }
        }
    }
}
