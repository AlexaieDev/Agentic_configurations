#!/bin/bash
# ============================================================================
# validate-branch.sh - Valida branch antes de push
# ============================================================================
# Trigger: PrePush
# Propósito: Asegurar que el código está listo para push
# ============================================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_PATH="${CLAUDE_PROJECT_PATH:-.}"
cd "$PROJECT_PATH"

# Configuración
REQUIRE_TESTS="${REQUIRE_TESTS:-true}"
REQUIRE_BUILD="${REQUIRE_BUILD:-false}"
PROTECTED_BRANCHES="${PROTECTED_BRANCHES:-main,master,production}"
REQUIRE_LINEAR_HISTORY="${REQUIRE_LINEAR_HISTORY:-false}"
MAX_COMMITS="${MAX_COMMITS:-50}"

echo -e "${CYAN}Pre-Push Validation${NC}"
echo "===================="
echo ""

ERRORS=0
WARNINGS=0

# ============================================================================
# Verificar que estamos en un repo git
# ============================================================================

if [ ! -d ".git" ]; then
    echo -e "${RED}ERROR: Not a git repository${NC}"
    exit 1
fi

CURRENT_BRANCH=$(git branch --show-current)
REMOTE=$(git remote | head -1)
REMOTE_BRANCH="${REMOTE}/${CURRENT_BRANCH}"

echo -e "${CYAN}Branch:${NC} $CURRENT_BRANCH"
echo -e "${CYAN}Remote:${NC} $REMOTE"
echo ""

# ============================================================================
# Verificar branch protegido
# ============================================================================

check_protected_branch() {
    echo "Checking branch protection..."

    IFS=',' read -ra PROTECTED <<< "$PROTECTED_BRANCHES"
    for protected in "${PROTECTED[@]}"; do
        if [ "$CURRENT_BRANCH" = "$protected" ]; then
            echo -e "${YELLOW}WARNING: Pushing directly to protected branch '$protected'${NC}"
            echo "  Consider using a feature branch and pull request."
            WARNINGS=$((WARNINGS + 1))

            # En modo estricto, bloquear push a protected
            if [ "${STRICT_PROTECTED:-false}" = "true" ]; then
                echo -e "${RED}ERROR: Direct push to '$protected' is not allowed${NC}"
                ERRORS=$((ERRORS + 1))
            fi
        fi
    done

    echo ""
}

# ============================================================================
# Verificar commits pendientes
# ============================================================================

check_commits() {
    echo "Checking commits to push..."

    # Obtener commits que se van a pushear
    if git rev-parse "$REMOTE_BRANCH" > /dev/null 2>&1; then
        local commit_count=$(git rev-list --count "$REMOTE_BRANCH..HEAD" 2>/dev/null || echo "0")
        local commits=$(git log --oneline "$REMOTE_BRANCH..HEAD" 2>/dev/null || echo "")

        if [ "$commit_count" -eq 0 ]; then
            echo -e "${YELLOW}No new commits to push${NC}"
            echo ""
            return 0
        fi

        echo "  $commit_count commit(s) to push:"
        echo "$commits" | head -10 | sed 's/^/    /'

        if [ "$commit_count" -gt 10 ]; then
            echo "    ... and $((commit_count - 10)) more"
        fi

        if [ "$commit_count" -gt "$MAX_COMMITS" ]; then
            echo -e "${YELLOW}WARNING: Pushing $commit_count commits at once${NC}"
            echo "  Consider breaking into smaller pushes."
            WARNINGS=$((WARNINGS + 1))
        fi
    else
        echo "  New branch, all local commits will be pushed"
    fi

    echo ""
}

# ============================================================================
# Verificar merge conflicts pendientes
# ============================================================================

check_merge_status() {
    echo "Checking for merge conflicts..."

    # Verificar si hay conflictos sin resolver
    if [ -f ".git/MERGE_HEAD" ]; then
        echo -e "${RED}ERROR: Merge in progress, resolve conflicts first${NC}"
        ERRORS=$((ERRORS + 1))
        return 1
    fi

    # Verificar archivos con conflictos
    local conflict_files=$(git diff --name-only --diff-filter=U 2>/dev/null || echo "")
    if [ -n "$conflict_files" ]; then
        echo -e "${RED}ERROR: Unresolved merge conflicts in:${NC}"
        echo "$conflict_files" | sed 's/^/    /'
        ERRORS=$((ERRORS + 1))
        return 1
    fi

    echo -e "${GREEN}No merge conflicts${NC}"
    echo ""
}

# ============================================================================
# Verificar cambios no commiteados
# ============================================================================

check_uncommitted() {
    echo "Checking for uncommitted changes..."

    local staged=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
    local unstaged=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
    local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

    if [ "$staged" -gt 0 ]; then
        echo -e "${YELLOW}WARNING: $staged staged but uncommitted file(s)${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi

    if [ "$unstaged" -gt 0 ]; then
        echo -e "${YELLOW}WARNING: $unstaged unstaged modification(s)${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi

    if [ "$untracked" -gt 0 ]; then
        echo "  $untracked untracked file(s)"
    fi

    if [ "$staged" -eq 0 ] && [ "$unstaged" -eq 0 ]; then
        echo -e "${GREEN}Working tree clean${NC}"
    fi

    echo ""
}

# ============================================================================
# Verificar que la branch está actualizada
# ============================================================================

