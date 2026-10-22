# ADR-Format

ADRs liegen in `docs/adr/` und sind fortlaufend nummeriert: `0001-slug.md`, `0002-slug.md` usw.

Leg das Verzeichnis `docs/adr/` erst an, wenn das erste ADR gebraucht wird.

## Vorlage

```md
# {Kurzer Titel der Entscheidung}

{1–3 Sätze: Was ist der Kontext, was wurde entschieden und warum.}
```

Das war's. Ein ADR kann ein einziger Absatz sein. Der Wert liegt darin festzuhalten, *dass* eine Entscheidung getroffen wurde und *warum* – nicht darin, Abschnitte auszufüllen.

## Optionale Abschnitte

Nur aufnehmen, wenn sie echten Mehrwert bringen. Die meisten ADRs brauchen sie nicht.

- **Status**-Frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`): nützlich, wenn Entscheidungen erneut aufgegriffen werden
- **Betrachtete Optionen**: nur, wenn es sich lohnt, die verworfenen Alternativen festzuhalten
- **Konsequenzen**: nur, wenn nicht offensichtliche Folgewirkungen benannt werden müssen

## Nummerierung

Such in `docs/adr/` die höchste vorhandene Nummer und erhöhe sie um eins.

## Wann ein ADR anbieten

Alle drei Punkte müssen zutreffen:

1. **Schwer umkehrbar**: Es kostet spürbar, die Meinung später zu ändern
2. **Ohne Kontext überraschend**: Wer den Code künftig liest, wird sich fragen: „Warum um alles in der Welt wurde das so gemacht?“
3. **Ergebnis eines echten Trade-offs**: Es gab echte Alternativen, und eine wurde aus bestimmten Gründen gewählt

Ist eine Entscheidung leicht umkehrbar, lass das ADR weg: Man würde sie einfach umkehren. Ist sie nicht überraschend, wird sich niemand wundern. Gab es keine echte Alternative, gibt es nichts festzuhalten außer „Wir haben das Naheliegende getan“.

### Was sich qualifiziert

- **Architektonische Form.** „Wir verwenden ein Monorepo.“ „Das Write-Model ist event-sourced, das Read-Model wird in Postgres projiziert.“
- **Integrationsmuster zwischen Kontexten.** „Ordering und Billing kommunizieren über Domain Events, nicht über synchrones HTTP.“
- **Technologieentscheidungen mit Lock-in.** Datenbank, Message Bus, Auth-Provider, Deployment-Ziel. Nicht jede Bibliothek: nur die, deren Austausch ein Quartal dauern würde.
- **Grenz- und Scope-Entscheidungen.** „Kundendaten gehören dem Customer-Kontext; andere Kontexte referenzieren sie nur per ID.“ Die ausdrücklichen Neins sind so wertvoll wie die Jas.
- **Bewusste Abweichungen vom naheliegenden Weg.** „Wir verwenden handgeschriebenes SQL statt eines ORM, weil X.“ Alles, bei dem man vernünftigerweise das Gegenteil annehmen würde. Solche ADRs verhindern, dass als Nächstes jemand etwas „repariert“, das Absicht war.
- **Rahmenbedingungen, die im Code nicht sichtbar sind.** „Wir dürfen AWS aus Compliance-Gründen nicht nutzen.“ „Antwortzeiten müssen wegen des Partner-API-Vertrags unter 200 ms liegen.“
- **Verworfene Alternativen, wenn die Ablehnung nicht offensichtlich ist.** Wenn GraphQL in Betracht gezogen und aus subtilen Gründen REST gewählt wurde, halte es fest; sonst schlägt in sechs Monaten jemand wieder GraphQL vor.
