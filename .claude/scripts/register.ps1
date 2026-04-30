param(
    [Parameter(Mandatory=$true)][string]$SessionId,
    [Parameter(Mandatory=$true)][ValidateSet('A','B','C')][string]$Instance
)

$registryPath = Join-Path $PSScriptRoot '..\registry.json'

if (-not (Test-Path -LiteralPath $registryPath)) {
    [IO.File]::WriteAllText($registryPath, '{}', [Text.UTF8Encoding]::new($false))
}

# Load existing registry into a hashtable.
$reg = @{}
try {
    $raw = Get-Content -LiteralPath $registryPath -Raw -Encoding UTF8
    if (-not [string]::IsNullOrWhiteSpace($raw)) {
        $obj = $raw | ConvertFrom-Json -ErrorAction Stop
        $obj.PSObject.Properties | ForEach-Object { $reg[$_.Name] = [string]$_.Value }
    }
} catch {
    Write-Error "Failed to read registry.json: $_"
    exit 1
}

# Remove any existing entries with this instance label so re-registering swaps cleanly.
$keysToRemove = @($reg.Keys | Where-Object { $reg[$_] -eq $Instance })
foreach ($k in $keysToRemove) {
    $reg.Remove($k) | Out-Null
}

# Add new mapping.
$reg[$SessionId] = $Instance

# Write back as compact JSON, UTF-8 without BOM.
$json = if ($reg.Count -eq 0) { '{}' } else { ($reg | ConvertTo-Json -Compress) }
[IO.File]::WriteAllText($registryPath, $json, [Text.UTF8Encoding]::new($false))

Write-Output "Registered session $SessionId as instance $Instance"
exit 0
