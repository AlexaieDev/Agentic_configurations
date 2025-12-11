# Agentic Configurations

Repositorio de configuraciones de agentes especializados para desarrollo de software asistido por IA. Contiene 4 packs de agentes listos para usar en Claude Code, diseñados para acelerar delivery manteniendo calidad, modularidad y seguridad.

**Repositorio GitHub:** https://github.com/AlexaieDev/Agentic_configurations

---

## Contenido del Repositorio

### 1. Packs de Agentes

#### Agentes Claude Code Pack v2.5 ULTRA
**Directorio:** `Agentes_Claude_Code_Pack_v2_5_ULTRA/`

Pack principal con agentes organizados por plataforma y función transversal:

**Plataformas:**
- **Web:** Architecture, Frontend, BFF-Backend, QA, CI-CD, DX, Product-Discovery, Accessibility
- **Mobile:** Architecture, UI, Data, QA, CI-CD, Security
- **Desktop:** Architecture, Integration, CI-CD
- **Cloud:** Architecture, Platform-DevOps, GitOps CI-CD, Security, Observability, SRE

**Transversales (Code Health):**
- Bug Hunter
- Refactor & Code Quality
- Performance & Efficiency
- Test Strategy
- Technology Critic & Improvement

**Especializados:**
- Data & Analytics
- Design System Steward
- Quality Gatekeeper
- Release Manager
- Docs & Knowledge
- License Reviewer & OSS Alternatives
- Ethical Hacker & PenTest Advisor
- Threat Modeling
- Security Testing Integrator

**Archivos clave:**
- `Global Policy Agent Rules.txt` (en `/agents/global/`)
- `Agent Selector & Orchestration Advisor.txt`
- `index.json` - Catálogo completo de agentes
- `README.md` - Guía de adopción y orquestación

---

#### Squad Operativo 1.0 v2.6 ULTRA
**Directorio:** `Squad_Operativo_1_0_v2_6_ULTRA/`

Pack operativo autocontenido para gestión de incidentes, resiliencia y gobernanza de costo.

**Agentes incluidos:**
- Incident Commander Agent
- Runbook & Operations Agent
- Postmortem & Learning Agent
- Chaos & Resilience Agent
- Capacity & Cost Governance Agent
- Documentador Agent

**Uso recomendado:**
- Equipos pequeños en producción
- Startups con 1-2 servicios críticos
- Reducir MTTR rápidamente
- Complementar el pack principal en equipos multi-squad

---

#### Condo Admin 1.0
**Archivos:** `Condo_Admin_1_0_Agent_Pack.zip`, `Modular_Condo_Tech_Agents_1_0.zip`

Pack especializado para sistemas de administración de condominios.

**Funcionalidades cubiertas:**
- Cálculo y publicación de gastos comunes
- Estado de cuenta por unidad
- Pagos online con idempotencia y conciliación
- Portal web de residentes y administración
- App mobile para residentes
- Notificaciones y observabilidad

**Agentes clave:**
- Condo Product-Discovery
- Condo Domain Model & Architecture
- Condo Interface & API Contracts
- Agentes dev (web/mobile/backend)
- Agentes de finanzas y seguridad

---

#### Global Policy v2.5
**Directorio:** `Agentes/`

Políticas globales y agentes base reutilizables.

**Contenido:**
- Global Policy Agent Rules
- Agentes por categoría (architecture, development, security, platform_ops, quality, product, etc.)
- Plantillas base para proyectos genéricos

---

### 2. Web UI - Catálogo Interactivo

**Archivo:** `web/index.html`

Interfaz web interactiva para navegar y utilizar todos los agentes.

**Características:**
- Catálogo visual de todos los agentes con tarjetas organizadas
- **Buscador semántico** con keywords inteligentes
- Modal con contenido completo de cada agente (contenido real de los .txt)
- Botón copy-to-clipboard para copiar configuraciones directamente
- Filtros por pack, categoría y plataforma
- Diagramas de workflow sugeridos
- Kits recomendados por tamaño de equipo (1-5, 6-20, 21-80, 80+ devs)
- Tema oscuro/claro
- Diseño responsive

