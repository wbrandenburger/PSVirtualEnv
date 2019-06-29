# ==============================================================================
#   PythonTools.ps1 ------------------------------------------------------------
# ==============================================================================

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