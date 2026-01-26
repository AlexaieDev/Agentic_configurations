# 🤖 Agentic Configurations

<div align="center">

**179 agentes especializados para desarrollo de software con IA**

Cubre el ciclo completo: Discovery → Planning → Design → Development → Testing → Deploy → Growth

[![Agentes](https://img.shields.io/badge/Agentes-179-blue)](./agents)
[![Categorías](https://img.shields.io/badge/Categorías-25-green)](./catalog)
[![Licencia](https://img.shields.io/badge/Licencia-MIT-yellow)](./LICENSE)

[Demo Web](./web/index.html) • [Catálogo](./catalog/index.json) • [Guía Rápida](#-guía-rápida)

</div>

---

## ✨ ¿Qué es esto?

Una colección curada de **System Prompts** para potenciar Claude Code y otros asistentes de IA. Cada agente es un especialista en un área específica del desarrollo de software.

```
💡 Idea → 🔍 Research → 📋 Planning → 🎨 Design → 💻 Code → 🧪 Test → 🚀 Deploy → 📈 Growth
```

**Un agente para cada fase. Un equipo completo de IA.**

---

## 🎯 Capacidades

### 🔍 Discovery & Research
| Agente | Función |
|--------|---------|
| Market Research | Análisis de mercado y oportunidades |
| Competitor Analysis | Benchmarking competitivo |
| User Research | Investigación de usuarios y necesidades |
| Product Vision | Definición de visión de producto |
| MVP Definition | Alcance mínimo viable |

### 📋 Planning & Strategy
| Agente | Función |
|--------|---------|
| Estimation | Estimación de esfuerzo y recursos |
| Roadmap | Planificación de roadmap |
| Sprint Planning | Organización de sprints |
| Backlog Management | Gestión de backlog |
| Stakeholder Management | Comunicación con stakeholders |

### 🎨 Design & UX
| Agente | Función |
|--------|---------|
| UX Research | Investigación de experiencia de usuario |
| UI Design | Diseño de interfaces |
| Prototyping | Creación de prototipos |
| User Journey | Mapeo de journeys |
| Usability Testing | Testing de usabilidad |

### 💻 Development
| Categoría | Agentes | Incluye |
|-----------|---------|---------|
| **Platform Web** | 15 | Frontend, Backend, PWA, Micro-frontends, BFF |
| **Platform Mobile** | 10 | iOS, Android, React Native, Flutter |
| **Platform Desktop** | 4 | Electron, Cross-platform |
| **Platform Cloud** | 14 | AWS, Azure, GCP, Serverless |
| **Architecture** | 5 | DDD, Microservices, Event-Driven |
| **Backend** | 5 | GraphQL, Message Queue, Caching |
| **Languages** | 12 | Python, Java, Go, Rust, C#, TypeScript... |

### 🧪 Quality & Testing
| Agente | Función |
|--------|---------|
| Bug Hunter | Detección proactiva de bugs |
| Test Strategy | Estrategia de testing |
| E2E Testing | Tests end-to-end |
| Load Testing | Tests de carga |
| Security Testing | Tests de seguridad |

### 🔒 Security
| Agente | Función |
|--------|---------|
| Threat Modeling | Modelado de amenazas |
| Ethical Hacker | Pentesting y vulnerabilidades |
| Cloud Security | Seguridad en cloud |
| Auth & Secrets | Autenticación y secretos |

### 🚀 DevOps & Operations
| Agente | Función |
|--------|---------|
| CI/CD | Pipelines de integración continua |
| GitOps | Operaciones basadas en Git |
| SRE | Site Reliability Engineering |
| Incident Commander | Gestión de incidentes |
| Observability | Monitoreo y trazabilidad |

### 📈 Growth & Marketing
| Agente | Función |
|--------|---------|
| SEO | Optimización para buscadores |
| Content Marketing | Estrategia de contenidos |
| Analytics | Análisis de métricas |
| Conversion Optimization | Optimización de conversión |
| Growth Hacking | Estrategias de crecimiento |
| User Retention | Retención de usuarios |

### 💼 Business
| Agente | Función |
|--------|---------|
| Business Model | Modelado de negocio |
| Pricing Strategy | Estrategia de precios |
| Monetization | Estrategias de monetización |
| Revenue Optimization | Optimización de ingresos |

### 🔄 Legacy & Migrations
| Tipo | Lenguajes Soportados |
|------|---------------------|
| **Mantenimiento** | COBOL, Delphi, VB6, FoxPro, RPG/AS400, Oracle Forms, PowerBuilder... |
| **Migración** | Rutas de migración a tecnologías modernas para cada legacy |

---

## 🚀 Guía Rápida

### Opción 1: Web UI (Recomendado)

1. Abre [`web/index.html`](./web/index.html) en tu navegador
2. Busca agentes por nombre o keyword
3. Agrega a **Mi Stack** los que necesites
4. Copia todo con un click
5. Pega en Claude Code como System Prompt

### Opción 2: Directo desde archivos

```bash
# Clonar repositorio
git clone https://github.com/AlexaieDev/Agentic_configurations.git

# Ver un agente
cat agents/quality/bug-hunter.agent.txt

# Listar categoría
ls agents/growth/
```

---

## 🎮 Web UI Features

<table>
<tr>
<td width="50%">

### 🔍 Búsqueda Inteligente
- Por nombre de agente
- Por keywords semánticas
- Por contenido del prompt

</td>
<td width="50%">

### 📦 Mi Stack
- Guarda tu selección de agentes
- Persiste entre sesiones
- Exporta todo con un click

</td>
</tr>
<tr>
<td>

### 🔄 Workflows
- Flujos predefinidos por problema
- Secuencias optimizadas
- Signals de cuándo usar cada uno

</td>
<td>

### 🏢 Kits por Madurez
- Startup (1-5 devs)
- Scale-up (6-20 devs)
- Enterprise (80+ devs)

</td>
</tr>
</table>

---

## 📂 Estructura

```
📦 agentic-configurations
├── 🤖 agents/           # 179 agentes organizados por categoría
├── 📋 catalog/          # Índice JSON centralizado
├── 🌐 web/              # UI interactiva
├── 📜 scripts/          # Herramientas de generación
└── 📦 packs/            # Manifiestos y kits predefinidos
```

---

## 🎯 Casos de Uso

<details>
<summary><b>🐛 Bug en Producción</b></summary>

```
1. Bug Hunter Agent
2. Observability Agent
3. Incident Commander Agent
4. Postmortem Agent
```
</details>

<details>
<summary><b>🚀 Nueva Feature (Idea a Producción)</b></summary>

```
1. Market Research Agent
2. Product Vision Agent
3. UX Research Agent
4. UI Design Agent
5. Sprint Planning Agent
6. Code Generator Agent
7. Test Strategy Agent
8. Growth Hacking Agent
```
</details>

<details>
<summary><b>📈 Optimizar Conversión</b></summary>

```
1. Analytics Agent
2. Conversion Optimization Agent
3. User Retention Agent
4. Growth Hacking Agent
```
</details>

<details>
<summary><b>🔄 Migrar Sistema Legacy</b></summary>

```
1. [Legacy]-Migration Agent (COBOL, VB6, etc.)
2. Database Architect Agent
3. Test Strategy Agent
4. Observability Agent
```
</details>

---

## 🏷️ Todas las Categorías

| Categoría | # | Categoría | # |
|-----------|---|-----------|---|
| `_global` | 2 | `languages` | 12 |
| `architecture` | 5 | `legacy-maintenance` | 15 |
| `backend` | 5 | `migrations` | 16 |
| `business` | 4 | `operations` | 4 |
| `data` | 3 | `planning` | 5 |
| `design` | 5 | `platform-cloud` | 14 |
| `devops` | 4 | `platform-desktop` | 4 |
| `discovery` | 5 | `platform-mobile` | 10 |
| `docs` | 4 | `platform-web` | 15 |
| `growth` | 8 | `process` | 12 |
| `integrations` | 5 | `product` | 2 |
| `quality` | 5 | `security` | 8 |
| `testing` | 7 | | |

---

## 🤝 Contribuir

1. Fork del repositorio
2. Crea tu agente en `agents/[categoria]/[nombre].agent.txt`
3. Ejecuta `./scripts/generate-web-data.ps1`
4. Pull Request

---

## 📄 Licencia

MIT © 2026

---

<div align="center">

**[⬆ Volver arriba](#-agentic-configurations)**

Made with 🤖 for developers who love AI

</div>
