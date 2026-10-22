#!/usr/bin/env bash
# Link skills/agents from this repo into OpenCode or Claude Code discovery paths.
# Usage:
#   ./install.sh [--global] [--project <path>] [--tool opencode|claude] [--lang en|de] [--legacy] [--uninstall]
#   --tool: opencode (default) or claude. Claude Code gets skills only (agents are OpenCode-format).
#   --lang: en (default, .opencode/skills) or de (de/skills). Agents exist in English only.
#   --legacy: OpenCode skills into ~/.config/opencode/skills (project: .opencode/skills) instead of .agents/skills.
# Targets: OpenCode skills ~/.agents/skills, agents ~/.config/opencode/agents; Claude Code skills ~/.claude/skills.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_AGENTS="$REPO_ROOT/.opencode/agents"

MODE="global"
PROJECT_PATH=""
TOOL="opencode"
SKILL_LANG="en"
LEGACY=0
UNINSTALL=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global) MODE="global"; shift ;;
    --project) PROJECT_PATH="${2:?--project needs a path}"; MODE="project"; shift 2 ;;
    --tool) TOOL="${2:?--tool needs opencode|claude}"; shift 2 ;;
    --lang) SKILL_LANG="${2:?--lang needs en|de}"; shift 2 ;;
    --legacy) LEGACY=1; shift ;;
    --uninstall) UNINSTALL=1; shift ;;
    -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
    *) echo "Unknown arg: $1 (see --help)" >&2; exit 1 ;;
  esac
done

case "$SKILL_LANG" in
  en) SRC_SKILLS="$REPO_ROOT/.opencode/skills" ;;
  de) SRC_SKILLS="$REPO_ROOT/de/skills" ;;
  *) echo "Unknown --lang: $SKILL_LANG (en|de)" >&2; exit 1 ;;
esac

DST_AGENTS=""
case "$TOOL" in
  opencode)
    cfg="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
    if [[ "$MODE" == "global" ]]; then
      if [[ $LEGACY -eq 1 ]]; then DST_SKILLS="$cfg/skills"; else DST_SKILLS="$HOME/.agents/skills"; fi
      DST_AGENTS="$cfg/agents"
    else
      if [[ $LEGACY -eq 1 ]]; then DST_SKILLS="$PROJECT_PATH/.opencode/skills"; else DST_SKILLS="$PROJECT_PATH/.agents/skills"; fi
      DST_AGENTS="$PROJECT_PATH/.opencode/agents"
    fi
    ;;
  claude)
    if [[ "$MODE" == "global" ]]; then DST_SKILLS="$HOME/.claude/skills"
    else DST_SKILLS="$PROJECT_PATH/.claude/skills"; fi
    ;;
  *) echo "Unknown --tool: $TOOL (opencode|claude)" >&2; exit 1 ;;
esac

link_entry() {
  local src="$1" dst="$2"
  if [[ $UNINSTALL -eq 1 ]]; then
    if [[ -L "$dst" ]]; then rm "$dst"; echo "removed $dst"; fi
    return
  fi
  mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" ]]; then
    if [[ "$(readlink "$dst")" == "$src" ]]; then echo "ok $dst"; return; fi
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    echo "skip $dst (exists, not a symlink)" >&2; return
  fi
  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
}

if [[ $UNINSTALL -eq 1 ]]; then echo "uninstalling from $DST_SKILLS${DST_AGENTS:+ , $DST_AGENTS}"; fi

for d in "$SRC_SKILLS"/*/; do
  [[ -d "$d" ]] || continue
  name="$(basename "$d")"
  link_entry "${d%/}" "$DST_SKILLS/$name"
done

if [[ -n "$DST_AGENTS" ]]; then
  for f in "$SRC_AGENTS"/*.md; do
    [[ -f "$f" ]] || continue
    name="$(basename "$f")"
    link_entry "$f" "$DST_AGENTS/$name"
  done
else
  echo "skipping agents: they are OpenCode-format, Claude Code would not load them."
fi

echo "done."
