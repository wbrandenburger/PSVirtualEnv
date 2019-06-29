# ==============================================================================
#   Clear-VirtualEnvLocal.ps1 --------------------------------------------------
# ==============================================================================

#   function -------------------------------------------------------------------
# ------------------------------------------------------------------------------
function Clear-VirtualEnvLocal {
    
    <#
    .SYNOPSIS
        Remove all download directories and requirement files which can not be bound to an existing virtual environment.

    .DESCRIPTION
        Remove all download directories and requirement files of the virtual environmet directory which can not be bound to an existing virtual environment.

    .EXAMPLE
        PS C:\> Clear-VirtualEnvLocal

        Download directory 'philosophy' can not be bound to an existing virtual environment.
        Requirement file 'philosophy.txt' can not be bound to an existing virtual environment.

        -----------
        Description
        Check existing download directories and requirement files which can not be bound to an existing virtual environment.

    .EXAMPLE 
        PS C:\> Clear-VirtualEnvLocal -Force

        SUCCESS: Download directory 'philosophy' was removed.
        SUCCESS: Requirement file 'philosophy.txt' was removed.

        -----------
        Description
        Remove download directories and requirement files which can not be bound to an existing virtual environment.

    .EXAMPLE 
        PS C:\> Clear-VirtualEnvLocal -Local -Force

        SUCCESS: Download directory 'philosophy' was removed.

        -----------
        Description
        Remove download directories which can not be bound to an existing virtual environment.

    .EXAMPLE 
        PS C:\> Clear-VirtualEnvLocal -Local -Force

        SUCCESS: Requirement file 'philosophy.txt' was removed.

        -----------
        Description
        Remove equirement files which can not be bound to an existing virtual environment

    .INPUTS
        None.

    .OUTPUTS
        PSCustomObject. Object with contain information about all virtual environments.

    .NOTES
    #>
    
    [CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact="Medium")]

    [OutputType([PSCustomObject])]

    Param(        
        
        [Parameter(HelpMessage="If switch 'Local' is true, only the download directories which can not be bound to an existing virtual environment will be removed.")]
        [Switch] $Local,

        [Parameter(HelpMessage="If switch 'Requirement' is true, only the requirement files which can not be bound to an existing virtual environment will be removed.")]
        [Switch] $Requirement,

        [Parameter(HelpMessage="If switch 'Force' is true, the directories and files which can not be bound to an existing virtual environment will be removed.")]
        [Switch] $Force
    )

    Process {

        # get all virtual environment directories in predefined system directory as well as the local directories and requirement files.
        $virtualEnv = Get-VirtualEnv
        $virtualEnvLocalDir = Get-ChildItem -Path $VENVLOCALDIR -Directory   
        $virtualEnvRequirement = Get-ChildItem -Path $VENVLOCALDIR -File 

        # remove all download directories which can not be bound to an virtual environment
        if (-not $Requirement) {
            $virtualEnvLocalDir | ForEach-Object {
                if (-not ($_ -in $virtualEnv.Name)){
                    if ($Force) {
                        Remove-Item -Path (Join-Path -Path $VENVLOCALDIR -ChildPath $_) -Recurse
                        Write-FormatedSuccess -Message "Download directory '$_' was removed."
                    }
                    else {
                        Write-FormatedMessage -Message "Download directory '$_' can not be bound to an existing virtual environment." -Color Yellow
                    }
                }
            }
        }

        # remove all requirement files which can not be bound to an virtual environment
        if (-not $Local) {
            $virtualEnvRequirement | ForEach-Object {
                if (-not (($_ -replace ".txt", "") -in $virtualEnv.Name)){
                    if ($Force)  {
                        Remove-Item -Path (Join-Path -Path $VENVLOCALDIR -ChildPath $_)
                        Write-FormatedSuccess -Message "Requirement file '$_' was removed."
                    }
                    else {              
                        Write-FormatedMessage -Message "Requirement file '$_' can not be bound to an existing virtual environment." -Color Yellow
                    }
                }
            }
        }

        return $virtualEnv
    }   
}