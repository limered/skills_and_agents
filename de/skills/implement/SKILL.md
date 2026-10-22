---
name: implement
description: "Ein Arbeitspaket auf Basis einer Spec oder einer Reihe von Tickets implementieren."
disable-model-invocation: true
metadata:
  uses: "code-review, tdd"
  requires: "code-review, codebase-design, tdd"
---

Implementiere die Arbeit, die der User in der Spec oder den Tickets beschreibt.

Baue sparsam (YAGNI, Framework zuerst): Hör bei der ersten tragfähigen Lösung auf – muss es überhaupt existieren (wenn nicht, sag das und lass es weg); hat die Codebasis es schon (wiederverwenden, nicht neu implementieren); kann die Standardbibliothek es; deckt ein natives Plattform-Feature es ab (gegenüber einer Abhängigkeit oder eigenem Code bevorzugen); löst es eine bereits installierte Abhängigkeit (nie eine neue hinzufügen für etwas, das ein paar Zeilen erledigen); andernfalls der kleinste Diff, der funktioniert.

Bugfixes zielen auf die Ursache, nicht auf das Symptom: Such vor dem Editieren per grep jeden Aufrufer der Funktion und behebe den Fehler dort, wo alle Aufrufer durchlaufen – nicht nur auf dem Pfad, den das Ticket nennt.

Liefere die sparsame Version und hinterfrage sie in derselben Antwort („X umgesetzt; Y deckt es ab. Volles X nötig? Sag Bescheid.“) – bleib nie an einer Antwort hängen, für die du einen sinnvollen Standard setzen kannst.

Verwende /tdd, wo möglich, an vorab vereinbarten Seams – beschränkt auf die kleinsten Checks, die fehlschlagen, wenn die Logik bricht; vollständige Suites nur auf Anfrage.

Führ regelmäßig Typechecks aus, regelmäßig einzelne Testdateien und am Ende einmal die vollständige Test-Suite. Sagt der Aufrufer, dass eine separate Phase die Tests ausführt (oder bittet anderweitig darum, den vollständigen Lauf zu überspringen), überspring den vollständigen Test-Suite-Lauf am Ende.

Implementiere über Sub-Agents: Teile die Arbeit nach Ticket oder Seam auf und starte einen Sub-Agent pro unabhängiger Einheit, wo möglich parallel; integriere ihre Ergebnisse auf dem aktuellen Branch.

Wenn du fertig bist, verwende /code-review, um die Arbeit zu reviewen – es startet eigene parallele Sub-Agents pro Achse.

Committe deine Arbeit auf den aktuellen Branch.
