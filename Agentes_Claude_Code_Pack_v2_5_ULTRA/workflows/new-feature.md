# Workflow: New Feature Development

Workflow completo para desarrollar una nueva funcionalidad desde la idea hasta el deployment.

## Cuándo Usar

- Implementar nueva funcionalidad de producto
- Agregar capacidades significativas al sistema
- Features que requieren cambios en múltiples capas
- Funcionalidad con impacto en usuarios finales

## Agentes Involucrados

| Fase | Agente | Responsabilidad |
|------|--------|-----------------|
| Discovery | **Web Product-Discovery Agent** | Validar idea y definir requisitos |
| Design | **API Design Agent** | Diseñar contratos y interfaces |
| Architecture | **Web Architecture Agent** / **Clean Architecture Agent** | Definir estructura técnica |
| Implementation | **Frontend Web Agent** / **Web BFF-Backend Agent** | Implementar código |
| Testing | **Test Strategy Agent** | Definir y ejecutar tests |
| Release | **Feature Flag Agent** | Controlar rollout |
| Launch | **Release Manager Agent** | Coordinar deployment |

## Secuencia de Ejecución

### Fase 1: Discovery
```
Cargar: Web Product-Discovery Agent

Tareas:
- Clarificar problema a resolver
- Identificar usuarios objetivo
- Definir métricas de éxito
- Crear user stories
- Priorizar MVP vs nice-to-have

Output: PRD (Product Requirements Document)
```

### Fase 2: API Design
```
Cargar: API Design Agent

Tareas:
- Diseñar endpoints necesarios
- Definir request/response schemas
- Documentar en OpenAPI/GraphQL
- Revisar backwards compatibility
- Planear versionado si necesario

Output: API specification
```

### Fase 3: Architecture Decision
```
Cargar: Web Architecture Agent + Clean Architecture Agent

Tareas:
- Evaluar impacto en arquitectura actual
- Decidir patrones a usar
- Identificar componentes afectados
- Documentar decisiones (ADR)
- Planear migrations si necesario

Output: ADR (Architecture Decision Record)
```

### Fase 4: Test Strategy
```
Cargar: Test Strategy Agent

Tareas:
- Definir test pyramid para feature
- Identificar casos críticos
- Planear integration tests
- Definir acceptance criteria
- Configurar test fixtures

Output: Test plan documentado
```

### Fase 5: Implementation
```
Cargar: Frontend Web Agent + Web BFF-Backend Agent

Tareas:
- Implementar backend/API
- Implementar frontend/UI
- Escribir unit tests
- Escribir integration tests
- Code review

Output: Código implementado y testeado
```

### Fase 6: Feature Flag Setup
```
Cargar: Feature Flag Agent

Tareas:
- Crear feature flag
- Definir targeting rules
- Configurar rollout gradual
- Preparar kill switch
- Documentar flag lifecycle

Output: Feature flag configurado
```

### Fase 7: Release
```
Cargar: Release Manager Agent

Tareas:
- Validar checklist pre-release
- Coordinar deployment
- Monitorear métricas post-deploy
- Comunicar a stakeholders
- Planear rollout gradual

Output: Feature en producción
```

## Checklist de Completitud

### Discovery
- [ ] Problema claramente definido
- [ ] User stories documentadas
- [ ] Métricas de éxito definidas
- [ ] Stakeholders alineados

### Design
- [ ] API specification completa
- [ ] Schemas validados
- [ ] Backwards compatibility verificada

### Architecture
- [ ] ADR documentado
- [ ] Impacto en sistema evaluado
- [ ] Dependencias identificadas

### Testing
- [ ] Test plan aprobado
- [ ] Unit tests escritos (cobertura > 80%)
- [ ] Integration tests pasando
- [ ] E2E tests para happy path

### Implementation
- [ ] Code review aprobado
- [ ] Documentación actualizada
- [ ] No hay deuda técnica nueva

### Release
- [ ] Feature flag configurado
- [ ] Rollback plan documentado
- [ ] Monitoring configurado
- [ ] Runbook actualizado

## Ejemplo: Feature "Checkout Express"

```
Fase 1 - Discovery:
- Problema: Usuarios abandonan checkout por ser largo
- Solución: Checkout en 1 click para usuarios registrados
- Métrica: Reducir abandono 20%

Fase 2 - API Design:
- POST /api/v1/checkout/express
- Request: { paymentMethodId, shippingAddressId }
- Response: { orderId, estimatedDelivery }

Fase 3 - Architecture:
- Agregar ExpressCheckoutUseCase en domain layer
- Reusar PaymentService y ShippingService existentes
- ADR: Decidir almacenar preferencias en user profile

Fase 4 - Testing:
- Unit: ExpressCheckoutUseCase (happy path, insufficient funds, invalid address)
- Integration: API endpoint con mocks
- E2E: Flujo completo en staging

Fase 5 - Implementation:
- Backend: 3 días
- Frontend: 2 días
- Testing: 2 días

Fase 6 - Feature Flag:
- Flag: express_checkout_enabled
- Rollout: 5% → 25% → 50% → 100%

Fase 7 - Release:
- Deploy con flag off
- Enable para 5% de usuarios
- Monitorear conversion rate
- Escalar si métricas positivas
```

## Métricas de Éxito del Workflow

- Time from idea to production < 2 sprints
- Code coverage de nueva feature > 80%
- Bugs en producción en primera semana < 2
- Rollback rate < 5%
- User satisfaction (feature-specific) > 4/5

## Errores Comunes

| Error | Solución |
|-------|----------|
| Saltar discovery | Siempre validar problema antes de codificar |
| API sin documentar | Documentar antes de implementar |
| Tests al final | TDD o al menos tests paralelos |
| Big bang release | Usar feature flags para rollout gradual |
| No monitorear | Configurar alertas antes de release |
