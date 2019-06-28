# ==============================================================================
#   Test-VirtualEnv.ps1 --------------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Test-VirtualEnv {

    <#
    .SYNOPSIS
        Check if there exists a specific virtual environment.

    .DESCRIPTION
        Check if there exists a specific virtual environment in the predefined system directory.

    .PARAMETER Name

    .EXAMPLE
        PS C:\> Test-VirtualEnv -Name venv

        True

        -----------
        Description
        Checks whether the virtual environment 'venv' exists.

    .INPUTS
        System.String. Name of virtual environment, which should be checked.
    
    .OUTPUTS
        Boolean. True if the specified virtual environment exists.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Boolean])]

    Param(        
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Name of virtual environment, which existence should be checked.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If Inverse is true, no error will be displayed if the specified virtual environment does not exist.")]
        [Switch] $Inverse
    )

    Process {

        # check whether a virtual environment is specified
        if (!$Name) {
            if ($VerbosePreference) {
                Write-FormatedError -Message "There is no virtual environment specified." -Space
            }
            return $False
        }

        # check if there exists the specified virtual environment in the predefined system directory
        if ( -not (Get-ChildItem $VENVDIR | Where-Object {$_.Name -eq $Name} )) {
            if ($VerbosePreference) {
                Write-FormatedError -Message "The virtual environment '$Name' does not exist." -Space
            }
            return $False
        }

        # get the full path of the specified virtual environment, which is located in the predefined system path and test the resulting path
        if ( -not (Test-Path (Get-VirtualEnvActivationScript -Name $Name) )) {
            if ($VerbosePreference) {
                Write-FormatedError -Message "Enable to find the activation script. The virtual environment '$Name' seems compromized." -Space
            }
            return $False
        }

        return $True
    }
}
