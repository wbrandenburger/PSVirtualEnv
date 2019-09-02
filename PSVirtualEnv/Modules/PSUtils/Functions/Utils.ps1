# ============================================================================
#   PowerShell-Utils.ps1 -----------------------------------------------------
# ============================================================================

#   function -----------------------------------------------------------------
# ----------------------------------------------------------------------------
function New-TemporaryDirectory {

    <#
    .DESCRIPTION
        Creates a folder with a random name in system's temp folder

    .OUTPUTS
        Systems.String. Absolute path of created temporary folder
    #>
    
    [CmdletBinding(PositionalBinding=$True)]
    
    [OutputType([System.String])]

    Param()

    $path = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())

    #if/while path already exists, generate a new path
    While(Test-Path $path) {
        $path = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
    }

    #create directory with generated path
    New-Item -Path $path -ItemType Directory 
}
