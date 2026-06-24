# 🚀 JOO - OpenCode Full Setup Package  
**الملف الشامل لتثبيت إعدادات JOO كاملة على أي جهاز**

---

## 📦 1. المتطلبات الأساسية (Prerequisites)

### 1.1 Node.js
```powershell
# تحقق من وجود Node.js
node --version
# لو مش موجود: https://nodejs.org (v18+)
```

### 1.2 Python
```powershell
python --version
# لو مش موجود: https://python.org (v3.10+)
```

### 1.3 Ollama (للنماذج المحلية)
```powershell
# Download from: https://ollama.com
# بعد التثبيت:
ollama pull qwen2.5-coder:3b-ctx
ollama pull qwen2.5-coder:7b-instruct
```

### 1.4 UV (للأدوات اللي محتاجة uvx)
```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### 1.5 Git
```powershell
git --version
# لو مش موجود: https://git-scm.com
```

---

## 🎯 2. التثبيت السريع (Quick Install)

### 2.1 تثبيت OpenCode
```powershell
npm install -g opencode
```

### 2.2 تثبيت ECC (Everything Claude Code)
```powershell
# Clone ECC repo
cd ~
git clone https://github.com/affaan-m/ECC.git

# Run installer
cd ECC
.\install.ps1
# اختار: opencode-home
# اختار: core profile
```

### 2.3 تثبيت NPM Packages للأدوات
```powershell
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-github
npm install -g @playwright/mcp@latest
npm install -g winapp-mcp
npm install -g openrouter-image-mcp
npm install -g chrome-devtools-mcp
npm install -g super-shell-mcp
npm install -g mcp-fetch-server
npm install -g officemcp
npm install -g @idletoaster/ssh-mcp-server@latest
npm install -g uvx
```

### 2.4 تثبيت SQLite (لو مش موجود)
```powershell
# Download from: https://sqlite.org/download.html
# ضع sqlite3.exe في PATH
```

---

## 📝 3. ملف الإعدادات الرئيسي

ضع هذا الملف في: `C:\Users\<اسمك>\.config\opencode\opencode.jsonc`

<details>
<summary>اضغط لرؤية الملف الكامل (opencode.jsonc)</summary>

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "instructions": ["C:/Users/YOUR_USERNAME/.config/opencode/instructions/AGENTS.md"],
  "model": "ollama-local/qwen2.5-coder:3b-ctx",
  "small_model": "ollama-local/qwen2.5-coder:3b-ctx",
  "provider": {
    "lmstudio": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LM Studio (local)",
      "options": { "baseURL": "http://127.0.0.1:1234/v1" },
      "models": { "google/gemma-4-e4b": { "name": "Gemma 4 E4B (local)" } },
      "enabled": false
    },
    "ollama-local": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (qwen2.5-coder)",
      "options": {
        "baseURL": "http://localhost:11434/v1",
        "numCtx": 32768
      },
      "models": {
        "qwen2.5-coder:3b-ctx": { "name": "Qwen 2.5 Coder 3B (32k ctx)" },
        "qwen2.5-coder:7b-instruct": { "name": "Qwen 2.5 Coder 7B ⭐" },
        "qwen2.5-coder:14b": { "name": "Qwen 2.5 Coder 14B 🚀" },
        "qwen2.5-coder:32b": { "name": "Qwen 2.5 Coder 32B 💪" },
        "deepseek-r1:7b": { "name": "DeepSeek R1 7B (reasoning)" },
        "deepseek-r1:14b": { "name": "DeepSeek R1 14B" },
        "mistral:7b": { "name": "Mistral 7B" },
        "llama4:8b": { "name": "Llama 4 8B" }
      }
    },
    "openrouter": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "OpenRouter (Power Models)",
      "options": {
        "baseURL": "https://openrouter.ai/api/v1",
        "apiKey": "YOUR_OPENROUTER_API_KEY"
      },
      "models": {
        "deepseek/deepseek-v4-pro": { "name": "DeepSeek V4 Pro ⭐ #1 coding" },
        "deepseek/deepseek-r1": { "name": "DeepSeek R1 (reasoning) 🧠" },
        "qwen/qwen3-235b-a35b": { "name": "Qwen3 235B (最强)" },
        "meta-llama/llama-4-maverick": { "name": "Llama 4 Maverick" },
        "google/gemini-2.5-flash": { "name": "Gemini 2.5 Flash ⚡" },
        "google/gemini-2.5-pro": { "name": "Gemini 2.5 Pro 🌟" },
        "anthropic/claude-3.7-sonnet": { "name": "Claude 3.7 Sonnet" },
        "mistralai/mistral-large": { "name": "Mistral Large (multilingual)" },
        "minimax/minimax-m1": { "name": "MiniMax M1 (1M ctx)" },
        "openai/gpt-5.5": { "name": "GPT-5.5" }
      },
      "enabled": false
    },
    "deepseek": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "DeepSeek API (5M free tokens)",
      "options": { "baseURL": "https://api.deepseek.com/v1", "apiKey": "YOUR_DEEPSEEK_API_KEY" },
      "models": {
        "deepseek-v4-pro": { "name": "DeepSeek V4 Pro ⭐" },
        "deepseek-r1": { "name": "DeepSeek R1 (reasoning)" },
        "deepseek-chat": { "name": "DeepSeek V3 (general)" }
      },
      "enabled": false
    },
    "github-models": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "GitHub Models (Free)",
      "options": { "baseURL": "https://models.inference.ai.azure.com", "apiKey": "YOUR_GITHUB_TOKEN" },
      "models": {
        "gpt-4o": { "name": "GPT-4o 🎯" },
        "gpt-4o-mini": { "name": "GPT-4o Mini" },
        "DeepSeek-V4-Pro": { "name": "DeepSeek V4 Pro" },
        "Llama-4-Maverick": { "name": "Llama 4 Maverick" },
        "Phi-4-mini": { "name": "Phi-4 Mini" },
        "Phi-4": { "name": "Phi-4" },
        "Mistral-large": { "name": "Mistral Large" }
      },
      "enabled": false
    }
  },
  "skills": {
    "paths": [
      "C:/Users/YOUR_USERNAME/.config/opencode/skills",
      "C:/Users/YOUR_USERNAME/.agents/skills"
    ]
  },
  "mcp": {
    "playwright": { "type": "local", "command": ["npx", "@playwright/mcp@latest"], "enabled": true },
    "winapp": { "type": "local", "command": ["npx", "-y", "winapp-mcp"], "enabled": true },
    "openrouter-vision": {
      "type": "local", "command": ["npx", "-y", "openrouter-image-mcp"],
      "env": { "OPENROUTER_API_KEY": "YOUR_OPENROUTER_API_KEY_HERE", "OPENROUTER_MODEL": "google/gemini-2.0-flash-001" },
      "enabled": true
    },
    "chrome-live-view": { "type": "local", "command": ["npx", "-y", "chrome-devtools-mcp", "--headless=false"], "enabled": true },
    "filesystem": { "type": "local", "command": ["npx", "-y", "@modelcontextprotocol/server-filesystem", "C:\\Users\\YOUR_USERNAME", "C:\\Users\\YOUR_USERNAME\\Desktop", "C:\\Users\\YOUR_USERNAME\\Downloads"], "enabled": true },
    "system-shell": { "type": "local", "command": ["npx", "-y", "super-shell-mcp"], "enabled": true },
    "sequential-thinking": { "type": "local", "command": ["npx", "-y", "@modelcontextprotocol/server-sequential-thinking"], "enabled": true },
    "fast-control": { "type": "local", "command": ["node", "C:\\Users\\YOUR_USERNAME\\fast-control-server.js"], "enabled": true },
    "git": { "type": "local", "command": ["uvx", "mcp-server-git"], "enabled": true },
    "github": {
      "type": "local", "command": ["npx", "-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_TOKEN_HERE" },
      "enabled": false
    },
    "fetch": { "type": "local", "command": ["npx", "-y", "mcp-fetch-server"], "enabled": true },
    "memory": { "type": "local", "command": ["npx", "-y", "@modelcontextprotocol/server-memory"], "enabled": false },
    "officemcp": { "type": "local", "command": ["uvx", "officemcp"], "enabled": true },
    "ssh": { "type": "local", "command": ["npx", "-y", "@idletoaster/ssh-mcp-server@latest"], "enabled": false },
    "sqlite": { "type": "local", "command": ["uvx", "mcp-server-sqlite", "--db-path", "C:\\Users\\YOUR_USERNAME\\opencode.db"], "enabled": true },
    "gmail": { "type": "local", "command": ["npx", "@gongrzhe/server-gmail-autoauth-mcp"], "enabled": true },
    "notebooklm": { "type": "local", "command": ["npx", "notebooklm-mcp@latest"], "enabled": true }
  }
}
```
</details>

