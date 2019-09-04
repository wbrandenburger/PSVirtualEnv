# ============================================================================
#   Utils.ps1 ----------------------------------------------------------------
# ============================================================================

#   function -----------------------------------------------------------------
# ----------------------------------------------------------------------------
function Write-PromptModuleStatus {

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param (

        [Parameter(Position=1, Mandatory=$True)]
        [System.String] $Module,

        [Parameter(Position=2, Mandatory=$True)]
        [System.String] $Value,

        [Parameter(Mandatory=$False)]
        [System.String] $ModuleColor = "DarkGray",

        [Parameter(Mandatory=$False)]
        [System.String] $ParenColor = "Yellow",

        [Parameter(Mandatory=$False)]
        [System.String] $ValueColor = "Cyan"

    )
    
    Process{

        If ($Value) {       
            Write-Host $Module -NoNewline -ForegroundColor $ModuleColor
            Write-Host "["  -NoNewline -ForegroundColor $ParenColor
            Write-Host  $Value -NoNewline -ForegroundColor $ValueColor
            Write-Host  "]" -NoNewline -ForegroundColor $ParenColor
        }
    }
}

#   function -----------------------------------------------------------------
# ------------------------------------------------------------------------
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
