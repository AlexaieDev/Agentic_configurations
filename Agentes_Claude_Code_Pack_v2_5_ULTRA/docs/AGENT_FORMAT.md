# Agent Format Specification

Este documento define la estructura oficial para todos los agentes del catálogo.

## Estructura General

Cada agente debe ser un archivo `.txt` con secciones claramente definidas en mayúsculas.

## Secciones Requeridas

Estas secciones son **obligatorias** y el script de validación fallará si no están presentes:

### 1. AGENTE
Primera línea del archivo. Define el nombre oficial del agente.

```
AGENTE: Nombre del Agente
```

**Convención de nombres:**
- Usar sustantivos descriptivos
- Terminar en "Agent"
- Usar mayúsculas iniciales (Title Case)
- Ejemplos: `Frontend Web Agent`, `Database Architect Agent`

### 2. MISIÓN
Define el propósito principal del agente en 1-2 oraciones.

```
MISIÓN
Descripción clara y concisa del objetivo principal del agente.
```

**Buenas prácticas:**
- Empezar con un verbo infinitivo
- Ser específico sobre el valor que aporta
- Evitar jerga innecesaria

### 3. DEBE HACER
Lista de acciones obligatorias que el agente siempre debe realizar.

```
DEBE HACER
- Acción obligatoria 1
- Acción obligatoria 2
- Mínimo 5 items recomendados
```

**Buenas prácticas:**
- Usar verbos en infinitivo
- Ser específico y accionable
- Ordenar por importancia

### 4. NO DEBE HACER
Lista de antipatrones y acciones prohibidas.

```
NO DEBE HACER
- Antipatrón 1
- Antipatrón 2
- Mínimo 3 items recomendados
```

**Buenas prácticas:**
- Ser específico sobre por qué está prohibido
- Incluir antipatrones comunes del dominio

### 5. DEFINICIÓN DE DONE
Criterios que deben cumplirse para considerar el trabajo del agente como completado.

```
DEFINICIÓN DE DONE
- Criterio de completitud 1
- Criterio de completitud 2
- Mínimo 4 items recomendados
```

## Secciones Recomendadas

Estas secciones son opcionales pero altamente recomendadas para agentes completos:

### ROL EN EL EQUIPO
Describe la identidad del agente usando "Eres...".

```
ROL EN EL EQUIPO
Eres el/la [rol]. [Descripción de cómo encaja en el equipo].
```

### ALCANCE
Define las áreas de responsabilidad del agente.

```
ALCANCE
- Área de responsabilidad 1
- Área de responsabilidad 2
```

### ENTRADAS
Define qué información o recursos necesita el agente para funcionar.

```
ENTRADAS
- Tipo de entrada 1
- Tipo de entrada 2
```

### SALIDAS
Define qué produce o entrega el agente.

```
SALIDAS
- Entregable 1
- Entregable 2
```

### COORDINA CON
Lista de otros agentes con los que coordina.

```
COORDINA CON
- Nombre Exacto del Agente: razón de coordinación
- Otro Agente: razón de coordinación
```

**IMPORTANTE:**
- Usar el nombre **exacto** del agente (como aparece en el archivo)
- No usar nombres genéricos como "Backend Agents"
- No usar roles organizacionales como "Manager" o "HR"
- El validador verificará que cada referencia exista

### EJEMPLOS
Casos de uso prácticos con escenarios concretos.

```
EJEMPLOS
1. **Título del ejemplo**: Descripción del escenario y solución aplicada.
2. **Otro ejemplo**: Otra descripción.
```

### MÉTRICAS DE ÉXITO
Indicadores medibles de éxito.

```
MÉTRICAS DE ÉXITO
- Métrica 1 > umbral
- Métrica 2 < umbral
```

### MODOS DE FALLA
Errores comunes y cómo reconocerlos.

```
MODOS DE FALLA
- Modo de falla: descripción breve
- Otro modo: descripción
```

## Ejemplo Completo

```
AGENTE: Example Domain Agent

MISIÓN
Demostrar la estructura correcta de un agente del catálogo, sirviendo como referencia para la creación de nuevos agentes.

ROL EN EL EQUIPO
Eres el agente de ejemplo. Sirves como modelo de referencia para todos los demás agentes del catálogo.

ALCANCE
- Definir estructura de agentes.
- Servir como template de referencia.
- Documentar buenas prácticas.

ENTRADAS
- Requisitos del nuevo agente.
- Dominio de conocimiento.
- Contexto organizacional.

SALIDAS
- Archivo de agente correctamente estructurado.
- Documentación de secciones.
- Validación exitosa.

DEBE HACER
- Incluir todas las secciones requeridas.
- Usar nombres consistentes.
- Ser específico en las acciones.
- Documentar ejemplos prácticos.
- Definir métricas medibles.

NO DEBE HACER
- Omitir secciones requeridas.
- Usar referencias a agentes inexistentes.
- Ser vago en las instrucciones.

COORDINA CON
- Test Strategy Agent: validación de estructura.
- Docs & Knowledge Agent: documentación.
- Code Review Agent: revisión de calidad.

EJEMPLOS
1. **Crear nuevo agente**: Copiar template, rellenar secciones, ejecutar validador, corregir errores.
2. **Actualizar agente existente**: Leer agente actual, modificar sección necesaria, re-validar.

MÉTRICAS DE ÉXITO
- Validación exitosa = 100%.
- Secciones recomendadas presentes > 80%.
- Referencias válidas = 100%.

MODOS DE FALLA
- Sección faltante: validador reporta error.
- Referencia rota: agente referenciado no existe.
- Contenido vago: instrucciones no accionables.

DEFINICIÓN DE DONE
- Todas las secciones requeridas presentes.
- Validador ejecutado sin errores.
- Ejemplos prácticos documentados.
- Referencias verificadas.
```

## Validación

Ejecutar el validador para verificar que un agente cumple con el formato:

```bash
# Validar todos los agentes
node scripts/validate.js

# Validación con warnings (secciones recomendadas)
node scripts/validate.js --verbose
```

## Agregar un Nuevo Agente

1. Copiar el template de `templates/agent-template.txt`
2. Renombrar siguiendo la convención: `Nombre del Agente.txt`
3. Rellenar todas las secciones requeridas
4. Agregar secciones recomendadas según aplique
5. Ejecutar validador: `node scripts/validate.js`
6. Actualizar `index.json` con el nuevo agente
7. Crear PR con los cambios

## Referencias

- [CONTRIBUTING.md](../CONTRIBUTING.md) - Guía de contribución
- [templates/agent-template.txt](../templates/agent-template.txt) - Template vacío
- [index.json](../index.json) - Índice del catálogo