check_branch_sync() {
    echo "Checking branch synchronization..."

    # Fetch latest from remote
    git fetch "$REMOTE" --quiet 2>/dev/null || true

    if git rev-parse "$REMOTE_BRANCH" > /dev/null 2>&1; then
        local behind=$(git rev-list --count "HEAD..$REMOTE_BRANCH" 2>/dev/null || echo "0")
        local ahead=$(git rev-list --count "$REMOTE_BRANCH..HEAD" 2>/dev/null || echo "0")

        if [ "$behind" -gt 0 ]; then
            echo -e "${YELLOW}WARNING: Branch is $behind commit(s) behind $REMOTE_BRANCH${NC}"
            echo "  Consider pulling before pushing."
            WARNINGS=$((WARNINGS + 1))
        fi

        echo "  Local is $ahead ahead, $behind behind remote"
    else
        echo "  New branch, will be created on remote"
    fi

    echo ""
}

# ============================================================================
# Ejecutar tests si están configurados
# ============================================================================

run_tests() {
    if [ "$REQUIRE_TESTS" != "true" ]; then
        return 0
    fi

    echo "Running tests..."

    local test_cmd=""
    local test_result=0

    # Detectar comando de test
    if [ -f "package.json" ]; then
        if grep -q '"test"' package.json; then
            test_cmd="npm test"
        fi
    elif [ -f "pyproject.toml" ]; then
        if grep -q 'pytest' pyproject.toml 2>/dev/null; then
            test_cmd="pytest"
        elif [ -f "Makefile" ] && grep -q 'test:' Makefile; then
            test_cmd="make test"
        fi
    elif [ -f "go.mod" ]; then
        test_cmd="go test ./..."
    elif [ -f "Cargo.toml" ]; then
        test_cmd="cargo test"
    elif [ -f "Makefile" ] && grep -q 'test:' Makefile; then
        test_cmd="make test"
    fi

    if [ -z "$test_cmd" ]; then
        echo "  No test command detected, skipping"
        echo ""
        return 0
    fi

    echo "  Running: $test_cmd"

    # Ejecutar tests
    if $test_cmd > /tmp/test-output.txt 2>&1; then
        echo -e "${GREEN}Tests passed${NC}"
    else
        echo -e "${RED}Tests failed${NC}"
        echo "  Output:"
        tail -20 /tmp/test-output.txt | sed 's/^/    /'
        ERRORS=$((ERRORS + 1))
    fi

    echo ""
}

# ============================================================================
# Verificar build si está configurado
# ============================================================================

run_build() {
    if [ "$REQUIRE_BUILD" != "true" ]; then
        return 0
    fi

    echo "Running build..."

    local build_cmd=""

    # Detectar comando de build
    if [ -f "package.json" ]; then
        if grep -q '"build"' package.json; then
            build_cmd="npm run build"
        fi
    elif [ -f "pyproject.toml" ]; then
        if grep -q 'build-system' pyproject.toml 2>/dev/null; then
            build_cmd="python -m build"
        fi
    elif [ -f "go.mod" ]; then
        build_cmd="go build ./..."
    elif [ -f "Cargo.toml" ]; then
        build_cmd="cargo build --release"
    elif [ -f "Makefile" ] && grep -q 'build:' Makefile; then
        build_cmd="make build"
    fi

    if [ -z "$build_cmd" ]; then
        echo "  No build command detected, skipping"
        echo ""
        return 0
    fi

    echo "  Running: $build_cmd"

    if $build_cmd > /tmp/build-output.txt 2>&1; then
        echo -e "${GREEN}Build succeeded${NC}"
    else
        echo -e "${RED}Build failed${NC}"
        tail -20 /tmp/build-output.txt | sed 's/^/    /'
        ERRORS=$((ERRORS + 1))
    fi

    echo ""
}

# ============================================================================
# Verificar mensaje de commits
# ============================================================================

check_commit_messages() {
    echo "Checking commit messages..."

    if ! git rev-parse "$REMOTE_BRANCH" > /dev/null 2>&1; then
        echo "  New branch, skipping commit message check"
        echo ""
        return 0
    fi

    local bad_commits=0

    while IFS= read -r commit_msg; do
        [ -z "$commit_msg" ] && continue

        # Verificar longitud mínima
        if [ ${#commit_msg} -lt 10 ]; then
            echo -e "${YELLOW}WARNING: Short commit message: '$commit_msg'${NC}"
            bad_commits=$((bad_commits + 1))
        fi

        # Verificar commits tipo "fix" sin contexto
        if echo "$commit_msg" | grep -qE "^(fix|wip|temp|test)$"; then
            echo -e "${YELLOW}WARNING: Vague commit message: '$commit_msg'${NC}"
            bad_commits=$((bad_commits + 1))
        fi
    done < <(git log --format="%s" "$REMOTE_BRANCH..HEAD" 2>/dev/null)

    if [ "$bad_commits" -gt 0 ]; then
        echo "  Consider improving commit messages before pushing."
        WARNINGS=$((WARNINGS + bad_commits))
    else
        echo -e "${GREEN}Commit messages look good${NC}"
    fi

    echo ""
}

# ============================================================================
# Ejecutar validaciones
# ============================================================================

check_protected_branch
check_commits
check_merge_status
check_uncommitted
check_branch_sync
check_commit_messages

# Tests y build opcionales
if [ "$REQUIRE_TESTS" = "true" ]; then
    run_tests
fi

if [ "$REQUIRE_BUILD" = "true" ]; then
    run_build
fi

# ============================================================================
# Resumen
# ============================================================================

echo "===================="
echo "Validation Summary"
echo "===================="
echo ""

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}Errors:   $ERRORS${NC}"
fi

if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
fi

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}All validations passed!${NC}"
fi

echo ""

# Decisión final
if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}BLOCKED: Please fix errors before pushing${NC}"
    echo ""
    echo "To push anyway (not recommended):"
    echo "  git push --no-verify"
    exit 1
fi

if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}Proceeding with warnings...${NC}"
fi

echo -e "${GREEN}Ready to push!${NC}"
exit 0
