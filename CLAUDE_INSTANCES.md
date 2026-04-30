# Claude Code Instances Guide

ไฟล์นี้ใช้แยก Claude Code ทั้ง 3 ตัวที่รันพร้อมกัน

---

## A — Main (ตัวหลัก) ⭐

- **ตำแหน่ง:** Sidebar ซ้าย (VSCode Extension Panel)
- **บทบาท:** ตัวหลักที่ใช้สั่งงาน orchestrate งานทั้งหมด
- **ใช้สำหรับ:** วางแผน, ตัดสินใจ, สั่งงาน A/B/C, รวมผลลัพธ์
- **Priority:** สูงสุด — ถ้าคำสั่งขัดกัน ให้ฟัง A เป็นหลัก

---

## B — Editor Tab

- **ตำแหน่ง:** Main editor area (แท็บ `/effort` กลางจอ)
- **บทบาท:** ผู้ช่วยรอง — ทำงานคู่ขนานกับ A
- **ใช้สำหรับ:** งาน implementation, edit ไฟล์, refactor, งานที่ต้องโฟกัสไฟล์เดียวนาน ๆ
- **Priority:** รอง — รับคำสั่งจาก A หรือผู้ใช้โดยตรง

---

## C — Terminal

- **ตำแหน่ง:** Terminal panel ล่างจอ (`claude` CLI)
- **บทบาท:** worker สำหรับงาน shell-heavy
- **ใช้สำหรับ:** รัน build, test, git ops, log monitoring, งาน background ที่ต้องดู output ดิบ
- **Priority:** รอง — เน้นงาน CLI / shell

---

## Workflow แนะนำ

1. ผู้ใช้สั่งงานที่ **A** เป็นหลัก
2. **A** วางแผนแล้วกระจายงานไปให้ **B** (edit code) และ **C** (run/test)
3. **B** และ **C** รายงานผลกลับมาที่ **A**
4. **A** สรุปและตอบผู้ใช้

## กฎการแก้ไฟล์ (สำคัญ)

- หลีกเลี่ยงให้ B และ C แก้ไฟล์เดียวกันพร้อมกัน — เสี่ยง conflict
- ก่อนแก้ไฟล์ ให้ระบุ "instance ไหนเป็นเจ้าของไฟล์นี้" ใน session นั้น ๆ
- ถ้าไม่แน่ใจ ให้ A เป็นคนตัดสิน

## วิธีระบุตัวเองในแต่ละ instance

เมื่อเริ่มงาน ให้ผู้ใช้บอก instance ว่า "คุณคือ A/B/C" เพื่อให้ตอบสนองตาม role ด้านบน

---

## Inter-Instance Communication

ทุก instance มี **inbox** เป็นไฟล์ markdown ที่ `.claude/inbox/<X>.md` (X = A, B, หรือ C)
ข้อความที่ค้างใน inbox จะถูก **inject เข้า session อัตโนมัติเมื่อจบ turn** ผ่าน Stop hook
(`.claude/scripts/check-inbox.ps1`) — ไม่ต้อง poll เอง

### วิธีส่งข้อความ

ใช้ Bash tool พร้อม `>>` (append) **เสมอ** ห้ามใช้ `>` (overwrite) เพื่อกัน race condition
ขึ้นต้นข้อความด้วย `[from A]`, `[from B]`, หรือ `[from C]` ทุกครั้ง เพื่อให้รู้ว่าใครส่ง

```bash
echo "[from <ชื่อตัวเอง>] <ข้อความ>" >> .claude/inbox/<target>.md
```

### ตัวอย่างการใช้งาน

```bash
# A สั่ง B
echo "[from A] refactor profile_screen.dart ใช้ Riverpod" >> .claude/inbox/B.md

# B รายงาน A
echo "[from B] refactor เสร็จ commit แล้ว" >> .claude/inbox/A.md

# A สั่ง C ทดสอบ
echo "[from A] รัน flutter test แล้วรายงานผล" >> .claude/inbox/C.md
```

### กลไก (mechanics)

1. เมื่อ instance หนึ่งจบ turn → Stop hook ทำงาน → script `check-inbox.ps1` อ่าน inbox ของตัวเอง
2. ถ้าว่าง → exit เงียบ ๆ
3. ถ้ามีข้อความ → ลบไฟล์ทิ้ง แล้วส่ง JSON `{"decision":"block","reason":"..."}` กลับ
4. Claude จะถูก inject ข้อความนั้นเข้า session ทันที และทำงานต่อตามคำสั่ง
5. ตอบกลับโดย append ไป inbox ของผู้ส่ง

