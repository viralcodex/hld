# Q07 · Notification Service

**Topic:** Queues · provider adapters · retries · dedup · preferences
**Tier:** 2 — Social graphs, feeds & messaging
**Difficulty:** Medium

---

## The brief

Design a **notification service** that other systems call to send users messages over
multiple channels — **push (APNs/FCM), SMS, and email**. "Your order shipped", "someone
liked your photo", "OTP code 123456". It must fan a single logical notification out to the
right channels, respect user preferences, and reliably deliver through flaky third-party
providers.

This is a classic **async, queue-driven** design where third-party failure handling and
exactly-the-right-number-of-times delivery are the meat.

### Functional requirements

- A `send(userId, type, payload)` API that other services call.
- Deliver via **push, SMS, email** (pick channels per notification type + user prefs).
- **User preferences**: opt-out per channel/type; quiet hours.
- **Templates** for message content.
- **Retries** on provider failure; avoid **duplicate** sends.
- (Optional) scheduled / batched notifications; rate limiting per user.

### Non-functional requirements

- **Highly available** and **decoupled** — a slow email provider must not block push.
- **Reliable:** deliver at-least-once; don't spam the user with duplicates.
- Handle **spiky** load (a marketing blast to millions).
- Third-party providers are **unreliable** and rate-limited.

### Scale to design for

- **10 B** notifications/day across channels.
- Bursts of **millions** in minutes (campaigns).

---

## What your diagram must show

1. The ingestion API and how requests are **decoupled** from delivery (queue).
2. **Per-channel workers/queues** and **provider adapters** (APNs, FCM, Twilio, SES, …).
3. **User preference** + template lookup in the pipeline.
4. **Retry** strategy (backoff, DLQ) and **deduplication / idempotency** so a user isn't
   notified twice.
5. How you absorb **spikes** without overwhelming providers (buffering, rate limiting).
6. The **data model**: preferences, templates, delivery status/audit log.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q7"**.
