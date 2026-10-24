# Future Work

Small improvements to consider next.

## Short Term

- Link documentation from the README.
- Add a demo user journey.
- Add safe sample messages.
- Clarify setup steps.

## Medium Term

- Document transport-level rejection before payload parsing; use synthetic oversized, truncated, and malformed-framing requests to specify the stable status and redacted diagnostic, verifying that decoding, lead persistence, notification enqueueing, and accepted-lead metrics are never reached.
- Document request-body timeout and client-disconnect behavior alongside validation examples; use synthetic uploads that finish within the limit, time out before parsing, and disconnect after a partial body to specify the status and redacted diagnostic, with incomplete payloads discarded before any lead is created or updated.
- Document a single generic error contract for transport-level rejections so malformed uploads return stable, non-sensitive status codes.
- Document an explicit `Content-Encoding` allowlist and reject unsupported encodings before payload decoding; use synthetic identity, supported compressed, stacked, unknown, and malformed values to specify normalized matching, stable rejection status, size-limit order, and redacted diagnostics without retaining request bodies.
- Document that transport-level rejections do not increment accepted-lead, retry, or notification metrics.
- Document separate wire and decoded body-size limits, with a compressed-payload example that rejects an oversized decoded request before parsing and leaves accepted-lead, retry, and notification metrics unchanged.
- Add consent notes.
- Add delivery failure notes.
- Add an onboarding checklist.
- Add a bounded replay example showing duplicate lead submissions remain idempotent.

## Portfolio

- Keep privacy notes visible.
- Show the system flow clearly.

## Maintenance verification backlog

These are proposed checks, not evidence of implemented or verified behavior. Record synthetic inputs and observed outcomes when checking an item, and keep unperformed checks explicitly untested.

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

- Document the transaction boundary between lead persistence and notification enqueueing; inject synthetic failures before and after that boundary to specify rollback or recovery, verifying each accepted lead retains exactly one notification intent rather than assuming two separate writes are atomic.

- Define a recovery procedure for leads persisted successfully when notification delivery is temporarily unavailable.

- Define validation behavior for incomplete contact details so recoverable leads remain editable without entering the notification queue.

- Document recipient validation with synthetic missing, malformed, and unauthorized destination settings; specify blocked dispatch and a redacted operator warning, preserving the pending notification without falling back to another chat or exposing lead content.

- Define a concise operator checklist for reviewing and replaying notification jobs that reached a retry limit.

- Document how duplicate form submissions are linked to an existing lead without overwriting newer contact details.

- Define how stale draft leads are distinguished from active conversations before automated cleanup.

- Document the audit trail required when an operator manually corrects or resubmits a captured lead; use synthetic edits to record timestamp, operator role, reason, changed field names, source revision, and resulting notification action without storing previous or replacement contact values in public diagnostics.

- Document how consent status is preserved when a user resumes an incomplete lead-capture conversation; compare synthetic granted, missing, and withdrawn consent states, requiring renewed consent where needed rather than treating conversation resumption as permission to submit or notify.

- Document validation of contact-field corrections using synthetic valid and rejected edits; specify that rejected edits preserve the saved revision and queued notification state, with no partially applied contact changes or raw rejected values in logs.

- Document how queued notifications are handled when the configured recipient changes before delivery; use synthetic old and new destinations to define whether routing is snapshotted or re-resolved, require authorization validation at send time, and prevent fallback to an obsolete recipient without logging chat identifiers or lead payloads.

- Document which lead fields are snapshotted when a notification is queued and which are resolved again at delivery time; use a synthetic lead edited after enqueue to define immutable consent and submission evidence, refreshable contact fields, revision identifiers, and suppression when delivery-time validation fails.

- Document how notification retries react when a lead is withdrawn or marked invalid after the first delivery attempt.

- Document the consent and data-freshness checks required before replaying a notification from the dead-letter queue; use synthetic active, withdrawn, expired, and edited leads to define operator approval, delivery-time revalidation, a new replay attempt identifier, and cancellation without restoring stale contact payloads.

- Document how final lead status is preserved when the notification channel becomes unavailable during submission; use a synthetic committed lead and mocked channel outage to distinguish accepted submission from pending notification, preserving the lead identifier and preventing a delivery failure from creating a second lead on retry.

- Document how notification deduplication is preserved when delivery moves to a replacement recipient group; use synthetic delivered, pending, and unknown-outcome records to define migration eligibility, retain a stable notification key, and prevent changing the destination from resetting confirmed delivery state.

- Document the non-sensitive audit event recorded when a notification destination is changed by an operator; define timestamp, authorized operator role, opaque destination aliases, reason, and outcome using a synthetic change, excluding raw chat identifiers, credentials, and lead payloads.

- Document the maximum notification-queue age and the review required before an expired item can be replayed; use synthetic entries just below, at, and above expiry to define eligibility, requiring current consent and operator approval for replay without resetting age automatically on retry.

- Document how notification state is reconciled when delivery acknowledgement arrives after the worker timeout; use a synthetic delayed success response to define the delivery-key state transition, suppress a queued duplicate retry, and keep unresolved timeouts distinct from confirmed delivery without logging contact payloads.

- Document recovery when persistence fails around Telegram webhook acknowledgement; use a synthetic transaction failure to specify acknowledgement only after durable commit, duplicate-update handling on retry, and reconciliation for prematurely acknowledged failures without assuming Telegram will redeliver them.

- Document how lead edits are reconciled when contact details change while the owner notification is still queued; use synthetic before-and-after revisions to specify which version is sent, recheck consent immediately before delivery, and prevent stale contact details from appearing in retries.

- Document contact-field normalization and validation without retaining rejected raw phone numbers or email addresses; use synthetic malformed phone and email inputs to specify user-facing validation codes and verify raw rejected values do not enter logs, dead-letter records, or notification payloads.

