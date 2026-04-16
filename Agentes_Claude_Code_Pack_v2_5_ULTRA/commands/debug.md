---
name: debug
description: Debug estructurado para resolver problemas de código
version: "1.0"
agents:
  - Bug Hunter Agent
  - Observability Agent
  - Root Cause Analysis Agent
  - Performance & Efficiency Agent
args:
  - name: issue
    description: Descripción del problema o error
    required: false
    default: ""
  - name: type
    description: Tipo de bug (crash, logic, perf, data, intermittent)
    required: false
    default: "logic"
  - name: context
    description: Contexto adicional (file, function, line)
    required: false
    default: ""
---

# /debug

## Descripción

Guía estructurada para debugging. Usa metodología sistemática para identificar y resolver bugs de manera eficiente.

## Instrucciones

### Fase 0: Reproducción

**Antes de debuggear, confirma que puedes reproducir el bug.**

```markdown
### Reproduction Steps
1. Step 1
2. Step 2
3. Step 3

### Expected Behavior
What should happen

### Actual Behavior
What actually happens

### Environment
- OS: 
- Runtime: 
- Version:
```

### Fase 1: Recopilar Información (Observability Agent)

#### 1.1 Logs

```bash
# Buscar errores recientes
grep -r "ERROR\|Exception\|Error" logs/

# Logs con timestamp
tail -f logs/app.log | grep -i error

# Logs estructurados (JSON)
cat logs/app.log | jq 'select(.level == "error")'
```

#### 1.2 Stack Trace

```markdown
### Stack Trace Analysis
- **Error Type**: TypeError
- **Message**: Cannot read property 'x' of undefined
- **Location**: src/api/users.js:45
- **Call Stack**:
  1. handleRequest (server.js:123)
  2. processUser (users.js:45)
  3. validateInput (validation.js:67)
```

#### 1.3 Métricas

```markdown
### Relevant Metrics
- Error rate: 5% (normal: <0.1%)
- Latency P99: 2500ms (normal: 200ms)
- Memory: 85% (normal: 60%)
- CPU: 95% (normal: 40%)
```

### Fase 2: Formar Hipótesis (Bug Hunter Agent)

#### 2.1 Árbol de Causas Posibles

```
Bug: "Cannot read property 'x' of undefined"
│
├── Input is null/undefined
│   ├── API caller sends null
│   ├── Database returns null
│   └── Default value missing
│
├── Object not initialized
│   ├── Async race condition
│   ├── Constructor failed
│   └── Conditional initialization
│
└── Wrong variable reference
    ├── Typo in property name
    ├── Scope issue
    └── This binding problem
```

#### 2.2 Probabilidad de Cada Hipótesis

| Hipótesis | Probabilidad | Por qué |
|-----------|--------------|---------|
| Input null desde API | 70% | Error en boundary |
| Race condition | 20% | Código async |
| Typo | 10% | Código existente |

### Fase 3: Aislar el Problema

#### 3.1 Binary Search en Código

```markdown
### Bisection
1. [ ] Bug ocurre antes de línea 50? → Sí/No
2. [ ] Bug ocurre antes de línea 25? → Sí/No
3. [ ] Bug ocurre en línea 30-35? → Sí/No
4. [ ] Línea exacta: 32
```

#### 3.2 Minimal Reproduction

```javascript
// Reducir a caso mínimo
const minimalCase = {
  input: { userId: null },  // <-- Este es el trigger
  expected: { error: "Invalid user" },
  actual: "TypeError: Cannot read property 'x' of undefined"
};
```

### Fase 4: Debugging Activo

#### 4.1 Logging Estratégico

```javascript
// Agregar logs en puntos clave
console.log('[DEBUG] Input:', JSON.stringify(input));
console.log('[DEBUG] User object:', user);
console.log('[DEBUG] User.x value:', user?.x);
```

#### 4.2 Breakpoints

