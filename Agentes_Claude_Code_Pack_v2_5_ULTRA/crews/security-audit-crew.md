# Crew: Security Audit

Equipo especializado para realizar auditorías de seguridad completas antes de releases críticos o como parte de compliance.

## Cuándo Usar

- Pre-release de funcionalidad sensible (auth, pagos, datos PII)
- Auditoría periódica (trimestral/anual)
- Después de un incidente de seguridad
- Preparación para certificaciones (SOC2, ISO 27001)
- Due diligence antes de M&A
- Nuevo proveedor/integración de terceros

## Composición del Equipo

| Rol | Agente | Responsabilidad Principal |
|-----|--------|---------------------------|
| Security Lead | **Threat Modeling Agent** | Identificar y priorizar amenazas |
| Vulnerability Analyst | **Vulnerability Management Agent** | Escanear y clasificar vulnerabilidades |
| Auth Specialist | **Authentication Agent** | Auditar flujos de autenticación |
| Access Control | **Authorization Agent** | Verificar modelo de permisos |
| Secrets Manager | **Secret Management Agent** | Auditar manejo de credenciales |
| Compliance | **Compliance Agent** | Verificar requisitos regulatorios |
| PenTester | **Ethical Hacker & PenTest Advisor Agent** | Testing ofensivo controlado |
| Integration | **Security Testing Integrator Agent** | Automatizar en CI/CD |

## Workflow del Audit

```
Fase 1: Reconnaissance (Día 1-2)
├── Threat Modeling Agent
│   ├── Mapear superficie de ataque
│   ├── Identificar assets críticos
│   ├── Crear threat model (STRIDE)
│   └── Priorizar amenazas por riesgo
│
└── Compliance Agent
    ├── Identificar requisitos aplicables
    ├── Gap analysis inicial
    └── Checklist de compliance

Fase 2: Vulnerability Assessment (Día 3-5)
├── Vulnerability Management Agent
│   ├── Ejecutar SAST (Semgrep, CodeQL)
│   ├── Ejecutar SCA (Dependabot, Snyk)
│   ├── Ejecutar DAST (OWASP ZAP)
│   └── Clasificar por CVSS
│
├── Authentication Agent
│   ├── Auditar login/logout flows
│   ├── Verificar session management
│   ├── Revisar password policies
│   └── Evaluar MFA implementation
│
└── Authorization Agent
    ├── Revisar modelo RBAC/ABAC
    ├── Verificar least privilege
    ├── Auditar endpoints sensibles
    └── Probar privilege escalation

Fase 3: Deep Dive (Día 6-8)
├── Secret Management Agent
│   ├── Escanear repos por secrets
│   ├── Auditar vault/KMS config
│   ├── Verificar rotación de keys
│   └── Revisar env vars handling
│
└── Ethical Hacker & PenTest Advisor Agent
    ├── Intentar exploits manuales
    ├── Business logic testing
    ├── API abuse testing
    └── Social engineering assessment

Fase 4: Remediation & Integration (Día 9-10)
├── Security Testing Integrator Agent
│   ├── Configurar SAST en CI
│   ├── Agregar secret scanning
│   ├── Implementar dependency alerts
│   └── Crear security gates
│
└── Todos los agentes
    ├── Priorizar remediaciones
    ├── Crear action items
    └── Documentar findings
```

## Severidades de Findings

| Severidad | CVSS | Tiempo de Remediación | Ejemplo |
|-----------|------|----------------------|---------|
| Critical | 9.0-10.0 | < 24 horas | RCE, SQL injection con data breach |
| High | 7.0-8.9 | < 7 días | Auth bypass, privilege escalation |
| Medium | 4.0-6.9 | < 30 días | XSS stored, IDOR limitado |
| Low | 0.1-3.9 | < 90 días | Information disclosure menor |
| Info | 0 | Best effort | Mejoras sugeridas |

## Checklist de Auditoría

