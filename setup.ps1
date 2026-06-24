param(
  [string]$InstallDir = "$env:USERPROFILE",
  [switch]$NoOllama,
  [switch]$NoMCP,
  [switch]$NoECC,
  [switch]$NoModels,
  [switch]$Help
)

if ($Help) {
  Write-Host @"
JOO Setup v1.0 - Ultimate AI Coding Agent Installer
Usage: .\setup.ps1 [options]
  -NoOllama    Skip Ollama installation
  -NoMCP       Skip MCP server installation
  -NoECC       Skip ECC (agent harness) setup
  -NoModels    Skip Ollama model pull
"@
  exit 0
}

$JOO_HOME = "$InstallDir\.joo"
$JOO_CONFIG = "$InstallDir\.config\joo"
$OPENCODE_DIR = "$InstallDir\.opencode"
$AGENTS_DIR = "$InstallDir\.agents"
$BUNDLE = "$PSScriptRoot\_bundle"

$USERPROFILE_BAK = $InstallDir -replace '\\', '\\'  # Replace single \ with \\ for JSON safety
$USERPROFILE_FWD = $InstallDir -replace '\\', '/'

Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     JOO - Ultimate AI Coding Agent      ║" -ForegroundColor Cyan
Write-Host "║           Setup Installer v1.0          ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "Install Dir : $InstallDir" -ForegroundColor White
Write-Host "JOO Home    : $JOO_HOME" -ForegroundColor White
Write-Host "Config      : $JOO_CONFIG" -ForegroundColor White
Write-Host ""

function Step($msg) { Write-Host "  → $msg" -ForegroundColor Yellow }
function Ok($msg) { Write-Host "    ✓ $msg" -ForegroundColor Green }
function Skip($msg) { Write-Host "    - $msg" -ForegroundColor DarkYellow }
function ErrorMsg($msg) { Write-Host "    ✗ $msg" -ForegroundColor Red }

# ============================================================
# PHASE 1: Prerequisites
# ============================================================
Write-Host "Phase 1: Prerequisites" -ForegroundColor Magenta

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 5) {
  ErrorMsg "PowerShell 5+ required. Install from https://aka.ms/powershell"
  exit 1
}
Ok "PowerShell $($PSVersionTable.PSVersion)"

# Check if running as admin (helpful for winget)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# ---- Git ----
Step "Checking Git..."
$gitPath = (Get-Command git -ErrorAction SilentlyContinue).Source
if (-not $gitPath) {
  Write-Host "    Installing Git..." -ForegroundColor Yellow
  try {
    if ($isAdmin) {
      winget install Git.Git --silent --accept-package-agreements 2>&1 | Out-Null
      $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")
    } else {
      Skip "Run as Administrator for auto-install, or install Git manually from https://git-scm.com"
      Skip "Continuing without Git..."
    }
  } catch { Skip "Git install failed, continuing..." }
} else { Ok "Git: $gitPath" }

# ---- Node.js ----
Step "Checking Node.js..."
$nodePath = (Get-Command node -ErrorAction SilentlyContinue).Source
if (-not $nodePath) {
  Write-Host "    Installing Node.js..." -ForegroundColor Yellow
  try {
    if ($isAdmin) {
      winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements 2>&1 | Out-Null
      $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")
      $nodePath = (Get-Command node -ErrorAction SilentlyContinue).Source
    } else {
      Skip "Run as Administrator for auto-install, or install Node.js from https://nodejs.org"
    }
  } catch { Skip "Node.js install failed, continuing..." }
} else { Ok "Node.js: $nodePath" }

# ---- npm ----
if ($nodePath) {
  $npmPath = (Get-Command npm -ErrorAction SilentlyContinue).Source
  if ($npmPath) { Ok "npm: $npmPath" } else { Skip "npm not found" }
}

# ---- Python ----
Step "Checking Python..."
$pythonPath = (Get-Command python -ErrorAction SilentlyContinue).Source
if (-not $pythonPath) {
  Write-Host "    Installing Python..." -ForegroundColor Yellow
  try {
    if ($isAdmin) {
      winget install Python.Python.3.12 --silent --accept-package-agreements 2>&1 | Out-Null
      $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")
      $pythonPath = (Get-Command python -ErrorAction SilentlyContinue).Source
    } else {
      Skip "Run as Administrator for auto-install, or install Python from https://python.org"
    }
  } catch { Skip "Python install failed, continuing..." }
} else { Ok "Python: $pythonPath" }

