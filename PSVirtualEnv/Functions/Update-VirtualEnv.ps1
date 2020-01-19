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
        [Parameter(Position=1, ValueFromPipeline, Mandatory, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name,

        [Parameter(ParameterSetName="Package", Position=2, Mandatory, HelpMessage="Specified packages will be upgraded.")]
        [System.String[]] $Package,

        [Parameter(ParameterSetName="Pip", HelpMessage="If switch 'silent' is true package pip will be upgraded in specified virtual environment.")]
        [Switch] $Pip,

        [Parameter(HelpMessage="If switch 'All' is true, the defined packages in all existing virtual environments will be changed.")]
        [Switch] $All,
    
        [Parameter(HelpMessage="If switch 'silent' is true no output will written to host.")]
        [Switch] $Silent
    )

    Process {

       # check valide virtual environment 
       if ($Name)  {
            if (-not (Test-VirtualEnv -Name $Name)){
                Write-FormattedError -Message "The virtual environment '$($Name)' does not exist." -Module $PSVirtualEnv.Name -Space -Silent:$Silent -Space 
                Get-VirtualEnv
                return
            }

            $virtual_env = @{ Name = $Name }
        }

        # get all existing virtual environments if 'Name' is not set
        if ($All) {
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
                
                # update packages from the requirement file in all defined virtual environments
                $virtual_env | ForEach-Object {
                    Install-VirtualEnvPackage -Name $_.Name -Requirement  $requirement_file -Upgrade:$Upgrade -Silent:$Silent
                }
                break;
            }
            "Pip" {
                # update pip in all defined virtual environments
                $virtual_env | ForEach-Object {       
                    Update-VirtualEnvPip -Name $Name -Silent:$Silent
                }
                break;
            }
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