```markdown
### Breakpoint Strategy
1. Set breakpoint at entry point (line 40)
2. Set breakpoint before error (line 44)
3. Inspect variables at each point
4. Step through to identify exact failure
```

#### 4.3 Watch Expressions

```markdown
### Variables to Watch
- `user` - Should be object, is undefined
- `user?.id` - Should have value
- `typeof user` - Expected 'object', got 'undefined'
```

### Fase 5: Root Cause Analysis

```markdown
### 5 Whys Analysis

**Problem**: TypeError en processUser

1. **Why?** `user.x` es undefined
2. **Why?** `user` es undefined
3. **Why?** `getUser()` retorna undefined
4. **Why?** Query no encuentra usuario
5. **Why?** userId inválido pasado desde API

**Root Cause**: Falta validación de userId en API endpoint
```

### Fase 6: Fix y Verificación

#### 6.1 Implementar Fix

```javascript
// ANTES (vulnerable)
function processUser(userId) {
  const user = getUser(userId);
  return user.x;  // Crash si user es undefined
}

// DESPUÉS (robusto)
function processUser(userId) {
  if (!userId) {
    throw new ValidationError('userId is required');
  }
  
  const user = getUser(userId);
  
  if (!user) {
    throw new NotFoundError(`User ${userId} not found`);
  }
  
  return user.x;
}
```

#### 6.2 Agregar Test

```javascript
describe('processUser', () => {
  it('throws ValidationError for null userId', () => {
    expect(() => processUser(null))
      .toThrow(ValidationError);
  });

  it('throws NotFoundError for nonexistent user', () => {
    expect(() => processUser('nonexistent'))
      .toThrow(NotFoundError);
  });

  it('returns user.x for valid user', () => {
    const result = processUser('valid-id');
    expect(result).toBeDefined();
  });
});
```

#### 6.3 Verificar Fix

```markdown
### Verification Checklist
- [ ] Bug no longer reproduces
- [ ] New test passes
- [ ] Existing tests pass
- [ ] No new errors in logs
- [ ] Performance not degraded
```

## Debug por Tipo de Bug

### Crash/Exception
```
1. Capturar stack trace completo
2. Identificar línea exacta
3. Inspeccionar valores de variables
4. Verificar inputs y preconditions
```

### Logic Bug
```
1. Verificar expected vs actual output
2. Trazar flujo de datos
3. Verificar condiciones y branches
4. Revisar edge cases
```

### Performance Bug
```
1. Profile con flamegraph
2. Identificar hotspots
3. Analizar complejidad algorítmica
4. Verificar I/O y queries
```

### Intermittent Bug
```
1. Buscar race conditions
2. Verificar estado compartido
3. Revisar timing dependencies
4. Agregar logging extensivo
```

### Data Bug
```
1. Verificar data en cada paso
2. Comparar con fuente de verdad
3. Revisar transformaciones
4. Validar encoding/formatting
```

## Output

```markdown
# Debug Report

## Bug ID: BUG-2024-001
## Status: RESOLVED

### Summary
TypeError in processUser due to missing input validation.

### Root Cause
API endpoint accepts null userId without validation,
causing undefined to propagate to processUser.

### Fix
Added input validation at API boundary and defensive
checks in processUser function.

### Files Changed
- src/api/users.js (+15 lines)
- tests/api/users.test.js (+25 lines)

### Prevention
- Added ESLint rule for null checks
- Added API input validation middleware

### Time Spent
- Investigation: 30 min
- Fix: 15 min
- Testing: 15 min
```

## Ejemplos de Uso

```bash
# Debug con descripción
/debug issue="TypeError: Cannot read property 'x' of undefined"

# Debug de performance
/debug type=perf context="checkout API taking 5s"

# Debug de bug intermitente
/debug type=intermittent issue="Random 500 errors"

# Debug en archivo específico
/debug context="src/api/users.js:45"
```
