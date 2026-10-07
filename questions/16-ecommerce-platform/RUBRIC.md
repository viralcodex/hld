# Rubric — Q16 E-commerce Platform (Capstone)

Grade out of 10. PASS = 7+. This is the capstone — judge **both** breadth (subsystems hang
together) **and** the hard core (consistent, failure-aware checkout).

## Dimension 1 — Requirements coverage & decomposition (2 pts)
- [ ] Catalog/search, cart, checkout, inventory, orders, notifications all present as
      distinct services with clear responsibilities (microservice-style decomposition).
- [ ] Every functional requirement has a path; nothing major missing.

## Dimension 2 — Storefront architecture & read scaling (1.5 pts)
- [ ] Browse/search is **read-heavy** → **search index** + **cache/CDN**; stays available
      independent of checkout.
- [ ] Catalog on a store suited to flexible reads; eventual consistency accepted here.

## Dimension 3 — Checkout core: inventory + payment — THE KEY INSIGHT (3 pts)
- [ ] **Inventory reservation is strongly consistent** — lock / conditional (CAS) update /
      hold-with-TTL so the system **never oversells** (reuse Q13). CAP call stated.
- [ ] **Payment is idempotent** — idempotency key so retries/duplicate webhooks don't
      double-charge or double-create orders.
- [ ] Order is created **only after** inventory reserved **and** payment confirmed.
- [ ] Inventory/orders/payments on an **ACID / strongly-consistent** store, explicitly chosen.

## Dimension 4 — Distributed transaction / saga (1.5 pts)
- [ ] Recognises checkout spans services → uses a **saga / orchestrated workflow** with
      **compensating actions** (payment fails → release reserved inventory; fulfillment
      fails → refund) rather than a naive multi-service 2PC or no coordination at all.
- [ ] Failure at each step has a defined compensation.

## Dimension 5 — Async events, scale & trade-offs (1.5 pts)
- [ ] A **message bus/queue** decouples checkout from notifications/fulfillment/analytics
      (reuse Q07); events drive downstream work.
- [ ] **Flash-sale** handling for hot items (waiting room/queue, hot-key mitigation).
- [ ] **Per-subsystem store + consistency choice** written down (SQL for money/inventory/
      orders; NoSQL/search/cache for catalog/cart). SPOFs addressed; estimates present.

## Dimension 6 — Clarity & coherence (0.5 pt)
- [ ] A reader can follow the end-to-end order flow and see how subsystems connect; the
      consistency choices are labelled on the canvas.

## Common gaps to call out
- Overselling: inventory decremented without a lock/transaction/conditional update.
- Double-charge: no idempotency on payment or order creation.
- Treating the whole thing as one monolith DB (no per-subsystem consistency reasoning).
- No saga/compensation → money taken but no stock, or stock held but no order.
- Checkout coupled to catalog so a search outage blocks buying (or vice-versa).
- Ignoring flash-sale hot-key contention on a single popular SKU.

## Follow-ups to push with
- 10,000 people buy the last 100 units of a flash-sale item in one second — how do you sell
  exactly 100 and no more?
- Payment succeeds but order creation crashes right after — what's the user's money state?
- The payment gateway retries its success webhook 3 times — how many orders/charges result?
- Search is down — can customers still check out? Should they be able to?

## Verdict guidance
- A capstone **PASS (7+)** needs: coherent service decomposition **and** a correct,
  failure-aware checkout core (strong inventory consistency + idempotent payment + saga).
- **9–10**: all of the above plus flash-sale handling, labelled consistency choices across
  subsystems, and removed SPOFs — a design you could hand to a team.
