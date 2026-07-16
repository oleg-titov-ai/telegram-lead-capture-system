# ✅ Setup Checklist

Use this checklist to deploy a demo or production version.

---

## 1. Telegram

- [ ] Create a Telegram bot using BotFather.
- [ ] Save the bot token locally or in n8n credentials.
- [ ] Do not commit the bot token to GitHub.
- [ ] Create a Telegram manager group.
- [ ] Add the bot to the manager group.
- [ ] Get demo or production chat IDs locally.

---

## 2. PostgreSQL

- [ ] Create a PostgreSQL database.
- [ ] Run `sql/001_schema.sql`.
- [ ] Run `sql/002_functions.sql`.
- [ ] Run `sql/003_demo_data.sql`.
- [ ] Check that demo client exists.

---

## 3. n8n

- [ ] Create PostgreSQL credentials in n8n.
- [ ] Create Telegram credentials in n8n.
- [ ] Create or import the workflow.
- [ ] Add website webhook node.
- [ ] Confirm the webhook accepts only the intended HTTP method.
- [ ] Reject unexpected webhook content types before processing input.
- [ ] Enforce a reasonable maximum webhook payload size.
- [ ] Normalize and trim text fields before database writes and notifications.
- [ ] Validate the expected origin or client identifier before processing website submissions.
- [ ] Add Telegram trigger node.
- [ ] Add filter: process only private Telegram chats.
- [ ] Test website form branch.
- [ ] Test Telegram bot branch.

---

## 4. Website Widget

- [ ] Copy `website/lead-widget.html` to the website.
- [ ] Replace `DEMO_WEBHOOK_URL` with your n8n webhook URL.
- [ ] Replace `DEMO_BOT_USERNAME` with your Telegram bot username.
- [ ] Replace `demo-client` with your real client slug.
- [ ] Check privacy policy and consent links.
- [ ] Verify consent status and timestamp are recorded with each website lead.
- [ ] Validate maximum input lengths before submitting the form.

---

## 5. Final Test

- [ ] Send a test website form request.
- [ ] Confirm the website receives a clear success or error response.
- [ ] Record webhook response status codes in operational logs without storing form contents.
- [ ] Include a non-sensitive request ID in logs to trace one submission across the workflow.
- [ ] Confirm the widget handles a webhook timeout without losing entered form data.
- [ ] Repeat the same submission and verify duplicate handling.
- [ ] Check that the lead is saved in PostgreSQL.
- [ ] Check that Telegram notification is sent.
- [ ] Simulate a Telegram notification failure and verify the lead remains stored for retry.
- [ ] Confirm retryable notification failures are visible in operational status without exposing lead contents.
- [ ] Open Telegram bot with `/start demo-client`.
- [ ] Complete the dialog.
- [ ] Check that Telegram lead is saved.
- [ ] Check that manager notification is sent.

---

## 6. Before Publishing Publicly

- [ ] Search repository for tokens.
- [ ] Search repository for passwords.
- [ ] Search repository for real chat IDs.
- [ ] Search repository for private webhook URLs.
- [ ] Search repository for real customer data.
- [ ] Keep production `.env` files out of GitHub.
