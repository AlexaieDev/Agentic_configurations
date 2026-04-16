---
name: tech-debt-scan
description: Analizar y cuantificar deuda técnica del proyecto
version: "1.0"
agents:
  - Technical Debt Agent
  - Code Quality Agent
  - Refactoring Agent
  - Architecture Review Agent
args:
  - name: scope
    description: Alcance del análisis (all, code, arch, deps, tests)
    required: false
    default: "all"
  - name: threshold
    description: Score mínimo para reportar (1-10)
    required: false
    default: "3"
  - name: output
    description: Formato de output (report, backlog, json)
    required: false
    default: "report"
---

# /tech-debt-scan

## Descripción

Analiza el proyecto para identificar, categorizar y cuantificar la deuda técnica. Genera un inventario priorizado con estimaciones de esfuerzo y impacto.

## Instrucciones

### 1. Análisis de Código (Technical Debt Agent)

Buscar indicadores de deuda técnica:

#### Code Smells
- [ ] Funciones largas (>50 líneas)
- [ ] Clases grandes (>300 líneas)
- [ ] Parámetros excesivos (>5)
- [ ] Código duplicado
- [ ] Dead code (código no usado)
- [ ] Complejidad ciclomática alta (>10)

#### Comentarios de Deuda
- [ ] TODO/FIXME/HACK/XXX
- [ ] @deprecated sin plan de migración
- [ ] Workarounds documentados

#### Patrones Problemáticos
- [ ] God objects
- [ ] Spaghetti code
- [ ] Feature envy
- [ ] Shotgun surgery
- [ ] Primitive obsession

### 2. Análisis de Arquitectura (Architecture Review Agent)

- [ ] Violaciones de capas
- [ ] Dependencias circulares
- [ ] Acoplamiento excesivo
- [ ] Módulos con baja cohesión
- [ ] Abstracciones filtradas

### 3. Análisis de Dependencias

- [ ] Dependencias desactualizadas
- [ ] Dependencias abandonadas (sin commits en >1 año)
- [ ] Dependencias duplicadas
- [ ] Dependencias con vulnerabilidades
- [ ] Vendor lock-in

### 4. Análisis de Tests

- [ ] Cobertura baja (<70%)
- [ ] Tests frágiles (flaky)
- [ ] Tests lentos
- [ ] Tests con setup complejo
- [ ] Mocking excesivo

### 5. Análisis de Documentación

- [ ] README desactualizado
- [ ] API docs incompletos
- [ ] Comentarios engañosos
- [ ] Falta de ADRs

## Sistema de Scoring

### Severidad (1-10)
| Score | Nivel | Descripción |
|-------|-------|-------------|
| 9-10 | Critical | Afecta producción, debe arreglarse ya |
| 7-8 | High | Reduce velocidad significativamente |
| 5-6 | Medium | Impacto moderado en mantenibilidad |
| 3-4 | Low | Mejora deseable pero no urgente |
| 1-2 | Trivial | Nice to have |

### Esfuerzo (Story Points)
| SP | Tiempo Estimado |
|----|-----------------|
| 1 | < 2 horas |
| 2 | 2-4 horas |
| 3 | 1 día |
| 5 | 2-3 días |
| 8 | 1 semana |
| 13 | 2 semanas |
| 21 | > 2 semanas |

### ROI Score
```
ROI = (Severidad × Impacto) / Esfuerzo
```

## Output

### Resumen Ejecutivo

```markdown
# Tech Debt Scan Report
## Project: my-app
## Date: 2024-01-15
## Tech Debt Score: 34/100 (Moderate)

### Overview
| Category | Items | Total SP | Top Priority |
|----------|-------|----------|--------------|
| Code | 23 | 89 | 5 |
| Architecture | 8 | 55 | 2 |
| Dependencies | 12 | 21 | 3 |
| Tests | 6 | 34 | 1 |
| Docs | 4 | 8 | 0 |
| **Total** | **53** | **207** | **11** |

### Debt Trend
- Last month: 41/100
- This month: 34/100 (+18% improvement)
```

### Inventario Detallado

```markdown
### TD-001: God Object in UserService
- **Category**: Code Quality
- **Location**: `src/services/UserService.ts`
- **Severity**: 8/10
- **Effort**: 8 SP
- **ROI**: 4.0
- **Description**: UserService tiene 45 métodos y 1200 líneas. Maneja autenticación, perfil, preferencias, y notificaciones.
- **Impact**: Difícil de testear, alto riesgo de regresiones
- **Recommendation**: Extraer a AuthService, ProfileService, NotificationService
- **Related**: TD-003, TD-007

### TD-002: Outdated React version
- **Category**: Dependencies
- **Location**: `package.json`
- **Severity**: 6/10
- **Effort**: 5 SP
- **ROI**: 3.6
- **Description**: React 17.0.2 (current: 18.2.0)
- **Impact**: Missing concurrent features, security patches
- **Recommendation**: Upgrade siguiendo migration guide
- **Breaking Changes**: Strict mode behavior, automatic batching
```

### Backlog Priorizado

```markdown
### Sprint 1 - Quick Wins (ROI > 3)
- [ ] TD-001: Refactor UserService (8 SP)
- [ ] TD-005: Fix N+1 queries (3 SP)
- [ ] TD-012: Remove dead code (2 SP)

### Sprint 2 - Dependencies
- [ ] TD-002: Upgrade React (5 SP)
- [ ] TD-008: Update testing-library (2 SP)

### Backlog
- [ ] TD-003: Architecture cleanup (13 SP)
- [ ] TD-007: Improve test coverage (8 SP)
```

## Ejemplos de Uso

```bash
# Scan completo
/tech-debt-scan

# Solo código, threshold alto
/tech-debt-scan scope=code threshold=7

# Generar backlog para Jira
/tech-debt-scan output=backlog

# Solo dependencias
/tech-debt-scan scope=deps
```

## Métricas de Tracking

### KPIs Recomendados
- **Debt Ratio**: Tiempo en debt / tiempo en features
- **Debt Age**: Promedio de edad de items de debt
- **Paydown Rate**: Items cerrados por sprint
- **Debt Growth**: Nuevos items por sprint

### Tracking en el Tiempo

```
| Sprint | Total Debt | Paid Down | Added | Net |
|--------|------------|-----------|-------|-----|
| S1     | 207 SP     | 15 SP     | 8 SP  | -7  |
| S2     | 200 SP     | 22 SP     | 5 SP  | -17 |
| S3     | 183 SP     | 18 SP     | 12 SP | -6  |
```

## Integración con Project Management

### Linear
```bash
/tech-debt-scan output=linear
# Crea issues en Linear con labels tech-debt
```

### Jira
```bash
/tech-debt-scan output=jira
# Crea issues en Jira con component Tech Debt
```

### GitHub
```bash
/tech-debt-scan output=issues
# Crea GitHub issues con label tech-debt
```
