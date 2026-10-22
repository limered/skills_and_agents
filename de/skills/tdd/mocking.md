# Wann mocken

Mocke nur an **Systemgrenzen**:

- Externe APIs (Zahlung, E-Mail usw.)
- Datenbanken (manchmal – lieber eine Test-DB)
- Zeit/Zufall
- Dateisystem (manchmal)

Nicht mocken:

- Deine eigenen Klassen/Module
- Interne Kollaborateure
- Alles, was du kontrollierst

## Design für Mockbarkeit

Entwirf an Systemgrenzen Schnittstellen, die sich leicht mocken lassen:

**1. Dependency Injection verwenden**

Übergib externe Abhängigkeiten, statt sie intern zu erzeugen:

```typescript
// Leicht zu mocken
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Schwer zu mocken
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. SDK-artige Schnittstellen statt generischer Fetcher bevorzugen**

Leg für jede externe Operation eine eigene Funktion an statt einer generischen Funktion mit Bedingungslogik:

```typescript
// GUT: Jede Funktion ist unabhängig mockbar
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// SCHLECHT: Mocken erfordert Bedingungslogik im Mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

Der SDK-Ansatz bedeutet:
- Jeder Mock liefert genau eine bestimmte Form zurück
- Keine Bedingungslogik im Test-Setup
- Leichter zu sehen, welche Endpunkte ein Test anspricht
- Typsicherheit pro Endpunkt
