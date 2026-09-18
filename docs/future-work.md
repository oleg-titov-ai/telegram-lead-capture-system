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
- Add consent notes.
- Add delivery failure notes.
- Add an onboarding checklist.

## Portfolio

- Keep privacy notes visible.
- Show the system flow clearly.
