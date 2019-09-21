# ===========================================================================
#   PSVirtualEnv_Environment.ps1 --------------------------------------------
# ===========================================================================

#   environment -------------------------------------------------------------
# ---------------------------------------------------------------------------
@(
    @{  # document and bibliography management environment variable
        Name="ProjectEnv"
        Value="$($PSVirtualEnv.Name)_PROJECT"
    }
    @{  # backup of document and bibliography management environment variable
        Name="ProjectEnvOld"
        Value="$($PSVirtualEnv.Name)_PROJECT_OLD"
    }
    @{  # backup of systems path environment variable
        Name="PathEnvOld"
        Value="$($PSVirtualEnv.Name)_PATH_OLD"
    }
    @{  #  pythonhome environment variable
        Name="PythonHome"
        Value="PYTHONHOME"
    }
) | ForEach-Object {
    $PSVirtualEnv | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
}

#   environment -------------------------------------------------------------
# ---------------------------------------------------------------------------
[System.Environment]::SetEnvironmentVariable("$($PSVirtualEnv.WORK)_WORK", $PSVirtualEnv.WorkDir)
[System.Environment]::SetEnvironmentVariable("$($PSVirtualEnv.Name)_LOCAL", $PSVirtualEnv.LocalDir)
[System.Environment]::SetEnvironmentVariable("$($PSVirtualEnv.Name)_REQUIRE", $PSVirtualEnv.RequireDir)