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

        SUCCESS: Virtual enviroment 'venv' was started.

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

        # check whether the specified virtual environment exists
        if (-not (Test-VirtualEnv -Name $Name -Verbose)){
            Get-VirtualEnv
            return
        }

        # deactivation of a running virtual environment
        if (Get-ActiveVirtualEnv) {
            Stop-VirtualEnv
        }

        # get the full path of the specified virtual environment, which is located in the predefined system path and activate the virtual environment
        . (Get-VirtualEnvActivationScript -Name $Name)
        Write-FormatedSuccess -Message "Virtual enviroment '$Name' was started." -Space
        
        # set environment variable

            # set a backup of the pythonhome environment variable
            [System.Environment]::SetEnvironmentVariable("VIRTUAL_ENV_PYTHONHOME",  [System.Environment]::GetEnvironmentVariable("PYTHONHOME", "process"), "process")
            # set the pythonhome variable in scope process to the path of the virtual environment
            [System.Environment]::SetEnvironmentVariable("PYTHONHOME", (Get-VirtualEnvPath -Name $Name), "process")
            #set the name of the virtual environment
            [System.Environment]::SetEnvironmentVariable("VIRTUAL_ENV", $Name ,"process")
        return
    }
}
