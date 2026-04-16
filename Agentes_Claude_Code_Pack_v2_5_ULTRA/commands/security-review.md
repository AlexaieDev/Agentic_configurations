---
name: security-review
description: Ejecutar revisión de seguridad completa del proyecto
version: "1.0"
agents:
  - Threat Modeling Agent
  - Vulnerability Management Agent
  - Authentication Agent
  - Authorization Agent
  - Secret Management Agent
  - Input Validation Agent
args:
  - name: scope
    description: Alcance del review (all, auth, data, api, deps)
    required: false
    default: "all"
  - name: severity
    description: Severidad mínima a reportar (critical, high, medium, low)
    required: false
    default: "medium"
  - name: output
    description: Formato de output (report, issues, json)
    required: false
    default: "report"
---

# /security-review

## Descripción

Ejecuta una revisión de seguridad completa del proyecto actual. Analiza código, configuraciones, dependencias y arquitectura para identificar vulnerabilidades y riesgos de seguridad.

## Instrucciones

Realiza el siguiente análisis de seguridad en orden:

### 1. Threat Modeling (Threat Modeling Agent)

- Identificar activos críticos del sistema
- Mapear superficies de ataque
- Enumerar amenazas usando STRIDE:
  - **S**poofing (suplantación de identidad)
  - **T**ampering (manipulación)
  - **R**epudiation (repudio)
  - **I**nformation Disclosure (divulgación)
  - **D**enial of Service (denegación de servicio)
  - **E**levation of Privilege (elevación de privilegios)
- Documentar vectores de ataque potenciales

### 2. Análisis de Autenticación (Authentication Agent)

- Revisar implementación de login/logout
- Verificar manejo de sesiones
- Auditar tokens (JWT, OAuth, API keys)
- Comprobar políticas de contraseñas
- Verificar MFA si aplica

### 3. Análisis de Autorización (Authorization Agent)

- Revisar control de acceso (RBAC, ABAC)
- Verificar enforcement en backend (no solo frontend)
- Buscar IDOR (Insecure Direct Object Reference)
- Auditar permisos de recursos

### 4. Validación de Input (Input Validation Agent)

- Buscar vulnerabilidades de inyección:
  - SQL Injection
  - XSS (Cross-Site Scripting)
  - Command Injection
  - Path Traversal
  - LDAP Injection
- Verificar sanitización de datos
- Revisar Content Security Policy

### 5. Gestión de Secrets (Secret Management Agent)

- Escanear por secrets hardcodeados
- Verificar archivos .env y configuración
- Auditar rotación de credenciales
- Verificar almacenamiento seguro

### 6. Análisis de Dependencias (Vulnerability Management Agent)

- Ejecutar `npm audit` / `pip-audit` / equivalente
- Identificar CVEs conocidos
- Evaluar criticidad de vulnerabilidades
- Sugerir actualizaciones

## Checklist de Output

Generar reporte con las siguientes secciones:

### Resumen Ejecutivo
- [ ] Puntuación de seguridad general (A-F)
- [ ] Conteo de findings por severidad
- [ ] Top 3 riesgos críticos

### Findings Detallados
Para cada finding:
- [ ] ID único (SEC-001, SEC-002...)
- [ ] Severidad (Critical/High/Medium/Low)
- [ ] Categoría (Auth, Injection, Config, etc.)
- [ ] Descripción del problema
- [ ] Impacto potencial
- [ ] Pasos de reproducción
- [ ] Remediación recomendada
- [ ] Referencia (CWE, OWASP)

### Matriz de Riesgos
- [ ] Tabla de probabilidad vs impacto
- [ ] Priorización de remediación

### Recomendaciones
- [ ] Quick wins (fácil de arreglar, alto impacto)
- [ ] Mejoras a mediano plazo
- [ ] Mejoras arquitecturales

## Scopes Disponibles

| Scope | Qué Analiza |
|-------|-------------|
| `all` | Análisis completo |
| `auth` | Solo autenticación y autorización |
| `data` | Solo validación de datos e inyecciones |
| `api` | Solo endpoints de API |
| `deps` | Solo dependencias |

## Ejemplos de Uso

```bash
# Review completo
/security-review

# Solo autenticación, severidad alta
/security-review scope=auth severity=high

# Generar issues de GitHub
/security-review output=issues

# Solo dependencias
/security-review scope=deps
```

## Integración con CI/CD

```yaml
# .github/workflows/security.yml
name: Security Review
on:
  pull_request:
    branches: [main]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Security Review
        run: claude-code --command "/security-review severity=high output=json"
```

## Output de Ejemplo

```markdown
# Security Review Report
## Project: my-app
## Date: 2024-01-15
## Score: C (67/100)

### Summary
- Critical: 1
- High: 3
- Medium: 8
- Low: 12

### Critical Findings

#### SEC-001: SQL Injection in User Search
- **Severity**: Critical
- **Location**: `src/api/users.js:45`
- **CWE**: CWE-89
- **Impact**: Permite acceso no autorizado a la base de datos
- **Fix**: Usar consultas parametrizadas

```javascript
// Vulnerable
const query = `SELECT * FROM users WHERE name = '${userInput}'`;

// Fixed
const query = 'SELECT * FROM users WHERE name = $1';
db.query(query, [userInput]);
```

...
```
