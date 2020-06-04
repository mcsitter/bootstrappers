# Validation
function Test-Elevated {
    $myIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $myPrincipal = New-Object System.Security.Principal.WindowsPrincipal ($myIdentity)
    return $myPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(Test-Elevated)) {
    Write-Host "Not running as Administrator"
    exit
}

# Install Chocolatey
if (!(Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    $chocoInstaller = Invoke-WebRequest "https://chocolatey.org/install.ps1" -UseBasicParsing
    Invoke-Expression $chocoInstaller

    # Make `refreshenv` available right away, by defining the $env:ChocolateyInstall variable
    # and importing the Chocolatey profile module.
    $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).path)\..\.."
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

    RefreshEnv.cmd
} else {
    $chocoVersion = choco --version
    Write-Host "chocolatey v$chocoVersion already installed."
}
