# Q06 · Chat System

**Topic:** WebSockets · presence · delivery/read receipts · message store
**Tier:** 2 — Social graphs, feeds & messaging
**Difficulty:** Medium

---

## The brief

Design a real-time **chat system** like **WhatsApp / Messenger**. Users exchange messages
1:1 (and in small groups), see when contacts are online, and get messages delivered within
moments — even when the recipient is briefly offline.

The new ingredient here is **real-time, bidirectional delivery**: the server must *push* to
clients, which changes the connection model from the request/response you've used so far.

### Functional requirements

- 1:1 messaging; small **group** chats.
- **Real-time delivery** when the recipient is online.
- **Store-and-forward** when offline → deliver on reconnect.
- **Presence**: online / last-seen.
- **Delivery & read receipts** (sent ✓ / delivered ✓✓ / read).
- Message history is persisted and retrievable.

### Non-functional requirements

- **Low latency:** message delivered in **< 1 s** when both online.
- **Highly available**; messages must not be lost.
- **Ordered** delivery within a conversation.
- Hundreds of millions of **persistent connections**.

### Scale to design for

- **1 B** users, **500 M** DAU.
- **50 B** messages/day.
- Tens of millions of **concurrent WebSocket connections**.

---

## What your diagram must show

1. The **connection model**: WebSocket (or long-poll) gateway servers holding persistent
   connections; how a client connects and stays connected.
2. The **send path**: A → gateway → how the message reaches B's connection (routing across
   gateway servers), including the **message queue / router**.
3. The **offline path**: store-and-forward, then deliver on reconnect.
4. **Presence**: how online/last-seen is tracked and published without melting the system.
5. The **data model & store** for messages and conversations (and why that store).
6. **Receipts** (delivered/read) and **ordering** within a conversation.
7. How you map **which gateway server** holds user B's live connection.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q6"**.
