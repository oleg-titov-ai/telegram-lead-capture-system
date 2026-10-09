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

Maintenance note: verify malformed UTF-8 input is rejected with a generic response before lead normalization or notification work begins.

Maintenance note: verify unsupported request content types are rejected before normalization without creating lead or notification state.

Maintenance note: document and test the maximum accepted payload size before request parsing so rejection behavior stays predictable.

Maintenance note: verify malformed Unicode input is rejected or normalized without altering valid lead fields.

Maintenance note: document the deduplication key and retention window used to make webhook retries safe.

Maintenance note: document when abandoned lead-capture conversations expire and which non-sensitive state is cleared.

Maintenance note: document rate-limit responses and retry timing so repeated requests cannot create duplicate lead state.

Maintenance note: document the consent-policy version and timestamp recorded before a lead is persisted.

Maintenance note: verify structured logs omit contact fields while retaining request IDs and safe processing outcomes.

Maintenance note: document notification retry limits and the safe terminal status used after repeated delivery failures.

- Document the transaction boundary between lead persistence and notification enqueueing so retries cannot produce inconsistent states.

- Define a recovery procedure for leads persisted successfully when notification delivery is temporarily unavailable.

- Document retention and cleanup rules for abandoned lead-capture sessions that never reach final submission.

- Define validation behavior for incomplete contact details so recoverable leads remain editable without entering the notification queue.

- Document how notification recipients are validated before dispatch so configuration mistakes fail safely and remain observable.

- Define a concise operator checklist for reviewing and replaying notification jobs that reached a retry limit.

- Document how duplicate form submissions are linked to an existing lead without overwriting newer contact details.

- Define how stale draft leads are distinguished from active conversations before automated cleanup.

- Document the audit trail required when an operator manually corrects or resubmits a captured lead.

- Document how consent status is preserved when a user resumes an incomplete lead-capture conversation.

- Document how contact-field corrections are validated before replacing values on an existing lead.

- Document how queued notifications are handled when the configured recipient changes before delivery.

- Document how a queued notification is refreshed or cancelled when lead details are corrected before delivery.

- Document which lead fields are snapshotted when a notification is queued and which are resolved again at delivery time.

- Document how notification retries react when a lead is withdrawn or marked invalid after the first delivery attempt.

- Document the consent and data-freshness checks required before replaying a notification from the dead-letter queue.

- Document how final lead status is preserved when the notification channel becomes unavailable during submission.

- Document how notification deduplication is preserved when delivery moves to a replacement recipient group.

- Document the non-sensitive audit event recorded when a notification destination is changed by an operator.

- Document the maximum notification-queue age and the review required before an expired item can be replayed.
