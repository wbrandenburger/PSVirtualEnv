# ===========================================================================
#   Get-RequirementContent.ps1 ----------------------------------------------
# ===========================================================================

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateRequirements: 
    System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        $require_dir = [System.Environment]::GetEnvironmentVariable("VENV_REQUIRE", "process")
        return [String[]] (((Get-ChildItem -Path $require_dir -Include "*requirements.txt" -Recurse).FullName | ForEach-Object {
            $_ -replace ($require_dir -replace "\\", "\\")}) + "")
    }
}

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

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateRequirements])]
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Relative  path to a requirements file, or name of a virtual environment.")]
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
