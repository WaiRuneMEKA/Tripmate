# Launches Claude Code as instance B (Editor / Implementation).
# Sets CLAUDE_INSTANCE=B so the inbox Stop hook reads .claude/inbox/B.md
$env:CLAUDE_INSTANCE = "B"
Write-Host "[Instance B] CLAUDE_INSTANCE set. Launching Claude..." -ForegroundColor Cyan
claude
