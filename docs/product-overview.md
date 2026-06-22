# Product Overview

## Business Problem

Many small and medium-sized businesses lose leads because website forms, messengers, and manager notifications are disconnected.

A customer leaves a request, but the manager sees it too late, the data is copied manually, or the lead is never saved in a central database.

## Product Idea

Telegram Lead Capture System connects a website form and Telegram bot to one PostgreSQL-based lead workflow orchestrated by n8n.

The same architecture can support several clients or websites through a `client_slug` and client configuration table.

## Customer Journey

### Website Form

```text
Customer submits website form
        ↓
n8n receives webhook
        ↓
data is normalized and validated
        ↓
lead is saved in PostgreSQL
        ↓
manager group receives Telegram alert
        ↓
website receives success response
```

### Telegram Bot

```text
Customer opens bot from website
        ↓
/start contains client identifier
        ↓
bot asks several short questions
        ↓
dialog state is stored in PostgreSQL
        ↓
completed lead is saved
        ↓
manager group receives notification
```

## Core Product Modules

- website lead widget;
- Telegram bot dialog;
- multi-client configuration;
- n8n orchestration;
- PostgreSQL lead storage;
- dialog state management;
- manager notifications;
- duplicate and validation logic;
- demo placeholders and secure configuration.

## Suitable Industries

- B2B suppliers;
- manufacturing;
- construction;
- professional services;
- local services;
- distributors;
- repair companies;
- agencies;
- companies with several websites or branches.

## Business Value

- faster response to new requests;
- fewer lost leads;
- one database for website and Telegram sources;
- easier manager notifications;
- reusable deployment for several clients;
- lower setup cost than a full custom CRM;
- clear foundation for later CRM integration.

## Recommended Production Extensions

1. lead status pipeline;
2. manager assignment;
3. SLA timers and reminders;
4. duplicate detection by phone and email;
5. CRM synchronization;
6. analytics dashboard;
7. retry queue for failed notifications;
8. audit log for important workflow events;
9. consent and privacy-policy tracking.

## Portfolio Value

The project demonstrates business-process automation, webhook design, Telegram integration, PostgreSQL functions, multi-client architecture, stateful bot dialogs, and secure public documentation.
