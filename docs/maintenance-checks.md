# Maintenance Checks

Before a demo or deployment:

- Verify repeated webhook deliveries do not create duplicate leads or notifications.
- Confirm malformed optional fields are rejected or normalized consistently.
- Test retry limits and ensure successful notifications are not resent.
- Review logs and screenshots for real chat IDs, customer data, and private endpoints.
- Confirm partially completed submissions expire without creating incomplete leads.
- Verify expired temporary submission data is removed according to the documented retention window.
- Confirm consent status is recorded with the submission timestamp without storing unnecessary client metadata.
- Verify notification failures remain visible for manual follow-up without exposing lead details in logs.
- Reject oversized webhook payloads before parsing and record only a non-sensitive failure reason.
- Confirm public demo instructions use placeholder endpoints and test chat identifiers only.
- Validate individual field lengths before storing or forwarding a lead submission.
- Confirm normalized phone and email fields are validated before duplicate matching.
- Verify consent wording shown in the demo matches the wording documented for stored submissions.
