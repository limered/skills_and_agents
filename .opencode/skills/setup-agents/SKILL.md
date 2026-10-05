---
name: setup-agents
description: Configure installed agents from this collection for a project or globally: pick which agents to keep, fill in their placeholders, prune the rest. Use after install.sh/install.ps1 when agents still carry {{PLACEHOLDERS}}.
---

# Setup agents

The agent templates ship generic. This skill binds them to one install: it asks which agents to keep, asks each placeholder value once, substitutes them into real copies, and removes the links of unused agents.

Never edit the collection repo templates — only the installed copies. If the target directory resolves inside the collection repo itself, stop and tell the user to run this in the project (or global config) instead.

## 1. Locate the install

- If `./.opencode/agents/` exists in the working directory, that is the target (project install).
- Else the target is the global install (`~/.config/opencode/agents/`, or `%APPDATA%\opencode\agents` on Windows).
- If both exist or neither does, ask the user which target to set up.

Read `<target>/agents.setup.json` if present: saved answers from a previous run. Only ask about what is new or changed; reuse the rest silently.

## 2. Ask which agents to keep

List every `*.md` in the target with its one-line `description:` from the frontmatter. Ask which to set up (multi-select, default: all). Note which entries are symlinks (fresh from the installer) and which are real files (already configured or hand-edited).

## 3. Ask placeholder values

Collect each distinct placeholder across the kept agents and ask its value once — shared answers apply to every kept agent. Show the default; empty answer keeps it.

| Placeholder | Default | Used by |
|---|---|---|
| `{{PROJECT}}` | _(none — must ask)_ | all agents |
| `{{PAT_PATH}}` | `~/.github-pat.txt` | pipeline agents |
| `{{STATE_DIR}}` | `.factory` | pipeline agents |
| `{{LEARNER}}` | _(none — must ask)_ | coding-mentor |
| `{{TEST_CMD}}` | `cargo test` | coding-mentor |
| `{{LINT_CMD}}` | `cargo clippy --all-targets && cargo fmt --check` | coding-mentor |
| `{{TICKET_DIR}}` | `.scratch/{{PROJECT}}/issues` | coding-mentor |
| `{{SPEC_PATH}}` | _(none — must ask)_ | coding-mentor |
| `{{GLOSSARY_PATH}}` | `CONTEXT.md` | coding-mentor |

`{{TICKET_DIR}}`'s default composes with `{{PROJECT}}`: substitute `{{PROJECT}}` first, then re-scan until no placeholders remain.

## 4. Materialize and substitute

For each kept agent:

1. If the entry is a symlink, replace it with a real copy of its target first — substituting through the link would rewrite the shared collection template.
2. Substitute every placeholder with the answered value, repeating to a fixpoint (composed defaults like `{{TICKET_DIR}}`).
3. Verify with grep: no `{{[A-Z_]+}}` may remain. Report any leftover and ask how to fill it.

## 5. Prune unused agents

For each agent not kept: if it is a symlink, remove the link. If it is a real file, ask before deleting (it may hold hand-written config).

## 6. Save and report

Write all answers to `<target>/agents.setup.json` (placeholder values keyed by name) so the next run or new agent only asks deltas. Print a summary: kept agents with their bound values, removed agents, and the setup file location.
