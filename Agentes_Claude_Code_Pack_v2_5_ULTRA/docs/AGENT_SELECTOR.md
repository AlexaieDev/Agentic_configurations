# Agent Selector Guide

Decision tree and guidance for choosing the right agent for your task.

## Quick Decision Tree

```
┌─────────────────────────────────────────────────────────────────┐
│                    What are you trying to do?                   │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
   ┌─────────┐         ┌───────────┐         ┌──────────┐
   │  Write  │         │   Fix/    │         │  Review/ │
   │  Code   │         │  Debug    │         │  Improve │
   └────┬────┘         └─────┬─────┘         └────┬─────┘
        │                    │                     │
        ▼                    ▼                     ▼
   What type?           What issue?          What aspect?
        │                    │                     │
   ┌────┼────┐         ┌────┼────┐         ┌──────┼──────┐
   │    │    │         │    │    │         │      │      │
   ▼    ▼    ▼         ▼    ▼    ▼         ▼      ▼      ▼
Front Back  API      Bug  Perf Sec     Quality  Sec   Docs
 end  end                                      
   │    │    │         │    │    │         │      │      │
   ▼    ▼    ▼         ▼    ▼    ▼         ▼      ▼      ▼
React  Go   API      Bug  Perf Sec     Code   Sec    Doc
Agent Agent Design  Hunter Agent Agent Review Agent Agent
```

## By Task Type

### Writing New Code

| If you're building... | Use this agent |
|----------------------|----------------|
| React/Vue/Angular components | React Agent, Vue Agent |
| Next.js app | Next.js Agent |
| REST API | API Design Agent + Python/Node/Go Agent |
| GraphQL API | API Design Agent |
| Database schema | Database Architect Agent |
| CLI tool | Node.js Agent or Go Agent |
| Mobile app | React Agent (React Native) |
| Microservices | Go Agent + Systems Agent |
| Infrastructure | IaC Agent |

### Fixing Issues

| If the issue is... | Use this agent |
|-------------------|----------------|
| Runtime bug | Bug Hunter Agent |
| Logic error | Bug Hunter Agent |
| Performance problem | Performance & Efficiency Agent |
| Memory leak | Performance & Efficiency Agent |
| Security vulnerability | Vulnerability Management Agent |
| Database slowness | Database Architect Agent |
| Flaky tests | Test Architect Agent |
| Build failure | CI/CD Agent |

### Code Quality

| If you want to... | Use this agent |
|-------------------|----------------|
| Review a PR | Code Review Agent |
| Improve code quality | Code Quality Agent |
| Refactor code | Refactoring Agent |
| Reduce tech debt | Technical Debt Agent |
| Add tests | Test Architect Agent |
| Improve documentation | Documentation Agent |
| Check accessibility | Accessibility Agent |

### Security

| If you need to... | Use this agent |
|-------------------|----------------|
| Audit for vulnerabilities | Security Audit Crew |
| Review authentication | Authentication Agent |
| Check authorization | Authorization Agent |
| Scan for secrets | Secret Management Agent |
| Model threats | Threat Modeling Agent |
| Validate input | Input Validation Agent |

### DevOps & Infrastructure

| If you're doing... | Use this agent |
|-------------------|----------------|
| CI/CD pipelines | CI/CD Agent |
| Docker/Kubernetes | Container Orchestration Agent |
| Terraform/Pulumi | IaC Agent |
| Monitoring setup | Observability Agent |
| Incident response | Incident Commander Agent |
| Release management | Release Manager Agent |

## By Technology Stack

### Frontend

| Stack | Primary Agent | Supporting Agents |
|-------|--------------|-------------------|
| React | React Agent | Frontend Perf, Accessibility |
| Vue | Vue Agent | Frontend Perf, Accessibility |
| Next.js | Next.js Agent | React Agent, SEO |
| React Native | React Agent | Mobile-specific patterns |

### Backend

| Stack | Primary Agent | Supporting Agents |
|-------|--------------|-------------------|
| Node.js | Node.js Agent | API Design, Database |
| Python/FastAPI | Python Agent | API Design, Database |
| Go | Go Agent | Systems, Performance |
| Rust | Rust Agent | Systems, Performance |

