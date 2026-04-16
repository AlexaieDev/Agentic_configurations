# GitHub Integration Guide

Guía completa para integrar Claude Code con GitHub para gestión de código, issues, PRs y CI/CD.

## Requisitos

- Cuenta de GitHub
- Personal Access Token (PAT) o GitHub App
- Claude Code instalado

## Configuración

### Paso 1: Crear Personal Access Token

1. Ir a GitHub Settings > Developer settings > Personal access tokens > Fine-grained tokens
2. Click "Generate new token"
3. Configurar:
   - **Name**: `claude-code-integration`
   - **Expiration**: 90 días (recomendado)
   - **Repository access**: Seleccionar repositorios específicos
   - **Permissions**:
     ```
     Repository permissions:
     - Contents: Read and write
     - Issues: Read and write
     - Pull requests: Read and write
     - Metadata: Read
     
     Account permissions:
     - (ninguno necesario)
     ```
4. Click "Generate token" y copiar

### Paso 2: Configurar Variable de Entorno

```bash
# Agregar a ~/.zshrc o ~/.bashrc
export GITHUB_TOKEN="github_pat_xxxxx"

# O agregar a ~/.claude/.env
echo 'GITHUB_TOKEN=github_pat_xxxxx' >> ~/.claude/.env
```

### Paso 3: Configurar MCP Server

Editar `~/.claude/settings.json`:

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

### Paso 4: Verificar Conexión

```bash
# Verificar que el token funciona
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/user

# Debería mostrar tu usuario de GitHub
```

## Herramientas Disponibles

### search_code
Buscar código en repositorios.

```
Ejemplo: "Busca todas las funciones que usan fetch en mi repo"
```

### get_issue
Obtener detalles de un issue.

```
Ejemplo: "Dame los detalles del issue #123"
```

### create_issue
Crear nuevo issue.

```
Ejemplo: "Crea un bug report para el crash en checkout"
```

### update_issue
Actualizar issue existente.

```
Ejemplo: "Cierra el issue #123 con comentario de resolución"
```

### get_pr
Obtener detalles de un PR.

```
Ejemplo: "Muéstrame el PR #456 y sus cambios"
```

### create_pr
Crear pull request.

```
Ejemplo: "Crea un PR de feature/auth a main"
```

### list_commits
Listar commits.

```
Ejemplo: "Muéstrame los últimos 10 commits en main"
```

### get_file
Obtener contenido de archivo.

```
Ejemplo: "Muéstrame el contenido de package.json"
```

## Workflows Comunes

### 1. Gestión de Issues

```markdown
## Flujo de trabajo con Issues

1. Listar issues abiertos
   "Muéstrame todos los bugs abiertos sin asignar"

2. Triaje
   "Asigna el issue #123 a @developer y añade label 'priority:high'"

3. Seguimiento
   "¿Cuántos issues cerramos esta semana?"
```

### 2. Code Review

```markdown
## Flujo de Code Review

1. Ver PRs pendientes
   "Lista los PRs que necesitan mi review"

2. Revisar código
   "Muéstrame los cambios en PR #456"

3. Comentar
   "Agrega un comentario en PR #456 sobre la validación de input"

4. Aprobar/Pedir cambios
   "Aprueba el PR #456 con el comentario 'LGTM'"
```

### 3. Búsqueda de Código

```markdown
## Flujo de búsqueda

1. Buscar implementación
   "Busca dónde se define la función authenticateUser"

2. Buscar uso
   "Encuentra todos los lugares que llaman a authenticateUser"

3. Buscar patrón
   "Busca código que use console.log en producción"
```

### 4. Automatización CI/CD

```markdown
## Integración con GitHub Actions

1. Ver estado de CI
   "¿Está pasando CI en el branch feature/auth?"

2. Crear workflow
   "Crea un workflow de CI que corra tests en cada PR"

3. Debug de fallos
   "¿Por qué falló el último CI en main?"
```

## Ejemplos de Uso con Agentes

### Con Bug Hunter Agent

```markdown
"Usando el Bug Hunter Agent:
1. Busca todos los issues con label 'bug'
2. Agrupa por severidad
3. Identifica patrones comunes"
```

### Con Release Manager Agent

```markdown
"Usando el Release Manager Agent:
1. Lista todos los PRs mergeados desde el último release
2. Genera changelog
3. Crea release en GitHub"
```

### Con Code Review Agent

```markdown
"Usando el Code Review Agent:
1. Revisa el PR #456
2. Identifica issues de seguridad
3. Comenta directamente en el PR"
```

## Configuración Avanzada

### Múltiples Repos

```json
{
  "github": {
    "defaultRepo": "org/main-repo",
    "repos": {
      "api": "org/api-service",
      "web": "org/web-frontend",
      "docs": "org/documentation"
    }
  }
}
```

### GitHub Enterprise

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}",
        "GITHUB_API_URL": "https://github.mycompany.com/api/v3"
      }
    }
  }
}
```

### Rate Limiting

```json
{
  "github": {
    "rateLimit": {
      "maxRequests": 5000,
      "windowMs": 3600000,
      "retryAfter": true
    }
  }
}
```

## Troubleshooting

### Error: Bad credentials

```bash
# Verificar token
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/user

# Si falla, regenerar token
```

### Error: Not found

```bash
# Verificar permisos del token para el repo
gh auth status
gh repo view owner/repo
```

### Error: Rate limit exceeded

```bash
# Verificar rate limit
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/rate_limit

# Esperar reset o usar GitHub App para mayor límite
```

### MCP Server no responde

```bash
# Verificar que npx funciona
npx -y @modelcontextprotocol/server-github --version

# Ver logs
cat ~/.claude/logs/mcp-github.log
```

## Best Practices

1. **Tokens con scope mínimo** - Solo permisos necesarios
2. **Expiración corta** - 90 días máximo
3. **Un token por uso** - No compartir entre aplicaciones
4. **Logging de acciones** - Para auditoría
5. **Fallback a CLI** - `gh` como backup

## Recursos

- [GitHub API Docs](https://docs.github.com/en/rest)
- [GitHub CLI](https://cli.github.com/)
- [MCP GitHub Server](https://github.com/modelcontextprotocol/servers)
