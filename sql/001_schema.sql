-- PostgreSQL schema for Telegram Lead Capture System
-- Demo/public version. No real credentials or customer data.

CREATE TABLE IF NOT EXISTS clients (
    id BIGSERIAL PRIMARY KEY,
    client_slug TEXT NOT NULL UNIQUE,
    company_name TEXT NOT NULL,
    site_url TEXT,
    owner_tg_chat_id TEXT,
    owner_group_chat_id TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS tg_dialogs (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
    tg_chat_id TEXT NOT NULL,
    tg_user_id TEXT,
    tg_username TEXT,
    tg_first_name TEXT,
    tg_last_name TEXT,
    current_step INTEGER NOT NULL DEFAULT 0,
    product_type TEXT,
    quantity TEXT,
    delivery_address TEXT,
    customer_name TEXT,
    customer_contact TEXT,
    comment TEXT,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (client_id, tg_chat_id)
);

CREATE TABLE IF NOT EXISTS leads (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT REFERENCES clients(id) ON DELETE SET NULL,
    source TEXT NOT NULL DEFAULT 'unknown',
    product_type TEXT,
    quantity TEXT,
    delivery_address TEXT,
    customer_name TEXT,
    customer_contact TEXT,
    comment TEXT,
    tg_chat_id TEXT,
    tg_user_id TEXT,
    tg_username TEXT,
    page_url TEXT,
    user_agent TEXT,
    raw_data JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS payments (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT REFERENCES clients(id) ON DELETE CASCADE,
    payment_date DATE,
    amount NUMERIC(12, 2),
    currency TEXT DEFAULT 'RUB',
    period_from DATE,
    period_to DATE,
    status TEXT DEFAULT 'manual',
    comment TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_clients_slug ON clients(client_slug);
CREATE INDEX IF NOT EXISTS idx_leads_client_id ON leads(client_id);
CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads(created_at);
CREATE INDEX IF NOT EXISTS idx_tg_dialogs_client_chat ON tg_dialogs(client_id, tg_chat_id);
