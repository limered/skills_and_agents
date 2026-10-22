---
name: codebase-design
description: "Gemeinsames Vokabular für das Design tiefer Module. Verwenden, wenn der User die Schnittstelle eines Moduls entwerfen oder verbessern, Vertiefungsmöglichkeiten finden, über die Lage einer Seam entscheiden oder Code testbarer bzw. für KI navigierbarer machen will – oder wenn ein anderer Skill das Deep-Module-Vokabular braucht."
metadata:
  uses: ""
  requires: ""
---

# Codebase-Design

Entwirf **tiefe Module**: viel Verhalten hinter einer kleinen Schnittstelle, platziert an einer sauberen Seam, testbar über genau diese Schnittstelle. Verwende diese Sprache und diese Prinzipien überall, wo Code entworfen oder umstrukturiert wird. Ziel ist Hebelwirkung für Aufrufer, Lokalität für Maintainer und Testbarkeit für alle.

## Glossar

Verwende diese Begriffe exakt – ersetze sie nicht durch „Komponente“, „Service“, „API“ oder „Grenze“. Konsistente Sprache ist der ganze Sinn.

**Modul** – alles mit einer Schnittstelle und einer Implementierung. Bewusst unabhängig von der Größenordnung: eine Funktion, eine Klasse, ein Paket oder ein Schnitt quer durch mehrere Schichten. _Vermeiden_: Unit, Komponente, Service.

**Schnittstelle** (Interface) – alles, was ein Aufrufer wissen muss, um das Modul korrekt zu benutzen: die Typsignatur, aber auch Invarianten, Reihenfolgebedingungen, Fehlermodi, erforderliche Konfiguration und Performance-Eigenschaften. _Vermeiden_: API, Signatur (zu eng – beide meinen nur die Oberfläche auf Typebene).

**Implementierung** – was in einem Modul steckt, sein Code-Rumpf. Abzugrenzen vom **Adapter**: Etwas kann ein kleiner Adapter mit großer Implementierung sein (ein Postgres-Repository) oder ein großer Adapter mit kleiner Implementierung (ein In-Memory-Fake). Greif zu „Adapter“, wenn die Seam das Thema ist, sonst zu „Implementierung“.

**Tiefe** – Hebelwirkung an der Schnittstelle: wie viel Verhalten ein Aufrufer (oder Test) pro gelernter Schnittstelleneinheit auslösen kann. Ein Modul ist **tief**, wenn viel Verhalten hinter einer kleinen Schnittstelle sitzt, und **flach**, wenn die Schnittstelle fast so komplex ist wie die Implementierung.

**Seam** _(Michael Feathers)_ – eine Stelle, an der du Verhalten ändern kannst, ohne an genau dieser Stelle zu editieren; der *Ort*, an dem die Schnittstelle eines Moduls lebt. Wo die Seam hinkommt, ist eine eigene Designentscheidung, getrennt davon, was dahinter liegt. _Vermeiden_: Grenze/Boundary (überladen durch den Bounded Context aus DDD).

**Adapter** – ein konkretes Ding, das eine Schnittstelle an einer Seam erfüllt. Beschreibt die *Rolle* (welchen Platz es füllt), nicht die Substanz (was drinsteckt).

**Hebelwirkung** (Leverage) – was Aufrufer von Tiefe haben: mehr Fähigkeit pro gelernter Schnittstelleneinheit. Eine Implementierung zahlt sich über N Aufrufstellen und M Tests aus.

**Lokalität** (Locality) – was Maintainer von Tiefe haben: Änderungen, Bugs, Wissen und Verifikation bündeln sich an einer Stelle, statt sich über die Aufrufer zu verteilen. Einmal behoben, überall behoben.

## Tief vs. flach

**Tiefes Modul** = kleine Schnittstelle + viel Implementierung:

```
┌─────────────────────────┐
│  Kleine Schnittstelle   │  ← Wenige Methoden, einfache Parameter
├─────────────────────────┤
│                         │
│  Tiefe Implementierung  │  ← Komplexe Logik verborgen
│                         │
└─────────────────────────┘
```

