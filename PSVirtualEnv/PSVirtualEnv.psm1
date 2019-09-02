# ===========================================================================
#   PSVirtualEnv.psm1 -------------------------------------------------------
# ===========================================================================

#   modules -----------------------------------------------------------------
# ---------------------------------------------------------------------------
Import-Module -Name $(Join-Path -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent) -ChildPath "Modules\PSUtils")

#   psvirtualenv ------------------------------------------------------------
# ---------------------------------------------------------------------------
$Module = New-Object -TypeName PSObject -Property @{
    Name = [System.IO.Path]::GetFileNameWithoutExtension($(Split-Path -Path $MyInvocation.MyCommand.Path -Leaf))
    Dir =  Split-Path -Path $MyInvocation.MyCommand.Path -Parent
    Config = $(Join-Path -Path $(Get-ConfigProjectDir -Name "PSVirtualEnv") -ChildPath "config.ini")
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
New-ProjectConfigDirs -Name $Module.Name.toLower()

# search for the local configuration file
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Ini.ps1")
if (-not $(Test-Path $Module.Config)) {
    $default_config_string | Out-File -FilePath $Module.Config -Force
}

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
    $PSVirtualEnv  | Add-Member -MemberType NoteProperty -Name $_.Field -Value  $Module.ConfigContent[$_.Section][$_.Name]

    if (-not $PSVirtualEnv.($_.Field) -or -not $(Test-Path $PSVirtualEnv.($_.Field))) {
        
        $path = $PSVirtualEnv.($_.Field)
        if (-not $PSVirtualEnv.($_.Field)) {
            $path = $_.Default
            $Module.ConfigContent | Set-IniContent -Sections $_.Section -NameValuePairs @{
                $_.Name = $_.Default
            }
        }

        Write-FormattedWarning -Message "The path $($PSVirtualEnv.($_.Field)) defined in field $($_.Name) of the module configuration file can not be found. Default directory $($path) will be created." -Module $Module.Name

        If (-not $(Test-Path $path)) {
            New-Item -Path $path -ItemType Directory
        }
    }
}

[System.Environment]::SetEnvironmentVariable("VENV_REQUIRE", $PSVirtualEnv.RequireDir, "process")

$Module.ConfigContent | Out-IniFile -FilePath $Module.Config -Force

# set the default python distribution, virtual environment executable and other settings defined in the configuration file
@( 
    @{Name="python"; Section="user"; Field="Python"}
    @{Name="venv"; Section="psvirtualenv"; Field="VirtualEnv"}
    @{Name="venv-activation"; Section="psvirtualenv"; Field="Activation"}
    @{Name="venv-deactivation"; Section="psvirtualenv"; Field="Deactivation"}
    
) | ForEach-Object {
    $PSVirtualEnv  | Add-Member -MemberType NoteProperty -Name $_.Field -Value  $Module.ConfigContent[$_.Section][$_.Name]
    
    if (-not $PSVirtualEnv.($_.Field)) {
        Write-FormattedWarning -Message "Field $($_.Field) is not defined in configuration file and should be set for full module functionality." -Module $Module.Name
    }
}

#   functions ---------------------------------------------------------------
# ---------------------------------------------------------------------------
Get-ChildItem -Path $Module.FunctionsDir -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}

#   environment -------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Environment.ps1")

#   aliases -----------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Alias.ps1")

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
. $(Join-Path -Path $Module.Dir -ChildPath "$($Module.Name)_Validation.ps1")

return 0
