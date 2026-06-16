-- Demo data for Telegram Lead Capture System
-- Safe public placeholders only.

INSERT INTO clients (
    client_slug,
    company_name,
    site_url,
    owner_tg_chat_id,
    owner_group_chat_id,
    is_active
)
VALUES (
    'demo-client',
    'Demo Company',
    'https://example.com',
    'DEMO_OWNER_CHAT_ID',
    'DEMO_GROUP_CHAT_ID',
    TRUE
)
ON CONFLICT (client_slug) DO UPDATE
SET
    company_name = EXCLUDED.company_name,
    site_url = EXCLUDED.site_url,
    owner_tg_chat_id = EXCLUDED.owner_tg_chat_id,
    owner_group_chat_id = EXCLUDED.owner_group_chat_id,
    is_active = EXCLUDED.is_active,
    updated_at = now();

-- Optional website lead test
SELECT crm_process_web_lead(
    jsonb_build_object(
        'client_slug', 'demo-client',
        'product_type', 'Steel pipe',
        'quantity', '100 pcs',
        'delivery_address', 'Demo city',
        'customer_name', 'Demo Customer',
        'customer_contact', '+7 000 000-00-00',
        'comment', 'Demo comment',
        'page_url', 'https://example.com',
        'user_agent', 'Demo browser'
    )
) AS website_lead_test;
