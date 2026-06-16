-- PostgreSQL functions for Telegram Lead Capture System
-- Demo/public version. No real credentials or customer data.

CREATE OR REPLACE FUNCTION crm_process_web_lead(input_data JSONB)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
    v_client clients%ROWTYPE;
    v_lead_id BIGINT;
    v_owner_text TEXT;
BEGIN
    SELECT *
    INTO v_client
    FROM clients
    WHERE client_slug = input_data->>'client_slug'
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'ok', false,
            'message', 'Client not found'
        );
    END IF;

    IF v_client.is_active IS NOT TRUE THEN
        RETURN jsonb_build_object(
            'ok', false,
            'message', 'Client is inactive'
        );
    END IF;

    INSERT INTO leads (
        client_id,
        source,
        product_type,
        quantity,
        delivery_address,
        customer_name,
        customer_contact,
        comment,
        page_url,
        user_agent,
        raw_data
    )
    VALUES (
        v_client.id,
        'website',
        input_data->>'product_type',
        input_data->>'quantity',
        input_data->>'delivery_address',
        input_data->>'customer_name',
        input_data->>'customer_contact',
        input_data->>'comment',
        input_data->>'page_url',
        input_data->>'user_agent',
        input_data
    )
    RETURNING id INTO v_lead_id;

    v_owner_text :=
        '🔥 <b>New website lead</b>' || E'\n\n' ||
        '<b>Company:</b> ' || v_client.company_name || E'\n' ||
        '<b>Lead ID:</b> ' || v_lead_id || E'\n' ||
        '<b>Source:</b> Website form' || E'\n\n' ||
        '<b>Product:</b> ' || COALESCE(input_data->>'product_type', '-') || E'\n' ||
        '<b>Quantity:</b> ' || COALESCE(input_data->>'quantity', '-') || E'\n' ||
        '<b>Delivery:</b> ' || COALESCE(input_data->>'delivery_address', '-') || E'\n' ||
        '<b>Name:</b> ' || COALESCE(input_data->>'customer_name', '-') || E'\n' ||
        '<b>Contact:</b> ' || COALESCE(input_data->>'customer_contact', '-') || E'\n' ||
        '<b>Comment:</b> ' || COALESCE(input_data->>'comment', '-') || E'\n\n' ||
        '<b>Page:</b> ' || COALESCE(input_data->>'page_url', '-');

    RETURN jsonb_build_object(
        'ok', true,
        'message', 'Thank you! Your request has been received.',
        'lead_id', v_lead_id,
        'notify_owner', true,
        'owner_chat_id', v_client.owner_tg_chat_id,
        'owner_group_chat_id', v_client.owner_group_chat_id,
        'owner_text', v_owner_text
    );
END;
$$;

CREATE OR REPLACE FUNCTION crm_process_tg_message(input_data JSONB)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
    v_client clients%ROWTYPE;
    v_dialog tg_dialogs%ROWTYPE;
    v_lead_id BIGINT;
    v_client_slug TEXT;
    v_text TEXT;
    v_chat_id TEXT;
    v_user_id TEXT;
    v_username TEXT;
    v_first_name TEXT;
    v_last_name TEXT;
    v_public_message TEXT;
    v_owner_text TEXT;
