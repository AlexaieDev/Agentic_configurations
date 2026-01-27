# Ranking de Agentes por Utilidad

> Análisis completo de los 179 agentes ordenados por utilidad práctica.

## Resumen Ejecutivo

| Tier | Cantidad | % | Descripción |
|------|----------|---|-------------|
| **S** | 9 | 5% | Esenciales para todos los proyectos |
| **A** | 29 | 16% | Muy útiles para la mayoría |
| **B** | 44 | 25% | Útiles en escenarios específicos |
| **C** | 97 | 54% | Especializados / Nicho |

---

## 🏆 TIER S - ESENCIALES (9 agentes)

| # | Agente | Archivo | Calidad | Fortalezas | Debilidades |
|---|--------|---------|---------|------------|-------------|
| 1 | Bug Hunter Agent | `quality/bug-hunter.agent.txt` | ⭐10/10 | DEBE/NO DEBE claros, 6 checkpoints, métricas MTTR | Podría incluir debugging mobile |
| 2 | Test Strategy Agent | `testing/test-strategy.agent.txt` | ⭐10/10 | Mejor estructurado, ratios 70/20/10, anti-patterns | Más frameworks por lenguaje |
| 3 | Agent Selector & Orchestration | `_global/agent-selector.agent.txt` | ⭐10/10 | Taxonomía excepcional problema→agentes | Es meta, no ejecuta |
| 4 | Web Architecture Agent | `platform-web/web-architecture.agent.txt` | ⭐10/10 | Trade-offs CSR/SSR/SSG documentados | Solo aplica a web |
| 5 | Performance & Efficiency Agent | `quality/performance-efficiency.agent.txt` | ⭐10/10 | Data-driven, Core Web Vitals, N+1 | Falta mobile performance |
| 6 | Code Review Agent | `quality/code-review.agent.txt` | ⭐9/10 | KPIs concretos, rotación reviewers | Ejemplos de comentarios |
| 7 | Refactor & Code Quality Agent | `quality/refactor-code-quality.agent.txt` | ⭐9/10 | Regla "2+ = extraer", scope claro | Más code smells |
| 8 | Global Policy Agent Rules | `_global/global-policy.agent.txt` | ⭐9/10 | 9 políticas, governance organizacional | Menos actionable |
| 9 | API Design Agent | `process/api-design.agent.txt` | ⭐9/10 | Contratos, versionado, OpenAPI/GraphQL | - |

---

## 🥇 TIER A - MUY ÚTILES (29 agentes)

