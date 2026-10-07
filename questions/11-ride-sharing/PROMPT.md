# Q11 · Ride-Sharing

**Topic:** Geo-indexing · matching · real-time location
**Tier:** 4 — Real-time, geo & transactions
**Difficulty:** Hard

---

## The brief

Design the backend of a ride-sharing service like **Uber / Lyft**. Riders request a trip;
the system finds nearby available drivers, matches one, and both sides see live location
updates until drop-off. Drivers continuously stream their position.

The new, hard ingredient is **geospatial** at scale: "which drivers are near this rider
*right now*", answered on constantly-moving data, millions of times a minute.

### Functional requirements

- Drivers go online and **stream location** continuously.
- Rider requests a ride at a location; system **finds nearby drivers** and **matches** one.
- Both parties see **live location** of each other during the trip.
- Trip lifecycle: request → match → pickup → in-progress → complete → fare.

### Non-functional requirements

- **Real-time:** matching in a few seconds; location updates every few seconds.
- **Highly available**; a region outage shouldn't take down others.
- Massive **write throughput** of location pings; read for proximity queries.
- Correctness: don't match one driver to two riders.

### Scale to design for

- **10 M** active drivers pinging location every **~4 s**.
- Millions of concurrent trips; peak surges in dense cities.

---

## What your diagram must show

1. **Location ingestion**: how 10 M drivers' pings (~millions/sec) are received and stored
   with low latency (and why a plain relational table won't do).
2. **Geo-indexing**: how you answer "drivers near (lat,long)" fast — **geohash** or
   **quadtree** / grid cells; how the index is updated as drivers move.
3. The **matching** flow: find candidates → select → **lock the driver** so they aren't
   double-matched (concurrency correctness).
4. The **live-trip** channel: how rider and driver exchange live location (websocket/push).
5. **Data model & stores**: live location (in-memory/geo store) vs durable trip records
   (which store for each and why).
6. Regional **sharding** by geography and failure isolation.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q11"**.
