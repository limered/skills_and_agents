# CONTEXT.md-Format

## Struktur

```md
# {Name des Kontexts}

{Ein oder zwei Sätze dazu, was dieser Kontext ist und warum es ihn gibt.}

## Sprache

**Bestellung**:
{Eine Beschreibung des Begriffs in ein oder zwei Sätzen}
_Vermeiden_: Kauf, Transaktion

**Rechnung**:
Eine Zahlungsaufforderung, die nach der Lieferung an einen Kunden geht.
_Vermeiden_: Abrechnung, Zahlungsanforderung

**Kunde**:
Eine Person oder Organisation, die Bestellungen aufgibt.
_Vermeiden_: Klient, Käufer, Konto
```

## Regeln

- **Sei meinungsstark.** Gibt es mehrere Wörter für dasselbe Konzept, wähle das beste und führe die anderen unter `_Vermeiden_` auf.
- **Halte Definitionen knapp.** Höchstens ein oder zwei Sätze. Definiere, was etwas IST, nicht, was es tut.
- **Nimm nur Begriffe auf, die für den Kontext dieses Projekts spezifisch sind.** Allgemeine Programmierkonzepte (Timeouts, Fehlertypen, Utility-Muster) gehören nicht hinein, selbst wenn das Projekt sie intensiv nutzt. Frag dich vor dem Hinzufügen eines Begriffs: Ist das ein Konzept, das es nur in diesem Kontext gibt, oder ein allgemeines Programmierkonzept? Nur Ersteres gehört hinein.
- **Gruppiere Begriffe unter Zwischenüberschriften**, wenn sich natürliche Cluster ergeben. Gehören alle Begriffe zu einem zusammenhängenden Bereich, ist eine flache Liste in Ordnung.

## Repos mit einem vs. mehreren Kontexten

**Ein Kontext (die meisten Repos):** Eine `CONTEXT.md` im Repo-Root.

**Mehrere Kontexte:** Eine `CONTEXT-MAP.md` im Repo-Root listet die Kontexte auf, wo sie liegen und wie sie zueinander stehen:

```md
# Context Map

## Kontexte

- [Ordering](./src/ordering/CONTEXT.md): nimmt Kundenbestellungen entgegen und verfolgt sie
- [Billing](./src/billing/CONTEXT.md): erstellt Rechnungen und wickelt Zahlungen ab
- [Fulfillment](./src/fulfillment/CONTEXT.md): steuert Kommissionierung und Versand im Lager

## Beziehungen

- **Ordering → Fulfillment**: Ordering sendet `OrderPlaced`-Events; Fulfillment konsumiert sie, um die Kommissionierung zu starten
- **Fulfillment → Billing**: Fulfillment sendet `ShipmentDispatched`-Events; Billing konsumiert sie, um Rechnungen zu erstellen
- **Ordering ↔ Billing**: Gemeinsame Typen für `CustomerId` und `Money`
```

Der Skill leitet ab, welche Struktur gilt:

- Existiert `CONTEXT-MAP.md`, lies sie, um die Kontexte zu finden
- Existiert nur eine `CONTEXT.md` im Root, gibt es einen Kontext
- Existiert keins von beiden, leg eine `CONTEXT.md` im Root an, sobald der erste Begriff geklärt ist

Gibt es mehrere Kontexte, leite ab, auf welchen sich das aktuelle Thema bezieht. Ist das unklar, frag nach.
