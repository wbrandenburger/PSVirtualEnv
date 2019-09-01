# ===========================================================================
#   New-VirtualEnv.ps1 ------------------------------------------------------
# ===========================================================================

#   validation ---------------------------------------------------------------
# ----------------------------------------------------------------------------
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
function New-VirtualEnv {

    <#
    .SYNOPSIS
        Creates a virtual environment.

    .DESCRIPTION
        Creates a virtual environment in the predefined system directory and install via a requirements file project related packages. All available requirement files can be accesed by autocompletion.

    .PARAMETER Name

    .PARAMETER Path

    .PARAMETER Requirement

    .EXAMPLE
        PS C:\> New-VirtualEnv -Name venv

        [PSVirtualEnv]::PROCESS: Creating new virtual environment 'venv'.
        New python executable in C:\Users\User\PSVirtualEnv\venv\Scripts\python.exe
        Installing setuptools, pip, wheel...
        done.

        [PSVirtualEnv]::SUCCESS: Virtual environment 'C:\Users\User\PSVirtualEnv\venv' was created.

        -----------
        Description
        Creates the specified virtual environment 'venv' in the predefined directory with the default python distribution.

    .EXAMPLE
        PS C:\> mk-venv venv

        [PSVirtualEnv]::SUCCESS: Virtual environment 'C:\Users\User\PSVirtualEnv\venv' was created

        -----------
        Description
        Creates the specified virtual environment 'venv' with predefined alias of command
   
    .EXAMPLE
        PS C:\> New-VirtualEnv -Name venv -Path C:\Python35\python.exe

        [PSVirtualEnv]::SUCCESS: Virtual environment 'C:\Users\User\PSVirtualEnv\venv' was created.

        -----------
        Description
        Creates the specified virtual environment 'venv' in the predefined directory with the defined python distribution.

    .EXAMPLE
        PS C:\> New-VirtualEnv -Name venv -Requirement \requirements.txt

        [PSVirtualEnv]::PROCESS: Creating new virtual environment 'venv'.
        New python executable in C:\Users\User\PSVirtualEnv\venv\Scripts\python.exe
        Installing setuptools, pip, wheel...
        done.

        [PSVirtualEnv]::SUCCESS: Virtual environment 'C:\Users\User\PSVirtualEnv\venv' was created.

        [PSVirtualEnv]::PROCESS: Try to install missing packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\requirements.txt'.
        Collecting 'package' (from -r C:\Users\User\PSVirtualEnv\.require\requirements.txt (line 1))
        Installing collected packages: 'package'
        Successfully installed 'package'-'version'

        [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\requirements.txt' were installed.


        Name       Version Latest
        ----       ------- ------
        package    version
        pip        19.2.3
        setuptools 41.2.0
        wheel      0.33.6

        -----------
        Description
        Creates the specified virtual environment 'venv' and install packages which are defined in 'requirements.txt'. Before execution, the requirements file has to be created in the requirements folder, specified in configuration file. All available requirement files can be accesed by autocompletion.

    .INPUTS
        System.String. Name of virtual environment, which should be created.
    
    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment to be created.")]
        [System.String] $Name,

        [Parameter(Position=2, HelpMessage="Relative path to a folder or executable of a python distribution.")]
        [System.String] $Path,

        [ValidateSet([ValidateRequirements])]
        [Parameter(HelpMessage="Path to a requirement file, or name of a virtual environment.")]
        [System.String] $Requirement

        # [Parameter(HelpMessage="If switch 'Offline' is true, the virtual environment will be created without download packages.")]
        # [Switch] $Offline
    )

    Process{
    
        # check whether the specified virtual environment exists
        if (Test-VirtualEnv -Name $Name){
            Write-FormattedError -Message "The virtual environment '$Name' already exists." -Module $PSVirtualEnv.Name -Space
            Get-VirtualEnv

            return
        }
        
        # deactivation of a running virtual environment
        if (Get-ActiveVirtualEnv) {
            Stop-VirtualEnv -Silent:$Silent
        }

        # get existing requirement file 
        if ($Requirement) {   
            $requirement_file = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement
        }

        # generate the full path of the specified virtual environment, which shall be located in the predefined system path
        $virtualEnvDir = Get-VirtualEnvPath -Name $Name
   
        # # set the offline flag, which will prevent the virtual environment to download packages to be installed
        # if ($Offline) {
        #     $offlineCreation = "--never-download"
        # }

        # create the specified virtual environment
        Write-FormattedProcess "Creating new virtual environment '$Name'." -Module $PSVirtualEnv.Name

        $verbose_cmd = ""
        if ($VerbosePreference){
            $verbose_cmd = "--verbose"
        }
        . $PSVirtualEnv.Python -m virtualenv  $virtualEnvDir $verbose_cmd

        # check whether the virtual environment could be created
        if (Test-VirtualEnv -Name $Name) {
            Write-FormattedSuccess -Message "Virtual environment '$virtualEnvDir' was created." -Module $PSVirtualEnv.Name -Space
        }
        else {
            Write-FormattedError -Message "Virtual environment '$virtualEnvDir' could not be created." -Module $PSVirtualEnv.Name -Space
            Get-VirtualEnv
            return $Null
        }

        # install packages from the requirement file
        if ($Requirement) {
            $python_venv = Get-VirtualPython -Name $Name
            Install-VirtualEnvPackage -Python $python_venv -Requirement $requirement_file
        
            Get-VirtualEnvPackage -Python $python_venv
        }

        # if ($Offline) {
        #     Set-Location -Path $hostPath
        # }
    }
}
