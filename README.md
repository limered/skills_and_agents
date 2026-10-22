# skills_and_agents

My reusable OpenCode / Claude Code collection. Repo root mirrors a project `.opencode/` exactly — clone and link, no remap logic.

## Layout

- `.opencode/skills/<name>/SKILL.md` — 17 skills, English (autodev versions win on overlap)
- `de/skills/<name>/SKILL.md` — the same 17 skills in German: same names, same files, same metadata
- `.opencode/agents/*.md` — 7 agents (6 autodev generic templates + 1 generic coding-mentor), English only
- `examples/autodev/` — reference copies: `agents.json`, `AGENTS.md.example`, `opencode.json.example`, `static-analysis-policy.md`
- `install.sh` / `install.ps1` — per-entry symlink farm into OpenCode or Claude Code discovery paths

## Skills (17)

From autodev (7): `atomic-commit`, `batch-review-findings`, `code-review`, `codebase-design`, `implement`, `improve-codebase-architecture`, `tdd`

Imported (9): `domain-modeling`, `grill-me`, `grill-with-docs`, `prototype`, `research`, `retro`, `to-spec`, `to-tickets`, `wayfinder`

Built here (1): `setup-agents` — bind agent placeholders per install, prune unused agents

Excluded: `setup-matt-pocock-skills`, symlinked `diagnose-crash`/`omarchy`.

### Skill dependencies

Every `SKILL.md` declares the skills it depends on in its frontmatter `metadata` (an [Agent Skills](https://agentskills.io) field that OpenCode and Claude Code both accept and ignore):

- `uses` — skills the text tells the agent to load or consult (direct).
- `requires` — transitive closure of `uses`: everything to ship with the skill in a package.

Both are comma-separated strings (the spec allows only string values), empty when there are none. `de/` carries identical metadata. When a skill starts or stops referencing another skill, update its `uses` and recompute `requires` for it and for every skill that requires it.

| Skill | `requires` (transitive) |
|---|---|
| `batch-review-findings` | `codebase-design`, `grill-me` |
| `grill-with-docs` | `domain-modeling`, `grill-me` |
| `implement` | `code-review`, `codebase-design`, `tdd` (direct: `code-review`, `tdd`) |
| `improve-codebase-architecture` | `codebase-design` |
| `tdd` | `code-review`, `codebase-design` |
| `wayfinder` | `domain-modeling`, `grill-me`, `prototype`, `research`, `to-spec` |
| all others | none |

## Agents (7)

`feature-builder`, `code-review`, `static-analysis`, `test-runner`, `pr-author`, `agentic-review` — genericized with `{{PROJECT}}` / `{{PAT_PATH}}` (default `~/.github-pat.txt`) / `{{STATE_DIR}}` (default `.factory`) placeholders, models kept as working defaults. See header in each file + `examples/autodev/`.

`coding-mentor` — language-agnostic mentor template from groves-mentor (`{{LEARNER}}`, `{{PROJECT}}`, `{{TEST_CMD}}`, `{{LINT_CMD}}`, `{{TICKET_DIR}}`, `{{SPEC_PATH}}`).

Skills each agent uses directly (also listed in the header of each agent file). Every agent additionally needs `setup-agents` to bind its placeholders.

| Agent | Skills used |
|---|---|
| `agentic-review` | `improve-codebase-architecture` |
| `code-review` | `code-review` |
| `feature-builder` | `atomic-commit`, `tdd` |
| `coding-mentor`, `pr-author`, `static-analysis`, `test-runner` | none |

Agents carry no `metadata` field: OpenCode reads agent frontmatter as agent config, so the list lives in the header blockquote instead.

## Use

| Option | `install.sh` | `install.ps1` | Default |
|---|---|---|---|
| Target tool | `--tool opencode\|claude` | `-Tool opencode\|claude` | `opencode` |
| Skill language | `--lang en\|de` | `-Lang en\|de` | `en` |
| Skill package | `--skills a,b` | `-Skills a,b` | all skills + agents |
| Old OpenCode skill folder | `--legacy` | `-Legacy` | `.agents/skills` |
| Project install | `--project <path>` | `-Project <path>` | global |
| Remove | `--uninstall` | `-Uninstall` | |
| Copy instead of symlink | — | `-Copy` | |

| Tool | Global | Project |
|---|---|---|
| OpenCode | skills `~/.agents/skills` (`--legacy`: `~/.config/opencode/skills`), agents `~/.config/opencode/agents` | skills `<project>/.agents/skills` (`--legacy`: `<project>/.opencode/skills`), agents `<project>/.opencode/agents` |
| Claude Code | skills `~/.claude/skills` | `<project>/.claude/skills` |

Linux:

```bash
./install.sh                              # OpenCode, global, English
./install.sh --lang de                    # OpenCode, global, German skills
./install.sh --tool claude --lang de      # Claude Code, global, German skills
./install.sh --skills implement,grill-me  # only these + required skills
./install.sh --project /path/to/project
./install.sh --uninstall
```

Windows:

```powershell
.\install.ps1
.\install.ps1 -Lang de
.\install.ps1 -Tool claude -Lang de
.\install.ps1 -Skills implement,grill-me
.\install.ps1 -Project C:\path\to\project
.\install.ps1 -Uninstall
```

Symlinks per entry, so `git pull` + re-run picks up new skills. Re-running with the other language relinks in place (skill names are identical). Windows falls back to copy when symlinks lack privilege.

Skill packages (`--skills` / `-Skills`):

- Installs the named skills plus everything in their `requires` (e.g. `implement` → `implement`, `tdd`, `code-review`, `codebase-design`). No agents.
- With `--uninstall`, removes only the named skills; their dependencies may still be needed by other skills.

Skill folder: OpenCode reads skills from `.agents/skills` and from its own `.opencode/skills` / `~/.config/opencode/skills`. The default is `.agents/skills`, the cross-tool location; `--legacy` installs to the OpenCode folder instead. When one ID exists in both, OpenCode loads the OpenCode folder, so remove a legacy install (`--legacy --uninstall`) before switching.

Claude Code:

- Skills only. The agents use OpenCode frontmatter (no `name`, `opencode-go/…` models, `mode`, `permission`), and Claude Code silently skips agent files without `name`.
- The `code-review` skill replaces Claude Code's bundled `/code-review` command; the bundled `/review` alias still runs the built-in one.
- OpenCode also reads `~/.claude/skills`. Installed globally for both tools, OpenCode sees every ID twice and loads the copy from its own install.

German skills (`de/`):

- Prose, templates and descriptions are translated. Skill names, file names and metadata stay the same.
- Kept in English because other agents or tools match them literally: tracker labels and status values, the `Blocked by` / `Status` ticket fields, `Strong` / `Worth exploring` / `Speculative`, the `## Standards` / `## Spec` headings, commands, JSON.
- `atomic-commit` still produces English commit messages; its format rules are English grammar.
- `codebase-design` vocabulary in German: Modul, Schnittstelle, Tiefe, Seam, Adapter, Hebelwirkung, Lokalität. Keep these exact terms when editing any German skill.
- A change to an English skill needs the same change in `de/`.

After installing, bind the generic agent templates with `/setup-agents`: pick agents, fill placeholders, drop the rest. Answers persist in `<target>/agents.setup.json`.

Autodev wiring is deferred (autodev has open issues); intended path is submodule or provision-time clone+copy of `.opencode/skills|agents`.
