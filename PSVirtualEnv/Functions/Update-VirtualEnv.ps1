# ===========================================================================
#   Update-VirtualEnv.ps1 ---------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Update-VirtualEnv {

    <#
    .SYNOPSIS
        Upgrade packages in specified virtual environments.
        
    .DESCRIPTION
        Upgrade packages in specified virtual environments.

    .PARAMETER Name

    .PARAMETER Requirement

    .PARAMETER Package

    .PARAMETER Pip

    .PARAMETER All

    .PARAMETER Silent

    .INPUTS
        System.String. Name of existing virtual environment.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding, DefaultParameterSetName="Package")]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=0, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name,

        [ValidateSet([ValidateVenvRequirements])]
        [Parameter(ParameterSetName="Requirement", Position=1, HelpMessage="Relative path to a requirements file in predefined requirements folder.")]
        [System.String] $Requirement,

        [Parameter(ParameterSetName="Package", Position=1, Mandatory, HelpMessage="Specified packages will be upgraded.")]
        [System.String[]] $Package,

        [Parameter(ParameterSetName="Pip", HelpMessage="If switch 'silent' is true package pip will be upgraded in specified virtual environment.")]
        [Switch] $Pip,

        [Parameter(HelpMessage="If switch 'Dev' is true, specified packages will be reinstalled.")]
        [Switch] $Dev,

        [Parameter(HelpMessage="If switch 'All' is true, the defined packages in all existing virtual environments will be changed.")]
        [Switch] $All,
    
        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    Process {

        if ($Name)  {
            $virtual_env = @{ Name = $Name }
        }
        else {
            # get all existing virtual environments if 'Name' is not set
            $virtual_env = Get-VirtualEnv
        }

        # update specified packages in all defined virtual environments
        switch ($PSCmdlet.ParameterSetName) {
            "Package" { 
                # create a valide requirement file for a specified package
                $requirement_file = New-TemporaryFile -Extension ".txt"

                if ($package.Count -eq 1) {
                    $package = $package -split "," | Where-Object { $_}
                }
                $package | Out-File -FilePath $requirement_file
                
                break
            }
            "Requirement" {
                # get existing requirement file 
                $requirement_file = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $Requirement
                break
            }
            "Pip" {
                # update pip in all defined virtual environments
                $virtual_env | ForEach-Object {       
                    Update-VirtualEnvPip -Name $_.Name -Silent:$Silent
                }
                return
            }
        }  

        # update packages from the requirement file in all defined virtual environments
        $virtual_env | ForEach-Object {
            Install-VirtualEnvPackage -Name $_.Name -Requirement  $requirement_file -Upgrade:$True -Dev:$Dev -Silent:$Silent
          
        }
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Update-VirtualEnvPip {

    <#
    .SYNOPSIS
        Upgrade package pip in specified virtual environments.
        
    .DESCRIPTION
        Upgrade packages in specified virtual environments.

    .PARAMETER Name

    .PARAMETER Silent

    .INPUTS
        System.String. Name of existing virtual environment.

    .OUTPUTS
        None.
    #>    

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(

        [Parameter(Position=1, ValueFromPipeline, Mandatory, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name,

        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent

    )

    Write-FormattedProcess -Message "Try to upgrade package pip in virtual environment '$Name'." -Module $PSVirtualEnv.Name -Silent:$Silent

    Set-VirtualEnv -Name $Name

    # install packages from a requirement file
    if ($Silent) {
        python -m pip install --upgrade pip 2>&1> $Null
    } else {
        python -m pip install --upgrade pip 
    }

    Restore-VirtualEnv

    Write-FormattedSuccess -Message "Package pip was upgraded in virtual environment '$Name'." -Module $PSVirtualEnv.Name -Silent:$Silent -Space 
}