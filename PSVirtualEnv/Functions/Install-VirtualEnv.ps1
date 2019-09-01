# ===========================================================================
#   Install-VirtualEnv.ps1 --------------------------------------------------
# ===========================================================================

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVirtualEnv : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] ((Get-VirtualEnv | Select-Object -ExpandProperty Name) + "" + "python")
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateRequirements: 
    System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        $require_dir = [System.Environment]::GetEnvironmentVariable("VENV_REQUIRE", "process")
        return [String[]] (((Get-ChildItem -Path $require_dir -Include "*requirements.txt" -Recurse).FullName | ForEach-Object {
            $_ -replace ($require_dir -replace "\\", "\\")}) + "")
    }
}


#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------

function Install-VirtualEnv {

    <#
    .SYNOPSIS

    .DESCRIPTION
        
    .PARAMETER Name

    .PARAMETER Python

    .PARAMETER Requirement

    .PARAMETER Package

    .PARAMETER Uninstall

    .PARAMETER All

    .PARAMETER Offline

    .EXAMPLE
        PS> Install-VirtualEnvPckg -Name venv

        -----------
        Description
       
    .INPUTS
        None.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param (
        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment to be changed.")]
        [System.String] $Name="",

        [ValidateSet([ValidateRequirements])]
        [Parameter(Position=2, HelpMessage="Path to a requirements file, or name of a virtual environment.")]
        [System.String] $Requirement="",

        [Parameter(HelpMessage="Package to be installed.")]
        [System.String] $Package,

        [Parameter(HelpMessage="If switch 'Python' is true, packages will be installed in default python distribution.")]
        [Switch] $Python,

        [Parameter(HelpMessage="If switch 'Uninstall' is true, specified packages will be uninstalled.")]
        [Switch] $Uninstall,

        [Parameter(HelpMessage="If switch 'Upgrade' is true, specified packages will be upgraded.")]
        [Switch] $Upgrade,

        [Parameter(HelpMessage="If switch 'All' is true, all existing virtual environments will be changed.")]
        [Switch] $All

        # [Parameter(HelpMessage="If switch 'Offline' is true, the virtual environment will be created without download packages.")]
        # [Switch] $Offline
    )
    
    Process {

        # check valide virtual environment 
        if ($Name -and -not $Python)  {
            if ($Name -eq "python"){
                $Python=$True
            }

            if (-not(Test-VirtualEnv -Name $Name)){
                Write-FormattedError -Message "The virtual environment '$($Name)' does not exist." -Module $PSVirtualEnv.Name -Space
                Get-VirtualEnv

                return
            }

            $virtualEnv = @{ Name = $Name }
        }

        # if default python distribution shall be modified set a placeholder
        if ($Python) {
            $virtualEnv = @{ Name = "python" }
        }

        # get all existing virtual environments if 'Name' is not set
        if ($All) {
            $virtualEnv = Get-VirtualEnv
        }

        # get existing requirement file 
        if ($Requirement) {   
            $requirement_file = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement
        }

        # create a valide requirement file for a specified package
        if ($Package){
            $Upgrade = $False                
            $requirement_file =  New-TemporaryFile
            $package | Out-File -FilePath $requirement_file
        }

        $virtualEnv | ForEach-Object {

            # get existing requirement file 
            if ($Upgrade) {
                $requirement_file = Get-VirtualEnvRequirementFile -Name $_.Name 
                Get-VirtualEnvRequirement -Name $_.Name -Upgrade -Python:$Python
            }

             # get python distribution
            if ($Python) {
                $python_exe = Find-Python -Force
            }
            else {
                $python_exe = Get-VirtualPython -Name $_.Name
            }
            
            # install packages from the requirement file
            Install-VirtualEnvPackage -Python $python_exe -Requirement  $requirement_file -Uninstall:$Uninstall -Upgrade:$Upgrade
        }

        return $Null
    }
}


#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Install-VirtualEnvPackage {

    <#
    .DESCRIPTION
        Gets the properties of all packages in a python environment.
    
    .PARAMETER Python

    .PARAMETER Requirement

    .PARAMETER Uninstall

    .PARAMETER Upgrade

    .OUTPUTS
        PSCustomObject. Properties of all packages in a python environment
    #>

    
    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([PSCustomObject])]

    Param (
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Executable of a python distribution.")]
        [System.String] $Python,

        [Parameter(Position=2, Mandatory=$True, HelpMessage="Path to a requirements file.")]
        [System.String] $Requirement,

        [Parameter(HelpMessage="If switch 'Uninstall' is true, specified packages will be uninstalled.")]
        [Switch] $Uninstall,

        [Parameter(HelpMessage="If switch 'Upgrade' is true, specified packages will be upgraded.")]
        [Switch] $Upgrade
    )

    # specify the command to install or uninstall
    $install_cmd = "install"
    if ($Uninstall){
        $Upgrade = $False
        $install_Cmd = "uninstall"
    }

    # if packages mmight be upgraded, consider upgrading in installation command
    $upgrade_cmd = ""
    if ($Upgrade) {
        $upgrade_cmd = "--upgrade"
    }

    # install packages from a requirement file
    Write-FormattedProcess -Message "Try to $($install_cmd) missing packages from requirement file '$Requirement'." -Module $PSVirtualEnv.Name

    . $Python -m pip $install_cmd --requirement $Requirement $upgrade_cmd

    Write-FormattedSuccess -Message "Packages from requirement file '$Requirement' were $($install_cmd)ed." -Module $PSVirtualEnv.Name

}
