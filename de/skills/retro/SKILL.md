---
name: retro
description: "Eine Retrospektive zu einer Coding-Sitzung durchführen."
disable-model-invocation: true
metadata:
  uses: ""
  requires: ""
---

Der User hat um eine **Retrospektive** gebeten. Du schlägst Verbesserungen an der **Umgebung** des Coding-Agents vor, damit künftige Läufe besser werden.

## Schritte

1. Lies die Primärquellen der Sitzung, die der User nennt. Das kann bedeuten, Sitzungsprotokolle auf diesem Rechner zu durchsuchen. Nennt der User keine Sitzung, nimm standardmäßig die aktuelle.

2. Such in diesen Kategorien nach Verbesserungskandidaten.

- **Navigation**: Wie leicht hat der Agent die richtigen Dateien gefunden? Gibt es versteckte Abhängigkeiten zwischen Dateien? Würde ein **Navigationsverweis** es leichter machen? _Verwenden, wenn_ die Sitzung lange gebraucht hat, um eine Information zu finden.
- **Automatisierte Checks**: Gibt es automatisierte Checks, die Fehler des Agents hätten abfangen können? Linting, Typprüfung, Tests, Dateisystem-Linter? Lies zuerst den eigenen Check-Befehl des Repos (die `lint`-/`check`-Skripte in `package.json` bzw. im Build-Tool, den CI-Workflow), damit ein Check, der zwar existiert, aber nicht eingebunden oder stillschweigend kaputt ist, das Finding ist – keine Neuerfindung. Ein Repo ohne **Leitplanke** (Guardrail: kein Pre-Commit-Hook und kein CI-Job, der Lint/Typecheck/Tests ausführt) ist selbst ein Finding: Ein ungelintetes Repo ist eine dauerhaft verpasste Gelegenheit, kein neutraler Normalzustand. _Verwenden, wenn_ der Agent einen Fehler gemacht hat, den ein automatisierter Check hätte abfangen können, oder das Repo überhaupt keine Leitplanke hat.
- **Coding-Standards**: Sollte der **Review-Agent** eine neue Regel durchsetzen? Sollte eine bestehende Regel entfernt oder präzisiert werden? Klassifiziere den Verstoß zuerst: Ein **mechanischer** Verstoß (ein festes syntaktisches Muster, eine verbotene API, eine Import-Form, eine Regel zum Dateiort) bekommt einen deterministischen Check, Punkt: eine eigene Regel im Linter des Repos, einen neuen Pre-Commit-Hook oder einen neuen CI-Job – je nachdem, was Sprache und bestehende Leitplanke des Repos am günstigsten machen. Bau standardmäßig lieber den Check, als die Regel aufzuschreiben. Reserviere `CODING_STANDARDS.md` für echte **Ermessensfragen** (dateiübergreifende Konsistenz, „passt zum umgebenden Stil“, alles, wofür keine Leitplanke je einspringen könnte). _Verwenden, wenn_ der Review-Agent einen Fehler nicht erkannt hat.
- **Globale AGENTS.md**: Gibt es Steuerungsanweisungen, die stattdessen in die Coding-Standards (oder automatisierte Checks) gehören? _Verwenden, wenn_ die AGENTS.md besonders groß ist – im Repo ODER im globalen Bereich des Users.
- **Tool-Ökonomie**: Hat der Agent teure Tool-Aufrufe gemacht, die sich verschlanken ließen? Gibt es eigenes Tooling (CLIs, MCPs), das besonders token-ineffizient ist? _Verwenden, wenn_ der Agent einen teuren Tool-Aufruf gemacht hat.
- **No-ops**: Such nach Anweisungen in Steuerungsdateien, die das Verhalten des Agents nicht verändern. _Verwenden, wenn_ die Steuerungsdateien groß und unhandlich sind.
- **Informationszugang**: Such nach Möglichkeiten, den Zugang des Agents zu Informationen zu verbessern. Dev-Server-Logs mitschneiden, Lesezugriff auf Drittanbieterdienste. _Verwenden, wenn_ dem Agent eine entscheidende Information nicht zur Verfügung stand.

3. Präsentiere diese Kandidaten dem User, nach Schweregrad geordnet.

## Referenz

### Implementierung vs. Review

Denk daran, dass jede Arbeit zwei Phasen durchläuft: Implementierung und Review. Der Implementierungs-Agent hat den größten **Kontextdruck**. Er ist für Erkundung, Code-Schreiben und das Debuggen von Fehlschlägen zuständig.

Der Review-Agent hat den geringsten Kontextdruck – er bekommt einen Diff, muss also nichts erkunden. Oft muss er weder Code schreiben noch debuggen.

Daraus folgt: Der Review-Agent sollte für das Durchsetzen von Coding-Standards verantwortlich sein, nicht der Implementierungs-Agent.

### Dateien

Du hast Zugriff auf mehrere Dateien im Repo:

- `CLAUDE.md`/`AGENTS.md`: Diese Dateien landen im Kontextfenster jedes Agents, der in diesem Repo arbeitet. Sie sollten äußerst sparsam eingesetzt werden, meist nur für **Navigationsverweise** auf andere Dateien.
- `CODING_STANDARDS.md`: Diese Datei wird beim Review gelesen, nicht bei der Implementierung. Füg **Navigationsverweise** auf Doku-Ordner hinzu, wenn die Standards-Datei länger als 1.000 Zeilen wird.
- Doku: Verwende Doku als Referenzdateien, auf die andere Dateien verweisen. Such nach bestehender Doku, bevor du neue schreibst.
- Skills: Verwende Skills für Doku (weil ihre Beschreibung ins Kontextfenster des Agents gelangt) oder für Befehle, die der User aufruft.
