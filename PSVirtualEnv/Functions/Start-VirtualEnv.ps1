# ===========================================================================
#   Start-VirtualEnv.ps1 ----------------------------------------------------
# ===========================================================================

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVirtualEnv : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (Get-VirtualEnv | Select-Object -ExpandProperty Name)
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Start-VirtualEnv {

    <#
    .SYNOPSIS
        Starts a specific virtual environment.

    .DESCRIPTION
        Starts a specific virtual environment in the predefined system directory.

    .PARAMETER Name

    .PARAMETER Silent

    .EXAMPLE
        PS C:\> Start-VirtualEnv -Name venv

        SUCCESS: Virtual enviroment 'venv' was started.

        -----------
        Description
        Starts the virtual environment 'venv', which must exist in the predefined system directory.

    .INPUTS
        System.String. Name of virtual environment, which should be started.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateVirtualEnv])]     
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of virtual environment, which should be started.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    Process {

        # check whether the specified virtual environment exists
        if (-not $(Test-VirtualEnv -Name $Name -Verbose)){
            Get-VirtualEnv
            return $Null
        }

        # deactivation of a running virtual environment
        if (Get-ActiveVirtualEnv) {
            Stop-VirtualEnv -Silent:$Silent
        }

        # get the full path of the specified virtual environment, which is located in the predefined system path and activate the virtual environment
        . $(Get-VirtualEnvActivationScript -Name $Name)
        if (-not $Silent) {
            Write-FormattedSuccess -Message "Virtual enviroment '$Name' was started." -Module $PSVirtualEnv.Name -Space
        }

        # set environment variable
        Set-VirtualEnvSystem -Name $Name

        return $Null
    }
}
