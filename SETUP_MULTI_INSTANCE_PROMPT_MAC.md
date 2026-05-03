# Multi-Instance Claude Code Setup Prompt (Mac / Linux)

วาง prompt ด้านล่างนี้ทั้งหมดให้ Claude **session A** ของโปรเจคใหม่ Claude จะ scaffold ไฟล์ทั้งหมดที่จำเป็น

> **Platform:** macOS / Linux (bash + jq)
>
> **Prerequisite:** ต้องมี `jq` ติดตั้งอยู่
> - macOS: `brew install jq`
> - Ubuntu/Debian: `sudo apt install jq`
> - Fedora: `sudo dnf install jq`
>
> **ลำดับ:** Claude A สร้างไฟล์ → user รัน `chmod +x .claude/scripts/*.sh` → รีสตาร์ตทุก session → SessionStart hook ฉีด context → user บอก "คุณคือ A/B/C" → Claude register → ใช้งานได้

---

## วาง prompt นี้ทั้งหมดให้ Claude

````
# Task: Set up multi-instance Claude Code routing system (macOS/Linux)

ฉันใช้ Claude Code 3 instance พร้อมกัน (A=orchestrator, B=editor, C=terminal worker)
ขอให้ scaffold ระบบ inbox + status routing โดยสร้างไฟล์ตามรายละเอียดด้านล่างนี้ **เป๊ะ**

