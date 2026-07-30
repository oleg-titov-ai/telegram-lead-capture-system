# Maintenance checklist

Before a demo, test duplicate-webhook handling, malformed optional fields, manager notifications, and removal of real chat IDs and customer data.

Confirm the consent text and privacy-policy link are visible and valid in every public lead-entry path.

Submit a synthetic duplicate lead after workflow changes to confirm retries do not create extra CRM records or notifications.

Verify webhook error responses remain generic and do not expose workflow names, database details, or internal identifiers.

Confirm stored demo leads record the consent version or timestamp needed for a basic audit trail.

Test the manager-notification fallback with a synthetic lead so a temporary messaging failure does not silently lose the request.

Verify each synthetic lead has a non-sensitive correlation identifier in logs so webhook, database, and notification steps can be traced without exposing customer data.