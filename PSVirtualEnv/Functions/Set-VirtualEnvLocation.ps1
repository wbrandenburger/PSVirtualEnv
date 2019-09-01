# ===========================================================================
#   Set-VirtualEnvLocation.ps1 ----------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Set-VirtualEnvLocation {

    <#
    .SYNOPSIS
        Set the location of the predefined virtual environment directory.

    .DESCRIPTION
        Set the location of the predefined virtual environment directory.

    .EXAMPLE
        PS C:\> Set-VirtualEnvLocation
        PS C:\VirtualEnv\>

        -----------
        Description
        Set the location of the predefined virtual environment directory.

    .INPUTS
        None.
    
    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param()

    Process{
        
        # set location of virtual env wokring directory
        Set-Location -Path $PSVirtualEnv.WorkDir

    }
}
