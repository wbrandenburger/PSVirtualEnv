# ===========================================================================
#   PSVirtualEnv_Config.ps1 -------------------------------------------------
# ===========================================================================

if (-not $(Test-Path $Module.Config)) {
    $default_config_string | Out-File -FilePath $Module.Config -Force
}

@(
    @{  # manifest 
        Name="Manifest"
        Value=Join-Path -Path $Module.Dir -ChildPath "$($Module.Name).psd1"
    }
    @{  # directory of functions
        Name="ClassDir"
        Value=Join-Path -Path $Module.Dir -ChildPath "Classes"
    }    
    @{  # directory of functions
        Name="FunctionsDir"
        Value=Join-Path -Path $Module.Dir -ChildPath "Functions"
    }
    @{  # directory of functions
        Name="TestsDir"
        Value=Join-Path -Path $Module.Dir -ChildPath "Tests"
    }
    @{  # configuration file and content of configuration file
        Name="ConfigContent" 
        Value=Get-IniContent -FilePath $Module.Config
    }
) | ForEach-Object {
    $Module | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
}

#   configuration -----------------------------------------------------------
# ---------------------------------------------------------------------------

# set the default path where the virtual environments are located and their subdirectories defined in the configuration file
$PSVirtualEnv = New-Object -TypeName PSObject -Property @{
    Name = $Module.Name
}

$work_dir = Get-ProjectDir -Name $Module.Name
@( 
    @{
        Name="venv-work-dir"; Section="user"; Field="WorkDir"; 
        Default=$work_dir
    }
    @{
        Name="venv-require-dir"; Section="user"; Field="RequireDir"
        Default=$(Join-Path -Path $work_dir -ChildPath ".require")
    }
    @{
        Name="venv-local-dir"; Section="user"; Field="LocalDir"
        Default=$(Join-Path -Path $work_dir -ChildPath ".temp")
    }
) | ForEach-Object {
    $content = $Module.ConfigContent[$_.Section][$_.Name]
    if (-not $content -or -not $(Test-Path $content)) {
        
        $path = $content
        if (-not $content) {
            $path = $_.Default
            $Module.ConfigContent | Set-IniContent -Sections $_.Section -NameValuePairs @{ $_.Name = $_.Default }
        }

        Write-FormattedWarning -Message "The path $($content) defined in field $($_.Name) of the module configuration file can not be found. Default directory $($path) will be created." -Module $Module.Name

        If (-not $(Test-Path $path)) {
            New-Item -Path $path -ItemType Directory
        }
    }

    $PSVirtualEnv  | Add-Member -MemberType NoteProperty -Name $_.Field -Value  $content 
}

$Module.ConfigContent | Out-IniFile -FilePath $Module.Config -Force

# set the default python distribution, virtual environment executable and other settings defined in the configuration file
@( 
    @{Name="python"; Section="user"; Field="Python"; Default=""}
    @{Name="venv"; Section="psvirtualenv"; Field="VirtualEnv"; Default="Scripts\python.exe"}
    @{Name="venv-activation"; Section="psvirtualenv"; Field="Activation"; Default="Scripts\activate.ps1"}
    @{Name="venv-deactivation"; Section="psvirtualenv"; Field="Deactivation"; Default="deactivate"}
    
) | ForEach-Object {
    $content = $Module.ConfigContent[$_.Section][$_.Name]
    
    if (-not $content) {
        Write-FormattedWarning -Message "Field $($_.Field) is not defined in configuration file and should be set for full module functionality." -Module $Module.Name
    }

    $PSVirtualEnv  | Add-Member -MemberType NoteProperty -Name $_.Field -Value  $content 
}
