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
    Set-ExecutionPolicy Bypass -Scope Process -Force
    $chocoInstaller = Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing
    Invoke-Expression $chocoInstaller
} else {
    $chocoVersion = choco --version
    Write-Host "chocolatey v$chocoVersion already installed."
}
