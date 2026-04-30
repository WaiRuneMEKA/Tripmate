# Multi-Instance Claude Code Setup Prompt

วาง prompt ด้านล่างนี้ทั้งหมดให้ Claude **session A** ของโปรเจคใหม่ Claude จะ scaffold ไฟล์ทั้งหมดที่จำเป็น

> **Platform:** Windows (PowerShell hooks) — ถ้าใช้ Mac/Linux ต้องแปลง `.ps1` เป็น `.sh` เอง
>
> **ลำดับ:** Claude A สร้างไฟล์ → user รีสตาร์ตทุก session → SessionStart hook ฉีด context → user บอก "คุณคือ A/B/C" → Claude register → ใช้งานได้

---

## วาง prompt นี้ทั้งหมดให้ Claude

````
# Task: Set up multi-instance Claude Code routing system

ฉันใช้ Claude Code 3 instance พร้อมกัน (A=orchestrator, B=editor, C=terminal worker) ใน VSCode/Cursor หน้าต่างเดียวกัน
ขอให้ scaffold ระบบ inbox + status routing โดยสร้างไฟล์ตามรายละเอียดด้านล่างนี้ **เป๊ะ**

## โครงสร้างที่ต้องสร้าง

```
.claude/
├── settings.json           # hooks (commit ลง git)
├── settings.local.json     # personal permissions (gitignored)
├── registry.json           # session_id → instance mapping
├── inbox/
│   ├── A.md (empty)
│   ├── B.md (empty)
│   └── C.md (empty)
├── status/
│   ├── A.md (empty)
│   ├── B.md (empty)
│   └── C.md (empty)
└── scripts/
    ├── session-start.ps1
    ├── register.ps1
    └── check-inbox.ps1
CLAUDE_INSTANCES.md         # docs (commit ลง git)
```

## ไฟล์ 1: `.claude/settings.json`

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File .claude/scripts/session-start.ps1"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File .claude/scripts/check-inbox.ps1"
          }
        ]
      }
    ]
  }
}
```

## ไฟล์ 2: `.claude/settings.local.json`

**สำคัญ — Bash rule ใช้ `space + *` ไม่ใช่ `:*`** (syntax ที่ผิดแล้ว rule จะไม่ทำงาน)

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Bash(echo *)",
      "Bash(cat *)",
      "Bash(tail *)",
      "Bash(head *)",
      "Bash(ls *)",
      "Bash(date *)",
      "Bash(wc *)",
      "Bash(pwd)",
      "Bash(mkdir *)",
      "Bash(touch *)",
      "Bash(rm .claude/inbox/*.md)",
      "Bash(rm .claude/status/*.md)",
      "Bash(git status *)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Write(.claude/inbox/*.md)",
      "Edit(.claude/inbox/*.md)",
      "Read(.claude/inbox/*.md)",
      "Write(.claude/status/*.md)",
      "Edit(.claude/status/*.md)",
      "Read(.claude/status/*.md)"
    ]
  }
}
```

> หมายเหตุ: เพิ่ม allow rule สำหรับภาษา/เฟรมเวิร์กที่ใช้จริงในโปรเจคทีหลัง (เช่น `Bash(npm *)`, `Bash(flutter analyze *)`, `Edit(src/**)`, `Edit(lib/**)`) — เริ่มแค่ minimum นี้ก่อน

## ไฟล์ 3: `.claude/registry.json`

เริ่มต้นว่าง:

```json
{}
```

## ไฟล์ 4: `.claude/scripts/session-start.ps1`

```powershell
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
    $context = "[Multi-instance] You are registered as instance $instance. Your inbox is .claude/inbox/$instance.md - messages from sibling instances will be auto-injected at the end of each turn via the Stop hook."
} else {
    $context = @"
[Multi-instance setup needed]
Session ID: $sessionId

This session is not yet registered. The user runs three Claude Code instances (A/B/C) in parallel - see CLAUDE_INSTANCES.md.

When the user tells you which instance you are (e.g. "you are A", "register as B"), run this command via the Bash tool to register yourself:

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
```

## ไฟล์ 5: `.claude/scripts/register.ps1`

```powershell
param(
    [Parameter(Mandatory=$true)][string]$SessionId,
    [Parameter(Mandatory=$true)][ValidateSet('A','B','C')][string]$Instance
)

$registryPath = Join-Path $PSScriptRoot '..\registry.json'

if (-not (Test-Path -LiteralPath $registryPath)) {
    [IO.File]::WriteAllText($registryPath, '{}', [Text.UTF8Encoding]::new($false))
}

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

$reg[$SessionId] = $Instance

$json = if ($reg.Count -eq 0) { '{}' } else { ($reg | ConvertTo-Json -Compress) }
[IO.File]::WriteAllText($registryPath, $json, [Text.UTF8Encoding]::new($false))

Write-Output "Registered session $SessionId as instance $Instance"
exit 0
```

## ไฟล์ 6: `.claude/scripts/check-inbox.ps1`

```powershell
param()

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

$reason = "New message (instance ${instance}):`n`n" + $content.TrimEnd() + "`n`nFollow the instructions above."

$payload = [PSCustomObject]@{
    decision = "block"
    reason   = $reason
} | ConvertTo-Json -Compress

Write-Output $payload
exit 0
```

## ไฟล์ 7: `CLAUDE_INSTANCES.md` (project root)

