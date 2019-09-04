# ===========================================================================
#   PSVirtualEnv.psm1 -------------------------------------------------------
# ===========================================================================

#   settings ----------------------------------------------------------------
# ---------------------------------------------------------------------------
$path = $MyInvocation.MyCommand.Path
$name = [System.IO.Path]::GetFileNameWithoutExtension($path)
$Module = New-Object -TypeName PSObject -Property @{
    Name = $name
    Dir =  Split-Path -Path $path -Parent
    Config = Get-ConfigProjectFile -Name $name
}

#   configuration -----------------------------------------------------------
# ---------------------------------------------------------------------------
New-ProjectConfigDirs -Name $Module.Name.toLower()

. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Default.ps1")
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Config.ps1")

#   functions ---------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Functions.ps1")

#   environment -------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Environment.ps1")

#   aliases -----------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Alias.ps1")

#   settings ----------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Settings.ps1")
