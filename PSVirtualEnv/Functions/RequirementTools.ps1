# ==============================================================================
#   RequirementTools.ps1 -------------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Get-VirtualEnvRequirementFile {

    <#
    .DESCRIPTION
        Get the absolute path of a requirement file related to a specific virtual environment.
    
    .PARAMETER Name

    .OUTPUTS 
        System.String. Absolute path of a requirement file related to a specific virtual environment
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment or path of a requirement file.")]
        [System.String] $Name
    )

    # check whether the requirement file exists
    $requirementFile = $Name
    if (-not (Test-Path -Path $requirementFile)) {
        $requirementFile = $PSVirtualEnv.Requirement -replace $PSVirtualEnv.ReplacePattern, $Name
    }

    # replace the predefined patter
    return $requirementFile
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Get-VirtualEnvRequirement {

    <#
    .DESCRIPTION
        Create the requirement file of a specific virtual environment.
    
    .PARAMETER Name

    .PARAMETER All

    .PARAMETER Upgrade

    .OUTPUTS
        None.
    #>

    [CmdletBinding()]

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Name of the virtual environment.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If switch 'All' is true, the requirement file for all existing virtual environments will be generated.")]
        [Switch] $All,

        [Parameter(HelpMessage="If switch 'Upgrade' is true the package will be upgraded.")]
        [Switch] $Upgrade
    )

    # Get all existing virtual environments if 'Name' is not set
    $virtualEnv = @{ Name = $Name }
    if ($All -or -not $Name) {
        $virtualEnv = Get-VirtualEnv
    }

    $virtualEnvIdx = 1
    $virtualEnv | ForEach-Object {
        #  check if there exists a specific virtual environment
        if (-not (Test-VirtualEnv -Name $_.Name -Verbose)) {
            return
        }

        # create the requirement file of the specified virtual environment
        Write-FormatedMessage -Message "Create requirement file for virtual environment '$($_.Name)'" -Color "Yellow"
        . (Get-VirtualEnvExe -Name $_.Name) -m pip freeze > (Get-VirtualEnvRequirementFile -Name $_.Name)
            Write-FormatedSuccess -Message "Requirement file for virtual environment '$($_.Name)' was created."
        
        if ($Upgrade){
            (Get-Content (Get-VirtualEnvRequirementFile -Name $_.Name)) -replace "==", ">=" | Out-File -FilePath (Get-VirtualEnvRequirementFile -Name $_.Name)
        }

        $virtualEnvIdx += 1
    }
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Remove-VirtualEnvRequirement {

    <#
    .DESCRIPTION
        Remove the requirement file related to a specific virtual environment.
    
    .PARAMETER Name

    .OUTPUTS
        None.
    #>

    [OutputType([Void])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    # get, check and remove the requirement file
    $requirementFile = Get-VirtualEnvRequirementFile -Name $Name
    if (Test-VirtualEnvRequirementFile -Name $Name -Verbose){
        Remove-Item -Path $requirementFile

        Write-FormatedSuccess -Message "Requirement file of virtual environment '$Name' was removed."
    }

    return $Null
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Test-VirtualEnvRequirementFile {

    <#
    .DESCRIPTION
        Checks if there exists a specific requirement file.
    
    .PARAMETER Name

    .OUTPUTS 
        Boolean. True if the specified requirement file exists.
    #>

    [OutputType([Boolean])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment or path of a requirement file.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If switch 'VirtualEnv is true, an corresponding virtual Environment will be checked.")]
        [Switch] $VirtualEnv
    )
    
    # check whether the requirement file exists
    $requirementFile = Get-VirtualEnvRequirementFile -Name $Name
    if (-not (Test-Path -Path $requirementFile)) {
        if ($VerbosePreference) {
            Write-FormatedError -Message "Unable to find the requirement file of the virtual environment '$Name'." -Space
        }
        return $False
    }
    else {
        $Name = [System.IO.Path]::GetFileNameWithoutExtension($requirementFile)
    }
    
    # check whether the requirement file can be bound to an existing virtual environment
    if ($VirtualEnv) {
        if (-not (Test-VirtualEnv -Name $Name -Inverse)){
            return $False
        }
    }

    return $True
}