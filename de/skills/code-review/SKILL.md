---
name: code-review
description: "Prüft die Änderungen seit einem Fixpunkt (Commit, Branch, Tag oder Merge-Base) entlang zweier Achsen – Standards (folgt der Code den dokumentierten Coding-Standards des Repos?) und Spec (entspricht der Code dem, was das ursprüngliche Issue bzw. die Spec verlangt hat?). Führt beide Reviews in parallelen Sub-Agents aus und berichtet sie nebeneinander. Verwenden, wenn der User einen Branch, einen PR oder laufende Änderungen reviewen lassen will oder um ein „Review seit X“ bittet."
metadata:
  uses: ""
  requires: ""
---

Zwei-Achsen-Review des Diffs zwischen `HEAD` und einem Fixpunkt, den der User vorgibt:

- **Standards** – entspricht der Code den dokumentierten Coding-Standards dieses Repos?
- **Spec** – setzt der Code das ursprüngliche Issue bzw. die Spec getreu um?

Beide Achsen laufen als **parallele Sub-Agents**, damit sie sich nicht gegenseitig den Kontext verunreinigen; anschließend führt dieser Skill ihre Findings zusammen.

Der Issue-Tracker ist GitHub Issues (bedient über `gh`). Hat das Repo kein GitHub-Remote, liegen Spec-Issues als lokales Markdown unter `.scratch/`.

## Ablauf

### 1. Fixpunkt festlegen

Was der User genannt hat, ist der Fixpunkt – ein Commit-SHA, Branch-Name, Tag, `main`, `HEAD~5` usw. Hat er keinen genannt, frag danach.

Halte den Diff-Befehl einmal fest: `git diff <fixed-point>...HEAD` (drei Punkte, damit gegen die Merge-Base verglichen wird). Notiere außerdem die Commit-Liste über `git log <fixed-point>..HEAD --oneline`.

Prüfe, bevor es weitergeht, dass der Fixpunkt auflösbar ist (`git rev-parse <fixed-point>`) und der Diff nicht leer ist. Eine ungültige Ref oder ein leerer Diff soll hier scheitern – nicht erst in zwei parallelen Sub-Agents.

### 2. Spec-Quelle ermitteln

Suche die ursprüngliche Spec in dieser Reihenfolge:

1. Issue-Referenzen in den Commit-Nachrichten (`#123`, `Closes #45` usw.) – abrufen mit `gh issue view <N> --json title,body,comments`, oder die lokale Datei direkt lesen, wenn das Repo den lokalen Markdown-Tracker nutzt.
2. Ein Pfad, den der User als Argument übergeben hat.
3. Eine Spec-Datei unter `docs/`, `specs/` oder `.scratch/`, die zum Branch-Namen oder Feature passt.
4. Wird nichts gefunden, frag den User, wo die Spec liegt. Sagt er, es gibt keine, wird der **Spec**-Sub-Agent übersprungen und meldet „keine Spec verfügbar“.

### 3. Standards-Quellen ermitteln

Alles im Repo, was dokumentiert, wie Code geschrieben werden soll, z. B. `CODING_STANDARDS.md` oder `CONTRIBUTING.md`.

Zusätzlich zu dem, was das Repo dokumentiert, bringt die Standards-Achse immer die **Smell-Baseline** unten mit – eine feste Auswahl von Code Smells nach Fowler (_Refactoring_, Kap. 3), die auch dann gilt, wenn ein Repo nichts dokumentiert. Zwei Regeln binden sie:

- **Das Repo hat Vorrang.** Ein dokumentierter Repo-Standard gewinnt immer; wo er etwas gutheißt, das die Baseline anmerken würde, unterdrücke den Smell.
- **Immer eine Ermessensfrage.** Jeder Smell ist eine benannte Heuristik („möglicherweise Feature Envy“), nie ein harter Verstoß – und wie bei jedem Standard hier: Überspring alles, was bereits durch Tooling erzwungen wird.

Jeder Smell liest sich als *was er ist* → *wie man ihn behebt*; gleiche ihn mit dem Diff ab:

