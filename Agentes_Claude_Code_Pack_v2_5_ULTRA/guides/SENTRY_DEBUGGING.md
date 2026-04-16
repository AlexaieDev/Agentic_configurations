# Sentry Debugging Guide

Guía completa para integrar Claude Code con Sentry para error tracking y debugging.

## Requisitos

- Cuenta de Sentry (cloud o self-hosted)
- Auth token con permisos adecuados
- Proyecto configurado en Sentry

## Configuración

### Paso 1: Crear Auth Token

1. Ir a Sentry Settings > Auth Tokens
2. Click "Create New Token"
3. Seleccionar scopes:
   ```
   project:read     - Ver proyectos
   project:write    - Modificar proyectos (opcional)
   org:read         - Ver organización
   issue:read       - Ver issues
   issue:write      - Modificar issues
   event:read       - Ver eventos
   ```
4. Click "Create Token" y copiar

### Paso 2: Configurar Variables de Entorno

```bash
export SENTRY_AUTH_TOKEN="sntrys_xxxxx"
export SENTRY_ORG="your-org-slug"
export SENTRY_PROJECT="your-project"  # Opcional: proyecto default
```

### Paso 3: Configurar MCP Server

```json
{
  "mcpServers": {
    "sentry": {
      "command": "npx",
      "args": ["-y", "@sentry/mcp-server"],
      "env": {
        "SENTRY_AUTH_TOKEN": "${SENTRY_AUTH_TOKEN}",
        "SENTRY_ORG": "${SENTRY_ORG}",
        "SENTRY_PROJECT": "${SENTRY_PROJECT}"
      }
    }
  }
}
```

### Paso 4: Verificar Conexión

```bash
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/"

# Debería mostrar info de tu organización
```

## Herramientas Disponibles

### list_issues
Listar issues con filtros.

```
Ejemplo: "Muéstrame los errores sin resolver de las últimas 24 horas"
```

### get_issue
Obtener detalles de un issue.

```
Ejemplo: "Dame detalles del error PROJ-ABC123"
```

### get_issue_events
Ver eventos/ocurrencias de un issue.

```
Ejemplo: "Muéstrame las últimas ocurrencias del error"
```

### resolve_issue
Marcar issue como resuelto.

```
Ejemplo: "Resuelve el issue PROJ-ABC123"
```

### list_releases
Listar releases del proyecto.

```
Ejemplo: "Qué releases hay en producción?"
```

### get_release
Detalles de un release.

```
Ejemplo: "Muéstrame stats del release 2.3.4"
```

### list_transactions
Listar transacciones de performance.

```
Ejemplo: "Cuáles son las transacciones más lentas?"
```

## Workflows de Debugging

### 1. Triaje de Errores

```markdown
## Flujo de Triaje

1. Ver errores nuevos
   "Muéstrame errores nuevos de las últimas 24h"

2. Priorizar por impacto
   "Ordena por número de usuarios afectados"

3. Investigar el más crítico
   "Dame stack trace del error más frecuente"

4. Asignar
   "Asigna PROJ-123 a @developer"
```

### 2. Debugging de Error Específico

```markdown
## Flujo de Debug

1. Obtener contexto
   "Dame detalles completos del issue PROJ-ABC123"

2. Analizar stack trace
   "Cuál es la línea de código que falla?"

3. Ver eventos recientes
   "Muéstrame las últimas 10 ocurrencias"

4. Identificar patrón
   "Qué tienen en común estos eventos?"

5. Buscar en código
   "Muéstrame el código en file.js:123"
```

### 3. Análisis de Release

```markdown
## Flujo de Release Analysis

1. Ver releases recientes
   "Lista los últimos 5 releases"

2. Comparar error rates
   "Compara errores entre v2.3.3 y v2.3.4"

3. Identificar regresiones
   "Qué errores nuevos aparecieron en v2.3.4?"

4. Evaluar rollback
   "El error rate justifica un rollback?"
```

### 4. Performance Investigation

```markdown
## Flujo de Performance

1. Ver transacciones lentas
   "Cuáles son las 10 transacciones más lentas?"

2. Analizar endpoint
   "Dame detalles de /api/checkout"

3. Ver spans
   "Qué operaciones toman más tiempo?"

4. Identificar bottleneck
   "La query de DB está tardando 2s"
```

## Queries de Sentry

### Por Estado

```
# No resueltos
is:unresolved

# Nuevos (primera vez)
is:unresolved is:new

# Ignorados
is:ignored

# Asignados a mí
assigned:me
```

### Por Tiempo

