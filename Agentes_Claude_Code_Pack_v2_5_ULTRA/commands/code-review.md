---
name: code-review
description: Ejecutar code review estructurado y exhaustivo
version: "1.0"
agents:
  - Code Review Agent
  - Security Agent
  - Performance & Efficiency Agent
  - Test Architect Agent
args:
  - name: target
    description: PR number, commit, branch, o file path
    required: false
    default: "HEAD"
  - name: focus
    description: Enfoque del review (all, security, perf, tests, style)
    required: false
    default: "all"
  - name: depth
    description: Profundidad (quick, standard, thorough)
    required: false
    default: "standard"
---

# /code-review

## Descripción

Ejecuta un code review estructurado y exhaustivo. Analiza cambios desde múltiples perspectivas: correctitud, seguridad, performance, mantenibilidad y tests.

## Instrucciones

### Fase 1: Contexto

#### 1.1 Entender el Cambio
```
[ ] Leer PR description / commit message
[ ] Identificar el problema que resuelve
[ ] Entender el approach elegido
[ ] Revisar tickets relacionados
```

#### 1.2 Obtener Diff
```bash
# Para PR
gh pr diff <number>

# Para commit
git show <commit>

# Para branch
git diff main...<branch>

# Para archivo
git diff HEAD -- <file>
```

### Fase 2: Review por Categoría

#### 2.1 Correctitud (Code Review Agent)

```markdown
### Correctness Checklist
- [ ] Lógica correcta y completa
- [ ] Edge cases manejados
- [ ] Error handling apropiado
- [ ] No hay bugs obvios
- [ ] Cumple con los requisitos
```

**Buscar:**
- Off-by-one errors
- Null/undefined handling
- Race conditions
- Resource leaks
- Infinite loops
- Type mismatches

#### 2.2 Seguridad (Security Agent)

```markdown
### Security Checklist
- [ ] No hay injection vulnerabilities
- [ ] Input validation presente
- [ ] Auth/authz correctos
- [ ] No secrets hardcodeados
- [ ] Crypto usado correctamente
- [ ] Data sanitizada antes de output
```

**Buscar:**
- SQL/NoSQL injection
- XSS
- Command injection
- Path traversal
- SSRF
- Insecure deserialization

#### 2.3 Performance (Performance & Efficiency Agent)

```markdown
### Performance Checklist
- [ ] No hay N+1 queries
- [ ] Complejidad algorítmica razonable
- [ ] Memory efficient
- [ ] No hay blocking operations
- [ ] Caching considerado
- [ ] Lazy loading donde aplica
```

**Buscar:**
- Loops innecesarios
- Queries en loops
- Large object copies
- Sync I/O en hot paths
- Missing indexes
- Memory leaks

#### 2.4 Mantenibilidad

```markdown
### Maintainability Checklist
- [ ] Código legible y claro
- [ ] Naming descriptivo
- [ ] Funciones pequeñas y enfocadas
- [ ] DRY (no duplicación)
- [ ] Comentarios donde necesario
- [ ] Sigue convenciones del proyecto
```

**Buscar:**
- Magic numbers
- Deep nesting
- Long functions
- God classes
- Tight coupling
- Missing abstractions

#### 2.5 Tests (Test Architect Agent)

```markdown
### Testing Checklist
- [ ] Tests agregados para nuevo código
- [ ] Tests actualizados para cambios
- [ ] Coverage adecuada
- [ ] Tests son mantenibles
- [ ] Edge cases cubiertos
- [ ] No hay tests flaky
```

**Buscar:**
- Missing tests
- Tests sin assertions
- Over-mocking
- Flaky tests
- Slow tests

### Fase 3: Comentarios

#### Niveles de Severidad

| Nivel | Prefix | Descripción |
|-------|--------|-------------|
| Blocker | 🚫 | Debe arreglarse antes de merge |
| Major | ⚠️ | Debería arreglarse |
| Minor | 💡 | Sugerencia de mejora |
| Nitpick | 📝 | Preferencia de estilo |
| Question | ❓ | Necesita clarificación |
| Praise | 👍 | Buen trabajo |

#### Formato de Comentario

```markdown
🚫 **Security**: SQL Injection vulnerability

**File**: `src/api/users.js:45`

**Issue**: User input concatenado directamente en query SQL.

**Current**:
```javascript
const query = `SELECT * FROM users WHERE id = ${userId}`;
```

**Suggested**:
```javascript
const query = 'SELECT * FROM users WHERE id = $1';
const result = await db.query(query, [userId]);
```

**Reference**: CWE-89, OWASP A03:2021
```

### Fase 4: Resumen

```markdown
## Code Review Summary

### PR: #123 - Add user search feature
### Reviewer: @reviewer
### Date: 2024-01-15

### Verdict: REQUEST CHANGES

### Statistics
| Category | Comments |
|----------|----------|
| 🚫 Blocker | 2 |
| ⚠️ Major | 3 |
| 💡 Minor | 5 |
| 📝 Nitpick | 2 |
| 👍 Praise | 3 |

### Summary
El feature está bien implementado en general, pero hay 2 issues
de seguridad que deben arreglarse antes del merge.

### Blockers
1. SQL Injection en `users.js:45`
2. Missing auth check en `admin.js:23`

### Highlights
- Buen uso de caching
- Tests comprehensivos
- Código limpio y legible

### Action Items
- [ ] Fix SQL injection
- [ ] Add auth middleware
- [ ] Consider adding rate limiting
```

## Output

### Review Report
```markdown
# Code Review: PR #123

## Overview
| Metric | Value |
|--------|-------|
| Files changed | 12 |
| Additions | +345 |
| Deletions | -89 |
| Complexity | Medium |

## Verdict
🔴 REQUEST CHANGES

## Comments by File

### src/api/users.js
| Line | Type | Comment |
|------|------|---------|
| 45 | 🚫 | SQL Injection |
| 67 | ⚠️ | Missing error handling |
| 89 | 💡 | Consider extracting to helper |

### src/services/UserService.ts
| Line | Type | Comment |
|------|------|---------|
| 23 | ⚠️ | N+1 query |
| 45 | 👍 | Nice caching implementation |

## Recommendations
1. Fix security issues (blockers)
2. Add error handling
3. Consider performance optimization
```

## Ejemplos de Uso

```bash
# Review del HEAD commit
/code-review

# Review de PR específico
/code-review target=123

# Review de branch
/code-review target=feature/user-auth

# Review rápido enfocado en seguridad
/code-review focus=security depth=quick

# Review exhaustivo
/code-review depth=thorough

# Review de archivo específico
/code-review target=src/api/users.js
```

## Integración con GitHub

```bash
# Agregar comentarios a PR
/code-review target=123 --post-comments

# Aprobar PR si pasa
/code-review target=123 --auto-approve

# Bloquear merge si hay blockers
/code-review target=123 --strict
```
