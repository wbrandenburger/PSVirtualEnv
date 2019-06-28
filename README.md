# [PSVirtualEnv](https://github.com/wbrandenburger/PSVirtualEnv)

## Table of Contents

- [PSVirtualEnv](#PSVirtualEnv)
  - [Table of Contents](#Table-of-Contents)
  - [Description](#Description)
    - [Origin](#Origin)
  - [Installation](#Installation)
  - [Examples](#Examples)
  - [Authors/Contributors](#AuthorsContributors)
    - [Author](#Author)

## Description

The module PSVirtualEnv is a set of powershell extensions to Ian Bicking’s virtualenv tool in python. The module includes wrappers for creating and deleting virtual environments and otherwise managing your development workflow, making it easier to work on more than one project at a time without introducing conflicts in their dependencies.

### Origin

This code is an extension of [virtualenvwrapper-powershell](https://github.com/regisf/virtualenvwrapper-powershell)

## Installation

The folder PSVirtualEnv has to be added to the directories of the system, where powershell search for modules.

Change the fields in file 'PSVirtualEnv.ini', pointing to existing locations:

```ini
[settings]
; default path where virtual environments are located
dir-virtualenv = "A:\OneDrive\Projects\VirtualEnv"
; default python distribution
python-exe = "C:\Python\Python37\python.exe"
; default virtual environment package manager
package-virtualenv = "virtualenv"
```

## Examples

## Authors/Contributors

### Author

- [Wolfgang Brandenburger](https://github.com/wbrandenburger)

