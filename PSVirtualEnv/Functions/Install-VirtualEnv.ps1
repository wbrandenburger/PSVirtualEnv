# ===========================================================================
#   Install-VirtualEnv.ps1 --------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Install-VirtualEnv {

    <#
    .SYNOPSIS
        Install or upgrade packages from command line or requirement files to virtual environments.

    .DESCRIPTION
        Install or upgrade packages from command line or requirement files to virtual environments. All available requirement files can be accessed by autocompletion.

    .PARAMETER Name

    .PARAMETER Requirement

    .PARAMETER Package

    .PARAMETER All

    .PARAMETER Offline

    .PARAMETER Silent

    .EXAMPLE
        PS C:\> Install-VirtualEnvPckg -Name venv -Package package
        [PSVirtualEnv]::PROCESS: Try to install packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\package-requirements.txt'.

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\package-requirements.txt' were installed.

        -----------
        Description
        Install package 'package' to specified virtual environment 'venv' by creating a requirement file with specified package and pipe it to virtual envinroments package manager.

    .EXAMPLE
        PS C:\> in-venv venv -Package package

        [PSVirtualEnv]::SUCCESS: Packages from requirement file C:\Users\User\PSVirtualEnv\.require\package-requirements.txt' were installed.

        -----------
        Description
        Install package 'package' to specified virtual environment 'venv' with predefined alias of command.

    .EXAMPLE
        PS C:\> Install-VirtualEnvPckg -Python -Package package

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\package-requirements.txt' were installed.

        -----------
        Description
        Install package 'package' to default python distribution.

    .EXAMPLE
        PS C:\> Install-VirtualEnvPckg -Name venv -Requirement \requirements.txt

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\requirements.txt' were installed.

        -----------
        Description
        Install packages defined in requirements file to specified virtual environment 'venv'. All available requirement files can be accessed by autocompletion.


    .EXAMPLE
        PS C:\> Install-VirtualEnvPckg -Name venv -Uninstall -Package package

        [PSVirtualEnv]::PROCESS: Try to uninstall packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\package-requirements.txt'.

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\package-requirements.txt' were uninstalled.

        -----------
        Description
        Remove package 'package' from specified virtual environment 'venv' by creating a requirement file with specified package and pipe it to virtual envinroments package manager.

    .EXAMPLE
        PS C:\> Install-VirtualEnvPckg -Name venv -Upgrade

        [PSVirtualEnv]::PROCESS: Try to upgrade packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\venv-requirements.txt'.

        Requirement already up-to-date: 'package'>='version' 

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\venv-requirements.txt' were upgraded.

    .INPUTS
        System.String. Name of existing virtual environment.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding, DefaultParameterSetName="Package")]

    [OutputType([Void])]

    Param (
        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=0, Mandatory, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name,

        [Parameter(ParameterSetName="Package", Position=1, Mandatory, HelpMessage="Specified packages will be installed.")]
        [System.String[]] $Package,

        [ValidateSet([ValidateVenvRequirements])]
        [Parameter(ParameterSetName="Requirement", Position=1, HelpMessage="Relative path to a requirements file in predefined requirements folder.")]
        [System.String] $Requirement,

        [ValidateSet([ValidateVenvLocal])]
        [Parameter(ParameterSetName="Offline", Position=1, HelpMessage="Path to a folder with local packages.")]
        [System.String] $Offline="",

        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )
    
    Process {

        $virtual_env = @{ Name = $Name }

        switch ($PSCmdlet.ParameterSetName) {
            "Package" { 
                # create a valide requirement file for a specified package
                $requirement_file = New-TemporaryFile -Extension ".txt"

                if ($package.Count -eq 1) {
                    $package = $package -split "," | Where-Object { $_}
                }
                $package | Out-File -FilePath $requirement_file
                

                break
            }
            "Requirement" {
                # get existing requirement file 
                $requirement_file = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement
                break
            }
            "Offline" {
                $local_path = Join-Path -Path $PSVirtualEnv.LocalDir -ChildPath $Offline

                $requirement_file = New-TemporaryFile -Extension ".txt"
                Out-File -FilePath $requirement_file -InputObject $local_path         
                break
            }
        }
        
        # install packages from the requirement file in all defined virtual environments
        $virtual_env | ForEach-Object {
            Install-VirtualEnvPackage -Name $_.Name -Requirement  $requirement_file -Silent:$Silent
        }
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Install-VirtualEnvPackage {

    <#
    .DESCRIPTION
        Gets the properties of all packages in a python environment.
    
    .PARAMETER Name

    .PARAMETER Requirement

    .PARAMETER Uninstall

    .PARAMETER Upgrade

    .PARAMETER Silent

    .OUTPUTS
        PSCustomObject. Properties of all packages in a python environment
    #>

    
    [CmdletBinding(PositionalBinding)]

    [OutputType([PSCustomObject])]

    Param (
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Name of the virtual environment to be changed.")]
        [System.String] $Name="",

        [Parameter(Position=2, Mandatory, HelpMessage="Path to a requirements file.")]
        [System.String] $Requirement,

        [Parameter(HelpMessage="If switch 'Uninstall' is true, specified packages will be uninstalled.")]
        [Switch] $Uninstall,

        [Parameter(HelpMessage="If switch 'Upgrade' is true, specified packages will be upgraded.")]
        [Switch] $Upgrade,

        [Parameter(HelpMessage="If switch 'Dev' is true, specified packages will be reinstalled.")]
        [Switch] $Dev,

        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    # specify the command to install or uninstall
    $install_cmd = "install"
    if ($Uninstall){
        $Upgrade = $False
        $install_Cmd = "uninstall"
    }
    $message = $install_cmd

    # if packages mmight be upgraded, consider upgrading in installation command
    $upgrade_cmd = ""
    if ($Upgrade -or $Dev) {
        $upgrade_cmd = "--upgrade"
        $message = "upgrade"
    }

    $dev_cmd = ""
    if ($Dev) {
        $dev_cmd = "--force-reinstall", "--no-deps"
        $message = "reinstall"
    }

    Write-FormattedProcess -Message "Try to $($message) packages from requirement file '$Requirement'." -Module $PSVirtualEnv.Name -Silent:$Silent

    Set-VirtualEnv -Name $Name
    
    # install packages from a requirement file
    if ($Silent) {
        pip $install_cmd --requirement $Requirement $upgrade_cmd $dev_cmd 2>&1> $Null
    } else {
        pip $install_cmd --requirement $Requirement $upgrade_cmd $dev_cmd
    }

    Restore-VirtualEnv

    Write-FormattedSuccess -Message "Packages from requirement file '$Requirement' were $($message)ed." -Module $PSVirtualEnv.Name -Silent:$Silent -Space 

}
