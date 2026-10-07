# Rubric — Q07 Notification Service

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] send API; push + SMS + email channels; preferences; templates; retries + dedup.

## Dimension 2 — Async, decoupled architecture — THE KEY INSIGHT (2.5 pts)
- [ ] Ingestion writes to a **message queue**; delivery happens in **async workers** —
      callers return immediately.
- [ ] **Per-channel queues/workers** so a slow/broken channel (email) can't block another (push).
- [ ] **Provider adapters** abstract each third party (APNs/FCM/Twilio/SES) behind one interface.

## Dimension 3 — Preferences, templates & routing (1.5 pts)
- [ ] Pipeline looks up **user preferences** (opt-out, quiet hours) and drops/holds accordingly.
- [ ] **Template** rendering step with the payload.
- [ ] Fan-out of one logical notification to the chosen channels.

## Dimension 4 — Reliability: retries & dedup (2 pts)
- [ ] **Retry with exponential backoff** on provider failure; **dead-letter queue** after N tries.
- [ ] **Idempotency / dedup**: an idempotency key per notification so retries or duplicate
      upstream calls don't double-send (dedup store / processed-set).
- [ ] Delivery guarantee stated (at-least-once + idempotent → effectively once to the user).

## Dimension 5 — Scale, spikes & trade-offs (2 pts)
- [ ] Queue **absorbs bursts** (campaign of millions) and workers drain at a safe rate.
- [ ] **Rate limiting** per provider (respect their limits) and per user (anti-spam).
- [ ] Status/audit store for delivery state; estimates present.
- [ ] Horizontal scaling of workers per channel independently.

## Dimension 6 — Clarity (0.5 pt)
- [ ] Queue → per-channel workers → adapters → providers chain is clearly drawn.

## Common gaps to call out
- Synchronous sends in the request path → caller blocked by provider latency/outage.
- One shared worker pool for all channels → head-of-line blocking.
- No dedup/idempotency → users get the same OTP 3 times on retry.
- No DLQ/backoff → infinite retries hammer a down provider.
- Ignoring provider rate limits → you get throttled/banned.

## Follow-ups to push with
- Twilio is down for 10 minutes — what happens to the SMS already in flight, and after?
- The same "order shipped" event is published twice — does the user get two texts?
- A campaign enqueues 5 M emails at once — how do you not melt SES or your workers?
