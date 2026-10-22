---
name: wayfinder
description: "Ein sehr großes Vorhaben (mehr, als eine Agent-Sitzung fassen kann) als gemeinsame Karte aus Entscheidungstickets im Issue-Tracker planen und diese einzeln auflösen, bis der Weg zum Ziel klar ist."
disable-model-invocation: true
metadata:
  uses: "domain-modeling, grill-me, prototype, research, to-spec"
  requires: "domain-modeling, grill-me, prototype, research, to-spec"
---

Eine lose Idee ist eingetroffen, zu groß für eine Agent-Sitzung und in Nebel gehüllt: Der Weg von hier zum **Ziel** ist noch nicht sichtbar. Bei der Wegfindung geht es darum, diesen Weg zu finden, nicht darum, auf das Ziel loszustürmen. Dieser Skill kartiert den Weg als **gemeinsame Karte** im Issue-Tracker des Repos und arbeitet dann ihre **Entscheidungstickets** ab (Fragen, deren Auflösung eine Entscheidung ist, keine Bauabschnitte, die auszuführen sind) – eines nach dem anderen, bis die Route klar ist.

Das Ziel ist je Vorhaben verschieden, und es zu benennen ist der erste Schritt der Kartierung: Es prägt jedes Ticket. Es kann eine Spec sein, die übergeben und weiterentwickelt wird, eine Entscheidung, die vor Planungsbeginn feststehen muss, oder eine Änderung an Ort und Stelle wie die Migration einer Datenstruktur. Die Karte ist domänenunabhängig: Engineering-Arbeit, Kursinhalte, was auch immer in diese Form passt.

## Planen, nicht machen

Wayfinder ist standardmäßig **Planung**: Jedes Ticket löst eine Entscheidung auf, und die Karte ist fertig, wenn der Weg klar ist und nichts mehr zu entscheiden bleibt, bevor jemand losgeht und die Sache umsetzt. Der Drang, die Arbeit einfach zu erledigen, ist meist das Signal, dass du den Rand der Karte erreicht hast und es Zeit für die Übergabe ist. Ein Vorhaben kann das in seinen **Notizen** überschreiben und die Umsetzung in die Karte selbst hineinholen; ohne das gilt: Entscheidungen produzieren, keine Ergebnisse.

## Beim Namen nennen

Jede Karte und jedes Ticket ist ein Issue und hat daher einen **Namen**: seinen Titel. In allem, was ein Mensch liest (Erzählung, die Bisherigen Entscheidungen der Karte), verweise darauf mit diesem Namen, nie mit einer nackten ID, Nummer oder einem Slug. Eine Wand aus `#42, #43, #44` ist unlesbar; Namen erfasst man auf einen Blick. ID und URL verschwinden nicht; ein Name umschließt seinen Link, sie reisen also _innerhalb_ des Namens mit, ersetzen ihn aber nie.

## Die Karte

Die Karte ist ein einzelnes Issue im Issue-Tracker dieses Repos (beim lokalen Tracker eine Datei `map.md` unter `.scratch/<feature>/`), mit dem Label `wayfinder:map` – das kanonische Artefakt. Ihre Tickets sind Child-Issues der Karte.

Die Karte ist ein **Index**, kein Speicher. Sie listet die getroffenen Entscheidungen und verweist auf die Tickets, die deren Details enthalten; eine Entscheidung lebt an genau einem Ort, ihrem Ticket, also wiederholt die Karte sie nie, sondern fasst sie nur knapp zusammen und verlinkt.

**Wo die Karte, ihre Child-Tickets, Blockierungen und Frontier-Abfragen physisch liegen, hängt vom Tracker ab.** Wayfinder funktioniert mit dem lokalen Markdown-Tracker: Die Karte ist `map.md`, Tickets sind Dateien `NN-<slug>.md` unter `.scratch/<feature>/`, und Blockierungen stehen als „Blocked by“-Text in jeder Datei. Lokal gibt es keine Labels – der Ticket-Typ steht im Ticket-Body. Ist die Karte vollständig aufgelöst, übergib das Ziel an `/to-spec`, das die Spec im Issue-Tracker veröffentlicht.

### Der Body der Karte

Die gesamte Karte in niedriger Auflösung, einmal pro Sitzung geladen. Offene Tickets werden **nicht** aufgelistet: Sie sind offene Child-Issues und werden per Abfrage gefunden.

