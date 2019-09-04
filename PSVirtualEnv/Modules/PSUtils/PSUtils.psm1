# ===========================================================================
#   PSUtils.psm1 ------------------------------------------------------------
# ===========================================================================

#   settings ----------------------------------------------------------------
# ---------------------------------------------------------------------------
$path = $MyInvocation.MyCommand.Path
$name = [System.IO.Path]::GetFileNameWithoutExtension($path)
$Module = New-Object -TypeName PSObject -Property @{
    Name = $name
    Dir =  Split-Path -Path $path -Parent
}

#   configuration -----------------------------------------------------------
# ---------------------------------------------------------------------------
@(
    @{  # manifest 
        Name="Manifest"
        Value=Join-Path -Path $Module.Dir -ChildPath "$($Module.Name).psd1"
    }
    @{  # directory of functions
        Name="FunctionsDir"
        Value=Join-Path -Path $Module.Dir -ChildPath "Functions"
    }
) | ForEach-Object {
    $Module | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
}

#   functions ---------------------------------------------------------------
# ---------------------------------------------------------------------------

# load all sets of public and private functions into the module scope
    Get-ChildItem -Path $Module.FunctionsDir -Filter "*.ps1" | ForEach-Object {
        . $_.FullName
}