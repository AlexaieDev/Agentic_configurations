# CLAUDE.md - Python FastAPI Service

## Project Overview

This is a Python FastAPI service with:
- **Framework**: FastAPI
- **Database**: PostgreSQL with SQLAlchemy
- **Migrations**: Alembic
- **Auth**: JWT tokens
- **Task Queue**: Celery + Redis
- **Deployment**: Docker + Kubernetes

## Architecture

```
src/
├── api/                    # API layer
│   ├── v1/                # Version 1 endpoints
│   │   ├── routes/        # Route handlers
│   │   └── deps.py        # Dependencies
│   └── middleware/        # Custom middleware
├── core/                   # Core configuration
│   ├── config.py          # Settings
│   ├── security.py        # Auth helpers
│   └── database.py        # DB connection
├── models/                 # SQLAlchemy models
├── schemas/                # Pydantic schemas
├── services/              # Business logic
├── repositories/          # Data access layer
├── tasks/                 # Celery tasks
└── utils/                 # Utilities
```

## Development Commands

```bash
# Environment
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Development
uvicorn src.main:app --reload --port 8000

# Database
alembic upgrade head          # Run migrations
alembic revision --autogenerate -m "description"  # Create migration
alembic downgrade -1          # Rollback last

# Testing
pytest                        # Run all tests
pytest -v                     # Verbose
pytest --cov=src             # With coverage
pytest -k "test_auth"        # Run specific tests

# Linting
ruff check src/              # Lint
ruff format src/             # Format
mypy src/                    # Type check

# Docker
docker-compose up -d         # Start services
docker-compose logs -f       # View logs
docker-compose down          # Stop services
```

## Environment Variables

```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb

# Security
SECRET_KEY=your-secret-key-here
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Redis
REDIS_URL=redis://localhost:6379/0

# Optional
DEBUG=true
LOG_LEVEL=INFO
CORS_ORIGINS=http://localhost:3000
```

## Key Files

| File | Purpose |
|------|---------|
| `src/main.py` | Application entry point |
| `src/core/config.py` | Pydantic settings |
| `src/core/database.py` | DB session management |
| `src/api/v1/routes/` | API endpoint handlers |
| `alembic/versions/` | Database migrations |
| `tests/conftest.py` | Test fixtures |

## Coding Standards

### Python
- Python 3.11+
- Type hints required for all functions
- Docstrings for public functions
- Follow PEP 8 (enforced by ruff)

### API Design
- RESTful conventions
- Version prefix (`/api/v1/`)
- Consistent error responses
- OpenAPI documentation

### Database
- Use SQLAlchemy 2.0 style
- Async when beneficial
- Migrations for all schema changes
- Indexes on frequently queried columns

### Testing
- Pytest for all tests
- Fixtures for common setup
- Factories for test data
- 80%+ coverage target

## Security Requirements

1. **Authentication**: JWT tokens with refresh
2. **Authorization**: Role-based access control
3. **Input Validation**: Pydantic schemas
4. **SQL Injection**: SQLAlchemy parameterized queries
5. **Rate Limiting**: On sensitive endpoints
6. **CORS**: Configured appropriately

## API Response Format

### Success
```json
{
  "data": {...},
  "meta": {
    "request_id": "uuid",
    "timestamp": "2024-01-15T10:00:00Z"
  }
}
```

### Error
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      {"field": "email", "message": "Invalid email format"}
    ]
  },
  "meta": {
    "request_id": "uuid",
    "timestamp": "2024-01-15T10:00:00Z"
  }
}
```

## Recommended Agents

| Task | Agent |
|------|-------|
| API design | API Design Agent |
| Database | Database Architect Agent |
| Python code | Python Agent |
| Security | Security Agent |
| Performance | Performance & Efficiency Agent |
| Testing | Test Architect Agent |
| Docker/K8s | Systems Agent |

## Common Tasks

### Add new endpoint
1. Create Pydantic schemas in `schemas/`
2. Add route in `api/v1/routes/`
3. Implement service logic in `services/`
4. Add repository methods if needed
5. Write tests
6. Update OpenAPI docs

### Add database model
1. Create model in `models/`
2. Create migration: `alembic revision --autogenerate`
3. Review and apply: `alembic upgrade head`
4. Add repository in `repositories/`
5. Create Pydantic schemas

### Add background task
1. Create task in `tasks/`
2. Register in Celery app
3. Add to task scheduler if periodic
4. Write tests with celery_worker fixture

## Performance Guidelines

1. Use async where I/O bound
2. Database connection pooling
3. Redis caching for hot data
4. Pagination for list endpoints
5. Background tasks for heavy operations

## Deployment

### Docker
```bash
docker build -t myapi:latest .
docker run -p 8000:8000 myapi:latest
```

### Kubernetes
```bash
kubectl apply -f k8s/
kubectl rollout status deployment/myapi
```

## Monitoring

- **Logs**: Structured JSON logging
- **Metrics**: Prometheus /metrics endpoint
- **Tracing**: OpenTelemetry integration
- **Health**: /health and /ready endpoints
