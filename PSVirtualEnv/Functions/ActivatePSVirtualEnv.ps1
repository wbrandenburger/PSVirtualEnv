# ===========================================================================
#   ActivatePSVirtualEnv.ps1 ------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ActivateVirtualEnvAutocompletion {

    <#
    .DESCRIPTION
        Import PSVirtualEnv activating autocompletion for validating input of module functions.

    .OUTPUTS
        ScriptBlock. Scriptblock with using command.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([ScriptBlock])]

    Param()

    Process {

        return $(Get-Command $(Join-Path -Path $Module.ClassDir -ChildPath "ModuleValidation.ps1") | Select-Object -ExpandProperty ScriptBlock)

    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ValidateVirtualEnvDirectories {

    <#
    .DESCRIPTION
        Return values for the use of validating existing virtual environments
    
    .OUTPUTS
        System.String[]. Virtual environments
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String[]])]

    Param()

    Process{

       return (Get-VirtualEnvWorkDir | Select-Object -ExpandProperty Name)
    
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ValidateVirtualEnvSearchDirs {
    <#
    .DESCRIPTION
        Return values for the use of validating existing files with additional search directories.
    
    .OUTPUTS
        System.String[]. Path files
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String[]])]

    Param()

    Process{

        $file_list = (Get-ChildItem -Path $PSVirtualEnv.SearchDir -Include "*searchdirs.txt" -Recurse).FullName
        return ($file_list | ForEach-Object {
            $_ -replace ($PSVirtualEnv.SearchDir -replace "\\", "\\")})

    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ValidateVirtualEnvTemplates {
    <#
    .DESCRIPTION
        Return values for the use of validating existing templates.
    
    .OUTPUTS
        System.String[]. Path files
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String[]])]

    Param()

    Process{

        return ( Get-Content -Path $PSVirtualEnv.TemplateFile | ConvertFrom-Json | ForEach-Object { $_.Name})

    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function ValidateVirtualEnvFiles {

    <#
    .DESCRIPTION
        Return values for the use of validating existing requirement or script files.
    
    .OUTPUTS
        System.String[]. Requirement or script files
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.String[]])]

    Param(

        [ValidateSet("Requirement", "Script", "Offline")]
        [Parameter(Position=1, Mandatory)]
        [System.String] $Type, 
        
        [Switch] $Folder
    )

    Process{

        switch ($Type) {
            "Requirement" {
                $file_path = $PSVirtualEnv.RequireDir
                $file_include = "*requirements.txt"
                break; 
            }
            "Script" {
                $file_path = $PSVirtualEnv.ScriptDir
                $file_include = "*.py", "*.ps1"
                break;
            }
            "Offline" {
                $file_path = $PSVirtualEnv.LocalDir
                $file_include = "*.whl"
                break;
            }
        }

        if (-not $Folder) {
            $file_list = (Get-ChildItem -Path $file_path -Include $file_include -Recurse).FullName
            
            $result = $file_list | ForEach-Object {
                $_ -replace ($file_path -replace "\\", "\\")}
        }
        else {
            $folder_list = (Get-ChildItem -Path $file_path -Directory -Recurse).FullName

            $result = $folder_list | ForEach-Object {
                $_ -replace ($file_path -replace "\\", "\\")
            } | Where-Object {$_ -notmatch ".git"}
        }
        
        return $result

    }
}