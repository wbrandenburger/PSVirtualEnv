# ===========================================================================
#   PSUtils.psm1 ------------------------------------------------------------
# ===========================================================================

#   psutils -----------------------------------------------------------------
# ---------------------------------------------------------------------------
$Module = New-Object -TypeName PSObject -Property @{
    Name = "PSUtils"
    Dir =  Split-Path -Path $MyInvocation.MyCommand.Path -Parent
}

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