**Buscador Semántico:**

El buscador encuentra agentes por conceptos relacionados, no solo por nombre:

| Búsqueda | Agentes que encuentra |
|----------|----------------------|
| `rapidez`, `optimizacion` | Performance, Refactor, SRE, Capacity |
| `hacking`, `seguridad` | Ethical Hacker, Threat Modeling, Security Testing |
| `testing`, `pruebas`, `qa` | Test Strategy, Bug Hunter, Web QA, Mobile QA |
| `documentador`, `readme`, `docs` | Documentador Agent, Docs & Knowledge |
| `devops`, `pipeline`, `cicd` | Platform-DevOps, GitOps CI-CD, todos los CI-CD |
| `incidente`, `postmortem` | Incident Commander, Postmortem & Learning |
| `arquitectura`, `microservicios` | Web/Mobile/Cloud Architecture |
| `frontend`, `ui`, `componentes` | Frontend Web, Mobile UI, Design System |
| `backend`, `api`, `bff` | Web BFF-Backend, Cloud Architecture |
| `costo`, `ahorro`, `finops` | Capacity & Cost Governance |

También busca en el **contenido completo** del agente.

**Cómo usar:**
1. Abre `web/index.html` en tu navegador
2. Usa el buscador para encontrar agentes por concepto (ej: "testing", "hacking")
3. Filtra por pack, categoría o plataforma si lo necesitas
4. Haz clic en una tarjeta para ver el contenido completo
5. Usa el botón "Copy to Clipboard" para copiar la configuración
6. Pega el contenido en el System Prompt de tu agente en Claude Code

---

## Estructura de Carpetas

```
Agentic_configurations/
├── Agentes/                              # Global Policy y agentes base
│   ├── agents/
│   │   ├── global/                       # Políticas globales
│   │   ├── architecture/
│   │   ├── development/
│   │   ├── security/
│   │   ├── platform_ops/
│   │   ├── quality/
│   │   ├── product/
│   │   ├── comms/
│   │   ├── docs/
│   │   └── payments_finance/
│   ├── index.json
│   ├── index.txt
│   └── README.md
│
├── Agentes_Claude_Code_Pack_v2_5_ULTRA/  # Pack principal
│   ├── agents/
│   │   ├── web/                          # 8 agentes web
│   │   ├── mobile/                       # 5 agentes mobile
│   │   ├── desktop/                      # 3 agentes desktop
│   │   ├── cloud/                        # 6 agentes cloud
│   │   ├── transversal/                  # 5 agentes transversales
│   │   ├── security/                     # 3 agentes security
│   │   └── global/                       # Selector y políticas
│   ├── index.json
│   └── README.md
│
├── Squad_Operativo_1_0_v2_6_ULTRA/       # Pack operativo
│   ├── agents/
│   │   ├── Incident Commander Agent.txt
│   │   ├── Runbook & Operations Agent.txt
│   │   ├── Postmortem & Learning Agent.txt
│   │   ├── Chaos & Resilience Agent.txt
│   │   ├── Capacity & Cost Governance Agent.txt
│   │   └── Documentador Agent.txt
│   ├── index.json
│   └── README.md
│
├── Condo_Admin_1_0_Agent_Pack.zip        # Pack Condo (comprimido)
├── Modular_Condo_Tech_Agents_1_0.zip     # Variante modular
│
├── web/
│   └── index.html                        # Catálogo interactivo
│
└── README.md                             # Este archivo
```

---

## Cómo Usar los Agentes

### Método 1: Usando la Web UI (Recomendado)

1. Abre `web/index.html` en tu navegador
2. Navega por el catálogo usando los filtros
3. Selecciona el agente que necesitas
4. Copia el contenido completo con el botón "Copy to Clipboard"
5. Ve a Claude Code y crea un nuevo agente
6. Pega el contenido en el System Prompt
7. Guarda el agente

### Método 2: Desde archivos .txt

1. Navega al directorio del pack correspondiente
2. Abre el archivo `.txt` del agente deseado
3. Copia todo el contenido
4. En Claude Code, crea un nuevo agente
5. Pega el contenido en el System Prompt
6. Guarda el agente

