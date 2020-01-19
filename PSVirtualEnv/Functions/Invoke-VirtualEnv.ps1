# ===========================================================================
#   Invoke-VirtualEnv.ps1 ---------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Invoke-VirtualEnv {
    <#
    .SYNOPSIS
        Runs commands in a specified virtual environment.

    .DESCRIPTION
        The function runs commands  in a specified virtual environment and returns all output from the commands, including errors

    .PARAMETER Name

    .PARAMETER ArgumentList

    .PARAMETER Silent

    .EXAMPLE
        PS C:\> Invoke-VirtualEnv -Name venv -ArgumentList 'papis', 'config', 'dir'
        C:\Users\User\pocs

        -----------
        Description
        Runs command 'papis' with arguments 'config' and 'dir' in virtual environment 'venv'.

    .EXAMPLE
        PS C:\> Invoke-VirtualEnv -Name venv -ScriptBlock {papis config dir}
        C:\Users\User\pocs

        -----------
        Description
        Runs scriptblock '{papis config dir}'.

    .INPUTS
        Name. Name of the virtual environment.
    
    .OUTPUTS
        None.
    #>
    
    [CmdletBinding(PositionalBinding, DefaultParameterSetName="ArgumentList")]

    [OutputType([Void])]

    Param(

        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=1, ValueFromPipeline, Mandatory, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name,

        [Parameter(ParameterSetName="ArgumentList", Position=2, Mandatory,  HelpMessage="Specifies parameters or parameter values to use when this cmdlet starts the process. If parameters or parameter values contain a space, they need surrounded with escaped double quotes.")]
        [System.String[]] $ArgumentList,

        [ValidateSet([ValidateVenvScripts])]
        [Parameter(ParameterSetName="Script", Position=2, ValueFromPipeline, HelpMessage="Relative path to a script file in predefined scripts folder.")]
        [System.String] $Script,

        [Parameter(ParameterSetName="Script", Position=3, ValueFromPipeline, HelpMessage="Specifies parameters or parameter values to use when this cmdlet starts the process. If parameters or parameter values contain a space, they need surrounded with escaped double quotes.")]
        [System.String] $ScriptArgumentList,

        [Parameter(ParameterSetName="ScriptBlock", Position=2, HelpMessage="Specifies the commands to run. Enclose the commands in braces ( { } ) to create a script block.")]
        [ScriptBlock] $ScriptBlock,

        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    Process{

        Start-VirtualEnv -PrivateName $Name -Silent

        switch ($PSCmdlet.ParameterSetName) {
            "ArgumentList" {
                $script_array =  $ArgumentList
                break;
            }
            "Script" {
                # get existing python script file 
                $script_file = Join-Path -Path $PSVirtualEnv.ScriptDir -ChildPath $Script
                
                if ($Script -match "[^\.].py$"){
                    $script_array = @("python", $script_file) + $ScriptArguments
                } else {
                    $script_array= @("." , $script_file) + $ScriptArguments
                }

                break;
            }
        }

        if ($PSCmdlet.ParameterSetName -ne "ScriptBlock"){
            $ScriptBlock = [ScriptBlock]::Create($(Get-ArgumentList -ArgumentList $script_array))
        }

        if ($Silent) {
            $ScriptBlock.Invoke() 2>&1> $Null
        } else {
            $ScriptBlock.Invoke()
        }

        Stop-VirtualEnv -Silent
    }
}