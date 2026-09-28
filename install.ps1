#Requires -Version 7.0
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$IncludeGlazeWM,
    [switch]$SkipPrerequisiteCheck,
    [string]$HomeDirectory = $HOME,
    [string]$LocalAppData = $env:LOCALAPPDATA,
    [string]$ProfilePath = $PROFILE.CurrentUserCurrentHost
)

$ErrorActionPreference = 'Stop'
if (-not $SkipPrerequisiteCheck) {
    $issues = @(& (Join-Path $PSScriptRoot 'check-prerequisites.ps1'))
    foreach ($issue in $issues) { Write-Warning $issue.Message }
    if ($issues.Level -contains 'Error') {
        throw 'Prerequisite check failed. Install the required tools above, then rerun install.ps1. No config files were changed.'
    }
    Write-Host 'Required tools and versions: OK'
}
if ($env:NVIM_APPNAME -or $env:XDG_CONFIG_HOME) {
    throw 'Custom NVIM_APPNAME or XDG_CONFIG_HOME is set. This installer targets the standard Windows Neovim directory; unset these variables before installing.'
}
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

# Check every source before making any changes.
foreach ($source in $files.Keys) {
    if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot $source) -PathType Leaf)) {
        throw "Missing source file: $source. Update or repair this checkout before installing."
    }
}

# init.vim and init.lua cannot coexist. Preserve the former outside the config
# directory before removing only that exact file; never delete the config tree.
$conflict = Join-Path $LocalAppData 'nvim\init.vim'
if ((Test-Path -LiteralPath $conflict) -and $PSCmdlet.ShouldProcess($conflict, 'Back up and remove conflicting init.vim')) {
    $conflictBackup = Join-Path $backupRoot 'neovim\nvim\init.vim'
    New-Item -ItemType Directory -Path (Split-Path $conflictBackup) -Force | Out-Null
    Copy-Item -LiteralPath $conflict -Destination $conflictBackup
    if ((Get-FileHash -LiteralPath $conflict).Hash -ne (Get-FileHash -LiteralPath $conflictBackup).Hash) {
        throw 'init.vim backup verification failed; original was preserved.'
    }
    Remove-Item -LiteralPath $conflict
    Write-Host 'Backed up conflicting init.vim'
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
