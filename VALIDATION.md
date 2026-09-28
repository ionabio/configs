# Validation, 2026-09-28

Tested on Windows with Neovim 0.11.5 and WezTerm 20240203-110809-5046fc22.

- Both configurations load without startup errors.
- C++ and Lua language servers attach; buffer-local definition mappings exist.
- ripgrep and LazyGit are available.
- Eight mocked WezTerm file-opening cases pass, including spaces, line/column,
  command-like filenames, control-character rejection, and encoded URI paths.
- Installer backs up replaced files and skips all five files on a second run.
- The installed PowerShell profile loads successfully.
- All installed lazy.nvim plugin commits match the committed lockfile.
- Full Neovim health check completes with zero errors in a normal Windows environment.

Local repair: the Neovim executable already matched the official 0.11.5 release,
but its runtime contained leftover 2023 files. Replaced the runtime from the official,
SHA-256-verified release archive; kept the original runtime in a local backup.
Installed tree-sitter-cli 0.27.0 and stylua. These binaries are not stored in Git.

Remaining optional health warnings include Python formatters (black/isort), snippet
transformation support, fd, and tools for languages not configured here. The Codex
process injects C.UTF-8 locale variables that Windows Neovim rejects; removing these
process-only variables for validation resolves that warning without changing user
environment settings.

No interactive GUI shortcut sweep or clean-machine bootstrap was performed.
