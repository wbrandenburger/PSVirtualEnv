# ===========================================================================
#   Rename-VirtualEnvFile.ps1 -----------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Rename-VirtualEnvFile {

    <#
    .SYNOPSIS
        Rename an existing requirement or script file.

    .DESCRIPTION
        Rename an existing requirement or script file in predefined folder. All available requirement and script files can be accessed by autocompletion.
    
    .PARAMETER Requirement

    .PARAMETER Script

    .PARAMETER SearchDirs

    .PARAMETER NewName

    .EXAMPLE
        PS C:\> Rename-VirtualEnvFile -Requirement \general\venv-requirements.txt -Name new-venv-requirements.txt

        -----------
        Description
        Rename the requirement file in predefined folder. All available requirement files can be accessed by autocompletion.

    .EXAMPLE
        PS C:\> Rename-VirtualEnvFile -Script \general\venv.py -Name new-venv

        -----------
        Description
        Rename the script file in predefined folder. All available script files can be accessed by autocompletion.

    .EXAMPLE
        PS C:\> Rename-VirtualEnvFile -SearchDirs \path-searchdirs.txt -Name new-path

        -----------
        Description
        Rename the file with optional search directories in predefined folder. All available files can be accessed by autocompletion.

    .INPUTS
        System.String. Relative path of an existing requirement or script file.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding, DefaultParameterSetName="Config")]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateVenvRequirements])]
        [Parameter(ParameterSetName="Requirement", Position=1,  HelpMessage="Relative path to a requirements file in predefined requirements folder.")]
        [System.String] $Requirement,

        # [ValidateSet([ValidateVenvScripts])]
        # [Parameter(ParameterSetName="Script", Position=1, HelpMessage="Relative path to a script file in predefined scripts folder.")]
        # [System.String] $Script,

        [ValidateSet([ValidateVenvSearchDirs])]
        [Parameter(ParameterSetName="SearchDirs", Position=1,  HelpMessage="Relative path to existing file with additional search directories in predefined folder.")]
        [System.String] $SearchDirs,

        [Parameter(Position=2, Mandatory,  HelpMessage="New file name for requirements or script file.")]
        [System.String] $NewName
    )

    Process {

        # get existing requirement or script file

        switch ($PSCmdlet.ParameterSetName) {

            "Requirement" {
                $file_path = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement
                $new_file_path = Join-Path -Path ([REgex]::Match($file_path, "(.*)\\.*$").Groups[1].Value) -ChildPath ($NewName + "-requirements.txt")
                break;
            }

            # "Script" {
            #     $file_path = Join-Path -Path $PSVirtualEnv.ScriptDir -ChildPath $Script
            #     break;
            # }

            "SearchDirs" {
                $file_path = Join-Path -Path $PSVirtualEnv.SearchDir -ChildPath $SearchDirs
                $new_file_path =
                Join-Path -Path ([REgex]::Match($file_path, "(.*)\\.*$").Groups[1].Value) -ChildPath ($NewName + "-searchdirs.txt") 
                break;
            }
        }

        # rename existing requirement or script file
        if (Test-Path -Path $file_path){
            Rename-Item -Path $file_path -NewName $new_file_path
        }
    }
}
