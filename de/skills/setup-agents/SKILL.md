---
name: setup-agents
description: "Installierte Agents aus dieser Sammlung für ein Projekt oder global konfigurieren: auswählen, welche Agents bleiben, ihre Platzhalter ausfüllen, den Rest entfernen. Verwenden nach install.sh/install.ps1, wenn Agents noch {{PLACEHOLDERS}} enthalten."
metadata:
  uses: ""
  requires: ""
---

# Agents einrichten

Die Agent-Vorlagen werden generisch ausgeliefert. Dieser Skill bindet sie an eine Installation: Er fragt, welche Agents bleiben sollen, fragt jeden Platzhalterwert einmal ab, setzt die Werte in echte Kopien ein und entfernt die Links nicht verwendeter Agents.

Bearbeite nie die Vorlagen im Sammlungs-Repo – nur die installierten Kopien. Liegt das Zielverzeichnis im Sammlungs-Repo selbst, brich ab und sag dem User, er soll das im Projekt (oder in der globalen Konfiguration) ausführen.

## 1. Die Installation finden

- Existiert `./.opencode/agents/` im Arbeitsverzeichnis, ist das das Ziel (Projektinstallation).
- Sonst ist das Ziel die globale Installation (`~/.config/opencode/agents/` auf jedem Betriebssystem bzw. `$XDG_CONFIG_HOME/opencode/agents/`, wenn das gesetzt ist).
- Existieren beide oder keines davon, frag den User, welches Ziel eingerichtet werden soll.

Lies `<target>/agents.setup.json`, falls vorhanden: gespeicherte Antworten aus einem früheren Lauf. Frag nur nach Neuem oder Geändertem; verwende den Rest stillschweigend wieder.

## 2. Fragen, welche Agents bleiben

Liste jede `*.md` im Ziel mit ihrer einzeiligen `description:` aus dem Frontmatter auf. Frag, welche eingerichtet werden sollen (Mehrfachauswahl, Standard: alle). Vermerke, welche Einträge Symlinks sind (frisch vom Installer) und welche echte Dateien (bereits konfiguriert oder von Hand bearbeitet).

## 3. Platzhalterwerte abfragen

Sammle jeden unterschiedlichen Platzhalter über alle behaltenen Agents und frag seinen Wert einmal ab – gemeinsame Antworten gelten für jeden behaltenen Agent. Zeig den Standardwert; eine leere Antwort behält ihn.

| Platzhalter | Standard | Verwendet von |
|---|---|---|
| `{{PROJECT}}` | _(keiner – muss erfragt werden)_ | alle Agents |
| `{{PAT_PATH}}` | `~/.github-pat.txt` | Pipeline-Agents |
| `{{STATE_DIR}}` | `.factory` | Pipeline-Agents |
| `{{LEARNER}}` | _(keiner – muss erfragt werden)_ | coding-mentor |
| `{{TEST_CMD}}` | `cargo test` | coding-mentor |
| `{{LINT_CMD}}` | `cargo clippy --all-targets && cargo fmt --check` | coding-mentor |
| `{{TICKET_DIR}}` | `.scratch/{{PROJECT}}/issues` | coding-mentor |
| `{{SPEC_PATH}}` | _(keiner – muss erfragt werden)_ | coding-mentor |
| `{{GLOSSARY_PATH}}` | `CONTEXT.md` | coding-mentor |

Der Standardwert von `{{TICKET_DIR}}` setzt sich mit `{{PROJECT}}` zusammen: Ersetze zuerst `{{PROJECT}}` und scanne dann erneut, bis keine Platzhalter mehr übrig sind.

## 4. Materialisieren und ersetzen

Für jeden behaltenen Agent:

1. Ist der Eintrag ein Symlink, ersetze ihn zuerst durch eine echte Kopie seines Ziels – ein Ersetzen durch den Link hindurch würde die gemeinsame Vorlage in der Sammlung umschreiben.
2. Ersetze jeden Platzhalter durch den erfragten Wert und wiederhole das, bis sich nichts mehr ändert (zusammengesetzte Standardwerte wie `{{TICKET_DIR}}`).
3. Prüfe per grep: Es darf kein `{{[A-Z_]+}}` übrig bleiben. Melde jeden Rest und frag, wie er zu füllen ist.

## 5. Nicht verwendete Agents entfernen

Für jeden nicht behaltenen Agent: Ist er ein Symlink, entferne den Link. Ist er eine echte Datei, frag vor dem Löschen nach (sie könnte von Hand geschriebene Konfiguration enthalten).

## 6. Speichern und berichten

Schreib alle Antworten nach `<target>/agents.setup.json` (Platzhalterwerte nach Name geschlüsselt), damit der nächste Lauf oder ein neuer Agent nur nach Änderungen fragt. Gib eine Zusammenfassung aus: behaltene Agents mit ihren gebundenen Werten, entfernte Agents und den Ort der Setup-Datei.