| # | Agente | Archivo | Calidad | Fortalezas | Debilidades |
|---|--------|---------|---------|------------|-------------|
| 10 | Backend Web Agent | `platform-web/backend-web.agent.txt` | ⭐9/10 | Clean Architecture, seguridad integrada | Connection pooling |
| 11 | Frontend Web Agent | `platform-web/frontend-web.agent.txt` | ⭐8/10 | Design System alignment | Performance budgets |
| 12 | E2E Testing Agent | `testing/e2e-testing.agent.txt` | ⭐9/10 | Page Object Model, anti-flaky | - |
| 13 | Authentication Agent | `security/authentication.agent.txt` | ⭐9/10 | OAuth2/PKCE/WebAuthn, OWASP | Ejemplos por framework |
| 14 | Threat Modeling Agent | `security/threat-modeling.agent.txt` | ⭐9/10 | STRIDE framework, shift-left | Templates |
| 15 | Vulnerability Management Agent | `security/vulnerability-management.agent.txt` | ⭐9/10 | CVSS + contexto negocio | - |
| 16 | Cloud Architecture Agent | `platform-cloud/cloud-architecture.agent.txt` | ⭐9/10 | Multi-cloud, well-architected | - |
| 17 | Observability Agent | `platform-cloud/observability.agent.txt` | ⭐9/10 | Tracing, metrics, logs | - |
| 18 | Product Vision Agent | `discovery/product-vision.agent.txt` | ⭐9/10 | Jobs-to-be-done, visión clara | Métricas de éxito |
| 19 | MVP Definition Agent | `discovery/mvp-definition.agent.txt` | ⭐9/10 | RICE/MoSCoW/Kano, hypothesis-driven | - |
| 20 | Infrastructure as Code Agent | `devops/infrastructure-as-code.agent.txt` | ⭐9/10 | Módulos, drift detection | Ejemplos Terraform |
| 21 | Business Model Agent | `business/business-model.agent.txt` | ⭐9/10 | Business Model Canvas, unit economics | Financial modeling |
| 22 | GitOps CI/CD Cloud Agent | `platform-cloud/gitops-ci-cd-cloud.agent.txt` | ⭐8/10 | ArgoCD, Flux, pipelines | Curva aprendizaje |
| 23 | Platform DevOps Agent | `platform-cloud/platform-devops.agent.txt` | ⭐8/10 | Infraestructura completa | - |
| 24 | SRE Agent | `platform-cloud/sre.agent.txt` | ⭐8/10 | SLOs, error budgets | - |
| 25 | Database Architect Agent | `platform-cloud/database-architect.agent.txt` | ⭐8/10 | Diseño de esquemas, índices | - |
| 26 | Backlog Management Agent | `planning/backlog-management.agent.txt` | ⭐8/10 | Definition of Ready | Métricas health |
| 27 | Load Testing Agent | `testing/load-testing.agent.txt` | ⭐9/10 | Baselines, breaking points | Uso menos frecuente |
| 28 | TypeScript/Node.js Agent | `languages/typescript-node-js.agent.txt` | ⭐8/10 | Strict mode, Fastify/Prisma/Zod | Solo TS |
| 29 | Python Agent | `languages/python.agent.txt` | ⭐8/10 | Type hints, mypy, Poetry | Solo Python |
| 30 | UI Design Agent | `design/ui-design.agent.txt` | ⭐8/10 | Design System, deliverables | Accessibility |
| 31 | Incident Commander Agent | `platform-cloud/incident-commander.agent.txt` | ⭐8/10 | Gestión de incidentes | - |
| 32 | Cloud Security Agent | `platform-cloud/cloud-security.agent.txt` | ⭐8/10 | IAM, encryption, compliance | - |
| 33 | Quality Gatekeeper Agent | `platform-cloud/quality-gatekeeper.agent.txt` | ⭐8/10 | Gates de calidad | - |
| 34 | Microservices Agent | `architecture/microservices.agent.txt` | ⭐8/10 | Patrones de microservicios | - |
| 35 | Domain-Driven Design Agent | `architecture/domain-driven-design.agent.txt` | ⭐8/10 | Bounded contexts, aggregates | - |
| 36 | Technical Debt Agent | `quality/technical-debt.agent.txt` | ⭐8/10 | Gestión de deuda técnica | - |
| 37 | Pair Programming Agent | `process/pair-programming.agent.txt` | ⭐8/10 | Modos de pairing | Heurísticas |
| 38 | Growth Hacking Agent | `growth/growth-hacking.agent.txt` | ⭐8/10 | AARRR, ICE prioritization | Especializado |

---

## 🥈 TIER B - ESCENARIOS ESPECÍFICOS (44 agentes)

