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

# Debloat System
# See https://github.com/Sycnex/Windows10Debloater for more info
$debloatScript = Invoke-WebRequest 'https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10SysPrepDebloater.ps1' -UseBasicParsing
Invoke-Expression $debloatScript

# Rename windows drive
Write-Host "Renaming windows drive"
$WindowsDrive = Get-Volume -DriveLetter $Env:SystemDrive[0]
$WindowsName = (Get-WmiObject win32_operatingsystem).Caption
if (-Not ($WindowsDrive.FileSystemLabel -eq $WindowsName)) {
    Set-Volume -InputObject $WindowsDrive -NewFileSystemLabel  $WindowsName
}

# Install Chocolatey
if (!(Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    $chocoInstaller = Invoke-WebRequest "https://chocolatey.org/install.ps1" -UseBasicParsing
    Invoke-Expression $chocoInstaller
} else {
    $chocoVersion = choco --version
    Write-Host "chocolatey v$chocoVersion already installed."
}

# Make `refreshenv` available right away, by defining the $env:ChocolateyInstall variable
# and importing the Chocolatey profile module.
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).path)\..\.."
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

refreshenv

# Install Git
if (!(Get-Command "git.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Git"
    choco install -y git --params="'/GitAndUnixToolsOnPath /NoShellIntegration'"

    refreshenv
} else {
    Write-Host "git already installed."
}

# Clone repository
$sourceDirectory = Join-Path $HOME "Source\"
$bootstrappersDirectory = Join-Path $HOME "Source\bootstrappers"
if (!(Test-Path $sourceDirectory)) {
    Write-Host "Cloning repository into $bootstrappersDirectory"
    $null = New-Item $sourceDirectory  -ItemType Directory
    Push-Location $sourceDirectory
    git clone https://github.com/mcsitter/bootstrappers.git
    Pop-Location
} else {
    Write-Host "Pulling repository in $bootstrappersDirectory"
    Push-Location $bootstrappersDirectory
    git pull
    Pop-Location
}

# Install Software
$installScript = Join-Path $bootstrappersDirectory "windows\install.ps1"
Write-Host "Running software install script"
Invoke-Expression $installScript

refreshenv

# Set Firefox policies
$firefoxScript = Join-Path $bootstrappersDirectory "windows\firefox\Set-FirefoxPolicy.ps1"
Write-Host "Setting Firefox policies"
Invoke-Expression $firefoxScript

# Initialize VSCode
$vscodeScript = Join-Path $bootstrappersDirectory "windows\vscode\Initialize-VSCode.ps1"
Write-Host "Initializing VSCode"
Invoke-Expression $vscodeScript

# Remove desktop shortcuts
Write-Host "Removing desktop shortcuts"
Remove-Item "C:\Users\*\Desktop\*.lnk" -Force   
