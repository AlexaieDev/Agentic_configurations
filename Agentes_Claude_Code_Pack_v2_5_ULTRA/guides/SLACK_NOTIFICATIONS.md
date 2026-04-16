# Slack Notifications Guide

Guía completa para integrar Claude Code con Slack para notificaciones, alertas y comunicación de equipo.

## Requisitos

- Workspace de Slack
- Permisos para crear Slack Apps o Bots
- Canales donde publicar

## Opciones de Integración

### Opción 1: Webhooks (Recomendado para notificaciones)

Más simple, solo permite enviar mensajes.

### Opción 2: Bot Token (Completo)

Permite enviar y leer mensajes, listar canales, etc.

## Configuración con Webhooks

### Paso 1: Crear Webhook

1. Ir a https://api.slack.com/apps
2. Click "Create New App" > "From scratch"
3. Nombre: `Claude Code Notifications`
4. Seleccionar workspace
5. Click "Create App"

### Paso 2: Activar Incoming Webhooks

1. En el menú lateral, click "Incoming Webhooks"
2. Toggle "Activate Incoming Webhooks" a ON
3. Click "Add New Webhook to Workspace"
4. Seleccionar canal destino (ej: #claude-notifications)
5. Click "Allow"
6. Copiar la Webhook URL

### Paso 3: Configurar Variable de Entorno

```bash
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/T00/B00/xxxxx"
```

### Paso 4: Probar Webhook

```bash
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Hello from Claude Code!"}' \
  $SLACK_WEBHOOK_URL
```

## Configuración con Bot Token

### Paso 1: Crear App con Bot

1. Ir a https://api.slack.com/apps
2. Click "Create New App" > "From scratch"
3. Nombre: `Claude Code Bot`
4. Seleccionar workspace

### Paso 2: Configurar Bot Scopes

En "OAuth & Permissions" > "Scopes" > "Bot Token Scopes":

```
channels:read      - Ver canales públicos
channels:history   - Leer mensajes de canales
chat:write         - Enviar mensajes
users:read         - Ver información de usuarios
files:write        - Subir archivos (opcional)
```

### Paso 3: Instalar App

1. Click "Install to Workspace"
2. Autorizar permisos
3. Copiar "Bot User OAuth Token" (xoxb-...)

### Paso 4: Configurar Variables

```bash
export SLACK_BOT_TOKEN="xoxb-your-token"
export SLACK_CHANNEL="#claude-notifications"
```

### Paso 5: Configurar MCP Server

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"
      }
    }
  }
}
```

### Paso 6: Invitar Bot al Canal

En Slack, en el canal deseado:
```
/invite @Claude Code Bot
```

## Herramientas Disponibles

### send_message
Enviar mensaje a un canal.

```
Ejemplo: "Envía 'Deploy completado' a #releases"
```

### list_channels
Listar canales disponibles.

```
Ejemplo: "Lista los canales del workspace"
```

### get_channel_history
Obtener mensajes recientes de un canal.

```
Ejemplo: "Muéstrame los últimos mensajes de #incidents"
```

### search_messages
Buscar mensajes.

```
Ejemplo: "Busca mensajes sobre 'deployment' en la última semana"
```

## Casos de Uso

### 1. Notificaciones de CI/CD

```markdown
## Deploy Notifications

Enviar a #releases cuando:
- [ ] Deploy iniciado
- [ ] Deploy completado
- [ ] Deploy fallido
- [ ] Rollback ejecutado
```

Ejemplo de mensaje:

```json
{
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "Deploy to Production"
      }
    },
    {
      "type": "section",
      "fields": [
        {"type": "mrkdwn", "text": "*Status:* Success"},
        {"type": "mrkdwn", "text": "*Version:* v2.3.4"},
        {"type": "mrkdwn", "text": "*Environment:* Production"},
        {"type": "mrkdwn", "text": "*By:* @developer"}
      ]
    }
  ]
}
```

### 2. Alertas de Incidentes

```markdown
## Incident Alerts

Enviar a #incidents cuando:
- [ ] Error rate > 5%
- [ ] Latency P99 > 2s
- [ ] Service down
```

Ejemplo de alerta:

```json
{
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "SEV2 Incident: Checkout Service"
      }
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Impact:* Checkout failing for ~10% of users\n*Started:* 14:30 UTC\n*Status:* Investigating"
      }
    },
    {
      "type": "actions",
      "elements": [
        {
          "type": "button",
          "text": {"type": "plain_text", "text": "Join Bridge"},
          "url": "https://meet.google.com/xxx"
        },
        {
          "type": "button",
          "text": {"type": "plain_text", "text": "View Dashboard"},
          "url": "https://grafana.company.com/d/checkout"
        }
      ]
    }
  ]
}
```

### 3. PR Reviews

```markdown
## Review Reminders

