# Crew: Incident Response

Equipo de respuesta rápida para manejar incidentes de producción de manera estructurada y efectiva.

## Cuándo Usar

- Servicio caído (total o parcial)
- Degradación significativa de performance
- Breach de seguridad confirmado o sospechado
- Pérdida o corrupción de datos
- SLA en riesgo de incumplimiento
- Alertas críticas disparadas

## Composición del Equipo

| Rol | Agente | Responsabilidad Principal |
|-----|--------|---------------------------|
| Incident Commander | **Incident Commander Agent** | Coordinar respuesta, decisiones |
| Investigator | **Bug Hunter Agent** | Encontrar root cause |
| Observer | **Observability Agent** | Métricas, logs, trazas |
| Stabilizer | **SRE Agent** | Estabilizar y recuperar |
| Resilience | **Chaos & Resilience Agent** | Prevenir recurrencia |
| Documenter | **Docs & Knowledge Agent** | Postmortem y runbooks |

## Severity Matrix

| SEV | Descripción | Response Time | Ejemplo |
|-----|-------------|---------------|---------|
| **SEV1** | Servicio completamente inaccesible | < 15 min | Site down, data breach |
| **SEV2** | Funcionalidad core afectada | < 30 min | Checkout roto, login falla |
| **SEV3** | Feature secundario degradado | < 2 horas | Search lento, reportes fallan |
| **SEV4** | Impacto mínimo | < 24 horas | UI glitch, typo |

## Workflow de Respuesta

```
┌─────────────────────────────────────────────────────────────────┐
│                    INCIDENT DETECTED                             │
│            (Alerta, reporte usuario, monitoring)                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ FASE 1: TRIAGE (0-15 min)                                       │
│ ─────────────────────────────────────────────────────────────── │
│ Incident Commander Agent:                                        │
│ • Confirmar incidente es real (no false positive)                │
│ • Asignar severidad inicial                                      │
│ • Crear war room (Slack channel/call)                           │
│ • Notificar on-call y stakeholders                              │
│ • Asignar roles (IC, Tech Lead, Comms)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ FASE 2: CONTAINMENT (15-60 min)                                 │
│ ─────────────────────────────────────────────────────────────── │
│ SRE Agent + Observability Agent:                                 │
│ • Implementar mitigación inmediata                              │
│ • Rollback si es deploy reciente                                │
│ • Escalar recursos si necesario                                 │
│ • Activar feature flags de fallback                             │
│ • Comunicar status cada 15-30 min                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ FASE 3: INVESTIGATION (30 min - 2 hrs)                          │
│ ─────────────────────────────────────────────────────────────── │
│ Bug Hunter Agent + Observability Agent:                          │
│ • Analizar logs y métricas                                      │
│ • Correlacionar eventos y cambios                               │
│ • Identificar cambios recientes (deploys, configs)              │
│ • Formular y probar hipótesis                                   │
│ • Encontrar root cause                                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ FASE 4: RESOLUTION (Variable)                                    │
│ ─────────────────────────────────────────────────────────────── │
│ SRE Agent + Bug Hunter Agent:                                    │
│ • Implementar fix permanente                                    │
│ • Validar en staging si posible                                 │
│ • Deploy con monitoreo intensivo                                │
│ • Verificar resolución completa                                 │
│ • Declarar incident resolved                                    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ FASE 5: POST-INCIDENT (24-72 hrs después)                       │
│ ─────────────────────────────────────────────────────────────── │
│ Docs & Knowledge Agent + Chaos & Resilience Agent:               │
│ • Escribir postmortem (blameless)                               │
│ • Identificar action items                                      │
│ • Actualizar runbooks                                           │
│ • Diseñar tests de resiliencia                                  │
│ • Compartir learnings con org                                   │
└─────────────────────────────────────────────────────────────────┘
```

## Roles y Responsabilidades

### Incident Commander (IC)
```
• Única fuente de verdad durante el incidente
• Toma decisiones finales
• Coordina recursos y comunicación
• NO debuggea directamente (delega)
• Mantiene timeline actualizado
```

### Tech Lead
```
• Lidera investigación técnica
• Coordina implementación de fixes
• Reporta findings al IC
• Decide approach técnico
```

