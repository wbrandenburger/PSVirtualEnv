# ===========================================================================
#   Get-VirtualEnv.ps1 ------------------------------------------------------
# ===========================================================================

#   validaation -------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVirtualEnv : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] ((Get-VirtualEnv | Select-Object -ExpandProperty Name) + "" )
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnv {

    <#
    .SYNOPSIS
        Get all existing virtual environments in predefined system directory.

    .DESCRIPTION
        Return all existing virtual environments in predefined system directory as PSObject with version number.

    .PARAMETER Name

    .PARAMETER Python

    .EXAMPLE
        PS C:\> Get-VirtualEnv

        Name    Version
        ----    -------
        biology 3.7.3
        math    3.7.3

        -----------
        Description
        Return all existing virtual environments in predefined system directory.

    .EXAMPLE
        PS C:\> Get-VirtualEnv -Name venv

        Name            Version  Latest
        ----            -------  ------
        cycler          0.10.0
        kiwisolver      1.1.0
        matplotlib      3.1.0

        -----------
        Description
        Return information about all packages installed in the specified virtual environment 'venv'.

    .EXAMPLE
        PS C:\> Get-VirtualEnv -Python

        Name              Version  Latest
        ----              -------  ------
        setuptools        41.0.1
        pip               19.1.1
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
        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Information about all packages installed in the specified virtual environment will be returned.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If switch 'Python' is true, information about all packages installed in the default python distribution will be returned.")]
        [Switch] $Python,

        [Parameter(HelpMessage="Return information about required packages.")]
        [Switch] $Full,

        [Parameter(HelpMessage="Return information not as readable table with additional details.")]
        [Switch] $Unformatted
    )

    Process {

        # return information about python distribution
        if ($Python) {
            return $(Get-VirtualEnvPackage -Python $PSVirtualEnv.Python -full:$Full -Unformatted:$Unformatted)
        }
        
        # return information about specified virtual distribution
        if ($Name) {                     
            # check whether the specified virtual environment exists
            if (-not $(Test-VirtualEnv -Name $Name -Verbose)){
                Get-VirtualEnv
                return $Null
            }

            Start-VirtualEnv -Name $Name -Silent
            $pkgProperty = $(Get-VirtualEnvPackage -Python $PSVirtualEnv.Python -full:$Full -Unformatted:$Unformatted)
            Stop-VirtualEnv -Silent
            
            return $pkgProperty
        }

        #  return information about all virtual environments in the predefined system directory are gathered
        if (-not $Name -and -not $Python) {
            # get all virtual environment directories in predefined system directory as well as the local directories and requirement files
            $virtualEnvSubDirs = Get-ChildItem -Path $PSVirtualEnv.WorkDir | Select-Object -ExpandProperty Name

            $virtualEnvs = $Null

            # call the python distribution of each virtual environnment and determine the version number
            if ($VirtualEnvSubDirs.length) {
                $virtualEnvs= $VirtualEnvSubDirs | ForEach-Object {
                    if (Test-VirtualEnv -Name $_) {
                         # set environment variable
                        Set-VirtualEnvSystem -Name $_

                        $virtualEnvExe = Get-VirtualPython -Name $_
                        # name of virtual environment and python version
                        [PSCustomObject]@{
                            Name = $_
                            Version = (((. $virtualEnvExe --version 2>&1) -replace "`r|`n","") -split " ")[1]
                        }
                        # # set the pythonhome variable in scope process to the stored backup variable
                        Restore-VirtualEnvSystem
                    }
                }

                return $virtualEnvs
            } 
            else {
                Write-FormattedError -Message "In predefined system directory do not exist any virtual environments" -Module $PSVirtualEnv.Name -Space 
            }
        }

    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvPackage {

    <#
    .DESCRIPTION
        Gets the properties of all packages in a python environment.
    
    .PARAMETER Python
    
    .EXAMPLE
        PS C:\> Get-VirtualEnvPackage -Python C:\Python\Python37\python.exe

        Name       Version Latest
        ----       ------- ------
        doc8       0.8.0
        pip        19.2.1
        setuptools 41.0.1
        virtualenv 16.6.1


        Name                  Version Required Latest
        ----                  ------- -------- ------
        chardet               3.0.4       True
        docutils              0.15.2      True
        pbr                   5.4.2       True

        -----------
        Description
        Return information about all packages installed in the default python distribution. Those packages which are independet are displayed in a separated table
    .OUTPUTS
        PSCustomObject. Properties of all packages in a python environment
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([PSCustomObject])]

    Param (
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Executable of system's python distribution or of a virtual environment.")]
        [System.String] $Python,

        [Parameter(HelpMessage="Return information about required packages.")]
        [Switch] $Full,

        [Parameter(HelpMessage="Return information not as readable table with additional details.")]
        [Switch] $Unformatted
    )

    # get all packages in the specified virtual environment
    $venv_package = . $Python -m pip list --format json | ConvertFrom-Json 

    # get all outdated packages 
    $venv_outdated = . $Python -m pip list --format json --outdated | ConvertFrom-Json 
    # get all independent packages
    $venv_independent = . $Python -m pip list --format json --not-required | ConvertFrom-Json 

    # combine all gathered properties about the packages in the specified virtual environment
    $venv_package = $venv_package | ForEach-Object{
        $package = $_
        $package_outdated = $venv_outdated | Where-Object {$_.Name -eq $package.Name}
        $package_independent = $venv_independent | Where-Object {$_.Name -eq $Package.Name}

        [PSCustomObject]@{
            Name = $package.Name
            Version = $package.Version
            Latest = $package_outdated.Latest
            Required = if ( $package_independent ) {$Null} else {$True}

        }
    } 

    # return all packages which are independent from others in a separated table
    $result = $venv_package
    # | Format-Table -Property Name, Version, Latest
    $result = $venv_package | Where-Object {-not $_.Required} 

    if ($Full) {
    $requires_dict = @{}
    $result | ForEach-Object{
        $package = $_.Name
        $result_info = . $Python -m pip show $package
        $result_info | ForEach-Object{
                $result_requires = $_ -Split "^Requires: "
                if ($result_requires.Length -gt 1){
                    foreach($required_package in ($result_requires[1] -Split ", ")){
                        $requires_dict[$required_package] = $package
                    }
                }
            }
        }

    $result_required = $venv_package | Where-Object {$_.Required} 
    $result_required | ForEach-Object {
            if ($requires_dict.ContainsKey($_.Name)) {
                $_ | Add-Member -MemberType NoteProperty -Name "Required-by" -Value $requires_dict[$_.Name]
            }
        }
    }

    if ($Unformatted){
        return $result,  $result_required
    }
    else {
        return  ($result | Format-Table -Property Name, Version, Latest), ($result_required | Format-Table -Property Name, Version, Required-by, Latest)
    }
}
