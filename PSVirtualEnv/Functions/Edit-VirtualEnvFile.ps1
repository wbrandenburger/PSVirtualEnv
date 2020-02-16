# ===========================================================================
#   Edit-VirtualEnvFile.ps1 -------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Edit-VirtualEnvFile {

    <#
    .SYNOPSIS
        Edit the content of an existing requirement, script file or (default setting) the module's configuration file.

    .DESCRIPTION
        Edit the content of an existing requirement, script file or (default setting) the module's configuration file in predefined editor. All available requirement and script files can be accessed by autocompletion.
    
    .PARAMETER Requirement

    .PARAMETER Script

    .PARAMETER SearchDirs

    .PARAMETER Template

    .EXAMPLE
        PS C:\> Edit-VirtualEnvFile

        -----------
        Description
        Open the content of module's configuration file in predefined editor.

    .EXAMPLE
        PS C:\> Edit-VirtualEnvFile -Template

        -----------
        Description
        Open the content of module's settings file in predefined editor.

    .EXAMPLE
        PS C:\> Edit-VirtualEnvFile -Requirement \general\venv-requirements.txt

        -----------
        Description
        Open the requirement file in predefined editor. All available requirement files can be accessed by autocompletion.

    .EXAMPLE
        PS C:\> Edit-VirtualEnvFile -Script \general\venv.py

        -----------
        Description
        Open the script file in predefined editor. All available script files can be accessed by autocompletion.

    .EXAMPLE
        PS C:\> Edit-VirtualEnvFile -SearchDirs \path-searchdirs.txt

        -----------
        Description
        Open the file with optional search directories in predefined editor. All available files can be accessed by autocompletion.

    .INPUTS
        System.String. Relative path of an existing requirement or script file.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding, DefaultParameterSetName="Config")]

    [OutputType([Void])]

    Param(
        [Parameter(ParameterSetName="Log",  HelpMessage="Show pip's last log file.")]
        [Switch] $Log,

        [ValidateSet([ValidateVenvRequirements])]
        [Parameter(ParameterSetName="Requirement", Position=1,  HelpMessage="Relative path to a requirements file in predefined requirements folder.")]
        [System.String] $Requirement,

        [ValidateSet([ValidateVenvScripts])]
        [Parameter(ParameterSetName="Script", Position=1, HelpMessage="Relative path to a script file in predefined scripts folder.")]
        [System.String] $Script,

        [ValidateSet([ValidateVenvSearchDirs])]
        [Parameter(ParameterSetName="SearchDirs", Position=1,  HelpMessage="Relative path to existing file with additional search directories in predefined folder.")]
        [System.String] $SearchDirs,

        [Parameter(ParameterSetName="Template", Position=1, HelpMessage="how all templates for special virtual environments.")]
        [Switch] $Template
    )

    Process {

        # get existing requirement or script file

        switch ($PSCmdlet.ParameterSetName) {
            "Config" {
                $file_path = $Module.Config
                break
            }
            "Log" {
                $file_path = $PSVirtualEnv.PipLogFile
                break
            }

            "Requirement" {
                $file_path = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement 
                break
            }

            "Script" {
                $file_path = Join-Path -Path $PSVirtualEnv.ScriptDir -ChildPath $Script
                break
            }

            "SearchDirs" {
                $file_path = Join-Path -Path $PSVirtualEnv.SearchDir -ChildPath $SearchDirs
                break
            }

            "Template" {
                $file_path = $PSVirtualEnv.TemplateFile
                break
            }
        }

        # open existing requirement or script file
        $editor_args = $($PSVirtualEnv.EditorArgs + " " + $file_path)
        if (Test-Path -Path $file_path){
            Start-Process -Path $PSVirtualEnv.Editor -NoNewWindow -Args $editor_args
        }
    }
}