```markdown
## Ziel

<wie das Erreichen des Endes dieser Karte aussieht: die Spec, Entscheidung oder Änderung, zu der dieses Vorhaben seinen Weg sucht. Ein oder zwei Zeilen; jede Sitzung orientiert sich daran, bevor sie ein Ticket wählt.>

## Notizen

<Domäne; Skills, die jede Sitzung heranziehen soll; feste Vorgaben für dieses Vorhaben>

## Bisherige Entscheidungen

<!-- der Index: eine Zeile pro geschlossenem Ticket, genug, um die Relevanz einzuschätzen; für die Details, die das Ticket enthält, den Link öffnen -->

- [<Titel des geschlossenen Tickets>](link): <einzeilige Kernaussage der Antwort>

## Noch nicht spezifiziert

<!-- siehe „Nebel des Krieges“: Nebel im Scope, den du noch nicht als Ticket fassen kannst; rückt nach, wenn die Frontier vorrückt -->

## Außerhalb des Scopes

<!-- siehe „Außerhalb des Scopes“: Arbeit jenseits des Ziels; geschlossen, rückt nie nach -->
```

### Tickets

Jedes Ticket ist ein **Child-Issue** der Karte; die Issue-ID im Tracker ist seine Identität. Sein Body ist die Frage, bemessen auf eine Agent-Sitzung mit 100K Tokens:

```markdown
## Frage

<die Entscheidung oder Untersuchung, die dieses Ticket auflöst>
```

