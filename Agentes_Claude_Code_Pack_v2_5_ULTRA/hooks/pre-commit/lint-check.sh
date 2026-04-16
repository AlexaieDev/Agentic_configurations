#!/bin/bash
# ============================================================================
# lint-check.sh - Verifica linting y formateo antes de commit
# ============================================================================
# Trigger: PreCommit
# Propósito: Asegurar que el código cumple con estándares de estilo
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
FIX_MODE="${FIX_MODE:-false}"  # Intentar auto-fix
STRICT_MODE="${STRICT_MODE:-false}"  # Fallar en warnings

echo -e "${CYAN}Lint & Format Check - Pre-Commit${NC}"
echo "================================="
echo ""

ERRORS=0
WARNINGS=0

# ============================================================================
# Obtener archivos staged
# ============================================================================

get_staged_files() {
    local extension=$1
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git diff --cached --name-only --diff-filter=ACMR | grep -E "\.$extension$" 2>/dev/null || echo ""
    else
        find . -type f -name "*.$extension" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null
    fi
}

# ============================================================================
# JavaScript / TypeScript
# ============================================================================

check_js_ts() {
    local js_files=$(get_staged_files "js")
    local ts_files=$(get_staged_files "ts")
    local tsx_files=$(get_staged_files "tsx")
    local jsx_files=$(get_staged_files "jsx")

    local all_files="$js_files $ts_files $tsx_files $jsx_files"
    all_files=$(echo "$all_files" | tr ' ' '\n' | grep -v '^$' | sort -u)

    if [ -z "$all_files" ]; then
        return 0
    fi

    echo "Checking JavaScript/TypeScript files..."

    # ESLint
    if [ -f "node_modules/.bin/eslint" ] || command -v eslint &> /dev/null; then
        local eslint_cmd="npx eslint"
        [ -f "node_modules/.bin/eslint" ] && eslint_cmd="node_modules/.bin/eslint"

        if [ "$FIX_MODE" = "true" ]; then
            eslint_cmd="$eslint_cmd --fix"
        fi

        local eslint_result
        eslint_result=$($eslint_cmd $all_files 2>&1) || true

        local error_count=$(echo "$eslint_result" | grep -c "error" || echo "0")
        local warning_count=$(echo "$eslint_result" | grep -c "warning" || echo "0")

        if [ "$error_count" -gt 0 ]; then
            echo -e "${RED}ESLint: $error_count errors${NC}"
            echo "$eslint_result" | head -20
            ERRORS=$((ERRORS + error_count))
        fi

        if [ "$warning_count" -gt 0 ]; then
            echo -e "${YELLOW}ESLint: $warning_count warnings${NC}"
            WARNINGS=$((WARNINGS + warning_count))
        fi

        if [ "$error_count" -eq 0 ] && [ "$warning_count" -eq 0 ]; then
            echo -e "${GREEN}ESLint: OK${NC}"
        fi
    else
        echo -e "${YELLOW}ESLint not found, skipping${NC}"
    fi

    # Prettier
    if [ -f "node_modules/.bin/prettier" ] || command -v prettier &> /dev/null; then
        local prettier_cmd="npx prettier"
        [ -f "node_modules/.bin/prettier" ] && prettier_cmd="node_modules/.bin/prettier"

        local check_flag="--check"
        [ "$FIX_MODE" = "true" ] && check_flag="--write"

        local prettier_result
        prettier_result=$($prettier_cmd $check_flag $all_files 2>&1) || true

        if echo "$prettier_result" | grep -q "Forgot to run Prettier"; then
            local unformatted=$(echo "$prettier_result" | grep -c "^\[" || echo "0")
            echo -e "${YELLOW}Prettier: $unformatted files need formatting${NC}"
            WARNINGS=$((WARNINGS + unformatted))
        elif echo "$prettier_result" | grep -q "error"; then
            echo -e "${RED}Prettier: Formatting errors${NC}"
            ERRORS=$((ERRORS + 1))
        else
            echo -e "${GREEN}Prettier: OK${NC}"
        fi
    fi

    # TypeScript check
    if [ -n "$ts_files$tsx_files" ] && [ -f "tsconfig.json" ]; then
        if [ -f "node_modules/.bin/tsc" ] || command -v tsc &> /dev/null; then
            local tsc_cmd="npx tsc"
            [ -f "node_modules/.bin/tsc" ] && tsc_cmd="node_modules/.bin/tsc"

            local tsc_result
            tsc_result=$($tsc_cmd --noEmit 2>&1) || true

            if echo "$tsc_result" | grep -q "error TS"; then
                local ts_errors=$(echo "$tsc_result" | grep -c "error TS" || echo "0")
                echo -e "${RED}TypeScript: $ts_errors type errors${NC}"
                echo "$tsc_result" | grep "error TS" | head -10
                ERRORS=$((ERRORS + ts_errors))
            else
                echo -e "${GREEN}TypeScript: OK${NC}"
            fi
        fi
    fi

    echo ""
}

