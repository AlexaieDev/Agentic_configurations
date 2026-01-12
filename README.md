# Agentic Configurations

Repositorio centralizado de agentes especializados para desarrollo de software asistido por IA. Contiene 106 agentes únicos organizados en una estructura modular, diseñados para usar con Claude Code.

**Repositorio GitHub:** https://github.com/AlexaieDev/Agentic_configurations

---

## Estructura del Repositorio (v3.0)

```
agentic-configurations/
├── agents/                    # FUENTE ÚNICA - Todos los agentes
│   ├── _global/               # Políticas globales
│   ├── platform-web/          # Web (14 agentes)
│   ├── platform-mobile/       # Mobile (11 agentes)
│   ├── platform-desktop/      # Desktop (4 agentes)
│   ├── platform-cloud/        # Cloud/Infra (14 agentes)
│   ├── architecture/          # Arquitectura (5 agentes)
│   ├── backend/               # Backend (5 agentes)
│   ├── devops/                # DevOps (4 agentes)
│   ├── security/              # Seguridad (8 agentes)
│   ├── testing/               # Testing (7 agentes)
│   ├── data/                  # Data (3 agentes)
│   ├── integrations/          # Integraciones (5 agentes)
│   ├── quality/               # Calidad (5 agentes)
│   ├── product/               # Producto (2 agentes)
│   ├── docs/                  # Documentación (4 agentes)
│   ├── operations/            # Operaciones (4 agentes)
│   └── process/               # Proceso (9 agentes)
│
├── packs/                     # Manifiestos de packs
│   ├── pack.schema.json       # Schema de validación
│   ├── claude-code-ultra/     # Pack principal (manifest.json)
│   ├── squad-operativo/       # Pack operativo (manifest.json)
│   └── kits/                  # Kits por caso de uso
│       ├── startup-web.json
│       ├── incident-response.json
│       └── enterprise-platform.json
│
├── catalog/                   # Índice centralizado
│   ├── index.json             # Catálogo maestro
│   └── categories.json        # Definición de categorías
│
├── docs/                      # Documentación
├── web/                       # UI interactiva
│   └── index.html
├── scripts/                   # Herramientas de migración
└── README.md
```

---

## Packs Disponibles

### Claude Code Pack v3.0 ULTRA
**Manifiesto:** `packs/claude-code-ultra/manifest.json`

Pack principal con 106 agentes para desarrollo full-stack enterprise.

**Categorías:**
| Categoría | Agentes | Descripción |
|-----------|---------|-------------|
| platform-web | 14 | Frontend, accesibilidad, PWA, micro-frontends |
| platform-mobile | 11 | iOS, Android, cross-platform |
| platform-cloud | 14 | Cloud, DevOps, SRE, observabilidad |
| architecture | 5 | DDD, microservicios, event-driven |
| security | 8 | PenTest, threat modeling, auth |
| testing | 7 | E2E, load, contract, visual regression |
| quality | 5 | Bug hunting, code review, tech debt |

### Squad Operativo v2.6 ULTRA
**Manifiesto:** `packs/squad-operativo/manifest.json`

Pack operativo para gestión de incidentes (6 agentes clave).

**Agentes:**
- Incident Commander
- Runbook & Operations
- Postmortem & Learning
- Chaos & Resilience
- Capacity & Cost Governance
- Documentador

---

## Kits Predefinidos

| Kit | Target | Agentes |
|-----|--------|---------|
| startup-web | 1-5 devs | 8 agentes esenciales para startups web |
| incident-response | any | 6 agentes para respuesta a incidentes |
| enterprise-platform | 50+ devs | 18 agentes para plataformas enterprise |

---

## Cómo Usar

### 1. Navegación por Web UI (Recomendado)
1. Abre `web/index.html` en tu navegador
2. Busca agentes por nombre o concepto
3. Copia el contenido con "Copy to Clipboard"
4. Pega en el System Prompt de Claude Code

### 2. Acceso Directo
```bash
# Ver un agente específico
cat agents/quality/bug-hunter.agent.txt

# Listar agentes por categoría
ls agents/platform-web/
```

### 3. Usar un Pack Completo
1. Lee el manifiesto: `packs/claude-code-ultra/manifest.json`
2. El manifiesto lista todos los agentes con rutas relativas
3. Copia los agentes que necesites según el `use_case_routing`

---

## Convenciones de Nombrado

| Tipo | Formato | Ejemplo |
|------|---------|---------|
| Archivos de agentes | `kebab-case.agent.txt` | `bug-hunter.agent.txt` |
| Carpetas de categoría | `kebab-case` | `platform-web/` |
| Carpetas especiales | Prefijo `_` | `_global/` |

---

## Adopción por Madurez

### Startup (1-5 devs)
Kit: `packs/kits/startup-web.json`
- Web Architecture + Frontend
- Bug Hunter + Test Strategy
- Auth + Secrets
- Logging + Error Handling

### Scale-up (6-20 devs)
Agregar:
- API Design + Code Review
- Database Architect + Observability
- Feature Flags + Contract Testing
- ADR + Onboarding

### Enterprise (50+ devs)
Kit: `packs/kits/enterprise-platform.json`
- Microservices + Event-Driven + DDD
- Container Orchestration + Service Mesh
- SRE + Chaos Engineering
- Threat Modeling + Compliance
- Data Pipeline + MLOps

---

## Orquestación por Caso de Uso

### Bug en Producción
```
1. bug-hunter.agent.txt
2. observability.agent.txt
3. incident-commander.agent.txt
4. logging-strategy.agent.txt
```

### Nueva Feature de Alto Riesgo
```
1. web-product-discovery.agent.txt
2. threat-modeling.agent.txt
3. api-design.agent.txt
4. test-strategy.agent.txt
5. feature-flag.agent.txt
```

### Migración a Microservicios
```
1. monolith-to-microservices.agent.txt
2. microservices.agent.txt
3. event-driven-architecture.agent.txt
4. service-mesh.agent.txt
```

---

## Global Policy

**Archivo:** `agents/_global/global-policy.agent.txt`

9 principios obligatorios que aplican a todos los agentes:
1. Reutilización por defecto
2. Modularidad y límites claros
3. Contratos y versionado
4. Calidad proporcional al riesgo
5. Seguridad por defecto
6. Observabilidad mínima
7. Simplicidad y evolución
8. Documentación viva y breve
9. Estándar de herramientas

---

## Instalación

```bash
git clone https://github.com/AlexaieDev/Agentic_configurations.git
cd Agentic_configurations
```

---

## Notas de Versión

### v3.0 (Enero 2026)
- **Reestructuración completa**: 243 archivos → 106 agentes únicos
- **Centralización**: Eliminada duplicación entre packs
- **Nuevo formato**: `kebab-case.agent.txt`
- **Manifiestos JSON**: Packs como referencias, no copias
- **Catálogo centralizado**: `catalog/index.json`
- **Kits predefinidos**: startup-web, incident-response, enterprise-platform

### v2.5 ULTRA
- Ethical Hacker & PenTest Advisor
- Threat Modeling
- Security Testing Integrator

### v2.4
- License Reviewer & OSS Alternatives

---

## Recursos

- **Catálogo:** `catalog/index.json`
- **Web UI:** `web/index.html`
- **Schema de packs:** `packs/pack.schema.json`

---

**Última actualización:** Enero 2026
