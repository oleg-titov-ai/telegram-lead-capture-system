# ⚙️ n8n Workflow Notes

This document describes the recommended n8n workflow structure for the Telegram Lead Capture System.

The workflow has two branches:

1. Website form branch
2. Telegram bot branch

---

## 🌐 Website Branch

Recommended nodes:

```text
Webhook
Normalize Website Form
PostgreSQL: SELECT crm_process_web_lead(...)
Prepare Website Response
Respond to Webhook
IF Website Notify Owner
Send Website Owner Notification
IF Website Has Work Group
Send Website Work Group Notification
```

### Webhook Node

Recommended method:

```text
POST
```

Recommended demo path:

```text
lead-form
```

The final public demo URL should look like:

```text
https://n8n.example.com/webhook/lead-form
```

Do not publish real production webhook URLs if the repository is public.

---

## 🧹 Normalize Website Form

Expected normalized object:

```json
{
  "source": "website_form",
  "client_slug": "demo-client",
  "product_type": "Steel pipe",
  "quantity": "100 pcs",
  "delivery_address": "Demo city",
  "customer_name": "Demo Customer",
  "customer_contact": "+7 000 000-00-00",
  "comment": "Demo comment",
  "page_url": "https://example.com",
  "user_agent": "Demo browser",
  "personal_data_agree": true,
  "privacy_policy_url": "https://example.com/privacy.html",
  "consent_url": "https://example.com/consent.html"
}
```

### PostgreSQL query example

```sql
SELECT crm_process_web_lead(
  '{{ JSON.stringify($json).replace(/'/g, "''") }}'::jsonb
) AS result;
```

---

## 🤖 Telegram Branch

Recommended nodes:

```text
Telegram Trigger
IF: chat.type = private
Normalize Telegram Message
PostgreSQL: SELECT crm_process_tg_message(...)
Prepare Telegram Replies
Send Reply to User
IF Notify Owner
Send Owner Notification
IF Has Work Group
Send Work Group Notification
```

---

## 🔒 Important Telegram Filter

Process only private Telegram chats:

```text
message.chat.type = private
```

This prevents the bot from replying inside manager group chats.

---

## 🧹 Normalize Telegram Message

Expected normalized object:

```json
{
  "source": "telegram_bot",
  "text": "MESSAGE_TEXT",
  "chat_id": "TELEGRAM_CHAT_ID",
  "user_id": "TELEGRAM_USER_ID",
  "username": "TELEGRAM_USERNAME",
  "first_name": "TELEGRAM_FIRST_NAME",
  "last_name": "TELEGRAM_LAST_NAME"
}
```

Example n8n Code node:

```js
const msg = $json.message || {};
const chat = msg.chat || {};
const from = msg.from || {};

return [{
  json: {
    source: 'telegram_bot',
    chat_id: chat.id,
    user_id: from.id || null,
    text: msg.text || '',
    username: from.username || chat.username || null,
    first_name: from.first_name || chat.first_name || null,
    last_name: from.last_name || chat.last_name || null
  }
}];
```

### PostgreSQL query example

```sql
SELECT crm_process_tg_message(
  '{{ JSON.stringify($json).replace(/'/g, "''") }}'::jsonb
) AS result;
```

---

## 📤 Prepare Telegram Reply

Expected PostgreSQL result fields:

```json
{
  "ok": true,
  "public_message": "Thank you! Your request has been received.",
  "notify_owner": true,
  "owner_chat_id": "DEMO_OWNER_CHAT_ID",
  "owner_group_chat_id": "DEMO_GROUP_CHAT_ID",
  "owner_text": "Lead notification text"
}
```

---

## 🚫 Do Not Publish

Do not publish production exports containing:

- Telegram credentials IDs that identify a real n8n instance;
- real webhook IDs;
- real workflow instance IDs;
- real PostgreSQL credentials names;
- real chat IDs;
- real customer data;
- private domains or URLs.

For public GitHub repositories, use a cleaned demo workflow or documentation-only workflow notes.
