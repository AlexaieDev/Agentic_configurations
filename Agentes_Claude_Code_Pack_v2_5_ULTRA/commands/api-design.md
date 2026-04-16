---
name: api-design
description: Diseñar API endpoint siguiendo best practices
version: "1.0"
agents:
  - API Design Agent
  - OpenAPI Spec Agent
  - Security Agent
  - Documentation Agent
args:
  - name: resource
    description: Nombre del recurso (users, orders, products)
    required: true
  - name: style
    description: Estilo de API (rest, graphql, rpc)
    required: false
    default: "rest"
  - name: version
    description: Versión de API (v1, v2)
    required: false
    default: "v1"
---

# /api-design

## Descripción

Diseña endpoints de API siguiendo best practices. Genera especificación OpenAPI, considera seguridad, y produce documentación lista para implementar.

## Instrucciones

### Fase 1: Análisis de Requisitos

#### 1.1 Definir el Recurso

```markdown
### Resource Definition
- **Name**: users
- **Description**: Gestión de usuarios del sistema
- **Domain**: Authentication & Identity
- **Related Resources**: profiles, roles, sessions
```

#### 1.2 Identificar Operaciones

```markdown
### Operations
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /users | List users |
| POST | /users | Create user |
| GET | /users/{id} | Get user by ID |
| PUT | /users/{id} | Update user |
| PATCH | /users/{id} | Partial update |
| DELETE | /users/{id} | Delete user |
```

#### 1.3 Definir Data Model

```typescript
interface User {
  id: string;           // UUID v4
  email: string;        // Unique, valid email
  name: string;         // 1-100 chars
  role: 'admin' | 'user' | 'guest';
  status: 'active' | 'inactive' | 'pending';
  createdAt: string;    // ISO 8601
  updatedAt: string;    // ISO 8601
}
```

### Fase 2: Diseño REST

#### 2.1 Naming Conventions

```
✅ DO:
- Use nouns for resources: /users, /orders
- Use plural: /users not /user
- Use kebab-case: /user-profiles
- Use lowercase: /users not /Users
- Nest for relationships: /users/{id}/orders

❌ DON'T:
- Use verbs: /getUsers, /createUser
- Use camelCase: /userProfiles
- Deep nesting (>3 levels): /a/b/c/d/e
```

#### 2.2 HTTP Methods

| Method | Usage | Idempotent | Safe |
|--------|-------|------------|------|
| GET | Read resource(s) | Yes | Yes |
| POST | Create resource | No | No |
| PUT | Replace resource | Yes | No |
| PATCH | Partial update | No | No |
| DELETE | Remove resource | Yes | No |

#### 2.3 Status Codes

```markdown
### Success
- 200 OK - Successful GET, PUT, PATCH
- 201 Created - Successful POST
- 204 No Content - Successful DELETE

### Client Errors
- 400 Bad Request - Invalid input
- 401 Unauthorized - Auth required
- 403 Forbidden - Insufficient permissions
- 404 Not Found - Resource doesn't exist
- 409 Conflict - Resource conflict
- 422 Unprocessable Entity - Validation error

### Server Errors
- 500 Internal Server Error - Unexpected error
- 503 Service Unavailable - Temporarily unavailable
```

### Fase 3: Request/Response Design

#### 3.1 Request Format

```typescript
// POST /users
interface CreateUserRequest {
  email: string;      // Required, valid email
  password: string;   // Required, min 8 chars
  name: string;       // Required, 1-100 chars
  role?: string;      // Optional, defaults to 'user'
}

// GET /users
interface ListUsersQuery {
  page?: number;      // Default: 1
  limit?: number;     // Default: 20, max: 100
  sort?: string;      // Field to sort by
  order?: 'asc' | 'desc';  // Default: asc
  status?: string;    // Filter by status
  search?: string;    // Search in name/email
}
```

#### 3.2 Response Format

```typescript
// Single resource
interface UserResponse {
  data: User;
  meta?: {
    requestId: string;
  };
}

// Collection
interface UsersResponse {
  data: User[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
  links: {
    self: string;
    next?: string;
    prev?: string;
  };
}

// Error
interface ErrorResponse {
  error: {
    code: string;
    message: string;
    details?: Record<string, string[]>;
  };
  meta: {
    requestId: string;
    timestamp: string;
  };
}
```

### Fase 4: OpenAPI Specification

```yaml
openapi: 3.1.0
info:
  title: Users API
  version: 1.0.0
  description: API para gestión de usuarios

servers:
  - url: https://api.example.com/v1
    description: Production
  - url: https://staging-api.example.com/v1
    description: Staging

paths:
  /users:
    get:
      summary: List users
      operationId: listUsers
      tags: [Users]
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
            maximum: 100
      responses:
        '200':
          description: List of users
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UsersResponse'
        '401':
          $ref: '#/components/responses/Unauthorized'

    post:
      summary: Create user
      operationId: createUser
      tags: [Users]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserResponse'
        '400':
          $ref: '#/components/responses/BadRequest'
        '409':
          $ref: '#/components/responses/Conflict'

  /users/{id}:
    get:
      summary: Get user by ID
      operationId: getUser
      tags: [Users]
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: User found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserResponse'
        '404':
          $ref: '#/components/responses/NotFound'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 1
          maxLength: 100
        role:
          type: string
          enum: [admin, user, guest]
        status:
          type: string
          enum: [active, inactive, pending]
        createdAt:
          type: string
          format: date-time
        updatedAt:
          type: string
          format: date-time
      required: [id, email, name, role, status]

  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

security:
  - bearerAuth: []
```

### Fase 5: Seguridad

```markdown
### Security Checklist
- [ ] Authentication required (JWT/OAuth)
- [ ] Rate limiting configurado
- [ ] Input validation en todos los campos
- [ ] Authorization checks por recurso
- [ ] CORS configurado correctamente
- [ ] Sensitive data no en logs
- [ ] HTTPS enforced
```

### Fase 6: Documentación

```markdown
## Users API

### Authentication
All endpoints require Bearer token authentication.

```bash
curl -H "Authorization: Bearer <token>" \
  https://api.example.com/v1/users
```

### Pagination
List endpoints return paginated results:

| Parameter | Default | Max | Description |
|-----------|---------|-----|-------------|
| page | 1 | - | Page number |
| limit | 20 | 100 | Items per page |

### Rate Limits
- 1000 requests/hour per API key
- 100 requests/minute burst

### Examples

#### Create User
```bash
curl -X POST https://api.example.com/v1/users \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "secure123!",
    "name": "John Doe"
  }'
```

#### List Users with Filters
```bash
curl "https://api.example.com/v1/users?status=active&limit=50" \
  -H "Authorization: Bearer <token>"
```
```

## Output

El comando genera:
1. OpenAPI spec (`openapi.yaml`)
2. TypeScript types (`types.ts`)
3. Request examples (`examples/`)
4. README documentation

## Ejemplos de Uso

```bash
# Diseñar API de usuarios
/api-design resource=users

# API GraphQL para productos
/api-design resource=products style=graphql

# API v2 para órdenes
/api-design resource=orders version=v2
```
