# ===========================================================================
#   PSVirtualEnv_Environment.ps1 -----------------------------------------------
# ===========================================================================

#   environment -------------------------------------------------------------
# ---------------------------------------------------------------------------

@(
    @{  #  pythonhome environment variable
        Name="PythonHome"
        Value="PYTHONHOME"
    }
    @{  #  backup of the pythonhome environment variable
        Name="OldVenvPath"
        Value="OLD_VIRTUAL_ENV_PATH"
    }
    @{  # python virtual environment variable
        Name="VenvPath"
        Value="VIRTUAL_ENV"
    }
) | ForEach-Object {
    $PSVirtualEnv | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
}