- Document dead-letter retention and redaction rules so failed lead notifications do not preserve unnecessary contact data; use synthetic failures to define retained status fields, expiry, and cleanup checks, excluding raw contact payloads and revalidating consent before any operator-approved replay.

- Document notification-state recovery after an owner unblocks the bot following a failed delivery attempt; use mocked owner interaction to define reactivation, recheck consent and lead validity before replay, and verify a previously delivered notification is not sent again.

- Document duplicate-contact reconciliation when a user restarts the chat and resubmits an existing lead; use a consented synthetic repeat submission to define the matching key, field-update precedence, and owner-notification decision without merging distinct contacts or reviving withdrawn consent.

- Document recording consent source and timestamp without retaining the original message body in operational logs; define the source label and UTC timestamp format using a synthetic consent event, and specify how missing consent evidence blocks submission without logging message text.

- Document notification routing recovery when a Telegram group is migrated and receives a replacement chat identifier; mock the migration response to specify authorized destination mapping, persistence across restart, and one queued notification delivery without logging real chat identifiers or lead payloads.

- Document how pending owner notifications are revalidated when a lead is deleted or withdrawn before delivery; use synthetic queued leads to specify a final eligibility check, cancellation of stale notifications, and a redacted outcome that retains no contact payload.

- Document owner-group permission checks after administrator roles change so lead notifications do not fail silently; mock allowed, send-denied, and group-unavailable responses to specify queue preservation and a redacted operator alert without sending real lead data.

- Document safe webhook-secret rotation with an overlap window that avoids dropping incoming lead submissions; use synthetic old and new secrets to verify both work only during overlap, the old value is rejected after cutover, and no secret value appears in logs.

- Document queue backpressure and notification prioritization when Telegram rate limits delay owner alerts; use synthetic queues below and above the threshold to specify priority classes, FIFO behavior within each class, Retry-After handling, and redacted backlog metrics.

- Document retention and cleanup of abandoned lead conversations that never reach final consent or submission; define the expiry clock and retained fields, then use synthetic expired and active sessions to verify cleanup does not remove in-progress submissions or log contact details.

- Document privacy-safe owner notification templates that expose only the contact details required for follow-up; include a synthetic example and an explicit included/omitted field list, keeping consent evidence and internal diagnostics out of the message.

- Document escalation for owner notifications that remain queued beyond the expected delivery window; specify the threshold and use synthetic queue entries just below and above it to verify one redacted alert per overdue notification.

- Document canonical international phone formatting while preserving the user's original value only where operationally necessary; use synthetic examples for country prefixes, separators, and invalid input, with expected normalized values or validation errors and no raw numbers in logs.

- Document verification of public bot links after a username change so website entry points do not become stale; check both visible link text and destination, preserving any intended start parameter without submitting a real lead.

- Document safe escaping of user-supplied text in owner notifications; include synthetic angle brackets, ampersands, and Markdown punctuation, with expected literal rendering for the configured Telegram parse mode.

- Document idempotent owner-notification delivery when a worker restarts after Telegram accepts a message but before local acknowledgement is stored; use a synthetic accepted response and stable delivery key to specify recovery behavior and verify the restart does not produce a second owner alert.

- Document how opt-out requests are handled when a lead later restarts the flow from a shared Telegram account; use synthetic contacts to verify that restarting alone does not restore consent or reveal an earlier lead's details.

- Document link-preview suppression for owner notifications so URL-like user input cannot trigger unintended external fetches or misleading preview cards; use synthetic reserved-domain text to verify literal escaped rendering, disabled previews, and unchanged delivery status without contacting the destination.

- Document owner-notification behavior when escaped lead text approaches Telegram message-length limits; use synthetic below, at, and above-limit payloads to specify safe splitting or rejection, preserve field labels and delivery keys, and ensure contact data is neither silently truncated nor duplicated across parts.

- Document how unsupported photos, documents, voice notes, and other attachments are handled during lead capture; use synthetic Telegram updates to specify a text-only clarification prompt, no attachment download or persistence, and no advancement of the five-question flow.

- Document handling of stale or replayed inline-button callbacks from earlier lead-flow steps; use synthetic callback identifiers and conversation versions to specify acknowledgement, a safe restart prompt, and no mutation of the current lead or consent state.

- Document how Telegram edited-message updates affect an in-progress or already submitted lead; use synthetic edits before validation, after consent, and after durable submission to define accepted corrections versus a new-flow prompt without silently rewriting delivered owner notifications.

- Document how forwarded messages and quoted replies are treated during lead capture; use synthetic updates to accept only the user's explicit text for the current question, ignore forwarded attribution and reply metadata, and avoid persisting third-party identities or advancing the flow on an empty quote.

- Document owner-notification routing when the destination supergroup uses forum topics; use synthetic `message_thread_id` values for valid, closed, deleted, and unavailable topics to keep each lead in the configured thread, fail visibly, and never fall back to an unrelated topic.

- Document how Telegram media groups are handled during an active lead flow; use synthetic albums with one caption, multiple captions, delayed parts, and unsupported media to define one bounded acknowledgement, preserve message ordering, and avoid advancing the form more than once.

- Document durable Telegram update-offset handling across process restarts; replay synthetic ordered, duplicate, skipped, and out-of-order `update_id` sequences to checkpoint only after durable state changes, avoid reprocessing submitted leads, and surface gaps without silently advancing past them.

- Document handling of Telegram `retry_after` responses while acknowledging a lead or notifying its owner; use synthetic short, excessive, repeated, and missing delay values to bound retries, preserve one delivery key, and avoid blocking unrelated conversations or duplicating a submitted lead.
