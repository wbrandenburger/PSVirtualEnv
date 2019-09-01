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
        Creates a virtual environment in the predefined system directory.

    .PARAMETER Name

    .PARAMETER Path

    .PARAMETER Requirement

    .PARAMETER OFFLINE

    .EXAMPLE
        PS C:\> New-VirtualEnv -Name venv

        SUCCESS: Virtual environment 'A:\VirtualEnv\venv' was created.

        -----------
        Description
        Creates the specified virtual environment in the predefined directory with the default python distribution.
   
    .EXAMPLE
        PS C:\> New-VirtualEnv -Name venv -Path C:\Python35\python.exe

        SUCCESS: Virtual environment 'A:\VirtualEnv\venv' was created.

        -----------
        Description
        Creates the specified virtual environment in the predefined directory with the defined python distribution.

    .EXAMPLE
        PS C:\> New-VirtualEnv -Name venv -Requirement papis-requirements.txt

        SUCCESS: Virtual environment 'A:\VirtualEnv\venv' was created.

        -----------
        Description
        Creates the specified virtual environment and install packages which are defined in requirements.txt

    .INPUTS
        System.String. Name of virtual environment, which should be removed.
    
    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment to be created.")]
        [System.String] $Name,

        [Parameter(Position=2, HelpMessage="Path to a folder or executable of a python distribution.")]
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

        # find a path, where a python distribution is located.
        $pythonExeLocal = Find-Python $Path -Verbose
        if (-not $pythonExeLocal){
            return
        }
        # $pythonVersion = Get-PythonVersion $pythonExeLocal -Verbose

        # generate the full path of the specified virtual environment, which shall be located in the predefined system path
        $virtualEnvDir = Get-VirtualEnvPath -Name $Name
   
        # # set the offline flag, which will prevent the virtual environment to download packages to be installed
        # if ($Offline) {
        #     $offlineCreation = "--never-download"
        # }

        # create the specified virtual environment
        Write-FormattedProcess "Creating the virtual environment '$Name'." -Module $PSVirtualEnv.Name

         . $pythonExeLocal -m virtualenv  $virtualEnvDir --verbose $offlineCreation
        
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
            Install-VirtualEnvPackage -Python (Get-VirtualPython -Name $Name) -Requirement $requirement_file
        
            Get-VirtualEnv -Name $Name
        }

        # if ($Offline) {
        #     Set-Location -Path $hostPath
        # }
    }
}
