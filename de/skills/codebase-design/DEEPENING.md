# Vertiefen

Wie man einen Cluster flacher Module unter Berücksichtigung seiner Abhängigkeiten sicher vertieft. Setzt das Vokabular aus [SKILL.md](SKILL.md) voraus – **Modul**, **Schnittstelle**, **Seam**, **Adapter**.

## Abhängigkeitskategorien

Wenn du einen Kandidaten fürs Vertiefen bewertest, klassifiziere seine Abhängigkeiten. Die Kategorie bestimmt, wie das vertiefte Modul über seine Seam hinweg getestet wird.

### 1. In-Process

Reine Berechnung, In-Memory-Zustand, kein I/O. Immer vertiefbar – führe die Module zusammen und teste direkt über die neue Schnittstelle. Kein Adapter nötig.

### 2. Lokal ersetzbar

Abhängigkeiten mit lokalen Test-Stellvertretern (PGLite für Postgres, In-Memory-Dateisystem). Vertiefbar, wenn der Stellvertreter existiert. Das vertiefte Modul wird mit dem Stellvertreter in der Test-Suite getestet. Die Seam ist intern; kein Port an der externen Schnittstelle des Moduls.

### 3. Remote, aber im eigenen Besitz (Ports & Adapters)

Eigene Services über eine Netzwerkgrenze hinweg (Microservices, interne APIs). Definiere einen **Port** (Schnittstelle) an der Seam. Das tiefe Modul besitzt die Logik; der Transport wird als **Adapter** injiziert. Tests verwenden einen In-Memory-Adapter. Produktion verwendet einen HTTP-/gRPC-/Queue-Adapter.

Form der Empfehlung: *„Definiere einen Port an der Seam, implementiere einen HTTP-Adapter für die Produktion und einen In-Memory-Adapter für Tests, damit die Logik in einem tiefen Modul sitzt, obwohl sie über ein Netzwerk verteilt deployt wird.“*

### 4. Echt extern (Mock)

Drittanbieter-Services (Stripe, Twilio usw.), die du nicht kontrollierst. Das vertiefte Modul nimmt die externe Abhängigkeit als injizierten Port entgegen; Tests liefern einen Mock-Adapter.

## Seam-Disziplin

- **Ein Adapter bedeutet eine hypothetische Seam. Zwei Adapter bedeuten eine echte.** Führ keinen Port ein, solange nicht mindestens zwei Adapter gerechtfertigt sind (typischerweise Produktion + Test). Eine Seam mit nur einem Adapter ist bloße Indirektion.
- **Interne vs. externe Seams.** Ein tiefes Modul kann interne Seams haben (privat für seine Implementierung, von seinen eigenen Tests genutzt) sowie die externe Seam an seiner Schnittstelle. Leg interne Seams nicht über die Schnittstelle offen, nur weil Tests sie nutzen.

## Teststrategie: ersetzen, nicht schichten

- Alte Unit-Tests auf flachen Modulen werden zu Ballast, sobald Tests an der Schnittstelle des vertieften Moduls existieren – lösch sie.
- Schreib neue Tests an der Schnittstelle des vertieften Moduls. Die **Schnittstelle ist die Testoberfläche**.
- Tests prüfen beobachtbare Ergebnisse über die Schnittstelle, nicht internen Zustand.
- Tests sollen interne Refactorings überleben – sie beschreiben Verhalten, nicht Implementierung. Muss ein Test geändert werden, wenn sich die Implementierung ändert, testet er hinter die Schnittstelle.
