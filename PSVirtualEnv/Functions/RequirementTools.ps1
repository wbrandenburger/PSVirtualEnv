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

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    # replace the predefined patter
    return ($VENVREQUIREMENT -replace $REPLACEPATTERN, $Name)
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Get-VirtualEnvRequirement {

    <#
    .DESCRIPTION
        Create the requirement file of a specific virtual environment.
    
    .PARAMETER Name

    .PARAMETER All

    .OUTPUTS
        None.
    #>

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Name of the virtual environment.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If switch 'All' is true, the requirement file for all existing virtual environments will be generated.")]
        [Switch] $All
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
        Write-FormatedMessage -Message "Create requirement file for virtual environment '$($_.Name)' - $virtualEnvIdx of $($virtualEnv.length) packages " -Color "Yellow"
        . (Get-VirtualEnvExe -Name $_.Name) -m pip freeze > (Get-VirtualEnvRequirementFile -Name $_.Name)
            Write-FormatedSuccess -Message "Requirement file for virtual environment '$($_.Name)' was created."
        
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
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )
    
    # get and check the requirement file
    $requirementFile = Get-VirtualEnvRequirementFile -Name $Name
    if (-not (Test-Path -Path $requirementFile)){
        if ($VerbosePreference) {
            Write-FormatedError -Message "Unable to find the requirement file of the virtual environment '$Name'." -Space
        }
        return $False
    }

    return $True
}