- **Mysterious Name** – eine Funktion, Variable oder ein Typ, dessen Name nicht verrät, was er tut oder enthält. → umbenennen; fällt kein ehrlicher Name ein, ist das Design unklar.
- **Duplicated Code** – dieselbe Logikform taucht in mehr als einem Hunk oder einer Datei der Änderung auf. → die gemeinsame Form extrahieren und von beiden Stellen aufrufen.
- **Feature Envy** – eine Methode greift mehr auf die Daten eines anderen Objekts zu als auf die eigenen. → die Methode zu den beneideten Daten verschieben.
- **Data Clumps** – dieselben paar Felder oder Parameter reisen immer gemeinsam (ein Typ, der geboren werden will). → zu einem Typ bündeln und diesen übergeben.
- **Primitive Obsession** – ein primitiver Wert oder String steht für ein Domänenkonzept, das einen eigenen Typ verdient. → dem Konzept einen eigenen kleinen Typ geben.
- **Repeated Switches** – dieselbe `switch`/`if`-Kaskade auf demselben Typ wiederholt sich in der Änderung. → durch Polymorphie ersetzen oder durch eine Map, die beide Stellen teilen.
- **Shotgun Surgery** – eine logische Änderung erzwingt verstreute Edits über viele Dateien im Diff. → das, was sich gemeinsam ändert, in einem Modul zusammenführen.
- **Divergent Change** – eine Datei oder ein Modul wird aus mehreren voneinander unabhängigen Gründen geändert. → so aufteilen, dass sich jedes Modul nur aus einem Grund ändert.
- **Speculative Generality** – Abstraktionen, Parameter oder Hooks für Bedürfnisse, die die Spec nicht hat. → löschen; zurück inlinen, bis sich ein echter Bedarf zeigt.
- **Message Chains** – lange `a.b().c().d()`-Navigation, von der der Aufrufer nicht abhängen sollte. → den Weg hinter einer Methode am ersten Objekt verbergen.
- **Middle Man** – eine Klasse oder Funktion, die größtenteils nur weiterdelegiert. → entfernen, das eigentliche Ziel direkt aufrufen.
- **Refused Bequest** – eine Unterklasse oder Implementierung, die den Großteil des Geerbten ignoriert oder überschreibt. → Vererbung aufgeben, Komposition verwenden.

Zusätzlich zur Baseline gelten diese Einfachheitsheuristiken – wie die Smells Ermessensfragen, nie harte Verstöße: keine unverlangten Abstraktionen (kein Interface mit nur einer Implementierung, keine Factory für nur ein Produkt, keine Konfiguration für einen Wert, der sich nie ändert); kein Gerüst „für später“; Löschen vor Hinzufügen; so wenige Dateien wie möglich; der kürzeste Diff, der an der richtigen Stelle sitzt.

### 4. Beide Sub-Agents parallel starten

**Prompt für den Standards-Sub-Agent** – enthält:

- Den vollständigen Diff-Befehl und die Commit-Liste.
- Die Liste der Standards-Quelldateien aus Schritt 3, **plus die Smell-Baseline aus Schritt 3** vollständig eingefügt – der Sub-Agent hat sonst keinen Zugriff darauf.
- Den Auftrag: „Berichte – wo sinnvoll pro Datei/Hunk – (a) jede Stelle, an der der Diff gegen einen dokumentierten Standard verstößt: Nenne den Standard (Datei + Regel); und (b) jeden Baseline-Smell, den du entdeckst: Benenne ihn und zitiere den Hunk. Unterscheide harte Verstöße von Ermessensfragen – Verstöße gegen dokumentierte Standards können hart sein, Baseline-Smells sind immer Ermessensfragen, und ein dokumentierter Repo-Standard hat Vorrang vor der Baseline. Überspring alles, was Tooling erzwingt. Unter 400 Wörtern.“

**Prompt für den Spec-Sub-Agent** – enthält:

- Den Diff-Befehl und die Commit-Liste.
- Den Pfad oder den abgerufenen Inhalt der Spec.
- Den Auftrag: „Berichte: (a) Anforderungen aus der Spec, die fehlen oder nur teilweise umgesetzt sind; (b) Verhalten im Diff, das nicht verlangt war (Scope Creep); (c) Anforderungen, die umgesetzt aussehen, deren Umsetzung aber falsch wirkt. Zitiere zu jedem Finding die Zeile aus der Spec. Unter 400 Wörtern.“

Fehlt die Spec, überspring den Spec-Sub-Agent und vermerke das im Abschlussbericht.

### 5. Zusammenführen

Präsentiere die beiden Berichte unter den Überschriften `## Standards` und `## Spec`, wörtlich oder leicht bereinigt. Führe die Findings **nicht** zusammen und ordne sie nicht neu – die beiden Achsen sind bewusst getrennt (siehe _Warum zwei Achsen_).

Schließ mit einer einzeiligen Zusammenfassung: Anzahl der Findings pro Achse und das schwerwiegendste Problem _innerhalb jeder Achse_ (falls vorhanden). Kür keinen Gesamtsieger über beide Achsen hinweg – das ist genau die Neuordnung, die die Trennung verhindern soll.

## Warum zwei Achsen

Eine Änderung kann eine Achse bestehen und an der anderen scheitern:

- Code, der jeden Standard einhält, aber das Falsche umsetzt → **Standards bestanden, Spec nicht bestanden.**
- Code, der genau das tut, was das Issue verlangt, aber die Konventionen des Projekts bricht → **Spec bestanden, Standards nicht bestanden.**

Getrennte Berichte verhindern, dass eine Achse die andere verdeckt.
