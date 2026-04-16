# Database Queries Guide

Guía completa para integrar Claude Code con PostgreSQL para consultas seguras y análisis de datos.

## Requisitos

- Servidor PostgreSQL accesible
- Usuario con permisos de lectura
- Connection string válido

## Configuración

### Paso 1: Crear Usuario de Solo Lectura

```sql
-- Conectar como superuser
psql -U postgres

-- Crear usuario para Claude
CREATE USER claude_reader WITH PASSWORD 'secure_password';

-- Otorgar permisos de solo lectura
GRANT CONNECT ON DATABASE mydb TO claude_reader;
GRANT USAGE ON SCHEMA public TO claude_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO claude_reader;

-- Para tablas futuras
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
  GRANT SELECT ON TABLES TO claude_reader;

-- Opcional: Limitar conexiones
ALTER USER claude_reader CONNECTION LIMIT 5;

-- Opcional: Timeout de statements
ALTER USER claude_reader SET statement_timeout = '30s';
```

### Paso 2: Configurar Connection String

```bash
# Formato básico
export DATABASE_URL="postgresql://claude_reader:password@host:5432/mydb"

# Con SSL
export DATABASE_URL="postgresql://claude_reader:password@host:5432/mydb?sslmode=require"

# Con parámetros adicionales
export DATABASE_URL="postgresql://claude_reader:password@host:5432/mydb?sslmode=require&connect_timeout=10"
```

### Paso 3: Configurar MCP Server

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

### Paso 4: Verificar Conexión

```bash
# Probar conexión
psql $DATABASE_URL -c "SELECT 1"

# Verificar permisos
psql $DATABASE_URL -c "SELECT current_user, session_user"
```

## Herramientas Disponibles

### query
Ejecutar query SQL de solo lectura.

```
Ejemplo: "Muéstrame los usuarios creados este mes"
```

### list_tables
Listar todas las tablas.

```
Ejemplo: "Qué tablas hay en la base de datos?"
```

### describe_table
Obtener schema de una tabla.

```
Ejemplo: "Cuál es el schema de la tabla users?"
```

### list_indexes
Listar índices de una tabla.

```
Ejemplo: "Qué índices tiene la tabla orders?"
```

### explain_query
Obtener plan de ejecución.

```
Ejemplo: "Explica el plan de esta query: SELECT..."
```

## Seguridad

### Principios Fundamentales

```markdown
1. **Solo lectura** - Nunca usar usuarios con permisos de escritura
2. **Usuario dedicado** - No reutilizar credenciales
3. **Read replica** - Usar réplica cuando sea posible
4. **Timeout** - Configurar timeouts para queries
5. **Logs** - Registrar todas las queries ejecutadas
```

### Permisos Recomendados

```sql
-- GRANT MÍNIMO
GRANT SELECT ON ALL TABLES IN SCHEMA public TO claude_reader;

-- NO OTORGAR
-- INSERT, UPDATE, DELETE
-- CREATE, DROP
-- GRANT, REVOKE
-- SUPERUSER
```

### Connection Pooling

```json
{
  "postgres": {
    "pool": {
      "min": 1,
      "max": 5,
      "idleTimeoutMs": 30000
    }
  }
}
```

## Queries Comunes

### Análisis de Datos

```sql
-- Conteo por tabla
SELECT 
  schemaname,
  relname AS table,
  n_live_tup AS row_count
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;

-- Tamaño de tablas
SELECT 
  relname AS table,
  pg_size_pretty(pg_total_relation_size(relid)) AS size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC
LIMIT 10;

-- Distribución de valores
SELECT 
  column_name,
  COUNT(*) as count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM table_name
GROUP BY column_name
ORDER BY count DESC;
```

### Performance

```sql
-- Queries lentas (requiere pg_stat_statements)
SELECT 
  query,
  calls,
  ROUND(mean_exec_time::numeric, 2) AS avg_ms,
  ROUND(total_exec_time::numeric, 2) AS total_ms
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

-- Índices no usados
SELECT
  schemaname,
  relname AS table,
  indexrelname AS index,
  idx_scan AS scans
FROM pg_stat_user_indexes
WHERE idx_scan = 0
  AND indexrelname !~ '^(pk_|unique_)'
ORDER BY pg_relation_size(indexrelid) DESC;

-- Table bloat
SELECT
  schemaname,
  relname,
  n_live_tup,
  n_dead_tup,
  ROUND(n_dead_tup * 100.0 / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS dead_pct
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY n_dead_tup DESC;
```

### Monitoreo

