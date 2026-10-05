#!/usr/bin/env bash
# Link skills/agents from this repo into OpenCode discovery paths.
# Usage:
#   ./install.sh [--global] [--project <path>] [--uninstall]
# Defaults to --global: ~/.config/opencode/skills|agents
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_SKILLS="$REPO_ROOT/.opencode/skills"
SRC_AGENTS="$REPO_ROOT/.opencode/agents"

MODE="global"
PROJECT_PATH=""
UNINSTALL=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global) MODE="global"; shift ;;
    --project) PROJECT_PATH="${2:?--project needs a path}"; MODE="project"; shift 2 ;;
    --uninstall) UNINSTALL=1; shift ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) echo "Unknown arg: $1 (see --help)" >&2; exit 1 ;;
  esac
done

if [[ "$MODE" == "global" ]]; then
  DST_SKILLS="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills"
  DST_AGENTS="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents"
else
  DST_SKILLS="$PROJECT_PATH/.opencode/skills"
  DST_AGENTS="$PROJECT_PATH/.opencode/agents"
fi

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

if [[ $UNINSTALL -eq 1 ]]; then echo "uninstalling from $DST_SKILLS , $DST_AGENTS"; fi

for d in "$SRC_SKILLS"/*/; do
  [[ -d "$d" ]] || continue
  name="$(basename "$d")"
  link_entry "$d" "$DST_SKILLS/$name"
done

for f in "$SRC_AGENTS"/*.md; do
  [[ -f "$f" ]] || continue
  name="$(basename "$f")"
  link_entry "$f" "$DST_AGENTS/$name"
done

echo "done."
