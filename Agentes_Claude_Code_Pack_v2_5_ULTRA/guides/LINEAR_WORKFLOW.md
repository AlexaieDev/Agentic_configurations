# Linear Workflow Guide

Guía completa para integrar Claude Code con Linear para project management moderno.

## Requisitos

- Cuenta de Linear
- API Key personal
- Acceso a los equipos/proyectos necesarios

## Configuración

### Paso 1: Crear API Key

1. Ir a Linear Settings (click en tu avatar)
2. Click "API" en el menú lateral
3. En "Personal API keys", click "Create key"
4. Nombre: `claude-code-integration`
5. Copiar el key (empieza con `lin_api_`)

### Paso 2: Configurar Variable de Entorno

```bash
export LINEAR_API_KEY="lin_api_xxxxx"
```

### Paso 3: Configurar MCP Server

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@linear/mcp-server"],
      "env": {
        "LINEAR_API_KEY": "${LINEAR_API_KEY}"
      }
    }
  }
}
```

### Paso 4: Verificar Conexión

```bash
curl -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ viewer { id name } }"}'
```

## Herramientas Disponibles

### search_issues
Buscar issues con filtros.

```
Ejemplo: "Busca bugs de alta prioridad sin asignar"
```

### get_issue
Obtener detalles de un issue.

```
Ejemplo: "Dame detalles de ENG-123"
```

### create_issue
Crear nuevo issue.

```
Ejemplo: "Crea un bug para el crash en checkout"
```

### update_issue
Actualizar issue existente.

```
Ejemplo: "Mueve ENG-123 a In Review"
```

### list_projects
Listar proyectos.

```
Ejemplo: "Qué proyectos hay activos?"
```

### get_project
Detalles de proyecto.

```
Ejemplo: "Cuál es el progreso de Project Alpha?"
```

### list_cycles
Listar ciclos (sprints).

```
Ejemplo: "Cuáles son los ciclos activos?"
```

### get_cycle
Detalles de ciclo.

```
Ejemplo: "Qué issues hay en el ciclo actual?"
```

### add_comment
Agregar comentario.

```
Ejemplo: "Agrega un comentario en ENG-123"
```

### list_teams
Listar equipos.

```
Ejemplo: "Qué equipos hay en el workspace?"
```

## Estados de Issues

Linear usa estados personalizables por equipo. Estados comunes:

| Estado | Descripción |
|--------|-------------|
| Backlog | Pendiente sin priorizar |
| Todo | Priorizado, listo para trabajar |
| In Progress | En desarrollo |
| In Review | En code review |
| Done | Completado |
| Canceled | Cancelado |

## Prioridades

| Nivel | Valor | Descripción |
|-------|-------|-------------|
| No Priority | 0 | Sin prioridad asignada |
| Urgent | 1 | Crítico, atender inmediatamente |
| High | 2 | Alta prioridad |
| Medium | 3 | Prioridad normal |
| Low | 4 | Baja prioridad |

## Workflows Comunes

### 1. Planificación de Sprint/Cycle

```markdown
## Sprint Planning

1. Ver backlog priorizado
   "Muestra el backlog de Engineering ordenado por prioridad"

2. Revisar capacidad
   "Cuántos story points tenemos en el ciclo actual?"

3. Mover a ciclo
   "Agrega ENG-456 al ciclo actual"

4. Asignar
   "Asigna ENG-456 a @developer"
```

### 2. Daily Standup

```markdown
## Daily Standup

1. Mis tareas de hoy
   "Qué tengo asignado In Progress?"

2. Completado ayer
   "Qué moví a Done ayer?"

3. Bloqueos
   "Hay issues con label 'blocked'?"
```

### 3. Triaje de Bugs

```markdown
## Bug Triage

1. Ver bugs nuevos
   "Lista bugs creados hoy sin asignar"

2. Evaluar severidad
   "Cuál es el impacto de BUG-789?"

3. Priorizar
   "Cambia prioridad de BUG-789 a Urgent"

4. Asignar
   "Asigna BUG-789 a @developer"
```

### 4. Seguimiento de Proyecto

```markdown
## Project Tracking

1. Ver progreso
   "Cuál es el estado de Project Alpha?"

2. Issues pendientes
   "Qué queda por hacer en Project Alpha?"

