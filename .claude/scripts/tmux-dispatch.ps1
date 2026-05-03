param(
    [Parameter(Mandatory=$true)][ValidateSet('B','C','D','E')][string]$Instance,
    [Parameter(Mandatory=$true)][string]$Message,
    [string]$Session = 'tripmate',
    [string]$Distro  = 'Ubuntu'
)

# Pane mapping (per launch-tmux.sh, 2x2 grid):
#   pane 0 = B (top-left)    pane 1 = C (top-right)
#   pane 2 = D (bottom-left) pane 3 = E (bottom-right)
$paneIndex = switch ($Instance) {
    'B' { 0 }
    'C' { 1 }
    'D' { 2 }
    'E' { 3 }
}
$paneTarget = "${Session}:0.${paneIndex}"

# Project root
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$dispatchDir = Join-Path $projectRoot '.claude\dispatch'
if (-not (Test-Path $dispatchDir)) {
    New-Item -ItemType Directory -Path $dispatchDir -Force | Out-Null
}
$tmpFile = Join-Path $dispatchDir "$Instance.tmp.md"

# Normalize line endings to LF, strip trailing newline so the explicit Enter is the submit
$content = (($Message -replace "`r`n", "`n") -replace "`r", "").TrimEnd("`n")
[IO.File]::WriteAllText($tmpFile, $content, [Text.UTF8Encoding]::new($false))

# Convert Windows path -> WSL path manually (PowerShell mangles backslashes when passing to wsl.exe)
function Convert-WinPathToWsl([string]$p) {
    $p = $p -replace '\\', '/'
    if ($p -match '^([A-Za-z]):(.*)$') {
        return '/mnt/' + $matches[1].ToLower() + $matches[2]
    }
    return $p
}
$wslPath = Convert-WinPathToWsl $tmpFile

# Load buffer -> paste into pane (bracketed = treat newlines as text, not submit) -> Enter to submit
wsl -d $Distro tmux load-buffer $wslPath
if ($LASTEXITCODE -ne 0) { throw "tmux load-buffer failed (exit $LASTEXITCODE)" }

wsl -d $Distro tmux paste-buffer -p -t $paneTarget
if ($LASTEXITCODE -ne 0) { throw "tmux paste-buffer -p failed (exit $LASTEXITCODE)" }

# Small delay for paste to settle in TUI before submit
Start-Sleep -Milliseconds 200

wsl -d $Distro tmux send-keys -t $paneTarget Enter
if ($LASTEXITCODE -ne 0) { throw "tmux send-keys Enter failed (exit $LASTEXITCODE)" }

Write-Output "Dispatched to $Instance ($paneTarget): $($content.Length) chars"
