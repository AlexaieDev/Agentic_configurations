# MCP Server Configurations

Configuraciones pre-hechas para conectar Claude Code con herramientas externas usando [Model Context Protocol (MCP)](https://modelcontextprotocol.io/).

## Instalación

### 1. Copiar configuración a settings.json

Las configuraciones MCP se agregan al archivo `~/.claude/settings.json` o al `.claude/settings.json` del proyecto:

```json
{
  "mcpServers": {
    "github": {
      // Copiar contenido de mcp/github.json
    }
  }
}
```

### 2. Configurar variables de entorno

Cada MCP server requiere variables de entorno específicas. Configúralas en tu shell o en `.env`:

```bash
# GitHub
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"

# Jira
export JIRA_HOST="https://yourcompany.atlassian.net"
export JIRA_EMAIL="you@company.com"
export JIRA_API_TOKEN="xxxxxxxx"

# Slack
export SLACK_BOT_TOKEN="xoxb-xxxxxxxxxxxx"

# PostgreSQL
export DATABASE_URL="postgresql://user:pass@localhost:5432/db"
```

### 3. Reiniciar Claude Code

Después de modificar settings.json, reinicia Claude Code para cargar los MCP servers.

## Configuraciones Disponibles

| Archivo | Servicio | Herramientas |
|---------|----------|--------------|
| [github.json](github.json) | GitHub | Issues, PRs, code search, commits |
| [jira.json](jira.json) | Jira | Tickets, sprints, boards, JQL |
| [slack.json](slack.json) | Slack | Mensajes, canales, threads |
| [postgres.json](postgres.json) | PostgreSQL | SQL queries, schema inspection |
| [linear.json](linear.json) | Linear | Issues, projects, cycles |
| [sentry.json](sentry.json) | Sentry | Errors, releases, performance |
| [notion.json](notion.json) | Notion | Pages, databases, search |
| [supabase.json](supabase.json) | Supabase | Database, auth, storage |

## Uso con Agentes

Una vez configurado, los agentes pueden usar las herramientas MCP automáticamente:

```
# Ejemplo con Bug Hunter Agent + GitHub MCP
"Investiga el issue #123 en GitHub y propón un fix"

# Ejemplo con Incident Commander Agent + Slack MCP
"Crea un canal de incidente y notifica al equipo on-call"

# Ejemplo con Database Architect Agent + PostgreSQL MCP
"Analiza el schema actual y sugiere índices faltantes"
```

## Seguridad

- **Nunca** commits tokens o secrets a git
- Usa variables de entorno o secret managers
- Configura scopes mínimos necesarios para cada token
- Revoca tokens que ya no uses
- Revisa logs de acceso periódicamente

## Troubleshooting

### MCP server no aparece
1. Verifica que settings.json es JSON válido
2. Confirma que las variables de entorno están seteadas
3. Reinicia Claude Code completamente

### Error de autenticación
1. Verifica que el token no ha expirado
2. Confirma que el token tiene los scopes necesarios
3. Prueba el token manualmente con curl

### Timeout o lentitud
1. Verifica conectividad de red
2. Considera usar caching para queries frecuentes
3. Revisa rate limits del servicio

## Recursos

- [MCP Documentation](https://modelcontextprotocol.io/docs)
- [Claude Code MCP Guide](https://docs.anthropic.com/claude-code/mcp)
- [MCP Server Registry](https://github.com/modelcontextprotocol/servers)
