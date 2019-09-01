# ===========================================================================
#   Get-Requirement.ps1 -----------------------------------------------------
# ===========================================================================

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVirtualEnv : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] ((Get-VirtualEnv | Select-Object -ExpandProperty Name) ,"python" ,"")
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-Requirement {

    <#
    .SYNOPSIS
        Create the requirement file of a specific virtual environment.
        
    .DESCRIPTION
        Create the requirement file of a specific virtual environment in predefined requirements folder.. All available virtual environments can be accessed by autocompletion. Flag 'All' enables the creation of requirments file for all existing virtual environments. Flag 'Upgrade' replaces in resulting requirement file '==' with '>=' for the use of upgrading packages.
    
    .PARAMETER Name

    .PARAMETER Python

    .PARAMETER All

    .PARAMETER Upgrade

    .EXAMPLE
        PS C:\>Get-Requirement -Name venv
        PS C:\>Get-RequirementContent -Requirement \venv-requirements.txt
        Click==7.0
        PS C:\>

        -----------
        Description
        Get the content of a existing requirement file in predefined requirements folder. All available virtual environments can be accessed by autocompletion.

    .EXAMPLE
        PS C:\>Get-Requirement -Name venv
        PS C:\>Get-RequirementContent -Requirement \venv-requirements.txt
        Click==7.0
        PS C:\>

        -----------
        Description
        Get the content of a existing requirement file in predefined requirements folder. All available virtual environments can be accessed by autocompletion.

    .EXAMPLE

        PS C:\>Get-Requirement -Python
        PS C:\>Get-RequirementContent -Requirement \python-requirements.txt
        virtualenv==16.7.4
        PS C:\>
 
        -----------
        Description
        Get the requirement file of the default python distribution.

    .EXAMPLE
        PS C:\>Get-Requirement -Name venv -Upgrade
        PS C:\>Get-RequirementContent -Requirement \venv-requirements.txt
        Click>=7.0
        PS C:\>

        -----------
        Description
        Get the requirement file of a existing requirement file in predefined requirements folder. Flag 'Upgrade' replaces in resulting requirement file '==' with '>=' for the use of upgrading packages.
    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param(
        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(Position=1, ValueFromPipeline=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name="",

        [Parameter(HelpMessage="If switch 'Python' is true, packages will be installed in default python distribution.")]
        [Switch] $Python,

        [Parameter(HelpMessage="If switch 'All' is true, the requirement file for all existing virtual environments will be generated.")]
        [Switch] $All,

        [Parameter(HelpMessage="If switch 'Upgrade' is true the requirement file is prepared for upgrading packages.")]
        [Switch] $Upgrade
    )

    Process {

        # check valide virtual environment 
        if ($Name -and -not $Python) {
            if ($Name -eq "python"){
                $Python=$True
            }

            if (-not(Test-VirtualEnv -Name $Name)){
                Write-FormattedError -Message "The virtual environment '$($Name)' does not exist." -Module $PSVirtualEnv.Name -Space
                Get-VirtualEnv

                return
            }

            $virtualEnv = @{ Name = $Name }
        }

        # if default python distribution shall be modified set a placeholder
        if ($Python) {
            $virtualEnv = @{ Name = "python" }
        }

        # Get all existing virtual environments if 'Name' is not set
        if ($All) {
            $virtualEnv = Get-VirtualEnv
        }

        $virtualEnv | ForEach-Object {

            # get full path of requirement file
            $requirement_file = Get-RequirementFile -Name $_.Name

            # get python distribution
            if ($Python) {
                $python_exe = Find-Python -Force
            }
            else {
                $python_exe = Get-VirtualPython -Name $_.Name
            }

            # create the requirement file of the specified virtual environment
            . $python_exe -m pip freeze > $requirement_file
            
            if ($Upgrade){
                $(Get-Content $requirement_file) -replace "==", ">=" | Out-File -FilePath $requirement_file
            }
        }
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Get-RequirementFile {

    <#
    .DESCRIPTION
        Create the requirement file of a specific virtual environment.
    
    .PARAMETER Name

    .OUTPUTS
        System.String. Full path of virtual environment requirements file.
    #>

    [CmdletBinding(PositionalBinding=$True)]

    [OutputType([Void])]

    Param(
        [Parameter(Position=1, ValueFromPipeline=$True, Mandatory=$True, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    Process {

        return Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath "$($Name)-requirements.txt" 
        
    }
}