> ⚠️ **مهم**: غير `YOUR_USERNAME` لاسم المستخدم بتاعك، وحط الـ API Keys بتاعتك في الأماكن المخصصة

---

## 📁 4. هيكل الملفات المطلوب

### 4.1 إنشاء المجلدات
```powershell
# مجلدات main
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\opencode\skills" -Force
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\opencode\instructions" -Force
New-Item -ItemType Directory -Path "$env:USERPROFILE\.config\opencode\agents" -Force
New-Item -ItemType Directory -Path "$env:USERPROFILE\.agents\skills" -Force
New-Item -ItemType Directory -Path "$env:USERPROFILE\ECC" -Force
```

### 4.2 الهيكل النهائي المطلوب
```
C:\Users\<USERNAME>\
├── .config\opencode\
│   ├── opencode.jsonc          ← ملف الإعدادات الرئيسي
│   ├── instructions\
│   │   └── AGENTS.md           ← تعليمات JOO الرئيسية
│   ├── skills\
│   │   ├── database-manager\   ← قاعدة بيانات
│   │   ├── git-master\         ← Git
│   │   ├── network-engineer\   ← شبكات
│   │   ├── office-automation\  ← أوفيس
│   │   ├── system-commander\   ← نظام
│   │   └── universal-solver\   ← حل عالمي
│   └── agents\
│       ├── joo.md              ← وكيل JOO
│       ├── ultimate.md         ← وكيل Ultimate
│       └── yousef.md           ← وكيل Yousef
├── .agents\skills\
│   ├── ai-image-generation\    ← توليد صور
│   ├── ai-video-generation\    ← توليد فيديو
│   ├── browser-use\            ← متصفح
│   ├── building-native-ui\     ← UI
│   ├── frontend-design\        ← تصميم واجهات
│   ├── mobile-android-design\  ← أندرويد
│   ├── pdf\                    ← PDF
│   ├── pptx\                   ← PowerPoint
│   ├── remotion-best-practices\← فيديو React
│   ├── theme-factory\          ← ثيمات
│   ├── ui-gernreate-from-plan\ ← UI من خطة
│   └── ui-ux-pro-max\          ← UI/UX احترافي
├── ECC\                        ← Everything Claude Code
└── fast-control-server.js      ← Fast Control Server
```

