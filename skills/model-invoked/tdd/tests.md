# Good and Bad Tests

Use the undefined check on every test below: if it would still pass when every imported function returned `undefined`, rewrite it or delete it.

## Good Tests

**Integration-style**: Test through real interfaces, not mocks of internal parts.

```typescript
// GOOD: Tests observable behavior
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Characteristics:

- Tests behavior users/callers care about
- Uses public API only
- Survives internal refactors
- Describes WHAT, not HOW
- One logical assertion per test

## Bad Tests

### 1. Weak assertion

```typescript
// BAD: Passes for almost any return value
test("checkout works", async () => {
  const result = await checkout(cart, payment);
  expect(result).toBeDefined();
});

// GOOD: Asserts the literal outcome the caller observes
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add({ price: 10 });
  const result = await checkout(cart, validPayment);
  expect(result.status).toBe("confirmed");
});
```

### 2. Mock-only assertion

```typescript
// BAD: Asserts the call happened, not the effect
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});

// GOOD: Asserts payload received and state after the call
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add({ price: 10 });
  const charges: number[] = [];
  const fakePayment = { charge: async (n: number) => { charges.push(n); return "ok"; } };
  const result = await checkout(cart, fakePayment);
  expect(result.status).toBe("confirmed");
  expect(charges).toEqual([10]);
});
```

Red flags:

- Mocking internal collaborators
- Testing private methods
- Asserting on call counts/order
- Test breaks when refactoring without behavior change
- Test name describes HOW not WHAT

### 3. Bypasses the interface

```typescript
// BAD: Bypasses interface to verify
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD: Verifies through interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

### 4. Tautological (self-referential)

Expected value restates the implementation, so the test passes by construction.

```typescript
// BAD: Expected value is recomputed the way the code computes it
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// GOOD: Expected value is an independent, known literal
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```

### 5. Constant pin

The assertion restates a hand-maintained constant, config default, table row, or prompt string. It blocks legitimate edits and catches no defect.

```typescript
// BAD: Restates the constant
test("limits config", () => {
  expect(LIMITS.maxTools).toBe(8);
});

// GOOD: Tests the mechanism that reads the constant
test("tool runner respects maxTools", async () => {
  const result = await runTools(fakeTools(10), { maxTools: 2 });
  expect(result.executed).toHaveLength(2);
});
```

Keep only relation checks across a table's rows and compile-time checks in `*.test-d.ts` files.

### 6. Fixture asserts fixture

The assertion reads data the test built, and the subject never runs in the body.

```typescript
// BAD: Subject never runs
describe("createUser", () => {
  let seed;
  beforeEach(() => { seed = { name: "Alice" }; });
  test("creates user", async () => {
    expect(seed.name).toBe("Alice");
  });
});

// GOOD: Subject runs in the body with one concrete input
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```
