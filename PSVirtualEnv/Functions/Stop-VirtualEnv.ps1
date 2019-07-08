# ==============================================================================
#   Stop-VirtualEnv.ps1 --------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Stop-VirtualEnv {

    <#
    .SYNOPSIS
        Stops current virtual environment.

    .DESCRIPTION
        Stops current virtual environment.

    .EXAMPLE
        PS C:\> Stop-VirtualEnv

        SUCCESS: Virtual enviroment 'venv' was stopped.

        -----------
        Description
        Stops current virtual environment.

    .INPUTS
        None.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="None", PositionalBinding=$True)]

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="If switch 'Requirement' is true, requirement file of the virtual environment to be stopped will be created.")]
        [Switch] $Requirement,

        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    Process {
  
        # deactivation of a running virtual environment and create the requirement file 
        $virtualEnvName = [System.Environment]::GetEnvironmentVariable("VIRTUAL_ENV", "process")
        if (Get-ActiveVirtualEnv -Name $virtualEnvName ) {            
            
            # create requirement file 
            if ($Requirement) {
                Get-VirtualEnvRequirement -Name $virtualEnvName
            }

            # deactivate the virtual environment
            . $PSVirtualEnv.Deactivation

            # set the pythonhome variable in scope process to the stored backup variable
            Restore-VirtualEnvSystem

            # if the environment variable is not empty, deavtivation failed
            if (-not [System.Environment]::GetEnvironmentVariable("VIRTUAL_ENV", "process")) {
                if (-not $Silent) {
                    Write-FormatedSuccess -Message "Virtual enviroment '$virtualEnvName' was stopped." -Space
                }
            }
            else {
                Write-FormatedError -Message "Virtual environment '$virtualEnvName' could not be stopped." -Space
            }
        }
        else {
            Write-FormatedError -Message "There is no running virtual environment." -Space
        }
    }
}
