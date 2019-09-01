# [PSVirtualEnv](https://github.com/wbrandenburger/PSVirtualEnv)

## Table of Contents

- [PSVirtualEnv](#psvirtualenv)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
    - [Origin](#origin)
  - [Installation](#installation)
  - [Dependencies](#dependencies)
  - [Settings](#settings)
  - [Examples](#examples)
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

The following PowerShell modules have to be installed:

- [PSIni](https://github.com/lipkau/PsIni)

PSVirtualEnv needs a Python distribution (Version >= 3), which working directory is defined in environment variable `%PYTHONHOME%` or in the systems configuration file of PSVirtualEnv.

## Settings

PSVirtualEnv creates automatically a configuration file in folder `%USERPRFOFILE%\psvirtualenv`. In that configuration file the working directory of a python distribution and an user defined folder for virtual environment can be specified.

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

## Examples

## Authors/Contributors

### Author

- [Wolfgang Brandenburger](https://github.com/wbrandenburger)
