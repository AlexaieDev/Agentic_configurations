#!/bin/bash
# ============================================================================
# load-context.sh - Carga contexto del proyecto al iniciar sesión de Claude
# ============================================================================
# Trigger: SessionStart
# Propósito: Detectar tipo de proyecto y cargar información relevante
# ============================================================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables de entorno de Claude
PROJECT_PATH="${CLAUDE_PROJECT_PATH:-.}"
SESSION_ID="${CLAUDE_SESSION_ID:-local}"

# Cambiar al directorio del proyecto
cd "$PROJECT_PATH"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  Claude Code - Context Loader${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# ============================================================================
# Detección de tipo de proyecto
# ============================================================================

PROJECT_TYPE="unknown"
FRAMEWORK=""
LANGUAGE=""

detect_project_type() {
    # Node.js / JavaScript / TypeScript
    if [ -f "package.json" ]; then
        LANGUAGE="JavaScript/TypeScript"

        # Detectar framework
        if grep -q '"next"' package.json 2>/dev/null; then
            FRAMEWORK="Next.js"
            PROJECT_TYPE="nextjs"
        elif grep -q '"react"' package.json 2>/dev/null; then
            FRAMEWORK="React"
            PROJECT_TYPE="react"
        elif grep -q '"vue"' package.json 2>/dev/null; then
            FRAMEWORK="Vue.js"
            PROJECT_TYPE="vue"
        elif grep -q '"express"' package.json 2>/dev/null; then
            FRAMEWORK="Express"
            PROJECT_TYPE="node-api"
        elif grep -q '"fastify"' package.json 2>/dev/null; then
            FRAMEWORK="Fastify"
            PROJECT_TYPE="node-api"
        elif grep -q '"@nestjs"' package.json 2>/dev/null; then
            FRAMEWORK="NestJS"
            PROJECT_TYPE="nestjs"
        else
            FRAMEWORK="Node.js"
            PROJECT_TYPE="node"
        fi
    fi

    # Python
    if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        LANGUAGE="Python"

        if [ -f "pyproject.toml" ]; then
            if grep -q 'fastapi' pyproject.toml 2>/dev/null; then
                FRAMEWORK="FastAPI"
                PROJECT_TYPE="fastapi"
            elif grep -q 'django' pyproject.toml 2>/dev/null; then
                FRAMEWORK="Django"
                PROJECT_TYPE="django"
            elif grep -q 'flask' pyproject.toml 2>/dev/null; then
                FRAMEWORK="Flask"
                PROJECT_TYPE="flask"
            fi
        elif [ -f "requirements.txt" ]; then
            if grep -qi 'fastapi' requirements.txt 2>/dev/null; then
                FRAMEWORK="FastAPI"
                PROJECT_TYPE="fastapi"
            elif grep -qi 'django' requirements.txt 2>/dev/null; then
                FRAMEWORK="Django"
                PROJECT_TYPE="django"
            elif grep -qi 'flask' requirements.txt 2>/dev/null; then
                FRAMEWORK="Flask"
                PROJECT_TYPE="flask"
            fi
        fi

        [ -z "$FRAMEWORK" ] && FRAMEWORK="Python" && PROJECT_TYPE="python"
    fi

    # Go
    if [ -f "go.mod" ]; then
        LANGUAGE="Go"
        FRAMEWORK="Go"
        PROJECT_TYPE="go"
    fi

    # Rust
    if [ -f "Cargo.toml" ]; then
        LANGUAGE="Rust"
        FRAMEWORK="Rust"
        PROJECT_TYPE="rust"
    fi

    # Java
    if [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        LANGUAGE="Java"
        if [ -f "pom.xml" ]; then
            if grep -q 'spring-boot' pom.xml 2>/dev/null; then
                FRAMEWORK="Spring Boot"
                PROJECT_TYPE="spring"
            fi
        fi
        [ -z "$FRAMEWORK" ] && FRAMEWORK="Java" && PROJECT_TYPE="java"
    fi

    # Ruby
    if [ -f "Gemfile" ]; then
        LANGUAGE="Ruby"
        if grep -q 'rails' Gemfile 2>/dev/null; then
            FRAMEWORK="Rails"
            PROJECT_TYPE="rails"
        else
            FRAMEWORK="Ruby"
            PROJECT_TYPE="ruby"
        fi
    fi
}

detect_project_type

# ============================================================================
# Mostrar información del proyecto
# ============================================================================

echo ""
echo -e "${BLUE}Project Type:${NC} $FRAMEWORK ($LANGUAGE)"

# Información de dependencias
if [ -f "package.json" ]; then
    DEP_COUNT=$(jq -r '.dependencies // {} | keys | length' package.json 2>/dev/null || echo "0")
    DEV_DEP_COUNT=$(jq -r '.devDependencies // {} | keys | length' package.json 2>/dev/null || echo "0")
    echo -e "${BLUE}Dependencies:${NC} $DEP_COUNT prod, $DEV_DEP_COUNT dev"

    # Node version si existe
    if [ -f ".nvmrc" ]; then
        NODE_VER=$(cat .nvmrc)
        echo -e "${BLUE}Node Version:${NC} $NODE_VER"
    elif [ -f ".node-version" ]; then
        NODE_VER=$(cat .node-version)
        echo -e "${BLUE}Node Version:${NC} $NODE_VER"
    fi
fi

if [ -f "requirements.txt" ]; then
    DEP_COUNT=$(wc -l < requirements.txt | tr -d ' ')
    echo -e "${BLUE}Dependencies:${NC} $DEP_COUNT packages"
fi

if [ -f "pyproject.toml" ]; then
    PYTHON_VER=$(grep -oP 'python\s*=\s*"\K[^"]+' pyproject.toml 2>/dev/null || echo "not specified")
    echo -e "${BLUE}Python:${NC} $PYTHON_VER"
fi

# ============================================================================
# Información de Git
# ============================================================================

if [ -d ".git" ]; then
    echo ""
    BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
    CHANGES=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    LAST_COMMIT=$(git log -1 --format="%h %s" 2>/dev/null | head -c 60)
    REMOTE=$(git remote get-url origin 2>/dev/null | sed 's/.*github.com[:/]\(.*\)\.git/\1/' || echo "no remote")

    echo -e "${GREEN}Branch:${NC} $BRANCH"
    echo -e "${GREEN}Changes:${NC} $CHANGES files modified"
    echo -e "${GREEN}Last Commit:${NC} $LAST_COMMIT"
    echo -e "${GREEN}Repository:${NC} $REMOTE"

    # Verificar si hay PRs abiertos (si gh está disponible)
    if command -v gh &> /dev/null; then
        PR_COUNT=$(gh pr list --state open 2>/dev/null | wc -l | tr -d ' ' || echo "0")
        if [ "$PR_COUNT" -gt 0 ]; then
            echo -e "${GREEN}Open PRs:${NC} $PR_COUNT"
        fi
    fi
fi

# ============================================================================
# Archivos de configuración detectados
# ============================================================================

echo ""
echo -e "${YELLOW}Configuration Files:${NC}"

CONFIG_FILES=()

[ -f ".env" ] && CONFIG_FILES+=(".env")
[ -f ".env.local" ] && CONFIG_FILES+=(".env.local")
[ -f ".env.example" ] && CONFIG_FILES+=(".env.example")
[ -f "docker-compose.yml" ] && CONFIG_FILES+=("docker-compose.yml")
[ -f "Dockerfile" ] && CONFIG_FILES+=("Dockerfile")
[ -f ".github/workflows" ] && CONFIG_FILES+=(".github/workflows/")
[ -f "CLAUDE.md" ] && CONFIG_FILES+=("CLAUDE.md")
[ -d ".claude" ] && CONFIG_FILES+=(".claude/")
[ -f "tsconfig.json" ] && CONFIG_FILES+=("tsconfig.json")
[ -f "eslint.config.js" ] || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] && CONFIG_FILES+=("eslint")
[ -f "prettier.config.js" ] || [ -f ".prettierrc" ] && CONFIG_FILES+=("prettier")
[ -f "jest.config.js" ] || [ -f "jest.config.ts" ] && CONFIG_FILES+=("jest")
[ -f "vitest.config.ts" ] && CONFIG_FILES+=("vitest")
[ -f "playwright.config.ts" ] && CONFIG_FILES+=("playwright")

if [ ${#CONFIG_FILES[@]} -gt 0 ]; then
    echo "  ${CONFIG_FILES[*]}"
else
    echo "  None detected"
fi

# ============================================================================
# Sugerencias de agentes
# ============================================================================

echo ""
echo -e "${CYAN}Suggested Agents:${NC}"

case $PROJECT_TYPE in
    nextjs|react|vue)
        echo "  - React/Vue/Next.js Agent (stack-specific)"
        echo "  - Frontend Performance Agent"
        echo "  - Accessibility Agent"
        ;;
    node-api|nestjs|fastapi|django|flask)
        echo "  - API Design Agent"
        echo "  - Database Architect Agent"
        echo "  - Security Agent"
        ;;
    go|rust)
        echo "  - Go/Rust Agent (stack-specific)"
        echo "  - Performance & Efficiency Agent"
        echo "  - Systems Agent"
        ;;
    *)
        echo "  - Code Review Agent"
        echo "  - Bug Hunter Agent"
        ;;
esac

# Siempre útiles
echo "  - Code Quality Agent"
echo "  - Test Architect Agent"

# ============================================================================
# Verificación de estado
# ============================================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Advertencias
WARNINGS=0

if [ ! -f ".env" ] && [ -f ".env.example" ]; then
    echo -e "${YELLOW}Warning:${NC} .env.example exists but .env not found"
    WARNINGS=$((WARNINGS + 1))
fi

if [ -d ".git" ] && [ "$CHANGES" -gt 10 ]; then
    echo -e "${YELLOW}Warning:${NC} $CHANGES uncommitted changes"
    WARNINGS=$((WARNINGS + 1))
fi

if [ "$WARNINGS" -eq 0 ]; then
    echo -e "${GREEN}Ready to work!${NC}"
fi

echo ""

exit 0
