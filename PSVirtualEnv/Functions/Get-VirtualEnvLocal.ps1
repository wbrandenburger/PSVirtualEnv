# ===========================================================================
#   Get-VirtualEnvLocal.ps1 -------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-VirtualEnvLocal {

    <#
    .SYNOPSIS
        Download packages of a specified virtual environment.

    .DESCRIPTION
        Download packages of a specified virtual environment to a predefined local directory.
    
    .PARAMETER Name

    .PARAMETER All

    .EXAMPLE
        PS C:\>Get-VirtualEnvLocal -Name venv

        SUCCESS: Packages of virtual environment 'venv' were downloaded to 'A:\VirtualEnv\.temp\venv'.

        -----------
        Description
        Download all packages of the virtual environment 'venv' to a predefined download directory.

    .EXAMPLE
        PS C:\>Get-VirtualEnvLocal -All

        -----------
        Description
        Download all packages of each existing virtual environment to a predefined download directory.       

    .INPUTS
        System.String. Name of the virtual environment, which packages shall be downloaded.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param (
        # [ValidateSet([ValidateVirtualEnvOptional])]
        [Parameter(HelpMessage="Name of the virtual environment, which packages shall be downloaded.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If switch 'All' is true, the packages of all existing virtual environments will be generated.")]
        [Switch] $All
    )
    
    Process {
        # Get all existing virtual environments if 'Name' is not set
        $virtualEnv = @{ Name = $Name }
        if ($All -or -not $virtualEnv) {
            $virtualEnv = Get-VirtualEnv
        }

        $virtualEnvIdx = 1
        $virtualEnv | ForEach-Object {
            #  check if there exists a specific virtual environment
            if (-not (Test-VirtualEnv -Name $_.Name -Verbose)) {
                return
            }

            # set environment variable
            Set-VirtualEnv -Name $Name

            # get absolute path of requirement file and download directoy
            $requirementFile = Get-RequirementFile -Name $_.Name
            $virtualEnvLocal = Get-VirtualEnvLocalDir -Name $_.Name

            # remove the requirement file when it exists and create the respective file
            if (Test-Path $requirementFile){
                Remove-Item -Path $requirementFile -Force
            }
            Get-Requirement -Name $_.Name

            # remove a previous folder, which contains download file of packages related to a older state of the virtual environment
            if (Test-Path $virtualEnvLocal){
                Remove-Item -Path $virtualEnvLocal -Recurse 
            }

            # download the packages defined in the requirement file to the specified download directory
            Write-FormattedProcess -Message "Download packages of virtual environment '$($_.Name)' to '$virtualEnvLocal' - $virtualEnvIdx of $($virtualEnv.length) packages " -Module $PSVirtualEnv.Name
            . (Get-VirtualPython -Name $_.Name) -m pip download --requirement   $requirementFile --dest  $virtualEnvLocal 
            Write-FormattedSuccess -Message "Packages of virtual environment '$($_.Name)' were downloaded to '$virtualEnvLocal'" -Module $PSVirtualEnv.Name

            # set the pythonhome variable in scope process to the stored backup variable
            Restore-VirtualEnv

            # create the local requirement file of the specified virtual environment
            $requirementFileLocal = Join-Path -Path $virtualEnvLocal -ChildPath ($_.Name + ".txt")
            Write-FormattedProcess -Message "Write local requirement file for virtual environment '$($_.Name)' to '$requirementFileLocal' - $virtualEnvIdx of $($virtualEnv.length) packages" -Module $PSVirtualEnv.Name
            Out-File -FilePath  $requirementFileLocal -InputObject (Get-ChildItem -Path $virtualEnvLocal | Select-Object -ExpandProperty Name )
            Write-FormattedSuccess -Message "Local requirement file '$requirementFileLocal' for virtual environment '$($_.Name)' was created." -Module $PSVirtualEnv.Name
            
            # write content of local requirement file to host
            Write-Host
            Write-Host "Content of '$requirementFileLocal':" -ForeGroundColor DarkGray
            Get-Content $requirementFileLocal 

            $virtualEnvIdx += 1
        }
    }
}
