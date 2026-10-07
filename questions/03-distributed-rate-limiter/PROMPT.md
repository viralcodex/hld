# Q03 · Distributed Rate Limiter

**Topic:** Token/leaky bucket · Redis counters · placement
**Tier:** 1 — Fundamentals & building blocks
**Difficulty:** Medium

---

## The brief

Design a **distributed rate limiter** that protects an API: "allow at most **N requests per
window** per client". It sits in front of a fleet of API servers, so the limit must be
enforced **globally**, not per-server.

This is the guard every large system needs. The hard part is making it correct and fast
when the counters are shared across many machines.

### Functional requirements

- Enforce a limit like **100 requests / minute / API key** (configurable per client/plan).
- On exceeding the limit, reject with **HTTP 429** and a `Retry-After` header.
- Return rate-limit headers (`X-RateLimit-Remaining`, `-Reset`).
- Support **different rules** per endpoint and per client tier (free vs paid).

### Non-functional requirements

- **Low latency:** the limiter adds **< 5 ms** to each request.
- **Highly available:** if the limiter has a hiccup, decide fail-open vs fail-closed.
- **Accurate enough:** small over/under-count at window edges is acceptable; large leaks
  are not.
- Works across **many API servers** in multiple regions.

### Scale to design for

- **1 M** requests/sec across the fleet.
- Millions of distinct API keys.

---

## What your diagram must show

1. **Where** the limiter runs: API gateway / middleware / sidecar — and why there.
2. The **algorithm**: token bucket, leaky bucket, fixed window, or sliding window — pick one
   and justify it (bursts vs smoothness vs edge accuracy).
3. The **shared counter store** (e.g. Redis) and how a check-and-decrement stays **atomic**
   across concurrent requests from many servers.
4. The **data model** for a client's counter/bucket and its TTL.
5. How you keep it **fast** (local pre-check, in-memory cache) and **available** (what
   happens if Redis is down — fail-open or fail-closed, and why).
6. How rules differ **per client/endpoint**.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q3"**.