# ---- uv (Python package manager for officemcp/sqlite) ----
Step "Checking uv..."
$uvPath = (Get-Command uv -ErrorAction SilentlyContinue).Source
if (-not $uvPath -and $pythonPath) {
  Write-Host "    Installing uv..." -ForegroundColor Yellow
  try {
    powershell -c "irm https://astral.sh/uv/install.ps1 | iex" 2>$null
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")
  } catch { Skip "uv install failed, continuing..." }
} elseif ($uvPath) { Ok "uv: $uvPath" } else { Skip "uv not available" }

# ---- Ollama ----
if (-not $NoOllama) {
  Step "Checking Ollama..."
  $ollamaPath = (Get-Command ollama -ErrorAction SilentlyContinue).Source
  if (-not $ollamaPath) {
    Write-Host "    Installing Ollama..." -ForegroundColor Yellow
    try {
      if ($isAdmin) {
        winget install Ollama.Ollama --silent --accept-package-agreements 2>&1 | Out-Null
        $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")
        $ollamaPath = (Get-Command ollama -ErrorAction SilentlyContinue).Source
      } else {
        Skip "Run as Administrator for auto-install, or install Ollama from https://ollama.com"
      }
    } catch { Skip "Ollama install failed" }
  } else { Ok "Ollama: $ollamaPath" }
} else { Skip "Ollama (skipped by -NoOllama)" }

Write-Host ""

# ============================================================
# PHASE 2: Core JOO Setup
# ============================================================
Write-Host "Phase 2: Core JOO Installation" -ForegroundColor Magenta

# ---- Install opencode-ai globally (needed for binary) ----
Step "Installing opencode-ai (base binary)..."
if ($nodePath) {
  try {
    $oc = npm list -g opencode-ai 2>$null | Select-String "opencode-ai"
    if (-not $oc) {
      npm install -g opencode-ai 2>&1 | Out-Null
      Ok "opencode-ai installed globally"
    } else { Ok "opencode-ai already installed" }
  } catch { ErrorMsg "npm install opencode-ai failed: $_" }
} else { Skip "Node.js required for opencode-ai" }

# ---- Create ~/.joo/ directories ----
Step "Creating JOO runtime directories..."
@("$JOO_HOME\bin", "$JOO_HOME\temp", "$JOO_HOME\plugins", "$JOO_HOME\prompts", "$JOO_HOME\scripts", "$JOO_HOME\skills") | ForEach-Object {
  New-Item -ItemType Directory -Path $_ -Force | Out-Null
}
Ok "JOO runtime directories created"

# ---- Copy JOO binary from opencode ----
Step "Setting up JOO binary..."
$npmRoot = (npm root -g 2>$null)
$opencodeBin = if ($npmRoot) { Join-Path (Split-Path $npmRoot -Parent) "opencode-ai\bin\opencode.exe" } else { $null }
if ($opencodeBin -and (Test-Path $opencodeBin)) {
  Copy-Item -Path $opencodeBin -Destination "$JOO_HOME\bin\joo.exe" -Force
  Ok "Binary copied from opencode-ai"
} else {
  Skip "Binary not found. It will auto-download when you run 'joo' for the first time"
}

# ---- Copy launcher scripts ----
Step "Copying launcher scripts..."
Copy-Item -Path "$BUNDLE\launcher\joo.ps1" -Destination "$JOO_HOME\joo.ps1" -Force
Copy-Item -Path "$BUNDLE\launcher\joo.cmd" -Destination "$JOO_HOME\joo.cmd" -Force
Copy-Item -Path "$BUNDLE\launcher\yousef.ps1" -Destination "$JOO_HOME\yousef.ps1" -Force
Copy-Item -Path "$BUNDLE\launcher\yousef.cmd" -Destination "$JOO_HOME\yousef.cmd" -Force
Ok "Launcher scripts installed (joo + yousef)"