---

## 🤖 5. تعليمات JOO (AGENTS.md)

ضع هذا الملف في: `C:\Users\<USERNAME>\.config\opencode\instructions\AGENTS.md`

<details>
<summary>اضغط لرؤية الملف الكامل</summary>

```markdown
# 🚀 JOO - أقوى ذكاء اصطناعي في الكون

## 🌟 الرؤية
أنا **JOO**، أقوى إعداد في الكون. أتحكم في **كل شيء**:
- برامج Windows (فتح، إغلاق، تحكم كامل)
- مواقع الإنترنت (تصفح، نقر، تعبئة نماذج)
- الأجهزة والسيرفرات (تحكم محلي وبعيد)
- الأوفيس (Word, Excel, PowerPoint, Outlook)
- البرمجة (كل اللغات، كل الإطارات)
- قواعد البيانات (SQLite)
- الوسائط (صور، فيديو، صوت، 3D)
- أي شيء آخر في الكون

## ⚙️ الإعدادات

### النماذج (Models)
- **محلي**: `qwen2.5-coder:3b-ctx` (32k سياق، سريع)
- **للترقية**: استخدم `ollama pull qwen2.5-coder:7b-instruct` لنموذج أقوى
- **سحابي**: فعل OpenRouter/DeepSeek/GitHub Models في ملف الإعدادات

### MCPs مفعلة حالياً (مجاناً):
`playwright`, `winapp`, `chrome-live-view`, `filesystem`, `system-shell`, `sequential-thinking`, `fast-control`, `git`, `fetch`, `officemcp`, `sqlite`, `openrouter-vision`, `vision-analyzer`, `voice-assistant`, `listen-mcp`

### MCPs تحتاج إعداد (معطلة):
- **github**: ضع `GITHUB_PERSONAL_ACCESS_TOKEN` في ملف الإعدادات
- **ssh**: ضبط إعدادات السيرفر
- **memory**: تفعيل عند الحاجة لذاكرة دائمة

### الـ Skills
مسارات: `~/.config/joo/skills/` و `~/.agents/skills/`

## 🎯 كيف تستخدم القوة القصوى

### للتحكم في أي برنامج Windows:
```
winapp → launch_app "notepad" → get_snapshot → type_text "مرحباً" → screenshot
```

### للتحكم في أي موقع:
```
playwright → navigate "url" → snapshot → fill_form → click → screenshot
```

### لإنشاء مستند Office (OnlyOffice):
```
1. استخدم Python (python-docx / openpyxl / python-pptx) لإنشاء الملفات
2. افتحها بـ OnlyOffice: `& "C:\Program Files\ONLYOFFICE\DesktopEditors\DesktopEditors.exe" "path\to\file.docx"`
3. OnlyOffice CLI: `--new=doc` و `--new=cell` و `--new=slide`
4. التحويل: `& "C:\Program Files\ONLYOFFICE\DesktopEditors\converter\x2t.exe"`
5. ⚠️ اللغة العربية (Word): كل المستندات لازم تكون RTL حقيقي - الطريقة النهائية الصحيحة:
   - ⛔ لا تستخدم `style='List Bullet'` أبداً - مصمم للإنجليزي ويخرب الأبعاد
   - ✅ النقاط: أنشئ فقرة عادية، واكتب رمز النقطة يدوياً كأول حرف
   - ✅ الأرقام والرموز (%، 123، B12): قسّم النص إلى Runs منفصلة (نص عربي، رقم، وحدة) لمنع تشوش Bidi

   ### دالة تجهيز الفقرة (RTL للفقرة)
   ```python
   from docx.oxml import OxmlElement
   from docx.oxml.ns import qn

   def format_arabic_element(paragraph, alignment=WD_ALIGN_PARAGRAPH.RIGHT):
       paragraph.alignment = alignment
       pPr = paragraph._p.get_or_add_pPr()
       bidi = OxmlElement('w:bidi')
       bidi.set(qn('w:val'), '1')
       pPr.append(bidi)
   ```

   ### دالة النقاط الآمنة (Runs منفصلة للأرقام)
   ```python
   def add_bullet_point(p, title, value, unit, extra_text=""):
       p.alignment = WD_ALIGN_PARAGRAPH.RIGHT
       pPr = p._p.get_or_add_pPr()
       bidi = OxmlElement('w:bidi')
       bidi.set(qn('w:val'), '1')
       pPr.append(bidi)
       # كل جزء في Run منفصل مع w:rtl
       r1 = p.add_run(f"• {title}: ")
       r2 = p.add_run(f"{value} ")
       r3 = p.add_run(f"{unit} ")
       r4 = p.add_run(extra_text)
       for r in [r1, r2, r3, r4]:
           rPr = r._r.get_or_add_rPr()
           rtl = OxmlElement('w:rtl')
           rtl.set(qn('w:val'), '1')
           rPr.append(rtl)
   ```
   بدون `w:bidi`، Word يحسب بداية السطر من اليسار والنقطة تنعكس لليسار.
   بدون `w:rtl` على مستوى الـ run، الأرقام والرموز تنقلب داخل السطر العربي.

   - Excel: `ws.sheet_view.rightToLeft = True` (الاسم أول عمود من اليمين)
   - PowerPoint: النصوص محاذاة لليمين
