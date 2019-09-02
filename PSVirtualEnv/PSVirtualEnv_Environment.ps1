# ===========================================================================
#   PSVirtualEnv_Environment.ps1 -----------------------------------------------
# ===========================================================================

#   environment -------------------------------------------------------------
# ---------------------------------------------------------------------------

@(
    @{  #  pythonhome environment variable
        Name="EnvPython"
        Value="PYTHONHOME"
    }
    @{  #  backup of the pythonhome environment variable
        Name="EnvBackup"
        Value="VIRTUAL_ENV_PYTHONHOME"
    }
    @{  # python virtual environment variable
        Name="EnvVenv"
        Value="VIRTUAL_ENV"
    }
) | ForEach-Object {
    $PSVirtualEnv | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
}
