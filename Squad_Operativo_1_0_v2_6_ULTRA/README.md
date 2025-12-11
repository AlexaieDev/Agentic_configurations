# Squad Operativo 1.0 (v2.6 Ultra independiente)

Este pack es una célula operativa autocontenida para **operación, incidentes, resiliencia y gobernanza de costo**.
Está diseñado para usarse solo o como complemento del ecosistema principal de agentes.

## Agentes incluidos
- Incident Commander Agent
- Runbook & Operations Agent
- Postmortem & Learning Agent
- Chaos & Resilience Agent
- Capacity & Cost Governance Agent
- Documentador Agent

## Objetivo del squad
Reducir impacto y recurrencia de incidentes, estandarizar respuesta y asegurar evolución operativa sin burocracia.

## Flujo recomendado ante incidente
1) **Incident Commander** — activa protocolo, roles y mitigación segura.
2) **Runbook & Operations** — ejecuta guías por síntoma/servicio.
3) **(Opcional) SRE/Observability del ecosistema completo** — si están disponibles.
4) **Postmortem & Learning** — causa raíz, acciones, actualización de estándares.
5) **Chaos & Resilience** — transforma aprendizaje en pruebas de resiliencia.
6) **Capacity & Cost Governance** — valida impacto en escala y costo.
7) **Documentador** — actualiza docs y checklists junto a los cambios.

## Cuándo usar este pack de forma independiente
- Equipos pequeños que ya están en producción.
- Startups con 1–2 servicios críticos y on-call liviano.
- Productos que necesitan bajar MTTR rápidamente.

## Cuándo integrarlo con el pack completo
- Si tienes múltiples squads.
- Si necesitas gates de seguridad avanzados o compliance de licencias.
- Si quieres gobernanza fuerte de arquitectura y design system.
