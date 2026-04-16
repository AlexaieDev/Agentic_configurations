# Agent Catalog Cheat Sheet

Quick reference for the most common agents, commands, and integrations.

---

## Quick Start

```bash
# 1. Copy agent to CLAUDE.md
cat agents/core/bug-hunter.md >> CLAUDE.md

# 2. Start Claude Code
claude-code

# 3. Claude now acts as Bug Hunter Agent
```

---

## Top 10 Agents

| Agent | Use For |
|-------|---------|
| Bug Hunter | Debugging, error fixing |
| Code Review | PR reviews, quality checks |
| Test Architect | Writing tests, coverage |
| Security | Vulnerabilities, audits |
| API Design | REST/GraphQL endpoints |
| Database Architect | Schema, queries, migrations |
| Refactoring | Code improvement |
| Performance | Optimization |
| Documentation | README, API docs |
| Release Manager | Deploys, releases |

---

## Crews by Scenario

| Scenario | Crew | Agents |
|----------|------|--------|
| Launch MVP | `startup-mvp-crew` | Full-Stack, API, DB, Deploy |
| Security Audit | `security-audit-crew` | Threat, Vuln, Auth, Secrets |
| Production Issue | `incident-response-crew` | IC, SRE, RCA, Comms |
| Migration | `platform-migration-crew` | Arch, Data, Test, Cutover |

---

## Slash Commands

| Command | Does |
|---------|------|
| `/security-review` | Full security audit |
| `/ship-checklist` | Pre-deploy checklist |
| `/tech-debt-scan` | Analyze tech debt |
| `/incident-start` | Start incident response |
| `/standup` | Generate standup update |
| `/code-review` | Structured code review |
| `/api-design` | Design API endpoint |
| `/debug` | Structured debugging |

---

## MCP Integrations

| Service | What You Can Do |
|---------|-----------------|
| **GitHub** | Issues, PRs, code search |
| **Jira** | Tickets, sprints |
| **Slack** | Notifications |
| **PostgreSQL** | SQL queries |
| **Sentry** | Error tracking |
| **Linear** | Project management |
| **Supabase** | DB + Auth |
| **Notion** | Documentation |

---

## Hooks

| Hook | Trigger | Use |
|------|---------|-----|
| `session-start/load-context.sh` | Start | Load project info |
| `pre-commit/security-scan.sh` | Commit | Scan secrets |
| `pre-commit/lint-check.sh` | Commit | Lint code |
| `pre-push/validate-branch.sh` | Push | Validate before push |
| `on-error/notify.sh` | Error | Send alert |

---

## Agent Categories

| Category | Agents |
|----------|--------|
| Core | Code Review, Bug Hunter, Test, Docs |
| Security | Threat Model, Auth, Secrets, Vuln |
| Architecture | Systems, DB, API, Event-Driven |
| DevOps | CI/CD, IaC, Containers, SRE |
| Performance | Frontend Perf, Backend Perf, Efficiency |
| Compliance | HIPAA, PCI-DSS, SOC2, GDPR |
| Stacks | React, Vue, Node, Python, Go, Rust |

---

## Example Projects

| Project | Stack | Files |
|---------|-------|-------|
| `nextjs-saas/` | Next.js + Supabase | CLAUDE.md, settings.json |
| `python-api/` | FastAPI + PostgreSQL | CLAUDE.md, settings.json |
| `mobile-app/` | React Native + Expo | CLAUDE.md, settings.json |
| `microservices/` | Go + Kubernetes | CLAUDE.md, settings.json |

---

## Configuration Files

```bash
# Project config
your-project/
├── CLAUDE.md           # Agent instructions
└── .claude/
    └── settings.json   # Claude Code settings

# Catalog structure
Agentes_Claude_Code_Pack/
├── agents/            # Agent definitions
├── crews/             # Pre-built teams
├── mcp/               # MCP configs
├── hooks/             # Automation
├── commands/          # Slash commands
├── guides/            # Integration guides
├── examples/          # Project examples
└── docs/              # Documentation
```

---

## Agent Selection Flow

```
What are you doing?
│
├─ Fixing bug?
│   └─ Bug Hunter Agent
│
├─ Writing code?
│   ├─ Frontend? → React/Vue Agent
│   ├─ Backend? → Python/Go/Node Agent
│   └─ API? → API Design Agent
│
├─ Reviewing?
│   └─ Code Review Agent
│
├─ Testing?
│   └─ Test Architect Agent
│
├─ Security?
│   └─ Security Audit Crew
│
├─ Deploying?
│   └─ Release Manager + SRE Agent
│
└─ Incident?
    └─ Incident Response Crew
```

---

## Common Patterns

### Bug Fix
```
1. Bug Hunter Agent → Find root cause
2. Test Architect Agent → Write failing test
3. Bug Hunter Agent → Implement fix
4. Code Review Agent → Review fix
```

### New Feature
```
1. API Design Agent → Design interface
2. Database Architect → Schema changes
3. Stack Agent → Implementation
4. Test Architect → Tests
5. Code Review Agent → Review
```

### Deploy
```
1. /ship-checklist → Verify ready
2. Release Manager → Tag release
3. SRE Agent → Monitor deploy
4. Observability Agent → Verify metrics
```

---

## Tips

1. **Be specific** - Tell Claude which agent to use
2. **Combine agents** - Use crews for complex tasks
3. **Use hooks** - Automate checks
4. **Leverage MCP** - Query external services
5. **Check examples** - Copy project configs

---

## Resources

| Resource | Location |
|----------|----------|
| Full docs | `docs/` |
| Agent index | `index.json` |
| Troubleshooting | `docs/TROUBLESHOOTING.md` |
| Best practices | `docs/BEST_PRACTICES.md` |

---

*v3.2 - 121+ agents, 4 crews, 8 MCP integrations*
