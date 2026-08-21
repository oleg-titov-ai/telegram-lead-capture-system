# Maintenance

- 2026-08-19: Keep demo reset verification in the release checklist: a clean portfolio run should start with no stale leads, dialog state, correlation IDs, or pending notification retries.
- 2026-08-20: Verify the demo reset also restores the documented seed lead/form state so a fresh walkthrough starts from the same reproducible baseline every time.
- 2026-08-20: Keep demo notification examples limited to synthetic contact data and verify no real phone numbers, usernames, or chat identifiers appear in screenshots or logs.
- 2026-08-20: Verify the documented form fields, stored lead fields, and Telegram notification example remain in sync after schema changes.
- 2026-08-20: Re-run the documented demo webhook example after contract changes and confirm invalid required fields still fail cleanly without creating a partial lead.
- 2026-08-21: Verify duplicate demo submissions with the same correlation key do not create duplicate stored leads or duplicate Telegram notifications.
