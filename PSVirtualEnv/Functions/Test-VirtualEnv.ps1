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

        $virtualEnv = $Name
        
        # check whether a virtual environment is specified
        if (!$virtualEnv) {
            if ($VerbosePreference) {
                Write-FormatedError -Message "There is no virtual environment specified." -Space
            }
            return $False
        }

        # check if there exists the specified virtual environment in the predefined system directory
        if ( -not (Get-ChildItem $VIRTUALENVSYSTEM | Where-Object {$_.Name -eq $virtualEnv} )) {
            if ($VerbosePreference) {
                Write-FormatedError -Message "The virtual environment '$virtualEnv' does not exist." -Space
            }
            return $False
        }

        # get the full path of the specified virtual environment, which is located in the predefined system path
        $virtualEnvDir = Get-VirtualEnvPath -Name $virtualEnv

        # check whether activation script exists
        $activationPath = "$virtualEnvDir\Scripts\Activate.ps1"
        if ( -not (Test-Path $activationPath )) {
            if ($VerbosePreference) {
                Write-FormatedError -Message "Enable to find the activation script. The virtual environment '$virtualEnv' seems compromized." -Space
            }
            return $False
        }

        return $True
    }
}

#   alias ----------------------------------------------------------------------
# ------------------------------------------------------------------------------
Set-Alias -Name testvenv -Value Test-VirtualEnv