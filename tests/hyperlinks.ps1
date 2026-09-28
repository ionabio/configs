$ErrorActionPreference = 'Stop'
$config = Get-Content (Join-Path (Split-Path $PSScriptRoot) 'wezterm/.wezterm.lua') -Raw
$patterns = @([regex]::Matches($config, 'regex = \[\[(.*?)\]\]') | ForEach-Object { $_.Groups[1].Value })
$cases = @(
    'C:/work/a&b.cpp',
    'C:/work/a#b%20+c.cpp:12:7',
    '"src/main.cpp"',
    '"C:/work/a b.cpp:12:7"',
    '"C:/work/a b.cpp":12:7',
    "'src/a b.cpp:12'",
    'C:\work\main.cpp:12:7',
    'src/main.cpp:12'
)
foreach ($value in $cases) {
    $matchesFound = @()
    foreach ($pattern in $patterns) {
        # ripgrep uses Rust regex syntax, like WezTerm's hyperlink rules.
        $result = $value | & rg --only-matching --replace '$2' --regexp $pattern
        if ($LASTEXITCODE -gt 1) { throw "Invalid hyperlink regex: $pattern" }
        if ($LASTEXITCODE -eq 0) { $matchesFound += $result }
    }
    if ($matchesFound.Count -ne 1 -or $matchesFound[0] -cne $value) {
        throw "Path was truncated or ambiguous: $value => $matchesFound"
    }
}
Write-Output "PASS: $($cases.Count) hyperlink matches preserve the complete location"
