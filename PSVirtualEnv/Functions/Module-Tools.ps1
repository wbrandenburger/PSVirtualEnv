# ===========================================================================
#   Module-Tools.ps1 --------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Set-VirtualEnv {

    <#
    .DESCRIPTION
        Set environment variable
    
    .PARAMETER Name

    .PARAMETER Python

    .OUTPUTS 
        None.
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    $old_venv = Get-ActiveVirtualEnv
    if($old_venv) {
        [System.Environment]::SetEnvironmentVariable("VIRTUAL_ENV_OLD", $old_venv, "process")
    }

    # set a backup of the pythonhome environment variable
    $python_home = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.PythonHome, "process")

    # set a backup of the pythonhome environment variable
    $backup =  [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.OldVenvPath, "process")
    if (-not $backup) {
        [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.OldVenvPath, $env:PATH, "process")
    }

    # set the pythonhome variable in scope process to the path of the virtual environment
    if ($Name) {
        if ($Name -eq "Python")
        {
            $python_path = $python_home
            $env_path = "$($python_home);$($python_home)\Scripts;"+$env:PATH

        }
        else{
            $python_path = Get-VirtualEnvPath -Name $Name
            $env_path = "$(Get-VirtualEnvPath -Name $Name)\Scripts;"+$env:PATH
        }
        #set environment path and the name of the virtual environment
        [System.Environment]::SetEnvironmentVariable("PATH", $env_path, "process")
        [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.VenvPath, $python_path,"process")
        [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.PythonHome, $python_path,"process")
    }
}

function Restore-VirtualEnv {
    <#
    .DESCRIPTION
        Restore environment variable
    
    .PARAMETER Name

    .OUTPUTS 
        None.
    #>

    [OutputType([Void])]

    Param ()

    # restore environment path
    $env_path = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.OldVenvPath, "process")
    if ($env_path) {
        [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.OldVenvPath, $Null,"process")
        [System.Environment]::SetEnvironmentVariable("PATH", $env_path, "process")
    }
    [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.PythonHome, $PSVirtualEnv.Python,"process")

    # emtpy the name of the virtual environment
    [System.Environment]::SetEnvironmentVariable($PSVirtualEnv.VenvPath, $Null ,"process")

    $old_venv = [System.Environment]::GetEnvironmentVariable("VIRTUAL_ENV_OLD", "process")
    if($old_venv) {
        [System.Environment]::SetEnvironmentVariable("VIRTUAL_ENV_OLD", $Null, "process")
        Set-VirtualEnv -Name $old_venv
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvPath {

    <#
    .DESCRIPTION
        Get the absolute path of a virtual environment, which is composed of the predefined system variable and a specified virtual environment
    
    .PARAMETER Name

    .OUTPUTS 
        System.String. Absolute path of a specified virtual environment
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    return Join-Path -Path $PSVirtualEnv.WorkDir -ChildPath $Name
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualPython {

    <#
    .DESCRIPTION
        Get the absolute path of the executable of a specified virtual environment, which is composed of the predefined system variable, a specified virtual environment and the fixed location of the executable
    
    .PARAMETER Name

    .OUTPUTS 
        System.String. Absolute path of the executable of a specified virtual environment
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    return Join-Path -Path (Get-VirtualEnvPath -Name $Name) -ChildPath $PSVirtualEnv.VirtualEnv 
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvActivationScript {

    <#
    .DESCRIPTION
        Get the absolute path of the activation sript of a specified virtual environment, which is composed of the predefined system variable, a specified virtual environment and the fixed location of the executable
    
    .PARAMETER Name

    .OUTPUTS 
        System.String. Absolute path ofthe activation sript a specified virtual environment
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    return Join-Path -Path (Get-VirtualEnvPath -Name $Name) -ChildPath $PSVirtualEnv.Activation
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvLocalDir {

    <#
    .DESCRIPTION
        Get the absolute path of the download directory of a virtual environment.
    
    .PARAMETER Name

    .OUTPUTS 
        Get the absolute path of the download directory of a virtual environment
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    return  Join-Path -Path $PSVirtualEnv.LocalDir -ChildPath $Name
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-PythonVersion() {
    
    <#
    .DESCRIPTION
        Retrieve the python version of a given python distribution.
    
    .PARAMETER Path

    .OUTPUTS
        Int. The version of the detected python distribution.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Int])]

    Param(
        [Parameter(Position=1, Mandatory=$True, HelpMessage="Path to a folder or executable of a python distribution.")]
        [System.String] $Path
    )

    # get the version of a given python distribution
    $Path = Find-Python $Path
    if (-not $Path) { return }
    $pythonVersion = . $Path --version 2>&1
    write-host $pythonVersion
    # check the compatibility of the detected python version 
    $pythonVersion2 = ($pythonVersion -match "^Python\s2") -or ($pythonVersion -match "^Python\s3.3")
    $pythonVersion3 = $pythonVersion -match "^Python\s3" -and -not $pythonVersion2
    if (-not $pythonVersion2 -and -not $pythonVersion3) {
        if ($VerbosePreference) {
            Write-FormattedError -Message "This module is not compatible with the detected python version $pythonVersion" -Module $PSVirtualEnv.Name
        }
        return $Null
    }

    # return the version of the detected python distribution.
    return $(if ($pythonVersion2) {"2"} else {"3"})
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ActiveVirtualEnv {

    <#
    .DESCRIPTION
        Detects activated virtual environments.

    .OUTPUTS 
       Boolean. True if the specified virtual environment is running, respectivly false if it is not activated.
    #>
    
    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Boolean])]

    Param()
    
    $virtual_env = [System.Environment]::GetEnvironmentVariable($PSVirtualEnv.VenvPath, "process")

    if ($virtual_env -and $(Test-Path -Path $virtual_env)) {
        return Split-Path -Path $virtual_env -Leaf
    }

    return $Null
}
