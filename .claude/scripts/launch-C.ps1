# Launches Claude Code as instance C (Terminal Worker).
# Sets CLAUDE_INSTANCE=C so the inbox Stop hook reads .claude/inbox/C.md
$env:CLAUDE_INSTANCE = "C"
Write-Host "[Instance C] CLAUDE_INSTANCE set. Launching Claude..." -ForegroundColor Cyan
claude