| # | Agente | Archivo | Calidad | Uso Principal |
|---|--------|---------|---------|---------------|
| 39 | User Retention Agent | `growth/user-retention.agent.txt` | ⭐8/10 | Churn prevention |
| 40 | Analytics Agent | `growth/analytics.agent.txt` | ⭐8/10 | Event tracking |
| 41 | Conversion Optimization Agent | `growth/conversion-optimization.agent.txt` | ⭐8/10 | CRO, funnels |
| 42 | SEO Agent | `growth/seo.agent.txt` | ⭐8/10 | Search optimization |
| 43 | Content Marketing Agent | `growth/content-marketing.agent.txt` | ⭐8/10 | Content strategy |
| 44 | Email Marketing Agent | `growth/email-marketing.agent.txt` | ⭐8/10 | Email automation |
| 45 | Social Media Agent | `growth/social-media.agent.txt` | ⭐7/10 | Social strategy |
| 46 | Pricing Strategy Agent | `business/pricing-strategy.agent.txt` | ⭐8/10 | Pricing models |
| 47 | Monetization Agent | `business/monetization.agent.txt` | ⭐8/10 | Revenue models |
| 48 | Revenue Optimization Agent | `business/revenue-optimization.agent.txt` | ⭐8/10 | Unit economics |
| 49 | UX Research Agent | `design/ux-research.agent.txt` | ⭐8/10 | User research |
| 50 | Usability Testing Agent | `design/usability-testing.agent.txt` | ⭐8/10 | Testing protocols |
| 51 | User Journey Agent | `design/user-journey.agent.txt` | ⭐8/10 | Journey mapping |
| 52 | Prototyping Agent | `design/prototyping.agent.txt` | ⭐8/10 | Rapid prototyping |
| 53 | Market Research Agent | `discovery/market-research.agent.txt` | ⭐8/10 | TAM/SAM/SOM |
| 54 | Competitor Analysis Agent | `discovery/competitor-analysis.agent.txt` | ⭐8/10 | Competitive intel |
| 55 | User Research Agent | `discovery/user-research.agent.txt` | ⭐8/10 | User interviews |
| 56 | Sprint Planning Agent | `planning/sprint-planning.agent.txt` | ⭐7/10 | Sprint methodology |
| 57 | Estimation Agent | `planning/estimation.agent.txt` | ⭐7/10 | Story points |
| 58 | Roadmap Agent | `planning/roadmap.agent.txt` | ⭐7/10 | Product roadmap |
| 59 | Stakeholder Management Agent | `planning/stakeholder-management.agent.txt` | ⭐7/10 | Communication |
| 60 | Ethical Hacker Agent | `security/ethical-hacker-pentest-advisor.agent.txt` | ⭐8/10 | Pentesting |
| 61 | Authorization Agent | `security/authorization.agent.txt` | ⭐8/10 | RBAC/ABAC |
| 62 | Compliance Agent | `security/compliance.agent.txt` | ⭐8/10 | Regulatory |
| 63 | Secret Management Agent | `security/secret-management.agent.txt` | ⭐8/10 | Vault, secrets |
| 64 | Contract Testing Agent | `testing/contract-testing.agent.txt` | ⭐8/10 | Pact, CDC |
| 65 | A/B Testing Agent | `testing/a-b-testing.agent.txt` | ⭐8/10 | Experiments |
| 66 | Visual Regression Agent | `testing/visual-regression.agent.txt` | ⭐8/10 | Percy, Chromatic |
| 67 | Mutation Testing Agent | `testing/mutation-testing.agent.txt` | ⭐7/10 | Test quality |
| 68 | Mobile Architecture Agent | `platform-mobile/mobile-architecture.agent.txt` | ⭐8/10 | iOS/Android |
| 69 | Mobile CI/CD Agent | `platform-mobile/mobile-ci-cd.agent.txt` | ⭐8/10 | Fastlane, Bitrise |
| 70 | Mobile UI Agent | `platform-mobile/mobile-ui.agent.txt` | ⭐8/10 | Native UI |
| 71 | Mobile Security Agent | `platform-mobile/mobile-security.agent.txt` | ⭐8/10 | App security |
| 72 | Desktop Architecture Agent | `platform-desktop/desktop-architecture.agent.txt` | ⭐8/10 | Electron, Tauri |
| 73 | Container Orchestration Agent | `devops/container-orchestration.agent.txt` | ⭐8/10 | Kubernetes |
| 74 | Service Mesh Agent | `devops/service-mesh.agent.txt` | ⭐7/10 | Istio, Linkerd |
| 75 | CDN Agent | `devops/cdn.agent.txt` | ⭐7/10 | CloudFront, Fastly |
| 76 | Event-Driven Architecture Agent | `architecture/event-driven-architecture.agent.txt` | ⭐8/10 | Kafka, events |
| 77 | Clean Architecture Agent | `architecture/clean-architecture.agent.txt` | ⭐8/10 | Hexagonal |
| 78 | Monolith to Microservices Agent | `architecture/monolith-to-microservices.agent.txt` | ⭐8/10 | Strangler pattern |
| 79 | Web CI/CD Agent | `platform-web/web-ci-cd.agent.txt` | ⭐8/10 | GitHub Actions |
| 80 | Web DX Agent | `platform-web/web-dx.agent.txt` | ⭐8/10 | Developer experience |
| 81 | Web QA Agent | `platform-web/web-qa.agent.txt` | ⭐8/10 | Frontend QA |
| 82 | State Management Agent | `platform-web/state-management.agent.txt` | ⭐8/10 | Redux, Zustand |

