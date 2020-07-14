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

# Install packages
$chocoConfigDirectory = Join-Path $PSScriptRoot "chocolatey\"
Push-Location $chocoConfigDirectory
foreach ($chocoConfig in Get-ChildItem) {
    choco install -y $chocoConfig
}
Pop-Location
