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

        Name    Version Local Requirement
        ----    ------- ----- -----------
        biology 3.7.3    True        True
        math    3.7.3    True        True

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
        virtualenv        16.6.1

        -----------
        Description
        Return information about all packages installed in the default python distribution.

    .INPUTS
        System.Strings. Name of the virtual environment.

    .OUTPUTS
        PSCustomObject. Object with contain information about all virtual environments.

    .NOTES
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([PSCustomObject])]

    Param (
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Information about all packages installed in the specified virtual environment will be returned.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If switch 'Python' is true, information about all packages installed in the default python distribution will be returned.")]
        [Switch] $Python
    )

    Process {

        # if the name of a virtual enviroment is not specified, general information about all virtual environments in the predefined system directory are gathered
        if (-not $Name -and -not $Python) {
            #   get all virtual environment directories in predefined system directory as well as the local directories and requirement files
            $virtualEnvSubDirs = Get-ChildItem -Path $PSVirtualEnv.WorkDir | Select-Object -ExpandProperty Name
            $virtualEnvLocalDir = Get-ChildItem -Path $PSVirtualEnv.LocalDir -Directory | Select-Object -ExpandProperty Name
            $virtualEnvRequirement = Get-ChildItem -Path $PSVirtualEnv.LocalDir -File | Select-Object -ExpandProperty Name

            $virtualEnvs = $Null

            #   call the python distribution of each virtual environnment and determine the version number
            if ($VirtualEnvSubDirs.length) {
                $virtualEnvs= $VirtualEnvSubDirs | ForEach-Object {
                    $virtualEnvName = $_
                    if (Test-VirtualEnv -Name $virtualEnvName) {
                        $virtualEnvExe = Get-VirtualEnvExe -Name $virtualEnvName
                        
                        [PSCustomObject]@{
                            # name of the virtual environment
                            Name = $virtualEnvName
                            # python version
                            Version = (((. $virtualEnvExe --version 2>&1) -replace "`r|`n","") -split " ")[1]
                            # download directory of the virtual environment
                            Local = if ($virtualEnvLocalDir | Where-Object{ $_ -match "^$virtualEnvName$"}){Get-VirtualEnvLocalDir -Name $virtualEnvName} else {$Null}
                            # requirement file of the virtual environment
                            Requirement = if($virtualEnvRequirement | Where-Object{ $_ -match "^$virtualEnvName.txt$"}){Get-VirtualEnvRequirementFile -Name $virtualEnvName} else {$Null}
                        }
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
                if (-not (Test-VirtualEnv -Name $Name -Verbose)){
                    Get-VirtualEnv
                    return $Null
                }
                $envExe = Get-VirtualEnvExe -Name $Name

            }
            else {
                $envExe = $PSVirtualEnv.Python
            }
           
            return Get-PckgProperty -EnvExe $envExe
   
        }
    }
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Get-PckgProperty {

    <#
    .DESCRIPTION
        Gets the properties of all packages in a python environment.
    
    .PARAMETER EnvExe

    .OUTPUTS
        PSCustomObject. Properties of all packages in a python environment
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([PSCustomObject])]

    Param (
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Executable of a python distribution.")]
        [System.String] $EnvExe
    )

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