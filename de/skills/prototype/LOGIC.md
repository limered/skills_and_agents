# Logik-Prototyp

Eine einzelne, in sich geschlossene HTML-Datei (eine **teilbare Demo**), mit der jede Person ein Zustandsmodell per Klick auf Buttons steuern kann. Verwende das, wenn es um **Geschäftslogik, Zustandsübergänge oder die Form von Daten** geht: Dinge, die auf dem Papier vernünftig aussehen, sich aber erst falsch anfühlen, wenn man echte Fälle durchspielt.

Weil es eine einzige Datei ist, für die nichts installiert werden muss, kannst du sie Leuten ohne Entwicklungshintergrund geben (Design, Produktmanagement, Fachexpertise) und sie das Modell selbst erfühlen lassen. Deshalb spricht sie deren Sprache, nicht die des Codes.

## Wann das die richtige Form ist

- „Ich bin mir nicht sicher, ob diese Zustandsmaschine den Grenzfall abdeckt, bei dem erst X und dann Y passiert.“
- „Lässt mich dieses Datenmodell wirklich den Fall abbilden, dass …“
- „Ich will ein Gefühl dafür bekommen, wie die API aussehen sollte, bevor ich sie schreibe.“
- Alles, wo jemand **Buttons drücken und zusehen will, wie sich der Zustand ändert**.

Lautet die Frage „Wie soll das aussehen?“, ist das der falsche Zweig. Verwende [UI.md](UI.md).

## Ablauf

### 1. Die Frage formulieren

Schreib vor dem Coden auf, welches Zustandsmodell und welche Frage du mit dem Prototyp untersuchst. Ein Absatz, ganz oben in der Demo (in einer sichtbaren Einleitung, nicht nur als Kommentar). Ein Logik-Prototyp, der die falsche Frage beantwortet, ist reine Verschwendung; formuliere die Frage also explizit, damit sie später überprüft werden kann – ob der User gerade zusieht oder später AFK darauf zurückkommt.

### 2. Die Logik in einem portablen Modul isolieren

Leg die eigentliche Logik (den Teil, der die Frage beantwortet) in einen einzigen `<script>`-Block, geschrieben als kleines, reines Modul, das sich später herauslösen und in die echte Codebasis übernehmen lässt. Die Seite drumherum ist Wegwerfware; dieses Modul nicht.

Die richtige Form hängt von der Frage ab:

- **Ein reiner Reducer**: `(state, action) => state`. Gut, wenn Aktionen diskrete Ereignisse sind und der Zustand ein einzelner Wert ist.
- **Eine Zustandsmaschine**: explizite Zustände und Übergänge. Gut, wenn „Welche Aktionen sind gerade überhaupt erlaubt?“ Teil der Frage ist.
- **Eine kleine Menge reiner Funktionen** über einem einfachen Datentyp. Gut, wenn es keinen impliziten aktuellen Zustand gibt, nur Transformationen.
- **Eine Klasse oder ein Modul mit klarer Methodenoberfläche**, wenn die Logik wirklich laufenden internen Zustand besitzt.

Wähl die Form, die am besten zur gestellten Frage passt, *nicht* die, die sich am leichtesten an eine Seite anbinden lässt. Halte sie rein: kein DOM, kein `document`, keine Button-Handler, die hineingreifen. Die Seite ruft das Modul auf; nichts fließt in die andere Richtung. Das macht den Prototyp über seine eigene Lebensdauer hinaus nützlich: Ist die Frage beantwortet, lässt sich der validierte Reducer / die Maschine / die Funktionsmenge eigenständig ins echte Modul übernehmen.

### 3. Die teilbare HTML-Datei bauen

Eine Datei, reines HTML/CSS/JS: kein Framework, kein Bundler, kein Server, alles inline, damit sie per Doppelklick aufgeht und den Versand per E-Mail übersteht. Jede Person soll sie durch einfaches Öffnen ausführen können.

Schreib sie für Leute ohne Entwicklungshintergrund. Jede Beschriftung ist in **Domänensprache**, nicht in Code: Buttons und Zustand lesen sich wie das Geschäft, nicht wie der Reducer. Erklär in einfachen Worten, was passiert.