Enviar a #engineering cuando:
- [ ] PR sin review por 24h
- [ ] PR aprobado listo para merge
- [ ] PR con conflictos
```

### 4. Daily Standups

```markdown
## Standup Bot

Enviar a #team cada mañana:
- [ ] Resumen de ayer
- [ ] PRs pendientes de review
- [ ] Issues bloqueados
```

## Integración con Hooks

### Hook de Error

```bash
# hooks/on-error/slack-notify.sh
#!/bin/bash

curl -X POST $SLACK_WEBHOOK_URL \
  -H 'Content-type: application/json' \
  -d "{
    \"text\": \"Claude Code Error\",
    \"attachments\": [{
      \"color\": \"danger\",
      \"fields\": [
        {\"title\": \"Project\", \"value\": \"$CLAUDE_PROJECT_PATH\", \"short\": true},
        {\"title\": \"Error\", \"value\": \"$CLAUDE_ERROR_MESSAGE\", \"short\": false}
      ]
    }]
  }"
```

### Hook de Deploy

```bash
# hooks/post-deploy/slack-notify.sh
#!/bin/bash

curl -X POST $SLACK_WEBHOOK_URL \
  -H 'Content-type: application/json' \
  -d "{
    \"blocks\": [
      {
        \"type\": \"section\",
        \"text\": {
          \"type\": \"mrkdwn\",
          \"text\": \":rocket: *Deploy Successful*\n\nVersion \`$VERSION\` deployed to \`$ENVIRONMENT\`\"
        }
      }
    ]
  }"
```

## Múltiples Canales

### Configuración

```json
{
  "slack": {
    "channels": {
      "releases": "#releases",
      "incidents": "#incidents",
      "engineering": "#engineering",
      "alerts": "#alerts-critical"
    },
    "defaultChannel": "#engineering"
  }
}
```

### Routing de Mensajes

```markdown
| Tipo de Evento | Canal |
|----------------|-------|
| Deploy | #releases |
| Incident | #incidents |
| Error crítico | #alerts-critical |
| PR ready | #engineering |
| Daily summary | #team |
```

## Formato de Mensajes

### Block Kit Builder

Usar https://app.slack.com/block-kit-builder para diseñar mensajes.

### Ejemplos de Bloques

```json
// Header
{
  "type": "header",
  "text": {"type": "plain_text", "text": "Title"}
}

// Section con campos
{
  "type": "section",
  "fields": [
    {"type": "mrkdwn", "text": "*Label:* Value"}
  ]
}

// Divider
{"type": "divider"}

// Context (texto pequeño)
{
  "type": "context",
  "elements": [
    {"type": "mrkdwn", "text": "Footer text"}
  ]
}

// Actions (botones)
{
  "type": "actions",
  "elements": [
    {
      "type": "button",
      "text": {"type": "plain_text", "text": "Click"},
      "url": "https://..."
    }
  ]
}
```

## Troubleshooting

### Webhook no envía mensaje

```bash
# Verificar webhook
curl -X POST $SLACK_WEBHOOK_URL \
  -H 'Content-type: application/json' \
  -d '{"text":"test"}'

# Respuesta esperada: "ok"
```

### Bot no puede escribir en canal

```
1. Verificar que bot tiene scope chat:write
2. Verificar que bot está invitado al canal
3. /invite @YourBot en el canal
```

### Mensajes no formateados

```bash
# Usar Content-type correcto
-H 'Content-type: application/json'

# Verificar JSON válido
echo '{"text":"test"}' | jq .
```

## Best Practices

1. **Canales dedicados** - No spamear canales de trabajo
2. **Mensajes concisos** - Información esencial primero
3. **Acciones claras** - Incluir links a dashboards, PRs, etc.
4. **Colores semánticos** - Rojo=error, verde=éxito, amarillo=warning
5. **Rate limiting** - No enviar más de 1 msg/segundo

## Recursos

- [Slack Block Kit](https://api.slack.com/block-kit)
- [Block Kit Builder](https://app.slack.com/block-kit-builder)
- [Slack API Docs](https://api.slack.com/methods)
- [Webhook Guide](https://api.slack.com/messaging/webhooks)
