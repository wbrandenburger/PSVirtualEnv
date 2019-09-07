# ===========================================================================
#   Get-Validation.ps1 ------------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ValidateVirtualEnv {

    <#
    .DESCRIPTION
        Return values for the use of validating existing
    
    .OUTPUTS
        System.String[]. Virtual environments
    #>

    [CmdletBinding(PositionalBinding=$True)]
    
    [OutputType([System.String[]])]

    Param()

    Process{

       return (Get-VirtualEnvWorkDir | Select-Object -ExpandProperty Name)
    
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-ValidateRequirementFiles {

    <#
    .DESCRIPTION
        Return values for the use of validating existing requirement files.
    
    .OUTPUTS
        System.String[]. Requirement files
    #>

    [CmdletBinding(PositionalBinding=$True)]
    
    [OutputType([System.String[]])]

    Param()

    Process{
        $file_list = (Get-ChildItem -Path $PSVirtualEnv.RequireDir -Include "*requirements.txt" -Recurse).FullName
        return ($file_list | ForEach-Object {
            $_ -replace ($PSVirtualEnv.RequireDir -replace "\\", "\\")})
    
    }
}



