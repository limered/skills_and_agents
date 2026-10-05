# skills_and_agents

My reusable OpenCode collection. Repo root mirrors a project `.opencode/` exactly — clone and link, no remap logic.

## Layout

- `.opencode/skills/<name>/SKILL.md` — 16 skills (autodev versions win on overlap)
- `.opencode/agents/*.md` — 7 agents (6 autodev generic templates + 1 generic coding-mentor)
- `examples/autodev/` — reference copies: `agents.json`, `AGENTS.md.example`, `opencode.json.example`, `static-analysis-policy.md`
- `install.sh` / `install.ps1` — per-entry symlink farm into OpenCode discovery paths

## Skills (16)

From autodev (7): `atomic-commit`, `batch-review-findings`, `code-review`, `codebase-design`, `implement`, `improve-codebase-architecture`, `tdd`

Imported (9): `domain-modeling`, `grill-me`, `grill-with-docs`, `prototype`, `research`, `retro`, `to-spec`, `to-tickets`, `wayfinder`

Excluded: `setup-matt-pocock-skills`, symlinked `diagnose-crash`/`omarchy`.

## Agents (7)

`feature-builder`, `code-review`, `static-analysis`, `test-runner`, `pr-author`, `agentic-review` — genericized with `{{PROJECT}}` / `{{PAT_PATH}}` (default `~/.github-pat.txt`) / `{{STATE_DIR}}` (default `.factory`) placeholders, models kept as working defaults. See header in each file + `examples/autodev/`.

`coding-mentor` — language-agnostic mentor template from groves-mentor (`{{LEARNER}}`, `{{PROJECT}}`, `{{TEST_CMD}}`, `{{LINT_CMD}}`, `{{TICKET_DIR}}`, `{{SPEC_PATH}}`).

## Use

Linux:

```bash
./install.sh            # global: ~/.config/opencode/skills|agents
./install.sh --project /path/to/project
./install.sh --uninstall
```

Windows:

```powershell
.\install.ps1
.\install.ps1 -Project C:\path\to\project
.\install.ps1 -Uninstall
```

Symlinks per entry, so `git pull` + re-run picks up new skills. Windows falls back to copy when symlinks lack privilege.

Autodev wiring is deferred (autodev has open issues); intended path is submodule or provision-time clone+copy of `.opencode/skills|agents`.
