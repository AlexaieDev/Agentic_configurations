# Jira Integration Guide

Guía completa para integrar Claude Code con Jira para gestión de tickets, sprints y boards.

## Requisitos

- Instancia de Jira Cloud o Server
- API Token de Atlassian
- Acceso a los proyectos que deseas integrar

## Configuración

### Paso 1: Crear API Token

#### Jira Cloud

1. Ir a https://id.atlassian.com/manage-profile/security/api-tokens
2. Click "Create API token"
3. Nombre: `claude-code-integration`
4. Click "Create" y copiar el token

#### Jira Server/Data Center

1. Ir a Profile > Personal Access Tokens
2. Click "Create token"
3. Nombre: `claude-code-integration`
4. Permisos: `read` y `write` según necesidad
5. Copiar el token

### Paso 2: Configurar Variables de Entorno

```bash
# Para Jira Cloud
export JIRA_HOST="your-company.atlassian.net"
export JIRA_EMAIL="your-email@company.com"
export JIRA_API_TOKEN="ATATT3xxxxx"

# Para Jira Server
export JIRA_HOST="jira.company.com"
export JIRA_PERSONAL_TOKEN="your-pat-token"
```

### Paso 3: Configurar MCP Server

Editar `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-jira"],
      "env": {
        "JIRA_HOST": "${JIRA_HOST}",
        "JIRA_EMAIL": "${JIRA_EMAIL}",
        "JIRA_API_TOKEN": "${JIRA_API_TOKEN}"
      }
    }
  }
}
```

### Paso 4: Verificar Conexión

```bash
# Test de conexión
curl -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  "https://$JIRA_HOST/rest/api/3/myself"

# Debería mostrar tu perfil de Jira
```

## Herramientas Disponibles

### search_issues
Buscar issues con JQL.

```
Ejemplo: "Busca todos los bugs abiertos en el proyecto PROJ"
JQL: project = PROJ AND type = Bug AND status != Done
```

### get_issue
Obtener detalles de un issue.

```
Ejemplo: "Dame los detalles del ticket PROJ-123"
```

### create_issue
Crear nuevo issue.

```
Ejemplo: "Crea un bug en PROJ con prioridad alta"
```

### update_issue
Actualizar issue existente.

```
Ejemplo: "Mueve PROJ-123 a In Review y asigna a @developer"
```

### add_comment
Agregar comentario a issue.

```
Ejemplo: "Agrega un comentario en PROJ-123 con el análisis"
```

### list_sprints
Listar sprints del proyecto.

```
Ejemplo: "Muéstrame los sprints activos de PROJ"
```

### get_board
Obtener información del board.

```
Ejemplo: "Muéstrame el estado del board de Engineering"
```

## Workflows Comunes

### 1. Triaje de Bugs

```markdown
## Flujo de Triaje

1. Buscar bugs sin triagear
   "Busca bugs sin asignar creados esta semana"

2. Analizar
   "Dame detalles de PROJ-456"

3. Asignar y priorizar
   "Asigna PROJ-456 a @developer, prioridad Alta, Sprint 45"

4. Documentar
   "Agrega comentario en PROJ-456 con el análisis inicial"
```

### 2. Sprint Planning

```markdown
## Flujo de Sprint Planning

1. Ver backlog priorizado
   "Muestra el backlog de PROJ ordenado por prioridad"

2. Ver capacidad del sprint
   "¿Cuántos story points tenemos en Sprint 45?"

3. Mover a sprint
   "Mueve PROJ-789 al Sprint 45"

4. Verificar balance
   "Compara estimación vs capacidad del equipo"
```

### 3. Daily Standup

```markdown
## Flujo de Standup

1. Ver tareas de ayer
   "Qué tickets moví a Done ayer"

2. Ver tareas de hoy
   "Qué tickets tengo In Progress"

3. Identificar bloqueos
   "Qué tickets están bloqueados en el sprint actual"
```

### 4. Release Management

```markdown
## Flujo de Release

1. Ver tickets del release
   "Lista todos los tickets en Fix Version 2.3.0"

2. Verificar estado
   "¿Hay tickets abiertos para el release 2.3.0?"

3. Generar notas
   "Genera release notes para 2.3.0"
```