# ============================================================================
# Python
# ============================================================================

check_python() {
    local py_files=$(get_staged_files "py")

    if [ -z "$py_files" ]; then
        return 0
    fi

    echo "Checking Python files..."

    # Ruff (fast Python linter)
    if command -v ruff &> /dev/null; then
        local ruff_cmd="ruff check"
        [ "$FIX_MODE" = "true" ] && ruff_cmd="ruff check --fix"

        local ruff_result
        ruff_result=$($ruff_cmd $py_files 2>&1) || true

        if echo "$ruff_result" | grep -qE "^Found [0-9]+ error"; then
            local ruff_errors=$(echo "$ruff_result" | grep -oE "Found [0-9]+ error" | grep -oE "[0-9]+" || echo "0")
            echo -e "${RED}Ruff: $ruff_errors errors${NC}"
            echo "$ruff_result" | head -15
            ERRORS=$((ERRORS + ruff_errors))
        else
            echo -e "${GREEN}Ruff: OK${NC}"
        fi
    # Fallback to flake8
    elif command -v flake8 &> /dev/null; then
        local flake8_result
        flake8_result=$(flake8 $py_files 2>&1) || true

        if [ -n "$flake8_result" ]; then
            local flake8_errors=$(echo "$flake8_result" | wc -l)
            echo -e "${RED}Flake8: $flake8_errors issues${NC}"
            echo "$flake8_result" | head -10
            ERRORS=$((ERRORS + flake8_errors))
        else
            echo -e "${GREEN}Flake8: OK${NC}"
        fi
    else
        echo -e "${YELLOW}No Python linter found (ruff or flake8)${NC}"
    fi

    # Black (formatter)
    if command -v black &> /dev/null; then
        local black_cmd="black --check"
        [ "$FIX_MODE" = "true" ] && black_cmd="black"

        local black_result
        black_result=$($black_cmd $py_files 2>&1) || true

        if echo "$black_result" | grep -q "would reformat"; then
            local black_files=$(echo "$black_result" | grep -c "would reformat" || echo "0")
            echo -e "${YELLOW}Black: $black_files files need formatting${NC}"
            WARNINGS=$((WARNINGS + black_files))
        elif echo "$black_result" | grep -q "error"; then
            echo -e "${RED}Black: Formatting errors${NC}"
            ERRORS=$((ERRORS + 1))
        else
            echo -e "${GREEN}Black: OK${NC}"
        fi
    fi

    # mypy (type checking)
    if command -v mypy &> /dev/null && [ -f "pyproject.toml" ]; then
        if grep -q "mypy" pyproject.toml 2>/dev/null; then
            local mypy_result
            mypy_result=$(mypy $py_files 2>&1) || true

            if echo "$mypy_result" | grep -q "error:"; then
                local mypy_errors=$(echo "$mypy_result" | grep -c "error:" || echo "0")
                echo -e "${RED}Mypy: $mypy_errors type errors${NC}"
                echo "$mypy_result" | grep "error:" | head -10
                ERRORS=$((ERRORS + mypy_errors))
            else
                echo -e "${GREEN}Mypy: OK${NC}"
            fi
        fi
    fi

    echo ""
}

# ============================================================================
# Go
# ============================================================================

