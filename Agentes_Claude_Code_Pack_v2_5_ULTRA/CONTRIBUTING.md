# Guía de Contribución

Gracias por tu interés en contribuir al catálogo de agentes. Esta guía explica cómo agregar nuevos agentes o mejorar los existentes.

## Antes de Empezar

1. Lee la [especificación de formato](docs/AGENT_FORMAT.md)
2. Revisa los agentes existentes en tu categoría objetivo
3. Asegúrate de que no existe un agente que cubra tu caso de uso

## Crear un Nuevo Agente

### Paso 1: Usar el Template

```bash
# Copiar template
cp templates/agent-template.txt agents/[categoria]/Mi Nuevo Agent.txt

# O usar el generador (si está disponible)
node scripts/new-agent.js
```

### Paso 2: Completar las Secciones

**Secciones requeridas (obligatorias):**
- `AGENTE`: Nombre oficial
- `MISIÓN`: Propósito en 1-2 oraciones
- `DEBE HACER`: Mínimo 5 acciones obligatorias
- `NO DEBE HACER`: Mínimo 3 antipatrones
- `DEFINICIÓN DE DONE`: Mínimo 4 criterios de completitud

**Secciones recomendadas:**
- `ROL EN EL EQUIPO`
- `ALCANCE`
- `ENTRADAS`
- `SALIDAS`
- `COORDINA CON`
- `EJEMPLOS`
- `MÉTRICAS DE ÉXITO`
- `MODOS DE FALLA`

### Paso 3: Validar

```bash
node scripts/validate.js
```

Asegúrate de que no hay errores antes de crear el PR.

### Paso 4: Actualizar index.json

Agrega tu agente al `index.json` en la categoría correspondiente:

```json
{
  "platforms": {
    "tu_categoria": {
      "agents": [
        "...",
        "Mi Nuevo Agent.txt"
      ]
    }
  }
}
```

### Paso 5: Crear Pull Request

1. Crea un branch: `git checkout -b add-mi-nuevo-agent`
2. Commit: `git commit -m "Add Mi Nuevo Agent"`
3. Push: `git push origin add-mi-nuevo-agent`
4. Crea PR con descripción del agente

## Mejorar un Agente Existente

### Cambios Menores
- Correcciones de typos
- Clarificación de instrucciones
- Agregar ejemplos adicionales

### Cambios Mayores
- Reestructurar secciones
- Cambiar misión o alcance
- Agregar/remover responsabilidades

Para cambios mayores, abre un Issue primero para discutir el cambio propuesto.

## Convenciones

### Nombres de Archivos
- Usar Title Case: `Mi Agente Agent.txt`
- Terminar en "Agent.txt"
- No usar caracteres especiales (excepto guiones y espacios)

### Contenido
- Escribir en español
- Usar verbos en infinitivo para acciones
- Ser específico y accionable
- Evitar jerga innecesaria

### Referencias a Otros Agentes
En la sección `COORDINA CON`:
- Usar el nombre **exacto** del agente
- El nombre debe coincidir con el archivo `.txt`
- No usar referencias genéricas como "Backend Agents"

**Correcto:**
```
COORDINA CON
- Performance & Efficiency Agent: optimización de performance
- Database Architect Agent: diseño de esquemas
```

**Incorrecto:**
```
COORDINA CON
- Performance Agent: optimización
- Backend Agents: implementación
```

## Categorías Disponibles

| Categoría | Descripción | Ejemplos |
|-----------|-------------|----------|
| web | Frontend web, UI/UX, accesibilidad | Frontend Web Agent, Responsive Design Agent |
| mobile | iOS, Android, cross-platform | Mobile Architecture Agent, Push Notification Agent |
| desktop | Electron, Tauri, native | Desktop Architecture Agent |
| backend | APIs, messaging, caching | GraphQL Agent, Message Queue Agent |
| architecture | Patrones y diseño de software | Clean Architecture Agent, DDD Agent |
| cloud | Cloud, DevOps, SRE | Cloud Architecture Agent, SRE Agent |
| devops | Infrastructure, containers | Infrastructure as Code Agent, Container Orchestration Agent |
| testing | Estrategias y tipos de testing | Test Strategy Agent, E2E Testing Agent |
| security | Seguridad y compliance | Authentication Agent, Vulnerability Management Agent |
| data | Data engineering y ML | Data Pipeline Agent, ML Ops Agent |
| integrations | Integraciones de terceros | Payment Integration Agent, Email Delivery Agent |
| transversal | Concerns cross-cutting | Code Review Agent, Technical Debt Agent |

## Preguntas Frecuentes

### ¿Mi agente existe ya?
Busca en `index.json` o usa:
```bash
grep -l "tu-termino" agents/**/*.txt
```

### ¿En qué categoría va mi agente?
Si el agente es específico de una plataforma (web, mobile), va ahí. Si es cross-cutting, va en `transversal`.

### ¿Puedo crear una nueva categoría?
Abre un Issue para discutirlo primero. Las categorías deben agrupar al menos 3+ agentes.

### ¿El validador falla, qué hago?
1. Lee el mensaje de error
2. Verifica que tienes todas las secciones requeridas
3. Verifica que las referencias en COORDINA CON existen
4. Ejecuta con `--verbose` para más detalles

## Código de Conducta

- Sé respetuoso y constructivo
- Las críticas deben ser hacia el código/contenido, no personas
- Acepta feedback y mejoras sugeridas
- Ayuda a otros contribuidores

## Contacto

Si tienes dudas, abre un Issue con el label `question`.
