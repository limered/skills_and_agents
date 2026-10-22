---
name: batch-review-findings
description: "Offene agentic-review-Issues aus GitHub einsammeln, ihre Finding-Karten deduplizieren und zu Arbeitspaketen gruppieren, die sich zu agententauglichen Issues grillen lassen. Verwenden, wenn der User agentic-review-Findings konsolidieren, Review-Issues deduplizieren oder Review-Rauschen in Arbeitsblöcke verwandeln will."
disable-model-invocation: true
metadata:
  uses: "codebase-design, grill-me"
  requires: "codebase-design, grill-me"
---

# Review-Findings bündeln

Verwandle den Stapel offener `agentic-review`-Issues in eine kleine Menge **Arbeitspakete**. Jedes Paket ist ein Cluster deduplizierter Findings, den der User anschließend (per `/grill-me`) zu echten `ready-for-agent`-Issues grillen kann.

Agentic-review-Issues sind beratende Sammelstellen: ein Issue pro Factory-Job, jedes mit mehreren **Finding-Karten** (`Candidate N —` aus `improve-codebase-architecture`). (Standards- und Spec-Findings aus dem Code-Review landen nicht mehr hier – sie laufen innerhalb des Runs durch die Fix-Durchläufe des `code-review`-Agents, und nur ihr HITL-Rest wird als `code-review roll-up`-Issue abgelegt.) Dasselbe Problem taucht über Jobs hinweg wieder auf, und verwandte Probleme verteilen sich über mehrere Issues. Dieser Skill fasst dieses Rauschen zusammen.

## Ablauf

### 1. Findings abrufen

```
gh issue list --repo limered/autodev --label agentic-review --state open --limit 200 --json number,title,body,url
```

Jede Karte ist eine Einheit. Zerlege jeden Issue-Body in seine Finding-Karten (Karten sind durch `---` getrennt und beginnen mit `**Candidate N —`, in deutschsprachigen Läufen ggf. mit `**Kandidat N —`). Halte pro Karte fest: Quell-Issue-Nummer, Titel, betroffene Dateien, Problem, vorgeschlagene Lösung, Empfehlungsstärke.

### 2. Deduplizieren

Zwei Karten sind **Duplikate**, wenn sie dasselbe Problem am selben Modul bzw. derselben Seam benennen – urteile nach dem Domänenkonzept und den aufgeführten Dateien, nicht nach dem Wortlaut. Wiederkehrende Findings über Jobs hinweg sind der Normalfall.

Führe Duplikate zu einer Karte zusammen. Behalte die klarste Formulierung von Problem und Lösung, vereinige die Dateilisten, behalte die stärkste Empfehlungsstärke und notiere jede Quell-Issue-Nummer, damit nichts verloren geht.

### 3. Zu Paketen gruppieren

Bündle die deduplizierten Karten nach Lokalität zu **Arbeitspaketen** – Karten, die dasselbe Modul, denselben Themenordner (`DispatchView/`, `RunView/`, `_shared/`) oder dieselbe Seam betreffen, gehören zusammen. Ein Paket sollte sich in einer Sitzung grillen lassen und als ein oder wenige zusammenhängende Issues landen.

Beachte beim Benennen der Pakete die Frontend-Strukturregeln in `AGENTS.md` (semantisch nach Thema) und das Vokabular aus `codebase-design`.

### 4. Präsentieren

Zeig die Pakete als nummerierte Liste. Pro Paket:

- **Pakettitel** – das Modul/Thema und das gemeinsame Anliegen
- **Findings** – die deduplizierten Karten darin, jeweils mit ihren Quell-Issue-Nummern (z. B. `#109, #106`)
- **Dateien** – die Vereinigung aller betroffenen Dateien
- **Vorgeschlagener Umfang** – ein Satz dazu, was eine Grill-Sitzung daraus machen würde

Erstelle, schließe oder ändere **keine** Issues. Dieser Skill liest und ordnet nur – sein Ergebnis ist die Paketliste, die der User als Nächstes grillt.

Frag den User, welches Paket zuerst gegrillt werden soll, und übergib dann an `/grill-me`.
