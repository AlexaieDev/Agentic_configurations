---
name: incident-start
description: Iniciar respuesta a incidente con procedimiento estructurado
version: "1.0"
agents:
  - Incident Commander Agent
  - SRE Agent
  - Observability Agent
  - Root Cause Analysis Agent
args:
  - name: severity
    description: Severidad del incidente (sev1, sev2, sev3, sev4)
    required: false
    default: "sev2"
  - name: type
    description: Tipo de incidente (outage, degradation, security, data)
    required: false
    default: "degradation"
  - name: service
    description: Servicio afectado
    required: false
    default: ""
---

# /incident-start

## Descripción

Inicia el proceso estructurado de respuesta a incidentes. Establece roles, crea canales de comunicación, y guía el proceso de diagnóstico y resolución.

## Instrucciones

### Fase 1: Declaración (0-5 minutos)

#### 1.1 Evaluar Severidad

| Severidad | Criterios | Respuesta |
|-----------|-----------|-----------|
| **SEV1** | Servicio completamente caído, pérdida de datos, breach de seguridad | Inmediata, all-hands |
| **SEV2** | Funcionalidad crítica degradada, afecta >10% usuarios | Urgente, equipo core |
| **SEV3** | Funcionalidad no-crítica afectada, workaround disponible | Horario laboral |
| **SEV4** | Issue menor, sin impacto a usuarios | Siguiente sprint |

#### 1.2 Crear Incident Record

```markdown
## Incident #INC-2024-0115-001

### Status: ACTIVE
### Severity: SEV2
### Commander: @alice
### Started: 2024-01-15 14:30 UTC

### Impact
- Service: checkout-api
- Users affected: ~5,000
- Revenue impact: ~$X,XXX/hour

### Timeline
- 14:25 - Alertas de latencia disparadas
- 14:28 - Confirmado: checkout fallando
- 14:30 - Incident declarado SEV2

### Current Status
Investigando causa raíz. Checkout degradado.
```

#### 1.3 Establecer Comunicación

```
[ ] Canal de Slack: #inc-2024-0115-checkout
[ ] Bridge de video: meet.google.com/xxx-xxx-xxx
[ ] Status page: Actualizado a "Degraded"
[ ] Stakeholders notificados
```

### Fase 2: Asignación de Roles

```markdown
### Roles
| Rol | Persona | Responsabilidad |
|-----|---------|-----------------|
| Incident Commander | @alice | Coordinación general |
| Tech Lead | @bob | Decisiones técnicas |
| Communications | @carol | Updates externos |
| Scribe | @dave | Documentación timeline |
```

### Fase 3: Diagnóstico (Observability Agent)

#### 3.1 Recopilar Información

```bash
# Métricas
[ ] Error rate actual vs baseline
[ ] Latency P50/P95/P99
[ ] Request rate
[ ] Resource utilization

# Logs
[ ] Errores recientes
[ ] Patterns inusuales
[ ] Correlación temporal

# Traces
[ ] Requests fallidos
[ ] Bottlenecks identificados

# Changes
[ ] Deploys recientes
[ ] Config changes
[ ] Infrastructure changes
```

#### 3.2 Árbol de Decisión

```
¿Hubo deploy reciente?
├── Sí → Considerar rollback
│   ├── ¿Rollback posible? → Ejecutar
│   └── ¿Rollback riesgoso? → Evaluar fix forward
└── No → Investigar cambios externos
    ├── ¿Dependencia externa fallando?
    ├── ¿Pico de tráfico?
    └── ¿Recurso agotado?
```

### Fase 4: Mitigación

#### 4.1 Acciones Comunes

| Problema | Acción Inmediata |
|----------|-----------------|
| Deploy malo | Rollback a versión anterior |
| Sobrecarga | Scale out, rate limiting |
| Dependencia caída | Failover, circuit breaker |
| DB lenta | Kill queries, failover a replica |
| Memory leak | Restart pods gradual |
| Certificado expirado | Renovar/reinstalar |

#### 4.2 Decisión de Mitigación

```
[ ] Mitigación identificada: _______________
[ ] Riesgo de la mitigación evaluado
[ ] Aprobación del Tech Lead
[ ] Ejecutando mitigación
[ ] Monitoreando resultados
```

### Fase 5: Resolución

```markdown
### Resolution
- 15:45 - Mitigación aplicada (rollback)
- 15:47 - Métricas normalizándose
- 16:00 - Confirmado: servicio recuperado
- 16:15 - Incident cerrado

### Root Cause
Deployment v2.3.4 introdujo query no optimizada
que causaba timeout bajo carga.

### Action Items
1. [ ] Fix query y re-deploy (owner: @bob, due: tomorrow)
2. [ ] Agregar test de performance (owner: @carol, due: this week)
3. [ ] Mejorar canary analysis (owner: @dave, due: next sprint)
```

### Fase 6: Post-Mortem

```
[ ] Post-mortem agendado (dentro de 48h)
[ ] Timeline completo documentado
[ ] Root cause analysis completo
[ ] Action items creados y asignados
[ ] Learnings compartidos
```

## Output

### Incident Report Template

```markdown
# Incident Post-Mortem: INC-2024-0115-001

## Summary
Checkout service experienced 75 minutes of degraded performance
affecting ~5,000 users and $XX,XXX in potential revenue.

## Impact
- Duration: 75 minutes
- Users affected: 5,000
- Failed transactions: 342
- Revenue impact: $XX,XXX

## Timeline (All times UTC)
| Time | Event |
|------|-------|
| 14:25 | Latency alerts fired |
| 14:28 | On-call acknowledged |
| 14:30 | Incident declared SEV2 |
| 14:45 | Root cause identified |
| 15:00 | Rollback decision made |
| 15:15 | Rollback complete |
| 15:45 | Service recovered |

## Root Cause
Unoptimized database query in v2.3.4 release caused
connection pool exhaustion under normal load.

## Detection
How was the issue detected?
- PagerDuty alert on latency > 2s

## Resolution
Steps taken to resolve:
1. Identified recent deploy
2. Analyzed slow query logs
3. Rolled back to v2.3.3

## Lessons Learned
What went well:
- Fast detection (3 minutes)
- Clear rollback process

What could be improved:
- Query performance testing
- Canary analysis duration

## Action Items
| Action | Owner | Due | Status |
|--------|-------|-----|--------|
| Add query perf tests | @bob | Jan 17 | Open |
| Extend canary window | @carol | Jan 20 | Open |
| Document runbook | @dave | Jan 22 | Open |

## References
- Slack channel: #inc-2024-0115-checkout
- Grafana dashboard: [link]
- Related PRs: #1234
```

## Ejemplos de Uso

```bash
# Iniciar incidente SEV2
/incident-start

# Incidente SEV1 en payments
/incident-start severity=sev1 service=payments

# Incidente de seguridad
/incident-start type=security severity=sev1

# Degradación menor
/incident-start severity=sev3 type=degradation
```

## Integraciones

### Slack
- Crea canal automáticamente
- Invita a on-call
- Posts updates periódicos

### PagerDuty
- Crea incident
- Escala automáticamente

### Status Page
- Actualiza estado
- Notifica subscribers

### Jira
- Crea ticket de incident
- Linkea action items
