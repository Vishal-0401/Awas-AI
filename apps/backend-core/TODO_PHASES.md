# backend-core build phases (AWAS-AI)

## Phase 0: Contract + schema enforcement
- [ ] Replace Prisma schema with full production schema
- [ ] Add enums/state machines
- [ ] Add indexes/constraints/soft deletes

## Phase 1: Auth + RBAC
- [ ] OTP placeholder (request/verify)
- [ ] JWT access + refresh rotation
- [ ] Redis token invalidation
- [ ] RBAC middleware (CUSTOMER/WORKER/ADMIN)

## Phase 2: Dispatch / Jobs state machine
- [ ] Socket.io namespaces/events
- [ ] Redis GEO indexing for worker locations
- [ ] Distributed locking + first-accept-wins
- [ ] Job expiration + retry via BullMQ
- [ ] Job tracking updates

## Phase 3: Wallet + Escrow + Payments (placeholders)
- [ ] Ledger + wallet balances
- [ ] Escrow account initialization and release
- [ ] Refund/dispute reversal placeholders

## Phase 4: AI module (upload + diagnostics placeholders)
- [ ] Multer secure uploads
- [ ] AI scan + diagnostic record
- [ ] Predictive health placeholder

## Phase 5: Notifications
- [ ] BullMQ notification queue
- [ ] DB notifications + read status

## Phase 6: Observability + Swagger + Ops
- [ ] Winston request + error logging
- [ ] Health checks and request logging
- [ ] Swagger/OpenAPI completion
- [ ] Docker + compose readiness

