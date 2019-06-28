# ==============================================================================
#   Test-PythonPath.ps1 --------------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Find-Python {

    <#
    .SYNOPSIS
        Find a path, where a python distribution is located.

    .DESCRIPTION
        Find a path, where a python distribution is located.

    .PARAMETER Python

    .EXAMPLE
        PS C:\> Find-Python C:\Python\Python3

        C:\Python\Python3\python.exe

        -----------
        Description
        Return the path to an existing executable of a python distribution

    .EXAMPLE
        PS C:\> Find-Python C:\Python\Python3\python.exe

        C:\Python\Python3\python.exe

        -----------
        Description
        Return the path to an existing executable of a python distribution

    .INPUTS
        System.String. Path to a folder or executable of a python distribution.
    
    .OUTPUTS
        System.String. Path to an existing executable of a python distribution
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([System.String])]

    Param(        
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Path to a folder or executable of a python distribution.")]
        [System.String] $Path
    )

    Process{

        # if the specified path does not contain an executable, try to detect the standard python distribution in system path
        if (-not $Path) {
            $Path = $PYTHONEXE
            # $Path = Get-Command "python.exe" -ErrorAction SilentlyContinue  | Select-Object -ExpandProperty Source
        }
        elseif (-not $Path.EndsWith('python.exe'))
        {
            $Path = Join-Path $Path "python.exe"
        } 

        # check, whether the defined executbale does exist
        if (-not $Path -or -not (Test-Path $Path)) 
        {            
            if ($VerbosePreference) {
                Write-FormatedError -Message "The python distribution can not be located." -Space
            }
            return $Null
        }

        # return the path to an existing executable of a python distribution

        return $Path
    }
}