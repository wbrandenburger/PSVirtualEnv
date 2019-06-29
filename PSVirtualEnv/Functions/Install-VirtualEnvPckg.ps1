# ==============================================================================
#   Install-VirtualEnvPckg.ps1 -------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------

function Install-VirtualEnvPckg {

    <#
    .SYNOPSIS
        Download packages of a specified virtual environment.

    .DESCRIPTION
        Download packages of a specified virtual environment to a predefined local directory.
    
    .PARAMETER Name

    .PARAMETER All

    .EXAMPLE
        Get-VirtualEnvLocal -Name venv

        SUCCESS: Packages of virtual environment 'venv' were downloaded to 'A:\VirtualEnv\.temp\venv'.

        -----------
        Description
        Download all packages of the virtual environment 'venv' to a predefined download directory.

    .INPUTS
        System.String. Name of the virtual environment, which packages shall be downloaded.

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
        [System.String] $Requirement
    )
    
    Process {

        if ($Requirement){
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

        if ($Name) {  Get-VirtualEnv -Name $Name }
        else { Get-VirtualEnv } 
    }
}