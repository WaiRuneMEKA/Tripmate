param()

# Read hook input from stdin (Claude Code passes JSON with session_id, etc.)
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

# Look up which instance (A/B/C) this session is registered as.
$registryPath = Join-Path $PSScriptRoot '..\registry.json'
if (-not (Test-Path -LiteralPath $registryPath)) {
    exit 0
}

$instance = $null
try {
    $raw = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8
    if (-not [string]::IsNullOrWhiteSpace($raw)) {
        $obj = $raw | ConvertFrom-Json -ErrorAction Stop
        $prop = $obj.PSObject.Properties | Where-Object { $_.Name -eq $sessionId } | Select-Object -First 1
        if ($prop) { $instance = [string]$prop.Value }
    }
} catch {
    exit 0
}

if ([string]::IsNullOrWhiteSpace($instance)) {
    exit 0
}

$inboxPath = Join-Path $PSScriptRoot "..\inbox\$instance.md"
if (-not (Test-Path -LiteralPath $inboxPath)) {
    exit 0
}

$content = Get-Content -LiteralPath $inboxPath -Raw -Encoding UTF8
if ([string]::IsNullOrWhiteSpace($content)) {
    exit 0
}

# Clear inbox so the same message isn't re-injected next Stop.
Remove-Item -LiteralPath $inboxPath -Force

$reason = "📬 ข้อความใหม่ (instance $instance):`n`n" + $content.TrimEnd() + "`n`nทำตามคำสั่งข้างบน"

$payload = [PSCustomObject]@{
    decision = "block"
    reason   = $reason
} | ConvertTo-Json -Compress

Write-Output $payload
exit 0