```sql
-- Conexiones activas
SELECT 
  usename,
  application_name,
  client_addr,
  state,
  query_start,
  query
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY query_start;

-- Locks
SELECT 
  l.locktype,
  l.relation::regclass,
  l.mode,
  l.granted,
  a.usename,
  a.query
FROM pg_locks l
JOIN pg_stat_activity a ON l.pid = a.pid
WHERE NOT l.granted;

-- Tamaño de base de datos
SELECT 
  pg_database.datname AS database,
  pg_size_pretty(pg_database_size(pg_database.datname)) AS size
FROM pg_database
ORDER BY pg_database_size(pg_database.datname) DESC;
```

## Ejemplos de Uso con Agentes

### Con Database Architect Agent

```markdown
"Usando el Database Architect Agent:
1. Analiza el schema actual
2. Identifica problemas de normalización
3. Sugiere mejoras de índices
4. Detecta posibles issues de performance"
```

### Con Performance Agent

```markdown
"Usando el Performance & Efficiency Agent:
1. Encuentra las 10 queries más lentas
2. Analiza sus planes de ejecución
3. Sugiere optimizaciones
4. Verifica uso de índices"
```

### Con Data Quality Agent

```markdown
"Usando el Data Quality Agent:
1. Busca valores NULL donde no debería haber
2. Identifica duplicados
3. Verifica integridad referencial
4. Detecta anomalías en distribuciones"
```

## Patrones de Queries

### Paginación Eficiente

```sql
-- Cursor-based (recomendado)
SELECT * FROM users
WHERE id > :last_id
ORDER BY id
LIMIT 100;

-- Offset-based (evitar para datasets grandes)
SELECT * FROM users
ORDER BY id
LIMIT 100 OFFSET 1000;
```

### Agregaciones

```sql
-- Resumen con totales
SELECT 
  COALESCE(category, 'TOTAL') AS category,
  COUNT(*) AS count,
  SUM(amount) AS total
FROM orders
GROUP BY ROLLUP(category);

-- Ventana temporal
SELECT 
  date_trunc('day', created_at) AS day,
  COUNT(*) AS daily_count,
  SUM(COUNT(*)) OVER (ORDER BY date_trunc('day', created_at)) AS cumulative
FROM orders
GROUP BY 1
ORDER BY 1;
```

### Joins Seguros

```sql
-- Siempre usar explicit joins
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON o.user_id = u.id
WHERE o.status = 'completed';

-- Evitar cartesian products
-- MAL: SELECT * FROM users, orders WHERE users.id = orders.user_id
```

## Troubleshooting

### Error: Permission denied

```sql
-- Verificar permisos del usuario
SELECT 
  table_schema,
  table_name,
  privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'claude_reader';

-- Otorgar permisos faltantes
GRANT SELECT ON schema.table TO claude_reader;
```

### Error: Connection refused

```bash
# Verificar que postgres acepta conexiones
pg_isready -h host -p 5432

# Verificar pg_hba.conf permite la IP
# Verificar firewall
```

### Error: Query timeout

```sql
-- Verificar timeout actual
SHOW statement_timeout;

-- Aumentar si es necesario (como superuser)
ALTER USER claude_reader SET statement_timeout = '60s';
```

### Query muy lenta

```sql
-- Analizar plan de ejecución
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT ...;

-- Buscar sequential scans
EXPLAIN SELECT ...
-- Si ves "Seq Scan" en tabla grande, falta índice
```

## Best Practices

1. **Read replica** - Usar réplica para queries pesadas
2. **Timeouts** - Siempre configurar statement_timeout
3. **LIMIT** - Siempre limitar resultados
4. **EXPLAIN** - Analizar antes de ejecutar queries complejas
5. **Índices** - Verificar que existan para columnas filtradas
6. **Evitar SELECT *** - Seleccionar solo columnas necesarias

## Configuración Avanzada

### Múltiples Bases de Datos

```json
{
  "databases": {
    "production": "${DATABASE_URL_PROD}",
    "staging": "${DATABASE_URL_STAGING}",
    "analytics": "${DATABASE_URL_ANALYTICS}"
  },
  "defaultDatabase": "production"
}
```

### SSL/TLS

```bash
# Connection string con SSL
DATABASE_URL="postgresql://user:pass@host:5432/db?sslmode=verify-full&sslrootcert=/path/to/ca.crt"
```

## Recursos

- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [EXPLAIN Visualizer](https://explain.depesz.com/)
- [pgAdmin](https://www.pgadmin.org/)
- [PostgreSQL Performance Tips](https://wiki.postgresql.org/wiki/Performance_Optimization)
