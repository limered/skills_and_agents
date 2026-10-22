# Link skills/agents from this repo into OpenCode discovery paths.
# Usage:
#   .\install.ps1 [-Global] [-Project <path>] [-Legacy] [-Copy] [-Uninstall]
#   -Legacy: skills into ~/.config/opencode/skills (project: .opencode/skills) instead of .agents/skills.
#   -Copy: copy files instead of symlinking; overwrites existing entries.
# Targets: skills ~/.agents/skills, agents ~/.config/opencode/agents.
param(
  [switch]$Global,
  [string]$Project = "",
  [switch]$Legacy,
  [switch]$Copy,
  [switch]$Uninstall,
  [switch]$Help
)

if ($Help) { Get-Content $PSCommandPath | Select-Object -First 6; exit 0 }

$RepoRoot = Split-Path -Parent $PSCommandPath
$SrcSkills = Join-Path $RepoRoot ".opencode\skills"
$SrcAgents = Join-Path $RepoRoot ".opencode\agents"

if ($Project -ne "") {
  $DstSkills = if ($Legacy) { Join-Path $Project ".opencode\skills" } else { Join-Path $Project ".agents\skills" }
  $DstAgents = Join-Path $Project ".opencode\agents"
} else {
  $base = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path $HOME ".config" }
  $cfg = Join-Path $base "opencode"
  $DstSkills = if ($Legacy) { Join-Path $cfg "skills" } else { Join-Path $HOME ".agents\skills" }
  # OpenCode reads global agents only from ~/.config/opencode/agents.
  $DstAgents = Join-Path $cfg "agents"
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

if ($Uninstall) { Write-Output "uninstalling from $DstSkills , $DstAgents" }

Get-ChildItem -Directory $SrcSkills | ForEach-Object { Link-Entry $_.FullName (Join-Path $DstSkills $_.Name) }
Get-ChildItem -File (Join-Path $SrcAgents "*.md") | ForEach-Object { Link-Entry $_.FullName (Join-Path $DstAgents $_.Name) }

Write-Output "done."