check_go() {
    local go_files=$(get_staged_files "go")

    if [ -z "$go_files" ]; then
        return 0
    fi

    echo "Checking Go files..."

    # go fmt
    if command -v gofmt &> /dev/null; then
        local fmt_result
        fmt_result=$(gofmt -l $go_files 2>&1) || true

        if [ -n "$fmt_result" ]; then
            local unformatted=$(echo "$fmt_result" | wc -l)
            echo -e "${YELLOW}gofmt: $unformatted files need formatting${NC}"

            if [ "$FIX_MODE" = "true" ]; then
                gofmt -w $go_files
                echo "  (auto-fixed)"
            else
                WARNINGS=$((WARNINGS + unformatted))
            fi
        else
            echo -e "${GREEN}gofmt: OK${NC}"
        fi
    fi

    # go vet
    if command -v go &> /dev/null; then
        local vet_result
        vet_result=$(go vet ./... 2>&1) || true

        if [ -n "$vet_result" ]; then
            local vet_issues=$(echo "$vet_result" | wc -l)
            echo -e "${RED}go vet: $vet_issues issues${NC}"
            echo "$vet_result" | head -10
            ERRORS=$((ERRORS + vet_issues))
        else
            echo -e "${GREEN}go vet: OK${NC}"
        fi
    fi

    # golangci-lint
    if command -v golangci-lint &> /dev/null; then
        local lint_result
        lint_result=$(golangci-lint run --new-from-rev=HEAD~1 2>&1) || true

        if echo "$lint_result" | grep -q "issues"; then
            echo -e "${YELLOW}golangci-lint: Issues found${NC}"
            echo "$lint_result" | head -10
            WARNINGS=$((WARNINGS + 1))
        else
            echo -e "${GREEN}golangci-lint: OK${NC}"
        fi
    fi

    echo ""
}

# ============================================================================
# Rust
# ============================================================================

check_rust() {
    local rs_files=$(get_staged_files "rs")

    if [ -z "$rs_files" ]; then
        return 0
    fi

    echo "Checking Rust files..."

    # rustfmt
    if command -v rustfmt &> /dev/null; then
        local fmt_cmd="rustfmt --check"
        [ "$FIX_MODE" = "true" ] && fmt_cmd="rustfmt"

        local fmt_result
        fmt_result=$($fmt_cmd $rs_files 2>&1) || true

        if echo "$fmt_result" | grep -q "Diff"; then
            echo -e "${YELLOW}rustfmt: Files need formatting${NC}"
            WARNINGS=$((WARNINGS + 1))
        else
            echo -e "${GREEN}rustfmt: OK${NC}"
        fi
    fi

    # clippy
    if command -v cargo &> /dev/null && [ -f "Cargo.toml" ]; then
        local clippy_result
        clippy_result=$(cargo clippy -- -D warnings 2>&1) || true

        if echo "$clippy_result" | grep -q "error\["; then
            local clippy_errors=$(echo "$clippy_result" | grep -c "error\[" || echo "0")
            echo -e "${RED}Clippy: $clippy_errors errors${NC}"
            ERRORS=$((ERRORS + clippy_errors))
        elif echo "$clippy_result" | grep -q "warning:"; then
            local clippy_warnings=$(echo "$clippy_result" | grep -c "warning:" || echo "0")
            echo -e "${YELLOW}Clippy: $clippy_warnings warnings${NC}"
            WARNINGS=$((WARNINGS + clippy_warnings))
        else
            echo -e "${GREEN}Clippy: OK${NC}"
        fi
    fi

    echo ""
}

# ============================================================================
# Ejecutar checks según el proyecto
# ============================================================================

# JavaScript/TypeScript
if [ -f "package.json" ]; then
    check_js_ts
fi

# Python
if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
    check_python
fi

# Go
if [ -f "go.mod" ]; then
    check_go
fi

# Rust
if [ -f "Cargo.toml" ]; then
    check_rust
fi

# ============================================================================
# Resumen
# ============================================================================

echo "================================="
echo "Summary"
echo "================================="
echo ""

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}Errors:   $ERRORS${NC}"
fi

if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
fi

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}All checks passed!${NC}"
fi

echo ""

# Decisión final
if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}BLOCKED: Please fix lint errors before committing${NC}"
    exit 1
fi

if [ $WARNINGS -gt 0 ] && [ "$STRICT_MODE" = "true" ]; then
    echo -e "${RED}BLOCKED: Warnings not allowed in strict mode${NC}"
    exit 1
fi

exit 0