---

## 🥉 TIER C - ESPECIALIZADOS / NICHO (97 agentes)

### Lenguajes (12 agentes)

| # | Agente | Archivo | Calidad | Uso |
|---|--------|---------|---------|-----|
| 83 | Java Agent | `languages/java.agent.txt` | ⭐8/10 | Solo Java |
| 84 | Go Agent | `languages/go.agent.txt` | ⭐8/10 | Solo Go |
| 85 | Rust Agent | `languages/rust.agent.txt` | ⭐8/10 | Solo Rust |
| 86 | C# .NET Agent | `languages/csharp-dotnet.agent.txt` | ⭐8/10 | Solo .NET |
| 87 | Ruby Agent | `languages/ruby.agent.txt` | ⭐8/10 | Solo Ruby |
| 88 | PHP Agent | `languages/php.agent.txt` | ⭐8/10 | Solo PHP |
| 89 | Swift Agent | `languages/swift.agent.txt` | ⭐8/10 | Solo Swift |
| 90 | Kotlin Agent | `languages/kotlin.agent.txt` | ⭐8/10 | Solo Kotlin |
| 91 | C/C++ Agent | `languages/c-cpp.agent.txt` | ⭐8/10 | Solo C/C++ |
| 92 | Delphi Agent | `languages/delphi.agent.txt` | ⭐8/10 | Solo Delphi |

### Migraciones Legacy (16 agentes)

| # | Agente | Archivo | Calidad | Migración |
|---|--------|---------|---------|-----------|
| 93 | COBOL Migration | `migrations/cobol-migration.agent.txt` | ⭐8/10 | COBOL→Java |
| 94 | Visual Basic 6 Migration | `migrations/visual-basic-6-migration.agent.txt` | ⭐8/10 | VB6→.NET |
| 95 | Delphi Legacy Migration | `migrations/delphi-legacy-migration.agent.txt` | ⭐8/10 | Delphi→Modern |
| 96 | FoxPro Migration | `migrations/foxpro-migration.agent.txt` | ⭐8/10 | FoxPro→SQL |
| 97 | Oracle Forms Migration | `migrations/oracle-forms-migration.agent.txt` | ⭐8/10 | Forms→Web |
| 98 | PowerBuilder Migration | `migrations/powerbuilder-migration.agent.txt` | ⭐8/10 | PB→Modern |
| 99 | RPG AS/400 Migration | `migrations/rpg-as400-migration.agent.txt` | ⭐8/10 | RPG→Java |
| 100 | Clipper Migration | `migrations/clipper-migration.agent.txt` | ⭐8/10 | Clipper→Modern |
| 101 | Informix 4GL Migration | `migrations/informix-4gl-migration.agent.txt` | ⭐7/10 | 4GL→Modern |
| 102 | Progress 4GL Migration | `migrations/progress-4gl-migration.agent.txt` | ⭐7/10 | Progress→Modern |
| 103 | Natural ADABAS Migration | `migrations/natural-adabas-migration.agent.txt` | ⭐7/10 | Natural→Modern |
| 104 | Classic ASP Migration | `migrations/classic-asp-migration.agent.txt` | ⭐7/10 | ASP→.NET |
| 105 | MUMPS Migration | `migrations/mumps-migration.agent.txt` | ⭐7/10 | MUMPS→Modern |
| 106 | PL/I Migration | `migrations/pl-i-migration.agent.txt` | ⭐7/10 | PL/I→Java |
| 107 | Fortran Migration | `migrations/fortran-migration.agent.txt` | ⭐7/10 | Fortran→Python |
| 108 | Lotus Notes Migration | `migrations/lotus-notes-migration.agent.txt` | ⭐7/10 | Notes→Modern |