Gib ihr eine klare Hierarchie, von oben nach unten:

1. **Titel und einzeilige Erklärung** dessen, was sich mit dieser Demo erkunden lässt (die Frage aus Schritt 1).
2. **Aktueller Zustand**: der vollständige relevante Zustand, dargestellt als lesbares Panel (beschriftete Felder, kein roher JSON-Dump), nach jedem Klick neu gerendert, damit die Änderung sichtbar ist. Wo es beim Folgen hilft, heb hervor, was sich gerade geändert hat.
3. **Frei bedienbare Buttons**: ein Button pro Aktion, immer verfügbar, damit jede Person das Modell in beliebiger Reihenfolge anstupsen kann. Jeder Klick löst seine Aktion aus und rendert den Zustand neu.
4. **Geführte Durchläufe**: eine Reihe von **Szenarien**, eines pro Tab. Jeder Tab enthält eine kurze, verständliche Beschreibung des Szenarios (die Ausgangssituation und worauf man achten soll) und darunter die geordneten **Buttons, die zu drücken sind**. Jeder Schritt ist ein echter Button: Ein Klick führt die Aktion aus und geht zum nächsten Schritt. Der Start eines Durchlaufs setzt auf einen bekannten Ausgangszustand zurück, damit das Szenario jedes Mal gleich abläuft.

Wähl Szenarien, die die unbequemen Fälle zeigen, die auf dem Papier schwer zu durchdenken sind: den Happy Path, einen kniffligen Grenzfall, einen Versuch, etwas zu tun, das verboten sein sollte.

Halte sie schön, aber zurückhaltend: saubere Typografie, großzügige Abstände, eine Akzentfarbe. Keine Animationen, keine Spielereien: nichts, was mit dem Zustand und den Buttons konkurriert.

### 4. Übergeben

Schick ihnen die Datei oder öffne sie für sie. Sie klicken sich durch die Durchläufe und das freie Spiel, wann immer sie dazu kommen; die interessanten Momente sind, wenn sie sagen „Moment, das dürfte nicht möglich sein“ oder „Hm, ich dachte, X wäre anders“ – das sind die Bugs in der _Idee_, und genau darum geht es. Wollen sie neue Aktionen oder ein neues Szenario, füg sie hinzu. Prototypen entwickeln sich weiter.

### 5. Die Antwort und den Prototyp festhalten

Sobald der Prototyp seine Frage beantwortet hat, halte die Antwort fest und dann den Prototyp so, wie es die [SKILL](SKILL.md) beschreibt. Die logikspezifische Zuordnung: Der validierte Reducer / die Maschine / die Funktionsmenge wandert ins echte Modul (die Entscheidung, übernommen); die HTML-Hülle reist mit auf den Wegwerf-Branch, der den Prototyp als Primärquelle aufbewahrt – und weil sie eine einzige, in sich geschlossene Datei ist, bleibt sie dort trivial wieder ausführbar.

## Anti-Patterns

- **Keine Tests hinzufügen.** Ein Prototyp, der Tests braucht, ist kein Prototyp mehr.
- **Nicht an die echte Datenbank anbinden.** Verwende In-Memory-Zustand, außer die Frage dreht sich ausdrücklich um Persistenz.
- **Nicht verallgemeinern.** Kein „Was, wenn wir später X unterstützen wollen“. Der Prototyp beantwortet eine Frage.
- **Logik und Seite nicht vermischen.** Verweist das reine Modul auf das DOM, `document` oder Button-Handler, lässt es sich nicht mehr herauslösen. Halte die Seite als dünne Hülle über einem reinen Modul.
- **Kein Framework, kein Bundler, kein Server.** Eine Datei, die die Empfänger doppelklicken; eine React-App oder ein Dev-Server macht „teilbar“ zunichte.
- **Die HTML-Hülle nicht in Produktion ausliefern.** Die Seite ist darauf optimiert, von Hand durchgeklickt zu werden. Das Logikmodul dahinter ist der Teil, der sich zu behalten lohnt.