### Aplicar Global Policy (Obligatorio)

La Global Policy es tu defensa anti-hype y anti-deuda técnica.

**Opción A - Prefijo manual:**

Agrega al inicio del System Prompt de cada agente:

```
[GLOBAL POLICY — OBLIGATORIA]
(Pega aquí el contenido de "Global Policy Agent Rules.txt")
[FIN GLOBAL POLICY]

[AGENT ROLE]
(Resto del prompt del agente)
```

**Opción B - Configuración base del workspace:**

Si Claude Code soporta instrucciones compartidas:
1. Configura `Global Policy Agent Rules.txt` como política común
2. Mantén cada agente solo con su prompt específico

---

## Núcleo Mínimo por Tipo de Producto

### Web-first (Startup)
- Web Architecture
- Frontend Web
- Web BFF/Backend
- Web CI-CD
- Bug Hunter
- Test Strategy

### Mobile-first (Startup)
- Mobile Architecture
- Mobile UI
- Mobile Data
- Mobile CI-CD
- Bug Hunter

### Desktop-first (Startup)
- Desktop Architecture
- Desktop Integration
- Desktop CI-CD
- Bug Hunter

### Cloud/Platform
- Cloud Architecture
- Platform/DevOps
- GitOps CI-CD Cloud
- Cloud Security
- Observability

---

## Adopción por Madurez de Equipo

### Startup temprana (1-5 devs)
- 4-6 agentes máximo
- Evitar complejidad operativa
- Foco en delivery rápido

### Scale-up (6-20 devs)
Agregar transversales obligatorios:
- Bug Hunter
- Refactor & Code Quality
- Test Strategy
- Performance & Efficiency
- DX Agent

### Multi-squad (21-80 devs)
- Formalizar plantillas de repos y pipelines
- Activar Observability + Cloud Security
- Usar Technology Critic para gobernanza del stack

### Enterprise/regulado (80+ devs)
- Global Policy obligatoria en todos los agentes
- Cloud Security + Observability + SRE como estándar
- Technology Critic en todas las decisiones mayores
- Quality Gatekeeper para gates automatizados

---

## Ejemplos de Orquestación

### Bug crítico en producción (Web)

**Orden recomendado:**
1. **Bug Hunter Agent** - Reproduce, identifica causa raíz, crea test de regresión
2. **Observability Agent** - Mejora logs/traces para confirmar hipótesis
3. **Test Strategy Agent** - Ajusta niveles de tests para evitar regresión
4. **Web CI/CD Agent** - Agrega gate de regresión
5. **Refactor & Code Quality Agent** - Solo si el bug revela duplicación sistémica

**Definición de éxito:**
- Bug no se repite
- Test de regresión integrado al pipeline
- Solución mínima y segura

### Nueva feature Web con ambigüedad

**Orden recomendado:**
1. **Web Product-Discovery Agent** - Define historia, criterios de aceptación, métricas
2. **Web Architecture Agent** - Define render strategy, modularidad UI, BFF
3. **Web BFF/Backend Agent** - Dominio y contratos
4. **Frontend Web Agent** - Implementación UI
5. **Web QA Agent + Test Strategy Agent** - Testing proporcional al riesgo
6. **Web CI/CD Agent** - Pipeline
7. **Observability Agent** - RUM + métricas post-release

### Reducir costo cloud y latencia

**Orden recomendado:**
1. **Observability Agent** - Evidencia de dónde se consume costo/latencia
2. **Performance & Efficiency Agent** - Optimizaciones medibles
3. **Cloud Architecture Agent** - Corregir anti-patterns sistémicos
4. **Platform/DevOps Agent** - Aplicar cambios IaC modulares
5. **GitOps CI-CD Cloud Agent** - Despliegue canary/rollback seguro
6. **Cloud Security Agent** - Validar que no se rompan guardrails

---

## Instalación y Requisitos

### Requisitos
- Acceso a Claude Code (Anthropic)
- Navegador web moderno (para la Web UI)

### Instalación

