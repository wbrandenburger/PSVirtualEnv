# ===========================================================================
#   Utils.ps1 ---------------------------------------------------------------
# ===========================================================================

#   function -----------------------------------------------------------------
# ----------------------------------------------------------------------------
function Write-PromptModuleStatus {

    <#
    .DESCRIPTION
        Generate a informartion text box with module status for the use of adjusting console prompt.

    .PARAMETER Module

    .PARAMETER Value

    .PARAMETER ModuleColor

    .PARAMETER ParenColor

    .PARAMETER ValueColor

    .OUTPUTS
        Systems.String. Informartion text box with module status.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param (

        [Parameter(Position=1, Mandatory=$True, HelpMessage="Name of module, which is the prefix when displaying module status.")]
        [System.String] $Module,

        [Parameter(Position=2, Mandatory=$True, HelpMessage="Current module status.")]
        [System.String] $Value,

        [Parameter(Mandatory=$False, HelpMessage="Color used when displaying module name.")]
        [System.String] $ModuleColor = "DarkGray",

        [Parameter(Mandatory=$False, HelpMessage="Color used when displaying parentheses around module status.")]
        [System.String] $ParenColor = "Yellow",

        [Parameter(Mandatory=$False, HelpMessage="Color used when displaying module status.")]
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

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-TemporaryFile {
    <#
    .DESCRIPTION
        Return a random file name in system's temp folder.

    .PARAMETER Extension

    .PARAMETER Directory

    .OUTPUTS
        Systems.String. Random file name.
    #>
    
    [CmdletBinding(PositionalBinding=$True)]
    
    [OutputType([System.String])]

    Param(

        [Parameter(HelpMessage="Extension of temporary file, to be created, e.g. '.json'")]
        [System.String] $Extension,

        [Parameter(HelpMessage="Return a temporary folder name.")]
        [Switch] $Directory
    )

    Process{
        
        $temp_folder = [System.IO.Path]::GetTempPath()
        
        $temp_file_path = [System.IO.Path]::GetTempFileName()
        $temp_file_name = [System.IO.Path]::GetFileNameWithoutExtension($temp_file_path)
        if ($Directory) {
            return Join-Path -Path $temp_folder -ChildPath $temp_file_name
        }
        
        if ($Extension){
            return Join-Path -Path $temp_folder -ChildPath "$($temp_file_name)$($Extension)"
        }

        return $temp_file_path
   }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-TemporaryDirectory {

    <#
    .DESCRIPTION
        Creates a folder with a random name in system's temp folder.

    .OUTPUTS
        Systems.String. Absolute path of created temporary folder.
    #>
    
    [CmdletBinding(PositionalBinding=$True)]
    
    [OutputType([System.String])]

    Param()

    $path = Get-TemporaryFile -Directory

    #if/while path already exists, generate a new path
    While(Test-Path $path) {
        $path = Get-TemporaryFile -Directory
    }

    #create directory with generated path
    New-Item -Path $path -ItemType Directory
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-TemporaryFile {

    <#
    .DESCRIPTION
        Creates a random file name in system's temp folder.

    .PARAMETER Extension

    .OUTPUTS
        Systems.String. Absolute path of created random file.
    #>
    
    [CmdletBinding(PositionalBinding=$True)]
    
    [OutputType([System.String])]

    Param(
        [Parameter(HelpMessage="Extension of temporary file, to be created, e.g. '.json'")]
        [System.String] $Extension
    )

    $path = Get-TemporaryFile -Extension $Extension

    #if/while path already exists, generate a new path
    While(Test-Path $path) {
        $path = Get-TemporaryFile -Extension $Extension
    }

    #create directory with generated path
    New-Item -Path $path -ItemType File
}

