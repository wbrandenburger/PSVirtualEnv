# ==============================================================================
#   Install-VirtualEnvPckg.ps1 -------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------

function Install-VirtualEnvPckg {

    <#
    .SYNOPSIS

    .DESCRIPTION
        
    
    .PARAMETER Name

    .PARAMETER All

    .EXAMPLE
        PS> Install-VirtualEnvPckg -Name venv

        -----------
        Description
       
    .INPUTS
        None.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param (
        [Parameter(ValueFromPipeline=$True, HelpMessage="Name of the virtual environment to be changed.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If switch 'All' is true, all existing virtual environments will be changed.")]
        [Switch] $All,

        [Parameter(HelpMessage="Path to a requirements file, or name of a virtual environment.")]
        [System.String] $Requirement,

        [Parameter(HelpMessage="If switch 'Offline' is true, the virtual environment will be created without download packages.")]
        [Switch] $Offline
    )
    
    Process {
        # get existing requirement file 
        if ($Offline -and $Requirement)
        {   
            if (Test-Path -Path $Requirement ){
                $requirementFile = $Requirement
                
                $hostPath = Get-Location
                Set-Location -Path (Split-Path -Path $requirementFile -Parent)
            }
            else {
                Write-FormatedError -Message "There can not be found a existing requirement file." -Space
                return
            }
        }
        if (-not $Offline -and $Requirement){
            $requirementFile = Get-VirtualEnvRequirementFile -Name $Requirement
            if (-not (Test-VirtualEnvRequirementFile -Name $requirementFile)) {
                Write-FormatedError -Message "There can not be found a existing requirement file." -Space
                return
            }
        }

        # Get all existing virtual environments if 'Name' is not set
        $virtualEnv = @{ Name = $Name }
        if ($All -or -not $virtualEnv) {
            $virtualEnv = Get-VirtualEnv
        }

        $virtualEnvIdx = 1
        $virtualEnv | ForEach-Object {

            # check whether the specified virtual environment exists
            if (-not(Test-VirtualEnv -Name $_.Name)){
                Write-FormatedError -Message "The virtual environment '$($_.Name)' does not exist." -Space
                Get-VirtualEnv

                return
            }
            
            # get existing requirement file 
            if (-not $Requirement) {
                $Requirement = $_.Name
                $Upgrade = $True

                Get-VirtualEnvRequirement -Name $_.Name -Upgrade
            }

            # install packages from the requirement file
            Install-PythonPckg -EnvExe (Get-VirtualEnvExe -Name $_.Name) -Requirement $requirementFile -Upgrade:$Upgrade

            if ($Upgrade) {
                Get-VirtualEnvRequirement -Name $_.Name
            }

            $virtualEnvIdx += 1
        }

        if ($Offline) {
            Set-Location -Path $hostPath
        }

        if ($Name) {  Get-VirtualEnv -Name $Name }
        else { Get-VirtualEnv } 
    }
}


#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Install-PythonPckg {

    <#
    .DESCRIPTION
        Gets the properties of all packages in a python environment.
    
    .PARAMETER EnvExe

    .PARAMETER Requirement

    .OUTPUTS
        PSCustomObject. Properties of all packages in a python environment
    #>

    
    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([PSCustomObject])]

    Param (
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Executable of a python distribution.")]
        [System.String] $EnvExe,

        [Parameter(Position=2, Mandatory=$True, HelpMessage="Path to a requirements file.")]
        [System.String] $Requirement,

        [Parameter(HelpMessage="If switch 'Upgrade' is true the package will be upgraded.")]
        [Switch] $Upgrade
    )

    $UpgradeCmd = ""
    if ($Upgrade) {
        $UpgradeCmd = "--upgrade"
    }

    # install packages from a requirement file
    Write-FormatedMessage -Message "Install missing packages from requirement file '$Requirement'." -Color Yellow

    . $EnvExe -m pip install --requirement $Requirement $UpgradeCmd

    Write-FormatedSuccess -Message "Packages from requirement file '$Requirement' were installed."
}
