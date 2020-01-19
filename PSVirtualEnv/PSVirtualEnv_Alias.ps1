# ===========================================================================
#   PSVirtualEnv_Alias.ps1 --------------------------------------------------
# ===========================================================================

#   aliases -----------------------------------------------------------------
# ---------------------------------------------------------------------------

# define aliases for specific function
@(
    @{ Name = "activate-venv";  Value = "ActivateVirtualEnvAutocompletion"}
    @{ Name = "cd-venv";        Value = "Set-VirtualEnvLocation"}
    @{ Name = "ed-venv-file";   Value = "Edit-VirtualEnvFile"}
    @{ Name = "is-venv";        Value = "Install-VirtualEnv"}
    @{ Name = "i-venv";         Value = "Invoke-VirtualEnv"}
    @{ Name = "ls-venv";        Value = "Get-VirtualEnv"}
    @{ Name = "ls-venv-file";   Value = "Get-VirtualEnvFile"}
    @{ Name = "mk-venv";        Value = "New-VirtualEnv"}
    @{ Name = "mk-venv-file";   Value = "New-VirtualEnvFile"}
    @{ Name = "mk-venv-local";  Value = "New-VirtualEnvLocal"}
    @{ Name = "rm-venv";        Value = "Remove-VirtualEnv"}
    @{ Name = "rm-venv-file";   Value = "Remove-VirtualEnvFile"}
    @{ Name = "sa-venv";        Value = "Start-VirtualEnv"}
    @{ Name = "sp-venv";        Value = "Stop-VirtualEnv"}
    @{ Name = "ud-venv";        Value = "Update-VirtualEnv"}

) | ForEach-Object {
    Set-Alias -Name $_.Name -Value $_.Value
}
