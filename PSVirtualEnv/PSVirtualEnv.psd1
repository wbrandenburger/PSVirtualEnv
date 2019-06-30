# ==============================================================================
#   PSVirtualEnv.psd1 ----------------------------------------------------------
# ==============================================================================

@{

# Script module or binary module file associated with this manifest.
RootModule = 'PSVirtualEnv'

# Version number of this module.
ModuleVersion = '0.2.3'

# ID used to uniquely identify this module
GUID = '41a9e505-d878-4b65-a8bf-b90bd2f2ddf6'

# Author of this module
Author = 'Wolfgang Brandenburger'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = '   
    # Copyright (c) 2017 Regis Floret
    # Copyright (c) 2019 Wolfgang Brandenburger

    # Permission is hereby granted, free of charge, to any person obtaining a copy
    # of this software and associated documentation files (the "Software"), to deal
    # in the Software without restriction, including without limitation the rights
    # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    # copies of the Software, and to permit persons to whom the Software is
    # furnished to do so, subject to the following conditions:
    # The above copyright notice and this permission notice shall be included in all
    # copies or substantial portions of the Software.
'

# Description of the functionality provided by this module
Description = '        The module PSVirtualEnv is a set of powershell extensions to Ian Bickings virtualenv tool in python. The module includes wrappers for creating and deleting virtual environments and otherwise managing your development workflow, making it easier to work on more than one project at a time without introducing conflicts in their dependencies.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '3.0'

# Name of the Windows PowerShell host required by this module
PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
ProcessorArchitecture = 'None'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(
    @{
        ModuleName = "PSIni"; 
        ModuleVersion = "3.1.2"; 
    }
)

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @()

# Functions to export from this module
FunctionsToExport = @(
    'Clear-VirtualEnvLocal'
    'Get-VirtualEnv',
    'Get-VirtualEnvAlias',
    'Get-VirtualEnvLocal',
    'Get-VirtualEnvRequirement'
    'Get-VirtualEnvSupplement'
    'Install-VirtualEnvPckg'
    'New-VirtualEnv',
    'Remove-VirtualEnv',
    'Remove-VirtualEnvRequirement'
    'Set-VirtualEnvLocation'
    'Start-VirtualEnv',
    'Stop-VirtualEnv'
    'Test-VirtualEnv',
    'Find-Python'
)

# Cmdlets to export from this module
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module
AliasesToExport = @(
    'cdvenv'
    'rmvenv',
    'lsvenv',
    'mkvenv'
    'runvenv'
    'stvenv'
)

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
ModuleList = @()

# List of all files packaged with this module
FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @(
            'virtualenvs',
            'virtualenvwrapper',
            'virtualenv-manager',
            'python',
            'powershell',
            'windows'
        )

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/wbrandenburger/PSVirtualEnv'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/wbrandenburger/PSVirtualEnv'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
