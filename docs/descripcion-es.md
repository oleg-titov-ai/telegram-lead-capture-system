# Descripción del proyecto — Telegram Lead Capture System

## Resumen

**Telegram Lead Capture System** es una automatización para recibir solicitudes desde un formulario web o un bot de Telegram, guardarlas en PostgreSQL y notificar inmediatamente a un gerente o grupo de ventas.

La solución utiliza n8n como orquestador y puede adaptarse a varios clientes, sitios web o sucursales.

## Funciones principales

- formulario de captación en el sitio web;
- bot de Telegram con preguntas breves;
- almacenamiento de leads en PostgreSQL;
- estado de conversación del bot;
- notificaciones para gerentes;
- configuración multi-cliente;
- placeholders seguros para demostración.

## Flujo del formulario web

```text
Formulario web
      ↓
Webhook de n8n
      ↓
Validación y normalización
      ↓
PostgreSQL
      ↓
Notificación en Telegram
```

## Flujo del bot

```text
Cliente abre el bot
      ↓
Bot hace preguntas
      ↓
PostgreSQL guarda el estado
      ↓
Lead completado
      ↓
Aviso al gerente
```

## Valor para el negocio

- respuesta más rápida;
- menos leads perdidos;
- base de datos centralizada;
- despliegue reutilizable;
- integración futura con CRM;
- coste menor que un CRM personalizado completo.

## Seguridad

El repositorio público no debe contener tokens, contraseñas, IDs reales, URLs privadas de webhooks ni datos reales de clientes.
