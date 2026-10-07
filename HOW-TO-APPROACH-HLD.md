# How to approach any high-level system-design problem

System-design interviews feel open-ended, but strong candidates all follow roughly the
same **repeatable method**. Internalise this and every question in this dojo (and in your
interview) becomes "apply the method", not "stare at a blank canvas".

Aim to spend your ~45 minutes roughly like this:

```text
 5 min  clarify requirements & scope
 5 min  back-of-envelope estimation (scale the design to)
 5 min  define the API and the core data model
15 min  draw the high-level architecture (the happy path end-to-end)
10 min  scale it: find the bottlenecks, add caching / sharding / replication / queues
 5 min  trade-offs, failure modes, and "what I'd do with more time"
```

---

## The 6-step method

### 1. Clarify requirements & scope (don't skip!)

Pin down **what** you're building before **how**. Separate the two kinds of requirement:

- **Functional** — what the system *does*. ("A user shortens a URL and is redirected."
  "A user posts a tweet and followers see it.")
- **Non-functional** — the *qualities* it must have. These drive the architecture:
  - **Scale** — reads/sec, writes/sec, data volume, number of users.
  - **Latency** — "redirect in < 100 ms", "feed loads in < 500 ms".
  - **Availability vs consistency** — can it ever show stale data? (CAP, below.)
  - **Durability** — can we ever lose a write?
  - **Read:write ratio** — a URL shortener is ~100:1 read-heavy; a logging system is
    write-heavy. This single ratio shapes everything downstream.

Then state what's **out of scope** so you don't boil the ocean. In this dojo, `PROMPT.md`
has done the clarifying for you — read it the way you'd *interview* the interviewer, and
note the constraints that drive the design.

### 2. Back-of-the-envelope estimation

Turn the scale into numbers you'll design against. You don't need precision — you need the
**order of magnitude** that tells you whether one box suffices or you need a fleet.

- **QPS:** `daily requests / 86,400`. Then peak ≈ 2–3× average.
- **Storage:** `objects/day × bytes/object × retention`.
- **Bandwidth:** `QPS × bytes/response`.
- **Memory for cache:** apply the 80/20 rule — cache the hot 20% of daily reads.

A worked example (URL shortener): 100 M new URLs/day → ~1,160 writes/sec. At 100:1 reads,
~116 K reads/sec. 100 M/day × 500 bytes × 5 years ≈ ~90 TB. Those numbers immediately tell
you: you need sharding and an aggressive read cache / CDN.

### 3. Define the API and the core data model

- **API:** the handful of endpoints the outside world calls. `POST /urls {longUrl} → {shortUrl}`,
  `GET /{shortCode} → 302`. Nail inputs, outputs, and what each returns on misuse. The API
  is the contract; everything behind it serves it.
- **Data model:** the key entities, their fields, and relationships. Decide the **access
  patterns first**, then pick storage to match them. "Look up by short code" → a key-value
  store. "Query a user's followers" → an index or a graph-ish store.

### 4. Draw the high-level architecture (happy path first)

Lay down the end-to-end flow for the main use case, left to right:

```text
Client → DNS → CDN → Load Balancer → API Gateway → Service(s) → Cache → Database
                                                        ↓
                                                   Message Queue → Workers
```

Only draw the boxes a request actually touches for the **core** use case. Resist adding
Kafka and Redis before you've shown the simple path working. Label every arrow with *what
flows* (a request, an event, a replication stream).

### 5. Scale it — find the bottleneck, then relieve it

Walk the happy path and ask "what breaks first as traffic grows?" Then reach for the right
tool. The standard scaling toolkit:

| Pressure | Tool | What it buys you |
|----------|------|------------------|
| Too many requests to one server | **Horizontal scaling** + **load balancer** | Spread load across a stateless fleet |
| Reads dominate | **Caching** (Redis/Memcached), **CDN** for static/media | Serve hot data from memory / the edge |
| One DB can't hold the data | **Sharding / partitioning** | Split data by key across nodes |
| One DB can't serve the reads | **Replication** (leader/follower) | Scale reads; survive node loss |
| Slow or spiky work | **Message queue** (Kafka/SQS) + async **workers** | Decouple, buffer, smooth spikes, retry |
| Expensive relationships / search | **Specialised store** (search index, graph, time-series) | Right tool for the access pattern |

Make the services **stateless** so you can scale them horizontally; push state into the
data tier where you can replicate and shard it deliberately.

### 6. Trade-offs, failure modes & bottlenecks

This is what separates a senior answer. Call out:

- **The CAP choice per data store.** Orders/payments → favour **consistency** (a SQL DB,
  quorum writes). Feeds/likes/analytics → favour **availability** (eventual consistency is
  fine; a stale like-count hurts no one).
- **Single points of failure** — and how you remove them (multi-AZ, replicas, failover).
- **Hot keys / celebrity problem** — one Justin-Bieber account breaks naive fanout.
- **Back-pressure & retries** — queues, idempotency keys, dead-letter queues.
- **What you'd do with more time** — monitoring, rate limiting, multi-region, cost.

---

## The vocabulary you must be fluent in

Keep `GLOSSARY.md` open. The terms that come up in almost every question:

- **Load balancer** — spreads requests across servers (L4 vs L7, round-robin vs least-conn).
- **Horizontal vs vertical scaling** — more boxes vs a bigger box.
- **Caching** — write-through / write-back / cache-aside; TTL and eviction (LRU).
- **CDN** — cache static assets & media at the edge, near users.
- **Sharding / partitioning** — split data by a key (hash vs range); watch for hot shards.
- **Replication** — leader/follower; sync vs async; read replicas.
- **CAP theorem** — under a network partition you choose Consistency *or* Availability.
- **Consistency models** — strong, eventual, read-your-writes.
- **SQL vs NoSQL** — ACID & joins vs horizontal scale & flexible schema; pick per access pattern.
- **Message queue / pub-sub** — async decoupling, buffering, fan-out of events.
- **Consistent hashing** — add/remove nodes without reshuffling every key.
- **Quorum (W + R > N)** — tune read/write overlap for consistency vs availability.
- **Rate limiting** — token bucket / leaky bucket to protect the system.
- **Idempotency** — the same request applied twice has the same effect (safe retries).

---

## A mental checklist before you say "done"

- [ ] Does every **functional requirement** have a path through my diagram?
- [ ] Did I size the design to the **non-functional** numbers (QPS, storage, latency)?
- [ ] Is there a **single point of failure** I haven't removed?
- [ ] For each **data store**, did I justify SQL vs NoSQL and the **consistency** choice?
- [ ] How do I handle the **hot key / celebrity / thundering-herd** case?
- [ ] Where does it **break at 10×** the stated scale, and what's my next move?
- [ ] Did I write the **trade-offs** on the canvas, not just the boxes?

Now open `ROADMAP.md` and start at question 01.