### Mantenimiento Legacy (15 agentes)

| # | Agente | Archivo | Calidad | Sistema |
|---|--------|---------|---------|---------|
| 109 | COBOL Maintenance | `legacy-maintenance/cobol-maintenance.agent.txt` | ⭐7/10 | COBOL |
| 110 | Visual Basic 6 Maintenance | `legacy-maintenance/visual-basic-6-maintenance.agent.txt` | ⭐7/10 | VB6 |
| 111 | Delphi 4-7 Maintenance | `legacy-maintenance/delphi-4-7-maintenance.agent.txt` | ⭐7/10 | Delphi antiguo |
| 112 | FoxPro Maintenance | `legacy-maintenance/foxpro-maintenance.agent.txt` | ⭐7/10 | FoxPro |
| 113 | Oracle Forms Maintenance | `legacy-maintenance/oracle-forms-maintenance.agent.txt` | ⭐7/10 | Forms |
| 114 | PowerBuilder Maintenance | `legacy-maintenance/powerbuilder-maintenance.agent.txt` | ⭐7/10 | PowerBuilder |
| 115 | RPG AS/400 Maintenance | `legacy-maintenance/rpg-as400-maintenance.agent.txt` | ⭐7/10 | AS/400 |
| 116 | Clipper/Harbour Maintenance | `legacy-maintenance/clipper-harbour-maintenance.agent.txt` | ⭐7/10 | Clipper |
| 117 | Informix 4GL Maintenance | `legacy-maintenance/informix-4gl-maintenance.agent.txt` | ⭐7/10 | Informix |
| 118 | Progress 4GL Maintenance | `legacy-maintenance/progress-4gl-maintenance.agent.txt` | ⭐7/10 | Progress |
| 119 | Natural ADABAS Maintenance | `legacy-maintenance/natural-adabas-maintenance.agent.txt` | ⭐7/10 | ADABAS |
| 120 | Classic ASP Maintenance | `legacy-maintenance/classic-asp-maintenance.agent.txt` | ⭐7/10 | ASP |
| 121 | MUMPS/M Maintenance | `legacy-maintenance/mumps-m-maintenance.agent.txt` | ⭐7/10 | MUMPS |
| 122 | PL/I Maintenance | `legacy-maintenance/pli-maintenance.agent.txt` | ⭐7/10 | PL/I |
| 123 | Fortran Maintenance | `legacy-maintenance/fortran-maintenance.agent.txt` | ⭐7/10 | Fortran |

### Platform Mobile (10 agentes)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 124 | Mobile Data Agent | `platform-mobile/mobile-data.agent.txt` | ⭐7/10 | Data sync |
| 125 | Mobile QA Agent | `platform-mobile/mobile-qa.agent.txt` | ⭐7/10 | Mobile testing |
| 126 | Offline First Agent | `platform-mobile/offline-first.agent.txt` | ⭐7/10 | Offline support |
| 127 | Push Notification Agent | `platform-mobile/push-notification.agent.txt` | ⭐7/10 | Push notifications |
| 128 | Deep Linking Agent | `platform-mobile/deep-linking.agent.txt` | ⭐7/10 | Deep links |
| 129 | App Store Optimization Agent | `platform-mobile/app-store-optimization.agent.txt` | ⭐7/10 | ASO |

