# Claude Code Hooks

Hooks permiten automatizar acciones en respuesta a eventos del lifecycle de Claude Code. Ejecutan scripts shell en momentos específicos para mejorar la experiencia de desarrollo.

## Eventos Disponibles

| Evento | Cuándo se Ejecuta | Uso Típico |
|--------|-------------------|------------|
| `SessionStart` | Al iniciar sesión de Claude | Cargar contexto, verificar environment |
| `PreCommit` | Antes de ejecutar `git commit` | Security scan, lint check |
| `PostToolUse` | Después de usar una herramienta | Logging, métricas |
| `OnError` | Cuando ocurre un error | Notificaciones, logging |
| `PrePush` | Antes de ejecutar `git push` | Validar branch, tests |

## Configuración

Agrega hooks en `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "command": "./hooks/session-start/load-context.sh",
        "timeout": 5000
      },
      {
        "command": "./hooks/session-start/check-env.sh",
        "timeout": 3000
      }
    ],
    "PreCommit": [
      {
        "command": "./hooks/pre-commit/security-scan.sh",
        "timeout": 30000,
        "blocking": true
      }
    ],
    "PostToolUse": [
      {
        "command": "./hooks/post-tool-use/log-actions.sh",
        "timeout": 1000,
        "blocking": false
      }
    ],
    "OnError": [
      {
        "command": "./hooks/on-error/notify.sh",
        "timeout": 5000
      }
    ],
    "PrePush": [
      {
        "command": "./hooks/pre-push/validate-branch.sh",
        "timeout": 10000,
        "blocking": true
      }
    ]
  }
}
```

## Opciones de Configuración

| Opción | Tipo | Default | Descripción |
|--------|------|---------|-------------|
| `command` | string | requerido | Comando o script a ejecutar |
| `timeout` | number | 10000 | Timeout en milisegundos |
| `blocking` | boolean | true | Si true, bloquea la acción hasta completar |
| `env` | object | {} | Variables de entorno adicionales |
| `cwd` | string | project root | Directorio de trabajo |

## Hooks Incluidos

### Session Start

| Hook | Propósito |
|------|-----------|
| `load-context.sh` | Detecta tipo de proyecto, carga contexto relevante |
| `check-env.sh` | Verifica variables de entorno necesarias |

### Pre-Commit

| Hook | Propósito |
|------|-----------|
| `security-scan.sh` | Escanea por secrets y vulnerabilidades |
| `lint-check.sh` | Verifica linting y formateo |

### Post-Tool-Use

| Hook | Propósito |
|------|-----------|
| `log-actions.sh` | Registra acciones para auditoría |

### On-Error

| Hook | Propósito |
|------|-----------|
| `notify.sh` | Envía notificaciones de errores |

### Pre-Push

| Hook | Propósito |
|------|-----------|
| `validate-branch.sh` | Valida naming de branch y estado |

## Instalación

```bash
# Copiar hooks al proyecto
cp -r hooks/ /your-project/hooks/

# Dar permisos de ejecución
chmod +x hooks/**/*.sh

# Agregar configuración a .claude/settings.json
```

## Variables de Entorno

Los hooks reciben automáticamente:

| Variable | Descripción |
|----------|-------------|
| `CLAUDE_SESSION_ID` | ID de la sesión actual |
| `CLAUDE_PROJECT_PATH` | Path del proyecto |
| `CLAUDE_EVENT` | Evento que disparó el hook |
| `CLAUDE_TOOL_NAME` | Nombre de la herramienta (PostToolUse) |
| `CLAUDE_ERROR_MESSAGE` | Mensaje de error (OnError) |

## Ejemplos de Uso

### Hook de Seguridad Estricto

```json
{
  "hooks": {
    "PreCommit": [
      {
        "command": "./hooks/pre-commit/security-scan.sh",
        "timeout": 60000,
        "blocking": true,
        "env": {
          "SCAN_LEVEL": "strict",
          "FAIL_ON_WARNING": "true"
        }
      }
    ]
  }
}
```

### Logging a Servicio Externo

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "command": "./hooks/post-tool-use/log-actions.sh",
        "env": {
          "LOG_ENDPOINT": "https://logs.company.com/api/v1/events",
          "LOG_TOKEN": "${LOG_API_TOKEN}"
        }
      }
    ]
  }
}
```

### Notificación a Slack

```json
{
  "hooks": {
    "OnError": [
      {
        "command": "./hooks/on-error/notify.sh",
        "env": {
          "SLACK_WEBHOOK_URL": "${SLACK_WEBHOOK}",
          "NOTIFY_CHANNEL": "#claude-errors"
        }
      }
    ]
  }
}
```

## Creando Hooks Personalizados

### Estructura Básica

```bash
#!/bin/bash
set -e

# Leer variables de entorno
SESSION_ID="${CLAUDE_SESSION_ID:-unknown}"
PROJECT_PATH="${CLAUDE_PROJECT_PATH:-.}"

# Tu lógica aquí
echo "Hook ejecutado en sesión: $SESSION_ID"

# Exit codes:
# 0 = éxito, continuar
# 1 = error, bloquear acción (si blocking=true)
exit 0
```

### Best Practices

1. **Siempre usar `set -e`** - Fallar rápido en errores
2. **Respetar timeouts** - No hacer operaciones largas
3. **Logging estructurado** - Usar formato JSON para logs
4. **Idempotencia** - Los hooks pueden ejecutarse múltiples veces
5. **Graceful degradation** - No fallar si servicios externos no responden

## Debugging

```bash
# Ejecutar hook manualmente
CLAUDE_SESSION_ID=test CLAUDE_PROJECT_PATH=. ./hooks/session-start/load-context.sh

# Ver logs
tail -f /tmp/claude-hooks.log

# Debug mode
DEBUG=1 ./hooks/pre-commit/security-scan.sh
```

## Troubleshooting

| Problema | Solución |
|----------|----------|
| Hook no se ejecuta | Verificar permisos `chmod +x` |
| Timeout | Aumentar `timeout` o optimizar script |
| Variables vacías | Verificar que el hook recibe el evento correcto |
| Blocking no funciona | Asegurar `blocking: true` en config |

## Integración con Agentes

Los hooks complementan a los agentes del catálogo:

- **Security Scan Hook** + **Threat Modeling Agent** = Seguridad proactiva
- **Lint Check Hook** + **Code Quality Agent** = Código limpio
- **Log Actions Hook** + **Observability Agent** = Visibilidad completa
- **Notify Hook** + **Incident Commander Agent** = Respuesta rápida
