# ==============================================================================
#   PSVirtualEnv.psm1 ----------------------------------------------------------
# ==============================================================================

#   settings -------------------------------------------------------------------
# ------------------------------------------------------------------------------
    
    # get module name and directory
    $Script:moduleName = "PSVirtualEnv"
    $Script:moduleDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

    # if the module shall be tested, the corresponding switch is activated to use the test configuration file
    if ($env:PSVirtualEnv){
        $Script:testModule = $True
    }

    # execute file with the specific module settings
    . (Join-Path -Path $Script:moduleDir -ChildPath ($Script:moduleName + ".Module.ps1")) -Test:$Script:testModule

    # load essential functions
    . $ModuleVar.FunctionsFile
    
#   configuration --------------------------------------------------------------
# ------------------------------------------------------------------------------

    # set the default path where the virtual environments are located and their subdirectories defined in the configuration file

    $PSVirtualEnv = New-Object -TypeName PSObject

    @( 
        @{Name="venv-work-dir"; Section="settings"; Variable="WorkDir"}
        @{Name="venv-config-dir"; Section="settings"; Variable="ConfigDir"}
        @{Name="venv-local-dir"; Section="settings"; Variable="LocalDir"}
    ) | ForEach-Object {
        $PSVirtualEnv  | Add-Member -MemberType NoteProperty -Name $_.Variable -Value  $ModuleVar.ConfigContent[$_.Section][$_.Name]

        if (-not (Test-Path $PSVirtualEnv.($_.Variable))) {
            Write-FormatedError -Message "The path $($PSVirtualEnv.($_.Variable)) defined in field $($_.Name) of the module configuration file can not be found." -Space

            $choices = "&Yes", "&No"
            if ($Host.UI.PromptForChoice($Null, "Create directory '$($PSVirtualEnv.($_.Variable))'?", $choices, 1) -eq 0) {
                New-Item -Path $PSVirtualEnv.($_.Variable) -ItemType Directory
            } 
            else {
                Write-FormatedError -Message "Import of module aborted" -Space
                exit
            }
        }
    }

    # set the default python distribution, virtual environment executable and other settings defined in the configuration file
    @( 
        @{Name="python"; Section="settings"; Variable="Python"}
        @{Name="venv"; Section="settings"; Variable="VirtualEnv"}
        @{Name="venv-activation"; Section="settings"; Variable="Activation"}
        @{Name="venv-deactivation"; Section="settings"; Variable="Deactivation"}
        @{Name="venv-requirement"; Section="settings"; Variable="Requirement"}
        @{Name="replace-pattern"; Section="settings"; Variable="ReplacePattern"}
    ) | ForEach-Object {
        $PSVirtualEnv  | Add-Member -MemberType NoteProperty -Name $_.Variable -Value  $ModuleVar.ConfigContent[$_.Section][$_.Name]
    }

#   functions ------------------------------------------------------------------
# ------------------------------------------------------------------------------

    # load all sets of public and private functions into the module scope
    Get-ChildItem -Path $ModuleVar.FunctionsDir -Filter "*.ps1" | ForEach-Object {
            . $_.FullName
    }

#   aliases --------------------------------------------------------------------
# ------------------------------------------------------------------------------

    # define aliases for specific function
    @(
        
        @{ Name = "cd-venv";     Value =  "Set-VirtualEnvLocation"}
        @{ Name = "cp-venv";     Value =  "Copy-VirtualEnv"}
        @{ Name = "ls-venv";     Value =  "Get-VirtualEnv"}
        @{ Name = "mk-venv";     Value =  "New-VirtualEnv"}
        @{ Name = "rm-venv";     Value =  "Remove-VirtualEnv"}
        @{ Name = "start-venv";  Value =  "Start-VirtualEnv"}
        @{ Name = "stop-venv";   Value =  "Stop-VirtualEnv"}

    ) | ForEach-Object {
        Set-Alias -Name $_.Name -Value $_.Value
    }

return 0
