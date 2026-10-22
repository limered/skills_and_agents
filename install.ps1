# Link skills/agents from this repo into OpenCode or Claude Code discovery paths.
# Usage:
#   .\install.ps1 [-Global] [-Project <path>] [-Tool opencode|claude] [-Lang en|de] [-Skills <name>[,<name>...]] [-Legacy] [-Copy] [-Uninstall]
#   -Tool: opencode (default) or claude. Claude Code gets skills only (agents are OpenCode-format).
#   -Lang: en (default, .opencode/skills) or de (de/skills). Agents exist in English only.
#   -Skills: only these skills plus the skills they require, no agents. With -Uninstall: only the named skills.
#   -Legacy: OpenCode skills into ~/.config/opencode/skills (project: .opencode/skills) instead of .agents/skills.
#   -Copy: copy files instead of symlinking; overwrites existing entries.
# Targets: OpenCode skills ~/.agents/skills, agents ~/.config/opencode/agents; Claude Code skills ~/.claude/skills.
param(
  [switch]$Global,
  [string]$Project = "",
  [ValidateSet("opencode", "claude")][string]$Tool = "opencode",
  [ValidateSet("en", "de")][string]$Lang = "en",
  [string[]]$Skills = @(),
  [switch]$Legacy,
  [switch]$Copy,
  [switch]$Uninstall,
  [switch]$Help
)

if ($Help) { Get-Content $PSCommandPath | Select-Object -First 9; exit 0 }

$RepoRoot = Split-Path -Parent $PSCommandPath
$SrcSkills = if ($Lang -eq "de") { Join-Path $RepoRoot "de\skills" } else { Join-Path $RepoRoot ".opencode\skills" }
$SrcAgents = Join-Path $RepoRoot ".opencode\agents"
$DstAgents = $null

if ($Tool -eq "claude") {
  $claudeDir = if ($Project -ne "") { Join-Path $Project ".claude" } else { Join-Path $HOME ".claude" }
  $DstSkills = Join-Path $claudeDir "skills"
} elseif ($Project -ne "") {
  $DstSkills = if ($Legacy) { Join-Path $Project ".opencode\skills" } else { Join-Path $Project ".agents\skills" }
  $DstAgents = Join-Path $Project ".opencode\agents"
} else {
  $base = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path $HOME ".config" }
  $cfg = Join-Path $base "opencode"
  $DstSkills = if ($Legacy) { Join-Path $cfg "skills" } else { Join-Path $HOME ".agents\skills" }
  # OpenCode reads global agents only from ~/.config/opencode/agents.
  $DstAgents = Join-Path $cfg "agents"
}

function Get-Requires($Name) {
  $text = Get-Content -Raw (Join-Path $SrcSkills "$Name\SKILL.md")
  $frontmatter = [regex]::Match($text, '(?s)^---\r?\n(.*?)\r?\n---').Groups[1].Value
  $list = [regex]::Match($frontmatter, '(?m)^\s+requires:\s*"([^"]*)"').Groups[1].Value
  $list -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ }
}

function Link-Entry($Src, $Dst) {
  if ($Uninstall) {
    if (Test-Path $Dst) {
      if ((Get-Item $Dst).LinkType -eq "SymbolicLink") { Remove-Item $Dst }
      else { Remove-Item -Recurse -Force $Dst }
      Write-Output "removed $Dst"
    }
    return
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Dst) | Out-Null
  if ($Copy) {
    if (Test-Path $Dst) { Remove-Item -Recurse -Force $Dst }
    Copy-Item -Recurse -Force $Src $Dst
    Write-Output "copied $Src -> $Dst"
    return
  }
  if (Test-Path $Dst) {
    $item = Get-Item $Dst -ErrorAction SilentlyContinue
    if ($item.LinkType -eq "SymbolicLink" -and $item.Target -eq $Src) { Write-Output "ok $Dst"; return }
    if ($item.LinkType -eq "SymbolicLink") { Remove-Item $Dst }
    else { Write-Warning "skip $Dst (exists, not a symlink)"; return }
  }
  try {
    New-Item -ItemType SymbolicLink -Path $Dst -Target $Src -ErrorAction Stop | Out-Null
    Write-Output "linked $Dst -> $Src"
  } catch {
    Write-Warning "symlink failed for $Dst ($($_.Exception.Message)); copying instead."
    if (Test-Path $Src -PathType Container) { Copy-Item -Recurse -Force $Src $Dst }
    else { Copy-Item -Force $Src $Dst }
  }
}

$SkillDirs = @(Get-ChildItem -Directory $SrcSkills)
$Requested = @($Skills | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
if ($Requested) {
  $selected = [System.Collections.Generic.SortedSet[string]]::new()
  foreach ($name in $Requested) {
    $dir = $SkillDirs | Where-Object { $_.Name -eq $name }
    if (-not $dir) { Write-Error "unknown skill: $name"; exit 1 }
    [void]$selected.Add($dir.Name)
    if (-not $Uninstall) { Get-Requires $dir.Name | ForEach-Object { [void]$selected.Add($_) } }
  }
  foreach ($name in $selected) {
    if (-not ($SkillDirs.Name -contains $name)) { Write-Warning "required skill $name is not in this repo" }
  }
  $SkillDirs = @($SkillDirs | Where-Object { $selected.Contains($_.Name) })
  Write-Output "skills: $($selected -join ', ')"
}

if ($Uninstall) { Write-Output "uninstalling from $DstSkills $(if ($DstAgents -and -not $Requested) { ", $DstAgents" })" }

$SkillDirs | ForEach-Object { Link-Entry $_.FullName (Join-Path $DstSkills $_.Name) }
if ($Requested) {
  Write-Output "skipping agents: -Skills selects skills only."
} elseif ($DstAgents) {
  Get-ChildItem -File (Join-Path $SrcAgents "*.md") | ForEach-Object { Link-Entry $_.FullName (Join-Path $DstAgents $_.Name) }
} else {
  Write-Output "skipping agents: they are OpenCode-format, Claude Code would not load them."
}

Write-Output "done."
