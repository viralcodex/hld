# Rubric — Q03 Distributed Rate Limiter

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] Allow/deny decision with **429 + Retry-After**; rate-limit headers mentioned.
- [ ] Per-client and per-endpoint rules supported (config/rules store).

## Dimension 2 — Placement & architecture (2 pts)
- [ ] Limiter sits at the **gateway / middleware / sidecar** in front of API servers — not
      buried in business logic.
- [ ] Clear request flow: request → limiter check → allow (forward) or reject (429).

## Dimension 3 — Algorithm (2 pts)
- [ ] Names a concrete algorithm and justifies it:
      - **Token bucket** — allows bursts up to bucket size, refills at a rate. (Most common.)
      - **Leaky bucket** — smooths to a constant outflow.
      - **Sliding window log/counter** — accurate at edges, more memory/compute.
      - **Fixed window** — simplest, but double-burst at the window boundary (note this flaw).
- [ ] Explains the trade-off it picked (bursts vs smoothness vs edge accuracy vs cost).

## Dimension 4 — Shared state & atomicity — THE KEY INSIGHT (2.5 pts)
- [ ] Counters in a **shared fast store (Redis)** so the limit is global across servers.
- [ ] **Atomic** check-and-update: `INCR`/Lua script/`EXPIRE`, or Redis sorted-sets for a
      sliding window — avoids the race where two servers both read "99" and both allow.
- [ ] Data model: key per `{clientId, window}` (or token bucket state) with a **TTL**.

## Dimension 5 — Latency & availability (1.5 pts)
- [ ] Keeps added latency low: local/in-memory bucket with periodic sync, or Redis in-region.
- [ ] **Failure policy** stated: fail-open (don't block traffic) vs fail-closed (protect
      backend) — with reasoning. Redis replication / HA considered.
- [ ] Clock-skew / window-edge inaccuracy acknowledged as acceptable or mitigated.

## Dimension 6 — Clarity (0.5 pt)
- [ ] The allow/deny decision path and the counter store are clearly drawn.

## Common gaps to call out
- Per-server counters → actual global limit is N × (#servers). The whole point missed.
- Non-atomic read-then-write → races let bursts through.
- No TTL on counters → unbounded memory growth.
- Fixed window without acknowledging the 2× boundary burst.

## Follow-ups to push with
- Two requests for the same key hit two servers at the same millisecond — who wins and how?
- Redis goes down — do you drop the limit or drop the traffic?
- How would you support a sliding window at 1 M rps without exploding memory?
