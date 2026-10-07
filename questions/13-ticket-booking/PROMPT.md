# Q13 · Ticket Booking

**Topic:** Inventory concurrency · holds/locks · no double-booking · ACID
**Tier:** 4 — Real-time, geo & transactions
**Difficulty:** Hard

---

## The brief

Design a ticket-booking system like **BookMyShow / Ticketmaster**. Users browse events,
pick specific seats, and pay. The defining constraint: a seat can be sold to **exactly one**
person, even when thousands rush the same popular show at the same second.

This is the **correctness-under-concurrency + transactions** question. Scale matters, but
getting *consistency* right — no double-selling, no lost money — is the whole game.

### Functional requirements

- Browse events/shows and see **seat availability**.
- **Select & hold** specific seats while the user pays (temporary reservation).
- **Pay** → confirm booking; release the hold if payment fails or times out.
- Prevent **double-booking** of any seat under heavy concurrency.

### Non-functional requirements

- **Strong consistency** on seat inventory — never sell a seat twice.
- Handle **flash-crowd** spikes (a hot concert on sale at 10:00:00).
- Available and responsive while holding the correctness line.
- Payments are external and may be slow/fail.

### Scale to design for

- Millions browsing; a hot show draws **100k+** users racing for seats in seconds.
- Reads (availability) ≫ writes (bookings), but writes are contended and critical.

---

## What your diagram must show

1. The **seat-hold mechanism**: how a user temporarily reserves seats with a **TTL**, and
   how the hold is released on timeout/failure (and the store behind it).
2. The **concurrency control** that guarantees one-seat-one-buyer: DB transaction with row
   locking / `SELECT ... FOR UPDATE`, conditional/optimistic update, or an atomic
   reservation in a strongly-consistent store — pick one and justify.
3. The **payment flow**: hold → pay (external) → confirm or release; handling slow/failed
   payment and ensuring **idempotency**.
4. **Data model & store**: events, seats/inventory, holds, bookings — and why inventory
   lives in an **ACID / strongly-consistent** store.
5. How you absorb the **flash crowd** (queue/waiting room, caching read-only availability).
6. Trade-off notes: consistency over availability for inventory; eventual consistency fine
   for browse.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q13"**.