3. Milestones
   "Cuándo es el próximo milestone?"
```

## Filtros de Linear

### Por Asignación

```
# Mis issues
assignee:@me

# Sin asignar
assignee:none

# De mi equipo
team:engineering
```

### Por Estado

```
# En progreso
state:in-progress

# Todo listo para trabajar
state:todo

# No completados
-state:done -state:canceled
```

### Por Prioridad

```
# Alta prioridad
priority:1,2

# Sin prioridad
priority:0
```

### Por Ciclo

```
# Ciclo actual
cycle:current

# Sin ciclo
cycle:none
```

### Por Labels

```
# Bugs
label:bug

# Tech debt
label:tech-debt

# Con cualquier bug label
label:bug,critical-bug
```

### Combinados

```
# Bugs urgentes de mi equipo sin asignar
team:engineering type:bug priority:1 assignee:none

# Mis tareas en el ciclo actual
assignee:@me cycle:current -state:done
```

## Ejemplos de Uso con Agentes

### Con Bug Hunter Agent

```markdown
"Usando el Bug Hunter Agent:
1. Lista bugs no resueltos del ciclo
2. Agrupa por componente
3. Identifica patrones comunes
4. Crea issues de investigación para los más críticos"
```

### Con Technical Debt Agent

```markdown
"Usando el Technical Debt Agent:
1. Busca issues con label 'tech-debt'
2. Calcula total de puntos
3. Prioriza por ROI
4. Sugiere qué incluir en próximo ciclo"
```

### Con Release Manager Agent

```markdown
"Usando el Release Manager Agent:
1. Lista issues completados desde último release
2. Verifica que no hay issues críticos abiertos
3. Genera release notes
4. Prepara comunicación"
```

## Automatizaciones

### Crear Issue desde Código

```typescript
// En tu código, al detectar error
const issue = await linear.createIssue({
  teamId: "ENG",
  title: `Bug: ${error.message}`,
  description: `Stack: ${error.stack}`,
  priority: 2,
  labels: ["bug", "automated"]
});
```

### Webhook de Linear

Linear puede enviar webhooks cuando hay cambios:

```json
{
  "action": "update",
  "data": {
    "id": "abc123",
    "title": "Issue title",
    "state": {"name": "Done"}
  }
}
```

### Integración con GitHub

Linear tiene integración nativa con GitHub:

1. En Linear Settings > Integrations > GitHub
2. Conectar repositorio
3. Los issues se linkean automáticamente con PRs

## Configuración Avanzada

### Múltiples Equipos

```json
{
  "linear": {
    "teams": {
      "engineering": "ENG",
      "product": "PROD",
      "design": "DES"
    },
    "defaultTeam": "ENG"
  }
}
```

### Custom Fields

Linear soporta custom fields por equipo:

```graphql
query {
  issue(id: "abc123") {
    customFields {
      name
      value
    }
  }
}
```

## Troubleshooting

### Error: 401 Unauthorized

```bash
# Verificar API key
curl -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ viewer { id } }"}'

# Si falla, regenerar API key
```

### Error: Issue not found

```bash
# Verificar que el issue existe y tienes acceso
# Los issue IDs en Linear son case-sensitive: ENG-123, no eng-123
```

### Filtros no funcionan

```markdown
1. Verificar sintaxis de filtros
2. Los filtros son case-sensitive
3. Usar Linear UI para construir filtro primero
```

## Best Practices

1. **Naming consistente** - Prefijos claros para issues
2. **Labels organizados** - Usar labels para categorizar
3. **Cycles regulares** - Sprints de 1-2 semanas
4. **Updates frecuentes** - Mover issues entre estados
5. **Linking** - Vincular issues relacionados

## Comparación con Jira

| Feature | Linear | Jira |
|---------|--------|------|
| UI/UX | Moderno, rápido | Complejo, configurable |
| Setup | Simple | Requiere configuración |
| API | GraphQL | REST |
| Cycles | Built-in | Via Sprints en Scrum |
| Integraciones | Selectas | Extensas |

## Recursos

- [Linear Docs](https://linear.app/docs)
- [Linear API](https://developers.linear.app/docs)
- [GraphQL Explorer](https://linear.app/graphql)
- [Keyboard Shortcuts](https://linear.app/docs/keyboard-shortcuts)