```markdown
# Claude Code Instances Guide

ระบบ multi-instance routing ของโปรเจคนี้ — A/B/C ทำงานพร้อมกัน

## A — Main (orchestrator)
- ตำแหน่ง: VSCode/Cursor sidebar
- บทบาท: วางแผน, สั่งงาน, รวมผล
- Priority: สูงสุด

## B — Editor Tab
- ตำแหน่ง: editor area
- บทบาท: refactor, edit ไฟล์โฟกัสนาน

## C — Terminal
- ตำแหน่ง: terminal panel
- บทบาท: build, test, git, log monitoring

## กฎการแก้ไฟล์
- B กับ C ห้ามแก้ไฟล์เดียวกันพร้อมกัน
- ถ้าไม่แน่ใจ ให้ A ตัดสิน

## Inter-Instance Communication

ใช้ inbox file `.claude/inbox/<X>.md` (X = A/B/C)
ข้อความจะ inject เข้า session อัตโนมัติเมื่อจบ turn ผ่าน Stop hook (`check-inbox.ps1`)

### วิธีส่งข้อความ
ใช้ `>>` (append) เสมอ ห้าม `>` (overwrite) — กัน race condition

```bash
echo "[from <self>] <message>" >> .claude/inbox/<target>.md
```

ตัวอย่าง:
```bash
echo "[from A] refactor X.dart" >> .claude/inbox/B.md
echo "[from B] เสร็จแล้ว" >> .claude/inbox/A.md
```

## Real-time Status (`.claude/status/<X>.md`)

สำหรับ task หลายขั้น — ผู้ส่ง task อ่าน progress ได้ตลอดโดยไม่ต้องรอ Stop hook

```bash
echo "[$(date +%H:%M:%S)] === START: <task> ===" > .claude/status/<self>.md
echo "[$(date +%H:%M:%S)] [2/5] reading X" >> .claude/status/<self>.md
echo "[$(date +%H:%M:%S)] === DONE ===" >> .claude/status/<self>.md
```

อ่าน status: `tail -5 .claude/status/X.md`

## Session-ID Registration

1. เปิด Claude session ใหม่ → SessionStart hook ฉีด session_id เข้า context
2. user บอก "คุณคือ A/B/C"
3. Claude รัน register script:
   ```bash
   powershell -ExecutionPolicy Bypass -File .claude/scripts/register.ps1 -SessionId <uuid> -Instance A
   ```

ดู registry: `cat .claude/registry.json`
Reset: `echo '{}' > .claude/registry.json`

## .gitignore เพิ่ม

```
.claude/registry.json
.claude/settings.local.json
.claude/inbox/
.claude/status/
```
```

## ไฟล์ที่เหลือ (ว่าง — ใช้ touch)

```bash
touch .claude/inbox/A.md .claude/inbox/B.md .claude/inbox/C.md
touch .claude/status/A.md .claude/status/B.md .claude/status/C.md
```

## .gitignore เพิ่ม (ในไฟล์ .gitignore ที่มีอยู่ ไม่ overwrite)

ต่อท้ายไฟล์ .gitignore ที่มีอยู่:
```
# Claude Code multi-instance state (per-developer)
.claude/registry.json
.claude/settings.local.json
.claude/inbox/
.claude/status/
```

## หลังสร้างเสร็จ

รายงานกลับว่า:
1. สร้างไฟล์อะไรบ้าง (จำนวน + path)
2. ลำดับขั้นตอนที่ user ต้องทำต่อ:
   - **ปิด-เปิด session ใหม่ทั้ง 3 ตัว** (A/B/C) — เพื่อ SessionStart hook ฉีด context
   - บอก instance แต่ละตัว: "คุณคือ A" / "คุณคือ B" / "คุณคือ C"
   - รอแต่ละตัว run register script
   - ทดสอบ: `echo "[from A] hello" >> .claude/inbox/C.md` แล้ว nudge C ให้จบ turn
3. permission rules ที่ตอนนี้ใส่ไว้เป็น minimum — ถ้าใช้ภาษา/เครื่องมืออื่นเพิ่ม rule ได้ที่ `.claude/settings.local.json` ใช้ syntax `Bash(<cmd> *)` (space + *) ไม่ใช่ `:*`

````

---

## คำเตือน / ข้อควรรู้

### Permission rule syntax (สำคัญ — เคยพลาดมาแล้ว)

| ✅ ถูก | ❌ ผิด |
|---|---|
| `Bash(flutter analyze *)` | `Bash(flutter analyze:*)` |
| `Bash(npm *)` | `Bash(npm:*)` |
| `Bash(git status)` (exact, no args) | — |
| `Edit(lib/**)` | — |

### "Sensitive file" hardcoded warning

Claude Code มี hardcoded protection กับ path ใน `.claude/` — `.claude/inbox/<X>.md` อาจโดน prompt ครั้งแรก แม้ว่าจะมี allow rule แล้ว ครั้งถัดไปจะ remember และไม่ถาม

### ไฟล์ใน .gitignore

- `registry.json` = per-developer (session_id ไม่เหมือนกัน)
- `settings.local.json` = personal preference
- `inbox/`, `status/` = ephemeral runtime state

ส่วน `settings.json` (hooks) + `CLAUDE_INSTANCES.md` (docs) + `scripts/*.ps1` = **commit เข้า repo** เพื่อให้ทีมใช้ได้

### ตอนนี้ project Tripmate ของเรา

Settings ปัจจุบันใน [.claude/settings.local.json](.claude/settings.local.json) มี syntax `:*` ที่ผิดอยู่ — ถ้าใช้กับ project นี้ต่อแนะนำให้แก้ตาม syntax ใน prompt ข้างบน
