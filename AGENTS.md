# 🚀 JOO - Ultimate AI Coding Agent

## What is JOO?

JOO is a **standalone fork** of [opencode](https://github.com/anomalyco/opencode) (MIT licensed), customized with:
- Arabic-first intelligence & configuration
- Completely **independent** from opencode (runs without it)
- Custom JOO config paths (`~/.config/joo/`, `~/.joo/`)
- Pre-configured JOO skills, agents, MCPs, and providers

## How JOO Works

JOO wraps the opencode binary with custom environment variables:

```
joo → joo.ps1 → sets env vars → runs opencode binary with JOO config
```

## Paths

| Purpose | Path |
|---------|------|
| Config | `~/.config/joo/joo.jsonc` |
| Config Dir | `~/.config/joo/` |
| Binary | `~/.joo/bin/joo.exe` |
| Data | `~/.joo/` |
| Skills | `~/.config/joo/skills/` |
| Agents | `~/.config/joo/agents/` |
| TUI Config | `~/.config/joo/tui.json` |

## Installation

```bash
# Quick install (requires opencode-ai installed):
joo --version

# Or download and run:
curl -fsSL https://opencode.ai/install | bash
# Then:
joo --version  # auto-caches the binary
```

## Building from Source

```bash
git clone https://github.com/anomalyco/joo.git
cd joo
bun install
cd packages/opencode
bun run build --single
```

## Key Environment Variables

- `OPENCODE_CONFIG` = `~/.config/joo/joo.jsonc`
- `OPENCODE_CONFIG_DIR` = `~/.config/joo`
- `OPENCODE_TUI_CONFIG` = `~/.config/joo/tui.json`

## Fork Details

- Base: opencode v1.17.9
- Changes: `global.ts` app name → `joo`, build output → `joo`
- License: MIT (same as opencode)
