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
    )

    Process {

        $Name =  $Env:VIRTUAL_ENV

        # deactivation of a running virtual environment and create the requirement file 
        if (Get-ActiveVirtualEnv -Name $Name ) {
            . $PSVirtualEnv.Deactivation
            $Env:VIRTUAL_ENV = $Null
            Get-VirtualEnvRequirement $Name

            Write-FormatedSuccess -Message "Virtual enviroment '$Name' was stopped." -Space
        }
        else {
            Write-FormatedError -Message "There is no running virtual environment." -Space
        }
        
        return
    }
}
