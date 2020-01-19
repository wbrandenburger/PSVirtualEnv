# ===========================================================================
#   ModuleValidation.ps1 ----------------------------------------------------
# ===========================================================================

#   import ------------------------------------------------------------------
# ---------------------------------------------------------------------------
using namespace System.Management.Automation

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVirtualEnv : IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVirtualEnvDirectories)
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVenvLocalDirs: IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVenvLocalDirs)
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVenvSearchDirs: IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVirtualEnvSearchDirs)
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVenvTemplates: IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVirtualEnvTemplates)
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVenvRequirements: IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVirtualEnvFiles -Type "Requirement")
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVenvRequirementsFolder: IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVirtualEnvFiles -Type "Requirement" -Folder)
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVenvScripts: IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVirtualEnvFiles -Type "Script")
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVenvScriptsFolder: IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVirtualEnvFiles -Type "Script" -Folder)
    }
}