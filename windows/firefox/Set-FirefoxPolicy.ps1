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

# Set Firefox policy
$firefoxPolicy = Get-Content -Path (Join-Path $PSScriptRoot "policies.json") -Raw
$firefoxPolicyTarget = 'C:\Program Files\Mozilla Firefox\distribution\policies.json'
New-Item $firefoxPolicyTarget -ItemType "file" -Value $firefoxPolicy -Force
