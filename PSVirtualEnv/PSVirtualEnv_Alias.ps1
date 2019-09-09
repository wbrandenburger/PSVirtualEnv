# ===========================================================================
#   PSVirtualEnv_Alias.ps1 --------------------------------------------------
# ===========================================================================

#   aliases -----------------------------------------------------------------
# ---------------------------------------------------------------------------

# define aliases for specific function
@(
    @{ Name = "cd-venv";  Value = "Set-VirtualEnvLocation"}
    @{ Name = "is-venv";  Value = "Install-VirtualEnv"}
    @{ Name = "ls-venv";  Value = "Get-VirtualEnv"}
    @{ Name = "mk-venv";  Value = "New-VirtualEnv"}
    @{ Name = "rm-venv";  Value = "Remove-VirtualEnv"}
    @{ Name = "sa-venv";  Value = "Start-VirtualEnv"}
    @{ Name = "sp-venv";  Value = "Stop-VirtualEnv"}

) | ForEach-Object {
    Set-Alias -Name $_.Name -Value $_.Value
}
