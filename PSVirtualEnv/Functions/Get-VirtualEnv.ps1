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

    .INPUTS
        None.

    .OUTPUTS
        PSCustomObject. Object with contain information about all virtual environments (name, version).

    .NOTES
    #>

    [CmdletBinding()]

    [OutputType([PSCustomObject])]

    Param (
    )

    Process {
        #   get all virtual environment directories in predefined system directory
        $virtualEnvSubDirs = Get-ChildItem $VIRTUALENVSYSTEM
        $virtualEnvs = $Null

        #   call the python distribution of each virtual environnment and determine the version number
        if ($VirtualEnvSubDirs.length) {
            $virtualEnvs= $VirtualEnvSubDirs | ForEach-Object {
                [PSCustomObject]@{
                    Name = $_
                    Version = (((. (Join-Path -Path (Get-VirtualEnvPath -Name $_) -ChildPath "Scripts\Python.exe") --version 2>&1) -replace "`r|`n","") -split " ")[1]
                }
            }

        } else {
            Write-FormatedError -Message "In predefined system directory do not exist any virtual environments" -Space
        }

        #   return information of all detected virtual environments
        return $virtualEnvs
    }
}

#   alias ----------------------------------------------------------------------
# ------------------------------------------------------------------------------
Set-Alias lsvenv Get-VirtualEnv