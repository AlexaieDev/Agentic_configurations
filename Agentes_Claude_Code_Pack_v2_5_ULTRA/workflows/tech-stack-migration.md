# Workflow: Tech Stack Migration

Workflow para evaluar, planificar y ejecutar migraciones de tecnología de manera segura e incremental.

## Cuándo Usar

- Migrar de un framework a otro (ej: Angular → React)
- Actualizar major versions (ej: Node 16 → Node 20)
- Cambiar bases de datos (ej: MySQL → PostgreSQL)
- Migrar de monolito a microservicios
- Cambiar proveedores cloud
- Modernizar legacy systems

## Agentes Involucrados

| Fase | Agente | Responsabilidad |
|------|--------|-----------------|
| Evaluation | **Technology Radar Agent** | Evaluar tecnologías |
| Assessment | **Technology Critic & Improvement Agent** | Análisis crítico |
| Decision | **ADR Agent** | Documentar decisión |
| Planning | **Migration Agent** | Planificar migración |
| Debt | **Technical Debt Agent** | Gestionar deuda |
| Execution | **Refactor & Code Quality Agent** | Ejecutar cambios |

## Secuencia de Ejecución

### Fase 1: Technology Evaluation
```
Cargar: Technology Radar Agent

Tareas:
- Identificar tecnologías candidatas
- Evaluar madurez y adopción
- Analizar comunidad y soporte
- Revisar roadmap y viability
- Clasificar: Adopt/Trial/Assess/Hold

Output: Technology assessment report
```

### Fase 2: Critical Analysis
```
Cargar: Technology Critic & Improvement Agent

Tareas:
- Evaluar pros y cons objetivamente
- Analizar TCO (Total Cost of Ownership)
- Identificar riesgos de migración
- Evaluar curva de aprendizaje del equipo
- Comparar con alternativas

Output: Análisis comparativo con recomendación
```

### Fase 3: Architecture Decision
```
Cargar: ADR Agent

Tareas:
- Documentar contexto y problema
- Listar opciones consideradas
- Documentar decisión y rationale
- Identificar consecuencias
- Obtener sign-off de stakeholders

Output: ADR aprobado
```

### Fase 4: Migration Planning
```
Cargar: Migration Agent

Tareas:
- Definir estrategia (Big Bang vs Strangler Fig)
- Crear migration roadmap
- Identificar dependencias y orden
- Planificar rollback strategy
- Estimar esfuerzo y timeline

Output: Migration plan detallado
```

### Fase 5: Technical Debt Management
```
Cargar: Technical Debt Agent

Tareas:
- Inventariar deuda técnica actual
- Decidir qué pagar vs migrar
- Priorizar items a resolver pre-migración
- Documentar deuda nueva aceptable
- Crear tech debt backlog

Output: Tech debt plan
```

### Fase 6: Execution
```
Cargar: Migration Agent + Refactor & Code Quality Agent

Tareas:
- Ejecutar migración incremental
- Mantener backward compatibility
- Ejecutar tests en cada paso
- Monitorear métricas de calidad
- Documentar cambios

Output: Migración completada
```

## Estrategias de Migración

### 1. Strangler Fig (Recomendada)
```
Ideal para: Migraciones grandes, sistemas críticos

Proceso:
1. Crear facade/proxy frente al sistema legacy
2. Implementar nueva funcionalidad en nuevo stack
3. Migrar features incrementalmente
4. Redirigir tráfico gradualmente
5. Decomisionar legacy cuando está vacío

Pros: Bajo riesgo, rollback fácil
Cons: Más tiempo, complejidad temporal
```

### 2. Big Bang
```
Ideal para: Sistemas pequeños, equipos experimentados

Proceso:
1. Congelar desarrollo en sistema actual
2. Migrar todo el sistema de una vez
3. Testing intensivo pre-launch
4. Cutover en fecha determinada
5. Decomisionar legacy inmediatamente

Pros: Rápido, sin duplicación
Cons: Alto riesgo, sin rollback fácil
```

### 3. Branch by Abstraction
```
Ideal para: Cambios de libraries/frameworks internos

Proceso:
1. Crear abstraction layer sobre componente actual
2. Modificar código para usar abstraction
3. Crear nueva implementación tras abstraction
4. Switchear implementación con feature flag
5. Remover implementación vieja

Pros: Bajo riesgo, testeable
Cons: Requiere disciplina, abstraction overhead
```

## Checklist Pre-Migración

- [ ] ADR documentado y aprobado
- [ ] Stakeholders alineados
- [ ] Budget y timeline aprobados
- [ ] Equipo capacitado en nueva tecnología
- [ ] Ambiente de pruebas configurado
- [ ] Métricas baseline establecidas
- [ ] Rollback plan documentado
- [ ] Communication plan definido

## Checklist Durante Migración

- [ ] Feature parity verificada en cada fase
- [ ] Tests pasando (unit, integration, e2e)
- [ ] Performance igual o mejor que baseline
- [ ] No regresiones en funcionalidad
- [ ] Documentación actualizada
- [ ] Equipo sincronizado en dailies

## Checklist Post-Migración

- [ ] Sistema legacy decomisionado
- [ ] Documentación completa
- [ ] Runbooks actualizados
- [ ] Equipo fully onboarded
- [ ] Métricas de éxito alcanzadas
- [ ] Retrospectiva realizada
- [ ] Learnings documentados

## Ejemplo: Migración React Class → Hooks

```
Fase 1 - Evaluation:
- Hooks son stable desde React 16.8
- Comunidad ha adoptado ampliamente
- Mejor DX y bundle size
- Classification: ADOPT

Fase 2 - Critical Analysis:
- Pros: Mejor composición, menos boilerplate
- Cons: Curva de aprendizaje, 200+ componentes a migrar
- TCO: 3 meses dev time, ROI en 6 meses
- Recomendación: Proceder con Strangler Fig

Fase 3 - ADR:
- Contexto: Class components dificultan reuse
- Decisión: Migrar a hooks incrementalmente
- Consecuencias: Tiempo de migración, código mixto temporal

Fase 4 - Migration Plan:
- Semanas 1-2: Setup tooling, guidelines
- Semanas 3-6: Migrar componentes leaf
- Semanas 7-10: Migrar componentes container
- Semanas 11-12: Cleanup, documentation

Fase 5 - Tech Debt:
- Resolver: Inconsistent state management
- Migrar: Legacy HOCs → custom hooks
- Aceptar: Algunos class components permanecen

Fase 6 - Execution:
- Crear codemod para transformaciones simples
- PR por componente migrado
- Tests obligatorios antes de merge
- Weekly check-in de progreso
```

## Métricas de Éxito

| Métrica | Target |
|---------|--------|
| Feature parity | 100% |
| Test coverage post-migration | >= pre-migration |
| Performance (P95 latency) | <= pre-migration |
| Developer satisfaction | > 4/5 |
| Time to complete | <= planned |
| Incidents during migration | 0 SEV1/2 |

## Errores Comunes

| Error | Solución |
|-------|----------|
| No ADR | Siempre documentar decisión |
| Big bang en sistema grande | Usar Strangler Fig |
| Sin métricas baseline | Medir antes de migrar |
| Olvidar capacitación | Training antes de empezar |
| Sin rollback plan | Siempre tener plan B |
| Subestimar esfuerzo | Buffer 30% en estimaciones |