BEGIN
    v_text := COALESCE(input_data->>'text', '');
    v_chat_id := input_data->>'chat_id';
    v_user_id := input_data->>'user_id';
    v_username := input_data->>'username';
    v_first_name := input_data->>'first_name';
    v_last_name := input_data->>'last_name';

    IF v_chat_id IS NULL OR v_chat_id = '' THEN
        RETURN jsonb_build_object(
            'ok', false,
            'public_message', 'Telegram chat_id is missing.'
        );
    END IF;

    -- Expected /start command: /start demo-client
    IF v_text LIKE '/start%' THEN
        v_client_slug := NULLIF(trim(replace(v_text, '/start', '')), '');

        IF v_client_slug IS NULL THEN
            RETURN jsonb_build_object(
                'ok', true,
                'public_message', 'Hello! To submit a request, please use the button on the company website.',
                'notify_owner', false
            );
        END IF;

        SELECT *
        INTO v_client
        FROM clients
        WHERE client_slug = v_client_slug
        LIMIT 1;

        IF NOT FOUND THEN
            RETURN jsonb_build_object(
                'ok', true,
                'public_message', 'Company was not found. Please use the button on the company website.',
                'notify_owner', false
            );
        END IF;

        IF v_client.is_active IS NOT TRUE THEN
            RETURN jsonb_build_object(
                'ok', true,
                'public_message', 'This request channel is currently unavailable.',
                'notify_owner', false
            );
        END IF;

        INSERT INTO tg_dialogs (
            client_id,
            tg_chat_id,
            tg_user_id,
            tg_username,
            tg_first_name,
            tg_last_name,
            current_step,
            is_completed
        )
        VALUES (
            v_client.id,
            v_chat_id,
            v_user_id,
            v_username,
            v_first_name,
            v_last_name,
            1,
            FALSE
        )
        ON CONFLICT (client_id, tg_chat_id) DO UPDATE
        SET
            tg_user_id = EXCLUDED.tg_user_id,
            tg_username = EXCLUDED.tg_username,
            tg_first_name = EXCLUDED.tg_first_name,
            tg_last_name = EXCLUDED.tg_last_name,
            current_step = 1,
            is_completed = FALSE,
            product_type = NULL,
            quantity = NULL,
            delivery_address = NULL,
            customer_name = NULL,
            customer_contact = NULL,
            comment = NULL,
            updated_at = now();

        v_public_message :=
            'Hello! This is ' || v_client.company_name || '.' || E'\n' ||
            'Please answer 5 short questions.' || E'\n\n' ||
            '1/5. What do you need? For example: metal, fasteners, materials, components.';

        RETURN jsonb_build_object(
            'ok', true,
            'public_message', v_public_message,
            'notify_owner', false
        );
    END IF;

    SELECT d.*
    INTO v_dialog
    FROM tg_dialogs d
    WHERE d.tg_chat_id = v_chat_id
      AND d.is_completed = FALSE
    ORDER BY d.updated_at DESC
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'ok', true,
            'public_message', 'To start submitting a request, please use the button on the company website.',
            'notify_owner', false
        );
    END IF;

    SELECT *
    INTO v_client
    FROM clients
    WHERE id = v_dialog.client_id
    LIMIT 1;

    IF NOT FOUND OR v_client.is_active IS NOT TRUE THEN
        RETURN jsonb_build_object(
            'ok', true,
            'public_message', 'This request channel is currently unavailable.',
            'notify_owner', false
        );
    END IF;

    IF v_dialog.current_step = 1 THEN
        UPDATE tg_dialogs
        SET product_type = v_text, current_step = 2, updated_at = now()
        WHERE id = v_dialog.id;

        RETURN jsonb_build_object(
            'ok', true,
            'public_message', '2/5. What quantity or approximate volume do you need?',
            'notify_owner', false
        );
    END IF;

    IF v_dialog.current_step = 2 THEN
        UPDATE tg_dialogs
        SET quantity = v_text, current_step = 3, updated_at = now()
        WHERE id = v_dialog.id;

        RETURN jsonb_build_object(
            'ok', true,
            'public_message', '3/5. Where should it be delivered? Please specify city or address.',
            'notify_owner', false
        );
    END IF;

    IF v_dialog.current_step = 3 THEN
        UPDATE tg_dialogs
        SET delivery_address = v_text, current_step = 4, updated_at = now()
        WHERE id = v_dialog.id;

        RETURN jsonb_build_object(
            'ok', true,
            'public_message', '4/5. What is your name?',
            'notify_owner', false
        );
    END IF;

    IF v_dialog.current_step = 4 THEN
        UPDATE tg_dialogs
        SET customer_name = v_text, current_step = 5, updated_at = now()
        WHERE id = v_dialog.id;

        RETURN jsonb_build_object(
            'ok', true,
            'public_message', '5/5. Please provide your phone number or Telegram username.',
            'notify_owner', false
        );
    END IF;

    IF v_dialog.current_step = 5 THEN
        UPDATE tg_dialogs
        SET customer_contact = v_text, is_completed = TRUE, updated_at = now()
        WHERE id = v_dialog.id;

        SELECT *
        INTO v_dialog
        FROM tg_dialogs
        WHERE id = v_dialog.id;

        INSERT INTO leads (
            client_id,
            source,
            product_type,
            quantity,
            delivery_address,
            customer_name,
            customer_contact,
            comment,
            tg_chat_id,
            tg_user_id,
            tg_username,
            raw_data
        )
        VALUES (
            v_client.id,
            'telegram',
            v_dialog.product_type,
            v_dialog.quantity,
            v_dialog.delivery_address,
            v_dialog.customer_name,
            v_dialog.customer_contact,
            v_dialog.comment,
            v_dialog.tg_chat_id,
            v_dialog.tg_user_id,
            v_dialog.tg_username,
            input_data
        )
        RETURNING id INTO v_lead_id;

        v_owner_text :=
            '🔥 <b>New Telegram lead</b>' || E'\n\n' ||
            '<b>Company:</b> ' || v_client.company_name || E'\n' ||
            '<b>Lead ID:</b> ' || v_lead_id || E'\n' ||
            '<b>Source:</b> Telegram bot' || E'\n\n' ||
            '<b>Product:</b> ' || COALESCE(v_dialog.product_type, '-') || E'\n' ||
            '<b>Quantity:</b> ' || COALESCE(v_dialog.quantity, '-') || E'\n' ||
            '<b>Delivery:</b> ' || COALESCE(v_dialog.delivery_address, '-') || E'\n' ||
            '<b>Name:</b> ' || COALESCE(v_dialog.customer_name, '-') || E'\n' ||
            '<b>Contact:</b> ' || COALESCE(v_dialog.customer_contact, '-') || E'\n\n' ||
            '<b>Telegram:</b> @' || COALESCE(v_dialog.tg_username, '-') || E'\n' ||
            '<b>Site:</b> ' || COALESCE(v_client.site_url, '-');

        RETURN jsonb_build_object(
            'ok', true,
            'public_message', 'Thank you! Your request has been received. A company specialist will contact you soon.',
            'lead_id', v_lead_id,
            'notify_owner', true,
            'owner_chat_id', v_client.owner_tg_chat_id,
            'owner_group_chat_id', v_client.owner_group_chat_id,
            'owner_text', v_owner_text
        );
    END IF;

    RETURN jsonb_build_object(
        'ok', true,
        'public_message', 'Please restart the request from the company website.',
        'notify_owner', false
    );
END;
$$;
