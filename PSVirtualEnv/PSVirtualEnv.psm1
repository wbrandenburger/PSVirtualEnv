# ===========================================================================
#   PSVirtualEnv.psm1 -------------------------------------------------------
# ===========================================================================

#   settings ----------------------------------------------------------------
# ---------------------------------------------------------------------------
$default_config_string = "
; ===========================================================================
;   config.ini --------------------------------------------------------------
; ===========================================================================

; user settings -------------------------------------------------------------
; ---------------------------------------------------------------------------
[user]

; default path where virtual environments are located
venv-work-dir = 

; default download path for python packages
venv-local-dir =  

; default path for the requirements
venv-require-dir = 

; default python distribution
python = 

; internal settings ---------------------------------------------------------
; ---------------------------------------------------------------------------
[psvirtualenv]

; relative path of the virtual environement executable 
venv = Scripts\python.exe

; relative path of the virtual environement activation script 
venv-activation = Scripts\activate.ps1

; command of deactivation virtual environment
venv-deactivation = deactivate

"

#   settings ----------------------------------------------------------------
# ---------------------------------------------------------------------------
    $ModuleVar = New-Object -TypeName PSObject -Property @{
        Name = "PSVirtualEnv"
        ModuleDir =  Split-Path -Path $MyInvocation.MyCommand.Path -Parent
        ConfigFile = $(Join-Path -Path $(Get-ConfigProjectDir -Name "PSVirtualEnv") -ChildPath "config.ini")
    }

    New-ProjectConfigDirs -Name $ModuleVar.Name.toLower()

    # search for the local configuration file
    if (-not $(Test-Path $ModuleVar.ConfigFile)) {
        $default_config_string | Out-File -FilePath $ModuleVar.ConfigFile -Force
    }

    @(
        @{  # manifest 
            Name="Manifest"
            Value=Join-Path -Path $ModuleVar.ModuleDir -ChildPath ($ModuleVar.Name + ".psd1")
        }
        @{  # directory of functions
            Name="FunctionsDir"
            Value=Join-Path -Path $ModuleVar.ModuleDir -ChildPath "Functions"
        }
        @{  # directory of functions
            Name="TestsDir"
            Value=Join-Path -Path $ModuleVar.ModuleDir -ChildPath "Tests"
        }
        @{  # configuration file and content of configuration file
            Name="ConfigContent" 
            Value=Get-IniContent -FilePath $ModuleVar.ConfigFile
        }
    ) | ForEach-Object {
        $ModuleVar | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
    }

#   configuration -----------------------------------------------------------
# ---------------------------------------------------------------------------

    # set the default path where the virtual environments are located and their subdirectories defined in the configuration file
    $PSVirtualEnv = New-Object -TypeName PSObject -Property @{
        Name = $ModuleVar.Name
    }

    $project_dir = Get-ProjectDir -Name $ModuleVar.Name
    @( 
        @{
            Name="venv-work-dir"; 
            Section="user"; 
            Field="WorkDir"; 
            Default=$project_dir
        }
        @{
            Name="venv-require-dir"; 
            Section="user"; 
            Field="RequireDir"
            Default=$(Join-Path -Path $project_dir -ChildPath ".require")
        }
        @{
            Name="venv-local-dir"; 
            Section="user"; 
            Field="LocalDir"
            Default=$(Join-Path -Path $project_dir -ChildPath ".temp")
        }
    ) | ForEach-Object {
        $PSVirtualEnv  | Add-Member -MemberType NoteProperty -Name $_.Field -Value  $ModuleVar.ConfigContent[$_.Section][$_.Name]

        if (-not $PSVirtualEnv.($_.Field) -or -not $(Test-Path $PSVirtualEnv.($_.Field))) {
            
            $path = $PSVirtualEnv.($_.Field)
            if (-not $PSVirtualEnv.($_.Field)) {
                $path = $_.Default
                $ModuleVar.ConfigContent | Set-IniContent -Sections $_.Section -NameValuePairs @{
                    $_.Name = $_.Default
                }
            }

            Write-FormattedProcess -Message "The path $($PSVirtualEnv.($_.Field)) defined in field $($_.Name) of the module configuration file can not be found. Default directory $($path) will be created." -Module $Script:moduleName

            If (-not $(Test-Path $path)) {
                New-Item -Path $path -ItemType Directory
            }
        }
    }

    [System.Environment]::SetEnvironmentVariable("VENV_REQUIRE", $PSVirtualEnv.RequireDir, "process")

    $ModuleVar.ConfigContent | Out-IniFile -FilePath $ModuleVar.ConfigFile -Force

    # set the default python distribution, virtual environment executable and other settings defined in the configuration file
    @( 
        @{Name="python"; Section="user"; Field="Python"}
        @{Name="venv"; Section="psvirtualenv"; Field="VirtualEnv"}
        @{Name="venv-activation"; Section="psvirtualenv"; Field="Activation"}
        @{Name="venv-deactivation"; Section="psvirtualenv"; Field="Deactivation"}
        
    ) | ForEach-Object {
        $PSVirtualEnv  | Add-Member -MemberType NoteProperty -Name $_.Field -Value  $ModuleVar.ConfigContent[$_.Section][$_.Name]
        
        if (-not $PSVirtualEnv.($_.Field)) {
            Write-FormattedProcess -Message "Field $($_.Field) is not defined in configuration file and should be set for full module functionality." -Module $Script:moduleName
        }
    }

#   variables ---------------------------------------------------------------
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

#   functions ---------------------------------------------------------------
# ---------------------------------------------------------------------------

    # load all sets of public and private functions into the module scope
    Get-ChildItem -Path $ModuleVar.FunctionsDir -Filter "*.ps1" | ForEach-Object {
            . $_.FullName
    }

#   aliases -----------------------------------------------------------------
# ---------------------------------------------------------------------------

    # define aliases for specific function
    @(
        
        @{ Name = "cd-venv";     Value =  "Set-VirtualEnvLocation"}
        @{ Name = "ls-venv";     Value =  "Get-VirtualEnv"}
        @{ Name = "mk-venv";     Value =  "New-VirtualEnv"}
        @{ Name = "rm-venv";     Value =  "Remove-VirtualEnv"}
        @{ Name = "start-venv";  Value =  "Start-VirtualEnv"}
        @{ Name = "stop-venv";   Value =  "Stop-VirtualEnv"}

    ) | ForEach-Object {
        Set-Alias -Name $_.Name -Value $_.Value
    }

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------

    # try to locate default python distribution
    Find-Python -Force -Verbose

return 0
