# Workflow: Incident Response

Workflow para responder a incidentes en producción de manera estructurada y efectiva.

## Cuándo Usar

- Servicio caído o degradado
- Errores masivos en producción
- Breach de seguridad detectado
- Pérdida de datos
- SLA en riesgo de incumplimiento
- Alertas críticas disparadas

## Agentes Involucrados

| Fase | Agente | Responsabilidad |
|------|--------|-----------------|
| Detection | **Observability Agent** | Detectar y alertar |
| Command | **Incident Commander Agent** | Coordinar respuesta |
| Investigation | **Bug Hunter Agent** | Investigar root cause |
| Reliability | **SRE Agent** | Estabilizar sistema |
| Chaos | **Chaos & Resilience Agent** | Prevenir recurrencia |
| Postmortem | **Docs & Knowledge Agent** | Documentar learnings |

## Severidades

| Nivel | Descripción | Response Time | Ejemplo |
|-------|-------------|---------------|---------|
| SEV1 | Crítico - Servicio completamente caído | < 15 min | Sitio web inaccesible |
| SEV2 | Major - Funcionalidad core afectada | < 30 min | Checkout no funciona |
| SEV3 | Moderate - Feature secundario afectado | < 2 horas | Búsqueda lenta |
| SEV4 | Minor - Impacto mínimo | < 24 horas | Typo en UI |

## Secuencia de Ejecución

### Fase 1: Detection & Alerting
```
Cargar: Observability Agent

Tareas:
- Confirmar alerta es real (no false positive)
- Determinar scope del impacto
- Identificar componentes afectados
- Asignar severidad inicial
- Notificar on-call

Output: Incident declarado con severidad
```

### Fase 2: Incident Command
```
Cargar: Incident Commander Agent

Tareas:
- Asumir rol de IC (Incident Commander)
- Crear war room (Slack channel/Zoom)
- Asignar roles (Comms, Tech Lead)
- Establecer cadencia de updates
- Comunicar a stakeholders

Output: Equipo movilizado, comunicación establecida
```

### Fase 3: Mitigation
```
Cargar: SRE Agent

Tareas:
- Implementar mitigación inmediata
- Considerar rollback si aplica
- Escalar recursos si necesario
- Habilitar feature flags de fallback
- Estabilizar sistema

Output: Servicio estabilizado (aunque no root-caused)
```

### Fase 4: Investigation
```
Cargar: Bug Hunter Agent

Tareas:
- Analizar logs y métricas
- Correlacionar eventos
- Identificar cambios recientes
- Formular hipótesis
- Encontrar root cause

Output: Root cause identificado
```

### Fase 5: Resolution
```
Cargar: SRE Agent + Bug Hunter Agent

Tareas:
- Implementar fix permanente
- Validar en staging si posible
- Deploy con monitoreo intensivo
- Verificar resolución
- Cerrar incident

Output: Incident resuelto
```

### Fase 6: Prevention
```
Cargar: Chaos & Resilience Agent

Tareas:
- Diseñar tests de resiliencia
- Implementar circuit breakers si faltaban
- Agregar alertas que faltaban
- Crear runbook para escenario
- Planear chaos testing

Output: Mejoras de resiliencia implementadas
```

### Fase 7: Postmortem
```
Cargar: Docs & Knowledge Agent

Tareas:
- Documentar timeline del incident
- Escribir root cause analysis
- Identificar action items
- Facilitar postmortem meeting
- Distribuir learnings

Output: Postmortem documentado
```

## Roles en Incident Response

| Rol | Responsabilidad |
|-----|-----------------|
| **Incident Commander (IC)** | Coordina respuesta, toma decisiones |
| **Tech Lead** | Investiga y resuelve técnicamente |
| **Comms Lead** | Comunica a stakeholders externos |
| **Scribe** | Documenta timeline en tiempo real |

## Template de Comunicación

### Update Interno (cada 30 min en SEV1/2)
```
🔴 Incident Update - [Título]
Severidad: SEV[X]
Status: [Investigating/Mitigating/Resolved]
Impacto: [Descripción del impacto]
Usuarios afectados: [número o %]
Acción actual: [Qué está haciendo el equipo]
ETA: [Estimación de resolución]
IC: [@nombre]
War room: [link]
```

### Update Externo (Status Page)
```
[Título del incidente]

Estamos investigando un problema que afecta [funcionalidad].
Algunos usuarios pueden experimentar [síntomas].
Nuestro equipo está trabajando activamente en la resolución.

Última actualización: [timestamp]
```

## Checklist de Postmortem

- [ ] Timeline documentado (minuto a minuto para SEV1)
- [ ] Root cause identificado (5 Whys)
- [ ] Impact cuantificado (usuarios, revenue, SLA)
- [ ] Detection time documentado
- [ ] Time to mitigation documentado
- [ ] Time to resolution documentado
- [ ] Action items con owners y deadlines
- [ ] Postmortem meeting realizado
- [ ] Learnings compartidos con org

## Métricas de Incident Response

| Métrica | Target SEV1 | Target SEV2 |
|---------|-------------|-------------|
| Time to Detect (TTD) | < 5 min | < 15 min |
| Time to Acknowledge | < 5 min | < 15 min |
| Time to Mitigate (TTM) | < 30 min | < 1 hora |
| Time to Resolve (TTR) | < 2 horas | < 4 horas |
| Postmortem completado | < 48 horas | < 1 semana |

## Errores Comunes

| Error | Solución |
|-------|----------|
| Muchos cocineros | Un solo IC con autoridad clara |
| Hero culture | Documentar, no improvisar |
| Blame game | Postmortems blameless |
| Skip postmortem | Obligatorio para SEV1/2 |
| Action items olvidados | Trackear en JIRA con deadlines |

## Recursos

- [Google SRE Book - Incident Response](https://sre.google/sre-book/managing-incidents/)
- [PagerDuty Incident Response](https://response.pagerduty.com/)
- [Atlassian Incident Management](https://www.atlassian.com/incident-management)