```
# Últimas 24 horas
lastSeen:-24h

# Esta semana
firstSeen:-7d

# Hoy
lastSeen:-1d
```

### Por Impacto

```
# Alta frecuencia
times_seen:>100

# Muchos usuarios afectados
users_count:>50

# En ambiente específico
environment:production
```

### Por Tipo

```
# Solo errores (no warnings)
level:error

# Específico tipo de error
error.type:TypeError

# En archivo específico
stack.filename:**/api/users.js
```

### Combinados

```
# Errores críticos de producción no resueltos
is:unresolved environment:production level:error times_seen:>100

# Nuevos errores de hoy en API
is:unresolved is:new firstSeen:-1d stack.filename:**/api/**

# Mis errores asignados de alta prioridad
assigned:me is:unresolved priority:high
```

## Ejemplos de Uso con Agentes

### Con Bug Hunter Agent

```markdown
"Usando el Bug Hunter Agent:
1. Lista errores no resueltos de las últimas 24h
2. Agrupa por tipo de error
3. Identifica el error más crítico
4. Analiza stack trace
5. Sugiere fix basado en el código"
```

### Con Incident Commander Agent

```markdown
"Usando el Incident Commander Agent:
1. Detecta spike de errores
2. Identifica release causante
3. Evalúa impacto en usuarios
4. Recomienda: fix forward o rollback
5. Prepara comunicación"
```

### Con Release Manager Agent

```markdown
"Usando el Release Manager Agent:
1. Compara error rates entre releases
2. Lista regresiones introducidas
3. Verifica que errores críticos estén resueltos
4. Da go/no-go para deploy"
```

## Integración con Desarrollo

### Resolver desde Commit

```markdown
## Workflow de Fix

1. Identificar issue en Sentry
2. Encontrar código problemático
3. Crear fix
4. En commit message:
   `Fixes PROJ-ABC123`
5. Sentry auto-resuelve al deployar
```

### Source Maps

Para debugging efectivo, asegurar que source maps estén configurados:

```javascript
// sentry.config.js
Sentry.init({
  dsn: "https://xxx@sentry.io/xxx",
  release: process.env.VERSION,
  environment: process.env.NODE_ENV,
});
```

```bash
# Upload source maps
sentry-cli releases files VERSION upload-sourcemaps ./dist
```

### Alertas

Configurar alertas para notificación temprana:

```yaml
# Alerta de error rate
- name: High Error Rate
  conditions:
    - type: event_frequency
      value: 100
      interval: 1h
  actions:
    - type: slack
      channel: #alerts
```

## Troubleshooting

### Error: 401 Unauthorized

```bash
# Verificar token
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/"

# Si falla, regenerar token
```

### Error: 404 Not Found

```bash
# Verificar org slug
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/organizations/$SENTRY_ORG/"

# Verificar project slug
curl -H "Authorization: Bearer $SENTRY_AUTH_TOKEN" \
  "https://sentry.io/api/0/projects/$SENTRY_ORG/$SENTRY_PROJECT/"
```

### Issues no aparecen

```markdown
1. Verificar que SDK está enviando eventos
2. Verificar filtros de sampling
3. Verificar rate limits
4. Verificar data retention
```

### Stack traces no legibles

```markdown
1. Verificar que source maps están uploaded
2. Verificar que release coincide
3. Verificar que archivos están mapeados correctamente
```

## Best Practices

1. **Source maps** - Siempre uploadear para debugging efectivo
2. **Releases** - Tagear cada deploy con versión
3. **Environment** - Separar prod/staging/dev
4. **Breadcrumbs** - Agregar contexto para debugging
5. **User context** - Incluir info de usuario (sin PII)
6. **Sampling** - Configurar apropiadamente para no perder errores críticos

## Configuración Avanzada

### Múltiples Proyectos

```json
{
  "sentry": {
    "projects": {
      "api": "api-service",
      "web": "web-frontend",
      "mobile": "mobile-app"
    },
    "defaultProject": "api-service"
  }
}
```

### Self-Hosted Sentry

```json
{
  "mcpServers": {
    "sentry": {
      "env": {
        "SENTRY_URL": "https://sentry.mycompany.com",
        "SENTRY_AUTH_TOKEN": "${SENTRY_AUTH_TOKEN}"
      }
    }
  }
}
```

## Recursos

- [Sentry Docs](https://docs.sentry.io/)
- [Sentry CLI](https://docs.sentry.io/product/cli/)
- [Sentry API](https://docs.sentry.io/api/)
- [Source Maps Guide](https://docs.sentry.io/platforms/javascript/sourcemaps/)