**Opción 1: Clonar repositorio**
```bash
git clone https://github.com/AlexaieDev/Agentic_configurations.git
cd Agentic_configurations
```

**Opción 2: Descargar ZIP**
1. Descarga desde GitHub
2. Extrae el archivo
3. Navega a la carpeta del proyecto

### Uso de packs comprimidos

Para los archivos `.zip` (Condo Admin):
```bash
unzip Condo_Admin_1_0_Agent_Pack.zip -d Condo_Admin_1_0/
```

---

## Packs Disponibles - Resumen

| Pack | Agentes | Propósito | Cuándo usar |
|------|---------|-----------|-------------|
| **Claude Code Pack v2.5 ULTRA** | 40+ | Desarrollo full-stack enterprise | Proyectos web, mobile, desktop, cloud |
| **Squad Operativo v2.6 ULTRA** | 6 | Operaciones e incidentes | Equipos en producción, reducir MTTR |
| **Condo Admin 1.0** | 15+ | Sistema de condominios | Dominio específico de administración |
| **Global Policy v2.5** | Base | Políticas y estándares | Todos los proyectos |

---

## Checklist de Adopción Rápida (1 semana)

**Día 1-2:**
- Instalar núcleo mínimo de tu plataforma principal
- Agregar Global Policy a todos los agentes

**Día 3-4:**
- Activar Bug Hunter + Test Strategy
- Ajustar CI/CD para exigir tests clave

**Día 5:**
- Añadir Refactor & Code Quality + DX
- Identificar 1-2 módulos para extracción reusable

**Día 6-7:**
- Definir dashboards mínimos de calidad/entrega
- Usar Technology Critic en propuestas de nuevas herramientas

---

## Filosofía: "Minimum Useful Documentation"

Todo agente responde:
1. **Purpose**: Qué hace y por qué existe
2. **Boundaries**: Qué NO hace, limitaciones
3. **Public API**: Cuál es su interfaz
4. **Examples**: Ejemplos de uso funcionales
5. **Testing**: Cómo verificar que funciona
6. **Deployment**: Cómo desplegarlo (si aplica)

---

## Personalización Recomendada

Para adaptar a tu stack:

1. **Herramientas específicas:**
   - Web: Next.js/React/Angular, Storybook
   - Mobile: Kotlin/Swift/KMP/Flutter
   - Cloud: AWS/GCP/Azure, K8s, Terraform, ArgoCD

2. **Convenciones de repos:**
   - Nombres de módulos
   - Estándar de versionado
   - Política de deprecación

3. **Plantillas:**
   - Repos base
   - Pipelines base
   - Módulos IaC base

---

## Consejos de Uso

- Mantener agentes con **una responsabilidad principal**
- Usar **Agent Selector** cuando el equipo no esté seguro de por dónde empezar
- Priorizar **modularidad y reutilización** antes que nuevas tecnologías
- Todo fix de bug relevante debe incluir **test de regresión**
- No usar E2E como solución universal (unit + integration + contract suelen ser mejores)

---

## Contribuir

Este repositorio está diseñado para uso interno y personalización.

Tu valor real aparecerá cuando:
- Adaptes los prompts a tu stack específico
- Establezcas plantillas reales de repos/pipelines/módulos compartidos
- Documentes tus casos de uso y orquestaciones exitosas

---

## Licencia

Para uso interno y personalización por organización.

---

## Contacto y Recursos

- **Repositorio:** https://github.com/AlexaieDev/Agentic_configurations
- **Catálogo Web:** Abre `web/index.html` en tu navegador
- **Documentación de cada pack:** Ver README.md en cada directorio

---

## Notas de Versión

### v2.5 ULTRA
- Ethical Hacker & PenTest Advisor Agent
- Threat Modeling Agent
- Security Testing Integrator Agent

### v2.4
- License Reviewer & OSS Alternatives Agent

### v2.3 ULTRA
- Data & Analytics Agent
- Design System Steward Agent
- Quality Gatekeeper Agent

### v2.2
- Web Accessibility Agent
- Mobile Security Agent
- Release Manager Agent
- Docs & Knowledge Agent

---

**Última actualización:** Diciembre 2025
