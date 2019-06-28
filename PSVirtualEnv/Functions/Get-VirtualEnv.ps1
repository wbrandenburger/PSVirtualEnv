# ==============================================================================
#   Get-VirtualEnv.ps1 ---------------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Get-VirtualEnv {

    <#
    .SYNOPSIS
        Get all existing virtual environments in predefined system directory.

    .DESCRIPTION
        Return all existing virtual environments in predefined system directory as PSObject with version number.

    .EXAMPLE
        PS C:\> Get-VirtualEnv

        Name      Version
        ----      -------
        GScholar  3.7.1
        jupyter   3.7.3

        -----------
        Description
        Return all existing virtual environments in predefined system directory.

    .EXAMPLE
        PS C:\> Get-VirtualEnv -Name venv

        Name            Version Independent Latest
        ----            ------- ----------- ------
        cycler          0.10.0
        kiwisolver      1.1.0
        matplotlib      3.1.0   True

        -----------
        Description
        Return information about all packages installed in the specified virtual environment 'venv'.

    .EXAMPLE
        PS C:\> Get-VirtualEnv -Python

        Name              Version Independent Latest
        ----              ------- ----------- ------
        setuptools        41.0.1         True
        pip               19.1.1         True
        virtualenvwrapper 4.8.4          True
        virtualenv        16.6.1
        pbr               5.1.1
        six               1.12.0
        stevedore         1.30.0

        -----------
        Description
        Return information about all packages installed in the default python distribution.

    .INPUTS
        System.Strings. Name of the virtual environment.

    .OUTPUTS
        PSCustomObject. Object with contain information about all virtual environments (name, version).

    .NOTES
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([PSCustomObject])]

    Param (
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Information about all packages installed in the specified virtual environment will be returned.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If true, information about all packages installed in the default python distribution will be returned.")]
        [Switch] $Python
    )

    Process {
        
        $virtualEnv = $Name

        # if the name of a virtual enviroment is not specified, general information about all virtual environments in the predefined system directory are gathered
        if (-not $virtualEnv -and -not $Python) {
            #   get all virtual environment directories in predefined system directory
            $virtualEnvSubDirs = Get-ChildItem $VIRTUALENVSYSTEM
            $virtualEnvs = $Null

            #   call the python distribution of each virtual environnment and determine the version number
            if ($VirtualEnvSubDirs.length) {
                $virtualEnvs= $VirtualEnvSubDirs | ForEach-Object {
                    $virtualEnvExe = Get-VirtualEnvExe -Name $_
                    [PSCustomObject]@{
                        Name = $_
                        Version = (((. $virtualEnvExe --version 2>&1) -replace "`r|`n","") -split " ")[1]
                    }
                }

            } else {
                Write-FormatedError -Message "In predefined system directory do not exist any virtual environments" -Space
            }

            #   return information of all detected virtual environments
            return $virtualEnvs
        }
        else {            
            # get the absolute path of the executable of the specified virtual environment
            if (-not $Python) {                     
                # check whether the specified virtual environment exists
                if (-not (Test-VirtualEnv -Name $virtualEnv -Verbose)){
                    Get-VirtualEnv
                    return $Null
                }
                $envExe = Get-VirtualEnvExe -Name $virtualEnv
            }
            else {
                $envExe = $PYTHONEXE
            }
            return Get-PckgProperty -EnvExe $envExe
   
        }
    }
}

#   alias ----------------------------------------------------------------------
# ------------------------------------------------------------------------------
Set-Alias -Name lsvenv -Value Get-VirtualEnv

function Get-PckgProperty {

    <#
    .SYNOPSIS
        Get the properties of all packages in a python environment.

    .DESCRIPTION
        Get the properties of all packages in a python environment.
    
    .PARAMETER EnvExe

    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([PSCustomObject])]

    Param (
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Executable of a python distribution.")]
        [System.String] $EnvExe
    )

    Process {

         # get the properties of all packages in the specified virtual environment
         $envPckg = . $EnvExe -m pip list --format json | ConvertFrom-Json # all available packages
         $envOutDated = . $EnvExe -m pip list --format json --outdated | ConvertFrom-Json # all outdated packages
         $envIndependent = . $EnvExe -m pip list --format json --not-required | ConvertFrom-Json # all independent packages

         # combine all gathered properties about the packages in the specified virtual environment
         return $envPckg | ForEach-Object{
             $pckg = $_
             $outDated = $envOutDated | Where-Object {$_.Name -eq $pckg.Name}
             $independent = $envIndependent | Where-Object {$_.Name -eq $pckg.Name}

             [PSCustomObject]@{
                 Name = $pckg.Name
                 Version = $pckg.Version
                 Independent = if ( $independent ) {$True} else {$Null}
                 Latest = $outDated.Latest
             }
         } | Sort-Object -Property Independent -Descending | Format-Table
    }
}