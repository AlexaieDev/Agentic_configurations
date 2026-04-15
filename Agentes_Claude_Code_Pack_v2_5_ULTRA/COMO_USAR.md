# Como Usar los Agentes en Visual Studio Code con Claude Opus

Esta guía explica cómo configurar y usar los 102 agentes especializados en Visual Studio Code con Claude Code y el modelo Opus.

## Requisitos Previos

- Visual Studio Code instalado
- Cuenta de Anthropic con acceso a Claude Opus
- Claude Code CLI instalado o extensión de VS Code

## Instalación

### Opción 1: Claude Code CLI (Recomendado)

```bash
# Instalar Claude Code CLI
npm install -g @anthropic-ai/claude-code

# Verificar instalación
claude --version

# Autenticarse
claude auth login
```

### Opción 2: Extensión de VS Code

1. Abrir VS Code
2. Ir a Extensions (Ctrl+Shift+X)
3. Buscar "Claude Code" o "Claude Dev"
4. Instalar la extensión oficial de Anthropic
5. Configurar API key en settings

## Configuración para usar Claude Opus

### En Claude Code CLI

```bash
# Configurar modelo por defecto a Opus
claude config set model claude-opus-4-5-20250101

# O usar Opus para una sesión específica
claude --model opus
```

### En VS Code Settings

Agregar a `settings.json`:

```json
{
  "claude-code.model": "claude-opus-4-5-20250101",
  "claude-code.maxTokens": 8192
}
```

## Métodos para Cargar los Agentes

### Método 1: Archivo CLAUDE.md (Recomendado)

Crea un archivo `CLAUDE.md` en la raíz de tu proyecto y copia el contenido del agente que necesitas:

```markdown
# CLAUDE.md

<!-- Copia aquí el contenido del agente que necesitas -->

## Agente Activo: Web Architecture Agent

MISIÓN
Diseñar arquitecturas web escalables...

DEBE HACER
- Evaluar requisitos antes de proponer arquitectura
- ...

NO DEBE HACER
- Proponer tecnologías sin justificación
- ...
```

Claude Code lee automáticamente este archivo al iniciar una sesión.

### Método 2: Carga Directa en Prompt

Copia el contenido del agente al inicio de tu conversación:

```
Actúa como el siguiente agente especializado:

[Pega aquí el contenido del archivo del agente]

---

Ahora, ayúdame con: [tu solicitud]
```

### Método 3: Sistema de Prompts Personalizados

Crea una carpeta `.claude/` en tu proyecto:

```
tu-proyecto/
├── .claude/
│   ├── prompts/
│   │   ├── web-architecture.md
│   │   ├── security-review.md
│   │   └── performance-audit.md
│   └── settings.json
├── src/
└── CLAUDE.md
```

En `.claude/settings.json`:

```json
{
  "customPrompts": {
    "web-arch": ".claude/prompts/web-architecture.md",
    "security": ".claude/prompts/security-review.md",
    "perf": ".claude/prompts/performance-audit.md"
  }
}
```

Luego invoca con:
```
/web-arch diseña la arquitectura para un e-commerce
```

### Método 4: Hooks de Sesión

Configura un hook que cargue agentes automáticamente según el contexto:

En `.claude/settings.json`:

```json
{
  "hooks": {
    "sessionStart": [
      {
        "matcher": "**/*.tsx",
        "prompt": "Carga el contenido de agents/web/Frontend Web Agent.txt"
      },
      {
        "matcher": "**/api/**",
        "prompt": "Carga el contenido de agents/backend/GraphQL Agent.txt"
      }
    ]
  }
}
```

## Uso Práctico por Escenario

### Escenario 1: Desarrollo Web Frontend

```bash
# Iniciar Claude Code con agente de frontend
claude "Actúa como Frontend Web Agent. $(cat agents/web/Frontend\ Web\ Agent.txt)"
```

O en VS Code, abre el Command Palette (Ctrl+Shift+P):
```
> Claude: Start Chat
```

Y pega:
```
Actúa según este agente:

[contenido de Frontend Web Agent.txt]

Necesito crear un componente de checkout con React.
```

### Escenario 2: Revisión de Seguridad

```bash
# Cargar múltiples agentes para revisión completa
claude "
Actúa como un equipo de seguridad compuesto por:

1. $(cat agents/security/Authentication\ Agent.txt)

2. $(cat agents/security/Vulnerability\ Management\ Agent.txt)

Revisa el código en src/auth/ y reporta vulnerabilidades.
"
```

### Escenario 3: Arquitectura de Microservicios

