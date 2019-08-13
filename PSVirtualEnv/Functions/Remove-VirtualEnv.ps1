# ==============================================================================
#   Remove-VirtualEnv.ps1 ------------------------------------------------------
# ==============================================================================

#   Class ----------------------------------------------------------------------
# ------------------------------------------------------------------------------
Class ValidateVirtualEnv : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (Get-VirtualEnv | Select-Object -ExpandProperty Name)
    }
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Remove-VirtualEnv  {

    <#
    .SYNOPSIS
        Removes a specific virtual environment.

    .DESCRIPTION
        Removes a specific virtual environment in the predefined system directory.

    .PARAMETER Name

    .EXAMPLE
        PS C:\> Remove-VirtualEnv -Name venv
        
        SUCCESS: Virtual enviroment 'venv' was deleted permanently.

        -----------
        Description
        Removes the specified virtual environment 'venv'

    .INPUTS
        System.String. Name of virtual environment, which should be removed.
    
    .OUTPUTS
        None.
    #>

    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="None", PositionalBinding=$True)]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateVirtualEnvMandatory])]
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of virtual environment, which should be removed.")]
        [System.String] $Name
    )

    Process{
        
        # check whether the specified virtual environment exists
        if (-not (Test-VirtualEnv -Name $Name -Verbose)){
            Get-VirtualEnv
            return
        }

        # deactivation of a running virtual environment
        if (Get-ActiveVirtualEnv -Name $Name) {
            Deactivate
        }

        # get the full path of the specified virtual environment, which is located in the predefined system path
        $virtualEnvDir = Get-VirtualEnvPath -Name $Name
        
        # remove specified virtual environment
        Remove-Item -Path $virtualEnvDir -Recurse
        
        # check whether the virtual environment could be removed
        if (-not (Test-Path -Path $virtualEnvDir)) {
            Write-FormatedSuccess -Message "Virtual Environment '$Name' was deleted permanently." -Space
        }
        else {
            Write-FormatedError -Message "Virtual environment '$Name' could not be deleted." -Space
        }

        Get-ChildItem -Path $PSVirtualEnv.WorkDir -Exclude "*.*" -Directory

    }
}
