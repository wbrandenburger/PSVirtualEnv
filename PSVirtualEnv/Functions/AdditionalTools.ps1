# ==============================================================================
#   AdditionalTools.ps1 --------------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Get-VirtualEnvPath {

    <#
    .SYNOPSIS
        Get the absolute path of a virtual environment

    .DESCRIPTION
        Get the absolute path of a virtual environment, which is composed of the predefined system variable and a specified virtual environment
    
    .PARAMETER Name

    .OUTPUTS 
        System.String. Absolute Path of the specified virtual environment
    #>

    [OutputType([System.String])]

    Param(
        [Parameter(Position=1, Mandatory=$True, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    return ("{0}\{1}" -f $VIRTUALENVSYSTEM, $Name)
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Get-PythonVersion() {
    
    <#
    .SYNOPSIS
        Retrieve the python version of a given python distribution.

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
            Write-FormatedError -Message "This module is not compatible with the detected python version $pythonVersion"
        }
        return $Null
    }

    # return the version of the detected python distribution.
    return $(if ($pythonVersion2) {"2"} else {"3"})
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Get-ActiveVirtualEnv {

    <#
    .SYNOPSIS
        Detects activated virtual environments.

    .DESCRIPTION
        Detects activated virtual environments.
    
    .PARAMETER Name

    .OUTPUTS 
       Boolean. True if the specified virtual environment is running, respectivly false if it is not activated.
    #>

    [OutputType([Boolean])]

    Param(
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    if ($Env:VIRTUAL_ENV) {
        if ($Name) {
            if (([System.String]$Env:VIRTUAL_ENV).EndsWith($Name)) {
                return $True
            }
            return $False;
        }
        return $True
    }

    return $False
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Write-FormatedError {

    <#
    .SYNOPSIS
        Displays a formated error message.

    .DESCRIPTION
        Stores the current system python path, such that later a restoring of that path can be applied.
    
    .PARAMETER Message

    .PARAMETER Space
    #>

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space
    )

    if ($Space) { Write-Host }
    Write-Host "ERROR: $Message" -ForegroundColor Red
    if ($Space) { Write-Host }
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Write-FormatedSuccess {
    
    <#
    .SYNOPSIS
        Displays a formated success message.

    .DESCRIPTION
        Stores the current system python path, such that later a restoring of that path can be applied.
    
    .PARAMETER Message

    .PARAMETER Space
    #>

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space
    )

    if ($Space) { Write-Host }
    Write-Host "SUCCESS: $Message" -ForegroundColor Green
    if ($Space) { Write-Host }
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function BackupPath {

    <#
    .SYNOPSIS
        Stores the current system python path.

    .DESCRIPTION
        Stores the current system python path, such that later a restoring of that path can be applied.
    #>

    [OutputType([Void])]

    Param(

    )

    $Env:PRIOR_PYTHON_PATH = $Env:PYTHONPATH
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function RestorePath {

    <#
    .SYNOPSIS
        Restores the system python path.

    .DESCRIPTION
        Restores the system python path.
    #>

    [OutputType([Void])]

    Param(

    )

    $Env:PYTHONPATH = $Env:PRIOR_PYTHON_PATH
}
