# ==============================================================================
#   PSVirtualEnv.Module.ps1 ----------------------------------------------------
# ==============================================================================

#   parameter ------------------------------------------------------------------
# ------------------------------------------------------------------------------
Param(        
    [Parameter(HelpMessage="If the switch 'Test' is true, the test environment will be used.")]
    [Switch] $Test
)

#   settings script ------------------------------------------------------------
# ------------------------------------------------------------------------------
    
    # get module name and directory
    $Script:moduleName = "PSVirtualEnv"
    $Script:moduleDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

#   settings module  -----------------------------------------------------------
# ------------------------------------------------------------------------------
    $ModuleVar = New-Object -TypeName PSObject -Property @{
        Name = $Script:moduleName
        ModuleDir = $Script:moduleDir
    }
    # consideration of testing module
    $Script:testFile = $ModuleVar.Name + ".ini"
    if ($Test) {
        $Script:testFile = $ModuleVar.Name + ".Tests.ini"
    } 
    $ModuleVar | Add-Member -MemberType NoteProperty -Name "ConfigFile" -Value (Join-Path -Path $ModuleVar.ModuleDir -ChildPath $Script:testFile)

#   settings module  -----------------------------------------------------------
# ------------------------------------------------------------------------------
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
            Name="ConfigTestFile"
            Value = Join-Path -Path $ModuleVar.ModuleDir -ChildPath ($ModuleVar.Name + ".Tests.ini")
        }
        @{  # path of module script
            Name="ModuleFile"
            Value=Join-Path -Path $ModuleVar.ModuleDir -ChildPath ($ModuleVar.Name + ".Module.ps1")
        }
        @{  # path of functions script
            Name="FunctionsFile"
            Value=Join-Path -Path $ModuleVar.ModuleDir -ChildPath ($ModuleVar.Name + ".Functions.ps1")
        }
        @{  # configuration file and content of configuration file
            Name="ConfigContent" 
            Value=Get-IniContent -FilePath $ModuleVar.ConfigFile
            DependsOn="ConfigFile"
        }
    ) | ForEach-Object {
        $ModuleVar | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
    }