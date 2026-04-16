#!/bin/bash
# ============================================================================
# check-env.sh - Verifica variables de entorno necesarias
# ============================================================================
# Trigger: SessionStart
# Propósito: Asegurar que el environment está correctamente configurado
# ============================================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROJECT_PATH="${CLAUDE_PROJECT_PATH:-.}"
cd "$PROJECT_PATH"

# ============================================================================
# Funciones de utilidad
# ============================================================================

check_var() {
    local var_name=$1
    local is_required=$2
    local is_secret=$3

    if [ -z "${!var_name}" ]; then
        if [ "$is_required" = "true" ]; then
            echo -e "${RED}MISSING${NC} $var_name (required)"
            return 1
        else
            echo -e "${YELLOW}UNSET${NC}  $var_name (optional)"
            return 0
        fi
    else
        if [ "$is_secret" = "true" ]; then
            echo -e "${GREEN}SET${NC}    $var_name (***hidden***)"
        else
            # Mostrar primeros 20 caracteres
            local value="${!var_name}"
            if [ ${#value} -gt 20 ]; then
                echo -e "${GREEN}SET${NC}    $var_name = ${value:0:20}..."
            else
                echo -e "${GREEN}SET${NC}    $var_name = $value"
            fi
        fi
        return 0
    fi
}

check_file_vars() {
    local env_file=$1
    local missing=0

    if [ ! -f "$env_file" ]; then
        return 0
    fi

    echo ""
    echo "Checking variables from $env_file..."
    echo ""

    while IFS= read -r line || [ -n "$line" ]; do
        # Ignorar comentarios y líneas vacías
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$line" ]] && continue

        # Extraer nombre de variable
        var_name=$(echo "$line" | cut -d'=' -f1 | tr -d ' ')

        # Detectar si es secret
        is_secret="false"
        if [[ "$var_name" =~ (KEY|SECRET|PASSWORD|TOKEN|CREDENTIAL|PRIVATE) ]]; then
            is_secret="true"
        fi

        if ! check_var "$var_name" "false" "$is_secret"; then
            missing=$((missing + 1))
        fi
    done < "$env_file"

    return $missing
}

# ============================================================================
# Verificaciones de sistema
# ============================================================================

echo "Environment Check"
echo "================="
echo ""

ERRORS=0
WARNINGS=0

# ============================================================================
# Verificar herramientas de desarrollo
# ============================================================================

echo "Development Tools:"
echo ""

# Node.js
if command -v node &> /dev/null; then
    NODE_VER=$(node --version)
    echo -e "${GREEN}OK${NC}     Node.js $NODE_VER"
else
    if [ -f "package.json" ]; then
        echo -e "${RED}MISSING${NC} Node.js (required for this project)"
        ERRORS=$((ERRORS + 1))
    fi
fi

# npm/yarn/pnpm
if [ -f "package.json" ]; then
    if [ -f "pnpm-lock.yaml" ]; then
        if command -v pnpm &> /dev/null; then
            PNPM_VER=$(pnpm --version)
            echo -e "${GREEN}OK${NC}     pnpm $PNPM_VER"
        else
            echo -e "${YELLOW}MISSING${NC} pnpm (project uses pnpm-lock.yaml)"
            WARNINGS=$((WARNINGS + 1))
        fi
    elif [ -f "yarn.lock" ]; then
        if command -v yarn &> /dev/null; then
            YARN_VER=$(yarn --version)
            echo -e "${GREEN}OK${NC}     Yarn $YARN_VER"
        else
            echo -e "${YELLOW}MISSING${NC} Yarn (project uses yarn.lock)"
            WARNINGS=$((WARNINGS + 1))
        fi
    else
        if command -v npm &> /dev/null; then
            NPM_VER=$(npm --version)
            echo -e "${GREEN}OK${NC}     npm $NPM_VER"
        fi
    fi
fi

# Python
if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
    if command -v python3 &> /dev/null; then
        PYTHON_VER=$(python3 --version)
        echo -e "${GREEN}OK${NC}     $PYTHON_VER"
    elif command -v python &> /dev/null; then
        PYTHON_VER=$(python --version)
        echo -e "${GREEN}OK${NC}     $PYTHON_VER"
    else
        echo -e "${RED}MISSING${NC} Python (required for this project)"
        ERRORS=$((ERRORS + 1))
    fi

    # pip/poetry
    if [ -f "poetry.lock" ]; then
        if command -v poetry &> /dev/null; then
            POETRY_VER=$(poetry --version 2>/dev/null | cut -d' ' -f3)
            echo -e "${GREEN}OK${NC}     Poetry $POETRY_VER"
        else
            echo -e "${YELLOW}MISSING${NC} Poetry (project uses poetry.lock)"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi
fi

# Go
if [ -f "go.mod" ]; then
    if command -v go &> /dev/null; then
        GO_VER=$(go version | cut -d' ' -f3)
        echo -e "${GREEN}OK${NC}     $GO_VER"
    else
        echo -e "${RED}MISSING${NC} Go (required for this project)"
        ERRORS=$((ERRORS + 1))
    fi
fi

# Rust
if [ -f "Cargo.toml" ]; then
    if command -v cargo &> /dev/null; then
        RUST_VER=$(rustc --version | cut -d' ' -f2)
        echo -e "${GREEN}OK${NC}     Rust $RUST_VER"
    else
        echo -e "${RED}MISSING${NC} Rust (required for this project)"
        ERRORS=$((ERRORS + 1))
    fi
fi

# Docker
if [ -f "docker-compose.yml" ] || [ -f "Dockerfile" ]; then
    if command -v docker &> /dev/null; then
        DOCKER_VER=$(docker --version | cut -d' ' -f3 | tr -d ',')
        echo -e "${GREEN}OK${NC}     Docker $DOCKER_VER"
    else
        echo -e "${YELLOW}MISSING${NC} Docker (docker-compose.yml found)"
        WARNINGS=$((WARNINGS + 1))
    fi
fi

# Git
if command -v git &> /dev/null; then
    GIT_VER=$(git --version | cut -d' ' -f3)
    echo -e "${GREEN}OK${NC}     Git $GIT_VER"
else
    echo -e "${RED}MISSING${NC} Git"
    ERRORS=$((ERRORS + 1))
fi

# ============================================================================
# Verificar variables de entorno del proyecto
# ============================================================================

# Primero verificar .env.example si existe
if [ -f ".env.example" ]; then
    check_file_vars ".env.example"
    MISSING_FROM_EXAMPLE=$?
    if [ $MISSING_FROM_EXAMPLE -gt 0 ]; then
        WARNINGS=$((WARNINGS + MISSING_FROM_EXAMPLE))
    fi
fi

# ============================================================================
# Verificar variables de MCP servers
# ============================================================================

echo ""
echo "MCP Integration Variables:"
echo ""

# GitHub
check_var "GITHUB_TOKEN" "false" "true"

# Jira
check_var "JIRA_HOST" "false" "false"
check_var "JIRA_EMAIL" "false" "false"
check_var "JIRA_API_TOKEN" "false" "true"

# Slack
check_var "SLACK_BOT_TOKEN" "false" "true"

# Database
check_var "DATABASE_URL" "false" "true"

# Sentry
check_var "SENTRY_AUTH_TOKEN" "false" "true"
check_var "SENTRY_ORG" "false" "false"

# Linear
check_var "LINEAR_API_KEY" "false" "true"

# Notion
check_var "NOTION_API_KEY" "false" "true"

# Supabase
check_var "SUPABASE_URL" "false" "false"
check_var "SUPABASE_SERVICE_ROLE_KEY" "false" "true"

# ============================================================================
# Resumen
# ============================================================================

echo ""
echo "================="

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}$ERRORS errors, $WARNINGS warnings${NC}"
    echo ""
    echo "Some required tools or variables are missing."
    echo "Please install missing tools and set required variables."
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}$WARNINGS warnings${NC}"
    echo ""
    echo "Some optional variables are not set."
    echo "Set them if you need those integrations."
    exit 0
else
    echo -e "${GREEN}All checks passed!${NC}"
    exit 0
fi
