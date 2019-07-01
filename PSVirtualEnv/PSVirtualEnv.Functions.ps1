# ==============================================================================
#   PSVirtualEnv.Functions.ps1 -------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Write-FormatedProcess {

    <#
    .DESCRIPTION
        Displays a formated process message.

    .PARAMETER Message

    .PARAMETER Space

    .OUTPUTS
        None.
    #>

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space
    )

    if ($Space) { Write-Host }
    Write-Host "PROCESS: $Message" -ForegroundColor Yellow
    if ($Space) { Write-Host }
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Write-FormatedError {

    <#
    .DESCRIPTION
        Displays a formated error message.

    .PARAMETER Message

    .PARAMETER Space

    .OUTPUTS
        None.
    #>

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space
    )

    if ($Space) { Write-Host }
    Write-Host "ERROR: $Message" -ForegroundColor Red
    if ($Space) { Write-Host }
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Write-FormatedSuccess {
    
    <#
    .DESCRIPTION
        Displays a formated success message.
    
    .PARAMETER Message

    .PARAMETER Space

    .OUTPUTS
        None.
    #>

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space
    )

    if ($Space) { Write-Host }
    Write-Host "SUCCESS: $Message" -ForegroundColor Green
    if ($Space) { Write-Host }
}

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Write-FormatedMessage {
    
    <#
    .DESCRIPTION
        Displays a formated message.
    
    .PARAMETER Message

    .PARAMETER Color

    .PARAMETER Space

    .OUTPUTS
        None.
    #>

    [OutputType([Void])]

    Param(
        [Parameter(HelpMessage="Message, which should be displayed.")]
        [System.String] $Message,

        [Parameter(HelpMessage="Color of the message to be displayed.")]
        [System.String] $Color="White",

        [Parameter(HelpMessage="If Space is true, spaces will be displayed.")]
        [Switch] $Space
    )

    if ($Space) { Write-Host }
    Write-Host "$Message" -ForegroundColor $Color
    if ($Space) { Write-Host }
}
