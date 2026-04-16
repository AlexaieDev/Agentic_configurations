---
name: standup
description: Generar update de standup basado en actividad reciente
version: "1.0"
agents: []
args:
  - name: period
    description: Período a revisar (today, yesterday, week)
    required: false
    default: "yesterday"
  - name: format
    description: Formato de output (text, slack, json)
    required: false
    default: "text"
  - name: include
    description: Qué incluir (commits, prs, issues, all)
    required: false
    default: "all"
---

# /standup

## Descripción

Genera un reporte de standup basado en la actividad reciente en el repositorio. Analiza commits, PRs, issues y genera un resumen estructurado.

## Instrucciones

### 1. Recopilar Información

#### Git Activity
```bash
# Commits del período
git log --since="yesterday" --author="$(git config user.email)" --oneline

# Branches activas
git branch --list --sort=-committerdate | head -5

# Cambios en progreso
git status --short
```

#### GitHub Activity (si gh disponible)
```bash
# PRs creadas/actualizadas
gh pr list --author @me --state all --limit 10

# Issues asignadas
gh issue list --assignee @me --state open

# Reviews pendientes
gh pr list --search "review-requested:@me"
```

### 2. Categorizar Actividad

#### Completado (Done)
- Commits mergeados
- PRs cerrados
- Issues resueltas

#### En Progreso (In Progress)
- PRs abiertas
- Branches activas
- Cambios no commiteados

#### Bloqueadores
- PRs esperando review
- Issues bloqueadas
- Dependencias externas

### 3. Generar Update

```markdown
## Standup - [Fecha]

### Done Yesterday
- Merged PR #123: Add user authentication
- Fixed bug in checkout flow (commit abc1234)
- Completed code review for @teammate's PR #456

### Working On Today
- PR #789: Implement payment processing (in review)
- Starting work on API rate limiting (Issue #101)

### Blockers
- Waiting for API credentials from vendor
- PR #789 needs review from @security-team
```

## Output Formats

### Text (Default)
```
Standup - January 15, 2024

DONE
- Merged PR #123: Add user authentication
- Fixed checkout bug

IN PROGRESS  
- PR #789: Payment processing

BLOCKED
- Waiting for API credentials
```

### Slack
```json
{
  "blocks": [
    {
      "type": "header",
      "text": {"type": "plain_text", "text": "Standup - Jan 15"}
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Done*\n- Merged PR #123\n- Fixed checkout bug"
      }
    }
  ]
}
```

### Markdown (for Notion/Docs)
```markdown
# Daily Standup

| Date | Jan 15, 2024 |
|------|--------------|
| Author | @developer |

## Summary
3 items completed, 2 in progress, 1 blocker

## Details
...
```

## Customization

### Team Standup
Agregar contexto de equipo:

```bash
/standup include=all --team
```

Output incluye:
- Actividad del equipo
- PRs que necesitan review
- Deployments recientes

### Sprint Focus
```bash
/standup --sprint
```

Output incluye:
- Progreso vs sprint goals
- Story points completados
- Burndown status

## Automatización

### GitHub Action
```yaml
name: Daily Standup
on:
  schedule:
    - cron: '0 9 * * 1-5'  # 9am weekdays

jobs:
  standup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Generate Standup
        run: claude-code --command "/standup format=slack"
      - name: Post to Slack
        run: |
          curl -X POST $SLACK_WEBHOOK \
            -H "Content-Type: application/json" \
            -d @standup.json
```

### Cron Local
```bash
# Agregar a crontab
0 9 * * 1-5 cd ~/project && claude-code --command "/standup" >> ~/standups.log
```

## Ejemplos de Uso

```bash
# Standup básico
/standup

# Actividad de la semana
/standup period=week

# Solo commits
/standup include=commits

# Formato para Slack
/standup format=slack

# Ayer para reunión de hoy
/standup period=yesterday
```

## Templates Adicionales

### Async Standup
Para equipos remotos:
```markdown
## Async Update - @developer

### Progress
- [x] Task 1 completed
- [ ] Task 2 (50%)

### Availability
- Working normal hours (9-5 PST)
- OOO Friday afternoon

### Need Help With
- Review on PR #123
- Clarification on requirements for Feature X
```

### Technical Standup
Para equipos técnicos:
```markdown
## Tech Standup

### Commits
- abc1234: Fix memory leak
- def5678: Add caching layer

### Performance
- API latency: 45ms (target: 50ms)
- Error rate: 0.01%

### Incidents
- None in last 24h

### Deploys
- v2.3.4 deployed to staging
```
