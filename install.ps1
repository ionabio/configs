#Requires -Version 7.0
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$IncludeGlazeWM,
    [string]$HomeDirectory = $HOME,
    [string]$LocalAppData = $env:LOCALAPPDATA,
    [string]$ProfilePath = $PROFILE.CurrentUserCurrentHost
)

$ErrorActionPreference = 'Stop'
$backupRoot = Join-Path $HomeDirectory ('.config-backups\' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
$files = [ordered]@{
    'wezterm/.wezterm.lua' = (Join-Path $HomeDirectory '.wezterm.lua')
    'neovim/nvim/init.lua' = (Join-Path $LocalAppData 'nvim\init.lua')
    'neovim/nvim/lazy-lock.json' = (Join-Path $LocalAppData 'nvim\lazy-lock.json')
    'ohmyposh/simple-prompt.json' = (Join-Path $HomeDirectory '.config\ohmyposh\simple-prompt.json')
    'powershell/Microsoft.PowerShell_profile.ps1' = $ProfilePath
}
if ($IncludeGlazeWM) {
    $files['glazewm/config.yaml'] = Join-Path $HomeDirectory '.glzr\glazewm\config.yaml'
}

foreach ($entry in $files.GetEnumerator()) {
    $source = Join-Path $PSScriptRoot $entry.Key
    $destination = $entry.Value
    if ((Test-Path -LiteralPath $destination) -and
        (Get-FileHash -LiteralPath $source).Hash -eq (Get-FileHash -LiteralPath $destination).Hash) {
        Write-Host "Unchanged: $($entry.Key)"
        continue
    }
    if ($PSCmdlet.ShouldProcess($destination, 'Back up existing file and install config')) {
        if (Test-Path -LiteralPath $destination) {
            $backup = Join-Path $backupRoot $entry.Key
            New-Item -ItemType Directory -Path (Split-Path $backup) -Force | Out-Null
            Copy-Item -LiteralPath $destination -Destination $backup
        }
        New-Item -ItemType Directory -Path (Split-Path $destination) -Force | Out-Null
        Copy-Item -LiteralPath $source -Destination $destination -Force
        Write-Host "Installed: $($entry.Key)"
    }
}
if (Test-Path -LiteralPath $backupRoot) {
    Write-Host "Backups: $backupRoot"
}
