# ==============================================================================
#   New-VirtualEnv.ps1 ---------------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function New-VirtualEnv {

    <#
    .SYNOPSIS
        Creates a virtual environment.

    .DESCRIPTION
        Creates a virtual environment in the predefined system directory.

    .PARAMETER Name

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


    .INPUTS
        System.String. Name of virtual environment, which should be removed.
    
    .OUTPUTS
        None.
    #>

    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="None", PositionalBinding=$True)]

    [OutputType([Void])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment to be created.")]
        [System.String] $Name,

        [Parameter(Position=2, HelpMessage="Path to a folder or executable of a python distribution.")]
        [System.String] $Path,

        [Parameter(HelpMessage="Path to a requirements file, or name of a virtual environment.")]
        [System.String] $Requirement
    )

    Process{
    
        # check whether the specified virtual environment exists
        if (Test-VirtualEnv -Name $Name){
            Write-FormatedError -Message "The virtual environment '$Name' already exists." -Space
            Get-VirtualEnv

            return
        }
        
        # get existing requirement file 
        if ($Requirement) {
            $requirementFile = Get-VirtualEnvRequirementFile -Name $Requirement
            if (-not (Test-VirtualEnvRequirementFile -Name $requirementFile)) {
                Write-FormatedError -Message "There can not be found a existing requirement file." -Space
                return
            }
        }

        # find a path, where a python distribution is located.
        $pythonExeLocal = Find-Python $Path -Verbose
        if (-not $pythonExeLocal) { return }
        $pythonVersion = Get-PythonVersion $pythonExeLocal -Verbose

        # generate the full path of the specified virtual environment, which shall be located in the predefined system path
        $virtualEnvDir = Get-VirtualEnvPath -Name $Name
   
        # create the specified virtual environment
        Write-Host "Creating the virtual environment '$Name'... "

         . $pythonExeLocal "-m" virtualenv  $virtualEnvDir "--verbose" 
         
        Write-FormatedSuccess -Message "Virtual environment '$virtualEnvDir' was created." -Space

        Get-VirtualEnv

        # install packages from the requirement file
        if ($Requirement) {
            Install-PythonPckg -EnvExe (Get-VirtualEnvExe -Name $Name) -Requirement $requirementFile
            
            Get-VirtualEnv -Name $Name
        }
    }
}