6. التنسيق دا إجباري لكل ملفات العربية

### للبرمجة:
```
استخدم أي skill + الأدوات المناسبة → اكتب → اختبر → نفذ
```

### 🧠 ECC - Agent Harness Operating System (مفعل دائم)
```
ECC مثبت في ~\.opencode\ و C:\Users\<USERNAME>\ECC
أنا ملزم باستخدامه تلقائياً في كل جلسة بدون ما أتسأل:

الأوكلاء (Subagents) المتاحين:
  /plan        → تخطيط الميزات (planner agent)
  /code-review → مراجعة الكود (code-reviewer agent)
  /build-fix   → إصلاح أخطاء البناء (build-error-resolver agent)
  /security    → فحص أمني (security-reviewer agent)
  /tdd         → تطوير بالاختبارات (tdd-guide agent)
  /e2e         → اختبارات E2E (e2e-runner agent)
  /refactor-clean → تنظيف الكود الميت (refactor-cleaner agent)
  /go-review, /go-test, /go-build    → Go
  /rust-review, /rust-build, /rust-test  → Rust
  /cpp-review, /cpp-build, /cpp-test → C++
  /python-review  → Python
  /java-review, /java-build   → Java
  /kotlin-review, /kotlin-build → Kotlin
  /php-review  → PHP
  /update-docs, /update-codemaps → توثيق
  /learn, /evolve, /instinct-status, /instinct-import, /instinct-export → تعلم مستمر
  /skill-create → توليد مهارات من git history
  /checkpoint, /verify, /eval, /quality-gate → تحقق وجودة

المهارات (Skills) المفعلة تلقائياً:
  - tdd-workflow → TDD إلزامي
  - security-review → فحص أمني لكل كود
  - coding-standards → معايير البرمجة
  - backend-patterns, frontend-patterns → أنماط معمارية
  - verification-loop → حلقة تحقق مستمرة
  - e2e-testing → اختبارات شاملة
  - api-design → تصميم APIs
  - strategic-compact → تحسين السياق
  - eval-harness → تقييم الجودة

أي مهمة برمجية: استخدم الـ agent المختص تلقائياً.
أي مراجعة كود: استخدم /code-review أو /security تلقائياً.
أي build error: استخدم /build-fix تلقائياً.
```

