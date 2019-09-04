# ===========================================================================
#   PSVirtualEnv_Scripts.psm1 -----------------------------------------------
# ===========================================================================

#   import ------------------------------------------------------------------
# ---------------------------------------------------------------------------
$path = Join-Path -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)  -ChildPath "Modules"
Get-Childitem -Path $path -Directory | Select-Object -ExpandProperty FullName | ForEach-Object {
    Import-Module -Name $_ -Scope Local
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateRequirements: 
    System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (Get-ValidateRequirementFiles)
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVirtualEnv : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (Get-ValidateVirtualEnv)
    }
}
