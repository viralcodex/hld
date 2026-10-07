# Q04 · Distributed Cache

**Topic:** Consistent hashing · eviction · replication · coherence
**Tier:** 1 — Fundamentals & building blocks
**Difficulty:** Medium

---

## The brief

Design a **distributed in-memory cache** — a Redis/Memcached-style service that many
application servers share to store hot key→value data and take load off the database.
A single cache box isn't enough: the dataset and the request rate exceed one machine, so
you must spread it across a **cluster** and keep working as nodes come and go.

### Functional requirements

- `get(key)`, `put(key, value, ttl?)`, `delete(key)`.
- Values up to a few hundred KB; TTL-based expiry.
- **Eviction** when memory is full (which key to drop).
- Scale to a cluster of many nodes; survive node loss.

### Non-functional requirements

- **Very low latency:** sub-millisecond `get` in the common case.
- **High availability:** losing a node must not lose the whole cache or stall clients.
- **Elastic:** add/remove nodes with minimal disruption (don't re-map every key).
- Cache is a *performance* layer — some staleness/loss is tolerable, but define it.

### Scale to design for

- **10 M** requests/sec across the cluster.
- **10 TB** of hot data, far more than one node holds.
- Nodes added/removed routinely (autoscaling, failures, deploys).

---

## What your diagram must show

1. How a key maps to a node — **consistent hashing** (ring + virtual nodes) and *why* over
   plain `hash(key) % N`.
2. The **client/proxy** path: how an app server finds the right cache node for a key.
3. **Eviction policy** (LRU/LFU/TTL) and how a node decides what to drop when full.
4. **Replication**: replicas per key, read/write routing, and what happens on node failure.
5. The **consistency / coherence** story: how a cache entry is kept in sync with the DB
   (cache-aside? write-through? invalidation on update?) — and the staleness window.
6. How adding/removing a node moves only a **fraction** of keys.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q4"**.
