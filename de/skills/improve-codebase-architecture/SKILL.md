---
name: improve-codebase-architecture
description: "Eine Codebasis nach Vertiefungsmöglichkeiten durchsuchen und sie als flache Liste von Kandidatenkarten berichten. Rein lesende Erkundung – keine Berichtsdatei, kein Grillen, keine Schreibzugriffe aufs Repo."
disable-model-invocation: true
metadata:
  uses: "codebase-design"
  requires: "codebase-design"
---

# Codebasis-Architektur verbessern

Mach architektonische Reibung sichtbar und schlag **Vertiefungsmöglichkeiten** vor – Refactorings, die flache Module in tiefe verwandeln. Ziel sind Testbarkeit und Navigierbarkeit für KI.

Dieser Skill ist ein einziger **Erkundungs**-Durchlauf. Er ist rein lesend: Er schreibt nichts ins Repo, legt keine Berichtsdatei an und stellt keine Fragen. Seine gesamte Ausgabe ist eine flache Liste von Kandidatenkarten, die ein Mensch später sichtet.

Dieser Skill ist vom Domänenmodell des Projekts _geprägt_ und baut auf einem gemeinsamen Design-Vokabular auf:

- Führ den Skill `/codebase-design` aus, um das Architekturvokabular (**Modul**, **Schnittstelle**, **Tiefe**, **Seam**, **Adapter**, **Hebelwirkung**, **Lokalität**) und seine Prinzipien (der Löschtest, „die Schnittstelle ist die Testoberfläche“, „ein Adapter = hypothetische Seam, zwei = echte“) zu erhalten. Verwende diese Begriffe in jedem Kandidaten exakt – weich nicht auf „Komponente“, „Service“, „API“ oder „Grenze“ aus.
- Die Domänensprache in `CONTEXT.md` gibt guten Seams ihre Namen; ADRs in `docs/adr/` halten Entscheidungen fest, die dieser Skill nicht neu verhandeln soll.

## Ablauf

Erkunden, dann Kandidatenkarten ausgeben. Das ist der gesamte Ablauf – es gibt keinen Berichtsschritt und keinen Grill-Schritt.

### Erkunden

**Erst eingrenzen, dann scannen – YAGNI.** Ein Modul zu vertiefen zahlt sich aus, weil künftige Änderungen daran leichter werden; gewichte deshalb die Teile der Codebasis stärker, die sich kürzlich geändert haben. Entscheide, *wo* du suchst, bevor du suchst:

- Wurde eine Richtung genannt – ein Modul, ein Subsystem, ein Schmerzpunkt –, nimm sie und überspring die Ableitung unten.
- Andernfalls geh ein gutes Stück der Commit-Historie zurück (`git log --oneline`), um die Hotspots der Codebasis zu finden – die Dateien und Bereiche, die immer wieder auftauchen – und lass diese Pfade zuerst deine Aufmerksamkeit lenken. Sind die Änderungen ohne klaren Hotspot verstreut, zieh das Netz weiter.

Lies zuerst das Domänenglossar des Projekts (`CONTEXT.md`) und alle ADRs in dem Bereich, den du berührst.

Starte dann einen Sub-Agent, der die Codebasis durchläuft. Folge keinen starren Heuristiken – erkunde organisch und notiere, wo du Reibung spürst:

- Wo muss man für das Verständnis eines Konzepts zwischen vielen kleinen Modulen hin- und herspringen?
- Wo sind Module **flach** – die Schnittstelle fast so komplex wie die Implementierung?
- Wo wurden reine Funktionen nur der Testbarkeit wegen extrahiert, während die echten Bugs darin stecken, wie sie aufgerufen werden (keine **Lokalität**)?
- Wo lecken eng gekoppelte Module über ihre Seams hinweg?
- Welche Teile der Codebasis sind ungetestet oder über ihre aktuelle Schnittstelle schwer zu testen?

Wende auf alles, was du für flach hältst, den **Löschtest** an: Würde das Löschen die Komplexität bündeln oder nur verschieben? Ein „ja, bündelt“ ist das Signal, das du suchst.

### Kandidatenkarten ausgeben

Berichte jeden Kandidaten als Karte, in reinem Text (kein HTML, keine Diagramme, keine geschriebene Datei). Verwende das `CONTEXT.md`-Vokabular für die Domäne und das `/codebase-design`-Vokabular für die Architektur: Definiert `CONTEXT.md` „Bestellung“, sprich vom „Bestellannahme-Modul“ – nicht vom „FooBarHandler“ und nicht vom „Bestellservice“.

Jede Karte hat genau diese Felder:

- **Dateien** – welche Dateien/Module beteiligt sind.
- **Problem** – warum die aktuelle Architektur Reibung verursacht, in Begriffen des Glossars.
- **Lösung** – verständliche Beschreibung dessen, was sich ändern würde.
- **Nutzen** – erklärt in Begriffen von Lokalität und Hebelwirkung, und wie sich die Tests verbessern würden.
- **Empfehlungsstärke** – einer der Werte `Strong`, `Worth exploring`, `Speculative` (diese Werte bleiben englisch, weil Pipelines danach filtern).

**ADR-Konflikte**: Widerspricht ein Kandidat einem bestehenden ADR, bring ihn nur dann zur Sprache, wenn die Reibung echt genug ist, um das ADR neu aufzurollen. Kennzeichne das deutlich auf der Karte (z. B. _„widerspricht ADR-0007 – aber es lohnt sich, das neu aufzurollen, weil …“_). Liste nicht jedes theoretische Refactoring auf, das ein ADR verbietet.

Schlag **keine** konkreten Schnittstellen vor, bilde **keine** Rangfolge mit einem einzigen Favoriten und frag **nicht**, welcher Kandidat erkundet werden soll – ein Mensch sichtet die Karten später.

Hat die Erkundung keine Kandidaten ergeben, sag das klar und gib keine Karten aus.

## Regeln

- **Rein lesend aufs Repo**: keine Edits, keine Commits, keine Dateien darin – auch kein HTML-Bericht.
- **Keine Interaktion**: keine Fragen, keine Grill-Schleife, kein interaktiver Modus.
- **Ein Durchlauf**: einmal erkunden und ausgeben; nie wiederholen oder erneut starten.
- **Das Vokabular ist tragend**: Verwende die Glossarbegriffe aus `/codebase-design` exakt; greif zu einem bestehenden Begriff, bevor du einen neuen erfindest.
