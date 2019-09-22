# Change Log

## [0.5.7](https://github.com/wbrandenburger/PSVirtualEnv/tree/0.5.7) (2019-09-22)

**Implemented enhancements:**

- Moved installation of package `virtualenv` from function `Find-Python` to `Repair-Python` due to possible loops when calling other module functions.
- Added function `Repair-Python` for online and offline installation of `pip`, `setuptools` and `virtualenv`.

**Fixed bugs:**

- Deprecated parameter in function `Install-VirtualEnv` when calling function `New-Requirement` was removed.
- Parameter `-All` showed wrong behavior when calling `Install-VirtualEnv`.
- `Get-VirtualEnvLocal` set wrong environment variables, if parameter `-All` was used.

## [0.5.6](https://github.com/wbrandenburger/PSVirtualEnv/tree/0.5.6) (2019-09-21)

**Implemented enhancements:**

- Added function `Invoke-VirtualEnv` for invoking commands in a specific virtual environment.
- Enabled installation of more than one package via function `Install-VirtualEnv`
- Enabled autocompletion of folders with local binaries of python packages for offline installation via `Install-VirtualEnv`

**Fixed bugs:**

- Incorrect python path in function `Find-Python` was generated, when a virtual environment was activated.

## [0.5.5](https://github.com/wbrandenburger/PSVirtualEnv/tree/0.5.5) (2019-09-18)

**Fixed bugs:**

- Activated function `New-VirtualEnvLocal` for downloading packages of virtual environment, e.g. for offline installation.
- Added opportunity for offline installation of a folder with local packages.
- Added opportunity for offline installation of a folder with local packages, when creating a virtual environment.

## [0.5.3](https://github.com/wbrandenburger/PSVirtualEnv/tree/0.5.3) (2019-09-17)

**Fixed bugs:**

- Fixed problems when installing automatically virtualenv as well as troubles with `Get-TemporaryFile`, when installing packages.

## [0.5.2](https://github.com/wbrandenburger/PSVirtualEnv/tree/0.5.2) (2019-09-16)

**Fixed bugs:**

- Fixed problems with missing configuration file

## [0.5.1](https://github.com/wbrandenburger/PSVirtualEnv/tree/0.5.1) (2019-09-15)

**Implemented enhancements:**

- Added function `Edit-VirtualEnvConfig`.
- Referenced fields in configuration files with a reference to another fields can be evaluated.
  
## [0.5.0](https://github.com/wbrandenburger/PSVirtualEnv/tree/0.5.0) (2019-09-12)

**Implemented enhancements:**

- Added function `Edit-Requirement`.
- Added ChangeLog.

**Fixed bugs:**

- Activation of autocompletion.
- Refactoring of core functionality.
