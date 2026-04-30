param()

# Read hook input from stdin.
$rawInput = [Console]::In.ReadToEnd()

if ([string]::IsNullOrWhiteSpace($rawInput)) {
    exit 0
}

try {
    $hookData = $rawInput | ConvertFrom-Json -ErrorAction Stop
} catch {
    exit 0
}

$sessionId = $hookData.session_id
if ([string]::IsNullOrWhiteSpace($sessionId)) {
    exit 0
}

# Look up registry to see if already registered.
$registryPath = Join-Path $PSScriptRoot '..\registry.json'
$instance = $null
if (Test-Path -LiteralPath $registryPath) {
    try {
        $raw = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8
        if (-not [string]::IsNullOrWhiteSpace($raw)) {
            $obj = $raw | ConvertFrom-Json -ErrorAction Stop
            $prop = $obj.PSObject.Properties | Where-Object { $_.Name -eq $sessionId } | Select-Object -First 1
            if ($prop) { $instance = [string]$prop.Value }
        }
    } catch {}
}

if ($instance) {
    $context = "[Multi-instance] You are registered as instance $instance. Your inbox is .claude/inbox/$instance.md — messages from sibling instances will be auto-injected at the end of each turn via the Stop hook."
} else {
    $context = @"
[Multi-instance setup needed]
Session ID: $sessionId

This session is not yet registered. The user runs three Claude Code instances (A/B/C) in parallel — see CLAUDE_INSTANCES.md.

When the user tells you which instance you are (e.g. "you are A", "register as B", "นายชื่อ A"), run this command via the Bash tool to register yourself:

  powershell -ExecutionPolicy Bypass -File .claude/scripts/register.ps1 -SessionId $sessionId -Instance <A|B|C>

After registration, the inbox at .claude/inbox/<X>.md will route messages to you via the Stop hook.
"@
}

$payload = [PSCustomObject]@{
    hookSpecificOutput = [PSCustomObject]@{
        hookEventName     = 'SessionStart'
        additionalContext = $context
    }
} | ConvertTo-Json -Compress -Depth 5

Write-Output $payload
exit 0
