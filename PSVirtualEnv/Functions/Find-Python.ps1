# ===========================================================================
#   Find-Python.ps1 ---------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Find-Python {

    <#
    .SYNOPSIS
        Find a path, where a python distribution might located.

    .DESCRIPTION
        Find a path, where a python distribution might located. 'Find-Python' searches for a python distribution in configuration file and environment variable '%PYTHONHOME%'. Via flag 'Force' the python package 'virtualenv' can be installed in valide distribution.

    .PARAMETER Python

    .PARAMETER FORCE

    .EXAMPLE
        PS C:\> Find-Python

        C:\Python\Python37\python.exe

        -----------
        Description
        Return the path to an existing executable of a python distribution

    .EXAMPLE
        PS C:\> Find-Python -PathC:\Python\Python37

        C:\Python\Python3\python.exe

        -----------
        Description
        Return the path to an existing executable of a python distribution

    .EXAMPLE
        PS C:\> Find-Python -Path C:\Python\Python37\python.exe

        C:\Python\Python3\python.exe

        -----------
        Description
        Return the path to an existing executable of a python distribution

    .EXAMPLE
        PS C:\> Find-Python -Path C:\Python\Python37\python.exe

        C:\Python\Python3\python.exe

        -----------
        Description
        Return the path to an existing executable of a python distribution

    .INPUTS
        System.String. Path to a folder or executable of a python distribution.
    
    .OUTPUTS
        System.String. Path to an existing executable of a python distribution
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([System.String])]

    Param(        
        [Parameter(Position=1, ValueFromPipeline, HelpMessage="Path to a folder or executable of a python distribution.")]
        [System.String] $Path,

        [Parameter(HelpMessage="Forces installation of package 'virtualenv' if not found.")]
        [Switch] $Force
    )

    Process{

        # if the specified path does not contain an executable, try to detect the standard python distribution in system path
        $python_list = @(
            "$Path",
            "$($PSVirtualEnv.Python)",
            [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.PythonHome, "user"),
            [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.PythonHome, "machine")
        )

        for($i = 0; $i -lt $python_list.Length; $i++){

            if ($python_list[$i] -and $python_list[$i].EndsWith('python.exe')){
                $python_list[$i] = Split-Path -Path $python_list[$i] -Parent
            } 

            # check, whether the defined executbale does exist
            if ($python_list[$i] -and $(Test-Path $python_list[$i])) {   
                # $python_packages = Get-VirtualEnvPackage -Python $python_list[$i] -Unformatted
                # if (-not ($python_packages | Where-Object {$_.Name -eq "virtualenv"})) {
                #     if (-not $Force) {
                #         Write-FormattedError -Message "The python distribution does not provide the required package 'virtualenvwrapper'. Please install the package manually." -Module $PSVirtualEnv.Name -Space -Silent:(!$VerbosePreference)
                #             return
                #     }
                #     else {
                #         . $python_list[$i] -m pip install virtualenv 2>&1> $Null
                #         Write-FormattedWarning -Message "The python distribution does not provide the required package 'virtualenvwrapper'. Package will be installed automatically for full functionality." -Module $PSVirtualEnv.Name -Space -Silent:(!$VerbosePreference)
                #     }
                # }

                return  $python_list[$i]
            }
        }

        Write-FormattedError -Message "The python distribution can not be located. Set an existing python distribution in configuration file or set the environment variable '$($PSVirtualEnv.PythonHome)'" -Module $PSVirtualEnv.Name -Space -Silent:(!$VerbosePreference)
        return
    }
}