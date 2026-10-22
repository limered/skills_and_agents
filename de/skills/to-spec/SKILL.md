---
name: to-spec
description: "Die aktuelle Unterhaltung in eine Spec verwandeln und im Issue-Tracker des Projekts veröffentlichen: kein Interview, nur eine Synthese dessen, was bereits besprochen wurde."
disable-model-invocation: true
metadata:
  uses: ""
  requires: ""
---

Dieser Skill nimmt den aktuellen Gesprächskontext und das Verständnis der Codebasis und erzeugt daraus eine Spec. Interviewe den User NICHT; fasse nur zusammen, was du bereits weißt.

Der Issue-Tracker ist GitHub Issues (bedient über `gh`). Triage-Labels: `ready-for-agent`, `ready-for-human`, `wontfix` – sonst nichts.

## Ablauf

1. Erkunde das Repo, um den aktuellen Stand der Codebasis zu verstehen, falls noch nicht geschehen. Verwende in der gesamten Spec das Vokabular aus dem Domänenglossar des Projekts und beachte ADRs in dem Bereich, den du berührst.

2. Skizziere die Seams, an denen du das Feature testen wirst. Bestehende Seams sind neuen vorzuziehen. Nimm die höchstmögliche Seam. Braucht es neue Seams, schlag sie so weit oben wie möglich vor. Je weniger Seams quer durch die Codebasis, desto besser – ideal ist eine.

Kläre mit dem User, ob diese Seams seinen Erwartungen entsprechen.

3. Schreib die Spec nach der Vorlage unten und veröffentliche sie dann im Issue-Tracker des Projekts. Vergib das Triage-Label `ready-for-agent` – weitere Triage ist nicht nötig.

<spec-template>

## Problemstellung

Das Problem, vor dem der User steht, aus seiner Sicht.

## Lösung

Die Lösung des Problems, aus Sicht des Users.

## User Stories

Eine LANGE, nummerierte Liste von User Stories. Jede User Story hat dieses Format:

1. Als <Akteur> möchte ich <Feature>, damit <Nutzen>

<user-story-example>
1. Als Kundin einer mobilen Bank möchte ich den Saldo meiner Konten sehen, damit ich fundiertere Entscheidungen über meine Ausgaben treffen kann
</user-story-example>

Diese Liste von User Stories soll extrem umfangreich sein und alle Aspekte des Features abdecken.

## Implementierungsentscheidungen

Eine Liste der getroffenen Implementierungsentscheidungen. Das kann umfassen:

- Die Module, die gebaut/geändert werden
- Die Schnittstellen dieser Module, die geändert werden
- Technische Klarstellungen aus dem Entwicklungsteam
- Architekturentscheidungen
- Schemaänderungen
- API-Verträge
- Konkrete Interaktionen

Nimm KEINE konkreten Dateipfade oder Code-Schnipsel auf. Sie können sehr schnell veralten.

Ausnahme: Hat ein Prototyp einen Schnipsel hervorgebracht, der eine Entscheidung präziser festhält, als Prosa es kann (Zustandsmaschine, Reducer, Schema, Typform), füge ihn bei der betreffenden Entscheidung inline ein und vermerke kurz, dass er aus einem Prototyp stammt. Kürze ihn auf die entscheidungsrelevanten Teile – keine lauffähige Demo, nur das Wesentliche.

## Testentscheidungen

Eine Liste der getroffenen Testentscheidungen. Enthält:

- Eine Beschreibung dessen, was einen guten Test ausmacht (nur externes Verhalten testen, keine Implementierungsdetails)
- Welche Module getestet werden
- Vorbilder für die Tests (d. h. ähnliche Tests in der Codebasis)

## Außerhalb des Scopes

Eine Beschreibung dessen, was außerhalb des Scopes dieser Spec liegt.

## Weitere Hinweise

Alle weiteren Hinweise zum Feature.

</spec-template>