Jedes Ticket trägt ein Label `wayfinder:<type>`, eines von `research`, `prototype`, `grilling`, `task` (siehe [Ticket-Typen](#ticket-typen)).

Eine Sitzung **beansprucht** ein Ticket, indem sie es der Person zuweist, die die Karte vorantreibt – und zwar **zuerst**, vor jeder Arbeit, damit parallele Sitzungen es überspringen. Diese Zuweisung _ist_ der Anspruch: Ein offenes, nicht zugewiesenes Ticket ist unbeansprucht.

Blockierungen verwenden die **native** Abhängigkeitsbeziehung des Trackers: wesentlich, weil sie die Frontier _visuell_ in der eigenen UI des Trackers darstellt, sodass Menschen sehen, was übernommen werden kann, ohne die Karte zu öffnen. Nur ein Tracker ohne native Blockierungen weicht auf eine Konvention im Body aus. Ein Ticket ist **unblockiert**, wenn jedes Ticket, das es blockiert, geschlossen ist; die **Frontier** sind die offenen, unblockierten, unbeanspruchten Child-Tickets – die Grenze des Bekannten.

Die Antwort ist nicht Teil des Bodys; sie wird bei der Auflösung festgehalten (siehe [Die Karte abarbeiten](#die-karte-abarbeiten)). Assets, die beim Auflösen eines Tickets entstehen, werden vom Issue aus verlinkt, nicht hineinkopiert.

## Ticket-Typen

Jedes Ticket ist entweder **HITL** (Human in the Loop, _mit_ einem Menschen bearbeitet, der für sich selbst spricht) oder **AFK**, allein vom Agent vorangetrieben. Ein HITL-Ticket löst sich nur durch diesen Live-Austausch auf; der Agent springt nie für die Seite des Menschen ein (ein Grill-Agent, der seine eigenen Fragen beantwortet, hat genau das gebrochen).

- **Research** (AFK): Dokumentation, Drittanbieter-APIs oder lokale Ressourcen wie Wissensdatenbanken lesen, um einen Fakt zu ermitteln, auf den eine Entscheidung wartet. Aufgelöst von einem Sub-Agent, der das Skill-Tool mit „research“ aufruft. Verwenden, wenn Wissen außerhalb des aktuellen Arbeitsverzeichnisses gebraucht wird.
- **Prototype** (HITL): Die Diskussion konkreter machen, indem ein günstiges, grobes, greifbares Artefakt entsteht, auf das man reagieren kann (eine Gliederung, ein grober Entwurf, ein Stub oder UI-/Logik-Code), durch Aufruf des Skill-Tools mit „prototype“. Verlinkt den Prototyp als Asset. Verwenden, wenn „Wie soll es aussehen?“ oder „Wie soll es sich verhalten?“ die Kernfrage ist.
- **Grilling** (HITL): Gespräch. Der Standardfall. Ruf das Skill-Tool immer zweimal auf, für „grill-me“ und „domain-modeling“.
- **Task** (HITL oder AFK): Manuelle Arbeit, die erledigt sein muss, bevor eine _Entscheidung_ getroffen werden kann: nichts zu entscheiden, zu prototypen oder zu recherchieren, aber die Diskussion ist blockiert, bis es erledigt ist. Sich bei einem Dienst registrieren, damit seine API beurteilt werden kann; Zugänge einrichten; Daten verschieben, damit ihre Form sichtbar wird. Das ist der einzige Typ, der etwas _tut_ statt zu entscheiden, und er verdient seinen Platz, indem er eine Entscheidung freischaltet, nicht indem er das Ziel liefert. Der Agent erledigt es allein, wo er kann (AFK); andernfalls gibt er dem Menschen eine präzise Checkliste (HITL). Aufgelöst, wenn die Arbeit erledigt ist; die Antwort hält fest, was getan wurde, und alle daraus resultierenden Fakten (Ort der Zugangsdaten, neue URLs, Zeilenzahlen), von denen spätere Tickets abhängen.

## Nebel des Krieges

Die Karte ist _absichtlich_ unvollständig: Kartiere nicht, was du noch nicht sehen kannst. Jenseits der aktiven Tickets liegt der **Nebel des Krieges**: die vage Sicht auf Entscheidungen und Untersuchungen, von denen du ahnst, dass sie kommen, die du aber noch nicht festmachen kannst, weil sie an noch offenen Fragen hängen. Das Auflösen eines Tickets lichtet den Nebel davor; was jetzt spezifizierbar ist, rückt als neue Tickets nach, eines nach dem anderen, bis der Weg zum Ziel klar ist und keine Tickets mehr übrig sind.

Der Abschnitt **Noch nicht spezifiziert** der Karte ist der Ort, an dem diese vage Sicht aufgeschrieben wird: die vermutete Frage, der Bereich, den man später wieder aufgreifen sollte. Er ist die unentdeckte Frontier _in Richtung_ Ziel: Alles hier liegt im Scope, ist nur noch nicht scharf genug für ein Ticket. Schreib so lose oder so ausführlich, wie die Sicht es erlaubt; das dient zugleich als Wegweiser für alle, die mitarbeiten und lesen wollen, wohin das Vorhaben steuert.

**Nebel oder Ticket?** Der Test ist, ob du die Frage jetzt präzise formulieren kannst, _nicht_, ob du sie jetzt beantworten kannst.

- **Ticket, wenn** die Frage schon scharf ist, selbst wenn sie blockiert ist und du noch nicht daran arbeiten kannst.
- **Noch nicht spezifiziert, wenn** du sie noch nicht so scharf formulieren kannst. Zerteil den Nebel nicht vorab in ticketgroße Stücke: Er ist gröber als ein Ticket, und ein Fleck kann zu mehreren Tickets werden oder zu keinem, sobald die Frontier ihn erreicht.

**Noch nicht spezifiziert** schließt aus, was bereits entschieden ist (Bisherige Entscheidungen), was bereits ein aktives Ticket ist und was außerhalb des Scopes liegt (nächster Abschnitt).

## Außerhalb des Scopes

Nebel sammelt sich immer nur _in Richtung_ Ziel. Das Ziel legt den Scope fest, also ist Arbeit jenseits davon **außerhalb des Scopes**: Sie ist kein Nebel und gehört nicht unter **Noch nicht spezifiziert**. Sie bekommt einen eigenen Abschnitt **Außerhalb des Scopes** auf der Karte: Arbeit, die du für _dieses_ Vorhaben bewusst ausgeschlossen hast. Der Scope, nicht die Schärfe, bringt sie hierher.

Arbeit außerhalb des Scopes rückt nie nach (die Frontier endet am Ziel); sie kehrt nur zurück, wenn das Ziel neu gezogen wird, und dann als neues Vorhaben, nicht als Fortsetzung.

Etwas aus dem Scope auszuschließen ist ein Akt der Abgrenzung, kein Schritt auf der Route. Stellt sich heraus, dass ein bereits existierendes Ticket jenseits des Ziels liegt (beim Kartieren fälschlich in den Scope geraten oder durch eine Auflösung entlarvt), **schließ es** (ein geschlossenes Ticket ist eindeutig nicht mehr auf der Frontier) und hinterlass eine Zeile im Abschnitt **Außerhalb des Scopes**: die Kernaussage plus warum es außerhalb des Scopes liegt, mit Link auf das geschlossene Ticket. Es bleibt aus **Bisherige Entscheidungen** heraus, denn dort steht die tatsächlich gegangene Route; eine Scope-Grenze ist kein Schritt darauf.

## Aufruf

Zwei Modi. In beiden gilt: **Löse nie mehr als ein Ticket pro Sitzung auf**, mit Ausnahme von Research-Tickets.

### Die Karte zeichnen

Der User ruft den Skill mit einer losen Idee auf.

1. **Das Ziel benennen.** Ruf das Skill-Tool zweimal auf, für „grill-me“ und „domain-modeling“, um festzunageln, wohin diese Karte ihren Weg sucht: die Spec, Entscheidung oder Änderung. Das Ziel legt den Scope fest, also wird es zuerst geklärt.
2. **Die Frontier kartieren.** Grille erneut, diesmal **in die Breite**: Fächere über den gesamten Raum auf, statt tief in einen einzelnen Strang zu gehen, und bring die offenen Entscheidungen und die ersten jetzt machbaren Schritte zutage. **Kommt dabei kein Nebel zutage** (der Weg zum Ziel ist bereits klar, die gesamte Reise klein genug für eine Sitzung), brauchst du keine Karte. Hör auf und frag den User, wie er weitermachen möchte.
3. **Die Karte anlegen** (Label `wayfinder:map`): Ziel und Notizen ausgefüllt, Bisherige Entscheidungen leer, der Nebel skizziert unter **Noch nicht spezifiziert**.
4. **Die Tickets anlegen, die du jetzt spezifizieren kannst**, als Child-Issues der Karte, und dann die Blockierungen in einem **zweiten Durchgang** verdrahten (Issues brauchen IDs, bevor sie sich gegenseitig referenzieren können). Das Verdrahten sortiert sie in Frontier und Blockierte; alles, was du noch nicht spezifizieren kannst, bleibt im Nebel: im Abschnitt **Noch nicht spezifiziert**.
5. **Die Research-Sub-Agents starten.** Starte für jedes gerade angelegte `research`-Ticket einen Sub-Agent, der das Skill-Tool mit „research“ aufruft, um es parallel aufzulösen, und seine Ergebnisse auf einem Wegwerf-Branch `research/<name>` festhält, mit einem Kontext-Verweis vom Ticket aus.
6. Stopp: Das Kartieren ist die Arbeit einer Sitzung; es löst nichts von Hand auf.

### Die Karte abarbeiten

Der User ruft den Skill mit einer Karte auf (URL oder Nummer). Ein Ticket ist **optional**: Ohne eines wählst du die nächste Entscheidung, nicht der User.

1. Lade die **Karte**: die Sicht in niedriger Auflösung, nicht jeden Ticket-Body.
2. Wähl das Ticket. Hat der User eines genannt, nimm es. Andernfalls nimm das erste Frontier-Ticket in der Reihenfolge. **Beanspruche es**: Weise es dir selbst zu, vor jeder Arbeit.
3. Löse es auf. **Zoome nach Bedarf**: Hol bei Bedarf den vollständigen Body jedes verwandten oder geschlossenen Tickets; ruf das Skill-Tool für die Skills auf, die der Block `## Notizen` nennt. Im Zweifel ruf das Skill-Tool zweimal auf, für „grill-me“ und „domain-modeling“.
4. Halte die Auflösung fest: Poste die Antwort als **Auflösungskommentar**, **schließ** das Issue und **häng einen Kontext-Verweis** an die Bisherigen Entscheidungen der Karte an.
5. Füg neu aufgetauchte Tickets hinzu (anlegen, dann verdrahten); lass jeden Nebel nachrücken, den die Antwort spezifizierbar gemacht hat, und entferne jeden nachgerückten Fleck aus **Noch nicht spezifiziert**, damit er nur noch als sein neues Ticket existiert. Zeigt die Antwort, dass ein Ticket (dieses oder ein anderes) jenseits des Ziels liegt, **schließ es aus dem Scope aus**, statt es auf der Route aufzulösen. Macht die Entscheidung andere Teile der Karte ungültig, aktualisiere oder lösche diese Tickets.

Der User kann unblockierte Tickets parallel bearbeiten lassen; rechne also damit, dass andere Sitzungen den Tracker gleichzeitig bearbeiten.
