# Crew: Platform Migration

Equipo especializado para ejecutar migraciones de plataforma/tecnología de manera segura e incremental.

## Cuándo Usar

- Migrar de framework (Angular → React, Rails → Node)
- Actualizar major versions (Node 16 → 20, React 17 → 19)
- Cambiar base de datos (MySQL → PostgreSQL)
- Migrar de monolito a microservicios
- Cambiar proveedor cloud (AWS → GCP)
- Modernizar sistemas legacy

## Composición del Equipo

| Rol | Agente | Responsabilidad Principal |
|-----|--------|---------------------------|
| Tech Evaluator | **Technology Radar Agent** | Evaluar tecnologías candidatas |
| Critic | **Technology Critic & Improvement Agent** | Análisis crítico objetivo |
| Architect | **ADR Agent** | Documentar decisiones |
| Migration Lead | **Migration Agent** | Planificar y ejecutar migración |
| Debt Manager | **Technical Debt Agent** | Gestionar deuda técnica |
| Quality | **Refactor & Code Quality Agent** | Mantener calidad durante cambios |
| Risk | **Compliance Agent** | Evaluar riesgos regulatorios |

## Estrategias de Migración

### 1. Strangler Fig Pattern (Recomendada)
```
Ideal para: Sistemas grandes, críticos, en producción

Proceso:
1. Crear facade/proxy frente al sistema legacy
2. Nueva funcionalidad va al nuevo sistema
3. Migrar features incrementalmente
4. Redirigir tráfico gradualmente
5. Decomisionar legacy cuando vacío

Timeline: 6-18 meses típicamente
Riesgo: Bajo
Rollback: Fácil (revertir tráfico)
```

### 2. Big Bang
```
Ideal para: Sistemas pequeños, equipos expertos

Proceso:
1. Freeze desarrollo en sistema actual
2. Reescribir/migrar todo
3. Testing intensivo
4. Cutover en fecha fija
5. Decomisionar legacy inmediatamente

Timeline: 1-3 meses
Riesgo: Alto
Rollback: Difícil
```

### 3. Branch by Abstraction
```
Ideal para: Cambios internos (libraries, patterns)

Proceso:
1. Crear abstraction layer
2. Código usa abstraction
3. Nueva implementación tras abstraction
4. Switch via feature flag
5. Remover implementación vieja

Timeline: 2-6 meses
Riesgo: Medio
Rollback: Feature flag
```

## Workflow de Migración

```
FASE 1: ASSESSMENT (Semana 1-2)
════════════════════════════════════════════════════════════════

Technology Radar Agent
├── Evaluar tecnologías candidatas
├── Analizar madurez y adopción
├── Revisar roadmap y viability
└── Clasificar: Adopt/Trial/Assess/Hold

Technology Critic & Improvement Agent
├── Pros/cons objetivos
├── TCO (Total Cost of Ownership)
├── Riesgos de migración
├── Curva de aprendizaje
└── Comparativa con alternativas

Output: Technology Assessment Report


FASE 2: DECISION (Semana 3)
════════════════════════════════════════════════════════════════

ADR Agent
├── Documentar contexto y problema
├── Opciones consideradas
├── Decisión y rationale
├── Consecuencias
└── Sign-off de stakeholders

Compliance Agent
├── Impacto regulatorio
├── Data migration concerns
├── Vendor lock-in analysis
└── Contractual obligations

Output: ADR aprobado + Risk Assessment


FASE 3: PLANNING (Semana 4-5)
════════════════════════════════════════════════════════════════

Migration Agent
├── Seleccionar estrategia (Strangler/Big Bang/Branch)
├── Crear roadmap por fases
├── Identificar dependencias
├── Estimar esfuerzo por fase
├── Definir rollback strategy
└── Crear communication plan

Technical Debt Agent
├── Inventariar deuda actual
├── Decidir: pagar vs migrar
├── Priorizar pre-migration cleanup
└── Definir acceptable new debt

Output: Migration Plan + Tech Debt Plan


FASE 4: PREPARATION (Semana 6-8)
════════════════════════════════════════════════════════════════

Migration Agent + Refactor & Code Quality Agent
├── Setup nuevo ambiente/proyecto
├── Crear abstractions necesarias
├── Implementar adapter pattern
├── Setup feature flags
├── Crear test harness comparativo
└── Establecer métricas baseline

Output: Infrastructure ready, baseline documented


FASE 5: EXECUTION (Variable: 1-12 meses)
════════════════════════════════════════════════════════════════

Por cada módulo/feature:
┌────────────────────────────────────────────┐
│ 1. Migration Agent: Migrar componente      │
│ 2. Refactor Agent: Limpiar y optimizar     │
│ 3. Test en paralelo (shadow mode)          │
│ 4. Redirigir tráfico gradualmente          │
│ 5. Monitorear métricas                     │
│ 6. Rollback si problemas                   │
│ 7. Decomisionar componente legacy          │
└────────────────────────────────────────────┘

Output: Sistema parcialmente migrado


FASE 6: COMPLETION (Semanas finales)
════════════════════════════════════════════════════════════════

Migration Agent
├── Migrar últimos componentes
├── Remover abstractions temporales
├── Cleanup código de migración
└── Decomisionar sistema legacy

Technical Debt Agent
├── Documentar deuda nueva
├── Crear plan de pago
└── Priorizar en backlog

Docs & Knowledge Agent
├── Actualizar documentación
├── Crear runbooks nuevos
├── Documentar lecciones aprendidas
└── Retrospectiva de migración

Output: Migración completada
```

