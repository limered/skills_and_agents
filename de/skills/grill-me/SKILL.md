---
name: grill-me
description: "Den User unerbittlich zu einem Plan, einer Entscheidung oder einer Idee grillen. Verwenden, wenn der User sein Denken einem Stresstest unterziehen oder einen Plan bzw. ein Design schärfen will oder Trigger wie ‚grill me‘, ‚grill mich‘ oder ‚löchere mich‘ verwendet."
metadata:
  uses: ""
  requires: ""
---

Interviewe den User unerbittlich, bis ihr ein gemeinsames Verständnis erreicht habt. Bilde das als **Entscheidungsbaum** ab: Jede Entscheidung verzweigt in die Entscheidungen, die an ihr hängen.

Arbeite den Baum in **Runden** ab. Die **Frontier** umfasst jede Entscheidung, deren Voraussetzungen bereits geklärt sind: die Fragen, die du _jetzt_ stellen kannst, ohne Antworten zu erraten, die du noch nicht gehört hast. Stell höchstens drei Fragen pro Runde: Enthält die Frontier mehr als drei, stell die drei mit der höchsten Priorität – die, die die meisten nachgelagerten Entscheidungen blockieren – und verschieb den Rest auf spätere Runden. Warte dann auf die Antworten des Users, bevor du die nächste Runde beginnst.

Formatiere eine Runde so:

```
❓ **F1** - **<Titel der Frage>**: <Fragetext, ggf. mehrere Absätze, einschließlich mehrerer Antwortoptionen>

📎 Kontext: <warum diese Frage jetzt wichtig ist – auf welche geklärte Entscheidung sie folgt, was sie freischaltet>

➡️ <deine empfohlene Antwort>

---

❓ **F2** - **<Titel der Frage>**: <Fragetext, ggf. mehrere Absätze, einschließlich mehrerer Antwortoptionen>

📎 Kontext: <warum diese Frage jetzt wichtig ist – auf welche geklärte Entscheidung sie folgt, was sie freischaltet>

➡️ <deine empfohlene Antwort>
```

Biete in jeder Runde mindestens eine Spar-Option an: Nimm unter die Antwortmöglichkeiten jeder Frage die Variante auf, die weniger tut (weglassen, Vorhandenes wiederverwenden, engerer Scope), und benenne ihren Trade-off klar – der User entscheidet, aber der günstige Weg liegt immer auf dem Tisch.

Jede beantwortete Runde formt den Baum um: Geklärte Entscheidungen schieben die Frontier nach außen und schalten Fragen frei, die von ihnen abhingen. Berechne die Frontier neu und stell die nächste Runde (wieder höchstens drei Fragen). Eine Frage, deren Antwort von einer anderen, in dieser Runde noch offenen Frage abhängt, gehört in eine _spätere_ Runde, nicht in diese.

_Fakten_ herauszufinden ist deine Aufgabe, nie die des Users. Braucht eine Frontier-Frage einen Fakt aus der Umgebung (Dateisystem, Tools usw.), schick einen Sub-Agent los, der ihn findet; frag den User nie nach etwas, das du selbst nachschlagen kannst. Blockiere nicht darauf: Eine laufende Untersuchung ist eine ungeklärte Voraussetzung, also warten nur die Fragen, die von ihr abhängen, auf den Bericht des Sub-Agents; stell den Rest der Frontier jetzt (im Rahmen des Budgets von drei Fragen). Die _Entscheidungen_ gehören dem User: Leg ihm jede vor und warte.

Die Sitzung ist beendet, wenn die Frontier leer ist: jeder Zweig des Entscheidungsbaums besucht, nichts stillschweigend angenommen. Handle erst, wenn der User bestätigt, dass ihr ein gemeinsames Verständnis erreicht habt.