**Flaches Modul** = große Schnittstelle + wenig Implementierung (vermeiden):

```
┌─────────────────────────────────┐
│       Große Schnittstelle       │  ← Viele Methoden, komplexe Parameter
├─────────────────────────────────┤
│  Dünne Implementierung          │  ← Reicht nur durch
└─────────────────────────────────┘
```

Frag dich beim Entwurf einer Schnittstelle:

- Kann ich die Zahl der Methoden reduzieren?
- Kann ich die Parameter vereinfachen?
- Kann ich mehr Komplexität nach innen verlagern?

## Prinzipien

- **Tiefe ist eine Eigenschaft der Schnittstelle, nicht der Implementierung.** Ein tiefes Modul kann intern aus kleinen, mockbaren, austauschbaren Teilen bestehen – sie sind nur nicht Teil der Schnittstelle. Ein Modul kann **interne Seams** haben (privat für seine Implementierung, von seinen eigenen Tests genutzt) und dazu die **externe Seam** an seiner Schnittstelle.
- **Der Löschtest.** Stell dir vor, du löschst das Modul. Verschwindet die Komplexität, war es nur ein Durchreicher. Taucht die Komplexität bei N Aufrufern wieder auf, hat es seinen Platz verdient.
- **Die Schnittstelle ist die Testoberfläche.** Aufrufer und Tests überqueren dieselbe Seam. Wenn du *hinter* die Schnittstelle testen willst, hat das Modul vermutlich die falsche Form.
- **Ein Adapter bedeutet eine hypothetische Seam. Zwei Adapter bedeuten eine echte.** Führ keine Seam ein, solange nichts tatsächlich über sie hinweg variiert.

## Design für Testbarkeit

Gute Schnittstellen machen Testen natürlich:

1. **Abhängigkeiten annehmen, nicht erzeugen.**

   ```typescript
   // Testbar
   function processOrder(order, paymentGateway) {}

   // Schwer zu testen
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **Ergebnisse zurückgeben, keine Seiteneffekte erzeugen.**

   ```typescript
   // Testbar
   function calculateDiscount(cart): Discount {}

   // Schwer zu testen
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **Kleine Oberfläche.** Weniger Methoden = weniger nötige Tests. Weniger Parameter = einfacheres Test-Setup.

## Beziehungen

- Ein **Modul** hat genau eine **Schnittstelle** (die Oberfläche, die es Aufrufern und Tests zeigt).
- **Tiefe** ist eine Eigenschaft eines **Moduls**, gemessen an seiner **Schnittstelle**.
- Eine **Seam** ist der Ort, an dem die **Schnittstelle** eines **Moduls** lebt.
- Ein **Adapter** sitzt an einer **Seam** und erfüllt die **Schnittstelle**.
- **Tiefe** erzeugt **Hebelwirkung** für Aufrufer und **Lokalität** für Maintainer.

## Verworfene Sichtweisen

- **Tiefe als Verhältnis von Implementierungszeilen zu Schnittstellenzeilen** (Ousterhout): belohnt das Aufblähen der Implementierung. Wir verwenden stattdessen Tiefe als Hebelwirkung.
- **„Schnittstelle“ als TypeScript-Schlüsselwort `interface` oder als die öffentlichen Methoden einer Klasse**: zu eng – Schnittstelle meint hier jede Tatsache, die ein Aufrufer kennen muss.
- **„Grenze“ (Boundary)**: überladen durch den Bounded Context aus DDD. Sag **Seam** oder **Schnittstelle**.

## Tiefer einsteigen

- **Einen Cluster unter Berücksichtigung seiner Abhängigkeiten vertiefen** – siehe [DEEPENING.md](DEEPENING.md): Abhängigkeitskategorien, Seam-Disziplin und Testen nach dem Prinzip „ersetzen statt schichten“.
- **Alternative Schnittstellen erkunden** – siehe [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md): parallele Sub-Agents entwerfen die Schnittstelle auf mehrere radikal verschiedene Arten, danach Vergleich nach Tiefe, Lokalität und Lage der Seam.
