# Design It Twice

Wenn der User für einen gewählten Vertiefungskandidaten alternative Schnittstellen erkunden will, nutze dieses Muster mit parallelen Sub-Agents. Basiert auf „Design It Twice“ (Ousterhout) – deine erste Idee ist wahrscheinlich nicht die beste.

Verwendet das Vokabular aus [SKILL.md](SKILL.md) – **Modul**, **Schnittstelle**, **Seam**, **Adapter**, **Hebelwirkung**.

## Ablauf

### 1. Den Problemraum abstecken

Bevor du Sub-Agents startest, schreib für den User eine Erklärung des Problemraums für den gewählten Kandidaten:

- Die Rahmenbedingungen, die jede neue Schnittstelle erfüllen müsste
- Die Abhängigkeiten, auf die sie sich stützen würde, und zu welcher Kategorie sie gehören (siehe [DEEPENING.md](DEEPENING.md))
- Eine grobe, illustrative Code-Skizze, um die Rahmenbedingungen greifbar zu machen – kein Vorschlag, nur eine Konkretisierung

Zeig das dem User und fahr sofort mit Schritt 2 fort. Der User liest und denkt nach, während die Sub-Agents parallel arbeiten.

### 2. Sub-Agents starten

Starte 3+ Sub-Agents parallel. Jeder muss eine **radikal andere** Schnittstelle für das vertiefte Modul liefern.

Gib jedem Sub-Agent ein eigenes technisches Briefing (Dateipfade, Details zur Kopplung, Abhängigkeitskategorie aus [DEEPENING.md](DEEPENING.md), was hinter der Seam liegt). Das Briefing ist unabhängig von der Erklärung des Problemraums für den User aus Schritt 1. Gib jedem Agent eine andere Design-Vorgabe:

- Agent 1: „Minimiere die Schnittstelle – höchstens 1–3 Einstiegspunkte. Maximiere die Hebelwirkung pro Einstiegspunkt.“
- Agent 2: „Maximiere die Flexibilität – unterstütze viele Anwendungsfälle und Erweiterungen.“
- Agent 3: „Optimiere für den häufigsten Aufrufer – mach den Standardfall trivial.“
- Agent 4 (falls sinnvoll): „Entwirf rund um Ports & Adapters für Abhängigkeiten über Seams hinweg.“

Nimm sowohl das Vokabular aus [SKILL.md](SKILL.md) als auch das aus CONTEXT.md ins Briefing auf, damit jeder Sub-Agent Dinge konsistent mit der Architektursprache und der Domänensprache des Projekts benennt.

Jeder Sub-Agent liefert:

1. Schnittstelle (Typen, Methoden, Parameter – plus Invarianten, Reihenfolge, Fehlermodi)
2. Ein Nutzungsbeispiel, das zeigt, wie Aufrufer sie verwenden
3. Was die Implementierung hinter der Seam verbirgt
4. Abhängigkeitsstrategie und Adapter (siehe [DEEPENING.md](DEEPENING.md))
5. Trade-offs – wo die Hebelwirkung hoch ist, wo sie dünn ist

### 3. Präsentieren und vergleichen

Präsentiere die Entwürfe nacheinander, damit der User jeden einzeln aufnehmen kann, und vergleiche sie dann in Prosa. Stell sie nach **Tiefe** (Hebelwirkung an der Schnittstelle), **Lokalität** (wo sich Änderungen bündeln) und **Lage der Seam** gegenüber.

Gib nach dem Vergleich deine eigene Empfehlung ab: welchen Entwurf du für den stärksten hältst und warum. Lassen sich Elemente verschiedener Entwürfe gut kombinieren, schlag einen Hybrid vor. Sei meinungsstark – der User will eine klare Einschätzung, keine Speisekarte.