### Database

| Database | Agent | For |
|----------|-------|-----|
| PostgreSQL | Database Architect | Schema, queries, optimization |
| MongoDB | Database Architect | Document design |
| Redis | Database Architect | Caching patterns |

### Infrastructure

| Tool | Agent | For |
|------|-------|-----|
| Kubernetes | Container Orchestration | Deployments, scaling |
| Terraform | IaC Agent | Infrastructure as code |
| AWS/GCP/Azure | Cloud Agent | Cloud services |

## By Development Phase

### Planning

| Phase | Recommended Agents |
|-------|-------------------|
| Architecture design | Architecture Review Agent |
| API design | API Design Agent, OpenAPI Spec Agent |
| Database design | Database Architect Agent |
| Security planning | Threat Modeling Agent |

### Development

| Phase | Recommended Agents |
|-------|-------------------|
| Feature implementation | Stack-specific Agent (React, Python, etc.) |
| Writing tests | Test Architect Agent |
| Documentation | Documentation Agent |
| Code review | Code Review Agent |

### Testing

| Phase | Recommended Agents |
|-------|-------------------|
| Unit tests | Test Architect Agent |
| Integration tests | Test Architect Agent |
| Security testing | Security Agent |
| Performance testing | Performance Agent |

### Deployment

| Phase | Recommended Agents |
|-------|-------------------|
| CI/CD setup | CI/CD Agent |
| Release | Release Manager Agent |
| Monitoring | Observability Agent, SRE Agent |
| Incident | Incident Response Crew |

## Crew Selection

Use crews for complex, multi-faceted tasks:

| Scenario | Crew | Why |
|----------|------|-----|
| Starting new project | Startup MVP Crew | Full stack coverage |
| Security audit | Security Audit Crew | Comprehensive security |
| Production incident | Incident Response Crew | Coordinated response |
| Platform migration | Platform Migration Crew | Safe, systematic migration |

## Combining Agents

Some tasks benefit from multiple agents in sequence:

### Security Review
```
1. Threat Modeling Agent → Identify threats
2. Vulnerability Management Agent → Scan code
3. Authentication Agent → Review auth
4. Secret Management Agent → Check secrets
5. Code Review Agent → Final review
```

### Performance Optimization
```
1. Performance & Efficiency Agent → Profile
2. Database Architect Agent → Optimize queries
3. Frontend Performance Agent → Optimize UI
4. Code Review Agent → Review changes
```

### Adding New Feature
```
1. API Design Agent → Design API
2. Database Architect Agent → Schema
3. Stack Agent → Implementation
4. Test Architect Agent → Tests
5. Documentation Agent → Docs
6. Code Review Agent → Review
```

## Anti-Patterns

### Don't Do This

| Situation | Wrong Approach | Right Approach |
|-----------|----------------|----------------|
| Bug in React code | Use generic Bug Hunter | Use Bug Hunter + React Agent |
| Security issue | Use Code Review Agent | Use Security Audit Crew |
| Database design | Use generic Code Agent | Use Database Architect Agent |
| CI/CD pipeline | Use Systems Agent alone | Use CI/CD Agent |

### Agent Overload

Don't combine too many agents at once. Focus on:
- 1-2 agents for simple tasks
- 3-4 agents (or a crew) for complex tasks
- Sequence agents rather than using all simultaneously

## Context Matters

Consider these factors when selecting:

1. **Project Type**: SaaS, API, Mobile, CLI
2. **Tech Stack**: React, Python, Go, etc.
3. **Phase**: Planning, Dev, Test, Deploy
4. **Urgency**: Incident vs. normal dev
5. **Scope**: Single file vs. whole system

## Tips

1. **Start specific** - Use stack-specific agents first
2. **Add specialists** - Bring in security, perf agents as needed
3. **Use crews for big tasks** - Don't recreate the wheel
4. **Iterate** - Can always switch agents mid-task
5. **Read agent docs** - Each has specific strengths
