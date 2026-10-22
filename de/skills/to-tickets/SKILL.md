---
name: to-tickets
description: "Einen Plan, eine Spec oder die aktuelle Unterhaltung in eine Reihe von Tracer-Bullet-Tickets zerlegen, die jeweils ihre blockierenden Abhängigkeiten angeben, und im konfigurierten Tracker veröffentlichen (lokal als Text in einer Datei pro Ticket, in einem echten Tracker als native Blocking-Links)."
disable-model-invocation: true
metadata:
  uses: ""
  requires: ""
---

# In Tickets zerlegen

Zerlege einen Plan, eine Spec oder eine Unterhaltung in eine Reihe von **Tickets**: Tracer-Bullet-Vertikalschnitte, die jeweils angeben, welche Tickets sie **blockieren**.

Der Issue-Tracker ist GitHub Issues (bedient über `gh`). Triage-Labels: `ready-for-agent`, `ready-for-human`, `wontfix` – sonst nichts. Hat das Repo kein GitHub-Remote, weich auf den lokalen Markdown-Tracker aus: eine Datei pro Ticket unter `.scratch/<feature-slug>/issues/`, wobei der Zustand im Feld `**Status:**` steht (`ready-for-agent`, solange offen, `done`, wenn geschlossen).

## Ablauf

### 1. Kontext sammeln

Arbeite mit dem, was bereits im Gesprächskontext steht. Übergibt der User eine Referenz als Argument (einen Spec-Pfad, eine Issue-Nummer oder URL), ruf sie ab und lies den vollständigen Body samt Kommentaren.

### 2. Die Codebasis erkunden (optional)

Hast du die Codebasis noch nicht erkundet, tu es, um den aktuellen Stand des Codes zu verstehen. Ticket-Titel und -Beschreibungen sollen das Vokabular aus dem Domänenglossar des Projekts verwenden und ADRs in dem Bereich respektieren, den du berührst.

Halte Ausschau nach Gelegenheiten, den Code vorab zu refaktorieren (Prefactoring), um die Implementierung zu erleichtern. „Mach die Änderung leicht, dann mach die leichte Änderung.“

### 3. Vertikale Schnitte entwerfen

Zerlege die Arbeit in **Tracer-Bullet**-Tickets.

<vertical-slice-rules>

- Jeder Schnitt zieht einen schmalen, aber VOLLSTÄNDIGEN Pfad durch jede Schicht (Schema, API, UI, Tests): vertikal, KEIN horizontaler Schnitt durch eine einzelne Schicht
- Ein fertiger Schnitt ist für sich allein demonstrierbar oder verifizierbar
- Jeder Schnitt ist so bemessen, dass er in ein einziges frisches Kontextfenster passt
- Prefactoring kommt zuerst

</vertical-slice-rules>

Gib jedem Ticket seine **blockierenden Abhängigkeiten**: die anderen Tickets, die abgeschlossen sein müssen, bevor es starten kann. Ein Ticket ohne Blocker kann sofort starten.

**Breite Refactorings sind die Ausnahme vom vertikalen Schneiden.** Ein **breites Refactoring** ist eine einzige mechanische Änderung (eine Spalte umbenennen, ein gemeinsam genutztes Symbol umtypisieren), deren **Blast-Radius** sich über die gesamte Codebasis erstreckt, sodass ein einziger Edit Tausende von Aufrufstellen auf einmal bricht und kein vertikaler Schnitt grün landen kann. Zwing es nicht in ein Tracer Bullet; ordne es als **Expand–Contract** an. Zuerst Expand: Füg die neue Form neben der alten hinzu, sodass nichts bricht. Dann migriere die Aufrufstellen in Batches, deren Größe sich nach dem Blast-Radius richtet (pro Paket, pro Verzeichnis), jeder Batch ein eigenes Ticket, blockiert durch das Expand – die CI bleibt dabei von Batch zu Batch grün, weil die alte Form noch existiert. Zum Schluss Contract: Lösch die alte Form, sobald kein Aufrufer mehr übrig ist, in einem Ticket, das von jedem Migrations-Batch blockiert wird. Wenn selbst die Batches allein nicht grün bleiben können, behalte die Abfolge bei, lass sie aber einen gemeinsamen Integrationsbranch nutzen und alle ein abschließendes Integrations-und-Verifikations-Ticket blockieren; Grün wird erst dort versprochen.

