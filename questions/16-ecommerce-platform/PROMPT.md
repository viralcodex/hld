# Q16 · E-commerce Platform — CAPSTONE

**Topic:** Composing subsystems · inventory & payment consistency · order saga
**Tier:** Capstone
**Difficulty:** Hard

---

## The brief

Design a complete e-commerce platform like **Amazon**. This is the capstone: it isn't one
trick — it's **composing many of the subsystems you've already designed** into one coherent,
failure-aware system. A shopper browses and searches a huge catalog, adds items to a cart,
checks out, pays, and gets an order that's fulfilled and tracked — and the business must
**never oversell inventory or lose/duplicate a payment**.

Treat this like a 45–60 minute interview. Breadth *and* the one hard core (consistent
checkout) both matter.

### Functional requirements

- **Browse & search** the product catalog (categories, filters, product pages).
- **Cart**: add/remove items; cart persists across sessions/devices.
- **Checkout**: reserve inventory → take payment → create order.
- **Inventory** management: never sell more than are in stock.
- **Order** lifecycle: placed → paid → packed → shipped → delivered; order history.
- **Notifications** (order confirmed/shipped) — reuse Q07 thinking.

### Non-functional requirements

- **Strong consistency** for inventory and payments (no overselling, no double-charge).
- **Eventual consistency** acceptable for catalog, search, reviews, recommendations.
- **Highly available** browse/search (the storefront must never go down).
- **Scalable** to huge catalogs and flash sales (Prime Day / Black Friday).

### Scale to design for

- **100 M+** products; hundreds of millions of users.
- **Billions** of browse/search requests/day; millions of orders/day.
- Flash sales: enormous spikes on a few hot items.

---

## What your diagram must show

This is a **systems-of-systems** diagram. Show the major services and how they interact —
don't fully re-derive every sub-service, but make each one's role and store clear.

1. **Catalog & search**: product service + a **search index** (reuse Q15/Q12 ideas), served
   read-heavy via **cache/CDN**; eventual consistency is fine here.
2. **Cart service** and where carts are stored (fast, available).
3. **Checkout orchestration** — the hard core:
   - **Inventory reservation** with **strong consistency** (reuse Q13: lock/conditional
     update / hold with TTL so you never oversell).
   - **Payment** via an external gateway, with **idempotency** (no double-charge on retry).
   - **Order creation** only after inventory + payment succeed.
   - A **saga / orchestrated workflow** with **compensating actions** (release inventory if
     payment fails; refund if fulfillment fails) — because this spans multiple services.
4. **Order service** + order history store (strongly consistent).
5. **Async events**: a message bus connecting checkout → notifications, fulfillment,
   analytics (reuse Q07). 
6. **Data-store choices per subsystem** with the **consistency call** written next to each
   (SQL/ACID for orders, inventory, payments; NoSQL/search/cache for catalog, cart, feed).
7. **Flash-sale** handling for hot items (queue/waiting room, hot-key mitigation).
8. The **trade-offs**: where you chose consistency vs availability, SPOFs removed, failure
   paths.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q16"**.

> This is the graduation piece. Take your time, label generously, and write your
> consistency choices right on the canvas — that's what I grade hardest here.
