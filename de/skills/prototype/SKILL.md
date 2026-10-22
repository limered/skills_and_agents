---
name: prototype
description: "Einen Wegwerf-Prototyp bauen, um eine Designfrage zu beantworten. Verwenden, wenn der User prüfen will, ob sich ein Zustandsmodell oder eine Logik richtig anfühlt, oder ausloten will, wie eine UI aussehen soll."
metadata:
  uses: ""
  requires: ""
---

# Prototyp

Ein Prototyp ist **Wegwerf-Code, der eine Frage beantwortet**. Die Frage bestimmt die Form. Bau das Dünnste, was sie beantwortet: nichts Wiederverwendbares, nichts über die Frage hinaus.

## Einen Zweig wählen

Stell fest, welche Frage beantwortet werden soll – anhand des Prompts des Users, des umgebenden Codes oder durch Nachfragen, wenn der User erreichbar ist:

- **„Fühlt sich diese Logik / dieses Zustandsmodell richtig an?“** → [LOGIC.md](LOGIC.md). Bau eine einzelne teilbare HTML-Datei (frei bedienbare Buttons plus geführte Durchläufe in Tabs), die die Zustandsmaschine durch Fälle treibt, die auf dem Papier schwer zu durchdenken sind, und die auch Nicht-Entwickler bedienen können.
- **„Wie soll das aussehen?“** → [UI.md](UI.md). Erzeuge mehrere radikal unterschiedliche UI-Varianten auf einer einzigen Route, umschaltbar über einen URL-Suchparameter und eine schwebende Leiste am unteren Rand.

Die beiden Zweige erzeugen sehr unterschiedliche Artefakte; wer hier falsch wählt, verschwendet den ganzen Prototyp. Ist die Frage wirklich mehrdeutig und der User nicht erreichbar, nimm den Zweig, der besser zum umgebenden Code passt (ein Backend-Modul → Logik; eine Seite oder Komponente → UI), und nenne die Annahme ganz oben im Prototyp.

## Regeln für beide Zweige

1. **Von Anfang an Wegwerfware und klar als solche gekennzeichnet.** Leg den Prototyp-Code nah an die Stelle, an der er tatsächlich gebraucht wird (neben das Modul oder die Seite, für die er gebaut wird), damit der Kontext offensichtlich ist, aber benenne ihn so, dass man auch beim flüchtigen Lesen erkennt, dass es ein Prototyp ist und kein Produktionscode. Halte dich bei Wegwerf-UI-Routen an die Routing-Konvention, die das Projekt bereits verwendet; erfinde keine neue Top-Level-Struktur.
2. **Trivial zu starten.** Ein UI-Prototyp startet mit einem Befehl im Task-Runner des Projekts: `pnpm <name>`, `python <path>`, `bun <path>` usw. Eine Logik-Demo ist eine einzelne HTML-Datei, die der User doppelklickt. So oder so: Starten ohne Nachdenken.
3. **Standardmäßig keine Persistenz.** Der Zustand lebt im Speicher. Persistenz ist das, was der Prototyp _prüft_, nicht etwas, von dem er abhängen soll. Geht es in der Frage ausdrücklich um eine Datenbank, nutze eine Scratch-DB oder eine lokale Datei mit einem eindeutigen Namen wie „PROTOTYPE, wipe me“.
4. **Verzichte auf Feinschliff.** Keine Tests, keine Fehlerbehandlung über das hinaus, was den Prototyp _lauffähig_ macht, keine Abstraktionen. Es geht darum, schnell etwas zu lernen.
5. **Mach den Zustand sichtbar.** Gib nach jeder Aktion (Logik) bzw. bei jedem Variantenwechsel (UI) den vollständigen relevanten Zustand aus, damit der User sieht, was sich geändert hat.
6. **Halte ihn am Ende fest.** Übernimm jede validierte Entscheidung in den echten Code und halte dann den Prototyp selbst als **Primärquelle** fest: Committe ihn auf einen Wegwerf-Branch außerhalb von main und hinterleg im Implementierungs-Issue einen Kontext-Verweis auf diesen Branch. Halte auch die Antwort fest (das Urteil und die Frage, die es geklärt hat), im Issue oder in einem Commit. Der main-Branch behält nur die validierte Entscheidung.
