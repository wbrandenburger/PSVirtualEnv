# ===========================================================================
#   Get-VirtualEnvFile.ps1 --------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvFile {

    <#
    .SYNOPSIS
        Get the content of an existing requirement, script file or (default setting) the module's configuration file.

    .DESCRIPTION
        Get the content of an existing requirement, script file or (default setting) the module's configuration file in predefined editor. All available requirement and script files can be accessed by autocompletion.
    
    .PARAMETER Requirement
    
    .PARAMETER RequirementList

    .PARAMETER Script

    .PARAMETER ScriptList

    .PARAMETER SearchDirs

    .PARAMETER SearchDirsList

    .PARAMETER Template

    .PARAMETER TemplateList

    .EXAMPLE
        PS C:\> Get-VirtualEnvFile

        Name                           Value
        ----                           -----
        venv-work-dir                  A:\VirtualEnv
        venv-local-dir                 A:\VirtualEnv\.temp
        venv-require-dir               A:\VirtualEnv\.require
        python                         PYTHONHOME
        default-editor                 code
        editor-arguments               --new-window --disable-gpu
        venv                           Scripts\python.exe
        venv-activation                Scripts\activate.ps1
        venv-deactivation              deactivate

        -----------
        Description
        Get the content of module's configuration file in predefined editor.

    .EXAMPLE
        PS C:\> Get-VirtualEnvFile -Template

        Name    Requirement                       SearchDir
        ----    -----------                       ---------
        hello-1 {shared\hello-1-requirements.txt} {cuda-v10.0-path.txt}

        -----------
        Description
        "Show a template for special virtual environments.

    .EXAMPLE
        PS C:\>Get-VirtualEnvFile -Requirement \general\venv-requirements.txt
        Click==7.0
        
        -----------
        Description
        Get the content of the requirement file in predefined requirements folder. All available requirement files can be accessed by autocompletion.

    .EXAMPLE
        PS C:\>Get-VirtualEnvFile -Script \general\venv.py
        import tensorflow as tf
        
        -----------
        Description
        Get the content of the script file in predefined scripts folder. All available script files can be accessed by autocompletion.

    .EXAMPLE
        PS C:\>Get-VirtualEnvFile -Path \cuda-10.0-path.txt
        C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.0\bin
        
        -----------
        Description
        Get the content of a file with optional search directories in predefined editor. All available files can be accessed by autocompletion.
    .INPUTS
        System.String. Relative path of an existing requirement or script file.

    .OUTPUTS
        System.String. Content of an existing requirement or script file.
    #>

    [CmdletBinding(PositionalBinding, DefaultParameterSetName="Config")]

    [OutputType([System.String])]

    Param(
        [ValidateSet([ValidateVenvRequirements])]
        [Parameter(ParameterSetName="Requirement", Position=1,  HelpMessage="Relative path to a requirements file in predefined requirements folder.")]
        [System.String] $Requirement,
        
        [Parameter(ParameterSetName="Requirement", Position=1,  HelpMessage="Show all requirements files provided in predefined requirements folder.")]
        [Switch] $RequirementList,
        
        [ValidateSet([ValidateVenvScripts])]
        [Parameter(ParameterSetName="Script", Position=1, HelpMessage="Relative path to a script file in predefined scripts folder.")]
        [System.String] $Script,

        [Parameter(ParameterSetName="Script", Position=1,  HelpMessage="Show all script files provided in predefined script folder.")]
        [Switch] $ScriptList,

        [ValidateSet([ValidateVenvSearchDirs])]
        [Parameter(ParameterSetName="SearchDirs", Position=1,  HelpMessage="Relative path to existing file with additional search directories in predefined folder.")]
        [System.String] $SearchDirs,

        [Parameter(ParameterSetName="SearchDirs", Position=1,  HelpMessage="Show all existing files with additional search directories provided in predefined folder.")]
        [Switch] $SearchDirsList,

        [ValidateSet([ValidateVenvTemplates])]
        [Parameter(ParameterSetName="Template", Position=1, HelpMessage="Show a template for special virtual environments.")]
        [System.String] $Template,

        [Parameter(ParameterSetName="Template", HelpMessage="Show all templates for special virtual environments.")]
        [Switch] $TemplateList,

        [Parameter(ParameterSetName="Config")]
        [Parameter(ParameterSetName="Template")]
        [Parameter(ParameterSetName="SearchDirs")]
        [Parameter(HelpMessage="Return information not as readable table with additional details.")]
        [Switch] $Unformatted

        
    )

    Process {

        # get existing requirement or script file
        switch ($PSCmdlet.ParameterSetName) {
            "Config" {
                $file_path = $Module.Config

                $content =  Format-IniContent -Content (Get-IniContent -FilePath $file_path -IgnoreComments) -Substitution $PSVirtualEnv

                $result = @()
                $content.Keys | ForEach-Object {
                    $result += $content[$_] 
                }

                if (-not $Unformatted){
                    $result = $result | Format-Table
                }

                break;
            }

            "Requirement" {
                if ($RequirementList){
                    $result = ValidateVirtualEnvFiles -Type "Requirement"
                }
                else {
                    $file_path = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement 

                    $result = Get-Content $file_path
                }
                break;
            }

            "Script" {
                if ($ScriptList){
                    $result = ValidateVirtualEnvFiles -Type "Script"
                }
                else {
                    $file_path = Join-Path -Path $PSVirtualEnv.ScriptDir -ChildPath $Script

                    $result = Get-Content $file_path
                }
                break;
            }

            "SearchDirs" {
                if ($SearchDirsList){
                    $result = ValidateVirtualEnvSearchDirs
                }
                else {
                    $file_path = Join-Path -Path $PSVirtualEnv.SearchDir -ChildPath $SearchDirs

                    $result = Get-Content $file_path

                    if ($Unformatted) {
                        $result = $result -join ";"
                    }
                }

                break;
            }

            "Template" {
                $templates = Get-Content -Path $PSVirtualEnv.TemplateFile | ConvertFrom-Json

                if ($TemplateList){
                    $result = $templates
                }
                else {
                    $result = $templates | Where-Object {$_.Name -match $Template}
                }

                if (-not $Unformatted){
                    $result = $result | Format-Table
                }

                break;
            }
        }

        # return content of requirement or script file
        return $result
    }
}