# ---- Create ~/.config/joo/ ----
Step "Creating JOO config directories..."
New-Item -ItemType Directory -Path "$JOO_CONFIG" -Force | Out-Null
New-Item -ItemType Directory -Path "$JOO_CONFIG\instructions" -Force | Out-Null
New-Item -ItemType Directory -Path "$JOO_CONFIG\skills" -Force | Out-Null
New-Item -ItemType Directory -Path "$JOO_CONFIG\agents" -Force | Out-Null
Ok "Config directories created"

# ---- Copy config with path substitution ----
Step "Installing config files..."
$configTemplate = Get-Content -Path "$BUNDLE\config\joo.jsonc" -Raw
$configProcessed = $configTemplate -replace "{{USERPROFILE}}", $USERPROFILE_BAK
$configProcessed = $configProcessed -replace "{{USERPROFILE_FWD}}", $USERPROFILE_FWD
Set-Content -Path "$JOO_CONFIG\joo.jsonc" -Value $configProcessed -NoNewline
Copy-Item -Path "$BUNDLE\config\tui.json" -Destination "$JOO_CONFIG\tui.json" -Force
Ok "Config files installed"

# ---- Copy instructions ----
Step "Installing instructions (AGENTS.md)..."
Copy-Item -Path "$BUNDLE\instructions\AGENTS.md" -Destination "$JOO_CONFIG\instructions\AGENTS.md" -Force
Ok "Instructions installed"

# ---- Copy JOO skills ----
Step "Installing JOO skills..."
robocopy "$BUNDLE\joo-skills" "$JOO_CONFIG\skills" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
Ok "JOO skills installed"

# ---- Copy JOO agents ----
Step "Installing JOO agents..."
robocopy "$BUNDLE\joo-agents" "$JOO_CONFIG\agents" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
Ok "JOO agents installed"

Write-Host ""

# ============================================================
# PHASE 3: OpenCode Skills & ECC
# ============================================================
Write-Host "Phase 3: Skills & ECC Setup" -ForegroundColor Magenta

# ---- OpenCode skills directory ----
Step "Setting up OpenCode skills..."
New-Item -ItemType Directory -Path "$OPENCODE_DIR\skills" -Force | Out-Null
robocopy "$BUNDLE\opencode\skills" "$OPENCODE_DIR\skills" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
Ok "OpenCode skills installed"

if (-not $NoECC) {
  # ---- OpenCode commands ----
  New-Item -ItemType Directory -Path "$OPENCODE_DIR\commands" -Force | Out-Null
  if (Test-Path "$BUNDLE\opencode\commands") {
    robocopy "$BUNDLE\opencode\commands" "$OPENCODE_DIR\commands" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
    Ok "OpenCode commands installed"
  }

  # ---- OpenCode hooks ----
  New-Item -ItemType Directory -Path "$OPENCODE_DIR\hooks" -Force | Out-Null
  if (Test-Path "$BUNDLE\opencode\hooks") {
    robocopy "$BUNDLE\opencode\hooks" "$OPENCODE_DIR\hooks" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
    Ok "OpenCode hooks installed"
  }

  # ---- OpenCode instructions ----
  New-Item -ItemType Directory -Path "$OPENCODE_DIR\instructions" -Force | Out-Null
  if (Test-Path "$BUNDLE\opencode\instructions") {
    robocopy "$BUNDLE\opencode\instructions" "$OPENCODE_DIR\instructions" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
    Ok "OpenCode instructions installed"
  }

  # ---- OpenCode plugins ----
  New-Item -ItemType Directory -Path "$OPENCODE_DIR\plugins" -Force | Out-Null
  if (Test-Path "$BUNDLE\opencode\plugins") {
    robocopy "$BUNDLE\opencode\plugins" "$OPENCODE_DIR\plugins" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
    Ok "OpenCode plugins installed"
  }

  # ---- OpenCode mcp-configs ----
  if (Test-Path "$BUNDLE\opencode\mcp-configs") {
    New-Item -ItemType Directory -Path "$OPENCODE_DIR\mcp-configs" -Force | Out-Null
    robocopy "$BUNDLE\opencode\mcp-configs" "$OPENCODE_DIR\mcp-configs" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
    Ok "OpenCode MCP configs installed"
  }

  # ---- OpenCode prompts ----
  if (Test-Path "$BUNDLE\opencode\prompts") {
    New-Item -ItemType Directory -Path "$OPENCODE_DIR\prompts" -Force | Out-Null
    robocopy "$BUNDLE\opencode\prompts" "$OPENCODE_DIR\prompts" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
    Ok "OpenCode prompts installed"
  }

  # ---- OpenCode scripts ----
  if (Test-Path "$BUNDLE\opencode\scripts") {
    New-Item -ItemType Directory -Path "$OPENCODE_DIR\scripts" -Force | Out-Null
    robocopy "$BUNDLE\opencode\scripts" "$OPENCODE_DIR\scripts" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
    Ok "OpenCode scripts installed"
  }

  # ---- OpenCode tools ----
  if (Test-Path "$BUNDLE\opencode\tools") {
    New-Item -ItemType Directory -Path "$OPENCODE_DIR\tools" -Force | Out-Null
    robocopy "$BUNDLE\opencode\tools" "$OPENCODE_DIR\tools" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
    Ok "OpenCode tools installed"
  }
} else { Skip "ECC components (skipped by -NoECC)" }