## Checklists

### Pre-Migración
- [ ] ADR documentado y aprobado
- [ ] Stakeholders alineados
- [ ] Budget aprobado
- [ ] Equipo capacitado en nueva tech
- [ ] Ambiente de pruebas listo
- [ ] Métricas baseline establecidas
- [ ] Rollback plan documentado
- [ ] Communication plan definido

### Durante Migración
- [ ] Feature parity en cada fase
- [ ] Tests pasando (unit, integration, e2e)
- [ ] Performance igual o mejor
- [ ] No regresiones funcionales
- [ ] Documentación actualizada
- [ ] Daily syncs del equipo
- [ ] Weekly stakeholder updates

### Post-Migración
- [ ] Sistema legacy decomisionado
- [ ] Documentación completa
- [ ] Runbooks actualizados
- [ ] Equipo onboarded
- [ ] Métricas de éxito alcanzadas
- [ ] Retrospectiva realizada
- [ ] Learnings documentados

## Ejemplo: Rails → Node.js

```
Contexto: Monolito Rails, 50K líneas, 100+ endpoints

Semana 1-2: Assessment
├── Technology Radar: Node.js + TypeScript + Fastify
├── Critic: +40% performance, -20% hosting cost
│   Risk: Equipo necesita training en TS
└── Decisión: Proceder con Strangler Fig

Semana 3-4: Planning
├── Fase 1: APIs públicas (30 endpoints)
├── Fase 2: APIs internas (40 endpoints)
├── Fase 3: Background jobs
├── Fase 4: Admin panel
└── Timeline total: 6 meses

Semana 5-8: Preparation
├── Setup Node.js project
├── Nginx como facade/proxy
├── Feature flags con LaunchDarkly
├── Implementar 3 endpoints como POC
└── Validar performance (+35% mejor)

Mes 2-4: Execution Fase 1
├── Migrar endpoints uno por uno
├── Shadow mode con comparación
├── Gradual traffic shift (10→50→100%)
├── 30 endpoints migrados
└── Rails solo sirve legacy

Mes 5-6: Completion
├── Migrar resto de endpoints
├── Migrar background jobs a BullMQ
├── Admin panel en React
├── Decomisionar Rails
└── Retrospectiva: 4 meses real vs 6 planned
```

## Métricas de Migración

| Métrica | Target |
|---------|--------|
| Feature parity | 100% |
| Performance post-migration | >= baseline |
| Test coverage | >= pre-migration |
| Incidents durante migración | 0 SEV1/2 |
| Timeline vs planned | < 120% |
| Budget vs planned | < 110% |

## Anti-Patrones

| Anti-Patrón | Consecuencia | Solución |
|-------------|--------------|----------|
| Big bang en sistema grande | Alto riesgo de falla total | Usar Strangler Fig |
| Sin métricas baseline | No puedes probar mejora | Medir antes de migrar |
| Sin rollback plan | Stuck si algo falla | Siempre tener plan B |
| Reescribir + refactorizar | Scope creep, nunca termina | Migrar primero, mejorar después |
| Ignorar equipo | Resistencia, errores | Training y comunicación |
| Skip testing | Bugs en producción | Tests en cada fase |

## Recursos

- [Technology Radar Agent](../agents/transversal/Technology%20Radar%20Agent.txt)
- [Technology Critic & Improvement Agent](../agents/transversal/Technology%20Critic%20%26%20Improvement%20Agent.txt)
- [ADR Agent](../agents/transversal/ADR%20Agent.txt)
- [Migration Agent](../agents/transversal/Migration%20Agent.txt)
- [Technical Debt Agent](../agents/transversal/Technical%20Debt%20Agent.txt)
- [Refactor & Code Quality Agent](../agents/transversal/Refactor%20%26%20Code%20Quality%20Agent.txt)
