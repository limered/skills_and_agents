---
name: atomic-commit
description: "Änderungen atomar committen – mit der kleinstmöglichen zusammengehörigen Menge an Änderungen pro Commit."
metadata:
  uses: ""
  requires: ""
---

Wichtig: Ignoriere andere Commit-Skills!

# Format

Format der Commit-Nachricht:

```
<Ticketnummer>(falls vorhanden) <Zusammenfassung in Kleinbuchstaben, im Imperativ>

Optional: <Erklärung, warum die Änderung nötig war>
```

Commit-Nachrichten schreibst du auf Englisch – das Format, die Beispiele und der Imperativ-Test unten sind auf englische Grammatik ausgelegt.

Verwende keine Commit-Typen wie `feat`, `chore`, `fix` o. Ä.

Beispiele:
- regenerate RenewOps
- add guide for npm cloudsmith migration
- A2M-1070 draft plan for moving/rename Generators into Packages/Brickmkers.CodeGen.Cli
- add generate-backend and generate-frontend CLI commands

# Regeln

## Du darfst Änderungen stagen

Entscheide anhand dieser Regeln, welche Änderungen du in welchen Gruppen stagst.

## Atomare Commits, nicht ein Commit pro Feature/Issue

Bevorzuge atomare Commits statt ganzer Features oder Issues pro Commit. Kleine Änderungen sind auch ohne lange Commit-Beschreibung leicht zu verstehen.

## Betreffzeile auf 50 Zeichen begrenzen

50 Zeichen sind keine harte Grenze, sondern eine Faustregel. Bei dieser Länge bleiben Betreffzeilen lesbar, und wer committet, muss kurz überlegen, wie sich die Änderung am knappsten beschreiben lässt.

Passt es nicht hinein, ist der Commit zu groß.

## Imperativ in der Betreffzeile

Eine korrekt formulierte Git-Betreffzeile muss immer diesen englischen Satz vervollständigen können:

If applied, this commit will <deine Betreffzeile>

Zum Beispiel:

If applied, this commit will refactor subsystem X for readability
If applied, this commit will update getting started documentation
If applied, this commit will remove deprecated methods
If applied, this commit will release version 1.0.0
If applied, this commit will merge pull request #123 from user/branch

## Bei 72 Zeichen umbrechen

Empfohlen sind 72 Zeichen, damit Git genug Platz zum Einrücken hat und alles insgesamt unter 80 Zeichen bleibt.

## Den Body für das Was und Warum nutzen statt für das Wie – aber sparsam

Lass ihn weg, wenn die Änderung klein ist oder die Betreffzeile genug Kontext liefert. Keine doppelten Texte. Die vollständige Nachricht liest ohnehin niemand, und andere Entwickler sollen den Code als einzige Quelle der Wahrheit lesen.

Meist kannst du Details dazu weglassen, wie eine Änderung umgesetzt wurde. Code ist in dieser Hinsicht in der Regel selbsterklärend (und wenn der Code so komplex ist, dass er in Prosa erklärt werden muss, sind dafür Quellcode-Kommentare da). Konzentriere dich darauf, die Gründe für die Änderung klarzumachen: wie es vorher funktionierte (und was daran falsch war), wie es jetzt funktioniert und warum du es so gelöst hast.

# Aufgabe

1. Wenn nichts gestaged ist: informiere den User und hör auf
2. Analysiere die gestagten Änderungen
3. Ermittle die Ticketnummer aus dem Branch-Namen (frag nach, wenn unklar)
4. Entwirf Commit-Nachrichten nach dem Format oben
5. Frag: **„Soll ich so committen:“** <Liste der Commits>
6. Committe erst nach ausdrücklicher Zustimmung
