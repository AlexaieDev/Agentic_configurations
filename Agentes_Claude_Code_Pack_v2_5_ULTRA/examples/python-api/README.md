# Python FastAPI Example

Example configuration for a Python FastAPI service with PostgreSQL, Celery, and modern tooling.

## Stack

| Technology | Purpose |
|------------|---------|
| FastAPI | API framework |
| Python 3.11+ | Runtime |
| PostgreSQL | Database |
| SQLAlchemy 2.0 | ORM |
| Alembic | Migrations |
| Celery | Task queue |
| Redis | Cache & broker |
| Docker | Containerization |

## Files Included

```
python-api/
├── CLAUDE.md              # Instructions for Claude
├── .claude/
│   └── settings.json      # Claude Code settings
└── README.md              # This file
```

## How to Use

### 1. Copy to Your Project

```bash
# Copy CLAUDE.md to root
cp CLAUDE.md /path/to/your-project/

# Copy settings
mkdir -p /path/to/your-project/.claude
cp .claude/settings.json /path/to/your-project/.claude/
```

### 2. Configure Environment

```bash
# Database
export DATABASE_URL="postgresql://user:pass@localhost:5432/mydb"

# GitHub (for MCP)
export GITHUB_TOKEN="ghp_xxx"

# Sentry (optional)
export SENTRY_AUTH_TOKEN="sntrys_xxx"
export SENTRY_ORG="your-org"
```

### 3. Start Claude Code

```bash
cd /path/to/your-project
claude-code
```

## Recommended Agents

### For API Development

| Agent | When to Use |
|-------|-------------|
| **Python Agent** | Python idioms, best practices |
| **API Design Agent** | REST design, OpenAPI |
| **Database Architect Agent** | Schema, queries |

### For Quality

| Agent | When to Use |
|-------|-------------|
| **Test Architect Agent** | Pytest, coverage |
| **Security Agent** | Auth, input validation |
| **Performance Agent** | Optimization |

### For Infrastructure

| Agent | When to Use |
|-------|-------------|
| **Systems Agent** | Docker, deployment |
| **SRE Agent** | Monitoring, reliability |

## MCP Integrations

### PostgreSQL
- Query database directly
- Inspect schema
- Analyze query performance

### GitHub
- Create issues
- Manage PRs
- Search code

### Sentry
- Debug production errors
- Track performance

## Common Workflows

### Create New Endpoint

```
1. "Design REST endpoint for resource X"
2. "Create Pydantic schemas"
3. "Implement service layer"
4. "Add route handler"
5. "Write pytest tests"
```

### Add Database Model

```
1. "Create SQLAlchemy model for entity X"
2. "Generate Alembic migration"
3. "Create repository with CRUD"
4. "Add Pydantic schemas"
```

### Debug API Issue

```
1. "Show recent errors in Sentry"
2. "Query database for related data"
3. "Analyze slow queries"
4. "Implement fix"
```

## Linting & Type Checking

### Ruff
- Fast Python linter
- Replaces flake8, isort, etc.
- Auto-fix available

### Mypy
- Static type checking
- Strict mode recommended
- Catches type errors early

## Testing

### Structure
```
tests/
├── unit/              # Unit tests
├── integration/       # Integration tests
├── e2e/              # End-to-end tests
├── conftest.py       # Fixtures
└── factories.py      # Test data factories
```

### Running
```bash
pytest                        # All tests
pytest -v                     # Verbose
pytest --cov=src             # Coverage
pytest -k "test_auth"        # Specific
```

## Best Practices

1. **Type hints everywhere** - Enables mypy
2. **Pydantic for validation** - Input/output schemas
3. **Dependency injection** - Use FastAPI's Depends
4. **Repository pattern** - Separate data access
5. **Service layer** - Business logic isolation

## Resources

- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [SQLAlchemy 2.0](https://docs.sqlalchemy.org/)
- [Pydantic Docs](https://docs.pydantic.dev/)
- [Ruff](https://docs.astral.sh/ruff/)
