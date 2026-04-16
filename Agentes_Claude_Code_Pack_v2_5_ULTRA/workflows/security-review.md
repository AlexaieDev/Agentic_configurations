# Workflow: Security Review

Workflow para realizar una revisión de seguridad completa antes de un release o al agregar funcionalidad sensible.

## Cuándo Usar

- Antes de release a producción
- Al agregar nueva funcionalidad de autenticación/autorización
- Al integrar servicios de terceros
- Al manejar datos sensibles (PII, pagos, health data)
- Después de un incidente de seguridad
- Durante auditorías de seguridad

## Agentes Involucrados

| Orden | Agente | Responsabilidad |
|-------|--------|-----------------|
| 1 | **Threat Modeling Agent** | Identificar amenazas y vectores de ataque |
| 2 | **Vulnerability Management Agent** | Escanear y priorizar vulnerabilidades |
| 3 | **Authentication Agent** | Validar implementación de autenticación |
| 4 | **Authorization Agent** | Verificar control de acceso |
| 5 | **Secret Management Agent** | Auditar manejo de secretos |
| 6 | **Security Testing Integrator Agent** | Integrar tests de seguridad en CI/CD |

## Secuencia de Ejecución

### Fase 1: Análisis de Amenazas
```
Cargar: Threat Modeling Agent

Tareas:
- Identificar assets críticos
- Mapear superficie de ataque
- Crear threat model (STRIDE/PASTA)
- Documentar amenazas prioritarias

Output: Threat model documentado
```

### Fase 2: Escaneo de Vulnerabilidades
```
Cargar: Vulnerability Management Agent

Tareas:
- Ejecutar SAST (análisis estático)
- Ejecutar DAST (análisis dinámico)
- Revisar dependencias (SCA)
- Priorizar por severidad CVSS

Output: Lista de vulnerabilidades con severidad
```

### Fase 3: Revisión de Autenticación
```
Cargar: Authentication Agent

Tareas:
- Revisar flujos de login/logout
- Validar manejo de sesiones
- Verificar MFA si aplica
- Auditar password policies

Output: Reporte de estado de autenticación
```

### Fase 4: Revisión de Autorización
```
Cargar: Authorization Agent

Tareas:
- Revisar modelo de permisos (RBAC/ABAC)
- Validar least privilege
- Verificar segregación de datos
- Auditar endpoints sensibles

Output: Matriz de permisos validada
```

### Fase 5: Auditoría de Secretos
```
Cargar: Secret Management Agent

Tareas:
- Escanear repos por secretos expuestos
- Revisar rotación de credentials
- Validar vault/KMS configuration
- Verificar variables de entorno

Output: Reporte de higiene de secretos
```

### Fase 6: Integración en CI/CD
```
Cargar: Security Testing Integrator Agent

Tareas:
- Configurar SAST en pipeline
- Agregar dependency scanning
- Implementar secret detection
- Configurar DAST para staging

Output: Pipeline de seguridad configurado
```

## Checklist de Completitud

- [ ] Threat model documentado y revisado
- [ ] Vulnerabilidades críticas/altas remediadas
- [ ] Autenticación validada contra OWASP ASVS
- [ ] Modelo de autorización verificado
- [ ] No hay secretos expuestos en código
- [ ] Tests de seguridad integrados en CI/CD
- [ ] Findings documentados en issue tracker
- [ ] Plan de remediación para items pendientes

## Output Esperado

1. **Threat Model**: Documento con amenazas identificadas y mitigaciones
2. **Vulnerability Report**: Lista priorizada de vulnerabilidades
3. **Security Findings**: Issues creados para cada finding
4. **Remediation Plan**: Timeline para corregir vulnerabilidades
5. **CI/CD Pipeline**: Tests de seguridad automatizados

## Métricas de Éxito

- Vulnerabilidades críticas: 0
- Vulnerabilidades altas: < 3 (con plan de remediación)
- Cobertura de security tests: > 80%
- Secretos expuestos: 0
- Tiempo de escaneo en CI: < 10 minutos

## Errores Comunes

| Error | Solución |
|-------|----------|
| Saltar threat modeling | Siempre empezar con análisis de amenazas |
| Ignorar dependencias | Incluir SCA en cada review |
| No priorizar | Usar CVSS para priorizar remediación |
| Review único | Integrar en CI para review continuo |

## Recursos Relacionados

- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
