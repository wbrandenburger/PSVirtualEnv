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
  
        # deactivation of a running virtual environment
        $virtual_env = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.EnvVenv, "process")
        if (Get-ActiveVirtualEnv -Name $virtual_env ) {            
    
            # deactivate the virtual environment
            . $PSVirtualEnv.Deactivation

            # set the pythonhome variable in scope process to the stored backup variable
            Restore-VirtualEnvSystem

            # if the environment variable is not empty, deavtivation failed
            if (-not [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.EnvVenv, "process")) {
                if (-not $Silent) {
                    Write-FormattedSuccess -Message "Virtual enviroment '$virtual_env' was stopped." -Module $PSVirtualEnv.Name -Space
                }
            }
            else {
                Write-FormattedError -Message "Virtual environment '$virtual_env' could not be stopped." -Module $PSVirtualEnv.Name -Space
            }
        }
        else {
            Write-FormattedError -Message "There is no running virtual environment." -Module $PSVirtualEnv.Name -Space
        }
    }
}
