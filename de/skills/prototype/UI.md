# UI-Prototyp

Erzeuge **mehrere radikal unterschiedliche UI-Varianten** auf einer einzigen Route, umschaltbar über eine schwebende Leiste am unteren Rand. Der User blättert im Browser durch die Varianten, wählt eine aus (oder übernimmt Teile aus mehreren) und wirft den Rest weg.

Geht es in der Frage um Logik/Zustand statt um das Aussehen, ist das der falsche Zweig. Verwende [LOGIC.md](LOGIC.md).

## Wann das die richtige Form ist

- „Wie soll diese Seite aussehen?“
- „Ich will ein paar Optionen für dieses Dashboard sehen, bevor ich mich festlege.“
- „Probier ein anderes Layout für den Einstellungsbildschirm.“
- Immer dann, wenn der User sonst einen Tag damit verbringen würde, sich im Kopf zwischen drei vagen Mockups zu entscheiden.

## Zwei Unterformen: Unterform A klar bevorzugen

Ein UI-Prototyp lässt sich viel leichter beurteilen, wenn er **direkt an den Rest der App anstößt**: echter Header, echte Sidebar, echte Daten, echte Dichte. Eine Wegwerf-Route für sich allein ist ein Vakuum: Jede Variante sieht isoliert gut aus. Nimm standardmäßig Unterform A, wann immer es eine plausible bestehende Seite gibt, die die Varianten aufnehmen kann. Greif nur zu Unterform B, wenn der Prototyp wirklich kein naheliegendes Zuhause hat.

### Unterform A: Anpassung einer bestehenden Seite (bevorzugt)

Die Route existiert bereits. Die Varianten werden **auf derselben Route** gerendert, gesteuert über einen URL-Suchparameter `?variant=`. Das bestehende Data Fetching, die Parameter und die Authentifizierung bleiben. Nur das Rendering wechselt. Das ist der Standard; wähle ihn, sofern es keinen konkreten Grund dagegen gibt.

Ist der Prototyp für etwas, das noch keine eigene Seite hat, aber *natürlich in eine hineingehören würde* (ein neuer Bereich im Dashboard, eine neue Karte im Einstellungsbildschirm, ein neuer Schritt in einem bestehenden Ablauf), ist es trotzdem Unterform A. Bau die Varianten in die Host-Seite ein.

### Unterform B: eine neue Seite (letzter Ausweg)

Nur verwenden, wenn das, wofür der Prototyp gebaut wird, wirklich keine bestehende Seite hat, in der es leben könnte (z. B. eine völlig neue Top-Level-Oberfläche oder ein Ablauf, der sich nirgends sinnvoll einbetten lässt).

Leg eine **Wegwerf-Route** nach der Routing-Konvention an, die das Projekt bereits verwendet. Erfinde keine neue Top-Level-Struktur. Benenne sie so, dass sie offensichtlich ein Prototyp ist (z. B. mit dem Wort `prototype` im Pfad oder Dateinamen). Gleiches `?variant=`-Muster.

Bevor du dich für Unterform B entscheidest, prüfe: Gibt es wirklich keine bestehende Seite, in die sich das einbetten ließe? Eine leere Route verbirgt Designprobleme, die eine befüllte aufdecken würde.

In beiden Unterformen ist die schwebende Leiste am unteren Rand identisch.

## Ablauf

### 1. Die Frage formulieren und N wählen

Standard sind **3 Varianten**. Mehr als 5 sind nicht mehr radikal verschieden, sondern Rauschen – dort ist Schluss.

Schreib den Plan in einer Zeile auf, am Ort des Prototyps oder als Kommentar ganz oben in der Datei:

> „Drei Varianten der Einstellungsseite, umschaltbar über `?variant=`, auf der bestehenden Route `/settings`.“

Das funktioniert unabhängig davon, ob der User gerade da ist, um zu widersprechen, oder nicht.

### 2. Radikal unterschiedliche Varianten erzeugen

Entwirf jede Variante. Halte dich bei jeder an:

- Den Zweck der Seite und die Daten, auf die sie Zugriff hat.
- Die Komponentenbibliothek bzw. das Styling-System des Projekts (TailwindCSS, shadcn, MUI, reines CSS, was auch immer).
- Einen klaren exportierten Komponentennamen, z. B. `VariantA`, `VariantB`, `VariantC`.

Varianten müssen **strukturell verschieden** sein: anderes Layout, andere Informationshierarchie, andere primäre Interaktion, nicht nur andere Farben. Drei leicht abgewandelte Karten-Grids sind kein UI-Prototyp, sondern Tapete. Fallen zwei Entwürfe zu ähnlich aus, mach einen davon neu, mit der ausdrücklichen Vorgabe „kein Karten-Grid verwenden“.

