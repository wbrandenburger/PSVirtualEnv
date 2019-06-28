# ==============================================================================
#   Get-VirtualEnvLocal.ps1 ----------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Get-VirtualEnvLocal {

    <#
    .SYNOPSIS
        Download packages of a specified virtual environment.

    .DESCRIPTION
        Download packages of a specified virtual environment to a predefined local directory.
    
    .PARAMETER Name

    .EXAMPLE
        Get-VirtualEnvLocal
    .INPUTS
        System.String. Name of the virtual environment, which packages shall be downloaded.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param (
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment, which packages shall be downloaded.")]
        [System.String] $Name
    )

    # get absolute path of requirement file and download directoy
    $requirementFile = Get-VirtualEnvRequirementFile -Name $Name
    $virtualEnvLocal = Get-VirtualEnvLocalDir -Name $Name

    # check whether the requirement file exists and create the respective file if it can not be found
    if (-not (Test-Path $requirementFile)){
        Get-PckgRequirement -EnvExe (Get-VirtualEnvExe -Name $Name)  -Dest $requirementFile
    }

    # remove a previous folder, which contains download file of packages related to a older state of the virtual environment
    if (-not (Test-Path $virtualEnvLocal)){
        Remove-Item -Path $virtualEnvLocal -Recurse 
    }

    # download the packages defined in the requirement file to the specified download directory
    . (Get-VirtualEnvExe -Name $Name) -m pip download --requirement   $requirementFile --dest  $virtualEnvLocal
    Write-FormatedSuccess -Message "Packages of virtual environment '$Name' were downloaded to '$virtualEnvLocal'" -Space
}
