# Keep repeated profile loads from duplicating npm's PATH entry.
$npmPath = Join-Path $env:APPDATA 'npm'
if ((Test-Path -LiteralPath $npmPath) -and ($env:PATH -split ';') -notcontains $npmPath) {
    $env:PATH = "$npmPath;$env:PATH"
}

$promptTheme = Join-Path $HOME '.config\ohmyposh\simple-prompt.json'
if ((Get-Command oh-my-posh -ErrorAction SilentlyContinue) -and (Test-Path -LiteralPath $promptTheme)) {
    oh-my-posh init pwsh --config $promptTheme | Invoke-Expression
}
