# [PSVirtualEnv](https://github.com/wbrandenburger/PSVirtualEnv)

## Table of Contents

- [PSVirtualEnv](#psvirtualenv)
  - [Table of Contents](#table-of-contents)
  - [General](#general)
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

## General

The module PSVirtualEnv is in an experimental status and will be developed to achieve a stable version as fast as possible.

## Description

The module PSVirtualEnv is a set of PowerShell extensions to Ian Bicking’s virtualenv tool in python. The module includes wrappers for creating and deleting virtual environments and otherwise managing your development workflow, making it easier to work on more than one project at a time without introducing conflicts in their dependencies. Besides the management of virtual environments, the work with requirement files for installation, upgrade and deinstallation of packages is simplified, as well as dealing with offline installations.

### Origin

This module is an extension of [virtualenvwrapper-powershell](https://github.com/regisf/virtualenvwrapper-powershell) and adds more functionality to manage virtual environments with the PowerShell.

## Installation

PSVirtualEnv is published to the Powershell Gallery and can be installed as follows:

```powershell
Install-Module PSVirtualEnv
```

To activate PSVirtualEnv and its autocompletion there is the need to dotsource in shell or in the local profile the output of `ActivateVirtualEnvAutocompletion`:

```powershell
. (ActivateVirtualEnvAutocompletion) # or in short . (activate-env)
```

## Dependencies

PSVirtualEnv needs a Python distribution (Version >= 3) whose working directory has to be defined in environment variable `%PYTHONHOME%` or in the systems configuration file of PSVirtualEnv.

The following PowerShell module will be automatically installed:

- [PSIni](https://github.com/lipkau/PsIni)

## Settings

PSVirtualEnv creates automatically a configuration file in folder `%USERPRFOFILE%\.config\psvirtualenv`. Additionally, PSVirtualEnv search for configuration directories in environment variable `%XDG_CONFIG_HOME%` and `%XDG_CONFIG_DIRS%`. It is recommended to use across several projects a predefined configuration folder.

In configuration file the working directory of a python distribution and an user defined folder for virtual environments can be specified. The default folder for the virtual environments is `%USERPRFOFILE%\PSVirtualEnv`.

```ini
[user]

; default path where virtual environments are located (path)
venv-work-dir = A:\VirtualEnv

; default download path for python packages (path)
venv-local-dir = %(venv-work-dir)s\.temp

; default path for the requirements (path)
venv-require-dir = %(venv-work-dir)s\.require

; default python distribution (path)
python = %(PYTHONHOME)s

; default editor for opening requirement files
default-editor = code

; optional arguments for editor when opening requirement files
editor-arguments = --new-window
```

An extension of module `PSIni` enables the exploitation of a reference fields `reference-field` inside a section, which can be applied via `$(reference-field)s`. This pattern will be replaced with the value defined in `reference-field`. If the defined reference field exists not in section, system's environment variables will be evaluated and, if any, used for replacing the pattern.

The other settings in section `psvirtualenv` are not relevant to standard user.

## Available Commands

| Command                  | Alias         | Description                                                                                 |
|--------------------------|---------------|---------------------------------------------------------------------------------------------|
| `Set-VirtualEnvLocation` | `cd-venv`     | Set the location of a virtual environment in folder `venv-work-dir`.                        |
| `Install-VirtualEnv`     | `is-venv`     | Install or upgrade packages from command line or requirement files to virtual environments. |
| `Find-Python`            |               | Find a path, where a python distribution might located.                                     |
| `New-Requirement`        | `mk-venv-req` | Create the requirement file of a specific virtual environment in folder `require-work-dir`. |
| `Get-Requirement`        | `ls-venv-req` | Get the content of an existing requirement file in folder `require-work-dir`.               |
| `Get-VirtualEnvConfig`   |               | Get the content of current module config file.                                              |
| `Edit-Requirement`       | `ed-venv-req` | Edit the content of an existing requirement file in folder `require-work-dir`.              |
| `Get-VirtualEnv`         | `ls-venv`     | List all existing virtual environments in folder `venv-work-dir`.                           |
| `Get-Requirement`        | `ls-venv-req` | Get the content of an existing requirement file in folder `require-work-dir`.               |
| `New-VirtualEnv`         | `mk-venv`     | Create a virtual environment in folder `venv-work-dir`. .                                   |
| `New-Requirement`        | `mk-venv-req` | Create requirement file an existing virtual environment with current installed packages .   |
| `Remove-VirtualEnv`      | `rm-venv`     | Remove a specific virtual environment in folder `venv-work-dir`. .                          |
| `Start-VirtualEnv`       | `sa-venv`     | Start a specific virtual environment in folder `venv-work-dir`.                             |
| `Stop-VirtualEnv`        | `sp-venv`     | Stop current running virtual environment.                                                   |
| `Write-VirtualEnvStatus` | `sp-venv`     | Function to use in extensions for prompt, writing status of current virtual environment.    |

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