# ---- Agent skills (ui-ux, pdf, pptx, etc.) ----
Step "Setting up agent skills..."
New-Item -ItemType Directory -Path "$AGENTS_DIR\skills" -Force | Out-Null
robocopy "$BUNDLE\agents-skills" "$AGENTS_DIR\skills" /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
Ok "Agent skills installed"

Write-Host ""

# ============================================================
# PHASE 4: Custom MCP Servers (agri-dss, saas-factory, etc.)
# ============================================================
Write-Host "Phase 4: Custom MCP Servers" -ForegroundColor Magenta

$MCP_DIR = "$InstallDir\joo-mcps"
New-Item -ItemType Directory -Path $MCP_DIR -Force | Out-Null

# Copy all custom MCPs from bundle
Step "Copying custom MCP servers..."
robocopy "$BUNDLE\custom-mcps" $MCP_DIR /E /IS /IT /NFL /NDL /NJH /NJS /NS /NC > $null
Ok "Custom MCPs copied to $MCP_DIR"

# Install npm dependencies for each npm-based MCP
Step "Installing npm dependencies for custom MCPs..."
$npmMcps = @("agri-dss-mcp", "saas-factory-mcp", "supreme-factory-mcp", "scroll-3d-sequence-mcp")
foreach ($mcp in $npmMcps) {
  $mcpPath = "$MCP_DIR\$mcp"
  if (Test-Path "$mcpPath\package.json") {
    Write-Host "    → npm install $mcp..." -ForegroundColor Gray
    Push-Location $mcpPath
    try {
      npm install --ignore-scripts 2>&1 | Out-Null
      # saas-factory needs puppeteer - skip chromium download if possible
      if ($mcp -eq "saas-factory-mcp") {
        $env:PUPPETEER_SKIP_DOWNLOAD = "true"
        npm install puppeteer 2>&1 | Out-Null
        Write-Host "      (saas-factory: puppeteer cached, chromium excluded)" -ForegroundColor Yellow
      }
      Write-Host "      ✓ $mcp" -ForegroundColor Green
    } catch {
      Write-Host "      ⚠ $mcp npm install failed: $_" -ForegroundColor Red
    } finally {
      Pop-Location
    }
  }
}

# Install Python dependencies for Python-based MCPs
Step "Installing Python dependencies for custom MCPs..."
$pythonMcps = @(
  @{dir="voice-mcp"; req="requirements.txt"},
  @{dir="vision-mcp"; req="requirements.txt"},
  @{dir="agri-vision-mcp"; req="requirements.txt"}
)
foreach ($mcp in $pythonMcps) {
  $reqPath = "$MCP_DIR\$($mcp.dir)\$($mcp.req)"
  if (Test-Path $reqPath) {
    Write-Host "    → pip install $($mcp.dir)..." -ForegroundColor Gray
    try {
      pip install -r $reqPath --quiet 2>&1 | Out-Null
      Write-Host "      ✓ $($mcp.dir)" -ForegroundColor Green
    } catch {
      Write-Host "      ⚠ $($mcp.dir) pip install failed: $_" -ForegroundColor Red
    }
  }
}

