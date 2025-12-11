# Agentes Claude Code Pack — README Maestro

Este repositorio/pack contiene prompts listos para copiar y usar como **System Prompts** de agentes especializados para ingeniería de software, organizados por plataforma (**Web, Mobile, Desktop, Cloud/Platform**) y por funciones transversales de **Code Health**.

Incluye además:
- `Global Policy Agent Rules.txt` (política base recomendada)
- `index.txt` (guía de selección por tamaño/madurez)
- `Agent Selector & Orchestration Advisor.txt` (router de agentes)

---

## 1) Objetivo del pack

Acelerar delivery sin sacrificar:
- **reutilización modular**
- **arquitectura evolutiva**
- **calidad y testing modernos**
- **seguridad por defecto**
- **observabilidad y confiabilidad**
- **DX y estandarización**

Este pack está diseñado para que puedas empezar con un **núcleo mínimo** y escalar a un **ecosistema enterprise** sin reescribir la estrategia.

---

## 2) Estructura sugerida de carpeta

Si quieres mantenerlo ordenado en un repo propio:

```
agents/
  global/
    Global Policy Agent Rules.txt
    Agent Selector & Orchestration Advisor.txt
    index.txt
  web/
    Web Architecture Agent.txt
    Frontend Web Agent.txt
    Web BFF-Backend Agent.txt
    Web QA Agent.txt
    Web CI-CD Agent.txt
    Web DX Agent.txt
    Web Product-Discovery Agent.txt
  mobile/
    Mobile Architecture Agent.txt
    Mobile UI Agent.txt
    Mobile Data Agent.txt
    Mobile QA Agent.txt
    Mobile CI-CD Agent.txt
  desktop/
    Desktop Architecture Agent.txt
    Desktop Integration Agent.txt
    Desktop CI-CD Agent.txt
  cloud/
    Cloud Architecture Agent.txt
    Platform-DevOps Agent.txt
    GitOps CI-CD Cloud Agent.txt
    Cloud Security Agent.txt
    Observability Agent.txt
    SRE Agent.txt
  transversal/
    Bug Hunter Agent.txt
    Refactor & Code Quality Agent.txt
    Performance & Efficiency Agent.txt
    Test Strategy Agent.txt
    Technology Critic & Improvement Agent.txt
```

---

## 3) Cómo instalarlos en Claude Code

> Los pasos exactos pueden variar según tu interfaz, pero la lógica general es la misma.

### Método A — Agentes individuales

1) Crea un agente nuevo en Claude Code.  
2) Pon el nombre del agente (por ejemplo, **Bug Hunter Agent**).  
3) Copia el contenido completo del `.txt` en el **System Prompt** del agente.  
4) Guarda.

Repite para los agentes que usarás.

---

## 4) Cómo hacer que todos “hereden” la política global

La política global es tu defensa anti-hype y anti-deuda.

### Método A — Prefijo manual (universal)

Pega esto al inicio del System Prompt de **cada agente**:

```
[GLOBAL POLICY — OBLIGATORIA]
Inserta aquí el contenido de "Global Policy Agent Rules.txt".
[FIN GLOBAL POLICY]

[AGENT ROLE]
(Rest of your agent prompt)
```

### Método B — Política base del workspace (si tu entorno lo permite)

Si Claude Code ofrece una configuración de **instrucciones compartidas** o “base system prompt”:

1) Configura `Global Policy Agent Rules.txt` como política común.  
2) Mantén cada agente solo con su prompt específico.  

> Este método reduce duplicación y asegura consistencia.

---

## 5) Núcleo mínimo recomendado por tipo de producto

### Web-first (startup)
- Web Architecture
- Frontend Web
- Web BFF/Backend
- Web CI/CD
- Bug Hunter
- Test Strategy

### Mobile-first (startup)
- Mobile Architecture
- Mobile UI
- Mobile Data
- Mobile CI/CD
- Bug Hunter

### Desktop-first (startup)
- Desktop Architecture
- Desktop Integration
- Desktop CI/CD
- Bug Hunter

### Cloud-first / plataforma interna
- Cloud Architecture
- Platform/DevOps
- GitOps CI/CD Cloud
- Cloud Security (guardrails)
- Observability (mínimo)

---

## 6) Regla práctica de adopción por madurez

### Startup temprana (1–5 devs)
- Usa **4–6 agentes máximo**.
- Evita complejidad operativa.

### Scale-up (6–20 devs)
- Agrega transversales obligatorios:
  - Bug Hunter
  - Refactor & Code Quality
  - Test Strategy
  - Performance & Efficiency
  - DX

### Multi-squad (21–80)
- Formaliza plantillas de repos y pipelines.
- Activa Observability + Cloud Security.
- Usa Technology Critic para gobernanza del stack.

### Enterprise/regulado (80+)
- Global Policy obligatoria.
- Cloud Security + Observability + SRE como estándar.
- Technology Critic siempre presente en decisiones mayores.

---

## 7) Cómo pedir trabajo a los agentes

Un prompt útil para casi cualquier agente:

**Contexto**
- producto/plataforma:
- objetivo:
- restricciones (tiempo/equipo/stack):
- problema actual:
- evidencia (logs, PR, métricas):

**Resultado esperado**
- salida concreta:
- criterios de aceptación:
- límites:

---

## 8) Ejemplos de orquestación real

### 8.1 Bug crítico en producción (Web)

**Objetivo:** resolver rápido, sin refactor innecesario.

**Orden recomendado**
1) **Bug Hunter Agent**  
   - reproduce, identifica causa raíz, crea test de regresión.
2) **Observability Agent** (si el bug solo ocurre en prod)  
   - mejora logs/traces mínimos para confirmar hipótesis.
