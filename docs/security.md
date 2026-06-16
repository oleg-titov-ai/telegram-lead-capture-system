# 🔐 Security Notes

This repository is designed as a public demo / portfolio project.

It must never contain production secrets, real customer data, private URLs, or real infrastructure details.

---

## 🚫 Never Commit

Do not commit:

- Telegram bot tokens
- n8n credentials
- PostgreSQL passwords
- PostgreSQL connection strings with passwords
- real Telegram `chat_id` values
- real manager group IDs
- private webhook URLs
- production domains if they are not intended for public use
- server IP addresses
- `.env` files with real values
- exported n8n credentials
- customer names
- real phone numbers
- real emails
- real leads
- database backups

---

## ✅ Safe Public Placeholders

Use placeholders like:

```text
https://example.com
https://n8n.example.com/webhook/lead-form
@demo_lead_bot
DEMO_OWNER_CHAT_ID
DEMO_GROUP_CHAT_ID
demo-client
demo@example.com
+7 000 000-00-00
CHANGE_ME_LOCALLY
```

---

## 🧪 Before Making Repository Public

Run a manual check for these keywords:

```text
token
password
secret
credential
chat_id
webhook
instanceId
versionId
.env
postgres
telegram
http
https
```

Also search for:

```text
real domains
server IP addresses
client names
phone numbers
email addresses
private company data
```

---

## 🧩 n8n Export Rules

Public n8n workflow exports should not include:

- `credentials`
- `webhookId`
- real credential names
- production workflow IDs
- private instance IDs
- real chat IDs
- private URLs

Use `n8n/workflow-placeholder.json` as a cleaned demo workflow.

---

## 🧯 If a Secret Was Committed

If a real token or password was committed by mistake:

1. Revoke or rotate the token immediately.
2. Change the password locally / in the service dashboard.
3. Remove the secret from the repository.
4. Treat the old secret as compromised.

Do not rely only on deleting the file from GitHub history.
