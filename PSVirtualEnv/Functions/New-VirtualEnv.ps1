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
        [System.String] $Path

        # [Parameter(HelpMessage="The requirements file")]
        # [alias("r")]
        # [System.String] $Requirement,

        # [Parameter(HelpMessage="The package to install. Repeat the parameter for more than one")]
        # [alias("i")]
        # [System.String[]] $Packages
    )

    Process{
    
        $virtualEnv = $Name

        # check whether the specified virtual environment exists
        if (Test-VirtualEnv -Name $virtualEnv){
            Write-FormatedError -Message "The virtual environment '$virtualEnv' already exists." -Space
            Get-VirtualEnv

            return
        }

        # find a path, where a python distribution is located.
        $Path = Find-Python $Path -Verbose
        if (-not $Path) { return }
        $pythonVersion = Get-PythonVersion $Path -Verbose

        #BackupPath
        # if ($pythonVersion -eq "2") {
            #createNewVirtualEnv2 -Name $Name -Path $Path -Packages $Packages -RequirementFile $Requirement
            #     $Command = (Join-Path (Join-Path (Split-Path $Python -Parent) "Scripts") "virtualenv.exe")
        #} elseif ($pythonVersion -eq "3") {
        #} else {
            #RestorePath
        #}

        # generate the full path of the specified virtual environment, which shall be located in the predefined system path
        $virtualEnvDir = Get-VirtualEnvPath -Name $virtualEnv
   
        # create the specified virtual environment
        Write-Host "Creating the virtual environment '$virtualEnv'... "
         . $Path "-m" $PYTHONVIRTUALENV  "--verbose" $virtualEnvDir
         
        Write-FormatedSuccess -Message "Virtual environment '$virtualEnvDir' was created." -Space
    }
}

#   alias ----------------------------------------------------------------------
# ------------------------------------------------------------------------------
Set-Alias -Name mkvenv -Value New-VirtualEnv