3) **Test Strategy Agent**  
   - ajusta niveles de tests para evitar otra regresión.
4) **Web CI/CD Agent**  
   - agrega gate de regresión si aplica.
5) **Refactor & Code Quality Agent**  
   - solo si el bug revela duplicación sistémica.

**Definición de éxito**
- bug no se repite.
- test de regresión integrado al pipeline.
- solución mínima y segura.

---

### 8.2 Construir una nueva feature Web (con riesgo de ambigüedad)

**Orden recomendado**
1) **Web Product-Discovery Agent**  
   - define historia, criterios de aceptación y métricas de éxito.
2) **UX/UI Agent** (si lo usas en tu ecosistema)  
   - flujo y specs consistentes con Design System.
3) **Web Architecture Agent**  
   - define render strategy + modularidad UI + BFF si aplica.
4) **Web BFF/Backend Agent**  
   - dominio y contratos.
5) **Frontend Web Agent**
6) **Web QA Agent + Test Strategy Agent**
7) **Web CI/CD Agent**
8) **Observability Agent**  
   - RUM + métricas post-release.

**Definición de éxito**
- MVP medible.
- UI reusable.
- contratos estables.
- tests proporcionales al riesgo.

---

### 8.3 Reducir costo cloud y latencia

**Orden recomendado**
1) **Observability Agent**  
   - evidencia real de dónde se consume costo/latencia.
2) **Performance & Efficiency Agent**  
   - optimizaciones y medición antes/después.
3) **Cloud Architecture Agent**  
   - corrige anti-patterns sistémicos.
4) **Platform/DevOps Agent**  
   - aplica cambios IaC modulares.
5) **GitOps CI/CD Cloud Agent**  
   - despliegue seguro canary/rollback.
6) **Cloud Security Agent**  
   - valida que la optimización no rompa guardrails.

**Definición de éxito**
- reducción medible de costo.
- mejoras de latencia.
- cambios reproducibles por IaC.

---

## 9) Consejos de uso para máxima calidad

- Mantén agentes **con una responsabilidad principal**.
- Usa el **Agent Selector** cuando el equipo no esté seguro de por dónde empezar.
- Prioriza **modularidad y reutilización** antes que introducir nuevas tecnologías.
- Todo fix de bug relevante debe incluir **test de regresión**.
- No uses E2E como solución universal:  
  unit + integration + contract suelen ser más rápidos y estables.

---

## 10) Qué personalizar primero

Si quieres adaptar este pack a tu stack real:

1) Añade herramientas específicas en cada agente:
   - Web: Next.js/React/Angular, Storybook
   - Mobile: Kotlin/Swift/KMP/Flutter
   - Cloud: AWS/GCP/Azure, K8s, Terraform, ArgoCD
2) Define convenciones de repos:
   - nombres de módulos
   - estándar de versionado
   - política de deprecación
3) Publica plantillas:
   - repos base
   - pipelines base
   - módulos IaC base

---

## 11) Archivos incluidos en el pack

- Agentes por plataforma: Web / Mobile / Desktop / Cloud
- Transversales de Code Health
- `Global Policy Agent Rules.txt`
- `index.txt`
- `Agent Selector & Orchestration Advisor.txt`

---

## 12) Licencia / uso interno

Este pack está pensado para uso interno y personalización por organización.  
Tu valor real aparecerá cuando:
- adaptes los prompts a tu stack específico,
- y establezcas plantillas reales de repos/pipelines/módulos compartidos.

---

## 13) Checklist de adopción rápida (1 semana)

Día 1–2:
- Instala núcleo mínimo de tu plataforma principal.
- Agrega Global Policy.

Día 3–4:
- Activa Bug Hunter + Test Strategy.
- Ajusta CI/CD para que exija tests clave.

Día 5:
- Añade Refactor & Code Quality + DX.
- Identifica 1–2 módulos para extracción reusable.

Día 6–7:
- Define dashboards mínimos y métricas de calidad/entrega.
- Usa Technology Critic en cualquier propuesta de tool nueva.

---

¡Listo! Si quieres, puedo generarte un README alternativo más corto tipo “handbook”,
o una versión específica para un stack concreto (por ejemplo, **Java/Spring + Angular + K8s + GitHub Actions**).
---

## 14) Agentes añadidos en v2.2

- **Web Accessibility Agent**: integra accesibilidad (WCAG) en diseño, desarrollo y CI/CD.
- **Mobile Security Agent**: seguridad-by-design en cliente mobile (storage, tokens, permisos).
- **Release Manager Agent**: coordinación de releases multi-plataforma con rollout/rollback seguro.
- **Docs & Knowledge Agent**: documentación viva para módulos compartidos, ADRs y onboarding.
---

## 15) Agentes añadidos en v2.3 “ultra”

- **Data & Analytics Agent**: tracking plan, taxonomía de eventos y métricas de producto consistentes cross-platform.
- **Design System Steward Agent**: gobierno y evolución del Design System con enfoque en reutilización y A11y.
- **Quality Gatekeeper Agent**: consolida señales de QA/Sec/Perf/A11y/SRE para definir criterios de go/no-go y gates reutilizables.
---

## 16) Agentes añadidos en v2.4

- **License Reviewer & OSS Alternatives Agent**: revisa licencias del stack y propone reemplazos open source con plan incremental y checklist de automatización en CI/CD.
---

## 17) Agentes añadidos en v2.5 “ultra”

- **Ethical Hacker & PenTest Advisor Agent**: análisis ofensivo responsable y priorización de mitigaciones con pruebas verificables.
- **Threat Modeling Agent**: modelado liviano de amenazas para shift-left security.
- **Security Testing Integrator Agent**: estandariza y automatiza gates de seguridad en CI/CD.
