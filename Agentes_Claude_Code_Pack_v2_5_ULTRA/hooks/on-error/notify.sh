#!/bin/bash
# ============================================================================
# notify.sh - Envía notificaciones cuando ocurren errores
# ============================================================================
# Trigger: OnError
# Propósito: Alertar a usuarios/equipos sobre errores de Claude
# ============================================================================

# No usar set -e para que notificaciones parciales no bloqueen
set +e

# Colores
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================================
# Configuración
# ============================================================================

# Variables de entorno de Claude
SESSION_ID="${CLAUDE_SESSION_ID:-unknown}"
PROJECT_PATH="${CLAUDE_PROJECT_PATH:-.}"
ERROR_MESSAGE="${CLAUDE_ERROR_MESSAGE:-Unknown error}"
ERROR_TOOL="${CLAUDE_TOOL_NAME:-unknown}"

# Configuración de notificaciones
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"
DISCORD_WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"
TEAMS_WEBHOOK_URL="${TEAMS_WEBHOOK_URL:-}"
EMAIL_TO="${NOTIFY_EMAIL:-}"
NOTIFY_CHANNEL="${NOTIFY_CHANNEL:-#claude-alerts}"

# Nivel mínimo para notificar: error, warning, all
NOTIFY_LEVEL="${NOTIFY_LEVEL:-error}"

# Log de errores
ERROR_LOG_DIR="${HOME}/.claude/logs"
ERROR_LOG_FILE="$ERROR_LOG_DIR/errors-$(date +%Y-%m-%d).jsonl"

# ============================================================================
# Funciones de utilidad
# ============================================================================

get_project_name() {
    basename "$PROJECT_PATH"
}

get_git_info() {
    if [ -d "$PROJECT_PATH/.git" ]; then
        cd "$PROJECT_PATH"
        local branch=$(git branch --show-current 2>/dev/null || echo "unknown")
        local user=$(git config user.name 2>/dev/null || whoami)
        echo "$user on $branch"
    else
        echo "$(whoami)"
    fi
}

sanitize_message() {
    # Limpiar mensaje para notificaciones
    echo "$1" | tr '\n' ' ' | sed 's/"/\\"/g' | head -c 500
}

# ============================================================================
# Log de error local
# ============================================================================

log_error() {
    mkdir -p "$ERROR_LOG_DIR" 2>/dev/null

    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local hostname=$(hostname 2>/dev/null || echo "unknown")
    local sanitized_msg=$(sanitize_message "$ERROR_MESSAGE")

    cat >> "$ERROR_LOG_FILE" <<EOF
{"timestamp":"$timestamp","session":"$SESSION_ID","project":"$(get_project_name)","tool":"$ERROR_TOOL","error":"$sanitized_msg","host":"$hostname"}
EOF
}

# ============================================================================
# Notificación a Slack
# ============================================================================

notify_slack() {
    if [ -z "$SLACK_WEBHOOK_URL" ]; then
        return 0
    fi

    local project=$(get_project_name)
    local context=$(get_git_info)
    local sanitized_error=$(sanitize_message "$ERROR_MESSAGE")
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S %Z")

    # Crear payload de Slack
    local payload=$(cat <<EOF
{
    "channel": "$NOTIFY_CHANNEL",
    "username": "Claude Code",
    "icon_emoji": ":robot_face:",
    "attachments": [
        {
            "color": "danger",
            "title": "Error in Claude Code Session",
            "fields": [
                {
                    "title": "Project",
                    "value": "$project",
                    "short": true
                },
                {
                    "title": "Tool",
                    "value": "$ERROR_TOOL",
                    "short": true
                },
                {
                    "title": "Context",
                    "value": "$context",
                    "short": true
                },
                {
                    "title": "Session",
                    "value": "$SESSION_ID",
                    "short": true
                },
                {
                    "title": "Error",
                    "value": "\`\`\`$sanitized_error\`\`\`",
                    "short": false
                }
            ],
            "footer": "Claude Code Error Notification",
            "ts": $(date +%s)
        }
    ]
}
EOF
)

    # Enviar a Slack (async)
    if command -v curl &> /dev/null; then
        (
            curl -s -X POST "$SLACK_WEBHOOK_URL" \
                -H "Content-Type: application/json" \
                -d "$payload" \
                --max-time 10 \
                > /dev/null 2>&1
        ) &
        echo -e "${CYAN}Slack notification sent${NC}"
    fi
}

# ============================================================================
# Notificación a Discord
# ============================================================================

