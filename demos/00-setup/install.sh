#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# BDR AI Agent Workshop — Setup Script
# Installs Claude Code CLI, verifies dependencies, and configures the workspace.
# =============================================================================

BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

info()  { echo -e "${GREEN}[INFO]${RESET}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error() { echo -e "${RED}[ERROR]${RESET} $*"; exit 1; }

# ---------------------------------------------------------------------------
# 1. Pre-flight checks
# ---------------------------------------------------------------------------
info "Checking prerequisites..."

command -v node  >/dev/null 2>&1 || error "Node.js is required (v18+). Install from https://nodejs.org"
command -v npm   >/dev/null 2>&1 || error "npm is required. It ships with Node.js."
command -v git   >/dev/null 2>&1 || error "git is required. Install from https://git-scm.com"

NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 18 ]; then
  error "Node.js v18+ is required. You have $(node -v)."
fi
info "Node $(node -v) — OK"

# ---------------------------------------------------------------------------
# 2. Install Claude Code CLI
# ---------------------------------------------------------------------------
if command -v claude >/dev/null 2>&1; then
  info "Claude Code CLI already installed: $(claude --version 2>/dev/null || echo 'installed')"
  info "Updating to latest..."
  npm update -g @anthropic-ai/claude-code || warn "Update failed — continuing with current version."
else
  info "Installing Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code
fi

claude --version >/dev/null 2>&1 || error "Claude Code CLI installation failed."
info "Claude Code CLI ready."

# ---------------------------------------------------------------------------
# 3. Verify API key
# ---------------------------------------------------------------------------
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  warn "ANTHROPIC_API_KEY is not set."
  echo ""
  echo -e "${BOLD}To set your API key, run:${RESET}"
  echo ""
  echo "  export ANTHROPIC_API_KEY=\"sk-ant-...\""
  echo ""
  echo "Add it to your shell profile (~/.zshrc or ~/.bashrc) to persist across sessions."
  echo ""
else
  info "ANTHROPIC_API_KEY is set (${ANTHROPIC_API_KEY:0:12}...)"
fi

# ---------------------------------------------------------------------------
# 4. Install optional tools (if available)
# ---------------------------------------------------------------------------
info "Checking optional tools..."

if command -v jq >/dev/null 2>&1; then
  info "jq $(jq --version) — OK"
else
  warn "jq not found. Recommended for JSON processing. Install: brew install jq"
fi

if command -v python3 >/dev/null 2>&1; then
  info "python3 $(python3 --version 2>&1 | awk '{print $2}') — OK"
else
  warn "python3 not found. Some enrichment scripts may need it."
fi

if command -v gh >/dev/null 2>&1; then
  info "GitHub CLI $(gh --version | head -1 | awk '{print $3}') — OK"
else
  warn "GitHub CLI (gh) not found. Optional but useful. Install: brew install gh"
fi

# ---------------------------------------------------------------------------
# 5. Create workspace directory structure
# ---------------------------------------------------------------------------
WORKSHOP_DIR="$(cd "$(dirname "$0")/.." && pwd)"

info "Setting up workspace at ${WORKSHOP_DIR}..."

mkdir -p "${WORKSHOP_DIR}/01-bdr/output"
mkdir -p "${WORKSHOP_DIR}/01-bdr/replies"
mkdir -p "${WORKSHOP_DIR}/01-bdr/logs"

# ---------------------------------------------------------------------------
# 6. Create .claude directory with project config if it doesn't exist
# ---------------------------------------------------------------------------
CLAUDE_DIR="${WORKSHOP_DIR}/.claude"
mkdir -p "${CLAUDE_DIR}"

if [ ! -f "${CLAUDE_DIR}/settings.json" ]; then
  cat > "${CLAUDE_DIR}/settings.json" <<'SETTINGS'
{
  "model": "claude-sonnet-4-20250514",
  "permissions": {
    "allow": [
      "Read",
      "Write",
      "Edit",
      "Bash(jq *)",
      "Bash(python3 *)",
      "Bash(cat *)",
      "Bash(head *)",
      "Bash(wc *)",
      "Bash(curl *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)"
    ]
  }
}
SETTINGS
  info "Created Claude Code project settings."
fi

# ---------------------------------------------------------------------------
# 7. Write a CLAUDE.md project context file
# ---------------------------------------------------------------------------
if [ ! -f "${WORKSHOP_DIR}/CLAUDE.md" ]; then
  cat > "${WORKSHOP_DIR}/CLAUDE.md" <<'CLAUDEMD'
# BDR AI Agent Workshop

## Project Context
This is a workshop project for building an AI-powered BDR (Business Development Representative) agent using Claude Code and MCP tools.

## Directory Layout
- `00-setup/`        — Installation and configuration scripts
- `01-bdr/`          — BDR agent demos, prompts, and configs
- `01-bdr/output/`   — Generated emails and sequences (gitignored)
- `01-bdr/replies/`  — Sample reply emails for intent detection
- `01-bdr/logs/`     — Agent run logs

## Key Files
- `01-bdr/bdr-aop.md`         — Agentic Operating Procedure (the agent's playbook)
- `01-bdr/mcp-tools.json`     — MCP tool definitions for all BDR actions
- `01-bdr/sample-leads.csv`   — Demo lead data
- `01-bdr/sequence-config.json` — Omnichannel sequence configuration

## Conventions
- All CSV files use UTF-8 encoding with headers in the first row.
- Email output format: one markdown file per lead in `output/`.
- Scores are 0-100 integers.
- Dates use ISO 8601 format.
CLAUDEMD
  info "Created CLAUDE.md project context."
fi

# ---------------------------------------------------------------------------
# 8. Summary
# ---------------------------------------------------------------------------
echo ""
echo -e "${BOLD}========================================${RESET}"
echo -e "${BOLD}  Setup Complete${RESET}"
echo -e "${BOLD}========================================${RESET}"
echo ""
echo -e "  Claude Code CLI:   $(claude --version 2>/dev/null || echo 'installed')"
echo -e "  Workspace:         ${WORKSHOP_DIR}"
echo -e "  API Key:           ${ANTHROPIC_API_KEY:+set}${ANTHROPIC_API_KEY:-NOT SET}"
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
echo -e "  1. cd ${WORKSHOP_DIR}"
echo -e "  2. claude          # Launch Claude Code"
echo -e "  3. Try: \"Read bdr-aop.md and list the daily routine steps\""
echo ""