ต้องมี `jq` ติดตั้งไว้ในระบบ — ถ้ายังไม่มีให้เตือน user ติดตั้งก่อน:
- macOS: brew install jq
- Linux (Debian/Ubuntu): sudo apt install jq

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
    ├── session-start.sh
    ├── register.sh
    └── check-inbox.sh
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
            "command": "bash .claude/scripts/session-start.sh"
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
            "command": "bash .claude/scripts/check-inbox.sh"
          }
        ]
      }
    ]
  }
}
```

## ไฟล์ 2: `.claude/settings.local.json`

**สำคัญ — Bash rule ใช้ `space + *` ไม่ใช่ `:*`**

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
      "Bash(chmod *)",
      "Bash(rm .claude/inbox/*.md)",
      "Bash(rm .claude/status/*.md)",
      "Bash(git status *)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(jq *)",
      "Bash(bash .claude/scripts/register.sh *)",
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

> หมายเหตุ: เพิ่ม allow rule ตามภาษา/เฟรมเวิร์กที่ใช้จริง (เช่น `Bash(npm *)`, `Bash(yarn *)`, `Edit(src/**)`) — เริ่มจาก minimum นี้ก่อน

## ไฟล์ 3: `.claude/registry.json`

```json
{}
```

## ไฟล์ 4: `.claude/scripts/session-start.sh`

```bash
#!/usr/bin/env bash
# SessionStart hook — inject session_id and instance role into context
set -euo pipefail

input=$(cat)
[ -z "$input" ] && exit 0

session_id=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null || true)
[ -z "$session_id" ] && exit 0

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
registry="$script_dir/../registry.json"

instance=""
if [ -f "$registry" ]; then
    instance=$(jq -r --arg sid "$session_id" '.[$sid] // empty' "$registry" 2>/dev/null || true)
fi

if [ -n "$instance" ]; then
    context="[Multi-instance] You are registered as instance $instance. Your inbox is .claude/inbox/$instance.md - messages from sibling instances will be auto-injected at the end of each turn via the Stop hook."
else
    context="[Multi-instance setup needed]
Session ID: $session_id

This session is not yet registered. The user runs three Claude Code instances (A/B/C) in parallel - see CLAUDE_INSTANCES.md.

When the user tells you which instance you are (e.g. \"you are A\", \"register as B\"), run this command via the Bash tool to register yourself:

  bash .claude/scripts/register.sh -s $session_id -i <A|B|C>

After registration, the inbox at .claude/inbox/<X>.md will route messages to you via the Stop hook."
fi

jq -nc --arg ctx "$context" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'
exit 0
```

## ไฟล์ 5: `.claude/scripts/register.sh`

```bash
#!/usr/bin/env bash
# Register a session_id to an instance label (A/B/C)
set -euo pipefail

session_id=""
instance=""

while [ $# -gt 0 ]; do
    case "$1" in
        -s|--session-id) session_id="${2:-}"; shift 2;;
        -i|--instance) instance="${2:-}"; shift 2;;
        -h|--help)
            echo "Usage: register.sh -s <session-id> -i <A|B|C>"
            exit 0
            ;;
        *) echo "Unknown arg: $1" >&2; exit 1;;
    esac
done

if [ -z "$session_id" ] || [ -z "$instance" ]; then
    echo "Usage: register.sh -s <session-id> -i <A|B|C>" >&2
    exit 1
fi

if [[ ! "$instance" =~ ^[ABC]$ ]]; then
    echo "Instance must be A, B, or C (got: $instance)" >&2
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
registry="$script_dir/../registry.json"

# Initialize if missing
[ ! -f "$registry" ] && echo '{}' > "$registry"

# Remove any existing entries that map to this instance, then add the new one
tmp=$(mktemp)
jq --arg sid "$session_id" --arg inst "$instance" '
  with_entries(select(.value != $inst)) + {($sid): $inst}
' "$registry" > "$tmp" && mv "$tmp" "$registry"

echo "Registered session $session_id as instance $instance"
exit 0
```

## ไฟล์ 6: `.claude/scripts/check-inbox.sh`

```bash
#!/usr/bin/env bash
# Stop hook — pull pending message from this instance's inbox and inject it
set -euo pipefail

input=$(cat)
[ -z "$input" ] && exit 0

session_id=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null || true)
[ -z "$session_id" ] && exit 0

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
registry="$script_dir/../registry.json"

[ ! -f "$registry" ] && exit 0

instance=$(jq -r --arg sid "$session_id" '.[$sid] // empty' "$registry" 2>/dev/null || true)
[ -z "$instance" ] && exit 0

inbox="$script_dir/../inbox/$instance.md"
[ ! -f "$inbox" ] && exit 0

content=$(cat "$inbox")
# Skip if file is empty or only whitespace
[ -z "$(printf '%s' "$content" | tr -d '[:space:]')" ] && exit 0

# Clear inbox so the same message isn't re-injected next Stop
rm -f "$inbox"

reason="New message (instance ${instance}):

${content}

Follow the instructions above."

jq -nc --arg reason "$reason" '{decision:"block", reason:$reason}'
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
- ตำแหน่ง: terminal panel (`claude` CLI)
- บทบาท: build, test, git, log monitoring

## กฎการแก้ไฟล์
- B กับ C ห้ามแก้ไฟล์เดียวกันพร้อมกัน
- ถ้าไม่แน่ใจ ให้ A ตัดสิน

## Inter-Instance Communication

ใช้ inbox file `.claude/inbox/<X>.md` (X = A/B/C)
ข้อความจะ inject เข้า session อัตโนมัติเมื่อจบ turn ผ่าน Stop hook (`check-inbox.sh`)

### วิธีส่งข้อความ
ใช้ `>>` (append) เสมอ ห้าม `>` (overwrite) — กัน race condition

\`\`\`bash
echo "[from <self>] <message>" >> .claude/inbox/<target>.md
\`\`\`

ตัวอย่าง:
\`\`\`bash
echo "[from A] refactor X.ts" >> .claude/inbox/B.md
echo "[from B] เสร็จแล้ว" >> .claude/inbox/A.md
\`\`\`

## Real-time Status (`.claude/status/<X>.md`)

สำหรับ task หลายขั้น — ผู้ส่ง task อ่าน progress ได้ตลอดโดยไม่ต้องรอ Stop hook

\`\`\`bash
echo "[$(date +%H:%M:%S)] === START: <task> ===" > .claude/status/<self>.md
echo "[$(date +%H:%M:%S)] [2/5] reading X" >> .claude/status/<self>.md
echo "[$(date +%H:%M:%S)] === DONE ===" >> .claude/status/<self>.md
\`\`\`

อ่าน status: \`tail -5 .claude/status/X.md\`

## Session-ID Registration

1. เปิด Claude session ใหม่ → SessionStart hook ฉีด session_id เข้า context
2. user บอก "คุณคือ A/B/C"
3. Claude รัน register script:
   \`\`\`bash
   bash .claude/scripts/register.sh -s <uuid> -i A
   \`\`\`

ดู registry: \`cat .claude/registry.json\`
Reset: \`echo '{}' > .claude/registry.json\`

## Prerequisite

ต้องมี \`jq\` ติดตั้ง:
- macOS: \`brew install jq\`
- Ubuntu/Debian: \`sudo apt install jq\`
- Fedora: \`sudo dnf install jq\`

## .gitignore เพิ่ม

\`\`\`
.claude/registry.json
.claude/settings.local.json
.claude/inbox/
.claude/status/
\`\`\`
```

## ไฟล์ที่เหลือ (ว่าง)

```bash
mkdir -p .claude/inbox .claude/status
touch .claude/inbox/A.md .claude/inbox/B.md .claude/inbox/C.md
touch .claude/status/A.md .claude/status/B.md .claude/status/C.md
```

## ทำให้ scripts รันได้ (สำคัญ)

```bash
chmod +x .claude/scripts/session-start.sh
chmod +x .claude/scripts/register.sh
chmod +x .claude/scripts/check-inbox.sh
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

## หลังสร้างเสร็จ รายงานกลับว่า

1. สร้างไฟล์อะไรบ้าง (จำนวน + path)
2. ตรวจสอบว่ามี `jq` หรือยัง:
   ```bash
   jq --version
   ```
   ถ้าไม่มี → บอก user ให้ install ก่อน (`brew install jq` / `apt install jq`)
3. ลำดับขั้นตอนที่ user ต้องทำต่อ:
   - **ปิด-เปิด session ใหม่ทั้ง 3 ตัว** (A/B/C) — เพื่อ SessionStart hook ฉีด context
   - บอกแต่ละ instance: "คุณคือ A" / "คุณคือ B" / "คุณคือ C"
   - รอแต่ละตัว run register script
   - ทดสอบ: `echo "[from A] hello" >> .claude/inbox/C.md` แล้ว nudge C ให้จบ turn
4. permission rules ที่ใส่ไว้เป็น minimum — ถ้าใช้ภาษาอื่นเพิ่ม rule ที่ `.claude/settings.local.json` ใช้ syntax `Bash(<cmd> *)` (space + *) ไม่ใช่ `:*`

````

---

## คำเตือน / ข้อควรรู้

### ความต่างจาก Windows version

| | Windows (PowerShell) | Mac/Linux (bash) |
|---|---|---|
| Hook command | `powershell -ExecutionPolicy Bypass -File X.ps1` | `bash X.sh` |
| Script extension | `.ps1` | `.sh` |
| JSON parser | built-in `ConvertFrom-Json` | ต้องมี `jq` |
| File permissions | ไม่ต้อง chmod | ต้อง `chmod +x` |
| Register call | `powershell ... register.ps1 -SessionId X -Instance A` | `bash register.sh -s X -i A` |

### Permission rule syntax (เหมือน Windows version)

| ✅ ถูก | ❌ ผิด |
|---|---|
| `Bash(npm *)` | `Bash(npm:*)` |
| `Bash(git status)` (exact) | — |
| `Edit(src/**)` | — |

### "Sensitive file" warning

Claude Code มี hardcoded protection กับ path ใน `.claude/` — `.claude/inbox/<X>.md` อาจโดน prompt ครั้งแรก แม้ว่าจะมี allow rule แล้ว

### ทดสอบ scripts manually (debug)

```bash
# ทดสอบว่า session-start ทำงาน
echo '{"session_id":"test-123"}' | bash .claude/scripts/session-start.sh

# ทดสอบ register
bash .claude/scripts/register.sh -s test-123 -i A
cat .claude/registry.json   # ควรเห็น {"test-123":"A"}

# ทดสอบ check-inbox (ต้อง register ก่อน + ใส่ message)
echo "test message" > .claude/inbox/A.md
echo '{"session_id":"test-123"}' | bash .claude/scripts/check-inbox.sh
# ควรได้ JSON {"decision":"block","reason":"..."}
# และ inbox/A.md ควรถูกลบ

# Reset
echo '{}' > .claude/registry.json
```

### Cross-platform note

ถ้าทีมใช้ทั้ง Windows + Mac ในโปรเจคเดียวกัน:
- ทำทั้ง `.ps1` และ `.sh` ใน `.claude/scripts/`
- ใน `settings.json` ต้องเลือกอย่างเดียว — ทำ 2 ไฟล์ `settings.json` (Windows) กับ `settings.mac.json` ไม่ได้
- แนะนำให้แยก project หรือทำ wrapper script ที่ check OS แล้ว delegate
