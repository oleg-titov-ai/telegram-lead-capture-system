# Maintenance Checks

Before a demo or deployment:

- Verify repeated webhook deliveries do not create duplicate leads or notifications.
- Confirm malformed optional fields are rejected or normalized consistently.
- Test retry limits and ensure successful notifications are not resent.
- Review logs and screenshots for real chat IDs, customer data, and private endpoints.
- Confirm partially completed submissions expire without creating incomplete leads.
