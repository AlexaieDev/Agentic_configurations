# Integration Guides

Guías paso a paso para integrar Claude Code con herramientas externas mediante MCP servers.

## Guías Disponibles

| Guía | Herramienta | Propósito |
|------|-------------|-----------|
| [GITHUB_WORKFLOW](GITHUB_WORKFLOW.md) | GitHub | CI/CD, Issues, PRs |
| [JIRA_INTEGRATION](JIRA_INTEGRATION.md) | Jira | Gestión de tickets |
| [SLACK_NOTIFICATIONS](SLACK_NOTIFICATIONS.md) | Slack | Notificaciones y alertas |
| [DATABASE_QUERIES](DATABASE_QUERIES.md) | PostgreSQL | Consultas SQL seguras |
| [SENTRY_DEBUGGING](SENTRY_DEBUGGING.md) | Sentry | Error tracking |
| [LINEAR_WORKFLOW](LINEAR_WORKFLOW.md) | Linear | Project management |
| [SUPABASE_SETUP](SUPABASE_SETUP.md) | Supabase | Database + Auth |
| [NOTION_DOCS](NOTION_DOCS.md) | Notion | Documentación |

## Requisitos Previos

1. **Claude Code** instalado y configurado
2. **Node.js** v18+ para MCP servers
3. **Credenciales** de los servicios a integrar

## Configuración General

### 1. Instalar MCP Server

```bash
# La mayoría de MCP servers se instalan automáticamente
# al configurarlos en settings.json

# Para instalación manual:
npm install -g @modelcontextprotocol/server-<name>
```

### 2. Configurar Variables de Entorno

```bash
# Opción 1: Export directo
export GITHUB_TOKEN="ghp_xxx"

# Opción 2: Archivo .env
echo 'GITHUB_TOKEN=ghp_xxx' >> ~/.claude/.env

# Opción 3: En settings.json
```

### 3. Actualizar settings.json

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### 4. Reiniciar Claude Code

```bash
claude-code restart
# o simplemente iniciar una nueva sesión
```

## Verificar Integración

```bash
# Listar MCP servers activos
claude-code mcp list

# Probar herramienta específica
claude-code mcp test github search_code "test"
```

## Troubleshooting Común

### MCP Server no inicia

```bash
# Verificar que npx funciona
npx -y @modelcontextprotocol/server-github --help

# Verificar logs
tail -f ~/.claude/logs/mcp-*.log
```

### Variable de entorno no encontrada

```bash
# Verificar que está definida
echo $GITHUB_TOKEN

# Si usas .env, verificar path
cat ~/.claude/.env
```

### Timeout en herramientas

```json
{
  "mcpServers": {
    "github": {
      "timeout": 60000  // Aumentar timeout
    }
  }
}
```

## Best Practices

1. **Mínimos privilegios** - Solo dar permisos necesarios
2. **Secrets seguros** - Usar env vars, no hardcodear
3. **Timeout apropiado** - Ajustar según operación
4. **Logging** - Habilitar logs para debugging
5. **Fallback** - Tener plan si servicio falla

## Seguridad

### Tokens y Credenciales

- Nunca commitear tokens
- Rotar regularmente
- Usar tokens con scope mínimo
- Revocar tokens no usados

### Permisos de MCP

```json
{
  "mcpServers": {
    "database": {
      "permissions": ["read"],  // Solo lectura
      "env": {
        "DATABASE_URL": "..."
      }
    }
  }
}
```

## Soporte

Para problemas con integraciones:

1. Revisar la guía específica
2. Verificar logs de MCP
3. Consultar documentación del servicio
4. Abrir issue en el repositorio
