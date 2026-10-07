# Glossary — the system-design vocabulary

The terms that show up across the questions. Skim it once; refer back when a `PROMPT.md`
or my feedback uses a word you want to pin down. Fluency in this vocabulary is half the
battle in an interview — using the right word signals you know the concept.

## Scaling & traffic

- **Vertical scaling** — a bigger machine (more CPU/RAM). Simple, but a hard ceiling and a
  single point of failure.
- **Horizontal scaling** — more machines behind a load balancer. The default answer for
  web-scale. Requires **stateless** services.
- **Load balancer (LB)** — distributes requests across servers. *L4* routes on TCP/IP;
  *L7* routes on HTTP (path, headers). Strategies: round-robin, least-connections, hashing.
- **Stateless service** — holds no per-client state between requests, so any instance can
  serve any request → trivially horizontally scalable. Push state to the data tier.
- **Reverse proxy / API gateway** — the front door: TLS termination, routing, auth, rate
  limiting, request aggregation.

## Caching & the edge

- **Cache** — fast (usually in-memory) store for hot data to cut DB load and latency.
- **Cache-aside (lazy)** — app checks cache, on miss reads DB and populates the cache.
- **Write-through** — writes go to cache *and* DB synchronously (fresh, slower writes).
- **Write-back / write-behind** — write to cache now, flush to DB later (fast, risky).
- **Eviction** — what to drop when full: **LRU** (least-recently-used) is the common pick.
- **TTL** — time-to-live; entries expire automatically.
- **Thundering herd / cache stampede** — a hot key expires and thousands of requests hit
  the DB at once. Mitigate with locks, request coalescing, or staggered TTLs.
- **CDN (Content Delivery Network)** — caches static assets & media at edge POPs close to
  users; the first tool for read-heavy media.

## Data & storage

- **SQL (relational)** — ACID, joins, strong consistency, flexible queries. Scales up well,
  out with effort. Use for money, inventory, orders — anything needing transactions.
- **NoSQL** — a family: **key-value** (Redis, DynamoDB), **document** (MongoDB), **wide-column**
  (Cassandra, HBase), **graph** (Neo4j). Horizontal scale & flexible schema; limited joins.
- **Object/blob storage** — S3/GCS for large immutable files (images, video, backups).
  Cheap, durable, served via CDN. Store the *bytes* here, the *metadata* in a DB.
- **Sharding / partitioning** — split one dataset across nodes by a **shard key**.
  *Hash* sharding spreads evenly; *range* sharding keeps order but risks hot ranges.
- **Hot shard / hot key** — one partition gets disproportionate traffic (a celebrity, a
  viral item). Mitigate by salting keys, dedicated handling, or extra replicas.
- **Replication** — copies of data on multiple nodes. **Leader/follower** (writes to leader,
  reads from followers). *Synchronous* = consistent but slower; *asynchronous* = fast but
  can lose recent writes / read stale.
- **Index** — a secondary structure for fast lookup by non-primary fields. Costs write time
  and space.
- **Write-ahead log (WAL) / commit log** — append-only durability record; also the backbone
  of replication and event streaming.

## Distributed-systems theory

- **CAP theorem** — under a network **P**artition you must choose **C**onsistency or
  **A**vailability. Not a free choice the rest of the time, but the headline trade-off.
- **PACELC** — the fuller picture: if **P**artitioned, choose **A**/**C**; **E**lse, choose
  **L**atency/**C**onsistency.
- **Consistency models** — **strong** (every read sees the latest write), **eventual**
  (replicas converge over time), **read-your-writes** (you always see your own updates).
- **Quorum** — with **N** replicas, require **W** acks on write and **R** on read. If
  **W + R > N**, reads and writes overlap → stronger consistency. Tune for the trade-off.
- **Consistent hashing** — maps keys and nodes onto a ring so adding/removing a node moves
  only a small fraction of keys. The basis of distributed caches and KV stores.
- **Idempotency** — applying the same operation twice has the same effect as once. Enables
  **safe retries** (critical for payments, at-least-once queues). Often via an idempotency key.
- **Two-phase commit (2PC)** — a blocking protocol for atomic commit across nodes; strong
  but slow and fragile. Often avoided in favour of sagas.
- **Saga** — a long-running transaction as a sequence of local steps, each with a
  **compensating** action to undo it on failure. The usual pattern for cross-service
  consistency (e.g. place order → charge → reserve stock → ship).

## Async & messaging

- **Message queue** — buffers work between producers and consumers (SQS, RabbitMQ). Enables
  decoupling, spike smoothing, and retries.
- **Pub/sub & event streaming** — one event, many consumers (Kafka, SNS). Kafka also
  retains an ordered, replayable log.
- **At-least-once / exactly-once / at-most-once** — delivery guarantees. "Exactly-once" is
  usually "at-least-once + idempotent consumer".
- **Dead-letter queue (DLQ)** — where messages go after repeated processing failures, for
  inspection instead of infinite retry.
- **Back-pressure** — signalling upstream to slow down when a consumer can't keep up.

## Real-time & geo

- **WebSocket** — a persistent, bidirectional connection; the basis of chat and live updates.
- **Long polling / SSE** — simpler server-push alternatives when full duplex isn't needed.
- **Geohash** — encodes lat/long into a short string; nearby points share prefixes → great
  for "find nearby" range scans and sharding.
- **Quadtree** — a tree that recursively subdivides 2D space; another spatial index for
  proximity queries, adapting to density.

## Reliability & operations

- **Availability** — uptime, in "nines" (99.9% ≈ 8.7 h/yr down; 99.99% ≈ 52 min/yr).
- **SPOF (single point of failure)** — a component whose loss takes down the system. Remove
  via redundancy, replicas, multi-AZ/region, failover.
- **Rate limiting** — cap request rate per client. **Token bucket** (allows bursts),
  **leaky bucket** (smooths to a constant rate), fixed/sliding window counters.
- **Health check / heartbeat** — periodic liveness signal the LB/orchestrator uses to route
  around dead nodes.
- **Circuit breaker** — stop calling a failing dependency for a cooldown so it can recover
  and you fail fast.
- **Monitoring / observability** — metrics, logs, traces; the SLIs/SLOs you alert on.