notify_discord() {
    if [ -z "$DISCORD_WEBHOOK_URL" ]; then
        return 0
    fi

    local project=$(get_project_name)
    local context=$(get_git_info)
    local sanitized_error=$(sanitize_message "$ERROR_MESSAGE")

    local payload=$(cat <<EOF
{
    "username": "Claude Code",
    "avatar_url": "https://www.anthropic.com/images/icons/apple-touch-icon.png",
    "embeds": [
        {
            "title": "Error in Claude Code Session",
            "color": 15158332,
            "fields": [
                {"name": "Project", "value": "$project", "inline": true},
                {"name": "Tool", "value": "$ERROR_TOOL", "inline": true},
                {"name": "Context", "value": "$context", "inline": true},
                {"name": "Error", "value": "\`\`\`$sanitized_error\`\`\`", "inline": false}
            ],
            "footer": {"text": "Session: $SESSION_ID"},
            "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
        }
    ]
}
EOF
)

    if command -v curl &> /dev/null; then
        (
            curl -s -X POST "$DISCORD_WEBHOOK_URL" \
                -H "Content-Type: application/json" \
                -d "$payload" \
                --max-time 10 \
                > /dev/null 2>&1
        ) &
        echo -e "${CYAN}Discord notification sent${NC}"
    fi
}

# ============================================================================
# Notificación a Microsoft Teams
# ============================================================================

notify_teams() {
    if [ -z "$TEAMS_WEBHOOK_URL" ]; then
        return 0
    fi

    local project=$(get_project_name)
    local sanitized_error=$(sanitize_message "$ERROR_MESSAGE")

    local payload=$(cat <<EOF
{
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "themeColor": "FF0000",
    "summary": "Claude Code Error",
    "sections": [{
        "activityTitle": "Error in Claude Code Session",
        "facts": [
            {"name": "Project", "value": "$project"},
            {"name": "Tool", "value": "$ERROR_TOOL"},
            {"name": "Session", "value": "$SESSION_ID"},
            {"name": "Error", "value": "$sanitized_error"}
        ],
        "markdown": true
    }]
}
EOF
)

    if command -v curl &> /dev/null; then
        (
            curl -s -X POST "$TEAMS_WEBHOOK_URL" \
                -H "Content-Type: application/json" \
                -d "$payload" \
                --max-time 10 \
                > /dev/null 2>&1
        ) &
        echo -e "${CYAN}Teams notification sent${NC}"
    fi
}

# ============================================================================
# Notificación por email (usando sendmail/mail si disponible)
# ============================================================================

notify_email() {
    if [ -z "$EMAIL_TO" ]; then
        return 0
    fi

    local project=$(get_project_name)
    local context=$(get_git_info)
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S %Z")

    local subject="[Claude Code] Error in $project"
    local body=$(cat <<EOF
Claude Code Error Notification

Project: $project
Tool: $ERROR_TOOL
Session: $SESSION_ID
Context: $context
Time: $timestamp

Error:
$ERROR_MESSAGE

---
This is an automated notification from Claude Code.
EOF
)

    if command -v mail &> /dev/null; then
        echo "$body" | mail -s "$subject" "$EMAIL_TO" 2>/dev/null &
        echo -e "${CYAN}Email notification sent to $EMAIL_TO${NC}"
    elif command -v sendmail &> /dev/null; then
        (
            echo "Subject: $subject"
            echo "To: $EMAIL_TO"
            echo ""
            echo "$body"
        ) | sendmail "$EMAIL_TO" 2>/dev/null &
        echo -e "${CYAN}Email notification sent to $EMAIL_TO${NC}"
    fi
}

# ============================================================================
# Notificación local (desktop notification)
# ============================================================================

notify_desktop() {
    local project=$(get_project_name)
    local short_error=$(echo "$ERROR_MESSAGE" | head -c 100)

    # macOS
    if command -v osascript &> /dev/null; then
        osascript -e "display notification \"$short_error\" with title \"Claude Code Error\" subtitle \"$project\"" 2>/dev/null &
        return 0
    fi

    # Linux (notify-send)
    if command -v notify-send &> /dev/null; then
        notify-send -u critical "Claude Code Error in $project" "$short_error" 2>/dev/null &
        return 0
    fi
}

# ============================================================================
# Output de consola
# ============================================================================

echo ""
echo -e "${RED}============================================${NC}"
echo -e "${RED}  Claude Code Error Detected${NC}"
echo -e "${RED}============================================${NC}"
echo ""
echo -e "${YELLOW}Project:${NC}  $(get_project_name)"
echo -e "${YELLOW}Tool:${NC}     $ERROR_TOOL"
echo -e "${YELLOW}Session:${NC}  $SESSION_ID"
echo ""
echo -e "${YELLOW}Error:${NC}"
echo "$ERROR_MESSAGE" | head -20
echo ""
echo -e "${RED}============================================${NC}"
echo ""

# ============================================================================
# Ejecutar notificaciones
# ============================================================================

# Siempre loggear localmente
log_error

# Notificaciones externas
notify_slack
notify_discord
notify_teams
notify_email

# Notificación de desktop (solo si estamos en modo interactivo)
if [ -t 1 ]; then
    notify_desktop
fi

# Siempre salir con éxito para no afectar el flujo de Claude
exit 0