## JQL Queries Útiles

### Por Estado

```jql
# Bugs críticos abiertos
project = PROJ AND type = Bug AND priority = Critical AND status != Done

# En progreso por más de 5 días
project = PROJ AND status = "In Progress" AND updated <= -5d

# Sin actividad en 2 semanas
project = PROJ AND status != Done AND updated <= -14d
```

### Por Asignación

```jql
# Mis tareas
assignee = currentUser() AND status != Done

# Sin asignar
project = PROJ AND assignee is EMPTY AND status != Done

# Tareas de mi equipo
project = PROJ AND assignee in membersOf("engineering")
```

### Por Sprint

```jql
# Sprint actual
project = PROJ AND sprint in openSprints()

# Completados en sprint
project = PROJ AND sprint = "Sprint 45" AND status = Done

# Spillover (no completados)
project = PROJ AND sprint = "Sprint 44" AND status != Done
```

### Por Tiempo

```jql
# Creados esta semana
project = PROJ AND created >= startOfWeek()

# Resueltos hoy
project = PROJ AND resolved >= startOfDay()

# Vencidos
project = PROJ AND duedate < now() AND status != Done
```

## Ejemplos de Uso con Agentes

### Con Bug Hunter Agent

```markdown
"Usando el Bug Hunter Agent:
1. Busca bugs reportados en las últimas 24 horas
2. Categoriza por componente
3. Identifica duplicados
4. Crea tickets de investigación"
```

### Con Technical Debt Agent

```markdown
"Usando el Technical Debt Agent:
1. Lista tickets con label 'tech-debt'
2. Calcula total de story points
3. Prioriza por ROI
4. Sugiere qué incluir en próximo sprint"
```

### Con Release Manager Agent

```markdown
"Usando el Release Manager Agent:
1. Verifica que todos los tickets de 2.3.0 están Done
2. Genera release notes agrupadas por tipo
3. Crea ticket de deploy
4. Actualiza Fix Version de tickets pendientes"
```

## Configuración Avanzada

### Campos Personalizados

```json
{
  "jira": {
    "customFields": {
      "storyPoints": "customfield_10016",
      "epicLink": "customfield_10014",
      "team": "customfield_10001"
    }
  }
}
```

### Múltiples Proyectos

```json
{
  "jira": {
    "defaultProject": "PROJ",
    "projects": {
      "backend": "BACK",
      "frontend": "FRONT",
      "mobile": "MOB"
    }
  }
}
```

### Workflows Personalizados

```json
{
  "jira": {
    "transitions": {
      "start": "In Progress",
      "review": "In Review",
      "done": "Done",
      "blocked": "Blocked"
    }
  }
}
```

## Troubleshooting

### Error: 401 Unauthorized

```bash
# Verificar credenciales
curl -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  "https://$JIRA_HOST/rest/api/3/myself"

# Si falla, regenerar API token
```

### Error: 403 Forbidden

```bash
# Verificar permisos en el proyecto
# Pedir a admin que verifique:
# - Browse Projects
# - Create Issues (si necesitas crear)
# - Edit Issues (si necesitas modificar)
```

### Error: Issue not found

```bash
# Verificar que el issue existe y tienes acceso
curl -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  "https://$JIRA_HOST/rest/api/3/issue/PROJ-123"
```

### JQL syntax error

```bash
# Validar JQL en Jira web primero
# Usar el buscador avanzado para construir la query
```

## Best Practices

1. **API Token dedicado** - No usar token personal para múltiples integraciones
2. **Permisos mínimos** - Solo los permisos necesarios
3. **Cache de queries** - Queries frecuentes deben cachearse
4. **Rate limiting** - Jira Cloud tiene límites, planificar acordemente
5. **Logging** - Registrar cambios para auditoría

## Recursos

- [Jira REST API Docs](https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/)
- [JQL Reference](https://support.atlassian.com/jira-software-cloud/docs/use-advanced-search-with-jql/)
- [Atlassian API Tokens](https://id.atlassian.com/manage-profile/security/api-tokens)
