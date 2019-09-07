# ===========================================================================
#   PSVirtualEnv_Scripts.psm1 -----------------------------------------------
# ===========================================================================

#   import ------------------------------------------------------------------
# ---------------------------------------------------------------------------
using namespace System.Management.Automation

$path = Join-Path -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)  -ChildPath "Modules"
Get-Childitem -Path $path -Directory | Select-Object -ExpandProperty FullName | ForEach-Object {
    Import-Module -Name $_ -Scope Local
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateRequirements: IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (Get-ValidateRequirementFiles)
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVirtualEnv : IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (Get-ValidateVirtualEnv)
    }
}
