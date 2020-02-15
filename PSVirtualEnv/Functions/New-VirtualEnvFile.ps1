# ===========================================================================
#   New-VirtualEnvFile.ps1 --------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function New-VirtualEnvFile {

    <#
    .SYNOPSIS
        Create a requirement or script file.
        
    .DESCRIPTION
        Create a requirement or script file in predefined folders. All available requirement and script files can be accessed by autocompletion. Flag 'All' enables the creation of requirments file for all existing virtual environments. Flag 'Upgrade' replaces in resulting requirement file '==' with '>=' for the use of upgrading packages.
    
    .PARAMETER Requirement

    .PARAMETER Script
        
    .PARAMETER Name

    .PARAMETER Extension

    .PARAMETER VirtualEnv

    .PARAMETER All

    .PARAMETER Upgrade

    .EXAMPLE
        PS C:\>New-Requirement -Name venv
        PS C:\>Get-Requirement -Requirement \venv-requirements.txt
        Click==7.0
        PS C:\>

        -----------
        Description
        Get the content of an existing requirement file in predefined requirements folder. All available virtual environments can be accessed by autocompletion.

    .EXAMPLE
        PS C:\>New-Requirement -Name venv
        PS C:\>Get-Requirement -Requirement \venv-requirements.txt
        Click==7.0

        -----------
        Description
        Get the content of an existing requirement file in predefined requirements folder. All available virtual environments can be accessed by autocompletion.

    .EXAMPLE

        PS C:\>New-Requirement -Python
        PS C:\>Get-Requirement -Requirement \python-requirements.txt
        virtualenv==16.7.4
        PS C:\>
 
        -----------
        Description
        Get the requirement file of the default python distribution.

    .EXAMPLE
        PS C:\>New-Requirement -Name venv -Upgrade
        PS C:\>Get-Requirement -Requirement \venv-requirements.txt
        Click>=7.0
        PS C:\>

        -----------
        Description
        Get the requirement file of an existing requirement file in predefined requirements folder. Flag 'Upgrade' replaces in resulting requirement file '==' with '>=' for the use of upgrading packages.

    .OUTPUTS
        None.
    #>

    [CmdletBinding(PositionalBinding, DefaultParameterSetName="Requirement")]

    [OutputType([Void])]

    Param(
        
        [ValidateSet([ValidateVenvRequirementsFolder])]
        [Parameter(ParameterSetName="Requirement", Position=0, Mandatory, ValueFromPipeline, HelpMessage="Relative path to a requirements folder.")]
        [System.String] $Requirement,

        [ValidateSet([ValidateVenvScriptsFolder])]
        [Parameter(ParameterSetName="Script", Position=0, Mandatory, ValueFromPipeline, HelpMessage="Relative path to a script files folder.")]
        [System.String] $Script,

        [Parameter(ParameterSetName="Requirement", Position=1, Mandatory, ValueFromPipeline, HelpMessage="Name of requirement file to be created.")]
        [Parameter(ParameterSetName="Script", Position=1, Mandatory, ValueFromPipeline, HelpMessage="Name of requirement or script file to be created.")]
        [System.String] $Name,

        [ValidateSet(".py",".ps1")]
        [Parameter(ParameterSetName="Script", Position=2, HelpMessage="Extension of python script file to be created.")]
        [System.String] $Extension = ".py",

        [ValidateSet([ValidateVirtualEnv])]
        [Parameter(ParameterSetName="VirtualEnv", Position=0, ValueFromPipeline, HelpMessage="Name of the virtual environment.")]
        [System.String] $VirtualEnv="",

        [Parameter(ParameterSetName="VirtualEnv", HelpMessage="If switch 'All' is true, the requirement file for all existing virtual environments will be generated.")]
        [Switch] $All,

        [Parameter(ParameterSetName="VirtualEnv", HelpMessage="If switch 'Upgrade' is true the requirement file is prepared for upgrading packages.")]
        [Switch] $Upgrade
    )

    Process {

        if ($PSCmdlet.ParameterSetName -eq "VirtualEnv" ){
            # check valide virtual environment 
            if ($VirtualEnv) {
                if (-not(Test-VirtualEnv -Name $VirtualEnv)){
                    Write-FormattedError -Message "The virtual environment '$($VirtualEnv)' does not exist." -Module $PSVirtualEnv.Name -Space
                    Get-VirtualEnv

                    return
                }

                $virtual_env = @{ Name = $VirtualEnv }
            }

            # Get all existing virtual environments if 'Name' is not set
            if ($All) {
                $virtual_env = Get-VirtualEnv
            }

            $virtual_env | ForEach-Object {

                # get full path of requirement file
                $requirement_file = Get-RequirementFile -Name $_.Name

                # create the requirement file of the specified virtual environment
                Set-VirtualEnv -Name $_.Name
                . pip freeze > $requirement_file
                Restore-VirtualEnv

                if ($Upgrade){
                    $(Get-Content $requirement_file) -replace "==", ">=" | Out-File -FilePath $requirement_file
                }

                Write-FormattedSuccess -Message "Requirement file for virtual enviroment '$($_.Name)' created." -Module $PSVirtualEnv.Name -Space
            }
        }
        else {
            switch ($PSCmdlet.ParameterSetName) {
                "Requirement" {
                    $file = $Requirement + "\" + $Name + "-requirements.txt"
                    $file_path = Join-Path -Path $PSVirtualEnv.RequireDir -ChildPath $file
                    break;
                }
                "Script" {
                    $file = $Script + "\" + $Name + $Extension
                    $file_path = Join-Path -Path $PSVirtualEnv.ScriptDir -ChildPath $file              
                    break;
                }
            }

            if (-not (Test-Path -Path $file_path)){
                [Void] (New-Item -Path $file_path -ItemType "File")

                Write-FormattedSuccess -Message "File '$file_path ' created." -Module $PSVirtualEnv.Name -Space
            }

            switch ($PSCmdlet.ParameterSetName) {
                "Requirement" {
                    Edit-VirtualEnvFile -Requirement $file
                    break;
                }
                "Script" {
                    Edit-VirtualEnvFile -Script $file       
                    break;
                }
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

    [CmdletBinding(PositionalBinding)]

    [OutputType([Void])]

    Param(
        [Parameter(Position=1, ValueFromPipeline, Mandatory, HelpMessage="Name of the virtual environment.")]
        [System.String] $Name
    )

    Process {

        return Join-Path -Path $PSVirtualEnv.LocalRequireDir -ChildPath "$($Name)-requirements.txt" 
        
    }
}
