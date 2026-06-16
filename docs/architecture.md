# 🧩 Architecture

This project contains two lead capture flows:

1. Website form flow
2. Telegram bot dialog flow

---

## 🌐 Website Form Flow

```text
Website lead form
        ↓
n8n Webhook
        ↓
Normalize website form data
        ↓
PostgreSQL function crm_process_web_lead()
        ↓
Save lead in PostgreSQL
        ↓
Return response to website
        ↓
Send Telegram notification to owner / manager group
```

### Main idea

A customer submits a website form. n8n receives the request, normalizes the data, sends it to PostgreSQL, and returns a public response to the website. If the lead is valid, Telegram notifications are sent to the owner and/or manager group.

---

## 🤖 Telegram Bot Flow

```text
Website Telegram button
        ↓
Telegram bot /start client_slug
        ↓
n8n Telegram Trigger
        ↓
Normalize Telegram message
        ↓
PostgreSQL function crm_process_tg_message()
        ↓
Save dialog state / save lead
        ↓
Send reply to customer
        ↓
Send Telegram notification to owner / manager group
```

### Main idea

A customer clicks the Telegram button on the website. The bot starts with `/start client_slug`, asks short questions, stores dialog state in PostgreSQL, creates a lead, and notifies managers.

---

## 🗄️ PostgreSQL Role

PostgreSQL stores:

- clients;
- active Telegram dialogs;
- leads;
- optional payment records.

Business logic is handled by PostgreSQL functions:

- `crm_process_web_lead(input_data jsonb)`
- `crm_process_tg_message(input_data jsonb)`

---

## 🔐 Security Model

Production values must not be published:

- Telegram bot tokens;
- n8n credentials;
- PostgreSQL credentials;
- real chat IDs;
- private webhook URLs;
- real leads;
- personal customer data.

Use demo placeholders in public examples.