### Platform Desktop (4 agentes)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 130 | Desktop CI/CD Agent | `platform-desktop/desktop-ci-cd.agent.txt` | ⭐7/10 | Desktop pipelines |
| 131 | Desktop Integration Agent | `platform-desktop/desktop-integration.agent.txt` | ⭐7/10 | OS integration |
| 132 | Data Analytics Agent | `platform-desktop/data-analytics.agent.txt` | ⭐7/10 | Analytics |

### Platform Cloud (adicionales)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 133 | Chaos & Resilience Agent | `platform-cloud/chaos-resilience.agent.txt` | ⭐7/10 | Chaos engineering |
| 134 | Multi-Cloud Agent | `platform-cloud/multi-cloud.agent.txt` | ⭐7/10 | Multi-cloud |
| 135 | Serverless Agent | `platform-cloud/serverless.agent.txt` | ⭐7/10 | Lambda, Functions |
| 136 | FinOps Cost Agent | `platform-cloud/finops-cost.agent.txt` | ⭐7/10 | Cloud costs |
| 137 | Security Testing Integrator | `platform-cloud/security-testing-integrator.agent.txt` | ⭐7/10 | SAST/DAST |

### Platform Web (adicionales)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 138 | Micro-Frontend Agent | `platform-web/micro-frontend.agent.txt` | ⭐7/10 | Module federation |
| 139 | PWA Agent | `platform-web/pwa.agent.txt` | ⭐7/10 | Progressive Web Apps |
| 140 | Web BFF Backend Agent | `platform-web/web-bff-backend.agent.txt` | ⭐7/10 | Backend for frontend |
| 141 | Responsive Design Agent | `platform-web/responsive-design.agent.txt` | ⭐7/10 | Mobile-first |
| 142 | CSS Architecture Agent | `platform-web/css-architecture.agent.txt` | ⭐7/10 | BEM, SMACSS |
| 143 | Animation & Motion Agent | `platform-web/animation-motion.agent.txt` | ⭐7/10 | Animations |
| 144 | Web Accessibility Agent | `platform-web/web-accessibility.agent.txt` | ⭐6/10 | WCAG (corto) |
| 145 | Web Product Discovery Agent | `platform-web/web-product-discovery.agent.txt` | ⭐5/10 | Discovery (muy corto) |

### Process (adicionales)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 146 | Code Generator Agent | `process/code-generator.agent.txt` | ⭐7/10 | Scaffolding |
| 147 | Dependency Management Agent | `process/dependency-management.agent.txt` | ⭐7/10 | Dependencies |
| 148 | Configuration Management Agent | `process/configuration-management.agent.txt` | ⭐7/10 | Configs |
| 149 | Error Handling Agent | `process/error-handling.agent.txt` | ⭐7/10 | Error patterns |
| 150 | Feature Flag Agent | `process/feature-flag.agent.txt` | ⭐7/10 | Feature toggles |
| 151 | Logging Strategy Agent | `process/logging-strategy.agent.txt` | ⭐7/10 | Logging |
| 152 | Migration Agent | `process/migration.agent.txt` | ⭐6/10 | General migration |
| 153 | Technology Critic Agent | `process/technology-critic.agent.txt` | ⭐7/10 | Tech evaluation |
| 154 | Technology Radar Agent | `process/technology-radar.agent.txt` | ⭐6/10 | Tech landscape |
| 155 | Idea Improver Agent | `process/idea-improver.agent.txt` | ⭐5/10 | Vago, metodologías poco claras |

### Backend (5 agentes)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 156 | GraphQL Agent | `backend/graphql.agent.txt` | ⭐8/10 | GraphQL APIs |
| 157 | Caching Strategy Agent | `backend/caching-strategy.agent.txt` | ⭐8/10 | Redis, caching |
| 158 | Message Queue Agent | `backend/message-queue.agent.txt` | ⭐8/10 | RabbitMQ, SQS |
| 159 | WebSocket Real-Time Agent | `backend/websocket-real-time.agent.txt` | ⭐7/10 | Real-time |
| 160 | Search Engine Agent | `backend/search-engine.agent.txt` | ⭐7/10 | Elasticsearch |

