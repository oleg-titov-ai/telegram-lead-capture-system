# Security Policy

## Scope

Telegram Lead Capture System is a public automation template for lead capture. The repository must contain only placeholders and safe demo data.

## Sensitive Data That Must Not Be Committed

- Telegram bot tokens;
- PostgreSQL passwords;
- n8n credentials;
- private webhook URLs;
- real chat IDs;
- real customer data;
- real leads;
- private phone numbers;
- private email addresses;
- `.env` files with secrets.

## Safe Public Examples

Use placeholders such as demo chat IDs, example domains, fake customers, and demo phone numbers. Screenshots should not reveal real leads or manager group messages.

## Reporting a Security Issue

Open a GitHub issue with a safe description. Do not include tokens, webhook URLs, database credentials, or real lead data.

## Production Notes

A production deployment should include access control, audit logging, backup strategy, consent tracking, and a clear privacy policy for lead processing.
