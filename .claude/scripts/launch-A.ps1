# Launches Claude Code as instance A (Main Orchestrator).
# Sets CLAUDE_INSTANCE=A so the inbox Stop hook reads .claude/inbox/A.md
$env:CLAUDE_INSTANCE = "A"
Write-Host "[Instance A] CLAUDE_INSTANCE set. Launching Claude..." -ForegroundColor Cyan
claude
