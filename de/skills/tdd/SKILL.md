---
name: tdd
description: "Testgetriebene Entwicklung (TDD). Verwenden, wenn der User Features oder Bugfixes test-first bauen will, „red-green-refactor“ bzw. Rot-Grün erwähnt oder Integrationstests möchte."
metadata:
  uses: "code-review, codebase-design"
  requires: "code-review, codebase-design"
---

# Testgetriebene Entwicklung

TDD ist die Rot → Grün-Schleife. Dieser Skill ist die Referenz, die dafür sorgt, dass diese Schleife Tests hervorbringt, die es wert sind, behalten zu werden: was ein guter Test ist, wo Tests hingehören, die Anti-Patterns und die Regeln der Schleife. Jeder Abschnitt gilt in jedem Zyklus – zieh sie vor und während der Schleife heran, nicht danach.

Lies beim Erkunden der Codebasis die `CONTEXT.md` (falls vorhanden), damit Testnamen und Schnittstellenvokabular zur Domänensprache des Projekts passen, und beachte ADRs in dem Bereich, den du berührst.

## Was ein guter Test ist

Tests prüfen Verhalten über öffentliche Schnittstellen, nicht Implementierungsdetails. Der Code kann sich komplett ändern; die Tests sollten es nicht. Ein guter Test liest sich wie eine Spezifikation – „user can checkout with valid cart“ sagt dir genau, welche Fähigkeit existiert – und übersteht Refactorings, weil ihm die interne Struktur egal ist.

Siehe [tests.md](tests.md) für Beispiele und [mocking.md](mocking.md) für Richtlinien zum Mocken.

## Seams – wo Tests hingehören

Eine **Seam** ist die öffentliche Grenze, an der du testest: die Schnittstelle, an der du Verhalten beobachtest, ohne hineinzugreifen. Tests leben an Seams, nie an Interna.

**Teste nur an vorab vereinbarten Seams.** Schreib vor jedem Test die Seams auf, die getestet werden sollen, und lass sie dir vom User bestätigen. An einer unbestätigten Seam wird kein Test geschrieben. Du kannst nicht alles testen – die Seams vorab zu vereinbaren sorgt dafür, dass der Testaufwand auf die kritischen Pfade und die komplexe Logik fällt statt auf jeden Grenzfall.

Frag: „Was ist die öffentliche Schnittstelle, und welche Seams sollen wir testen?“

Steht die Form dieser Schnittstelle selbst in Frage – wie tief das Modul ist, wo die Seam hingehört, was die Schnittstelle offenlegen soll –, nutze den Skill `/codebase-design` für das Vokabular. Er ist die gemeinsame Quelle für die Begriffe Modul, Schnittstelle, Tiefe, Seam, Adapter, Hebelwirkung und Lokalität, und er ist eine Referenz zum Nachschlagen, keine Sitzung, die man durchführt.

## Anti-Patterns

- **Implementierungsgekoppelt** – mockt interne Kollaborateure, testet private Methoden oder verifiziert über einen Seitenkanal (die Datenbank abfragen statt die Schnittstelle zu nutzen). Das Erkennungszeichen: Der Test bricht beim Refactoring, obwohl sich das Verhalten nicht geändert hat.
- **Tautologisch** – die Assertion berechnet den erwarteten Wert so, wie es der Code tut (`expect(add(a, b)).toBe(a + b)`, ein von Hand auf dieselbe Weise hergeleiteter Snapshot, eine Konstante, die mit sich selbst verglichen wird), sodass der Test per Konstruktion besteht und dem Code nie widersprechen kann. Erwartete Werte müssen aus einer unabhängigen Quelle der Wahrheit stammen – einem bekannt korrekten Literal, einem durchgerechneten Beispiel, der Spec.
- **Horizontales Schneiden** – erst alle Tests schreiben, dann die gesamte Implementierung. Massenhaft vorab geschriebene Tests prüfen _eingebildetes_ Verhalten: Du testest die _Form_ der Dinge statt des Verhaltens, das User sehen, die Tests werden unempfindlich gegenüber echten Änderungen, und du legst dich auf eine Teststruktur fest, bevor du die Implementierung verstehst. Arbeite stattdessen in **vertikalen Schnitten** – ein Test → eine Implementierung → wiederholen, jeder Test ein **Tracer Bullet**, das auf das reagiert, was dich der letzte Zyklus gelehrt hat.

## Regeln der Schleife

- **Rot vor Grün.** Schreib zuerst den fehlschlagenden Test, dann nur so viel Code, dass er besteht. Nimm keine künftigen Tests vorweg und füg keine spekulativen Features hinzu.
- **Ein Schnitt nach dem anderen.** Eine Seam, ein Test, eine minimale Implementierung pro Zyklus.
- **Refactoring ist nicht Teil der Schleife.** Es gehört in die Review-Phase (siehe Skill `code-review`), nicht in den Rot → Grün-Implementierungszyklus.