### Communications Lead
```
• Actualiza status page
• Comunica a stakeholders externos
• Maneja escalaciones de clientes
• Prepara mensajes internos
```

### Scribe
```
• Documenta timeline en tiempo real
• Captura decisiones y rationale
• Registra comandos ejecutados
• Base para postmortem
```

## Templates de Comunicación

### Status Update Interno (cada 15-30 min en SEV1/2)
```
🔴 INCIDENT UPDATE - [Título Breve]

Severidad: SEV[X]
Status: [Investigating | Mitigating | Monitoring | Resolved]
Impacto: [Descripción del impacto a usuarios]
Usuarios afectados: [N usuarios / X%]

Acción actual: [Qué está haciendo el equipo ahora]
Próximo update: [Hora]

IC: @nombre
War room: #incident-YYYYMMDD-titulo
```

### Status Page (externo)
```
[Título del Incidente]

[Hora] - Estamos investigando reportes de [descripción del problema].
Algunos usuarios pueden experimentar [síntomas].

Nuestro equipo está trabajando activamente en resolver el problema.
Actualizaremos este status cada [30 minutos].

Current status: [Investigating | Identified | Monitoring | Resolved]
```

### Postmortem Template
```markdown
# Postmortem: [Título del Incidente]

## Resumen Ejecutivo
- **Fecha**: YYYY-MM-DD
- **Duración**: X horas Y minutos
- **Severidad**: SEVX
- **Impacto**: [usuarios afectados, revenue perdido, etc.]

## Timeline
| Hora | Evento |
|------|--------|
| HH:MM | Alerta disparada |
| HH:MM | IC asignado |
| HH:MM | Mitigación implementada |
| HH:MM | Root cause identificado |
| HH:MM | Fix deployado |
| HH:MM | Incidente resuelto |

## Root Cause
[Descripción técnica del problema]

## Contribuyentes
[Factores que permitieron o agravaron el incidente]

## Qué Funcionó Bien
- [Cosa positiva 1]
- [Cosa positiva 2]

## Qué Podemos Mejorar
- [Área de mejora 1]
- [Área de mejora 2]

## Action Items
| Item | Owner | Deadline | Status |
|------|-------|----------|--------|
| [Acción] | @persona | YYYY-MM-DD | Open |

## Lecciones Aprendidas
[Qué aprendimos de este incidente]
```

## Métricas de Incident Response

| Métrica | Target SEV1 | Target SEV2 |
|---------|-------------|-------------|
| Time to Detect (TTD) | < 5 min | < 15 min |
| Time to Acknowledge | < 5 min | < 15 min |
| Time to Mitigate | < 30 min | < 1 hora |
| Time to Resolve | < 2 horas | < 4 horas |
| Postmortem completado | < 48 horas | < 5 días |
| Action items cerrados | < 2 semanas | < 1 mes |

## Runbook Quick Reference

### Rollback Rápido
```bash
# Verificar último deploy exitoso
git log --oneline -10

# Rollback en Kubernetes
kubectl rollout undo deployment/[name]

# Rollback en Vercel
vercel rollback

# Verificar
kubectl get pods
curl -I https://[domain]/health
```

### Escalar Recursos
```bash
# Kubernetes
kubectl scale deployment/[name] --replicas=10

# AWS Auto Scaling
aws autoscaling set-desired-capacity \
  --auto-scaling-group-name [name] \
  --desired-capacity 10
```

### Feature Flag Emergency
```bash
# Desactivar feature problemático
curl -X PATCH https://[flagservice]/flags/[flag] \
  -d '{"enabled": false}'
```

## Recursos

- [Incident Commander Agent](../agents/cloud/Incident%20Commander%20Agent.txt)
- [Bug Hunter Agent](../agents/transversal/Bug%20Hunter%20Agent.txt)
- [Observability Agent](../agents/cloud/Observability%20Agent.txt)
- [SRE Agent](../agents/cloud/SRE%20Agent.txt)
- [Chaos & Resilience Agent](../agents/cloud/Chaos%20%26%20Resilience%20Agent.txt)
- [Docs & Knowledge Agent](../agents/transversal/Docs%20%26%20Knowledge%20Agent.txt)
