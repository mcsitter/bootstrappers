# Install VSCode extensions
$extensionsFile = Join-Path $PSScriptRoot "extensions.json"
$extensions = Get-Content $extensionsFile | ConvertFrom-Json
foreach ($extension in $extensions) {
    code --install-extension $extension
}

# Set VSCode settings
# $vscodeSettings = Get-Content -Path (Join-Path $PSScriptRoot "settings.json") -Raw
# $vscodeSettingsTarget = Join-Path $env:APPDATA  "Code\User\settings.json"
# New-Item $vscodeSettingsTarget -ItemType "file" -Value $vscodeSettings -Force
