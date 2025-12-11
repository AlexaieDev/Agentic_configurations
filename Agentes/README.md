# Condo Admin 1.0 — Pack de Agentes

Pack especializado para desarrollar un **sistema administrador de condominios** con foco en:
- cálculo y publicación de gastos comunes,
- estado de cuenta por unidad,
- pagos online robustos,
- conciliación y comprobantes,
- portal web de residentes y administración,
- app mobile para residentes,
- notificaciones y observabilidad.

## Por qué este pack existe
Los sistemas de condominios fallan típicamente por:
1) reglas financieras dispersas y sin tests,
2) pagos sin idempotencia y conciliación débil,
3) contratos inestables entre backend y UIs,
4) poca trazabilidad y auditoría.

Este pack crea agentes específicos de:
- **dominio financiero** (motor de cálculo),
- **pagos y reconciliación**,
- **contratos e interfaces**,
- **dev web/mobile/backend**,
- **seguridad y gates**.

## Uso recomendado
1) Usa `Condo Product-Discovery` para definir MVP y roles.
2) Modela dominios con `Condo Domain Model & Architecture`.
3) Congela interfaces clave con `Condo Interface & API Contracts`.
4) Implementa core con los agentes dev.
5) Fortalece pagos con los agentes de finanzas/seguridad.
6) Activa observabilidad y runbooks antes de producción.

## Archivos clave
- `index.txt`: guías de kits y orquestación por fases.
- `index.json`: catálogo legible por máquinas.