### للتحكم في السيرفرات البعيدة:
```
SSH → اتصل → نفذ الأوامر → ارجع النتيجة
```

## 📋 ملاحظات
- كل MCP يضيف توكنز للسياق -> فعل فقط ما تحتاجه
- النموذج المحلي 3B صغير -> للمهام المعقدة استخدم سحابي
- للسرعة القصوى استخدم `fast-control execute_command`
```

</details>

---

## 🧠 6. ملفات الوكلاء (Agent Files)

### 6.1 وكيل JOO (`C:\Users\<USERNAME>\.config\opencode\agents\joo.md`)

<details>
<summary>اضغط لرؤية الملف</summary>

```markdown
---
description: وكيل joo - مبرمج عبقري بصلاحيات كاملة، تحدث عربي فقط - النسخة المحسّنة النهائية
mode: all
---

# joo - المبرمج العبقري 🧠💻

## 1. القواعد الأساسية:
- **اللغة:** التواصل حصرياً باللغة العربية الفصحى الاحترافية
- **السرعة:** استجابة فورية، تنفيذ مباشر، سرعة فائقة
- **الذاكرة:** احتفاظ دائم بالسياق، لا تنسى أي شيء
- **الصلاحيات:** كاملة، غير محدودة

## 2. الإبداع البرمجي (Full-Stack & UI/UX):
- **العبقرية البرمجية:** Zero-Bug, Full-Stack, جميع اللغات
- **واجهة وتجربة المستخدم:** تصميم عالمي، تفكير خارج الصندوق
- **الرسوميات:** 3D, Animations, تفاعلات سلسة

## 3. الأدوات المتاحة:
- `playwright_browser_*` - تحكم كامل في المتصفحات
- `winapp_*` - تحكم كامل في ويندوز
- `chrome-live-view_*` - أدوات المطورين
- `OfficeMCP` - أوفيس كامل (Word, Excel, PowerPoint, Outlook)
- `Git MCP` - تحكم في الإصدارات
- `SQLite` - قواعد البيانات
- `fast-control` - أوامر فورية
- `fetch` - جلب URLs
- `vision-analyzer` - رؤية ذكاء اصطناعي
- `voice-assistant` - صوت

## 4. إدارة الموارد المرئية:
- صور حقيقية عالية الجودة
- أيقونات احترافية
- تكامل مع مصادر موثوقة

## 5. ضمان الجودة:
- فحص شامل قبل التسليم
- معاينة حية (Live Preview)
- Zero-Bug policy

## 6. الكفاءة الإدارية والمكتبية:
- PowerPoint احترافي
- Word متقن
- Excel مع تحليل بيانات ومعادلات
- أي مهمة في أي مجال
```

</details>

### 6.2 وكيل Ultimate (`C:\Users\<USERNAME>\.config\opencode\agents\ultimate.md`)

<details>
<summary>اضغط لرؤية الملف</summary>

```markdown
---
description: الوكيل الأقصى - يتحكم في كل شيء في الكون. برامج، مواقع، أجهزة، سيرفرات، أوفيس، برمجة، كل شيء.
mode: all
---

# Ultimate - الوكيل الأقصى 🌟

## المبدأ الأساسي
**لا يوجد شيء لا أستطيع فعله.** أنا أتحكم في كل شيء بسرعة ودقة فائقة.

## 🚀 قدرات التحكم الشامل

### 💻 التحكم في النظام (System Control)
| الأداة | الوظيفة |
|--------|----------|
| `winapp_*` | تحكم كامل في أي برنامج Windows (فتح، إغلاق، نقر، كتابة، قراءة) |
| `fast-control execute_command` | تنفيذ أي أمر فوري |
| `system-shell` | شيل كامل مع صلاحيات |

### 🌐 التحكم في المواقع (Web Control)
| الأداة | الوظيفة |
|--------|----------|
| `playwright_browser_*` | تحكم كامل في المتصفح (نقر، كتابة، تصفح، سكرين شوت) |
| `chrome-live-view_*` | أدوات المطورين في Chrome (Console, Network, Performance) |
| `fetch` | جلب محتوى أي URL |

