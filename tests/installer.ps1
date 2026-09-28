# Tests only isolated destinations. Leaves artifacts in the reported temp directory.
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot
$scratch = Join-Path ([IO.Path]::GetTempPath()) ('terminal-config-tests-' + [guid]::NewGuid())
New-Item -ItemType Directory -Path "$scratch\Local\nvim" -Force | Out-Null
$original = 'let g:old_config = 1'
$original | Set-Content "$scratch\Local\nvim\init.vim"
$parameters = @{
    HomeDirectory = $scratch
    LocalAppData = "$scratch\Local"
    ProfilePath = "$scratch\profile.ps1"
    SkipPrerequisiteCheck = $true
}
& "$root\install.ps1" @parameters -WhatIf *> "$scratch\whatif.log"
if (-not (Test-Path "$scratch\Local\nvim\init.vim") -or (Test-Path "$scratch\.wezterm.lua")) { throw 'WhatIf changed files' }
if (Test-Path "$scratch\.config-backups") { throw 'WhatIf created backups' }
& "$root\install.ps1" @parameters *> "$scratch\install.log"
if (Test-Path "$scratch\Local\nvim\init.vim") { throw 'Conflicting init.vim remains' }
$backup = @(Get-ChildItem "$scratch\.config-backups" -Recurse -Filter init.vim)
if ($backup.Count -ne 1 -or (Get-Content $backup[0].FullName -Raw).Trim() -ne $original) { throw 'Original config backup was lost' }
& "$root\install.ps1" @parameters *> "$scratch\repeat.log"
if (@(Select-String '^Unchanged:' "$scratch\repeat.log").Count -ne 5) { throw 'Second install not idempotent' }
# Simulate a PC with no prerequisites, without altering the real PATH.
& {
    function Get-Command { param($Name, $CommandType, $ErrorAction) return $null }
    $failed = $false
    try {
        & "$root\install.ps1" -HomeDirectory "$scratch\missing-tools" -LocalAppData "$scratch\missing-tools\Local" -ProfilePath "$scratch\missing-tools\profile.ps1" *> "$scratch\missing-tools.log"
    } catch { $failed = $_ -match 'Prerequisite check failed' }
    if (-not $failed -or (Test-Path "$scratch\missing-tools")) { throw 'Missing prerequisites did not stop installation before writes' }
}
& {
    '$global:LASTEXITCODE = 0; "NVIM v0.10.0"' | Set-Content "$scratch\old-nvim.ps1"
    function Get-Command {
        param($Name, $CommandType, $ErrorAction)
        if ($Name -eq 'nvim') { return [pscustomobject]@{ Source = "$scratch\old-nvim.ps1" } }
        Microsoft.PowerShell.Core\Get-Command $Name -ErrorAction SilentlyContinue
    }
    $issues = @(& "$root\check-prerequisites.ps1")
    if (-not ($issues | Where-Object { $_.Level -eq 'Error' -and $_.Message -match 'nvim is too old' })) {
        throw 'Old Neovim version was not rejected'
    }
}
Write-Output 'PASS: WhatIf, conflict backup, idempotence, missing tools, old-version rejection'
Write-Output "Test artifacts: $scratch"
