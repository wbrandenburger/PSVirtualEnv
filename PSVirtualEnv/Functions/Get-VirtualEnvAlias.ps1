# ==============================================================================
#   Get-VirtualEnvAlias.ps1 ----------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Get-VirtualEnvAlias {

    <#
    .SYNOPSIS
        Displays the aliases of the module.

    .DESCRIPTION
        Displays the aliases of the module.

    .EXAMPLE
        PS C:\> Get-VirtualEnvAlias

        CommandType     Name                            Version    Source
        -----------     ----                            -------    ------
        Alias           lsvenv -> Get-VirtualEnv        1.0.0      PSVirtualEnv
        Alias           mkvenv -> New-VirtualEnv        1.0.0      PSVirtualEnv        
    .INPUTS
        None.
    
    .OUTPUTS
        PSCustomObject. The object contains all aliases of the module
    #>

    [CmdletBinding()]

    [OutputType([PSCustomObject])]

    Param(
    )

    Process{
        
        # return all aliases of the module
        return Get-Alias | Where-Object {$_.Source -eq $PSVIRTUALENV}

    }
}

#   alias ----------------------------------------------------------------------
# ------------------------------------------------------------------------------
Set-Alias -Name aliasvenv -Value Get-VirtualEnvAlias