### Autenticación
- [ ] Passwords hasheados con bcrypt/Argon2
- [ ] Rate limiting en login
- [ ] Account lockout después de N intentos
- [ ] Session tokens seguros (HttpOnly, Secure, SameSite)
- [ ] Logout invalida session server-side
- [ ] Password reset seguro (token único, expirable)
- [ ] MFA disponible para cuentas sensibles

### Autorización
- [ ] Verificación en cada endpoint (no solo UI)
- [ ] IDOR protegido (no IDs predecibles)
- [ ] Admin functions properly protected
- [ ] API keys con scopes limitados
- [ ] Segregación de datos multi-tenant

### Datos
- [ ] PII encriptado at rest
- [ ] TLS 1.3 en tránsito
- [ ] Backups encriptados
- [ ] Data retention policy implementada
- [ ] Logs no contienen datos sensibles

### Infraestructura
- [ ] Secrets en vault (no en código/env files)
- [ ] Firewalls configurados (least access)
- [ ] Updates automáticos habilitados
- [ ] No servicios innecesarios expuestos
- [ ] SSH con keys (no passwords)

### Código
- [ ] No SQL injection posible
- [ ] No XSS posible
- [ ] No SSRF posible
- [ ] Input validation en server-side
- [ ] Dependencies sin vulnerabilidades críticas

## Template de Reporte

```markdown
# Security Audit Report

## Executive Summary
- Fecha: [fecha]
- Scope: [aplicación/sistema]
- Metodología: [OWASP, PTES, etc.]
- Risk Rating: [Critical/High/Medium/Low]

## Findings Summary
| Severidad | Count | Remediados |
|-----------|-------|------------|
| Critical  | X     | X          |
| High      | X     | X          |
| Medium    | X     | X          |
| Low       | X     | X          |

## Critical Findings
### [Finding Title]
- **Severidad**: Critical (CVSS 9.5)
- **Ubicación**: [archivo/endpoint]
- **Descripción**: [qué se encontró]
- **Impacto**: [qué podría pasar]
- **Remediación**: [cómo arreglarlo]
- **Estado**: [Open/Remediated/Accepted Risk]

## Recommendations
1. [Recomendación prioritaria]
2. [Siguiente]
...

## Appendix
- Tools utilizados
- Evidencia detallada
- Referencias
```

## Métricas del Audit

| Métrica | Target |
|---------|--------|
| Critical findings | 0 al cierre |
| High findings | < 3 con plan |
| MTTD (tiempo detección) | < 5 días |
| MTTR críticos | < 24 horas |
| Cobertura OWASP Top 10 | 100% |
| Scans automatizados | 100% CI |

## Herramientas Recomendadas

| Tipo | Herramienta | Propósito |
|------|-------------|-----------|
| SAST | Semgrep, CodeQL | Análisis estático de código |
| SCA | Snyk, Dependabot | Vulnerabilidades en deps |
| DAST | OWASP ZAP, Burp | Testing dinámico |
| Secrets | GitLeaks, TruffleHog | Detectar secrets expuestos |
| Container | Trivy, Grype | Vulnerabilidades en imágenes |
| Cloud | Prowler, ScoutSuite | Misconfiguration cloud |

## Recursos

- [Threat Modeling Agent](../agents/security/Threat%20Modeling%20Agent.txt)
- [Vulnerability Management Agent](../agents/security/Vulnerability%20Management%20Agent.txt)
- [Authentication Agent](../agents/security/Authentication%20Agent.txt)
- [Authorization Agent](../agents/security/Authorization%20Agent.txt)
- [Secret Management Agent](../agents/security/Secret%20Management%20Agent.txt)
- [Compliance Agent](../agents/transversal/Compliance%20Agent.txt)
- [Ethical Hacker & PenTest Advisor Agent](../agents/security/Ethical%20Hacker%20%26%20PenTest%20Advisor%20Agent.txt)
