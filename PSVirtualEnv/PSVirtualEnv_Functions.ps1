# ===========================================================================
#   PSVirtualEnv_Functions.ps1 ----------------------------------------------
# ===========================================================================

#   functions ---------------------------------------------------------------
# ---------------------------------------------------------------------------
Get-ChildItem -Path $Module.FunctionsDir -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}