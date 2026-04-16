# Crew: Startup MVP

Equipo optimizado para construir un MVP rápidamente con las mejores prácticas esenciales.

## Cuándo Usar

- Lanzar producto nuevo en < 3 meses
- Validar idea de negocio con usuarios reales
- Equipo pequeño (1-5 personas)
- Presupuesto limitado, velocidad prioritaria
- Stack moderno y mantenible

## Composición del Equipo

| Rol | Agente | Responsabilidad Principal |
|-----|--------|---------------------------|
| Product Lead | **Web Product-Discovery Agent** | Definir qué construir y priorizar |
| Architect | **Web Architecture Agent** | Diseñar estructura escalable pero simple |
| Frontend | **Frontend Web Agent** | Implementar UI/UX |
| Backend | **Web BFF-Backend Agent** | Implementar APIs y lógica |
| DevOps | **Web CI-CD Agent** | Automatizar deployment |
| QA | **Test Strategy Agent** | Definir testing mínimo viable |

## Agentes de Apoyo (Según Necesidad)

| Situación | Agente |
|-----------|--------|
| Autenticación requerida | Authentication Agent |
| Pagos integrados | Payment Integration Agent |
| Envío de emails | Email Delivery Agent |
| App móvil también | Mobile Architecture Agent |
| Base de datos compleja | Database Architect Agent |

## Workflow del Crew

```
Semana 1-2: Discovery & Architecture
├── Web Product-Discovery Agent
│   ├── Definir problema y usuarios
│   ├── Crear user stories prioritizadas
│   └── Establecer métricas de éxito
│
└── Web Architecture Agent
    ├── Seleccionar stack (recomendado: Next.js + PostgreSQL)
    ├── Diseñar arquitectura monolito modular
    └── Configurar proyecto base

Semana 3-6: Implementation
├── Frontend Web Agent
│   ├── Implementar UI core
│   ├── Integrar con APIs
│   └── Responsive design
│
├── Web BFF-Backend Agent
│   ├── Implementar endpoints
│   ├── Conectar database
│   └── Autenticación básica
│
└── Web CI-CD Agent
    ├── Setup CI pipeline
    ├── Deploy a staging
    └── Configurar preview deployments

Semana 7-8: Polish & Launch
├── Test Strategy Agent
│   ├── Tests críticos (auth, pagos, core flows)
│   ├── Smoke tests para CI
│   └── Manual QA checklist
│
└── Todos los agentes
    ├── Bug fixes
    ├── Performance básica
    └── Launch checklist
```

## Stack Recomendado

### Opción A: JavaScript Full-Stack (Más Rápido)
```
Frontend: Next.js 14+ (App Router)
Backend: Next.js API Routes o tRPC
Database: PostgreSQL (Supabase/Neon)
Auth: NextAuth.js o Clerk
Hosting: Vercel
```

### Opción B: Separado (Más Flexible)
```
Frontend: React + Vite
Backend: Node.js + Express/Fastify
Database: PostgreSQL
Auth: Auth0 o Firebase Auth
Hosting: Railway/Render
```

## Definición de Done del MVP

### Funcionalidad
- [ ] Core user flow funciona end-to-end
- [ ] Autenticación implementada (si aplica)
- [ ] Datos persisten correctamente
- [ ] Errores manejados gracefully

### Calidad
- [ ] Tests de happy path pasando
- [ ] No hay errores críticos en console
- [ ] Mobile responsive funciona
- [ ] Carga en < 3 segundos

### Operaciones
- [ ] CI/CD funcionando
- [ ] Staging environment disponible
- [ ] Logging básico configurado
- [ ] Backup de database configurado

### Lanzamiento
- [ ] Dominio configurado
- [ ] SSL activo
- [ ] Analytics instalado (Plausible/Posthog)
- [ ] Error tracking (Sentry)

## Anti-Patrones a Evitar

| Anti-Patrón | Por Qué Evitarlo | Qué Hacer |
|-------------|------------------|-----------|
| Over-engineering | Retrasa lanzamiento | YAGNI - solo lo necesario |
| Microservicios | Complejidad innecesaria | Monolito modular |
| Testing exhaustivo | Tiempo en tests vs features | Tests de critical path |
| Perfección en UI | El MVP no necesita ser perfecto | Funcional > Bonito |
| Auth custom | Riesgo de seguridad | Usar servicio (Clerk, Auth0) |

## Métricas del Crew

| Métrica | Target |
|---------|--------|
| Time to MVP | < 8 semanas |
| Core features completados | 100% |
| Bugs críticos en launch | 0 |
| Test coverage critical paths | > 70% |
| Deploy automatizado | Sí |

## Escalabilidad Post-MVP

Una vez validado el MVP, agregar gradualmente:
1. **Performance & Efficiency Agent** - Optimizar cuellos de botella
2. **Observability Agent** - Monitoring y alertas
3. **Technical Debt Agent** - Pagar deuda acumulada
4. **Feature Flag Agent** - Releases controlados

## Ejemplo: MVP de SaaS de Invoicing

```
Crew aplicado a construir MVP de facturación:

Week 1: Discovery
- Product Agent: User stories (crear factura, enviar, marcar pagada)
- Architecture Agent: Next.js + Supabase + Resend

Week 2-4: Core
- Frontend Agent: Dashboard, formulario de factura, lista
- Backend Agent: CRUD facturas, PDF generation, email sending
- Auth: Clerk integration

Week 5-6: Polish
- CI-CD Agent: Deploy a Vercel, preview deploys
- Test Agent: Tests de crear/enviar factura

Week 7: Launch
- Dominio configurado
- Primeros 10 usuarios beta
- Feedback loop iniciado
```

## Recursos

- [Web Product-Discovery Agent](../agents/web/Web%20Product-Discovery%20Agent.txt)
- [Web Architecture Agent](../agents/web/Web%20Architecture%20Agent.txt)
- [Frontend Web Agent](../agents/web/Frontend%20Web%20Agent.txt)
- [Web BFF-Backend Agent](../agents/web/Web%20BFF-Backend%20Agent.txt)
- [Web CI-CD Agent](../agents/web/Web%20CI-CD%20Agent.txt)
- [Test Strategy Agent](../agents/testing/Test%20Strategy%20Agent.txt)
