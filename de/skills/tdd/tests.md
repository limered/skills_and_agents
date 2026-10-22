# Gute und schlechte Tests

## Gute Tests

**Integrationsartig**: Teste über echte Schnittstellen, nicht über Mocks interner Teile.

```typescript
// GUT: Testet beobachtbares Verhalten
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Merkmale:

- Testet Verhalten, das User bzw. Aufrufer interessiert
- Verwendet nur die öffentliche API
- Übersteht interne Refactorings
- Beschreibt das WAS, nicht das WIE
- Eine logische Assertion pro Test

## Schlechte Tests

**Tests von Implementierungsdetails**: An die interne Struktur gekoppelt.

```typescript
// SCHLECHT: Testet Implementierungsdetails
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Warnsignale:

- Mocken interner Kollaborateure
- Testen privater Methoden
- Assertions auf Anzahl oder Reihenfolge von Aufrufen
- Test bricht beim Refactoring ohne Verhaltensänderung
- Testname beschreibt das WIE statt das WAS
- Verifikation auf externem Weg statt über die Schnittstelle

```typescript
// SCHLECHT: Umgeht die Schnittstelle zur Verifikation
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GUT: Verifiziert über die Schnittstelle
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**Tautologische Tests**: Der erwartete Wert wiederholt die Implementierung, sodass der Test per Konstruktion besteht.

```typescript
// SCHLECHT: Der erwartete Wert wird so berechnet, wie der Code ihn berechnet
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// GUT: Der erwartete Wert ist ein unabhängiges, bekanntes Literal
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
