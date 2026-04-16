# Slash Commands

Commands rápidos invocables para tareas comunes de desarrollo. Cada comando activa uno o más agentes del catálogo con instrucciones específicas.

## Uso

```
/command-name [argumentos opcionales]
```

## Commands Disponibles

| Command | Propósito | Agentes |
|---------|-----------|---------|
| `/security-review` | Auditoría de seguridad completa | Threat Modeling, Vulnerability Management |
| `/ship-checklist` | Checklist pre-deploy | Release Manager, SRE |
| `/tech-debt-scan` | Análisis de deuda técnica | Technical Debt, Code Quality |
| `/incident-start` | Iniciar incident response | Incident Commander, SRE |
| `/standup` | Generar update de standup | - |
| `/code-review` | Code review estructurado | Code Review, Security |
| `/api-design` | Diseñar API endpoint | API Design, OpenAPI |
| `/debug` | Debug estructurado | Bug Hunter, Observability |

## Configuración

Para habilitar commands en tu proyecto, agrega a `.claude/settings.json`:

```json
{
  "commands": {
    "enabled": true,
    "directory": "./commands"
  }
}
```

## Estructura de un Command

Cada command es un archivo Markdown con frontmatter YAML:

```markdown
---
name: command-name
description: Descripción corta
agents:
  - Agent Name 1
  - Agent Name 2
args:
  - name: target
    description: Archivo o directorio objetivo
    required: false
    default: "."
---

# /command-name

## Descripción

Explicación detallada de lo que hace el command.

## Instrucciones

1. Paso 1
2. Paso 2
3. Paso 3

## Output Esperado

- Item 1
- Item 2
```

## Creando Commands Personalizados

### 1. Crear archivo

```bash
touch commands/my-command.md
```

### 2. Definir frontmatter

```yaml
---
name: my-command
description: Mi command personalizado
agents:
  - Code Quality Agent
args:
  - name: scope
    description: Alcance del análisis
    required: true
---
```

### 3. Escribir instrucciones

Las instrucciones deben ser claras y específicas. Claude seguirá estas instrucciones al invocar el command.

### 4. Probar

```
/my-command scope=src/
```

## Best Practices

1. **Nombres descriptivos** - El nombre debe indicar claramente qué hace
2. **Argumentos opcionales** - Usa defaults razonables
3. **Agentes específicos** - Referencia solo agentes que existen en el catálogo
4. **Output estructurado** - Define qué esperas como resultado
5. **Idempotencia** - El command debería poder ejecutarse múltiples veces

## Categorías

### Seguridad
- `/security-review` - Auditoría completa
- Pre-commit hooks complementarios

### Deployment
- `/ship-checklist` - Pre-deploy
- Integra con CI/CD

### Calidad
- `/tech-debt-scan` - Deuda técnica
- `/code-review` - Review estructurado

### Incidentes
- `/incident-start` - Iniciar respuesta
- Integra con Slack/PagerDuty

### Desarrollo
- `/api-design` - Diseño de APIs
- `/debug` - Debugging estructurado

### Productividad
- `/standup` - Updates diarios
