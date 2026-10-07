# Rubric — Q13 Ticket Booking

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] Browse/availability, select+hold, pay+confirm, release-on-failure all have paths.

## Dimension 2 — No double-booking — THE KEY INSIGHT (3 pts)
- [ ] A real concurrency-control mechanism, named and justified:
      - **DB transaction + pessimistic lock** (`SELECT ... FOR UPDATE` on seat rows), or
      - **Optimistic / conditional update** (compare-and-set on seat status/version), or
      - **Atomic reservation** in a strongly-consistent store.
- [ ] Explains the race it prevents (two buyers, same seat, same instant → exactly one wins).
- [ ] Inventory lives in an **ACID / strongly-consistent** store — consistency chosen over
      availability for this data (CAP call made explicitly).

## Dimension 3 — Hold / reservation with TTL (2 pts)
- [ ] Seats move to a **temporary HELD state with a TTL** during checkout.
- [ ] Hold **auto-releases** on timeout/payment failure (expiry job / TTL / lazy release).
- [ ] Prevents others from grabbing held seats while respecting that holds expire.

## Dimension 4 — Payment flow & idempotency (1.5 pts)
- [ ] hold → external payment → confirm (seat SOLD) or release; slow/failed payment handled.
- [ ] **Idempotency key** so a retried/duplicate payment callback doesn't double-charge or
      double-book.

## Dimension 5 — Flash crowd, data model & trade-offs (1.5 pts)
- [ ] Absorbs spikes: **virtual waiting room / queue**, cached read-only availability so
      browse traffic doesn't contend with the inventory writes.
- [ ] Browse = eventually consistent/cached; inventory = strongly consistent — distinction made.
- [ ] Estimates / hot-show reasoning present.

## Dimension 6 — Clarity (0.5 pt)
- [ ] Hold→pay→confirm/release state flow is clearly drawn.

## Common gaps to call out
- "Check availability then insert booking" with no lock/transaction → classic double-sell.
- No TTL on holds → seats stuck "held" forever by abandoned carts.
- Using an eventually-consistent store for inventory.
- No idempotency on payment callbacks → double charges/bookings on retry.
- Letting 100k browsers hammer the inventory rows directly.

## Follow-ups to push with
- Two users click the last seat at the same millisecond — walk me through who wins and how.
- A user holds a seat then closes the tab — when and how is it freed?
- The payment gateway sends the success webhook twice — what stops a double booking?
