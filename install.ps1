# Link skills/agents from this repo into OpenCode discovery paths.
# Usage:
#   .\install.ps1 [-Global] [-Project <path>] [-Uninstall]
# Defaults to global: $env:APPDATA\opencode\skills|agents, else ~/.config/opencode on PS7.
param(
  [switch]$Global,
  [string]$Project = "",
  [switch]$Uninstall,
  [switch]$Help
)

if ($Help) { Get-Content $PSCommandPath | Select-Object -First 6; exit 0 }

$RepoRoot = Split-Path -Parent $PSCommandPath
$SrcSkills = Join-Path $RepoRoot ".opencode\skills"
$SrcAgents = Join-Path $RepoRoot ".opencode\agents"

if ($Project -ne "") {
  $DstSkills = Join-Path $Project ".opencode\skills"
  $DstAgents = Join-Path $Project ".opencode\agents"
} else {
  $base = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } elseif ($env:APPDATA) { Join-Path $env:APPDATA "opencode" } else { Join-Path $HOME ".config/opencode" }
  if ($base -like "*opencode") { $cfg = $base } else { $cfg = Join-Path $base "opencode" }
  $DstSkills = Join-Path $cfg "skills"
  $DstAgents = Join-Path $cfg "agents"
}

function Link-Entry($Src, $Dst) {
  if ($Uninstall) {
    if ((Test-Path $Dst) -and ((Get-Item $Dst).LinkType -eq "SymbolicLink")) {
      Remove-Item $Dst; Write-Output "removed $Dst"
    }
    return
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Dst) | Out-Null
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
