# ==============================================================================
#   Remove-VirtualEnv.ps1 ------------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Remove-VirtualEnv  {

    <#
    .SYNOPSIS
        Removes a specific virtual environment.

    .DESCRIPTION
        Removes a specific virtual environment in the predefined system directory.

    .PARAMETER Name

    .EXAMPLE
        PS C:\> Remove-VirtualEnv -Name venv

        Removes the specified virtual environment 'venv'

    .INPUTS
        System.String. Name of virtual environment, which should be removed.
    
    .OUTPUTS
        None.
    #>

    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="None", PositionalBinding=$True)]

    [OutputType([Void])]

    Param(        
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Name of virtual environment, which should be removed.")]
        [System.String] $Name
    )

    Process{
    
        $virtualEnv = $Name
        
        # check whether the specified virtual environment exists
        if (-not (Test-VirtualEnv -Name $virtualEnv -Verbose)){
            Get-VirtualEnv
            return
        }

        # deactivation of a running virtual environment
        if (Get-ActiveVirtualEnv -Name $virtualEnv) {
            Deactivate
        }

        # get the full path of the specified virtual environment, which is located in the predefined system path
        $virtualEnvDir = Get-VirtualEnvPath -Name $virtualEnv
        
        # remove specified virtual environment
        Remove-Item -Path $virtualEnvDir -Recurse 
        Write-FormatedSuccess -Message "$virtualEnv was deleted permanently" -Space
    }
}

#   alias ----------------------------------------------------------------------
# ------------------------------------------------------------------------------
Set-Alias rmvenv Remove-VirtualEnv