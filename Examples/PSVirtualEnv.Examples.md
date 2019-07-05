# Examples

## Create virtual environments

### Create virtual environment without any requirements

Creates the virtual environment `test-normal`.

```PowerShell
New-VirtualEnv -Name "test-normal"      # or with
mkdir "test-normal"                     # alias
```

```
PROCESS: Creating the virtual environment 'test-normal'.
SUCCESS: Virtual environment 'A:\VirtualEnv\test-normal' was created.
```

The virtual environment `test-normal` contains only the default packages.

```PowerShell
Get-VirtualEnv -Name "test-normal"
```

```
Name       Version Independent Latest
----       ------- ----------- ------
wheel      0.33.4         True
setuptools 41.0.1         True
pip        19.1.1         True
```

### Create virtual environment with requirements to download

Creates the virtual environment `test-online`.

```PowerShell
New-VirtualEnv -Name "test-online" -Requirement -Requirement "test-pkg.txt"
```

The requirements file `test-pkg.txt` contains specification about necessary packages, which has to be downloaded.

Content of test-pkg.txt:
```
Click==7.0
```

```
Install missing packages from requirement file 'A:\VirtualEnv\.example\test-pkg.txt'.
SUCCESS: Packages from requirement file 'A:\VirtualEnv\.example\test-pkg.txt' were installed.
```

The virtual environment `test-online` contains the default packages and additionally the specified package from the requirements file.

```PowerShell
Get-VirtualEnv -Name "test-online"
```

```
Name       Version Independent Latest
----       ------- ----------- ------
setuptools 41.0.1         True
wheel      0.33.4         True
Click      7.0            True
pip        19.1.1         True
```

### Create virtual environment with requirements from local

Creates the virtual environment `test-offline`

```PowerShell
New-VirtualEnv -Name "test-offline-pkg" -Requirement ".\test-pkg\test-pkg.txt"
```

Content of directory "test-pkg":
```
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       05/07/2019     00:40          81299 Click-7.0-py2.py3-none-any.whl
-a----       05/07/2019     00:40             66 test-pkg.txt
```

The requirements file `test-pkg.txt` contains the relative path of local packages to be installed.

Content of `test-pkg.txt`:
```
Click-7.0-py2.py3-none-any.whl
```

```
Install missing packages from requirement file 'A:\VirtualEnv\.example\test-pkg\test-pkg.txt'.
SUCCESS: Packages from requirement file 'A:\VirtualEnv\.example\test-pkg\test-pkg.txt' were installed.
```

The virtual environment `test-offline` contains the default packages and additionally the specified package from the requirements file.

```PowerShell
Get-VirtualEnv -Name "test-offline"
```

```
Name       Version Independent Latest
----       ------- ----------- ------
setuptools 41.0.1         True
wheel      0.33.4         True
Click      7.0            True
pip        19.1.1         True
```

## Get virtual environments in default virtual environment path

With `Get-VirtualEnv` all existing virtual environments of the default path will be shown

```PowerShell
Get-VirtualEnv                          # or with
lsvenv                                  # alias
```

```
Name         Version Local                            Requirement
----         ------- -----                            -----------
test-normal  3.7.3
test-offline 3.7.3   A:\VirtualEnv\.temp\test-offline A:\VirtualEnv\.temp\test-offline.txt
test-online  3.7.3
```

If the name of a existing virtual environment is specified, the installed packages of this environment will be shown.

```PowerShell
Get-VirtualEnv "test-normal"           # or with
lsvenv "test-normal"                   # alias
```

```
Name       Version Independent Latest
----       ------- ----------- ------
setuptools 41.0.1         True
wheel      0.33.4         True
Click      7.0            True
pip        19.1.1         True
```

## Start and stop a virtual environment

To start the virtual environment `test-normal` use the command `Start-VirtualEnv`.

```PowerShell
Start-VirtualEnv -Name "test-normal"    # or with
runvenv "test-normal"                   # alias
```

The follwing command stops the virtual environment:

```PowerShell
Stop-VirtualEnv                         # or with
stvenv                                  # alias
```

## Download all packages from a virtual environment

Download all packages from virtual environment `test-online` to default download path for python packages defined in the configuration file

```PowerShell
Get-VirtualEnvLocal -Name "test-online"
```

This command creates a directory "test-online" in the default download path:
```
Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       05/07/2019     00:40          81299 Click-7.0-py2.py3-none-any.whl
-a----       05/07/2019     00:40             66 test-online.txt
```

The requirements file `test-online.txt` contains the relative path of local packages to be installed.

Content of `test-online.txt`:
```
Click-7.0-py2.py3-none-any.whl
```

With the following command the download files of the virtual environment `test-online`  can be copied to another location.

```PowerShell
Copy-VirtualEnvLocal -Name "test-online" -Path "G:\test-online"
```

## Remove a virtual environment

With `Remove-VirtualEnv` the specified virtual environment will be removed.

```PowerShell
Remove-VirtualEnv -Name "test-online"   # or with
rmvenv "test-online"                    # alias
```