# ===========================================================================
#   PSVirtualEnv_Scripts.psm1 -----------------------------------------------
# ===========================================================================

#   import ------------------------------------------------------------------
# ---------------------------------------------------------------------------
using namespace System.Management.Automation

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
