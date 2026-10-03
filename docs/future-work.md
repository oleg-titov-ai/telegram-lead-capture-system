# Future Work

Small improvements to consider next.

## Short Term

- Link documentation from the README.
- Add a demo user journey.
- Add safe sample messages.
- Clarify setup steps.

## Medium Term

- Document transport-level rejection before payload parsing.
- Document request-body timeout and client-disconnect behavior alongside validation examples.
- Document a single generic error contract for transport-level rejections so malformed uploads return stable, non-sensitive status codes.
- Document an explicit `Content-Encoding` allowlist and reject unsupported encodings before payload decoding.
- Document that transport-level rejections do not increment accepted-lead, retry, or notification metrics.
- Document separate wire and decoded body-size limits, with a compressed-payload example that rejects an oversized decoded request before parsing and leaves accepted-lead, retry, and notification metrics unchanged.
- Add consent notes.
- Add delivery failure notes.
- Add an onboarding checklist.
- Add a bounded replay example showing duplicate lead submissions remain idempotent.

## Portfolio

- Keep privacy notes visible.
- Show the system flow clearly.

Maintenance note: verify unsupported content encodings are rejected before parsing without creating lead, retry, or notification state.

Maintenance note: verify replaying one synthetic request with the same idempotency key returns a consistent response without duplicating lead or notification state.

Maintenance note: verify reusing an idempotency key with a different synthetic payload returns a safe conflict without changing stored lead state.