### 4. Den User abfragen

Präsentiere die vorgeschlagene Aufteilung als nummerierte Liste. Zeig für jedes Ticket:

- **Titel**: kurzer, beschreibender Name
- **Blockiert durch**: welche anderen Tickets (falls vorhanden) zuerst abgeschlossen sein müssen
- **Was es liefert**: das End-to-End-Verhalten, das dieses Ticket zum Laufen bringt

Frag den User:

- Fühlt sich die Granularität richtig an? (zu grob / zu fein)
- Stimmen die blockierenden Abhängigkeiten: Hängt jedes Ticket nur von Tickets ab, die es wirklich aufhalten?
- Sollten Tickets zusammengelegt oder weiter aufgeteilt werden?

Iteriere, bis der User die Aufteilung freigibt.

### 5. Die Tickets im konfigurierten Tracker veröffentlichen

Veröffentliche die freigegebenen Tickets. **Wie**, hängt vom Tracker ab – standardmäßig GitHub Issues, lokale Dateien als Fallback; die Tickets sind in beiden Fällen dieselben, nur die Form der blockierenden Abhängigkeiten ändert sich:

- **Lokale Dateien** → schreib eine Datei pro Ticket unter `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, nummeriert ab `01` in Abhängigkeitsreihenfolge (Blocker zuerst). Das Feld „Blocked by“ jeder Datei listet die Nummern/Titel auf, von denen sie abhängt. Verwende die Vorlage pro Ticket unten: ein Ticket pro Datei, nie eine einzige kombinierte Datei.
- **Ein echter Issue-Tracker (GitHub, Linear, …)** → veröffentliche ein Issue pro Ticket in Abhängigkeitsreihenfolge (Blocker zuerst), damit die blockierenden Abhängigkeiten jedes Tickets echte IDs referenzieren können. Nutze die native Blocking- bzw. Sub-Issue-Beziehung der Plattform, wo es eine gibt; andernfalls setz „Blocked by“ jedes Tickets auf die blockierenden Issues. Vergib das Triage-Label `ready-for-agent`, sofern nicht anders angewiesen; die Tickets sind per Konstruktion von Agents übernehmbar.

Arbeite die **Frontier** ab: jedes Ticket, dessen Blocker alle erledigt sind. Bei einer rein linearen Kette heißt das von oben nach unten.

Schließe oder ändere KEIN Parent-Issue.

Die Feldnamen `Blocked by` und `Status` sowie ihre Werte bleiben in beiden Vorlagen englisch, weil Agents (z. B. `coding-mentor`) sie wörtlich auslesen.

<local-ticket-template>

# <NN>: <Ticket-Titel>

**Was gebaut wird:** das End-to-End-Verhalten, das dieses Ticket zum Laufen bringt, aus Sicht des Users – keine Liste der Implementierung Schicht für Schicht.

**Blocked by:** die Nummern/Titel der Tickets, die dieses aufhalten, oder „None (can start immediately)“.

**Status:** ready-for-agent

- [ ] Akzeptanzkriterium 1
- [ ] Akzeptanzkriterium 2

</local-ticket-template>

<issue-template>

## Parent

Eine Referenz auf das Parent-Issue im Tracker (falls die Quelle ein bestehendes Issue war, sonst diesen Abschnitt weglassen).

## Was gebaut wird

Das End-to-End-Verhalten, das dieses Ticket zum Laufen bringt, aus Sicht des Users, nicht Schicht für Schicht.

## Akzeptanzkriterien

- [ ] Kriterium 1
- [ ] Kriterium 2

## Blocked by

- Eine Referenz auf jedes blockierende Ticket oder „None (can start immediately)“.

</issue-template>

Vermeide in beiden Formen konkrete Dateipfade oder Code-Schnipsel: Sie veralten schnell. Ausnahme: Hat ein Prototyp einen Schnipsel hervorgebracht, der eine Entscheidung präziser festhält, als Prosa es kann (Zustandsmaschine, Reducer, Schema, Typform), füge ihn inline ein und vermerke kurz, dass er aus einem Prototyp stammt. Kürze ihn auf die entscheidungsrelevanten Teile – keine lauffähige Demo, nur das Wesentliche.