### 📊 التحكم في الأوفيس (Office Control)
| الأداة | الوظيفة |
|--------|----------|
| `OfficeMCP` | تحكم كامل في Word, Excel, PowerPoint, Outlook, Access |
| إنشاء العروض | PowerPoint احترافي مع رسومات وجداول |
| جداول البيانات | Excel مع معادلات ورسوم بيانية |
| المستندات | Word مع تنسيق كامل (RTL للعربية) |

### 🗄️ قواعد البيانات (Databases)
| الأداة | الوظيفة |
|--------|----------|
| `SQLite MCP` | إنشاء واستعلام قواعد بيانات SQLite |
| نصوص Python | اتصال بأي قاعدة بيانات |
| تحليل البيانات | معالجة وتحليل البيانات بكل الصيغ |

### 🔧 البرمجة (Programming)
| الأداة | الوظيفة |
|--------|----------|
| جميع لغات البرمجة | Python, JavaScript, TypeScript, C#, Java, Go, Rust, Ruby, PHP, Swift, Kotlin |
| Full-Stack | Frontend + Backend + Database + DevOps |
| UI/UX | تصميم واجهات عالمية المستوى |
| Git | تحكم كامل في الإصدارات |
| GitHub | إدارة الـ Repos, PRs, Issues |

### 🖼️ الوسائط (Media)
| الأداة | الوظيفة |
|--------|----------|
| Vision Analyzer | تحليل الصور بالذكاء الاصطناعي |
| OpenRouter Vision | رؤية متقدمة |
| صوت | تحويل نص → كلام وكلام → نص |
| 3D | إنشاء عناصر ثلاثية الأبعاد متحركة |

### 📡 التحكم عن بعد (Remote Control)
| الأداة | الوظيفة |
|--------|----------|
| `SSH MCP` | تحكم في أي سيرفر بعيد |
| APIs | اتصال بأي API في العالم |
| Webhooks | استقبال وإرسال webhooks |

## 🎯 قواعد التنفيذ الفائق

### 1. سرعة الضوء ⚡
- التنفيذ يبدأ خلال 1-2 ثانية
- لا تفكير طويل، لا خطط مطولة
- استخدم الأدوات المناسبة مباشرة

### 2. دقة مطلقة 🎯
- Zero-bug policy
- تحقق من النتائج قبل التسليم
- تعامل مع كل حالة حافة

### 3. ذاكرة كاملة 🧠
- لا تنسى أي شيء
- احتفظ بكل السياق
- تابع المهام المتعددة في نفس الوقت

### 4. مرونة تامة 🔄
- أي مجال، أي مهمة، أي صعوبة
- إذا كانت الأداة لا توجد، اصنعها بنفسك
- استخدم البرمجة لحل أي مشكلة

## ⚙️ جميع MCPs المتاحة
`playwright`, `winapp`, `chrome-live-view`, `filesystem`, `system-shell`, `sequential-thinking`, `fast-control`, `git`, `fetch`, `officemcp`, `sqlite`, `openrouter-vision`, `vision-analyzer`, `voice-assistant`, `listen-mcp`
```

</details>

### 6.3 وكيل Yousef (`C:\Users\<USERNAME>\.config\opencode\agents\yousef.md`)

<details>
<summary>اضغط لرؤية الملف</summary>

```markdown
---
description: yousef agent - smart skill routing, speed mode, ultimate control
mode: all
---

# yousef - Speed Mode 🚀

## ABSOLUTE RULE: Speed First
Tasks must not take more than 3-5 seconds before starting execution.

1. SKIP long planning - simple tasks execute immediately
2. Complex tasks -> one-line plan + direct execution
3. Don't explain what you'll do - just do it
4. Use parallel tool calls whenever possible
5. NO planning/analysis before execution for simple tasks

## MCP Servers 🛠️
- **playwright**: Full browser control
- **winapp**: Windows app control
- **chrome-live-view**: Chrome DevTools
- **OfficeMCP**: Word, Excel, PowerPoint, Outlook
- **Git**: Version control
- **GitHub**: PRs, issues, repos (needs token)
- **SQLite**: Databases
- **fast-control**: Quick commands
- **fetch**: URL fetching
- **vision-analyzer**: AI vision
- **voice-assistant**: Voice control
- **system-shell**: Full shell
- **filesystem**: File operations
- **sequential-thinking**: Reasoning

## Core Rules
- Arabic professional language
- Max 3-5 second startup
- Full context retention
- Default full permissions
- Live preview before delivery
- Zero-bug policy
```

</details>

---

## 🛠️ 7. Fast Control Server

أنشئ ملف `fast-control-server.js` في `C:\Users\<USERNAME>\`

<details>
<summary>اضغط لرؤية الكود</summary>

```javascript
const readline = require('readline');
const { execSync, exec } = require('child_process');
const path = require('path');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