Write-Host ""

# ============================================================
# PHASE 5: Ollama Models
# ============================================================
if ((-not $NoOllama) -and (-not $NoModels)) {
  Write-Host "Phase 5: Ollama Models" -ForegroundColor Magenta
  $ollama = (Get-Command ollama -ErrorAction SilentlyContinue).Source
  if ($ollama) {
    $models = @("qwen2.5-coder:3b-ctx")
    foreach ($m in $models) {
      Step "Pulling $m (this may take a while, ~2 GB)..."
      try {
        & $ollama pull $m 2>&1 | Out-Null
        Ok "$m ready"
      } catch { ErrorMsg "Failed to pull $m: $_" }
    }
    Write-Host ""
  }
} elseif ($NoModels) { Skip "Model pull (skipped by -NoModels)" }
elseif ($NoOllama) { Skip "Model pull (Ollama skipped)" }

# ============================================================
# PHASE 6: Standard MCP Servers (npx-based)
# ============================================================
if (-not $NoMCP) {
  Write-Host "Phase 6: Standard MCP Servers" -ForegroundColor Magenta

  $npxAvailable = (Get-Command npx -ErrorAction SilentlyContinue).Source
  if (-not $npxAvailable) { Skip "npx not available, skipping MCPs" }
  else {
    # These MCPs are auto-installed by npx when first used, nothing to do here
    Ok "MCPs are auto-installed by npx on first use:"
    Ok "  playwright, winapp, chrome-live-view, filesystem"
    Ok "  system-shell, sequential-thinking, fetch, github"
    Ok "OpenRouter Vision needs API key (OPENROUTER_API_KEY)"
    Ok "Vision Analyzer needs API key (GEMINI_API_KEY)"
    Ok "GitHub MCP needs token (GITHUB_PERSONAL_ACCESS_TOKEN)"
    Ok ""

    # Pre-cache some MCPs
    Step "Pre-caching key MCPs..."
    $mcps = @(
      "@playwright/mcp@latest",
      "@modelcontextprotocol/server-filesystem",
      "super-shell-mcp",
      "mcp-fetch-server",
      "@modelcontextprotocol/server-sequential-thinking",
      "winapp-mcp"
    )
    foreach ($mcp in $mcps) {
      try {
        npx -y $mcp --version 2>&1 | Out-Null
        Ok "  $mcp cached"
      } catch {
        # npx caches on first use, this is just pre-warming
      }
    }
  }
} else { Skip "MCP servers (skipped by -NoMCP)" }

# ============================================================
# PHASE 7: Add to PATH
# ============================================================
Write-Host ""
Write-Host "Phase 7: PATH Setup" -ForegroundColor Magenta

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$JOO_HOME*") {
  $newPath = "$JOO_HOME;" + $userPath
  [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
  $env:Path = "$JOO_HOME;$env:Path"
  Ok "Added $JOO_HOME to PATH"
} else { Ok "JOO already in PATH" }

Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          JOO Setup Complete!            ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Quick Start:" -ForegroundColor White
Write-Host "  1. Restart your terminal (or run: `$env:Path = [Environment]::GetEnvironmentVariable('Path','User')" -ForegroundColor Gray
Write-Host "  2. Type: yousef  (or: joo)" -ForegroundColor Cyan
Write-Host "  3. First run auto-downloads the opencode binary"
Write-Host ""
Write-Host "To upgrade the binary later:" -ForegroundColor Yellow
Write-Host "  yousef --update-joo    (or: joo --update-joo)" -ForegroundColor Gray
Write-Host ""
Write-Host "Need API keys? Edit: $JOO_CONFIG\joo.jsonc" -ForegroundColor Yellow
Write-Host "  - OPENROUTER_API_KEY  → OpenRouter Vision" -ForegroundColor Gray
Write-Host "  - GEMINI_API_KEY      → Vision Analyzer" -ForegroundColor Gray
Write-Host "  - GITHUB_TOKEN        → GitHub MCP" -ForegroundColor Gray
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 2>$null
