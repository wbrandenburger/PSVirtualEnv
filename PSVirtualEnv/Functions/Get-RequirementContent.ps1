# ===========================================================================
#   Get-RequirementContent.ps1 ----------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-RequirementContent {

    <#
    .SYNOPSIS
        Get the content of a existing requirement file.

    .DESCRIPTION
        Get the content of a existing requirement file in predefined requirements folder. All available requirement files can be accessed by autocompletion.
    
    .PARAMETER Requirement

    .EXAMPLE
        PS C:\>Get-Requirement -Name venv
        PS C:\>Get-RequirementContent -Requirement \venv-requirements.txt
        Click==7.0
        PS C:\>

        -----------
        Description
        Get the content of a existing requirement file in predefined requirements folder. All available virtual environments can be accessed by autocompletion.

    .INPUTS
        System.String. Relative path of existing requirement file

    .OUTPUTS
        System.String. Content of a existing requirement file
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateRequirements])]
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Relative  path to a requirements file, or name of a virtual environment.")]
        [System.String] $Requirement=""
    )

    Process {

        # get existing requirement file 
        if ($Requirement) {   
            $requirement_file = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement
        }

        return Get-Content $requirement_file
    }
}