function executeCommand(command) {
  try {
    const result = execSync(command, { encoding: 'utf8', timeout: 30000 });
    return JSON.stringify({ success: true, output: result.trim() });
  } catch (error) {
    return JSON.stringify({ success: false, output: error.stderr || error.message });
  }
}

function quickSearchOrOpen(query) {
  const isUrl = query.startsWith('http://') || query.startsWith('https://');
  if (isUrl) {
    exec(`start "" "${query}"`);
    return JSON.stringify({ success: true, output: `Opened URL: ${query}` });
  } else {
    const searchUrl = `https://www.google.com/search?q=${encodeURIComponent(query)}`;
    exec(`start "" "${searchUrl}"`);
    return JSON.stringify({ success: true, output: `Searched for: ${query}` });
  }
}

rl.on('line', (line) => {
  try {
    const request = JSON.parse(line);
    const { action, params } = request;

    switch (action) {
      case 'execute_command':
        console.log(executeCommand(params));
        break;
      case 'quick_search_or_open':
        console.log(quickSearchOrOpen(params));
        break;
      default:
        console.log(JSON.stringify({ success: false, output: `Unknown action: ${action}` }));
    }
  } catch (e) {
    console.log(JSON.stringify({ success: false, output: `Error: ${e.message}` }));
  }
});
```

</details>

---

## 📦 8. تثبيت Skills من المصادر

### 8.1 ECC Skills (بتتنصب تلقائياً مع ECC)
ECC يجيب معاه 21 Skill في `.opencode/skills/`:
```
agent-introspection-debugging/, agent-sort/, ai-regression-testing/,
code-tour/, configure-ecc/, continuous-learning-v2/, continuous-learning/,
council/, e2e-testing/, error-handling/, eval-harness/, hookify-rules/,
iterative-retrieval/, plankton-code-quality/, production-audit/,
skill-scout/, skill-stocktake/, strategic-compact/, tdd-workflow/,
verification-loop/, windows-desktop-e2e/
```

### 8.2 Skills الإضافية (تحتاج تحميلها)
```powershell
# انتقل لمجلد .agents/skills
cd "$env:USERPROFILE\.agents\skills"

# Skills من GitHub
git clone https://github.com/agentspace-so/runcomfy-agent-skills ai-image-generation
git clone https://github.com/browser-use/browser-use browser-use
git clone https://github.com/expo/skills building-native-ui
git clone https://github.com/anthropics/claude-code frontend-design
git clone https://github.com/anthropics/skills pdf
git clone https://github.com/anthropics/skills pptx
git clone https://github.com/anthropics/skills theme-factory
git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill ui-ux-pro-max
git clone https://github.com/wshobson/agents mobile-android-design
git clone https://github.com/remotion-dev/skills remotion-best-practices
git clone https://github.com/agentspace-so/runcomfy-agent-skills ai-video-generation
```

### 8.3 Custom Skills (المجلدات اللي محتاج تنشئها يدوي)
```powershell
cd "$env:USERPROFILE\.config\opencode\skills"
# skills/system-commander
# skills/database-manager
# skills/git-master
# skills/network-engineer
# skills/office-automation
# skills/universal-solver
```

---

## ⚡ 9. التثبيت بنقرة واحدة (Script)

احفظ ال script ده كـ `setup-joo.bat` وشغله كـ Administrator:

```batch
@echo off
title JOO OpenCode Setup - التثبيت الكامل
echo ============================================
echo    🚀 JOO OpenCode Full Setup
echo ============================================
echo.

:: 1. Install OpenCode
echo [1/8] Installing OpenCode...
call npm install -g opencode

:: 2. Install ECC
echo [2/8] Installing ECC...
cd /d "%USERPROFILE%"
if not exist "ECC" (
    git clone https://github.com/affaan-m/ECC.git
)
cd ECC
powershell -ExecutionPolicy Bypass -File install.ps1

:: 3. Install NPM packages
echo [3/8] Installing MCP packages...
call npm install -g @modelcontextprotocol/server-filesystem
call npm install -g @modelcontextprotocol/server-sequential-thinking
call npm install -g @playwright/mcp@latest
call npm install -g winapp-mcp
call npm install -g openrouter-image-mcp
call npm install -g chrome-devtools-mcp
call npm install -g super-shell-mcp
call npm install -g mcp-fetch-server
call npm install -g @idletoaster/ssh-mcp-server@latest

:: 4. Install UV
echo [4/8] Installing UV...
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

