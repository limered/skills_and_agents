---
name: domain-modeling
description: "Das Domänenmodell eines Projekts aufbauen und schärfen. Verwenden, wenn es um Begriffe in der Codebasis geht, beim Schreiben oder Bearbeiten einer CONTEXT.md oder beim Festhalten oder Bearbeiten eines ADR."
metadata:
  uses: ""
  requires: ""
---

# Domänenmodellierung

Baue das Domänenmodell des Projekts aktiv auf und schärfe es, während du entwirfst. Das ist die *aktive* Disziplin: Begriffe hinterfragen, Grenzfall-Szenarien erfinden und Glossar und Entscheidungen in dem Moment aufschreiben, in dem sie sich herauskristallisieren. (Die `CONTEXT.md` bloß wegen des Vokabulars zu *lesen*, ist nicht dieser Skill: Das ist eine einzeilige Gewohnheit, die jeder Skill haben kann. Dieser Skill ist dafür da, das Modell zu verändern, nicht nur, es zu konsumieren.)

## Dateistruktur

Die meisten Repos haben einen einzigen Kontext:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

Existiert im Root eine `CONTEXT-MAP.md`, hat das Repo mehrere Kontexte. Die Map zeigt, wo jeder davon liegt:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← systemweite Entscheidungen
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← kontextspezifische Entscheidungen
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Leg Dateien erst an, wenn du etwas hineinzuschreiben hast. Gibt es keine `CONTEXT.md`, erstelle sie, sobald der erste Begriff geklärt ist. Gibt es kein `docs/adr/`, erstelle es, sobald das erste ADR gebraucht wird.

## Während der Sitzung

### Gegen das Glossar prüfen

Verwendet der User einen Begriff, der der bestehenden Sprache in `CONTEXT.md` widerspricht, sprich es sofort an. „Dein Glossar definiert ‚Stornierung‘ als X, du scheinst aber Y zu meinen. Was davon gilt?“

### Unscharfe Sprache schärfen

Verwendet der User vage oder überladene Begriffe, schlag einen präzisen kanonischen Begriff vor. „Du sagst ‚Konto‘: Meinst du den Kunden oder den Benutzer? Das sind verschiedene Dinge.“

### Konkrete Szenarien durchspielen

Wenn Beziehungen in der Domäne besprochen werden, prüfe sie mit konkreten Szenarien auf Belastbarkeit. Erfinde Szenarien, die Grenzfälle ausloten und den User zwingen, die Grenzen zwischen Konzepten genau zu ziehen.

### Mit dem Code abgleichen

Wenn der User beschreibt, wie etwas funktioniert, prüfe, ob der Code das bestätigt. Findest du einen Widerspruch, mach ihn sichtbar: „Dein Code storniert immer ganze Bestellungen, aber du hast gerade gesagt, Teilstornierungen seien möglich. Was stimmt?“

### CONTEXT.md sofort aktualisieren

Ist ein Begriff geklärt, aktualisiere `CONTEXT.md` sofort. Sammle das nicht: Halte es fest, sobald es passiert. Verwende das Format aus [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`CONTEXT.md` soll völlig frei von Implementierungsdetails sein. Behandle `CONTEXT.md` nicht als Spec, Notizzettel oder Ablage für Implementierungsentscheidungen. Sie ist ein Glossar und sonst nichts.

### ADRs sparsam anbieten

Biete ein ADR nur an, wenn alle drei Punkte zutreffen:

1. **Schwer umkehrbar**: Es kostet spürbar, die Meinung später zu ändern
2. **Ohne Kontext überraschend**: Wer den Code künftig liest, wird sich fragen: „Warum wurde das so gemacht?“
3. **Ergebnis eines echten Trade-offs**: Es gab echte Alternativen, und eine wurde aus bestimmten Gründen gewählt

Fehlt einer der drei Punkte, lass das ADR weg. Verwende das Format aus [ADR-FORMAT.md](./ADR-FORMAT.md).
