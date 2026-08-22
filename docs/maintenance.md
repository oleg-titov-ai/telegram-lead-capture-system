# Maintenance

- 2026-08-19: Keep demo reset verification in the release checklist: a clean portfolio run should start with no stale leads, dialog state, correlation IDs, or pending notification retries.
- 2026-08-20: Verify the demo reset also restores the documented seed lead/form state so a fresh walkthrough starts from the same reproducible baseline every time.
- 2026-08-20: Keep demo notification examples limited to synthetic contact data and verify no real phone numbers, usernames, or chat identifiers appear in screenshots or logs.
- 2026-08-20: Verify the documented form fields, stored lead fields, and Telegram notification example remain in sync after schema changes.
- 2026-08-20: Re-run the documented demo webhook example after contract changes and confirm invalid required fields still fail cleanly without creating a partial lead.
- 2026-08-21: Verify duplicate demo submissions with the same correlation key do not create duplicate stored leads or duplicate Telegram notifications.
- 2026-08-21: Keep the demo notification status aligned with the stored lead status so a portfolio walkthrough cannot show a successful notification for a lead that failed validation or persistence.
- 2026-08-21: Verify a demo lead can be deleted or reset cleanly without leaving an orphaned notification retry or stale conversation-state reference.
- 2026-08-21: Recheck the documented webhook response examples after validation changes so success and error payloads remain accurate and contain no internal stack details.
- 2026-08-22: Verify the documented demo form submission still produces exactly one persisted lead and one notification after dependency or workflow updates.
- 2026-08-22: Keep the documented demo field mapping explicit enough to compare form input, persisted lead data, and notification output without relying on production-only fields.
- 2026-08-22: After a demo reset, verify the next synthetic submission receives a fresh correlation ID and does not inherit retry or conversation state from the previous walkthrough.
- 2026-08-22: Keep portfolio demo timestamps synthetic or normalized so screenshots and sample payloads cannot reveal real operating times or customer activity windows.