### 3. Sie verdrahten

Leg auf der Route eine einzige Switcher-Komponente an:

```tsx
// Pseudocode, an das Framework des Projekts anpassen
const variant = searchParams.get('variant') ?? 'A';
return (
  <>
    {variant === 'A' && <VariantA {...data} />}
    {variant === 'B' && <VariantB {...data} />}
    {variant === 'C' && <VariantC {...data} />}
    <PrototypeSwitcher variants={['A','B','C']} current={variant} />
  </>
);
```

Für Unterform A (bestehende Seite): Lass das gesamte bestehende Data Fetching oberhalb des Switchers; nur der gerenderte Teilbaum ändert sich pro Variante.

Für Unterform B (neue Seite): Die Wegwerf-Route unter `/prototype/<name>` bindet denselben Switcher ein.

### 4. Die schwebende Umschaltleiste bauen

Eine kleine, fest positionierte Leiste unten mittig auf dem Bildschirm mit drei Elementen:

- **Pfeil links**: wechselt zur vorherigen Variante (mit Umlauf).
- **Variantenbezeichnung**: zeigt den aktuellen Variantenschlüssel und, falls die Variante einen Namen exportiert, auch diesen, z. B. `B (Sidebar layout)`.
- **Pfeil rechts**: wechselt vorwärts (mit Umlauf).

Verhalten:

- Ein Klick auf einen Pfeil aktualisiert den URL-Suchparameter (über den Router des Frameworks, z. B. `router.replace` bei Next, `navigate` bei React Router usw.), damit die Variante teilbar ist und ein Neuladen übersteht.
- Tastatur: `←` und `→` wechseln ebenfalls. Fang die Pfeiltasten nicht ab, wenn ein `<input>`, `<textarea>` oder `[contenteditable]` den Fokus hat.
- Optisch deutlich von der Seite abgehoben (z. B. kontrastreiche Pille, dezenter Schatten), damit klar ist, dass sie nicht zum bewerteten Design gehört.
- In Produktions-Builds ausgeblendet: an `process.env.NODE_ENV !== 'production'` oder eine gleichwertige Prüfung koppeln, damit ein versehentlich gemergter Prototyp die Leiste nicht an User ausliefert.

Leg den Switcher in eine einzige gemeinsame Komponente, damit beide Unterformen ihn wiederverwenden können. Platziere ihn dort, wo im Projekt gemeinsame UI liegt.

### 5. Übergeben

Gib die URL (und die `?variant=`-Schlüssel) weiter. Der User blättert durch, wann immer er dazu kommt. Das interessante Feedback ist meist **„Ich will den Header aus B mit der Sidebar aus C“** – und genau das ist das eigentlich gewünschte Design.

### 6. Die Antwort festhalten und aufräumen

Sobald eine Variante gewonnen hat, halte die Antwort fest (welche Variante und warum) und dann den Prototyp so, wie es die [SKILL](SKILL.md) beschreibt. Übernimm die Gewinnerin in den echten Code und verschieb den Rest auf den Wegwerf-Branch, nicht nach main:

- **Unterform A**: Übernimm die Gewinnerin in die bestehende Seite; entferne die unterlegenen Varianten und den Switcher aus main.
- **Unterform B**: Mach aus der Gewinner-Variante eine echte Route; entferne die Wegwerf-Route und den Switcher aus main.

Der vollständige Satz an Varianten ist die Primärquelle und landet deshalb auf dem Wegwerf-Branch, nicht im Müll – denn Variantenkomponenten und der Switcher verrotten im main-Branch schnell und verwirren alle, die als Nächstes lesen.

## Anti-Patterns

- **Varianten, die sich nur in Farbe oder Text unterscheiden.** Das ist eine Feinjustierung, kein Prototyp. Echte Varianten sind sich in der Struktur uneinig.
- **Zu viel gemeinsamer Code zwischen den Varianten.** Ein gemeinsamer `<Header>` ist in Ordnung; ein gemeinsames `<Layout>` verfehlt den Zweck. Jede Variante sollte das Layout über Bord werfen dürfen.
- **Varianten an echte Mutationen anbinden.** Rein lesende Prototypen sind in Ordnung. Muss eine Variante etwas verändern, lass sie gegen einen Stub laufen: Die Frage ist „Wie soll das aussehen?“, nicht „Funktioniert das Backend?“.
- **Den Prototyp direkt in Produktion übernehmen.** Der Variantencode entstand unter Prototyp-Bedingungen (keine Tests, minimale Fehlerbehandlung). Schreib ihn ordentlich neu, wenn du ihn übernimmst.
