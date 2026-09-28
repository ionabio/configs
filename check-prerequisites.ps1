#Requires -Version 7.0
# Return structured results; the installer decides whether to stop.
[CmdletBinding()]
param()

foreach ($tool in @(
    @{ Name = 'pwsh'; Minimum = [version]'7.0'; Hint = 'Install PowerShell 7.' },
    @{ Name = 'git'; Minimum = [version]'2.19'; Hint = 'Install Git for Windows 2.19 or newer.' },
    @{ Name = 'nvim'; Minimum = [version]'0.11.5'; Hint = 'Install Neovim 0.11.5 or newer.' },
    @{ Name = 'wezterm'; Minimum = $null; Hint = 'Install WezTerm 20240203 or newer.' },
    @{ Name = 'rg'; Minimum = $null; Hint = 'Install ripgrep on your normal user PATH.' }
)) {
    $command = Get-Command $tool.Name -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    $problem = $null
    if (-not $command) {
        $problem = "Missing $($tool.Name). $($tool.Hint)"
    } else {
        $output = (& $command.Source --version 2>&1 | Out-String)
        if ($LASTEXITCODE -ne 0) {
            $problem = "$($tool.Name) could not run. $($tool.Hint)"
        } elseif ($tool.Minimum -and
            ($output -notmatch '(\d+\.\d+(?:\.\d+)?)' -or [version]$Matches[1] -lt $tool.Minimum)) {
            $problem = "$($tool.Name) is too old or its version is unrecognized. $($tool.Hint)"
        } elseif ($tool.Name -eq 'wezterm' -and
            ($output -notmatch 'wezterm (\d{8})' -or [int64]$Matches[1] -lt 20240203)) {
            $problem = $tool.Hint
        }
    }
    if ($problem) { [pscustomobject]@{ Level = 'Error'; Message = $problem } }
}

foreach ($tool in 'oh-my-posh', 'lazygit', 'tree-sitter', 'clang-format') {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        [pscustomobject]@{ Level = 'Warning'; Message = "Optional tool missing: $tool. See README.md for setup." }
    }
}
if (-not (Test-Path -LiteralPath 'C:\Program Files\Git\bin\bash.exe')) {
    [pscustomobject]@{ Level = 'Warning'; Message = 'Git Bash shortcuts require C:\Program Files\Git\bin\bash.exe; adjust wezterm/.wezterm.lua for another location.' }
}
if (Get-Command wezterm -CommandType Application -ErrorAction SilentlyContinue) {
    $fonts = (& wezterm ls-fonts --list-system 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0 -or $fonts -notmatch 'JetBrainsMono Nerd Font|JetBrainsMono NF') {
        [pscustomobject]@{ Level = 'Warning'; Message = 'Install JetBrainsMono Nerd Font for the configured font and icons.' }
    }
}
