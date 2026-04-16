# Go Microservices Example

Example configuration for a Go microservices platform with gRPC, Kubernetes, and modern observability.

## Stack

| Technology | Purpose |
|------------|---------|
| Go 1.21+ | Language |
| gRPC | Service communication |
| Protocol Buffers | API definition |
| Kubernetes | Orchestration |
| Docker | Containerization |
| PostgreSQL | Database |
| Redis | Caching |
| Prometheus | Metrics |
| Jaeger | Tracing |

## Files Included

```
microservices/
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
export DATABASE_URL="postgres://user:pass@localhost:5432/mydb"

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

### For Development

| Agent | When to Use |
|-------|-------------|
| **Go Agent** | Go idioms, best practices |
| **API Design Agent** | gRPC/REST design |
| **Database Architect Agent** | Schema, queries |

### For Infrastructure

| Agent | When to Use |
|-------|-------------|
| **Systems Agent** | Docker, K8s |
| **SRE Agent** | Reliability |
| **Security Agent** | mTLS, auth |

## MCP Integrations

### PostgreSQL
- Query databases across services
- Analyze query performance
- Check schema differences

### GitHub
- Manage issues
- Create PRs
- Search code across services

### Sentry
- Debug production errors
- Track service health

## Common Workflows

### Create New Service

```
1. "Create service structure for payment-service"
2. "Define proto for PaymentService"
3. "Generate gRPC code"
4. "Implement handlers"
5. "Create Dockerfile and K8s manifests"
```

### Add Service Communication

```
1. "Design gRPC contract between services"
2. "Generate proto code"
3. "Implement client in calling service"
4. "Add circuit breaker"
5. "Test with integration tests"
```

### Deploy Service

```
1. "Build and push Docker image"
2. "Apply K8s manifests"
3. "Verify rollout"
4. "Check metrics and logs"
```

### Debug Production Issue

```
1. "Show recent errors in Sentry"
2. "Check service metrics in Prometheus"
3. "Trace request in Jaeger"
4. "Query related data in PostgreSQL"
```

## Service Template

```go
package main

import (
    "context"
    "log"
    "net"

    "google.golang.org/grpc"
    pb "myservice/proto"
)

type server struct {
    pb.UnimplementedMyServiceServer
}

func (s *server) MyMethod(ctx context.Context, req *pb.MyRequest) (*pb.MyResponse, error) {
    // Implementation
    return &pb.MyResponse{}, nil
}

func main() {
    lis, err := net.Listen("tcp", ":9090")
    if err != nil {
        log.Fatalf("failed to listen: %v", err)
    }

    s := grpc.NewServer()
    pb.RegisterMyServiceServer(s, &server{})

    log.Printf("server listening at %v", lis.Addr())
    if err := s.Serve(lis); err != nil {
        log.Fatalf("failed to serve: %v", err)
    }
}
```

## Best Practices

1. **Single responsibility** - One service, one purpose
2. **API-first** - Define protos before implementing
3. **Observability** - Logs, metrics, traces everywhere
4. **Circuit breakers** - Protect against cascade failures
5. **Graceful shutdown** - Handle SIGTERM properly

## Resources

- [Go gRPC Docs](https://grpc.io/docs/languages/go/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Protocol Buffers](https://developers.google.com/protocol-buffers)
- [Microservices Patterns](https://microservices.io/)