---

## Real-time Status Updates (`.claude/status/<X>.md`)

Inbox ใช้สำหรับ **command/report** (turn-based) ส่วน status file ใช้สำหรับ **progress streaming** ที่ผู้ส่ง task อ่านได้ตลอดโดยไม่ต้องรอ Stop hook

### Convention

แต่ละ instance มีไฟล์ status ของตัวเอง: `.claude/status/A.md`, `.claude/status/B.md`, `.claude/status/C.md`

เมื่อ instance ได้รับ task **ที่มีหลายขั้นตอน** ให้ append progress line ก่อนเริ่มแต่ละ step:

```bash
# เริ่ม task — เคลียร์ไฟล์ก่อน
echo "[$(date +%H:%M:%S)] === START: <task summary> ===" > .claude/status/<self>.md

# ระหว่าง task — append ก่อนแต่ละ step
echo "[$(date +%H:%M:%S)] [step 2/5] reading pubspec.yaml" >> .claude/status/<self>.md
echo "[$(date +%H:%M:%S)] [step 3/5] analyzing dependencies" >> .claude/status/<self>.md

# จบ task
echo "[$(date +%H:%M:%S)] === DONE ===" >> .claude/status/<self>.md
```

### การอ่าน status

ใครก็อ่านได้ตลอด ไม่ต้องรอ Stop hook:

```bash
cat .claude/status/C.md          # ดูทั้งหมด
tail -5 .claude/status/C.md      # ดู 5 บรรทัดล่าสุด
```

### หลักปฏิบัติ

- **เขียน status เฉพาะตอนทำงานหลายขั้นตอน** — task สั้นๆ ไม่ต้องเขียน
- **Overwrite (`>`) ตอนเริ่ม task ใหม่** เพื่อเคลียร์ของเก่า, **append (`>>`) ระหว่าง task**
- **อย่าเขียนข้อมูลลับ** ในไฟล์ status (ไฟล์อ่านได้ทุก instance)
- ถ้า user ถาม "X ทำถึงไหน" → A อ่าน `.claude/status/X.md` แล้วสรุปให้

---

## วิธีเปิดใช้งาน (สำคัญ) — Session-ID Registration

ระบบใช้ **session_id** (UUID ที่ Claude Code สร้างต่อ session) จับคู่กับ A/B/C
ผ่าน `.claude/registry.json` — **ไม่ต้องใช้ env var** อีกต่อไป
ทำให้รัน A กับ B ใน Cursor/VSCode หน้าต่างเดียวกันได้

### Flow การลงทะเบียน

1. **เปิด Claude Code session ใหม่** (ใน Cursor sidebar / editor tab / terminal)
2. **SessionStart hook** ฉีด context เข้า session ทันทีว่า session_id คืออะไร
   พร้อมคำสั่ง register
3. **บอก Claude** ว่าตัวเองคือใคร — เช่น `"คุณคือ A"` หรือ `"register as B"`
4. **Claude รัน register script** ด้วย `session_id` ที่ได้จาก context:
   ```bash
   powershell -ExecutionPolicy Bypass -File .claude/scripts/register.ps1 -SessionId <uuid> -Instance A
   ```
5. ตั้งแต่นี้ไป Stop hook จะอ่าน `.claude/inbox/A.md` ของ session นี้โดยอัตโนมัติ

ลงทะเบียนซ้ำกับ instance เดิม (เช่น register ใหม่เป็น A) จะทับ session เก่า
session เก่าจะไม่รับ inbox ของ A อีก

### ดู registry ปัจจุบัน

```bash
cat .claude/registry.json
```

### Reset registry (เริ่มใหม่ทั้งหมด)

```powershell
echo '{}' | Out-File -Encoding utf8 .claude/registry.json
```

### Hook scripts

- `.claude/scripts/session-start.ps1` — SessionStart hook ฉีด session_id เข้า context
- `.claude/scripts/register.ps1` — เพิ่ม mapping `session_id → instance` ลง registry
- `.claude/scripts/check-inbox.ps1` — Stop hook อ่าน session_id จาก stdin → look up registry → อ่าน inbox

ถ้า session ยังไม่ register → Stop hook จะ exit 0 เงียบ ๆ (ไม่ block, ไม่ inject)