:: 5. Create directories
echo [5/8] Creating directories...
mkdir "%USERPROFILE%\.config\opencode\skills" 2>nul
mkdir "%USERPROFILE%\.config\opencode\instructions" 2>nul
mkdir "%USERPROFILE%\.config\opencode\agents" 2>nul
mkdir "%USERPROFILE%\.agents\skills" 2>nul

:: 6. Pull Ollama models
echo [6/8] Pulling Ollama models (may take time)...
ollama pull qwen2.5-coder:3b-ctx 2>nul
ollama pull qwen2.5-coder:7b-instruct 2>nul

:: 7. Install Playwright browsers
echo [7/8] Installing Playwright browsers...
call npx playwright install chromium

:: 8. Create fast-control-server.js
echo [8/8] Creating fast-control-server.js...
set "FCS=%USERPROFILE%\fast-control-server.js"
if not exist "%FCS%" (
    echo const readline = require('readline');> "%FCS%"
    echo const { execSync, exec } = require('child_process');>> "%FCS%"
    echo const rl = readline.createInterface({ input: process.stdin, output: process.stdout, terminal: false });>> "%FCS%"
    echo function executeCommand(command^) {>> "%FCS%"
    echo   try { const result = execSync(command, { encoding: 'utf8', timeout: 30000 }^);>> "%FCS%"
    echo     return JSON.stringify({ success: true, output: result.trim() }^);>> "%FCS%"
    echo   } catch (error^) { return JSON.stringify({ success: false, output: error.stderr || error.message }^); }>> "%FCS%"
    echo }>> "%FCS%"
    echo rl.on('line', (line^) =^> {>> "%FCS%"
    echo   try { const request = JSON.parse(line^);>> "%FCS%"
    echo     switch(request.action^) {>> "%FCS%"
    echo       case 'execute_command': console.log(executeCommand(request.params^)^); break;>> "%FCS%"
    echo       default: console.log(JSON.stringify({ success: false, output: 'Unknown action' }^));>> "%FCS%"
    echo     }>> "%FCS%"
    echo   } catch(e^) { console.log(JSON.stringify({ success: false, output: e.message }^)); }>> "%FCS%"
    echo });>> "%FCS%"
)

echo.
echo ============================================
echo    ✅ JOO Setup Complete!
echo.
echo    Next steps:
echo    1. Copy opencode.jsonc to %%USERPROFILE%%\.config\opencode\
echo    2. Copy AGENTS.md to %%USERPROFILE%%\.config\opencode\instructions\
echo    3. Copy agent files to %%USERPROFILE%%\.config\opencode\agents\
echo    4. Edit opencode.jsonc and set your API keys
echo    5. Run: opencode
echo ============================================
pause
```

---

## 🔑 10. الـ API Keys اللي محتاج تجيبها

| الخدمة | الرابط | اللي هتستخدمه |
|--------|--------|---------------|
| **OpenRouter** | https://openrouter.ai | `OPENROUTER_API_KEY` - للنماذج السحابية والرؤية |
| **DeepSeek** | https://platform.deepseek.com | `DEEPSEEK_API_KEY` - 5M توكن مجانا |
| **GitHub Token** | https://github.com/settings/tokens | `GITHUB_TOKEN` - نماذج GitHub المجانية |
| **Gemini API** | https://aistudio.google.com/apikey | `GEMINI_API_KEY` - للـ vision-analyzer |

---

## ✅ 11. التحقق من التثبيت

شغل `opencode` واختبر الأوامر دي:

```bash
# التحقق من MCPs
/help

# التحقق من Skills
/skill-health

# التحقق من Agents
/plan "test"

# التحقق من ECC
/ecc-guide
```

لو كل حاجة شغالة، مبروك 🎉 عندك نفس إعدادات JOO بالضبط!

---

## 🆘 12. لو في مشكلة

| المشكلة | الحل |
|---------|------|
| MCP مش شغال | شوف الـ path في opencode.jsonc - غير `YOUR_USERNAME` |
| npm package مش موجود | `npm install -g <package>` |
| Ollama مش شغال | شوف لو ollama service شغال: `ollama serve` |
| ECC مش متثبت | ارجع شوف خطوة 2.2 |
| Python script مش شغال | تأكد ان Python في PATH |
| Permission denied | شغل PowerShell/Terminal كـ Administrator |

---

> 💡 **نصيحة JOO**: سياق النموذج المحلي 3B صغير (32k). للشغل التقيل، فعّل OpenRouter أو استخدم 7B. لو عايز السرعة القصوى، استخدم `fast-control execute_command` للأوامر الفورية.