### Data (3 agentes)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 161 | Data Pipeline Agent | `data/data-pipeline.agent.txt` | ⭐8/10 | ETL, pipelines |
| 162 | Data Quality Agent | `data/data-quality.agent.txt` | ⭐7/10 | Data validation |
| 163 | ML Ops Agent | `data/ml-ops.agent.txt` | ⭐7/10 | ML pipelines |

### Docs (4 agentes)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 164 | ADR Agent | `docs/adr.agent.txt` | ⭐8/10 | Architecture Decision Records |
| 165 | Docs & Knowledge Agent | `docs/docs-knowledge.agent.txt` | ⭐7/10 | Documentation |
| 166 | Documentador Agent | `docs/documentador.agent.txt` | ⭐7/10 | Auto-documentation |
| 167 | Onboarding Agent | `docs/onboarding.agent.txt` | ⭐7/10 | Developer onboarding |

### Integrations (5 agentes)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 168 | Payment Integration Agent | `integrations/payment-integration.agent.txt` | ⭐8/10 | Stripe, payments |
| 169 | Email Delivery Agent | `integrations/email-delivery.agent.txt` | ⭐7/10 | SendGrid, SES |
| 170 | File Storage Agent | `integrations/file-storage.agent.txt` | ⭐7/10 | S3, storage |
| 171 | Notification Hub Agent | `integrations/notification-hub.agent.txt` | ⭐7/10 | Multi-channel |
| 172 | Third-Party Integration Agent | `integrations/third-party-integration.agent.txt` | ⭐7/10 | APIs externas |

### Operations (4 agentes)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 173 | Release Manager Agent | `operations/release-manager.agent.txt` | ⭐8/10 | Releases |
| 174 | Runbook & Operations Agent | `operations/runbook-operations.agent.txt` | ⭐8/10 | Runbooks |
| 175 | Postmortem & Learning Agent | `operations/postmortem-learning.agent.txt` | ⭐8/10 | Blameless postmortems |
| 176 | Capacity & Cost Governance Agent | `operations/capacity-cost-governance.agent.txt` | ⭐7/10 | Capacity planning |

### Product (2 agentes)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 177 | Design System Steward Agent | `product/design-system-steward.agent.txt` | ⭐8/10 | Design system |
| 178 | i18n Agent | `product/i18n.agent.txt` | ⭐7/10 | Internacionalización |

### Security (adicional)

| # | Agente | Archivo | Calidad | Función |
|---|--------|---------|---------|---------|
| 179 | License Reviewer & OSS Agent | `security/license-reviewer-oss-alternatives.agent.txt` | ⭐6/10 | License compliance |

---

## Resumen de Calidad

| Calificación | Cantidad | % |
|--------------|----------|---|
| ⭐10/10 | 5 | 3% |
| ⭐9/10 | 18 | 10% |
| ⭐8/10 | 72 | 40% |
| ⭐7/10 | 76 | 42% |
| ⭐6/10 | 6 | 3% |
| ⭐5/10 | 2 | 1% |

---

## Recomendaciones por Tamaño de Equipo

### Startup (2-5 devs) - Kit mínimo: 6 agentes
1. Bug Hunter
2. Test Strategy
3. Code Review
4. Web Architecture
5. API Design
6. Global Policy

### Scale-up (10-20 devs) - Agregar 12 más:
- Performance & Efficiency
- E2E Testing
- Authentication
- Threat Modeling
- Cloud Architecture
- Observability
- GitOps CI/CD
- Database Architect
- Product Vision
- MVP Definition
- Backlog Management
- TypeScript/Python Agent (según stack)

### Enterprise (50+ devs) - Agregar todos Tier A + B relevantes
- Compliance, Ethical Hacker, Authorization
- All Planning agents
- All Security agents
- Contract Testing, Load Testing
- Infrastructure as Code
- SRE, Incident Commander

---

*Última actualización: Enero 2026*
