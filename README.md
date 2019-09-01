# [PSVirtualEnv](https://github.com/wbrandenburger/PSVirtualEnv)

## Table of Contents

- [PSVirtualEnv](#psvirtualenv)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
    - [Origin](#origin)
  - [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Settings](#settings)
  - [Available Commands](#available-commands)
  - [Examples](#examples)
    - [Creating virtual environments](#creating-virtual-environments)
    - [Working with virtual environments](#working-with-virtual-environments)
    - [Manage virtual environments](#manage-virtual-environments)
  - [Authors/Contributors](#authorscontributors)
    - [Author](#author)

## Description

The module PSVirtualEnv is a set of PowerShell extensions to Ian Bicking’s virtualenv tool in python. The module includes wrappers for creating and deleting virtual environments and otherwise managing your development workflow, making it easier to work on more than one project at a time without introducing conflicts in their dependencies.

### Origin

This module is an extension of [virtualenvwrapper-powershell](https://github.com/regisf/virtualenvwrapper-powershell) and adds more functionality to manage virtual environments with the PowerShell, especially offline installations.

## Installation

PSVirtualEnv is published to the Powershell Gallery and can be installed as follows:

```powershell
Install-Module PSVirtualEnv
```

## Dependencies

PSVirtualEnv needs a Python distribution (Version >= 3) whose working directory has to be defined in environment variable `%PYTHONHOME%` or in the systems configuration file of PSVirtualEnv.

The following PowerShell module will be automatically installed:

- [PSIni](https://github.com/lipkau/PsIni)

## Settings

PSVirtualEnv creates automatically a configuration file in folder `%USERPRFOFILE%\psvirtualenv`. Additionally, PSVirtualEnv search for configuration directories in environment variable `%XDG_CONFIG_HOME%` and `XDG_CONFIG_DIRS`. In configuration file the working directory of a python distribution and an user defined folder for virtual environment can be specified.

```ini
[settings]

; default path where virtual environments are located
venv-work-dir = "A:\VirtualEnv"

; config path of virtual environments
venv-config-dir =  "A:\VirtualEnv\.config"

; default download path for python packages
venv-local-dir =  "A:\VirtualEnv\.temp"

; default python distribution
python = "C:\Python\Python37\python.exe"
```

## Available Commands

| Command                  | Alias        | Description                                                                                 |
|--------------------------|--------------|---------------------------------------------------------------------------------------------|
| `Set-VirtualEnvLocation` | `cd-venv`    | Set the location of the predefined directory.                                               |
| `Install-VirtualEnv`     | `in-venv`    | Install or upgrade packages from command line or requirement files to virtual environments. |
| `Find-Python`            |              | Find a path, where a python distribution might located.                                     |
| `Get-Requirement`        |              | Create the requirement file of a specific virtual environment.                              |
| `Get-RequirementContent` |              | Get the content of a existing requirement file.                                             |
| `Get-VirtualEnv`         | `ls-venv`    | List all existing virtual environments in predefined directory.                             |
| `New-VirtualEnv`         | `mk-venv`    | Creates a virtual environment.                                                              |
| `Remove-VirtualEnv`      | `rm-venv`    | Removes a specific virtual environment in the predefined directory.                         |
| `Start-VirtualEnv`       | `start-venv` | Starts a specific virtual environment in the predefined directory.                          |
| `Stop-VirtualEnv`        | `stop-venv`  | Stops current running virtual environment.                                                  |

## Examples

### Creating virtual environments

Creates a virtual environment in the predefined directory and install via a requirements file project related packages. All available requirement files can be accessed by autocompletion.

```log
    PS C:\> New-VirtualEnv -Name venv -Requirement \requirements.txt

    [PSVirtualEnv]::PROCESS: Creating new virtual environment 'venv'.
    New python executable in C:\Users\User\PSVirtualEnv\venv\Scripts\python.exe
    Installing setuptools, pip, wheel...
    done.

    [PSVirtualEnv]::SUCCESS: Virtual environment 'C:\Users\User\PSVirtualEnv\venv' was created.

    [PSVirtualEnv]::PROCESS: Try to install missing packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\requirements.txt'.

    [PSVirtualEnv]::SUCCESS: Packages from requirement file 'C:\Users\User\PSVirtualEnv\.require\requirements.txt' were installed.


    Name       Version Latest
    ----       ------- ------
    package    version
    pip        19.2.3
    setuptools 41.2.0
    wheel      0.33.6
```

### Working with virtual environments

Starts and stops a specific virtual environment in the predefined directory. All available virtual environments can be accessed by autocompletion.

```log
    PS C:\> Start-VirtualEnv -Name venv

    [PSVirtualEnv]::SUCCESS: Virtual enviroment 'venv' was started.

    [venv] PS C:\>Stop-VirtualEnv

    [PSVirtualEnv]::SUCCESS: Virtual enviroment 'venv' was stopped.

    PS C:\>
```

### Manage virtual environments

Return information about all independent packages installed in the specified virtual environment and shows potentially newer versions. All available virtual environments can be accessed by autocompletion.

```log
        PS C:\> Get-VirtualEnv -Name venv

        Name       Version Latest
        ----       ------- ------
        Click      7.0
        pip        19.2.3
        setuptools 41.2.0
        wheel      0.33.6
```

## Authors/Contributors

### Author

- [Wolfgang Brandenburger](https://github.com/wbrandenburger)
