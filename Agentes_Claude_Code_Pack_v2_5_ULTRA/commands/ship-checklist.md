---
name: ship-checklist
description: Checklist pre-deploy para asegurar que todo está listo para producción
version: "1.0"
agents:
  - Release Manager Agent
  - SRE Agent
  - Performance & Efficiency Agent
  - Observability Agent
  - Security Agent
args:
  - name: environment
    description: Ambiente destino (staging, production)
    required: false
    default: "production"
  - name: type
    description: Tipo de release (feature, hotfix, major)
    required: false
    default: "feature"
  - name: skip
    description: Checks a saltar (tests, security, perf)
    required: false
    default: ""
---

# /ship-checklist

## Descripción

Ejecuta una verificación completa pre-deploy para asegurar que el código está listo para producción. Valida tests, seguridad, performance, observabilidad y configuración.

## Instrucciones

Ejecutar los siguientes checks en orden:

### 1. Pre-requisitos

```
[ ] Branch está actualizado con main/master
[ ] No hay conflictos de merge pendientes
[ ] Todos los commits tienen mensajes descriptivos
[ ] PR aprobado (si aplica)
```

### 2. Tests (Release Manager Agent)

```
[ ] Unit tests pasan (100%)
[ ] Integration tests pasan
[ ] E2E tests pasan
[ ] Test coverage >= umbral definido
[ ] No hay tests skipped sin razón documentada
[ ] Smoke tests preparados para post-deploy
```

Ejecutar:
```bash
npm test
npm run test:integration
npm run test:e2e
npm run coverage
```

### 3. Seguridad (Security Agent)

```
[ ] No hay secrets en el código
[ ] Dependencias sin vulnerabilidades críticas
[ ] Headers de seguridad configurados
[ ] HTTPS enforced
[ ] Input validation en todos los endpoints
[ ] Rate limiting configurado
```

Ejecutar:
```bash
npm audit
./hooks/pre-commit/security-scan.sh
```

### 4. Performance (Performance & Efficiency Agent)

```
[ ] Bundle size dentro de límites
[ ] No hay regresiones de performance
[ ] Queries optimizadas (no N+1)
[ ] Imágenes optimizadas
[ ] Caching configurado correctamente
[ ] CDN configurado (si aplica)
```

Verificar:
```bash
npm run build -- --analyze
lighthouse https://staging.app.com
```

### 5. Observabilidad (Observability Agent)

```
[ ] Logging estructurado implementado
[ ] Métricas de negocio definidas
[ ] Health checks configurados
[ ] Alertas configuradas
[ ] Dashboards actualizados
[ ] Tracing habilitado
```

Verificar endpoints:
```
GET /health
GET /ready
GET /metrics
```

### 6. Infraestructura (SRE Agent)

```
[ ] Variables de entorno configuradas en target env
[ ] Secrets rotados si es necesario
[ ] Database migrations listas
[ ] Rollback plan documentado
[ ] Capacidad verificada (scaling)
[ ] DNS/Load balancer configurado
```

### 7. Documentación

```
[ ] CHANGELOG actualizado
[ ] API docs actualizados (si hay cambios)
[ ] Runbook actualizado
[ ] README actualizado (si aplica)
[ ] Release notes preparadas
```

### 8. Comunicación

```
[ ] Stakeholders notificados
[ ] Ventana de deploy acordada
[ ] On-call asignado
[ ] Canales de comunicación listos
```

## Output

### Checklist Interactivo

```markdown
# Ship Checklist - v2.3.0 -> Production
## Date: 2024-01-15 14:30 UTC
## Author: @developer

### Summary
- [x] 15/18 checks passed
- [ ] 3 items need attention

### Detailed Results

#### Tests
- [x] Unit tests: 234/234 passed (100%)
- [x] Integration: 45/45 passed
- [x] E2E: 12/12 passed
- [x] Coverage: 87% (threshold: 80%)

#### Security
- [x] No secrets detected
- [ ] npm audit: 2 moderate vulnerabilities
      Action: Review and update lodash
- [x] Headers: OK
- [x] HTTPS: Enforced

#### Performance
- [x] Bundle: 245KB (limit: 300KB)
- [ ] Lighthouse: 72 (target: 80)
      Action: Optimize LCP
- [x] No N+1 queries detected

#### Infrastructure
- [x] Env vars: All set
- [x] Migrations: 2 pending, tested
- [x] Rollback: Documented

### Blockers
1. npm audit vulnerabilities - Low risk, proceed with caution
2. Lighthouse score - Non-blocking for this release

### Recommendation
READY TO SHIP with noted items in follow-up ticket
```

## Tipos de Release

### Feature Release
- Full checklist
- Puede deployarse en horario normal

### Hotfix
- Checklist reducido (tests + security)
- Deploy inmediato permitido
- Post-mortem requerido

### Major Release
- Full checklist + extra validations
- Ventana de deploy extendida
- Comunicación a todos los stakeholders
- Rollback plan obligatorio

## Ejemplos de Uso

```bash
# Checklist completo para producción
/ship-checklist

# Hotfix rápido
/ship-checklist type=hotfix skip=perf

# Deploy a staging
/ship-checklist environment=staging

# Saltar tests (no recomendado)
/ship-checklist skip=tests
```

## Integración con CI/CD

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  workflow_dispatch:
    inputs:
      release_type:
        description: 'Release type'
        required: true
        default: 'feature'
        type: choice
        options:
          - feature
          - hotfix
          - major

jobs:
  ship-checklist:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Ship Checklist
        run: |
          claude-code --command "/ship-checklist type=${{ inputs.release_type }}"
        
      - name: Deploy if passed
        if: success()
        run: ./deploy.sh
```

## Post-Deploy

Después de un deploy exitoso:

```
[ ] Smoke tests ejecutados en producción
[ ] Métricas monitoreadas por 30 minutos
[ ] Logs verificados (no errores nuevos)
[ ] Stakeholders notificados de deploy exitoso
[ ] Ticket/PR marcado como deployed
```
