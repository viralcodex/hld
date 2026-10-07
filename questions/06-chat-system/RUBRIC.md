# Rubric — Q06 Chat System

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] 1:1 + group; real-time delivery; offline store-and-forward; presence; receipts; history.

## Dimension 2 — Connection model — THE KEY INSIGHT (2.5 pts)
- [ ] **WebSocket** (or long-poll/SSE) gateway tier holding persistent connections — not
      plain request/response.
- [ ] A **connection registry / session service** mapping `userId → which gateway server`
      holds their live socket (so a message for B can be routed to the right box).
- [ ] Gateways are stateful (hold sockets) but the mapping is externalised (Redis/registry).

## Dimension 3 — Message routing & delivery (2 pts)
- [ ] Send path: A → A's gateway → router/queue → B's gateway → B's socket.
- [ ] Uses a **message queue / pub-sub** or router to move messages between gateway servers.
- [ ] **Offline**: persist to the message store, deliver on reconnect; outbox/undelivered flag.
- [ ] Ordering within a conversation preserved (per-conversation sequence/timestamp).

## Dimension 4 — Data model & storage (1.5 pts)
- [ ] Messages store keyed by `conversationId` + time (wide-column like Cassandra/HBase fits
      the write volume and the "fetch recent messages for a conversation" access pattern).
- [ ] Reasoning for NoSQL over relational at 50 B msgs/day.

## Dimension 5 — Presence, receipts & trade-offs (2 pts)
- [ ] **Presence** via heartbeats; published through pub-sub; acknowledges it's chatty and
      often made eventually consistent / sampled to avoid overload.
- [ ] **Receipts**: delivered/read sent back as control messages and persisted.
- [ ] Durability: ack to sender only after persisted; at-least-once + dedup/idempotency.
- [ ] Scale: millions of connections sharded across many gateway servers; estimates present.

## Dimension 6 — Clarity (0.5 pt)
- [ ] The two-gateway hop (A's box → B's box) is clearly drawn.

## Common gaps to call out
- Using HTTP request/response polling as the primary delivery (won't meet latency/scale).
- No connection registry → can't find which server holds B's socket.
- Losing messages when the recipient is offline (no store-and-forward).
- Presence broadcast to all contacts on every change → fan-out storm.
- Ignoring ordering within a conversation.

## Follow-ups to push with
- A sends to B who is connected to a *different* gateway server — trace the message.
- B is offline for an hour then reconnects — what gets delivered, in what order?
- 10 M users come online at 9 a.m. — what does presence do to your system?
