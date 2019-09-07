# ===========================================================================
#   Modify-Prompt.ps1 -------------------------------------------------------
# ===========================================================================

#   function -----------------------------------------------------------------
# ----------------------------------------------------------------------------
function Write-VirtualEnvStatus {

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param ()
    
    Process{

        $venv_path = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.ProjectEnv, "process")
        Write-PromptModuleStatus -Module "Venv" -Value $(Split-Path -Path $venv_path -leaf)
    }
}
