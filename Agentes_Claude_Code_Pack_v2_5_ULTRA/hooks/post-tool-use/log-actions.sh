#!/bin/bash
# ============================================================================
# log-actions.sh - Registra acciones de herramientas para auditoría
# ============================================================================
# Trigger: PostToolUse
# Propósito: Crear registro de acciones para compliance y debugging
# ============================================================================

# No usar set -e para que el logging no bloquee operaciones
set +e

# Colores (solo si terminal interactiva)
if [ -t 1 ]; then
    CYAN='\033[0;36m'
    NC='\033[0m'
else
    CYAN=''
    NC=''
fi

# ============================================================================
# Configuración
# ============================================================================

# Directorio de logs
LOG_DIR="${CLAUDE_LOG_DIR:-${HOME}/.claude/logs}"
LOG_FILE="$LOG_DIR/actions-$(date +%Y-%m-%d).jsonl"

# Variables de entorno de Claude
SESSION_ID="${CLAUDE_SESSION_ID:-unknown}"
PROJECT_PATH="${CLAUDE_PROJECT_PATH:-.}"
TOOL_NAME="${CLAUDE_TOOL_NAME:-unknown}"
TOOL_RESULT="${CLAUDE_TOOL_RESULT:-}"

# Configuración de logging externo (opcional)
LOG_ENDPOINT="${LOG_ENDPOINT:-}"
LOG_TOKEN="${LOG_TOKEN:-}"

# Máximo tamaño de log por día (10MB)
MAX_LOG_SIZE=$((10 * 1024 * 1024))

# ============================================================================
# Funciones de utilidad
# ============================================================================

ensure_log_dir() {
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR" 2>/dev/null || true
    fi
}

rotate_log_if_needed() {
    if [ -f "$LOG_FILE" ]; then
        local size=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null || echo "0")
        if [ "$size" -gt "$MAX_LOG_SIZE" ]; then
            mv "$LOG_FILE" "${LOG_FILE}.$(date +%H%M%S).bak"
        fi
    fi
}

get_git_context() {
    if [ -d "$PROJECT_PATH/.git" ]; then
        cd "$PROJECT_PATH"
        local branch=$(git branch --show-current 2>/dev/null || echo "")
        local commit=$(git rev-parse --short HEAD 2>/dev/null || echo "")
        echo "{\"branch\":\"$branch\",\"commit\":\"$commit\"}"
    else
        echo "{}"
    fi
}

sanitize_json() {
    # Escapar caracteres especiales para JSON
    echo "$1" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed 's/	/\\t/g' | tr '\n' ' ' | head -c 1000
}

# ============================================================================
# Crear entrada de log
# ============================================================================

create_log_entry() {
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local hostname=$(hostname 2>/dev/null || echo "unknown")
    local user=$(whoami 2>/dev/null || echo "unknown")
    local git_context=$(get_git_context)
    local result_sanitized=$(sanitize_json "$TOOL_RESULT")

    # Determinar categoría de la herramienta
    local category="other"
    case "$TOOL_NAME" in
        Read|Write|Edit|Glob|Grep)
            category="filesystem"
            ;;
        Bash)
            category="shell"
            ;;
        WebFetch|WebSearch)
            category="network"
            ;;
        Agent)
            category="agent"
            ;;
        TodoWrite)
            category="planning"
            ;;
        *)
            category="other"
            ;;
    esac

    # Crear JSON entry
    cat <<EOF
{"timestamp":"$timestamp","session_id":"$SESSION_ID","tool":"$TOOL_NAME","category":"$category","project":"$PROJECT_PATH","user":"$user","host":"$hostname","git":$git_context,"result_preview":"$result_sanitized"}
EOF
}

# ============================================================================
# Log a archivo local
# ============================================================================

log_to_file() {
    ensure_log_dir
    rotate_log_if_needed

    local entry=$(create_log_entry)
    echo "$entry" >> "$LOG_FILE" 2>/dev/null

    return 0
}

# ============================================================================
# Log a servicio externo (opcional)
# ============================================================================

log_to_external() {
    if [ -z "$LOG_ENDPOINT" ]; then
        return 0
    fi

    local entry=$(create_log_entry)

    # Enviar a endpoint (async, no bloquear)
    if command -v curl &> /dev/null; then
        (
            curl -s -X POST "$LOG_ENDPOINT" \
                -H "Content-Type: application/json" \
                -H "Authorization: Bearer $LOG_TOKEN" \
                -d "$entry" \
                --max-time 5 \
                > /dev/null 2>&1
        ) &
    fi

    return 0
}

# ============================================================================
# Métricas agregadas (opcional)
# ============================================================================

update_metrics() {
    local metrics_file="$LOG_DIR/metrics-$(date +%Y-%m-%d).json"

    # Inicializar métricas si no existen
    if [ ! -f "$metrics_file" ]; then
        echo '{"tools":{},"sessions":{},"total_actions":0}' > "$metrics_file"
    fi

    # Actualizar contador de herramienta (usando jq si está disponible)
    if command -v jq &> /dev/null; then
        local temp_file=$(mktemp)
        jq --arg tool "$TOOL_NAME" --arg session "$SESSION_ID" '
            .total_actions += 1 |
            .tools[$tool] = ((.tools[$tool] // 0) + 1) |
            .sessions[$session] = ((.sessions[$session] // 0) + 1)
        ' "$metrics_file" > "$temp_file" 2>/dev/null && mv "$temp_file" "$metrics_file"
    fi
}

# ============================================================================
# Output (si verbose)
# ============================================================================

if [ "${VERBOSE:-false}" = "true" ]; then
    echo -e "${CYAN}[LOG]${NC} $TOOL_NAME action recorded"
fi

# ============================================================================
# Ejecutar logging
# ============================================================================

log_to_file
log_to_external
update_metrics

# Siempre salir con éxito para no bloquear operaciones
exit 0
