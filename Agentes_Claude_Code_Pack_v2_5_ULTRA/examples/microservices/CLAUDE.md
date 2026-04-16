# CLAUDE.md - Go Microservices Platform

## Project Overview

This is a Go microservices platform with:
- **Language**: Go 1.21+
- **Communication**: gRPC + REST (Gateway)
- **Orchestration**: Kubernetes
- **Service Mesh**: Istio (optional)
- **Observability**: Prometheus + Grafana + Jaeger
- **CI/CD**: GitHub Actions + ArgoCD

## Architecture

```
.
├── services/              # Individual services
│   ├── api-gateway/      # REST to gRPC gateway
│   ├── user-service/     # User management
│   ├── order-service/    # Order processing
│   └── notification/     # Notifications
├── proto/                 # Protocol Buffer definitions
├── pkg/                   # Shared packages
│   ├── auth/             # JWT auth
│   ├── database/         # DB helpers
│   ├── logger/           # Structured logging
│   └── metrics/          # Prometheus metrics
├── k8s/                   # Kubernetes manifests
│   ├── base/             # Kustomize base
│   └── overlays/         # Environment overlays
├── scripts/              # Build and deploy scripts
└── docker/               # Dockerfiles
```

## Service Structure

Each service follows:
```
services/user-service/
├── cmd/
│   └── main.go           # Entry point
├── internal/
│   ├── config/           # Configuration
│   ├── handler/          # gRPC/HTTP handlers
│   ├── service/          # Business logic
│   ├── repository/       # Data access
│   └── model/            # Domain models
├── Dockerfile
├── go.mod
└── go.sum
```

## Development Commands

```bash
# Setup
make setup                # Install tools
make proto                # Generate proto code

# Development
make run-user             # Run user service
make run-all              # Run all services

# Testing
make test                 # All tests
make test-unit            # Unit tests
make test-integration     # Integration tests
make coverage             # Coverage report

# Linting
make lint                 # golangci-lint
make fmt                  # gofmt

# Building
make build                # Build all services
make docker-build         # Build Docker images
make docker-push          # Push to registry

# Kubernetes
make k8s-apply            # Apply to current context
make k8s-dev              # Apply dev overlay
make k8s-prod             # Apply prod overlay
```

## Environment Variables

```bash
# Service Config
SERVICE_NAME=user-service
SERVICE_PORT=8080
GRPC_PORT=9090

# Database
DATABASE_URL=postgres://user:pass@localhost:5432/users

# Observability
JAEGER_ENDPOINT=http://jaeger:14268/api/traces
PROMETHEUS_PORT=2112

# Auth
JWT_SECRET=your-secret
JWT_EXPIRY=24h

# Service Discovery
CONSUL_ADDR=consul:8500
# or
KUBERNETES_SERVICE_HOST=...
```

## Key Files

| File | Purpose |
|------|---------|
| `proto/*.proto` | Service definitions |
| `pkg/` | Shared libraries |
| `k8s/base/` | Base K8s manifests |
| `Makefile` | Build automation |
| `.golangci.yml` | Linter config |

## Coding Standards

### Go
- Go 1.21+ idioms
- Use `context.Context` for cancellation
- Error wrapping with `fmt.Errorf("%w")`
- Interface-based dependencies
- Table-driven tests

### gRPC
- Proto3 syntax
- Version APIs (v1, v2)
- Use well-known types
- Proper error codes

### Microservices
- Single responsibility
- API-first design
- Stateless services
- Circuit breakers
- Graceful shutdown

## Communication Patterns

### Sync (gRPC)
```go
// Direct service-to-service
client := userpb.NewUserServiceClient(conn)
resp, err := client.GetUser(ctx, &userpb.GetUserRequest{Id: id})
```

### Async (Events)
```go
// Event-driven
publisher.Publish(ctx, "user.created", &UserCreatedEvent{...})
```

## Observability

### Logging
```go
logger.Info("user created",
    zap.String("user_id", id),
    zap.String("trace_id", traceID))
```

### Metrics
```go
requestDuration.WithLabelValues(method, status).Observe(duration)
```

### Tracing
```go
span := trace.SpanFromContext(ctx)
span.SetAttributes(attribute.String("user_id", id))
```

## Recommended Agents

| Task | Agent |
|------|-------|
| Go code | Go Agent |
| API design | API Design Agent |
| Database | Database Architect Agent |
| Kubernetes | Systems Agent |
| Reliability | SRE Agent |
| Security | Security Agent |
| Performance | Performance & Efficiency Agent |

## Common Tasks

### Add new service
1. Create directory in `services/`
2. Define protos in `proto/`
3. Generate code: `make proto`
4. Implement handlers and service
5. Add Dockerfile
6. Add K8s manifests
7. Update CI/CD

### Add new endpoint
1. Update proto definition
2. Regenerate: `make proto`
3. Implement handler
4. Add tests
5. Update docs

### Deploy to Kubernetes
1. Build: `make docker-build`
2. Push: `make docker-push`
3. Apply: `make k8s-apply`
4. Verify: `kubectl rollout status`

## Security Requirements

1. **mTLS**: Service-to-service encryption
2. **JWT**: User authentication
3. **RBAC**: Kubernetes RBAC
4. **Secrets**: K8s Secrets or Vault
5. **Network Policies**: Restrict traffic

## Performance Guidelines

1. Connection pooling for DB and gRPC
2. Proper timeouts on all calls
3. Circuit breakers for external deps
4. Horizontal scaling via K8s
5. Cache hot data in Redis

## Deployment

### Rolling Update
```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
```

### Canary
```yaml
# Using Istio VirtualService
spec:
  http:
  - route:
    - destination:
        host: user-service
        subset: stable
      weight: 90
    - destination:
        host: user-service
        subset: canary
      weight: 10
```

## Troubleshooting

### Service Discovery
```bash
kubectl get endpoints user-service
kubectl describe svc user-service
```

### Connectivity
```bash
kubectl exec -it debug-pod -- grpcurl user-service:9090 list
```

### Logs
```bash
kubectl logs -l app=user-service --tail=100 -f
```