```bash
claude "
$(cat agents/architecture/Microservices\ Agent.txt)

$(cat agents/architecture/Event-Driven\ Architecture\ Agent.txt)

Diseña la arquitectura para migrar nuestro monolito a microservicios.
El monolito actual está en src/ y maneja: users, orders, inventory.
"
```

## Combinación de Agentes

Para tareas complejas, combina múltiples agentes:

```markdown
# CLAUDE.md para proyecto E-commerce

## Equipo de Agentes Activos

### Arquitectura
[Contenido de Cloud Architecture Agent]

### Backend  
[Contenido de GraphQL Agent]
[Contenido de Caching Strategy Agent]

### Testing
[Contenido de E2E Testing Agent]
[Contenido de Load Testing Agent]

### Seguridad
[Contenido de Authentication Agent]
[Contenido de Authorization Agent]

---

## Instrucciones
Cuando trabajes en este proyecto, aplica las directivas de los agentes
relevantes según el contexto de la tarea.
```

## Comandos Útiles

### Ver modelo actual
```bash
claude config get model
```

### Cambiar a Opus temporalmente
```bash
claude --model opus "tu prompt aquí"
```

### Usar modo rápido con Opus
```bash
claude --model opus --fast "tu prompt aquí"
```

## Estructura de Carpetas Recomendada

```
tu-proyecto/
├── .claude/
│   ├── agents/                    # Copia los agentes que uses frecuentemente
│   │   ├── frontend.md
│   │   ├── backend.md
│   │   └── security.md
│   ├── prompts/                   # Prompts personalizados
│   │   └── code-review.md
│   └── settings.json
├── CLAUDE.md                      # Agente principal del proyecto
├── src/
└── package.json
```

## Tips para Mejores Resultados

### 1. Sé Específico con el Contexto
```
Actúa como [Agente]. 

Contexto del proyecto:
- Stack: React + Node.js + PostgreSQL
- Escala: 10K usuarios diarios
- Requisitos: GDPR compliance

Tarea: [tu solicitud específica]
```

### 2. Usa las Métricas de Éxito
Cada agente tiene métricas definidas. Úsalas para validar:
```
Según las MÉTRICAS DE ÉXITO del agente, evalúa si mi implementación cumple:
- Query P99 latency < 200ms ✓/✗
- Cache hit rate > 90% ✓/✗
```

### 3. Aplica la Definición de Done
```
Antes de considerar esta tarea completa, verifica contra 
la DEFINICIÓN DE DONE del agente activo.
```

### 4. Combina Agentes Complementarios
Para un feature completo, usa:
- **Diseño**: API Design Agent
- **Implementación**: Backend Agent correspondiente
- **Testing**: Contract Testing Agent + E2E Testing Agent
- **Seguridad**: Authentication Agent + Security Testing Agent
- **Deploy**: CI-CD Agent + Release Manager Agent

## Solución de Problemas

### El agente no se carga correctamente
- Verifica que el archivo existe y tiene el formato correcto
- Asegúrate de no tener caracteres especiales que rompan el parsing

### Claude no sigue las instrucciones del agente
- El prompt del agente debe estar al inicio de la conversación
- Reafirma el rol: "Recuerda actuar como [Agente] según las instrucciones anteriores"

### El modelo no es Opus
```bash
# Verificar modelo
claude config get model

# Forzar Opus
claude --model claude-opus-4-5-20250101
```

## Ejemplos de Prompts Efectivos

### Crear nueva feature
```
Como Frontend Web Agent, necesito implementar un componente de 
filtros para una lista de productos.

Requisitos:
- Filtro por categoría, precio, rating
- Responsive (mobile-first)
- Accesible (WCAG 2.1 AA)

Stack: React + TypeScript + Tailwind
```

### Code Review
```
Como Code Review Agent + Security Agent, revisa este PR:

[código o link al PR]

Enfócate en:
1. Calidad del código
2. Vulnerabilidades de seguridad
3. Performance
4. Adherencia a los estándares del agente
```

### Debugging
```
Como Bug Hunter Agent + Observability Agent:

Tengo este error en producción:
[error logs]

Contexto:
- Ocurre intermitentemente
- Solo en peak hours
- Empezó después del deploy de ayer

Ayúdame a diagnosticar y proponer fix.
```

---

## Recursos Adicionales

- [Documentación Claude Code](https://docs.anthropic.com/claude-code)
- [VS Code Extension](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code)
- [API de Anthropic](https://docs.anthropic.com/api)

## Soporte

Si tienes problemas o sugerencias:
1. Revisa que tu API key tenga acceso a Opus
2. Verifica la versión de Claude Code: `claude --version`
3. Consulta la documentación oficial de Anthropic
