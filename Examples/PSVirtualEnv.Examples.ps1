# ===========================================================================
#   PSVirtualEnv.Examples.ps1 --------------------------------------------------
# ===========================================================================

#   settings -------------------------------------------------------------------
# ---------------------------------------------------------------------------

    # install necessary powershell modules
    if (-not (Get-Module -Name PSVirtualEnv)) {
        Write-Host "SUCCESS: Module PSVirtualEnv exists" -ForegroundColor Green
        Import-Module PSVirtualEnv
    } 

    # path of example files
    $examplePath = "A:\VirtualEnv\.example"

#   examples -------------------------------------------------------------------
# ---------------------------------------------------------------------------

    # Create virtual environments
    $Outout = New-VirtualEnv -Name "test-normal"

    Get-VirtualEnv -Name "test-normal"

    $OutPut = New-VirtualEnv -Name "test-online" -Requirement (Join-Path -Path $examplePath -ChildPath "test-pkg.txt")

    Get-VirtualEnv -Name "test-online"

    $OutPut = New-VirtualEnv -Name "test-offline" -offline -Requirement (Join-Path -Path $examplePath -ChildPath "test-pkg\test-pkg.txt")

    Get-VirtualEnv -Name "test-offline"

    # Get virtual environments in default virtual environment path
    Get-VirtualEnv

    # Start and stop a virtual environment
    Start-VirtualEnv -Name "test-normal"
    Stop-VirtualEnv

    # Download all packages from a virtual environment
    Get-VirtualEnvLocal -Name "test-online" 

    $OutPut = Copy-VirtualEnvLocal -Name "test-online" -Path (Join-Path -Path $examplePath -ChildPath "test-online")

    # Remove a virtual environment
    $OutPut = Remove-VirtualEnv -Name "test-normal"
    $OutPut = Remove-VirtualEnv -Name "test-online"
    $OutPut = Remove-VirtualEnv -Name "test-offline"

    Get-VirtualEnv
