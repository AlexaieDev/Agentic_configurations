#!/bin/bash
# ============================================================================
# security-scan.sh - Escanea por secrets y vulnerabilidades antes de commit
# ============================================================================
# Trigger: PreCommit
# Propósito: Prevenir que secrets y vulnerabilidades lleguen al repositorio
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
SCAN_LEVEL="${SCAN_LEVEL:-normal}"  # normal, strict, paranoid
FAIL_ON_WARNING="${FAIL_ON_WARNING:-false}"
DEBUG="${DEBUG:-false}"

# Contadores
CRITICAL=0
HIGH=0
MEDIUM=0
LOW=0

echo -e "${CYAN}Security Scan - Pre-Commit${NC}"
echo "=========================="
echo ""

# ============================================================================
# Patrones de secrets comunes
# ============================================================================

declare -A SECRET_PATTERNS=(
    # API Keys y Tokens
    ["AWS Access Key"]="AKIA[0-9A-Z]{16}"
    ["AWS Secret Key"]="['\"][0-9a-zA-Z/+]{40}['\"]"
    ["GitHub Token"]="gh[pousr]_[A-Za-z0-9_]{36,}"
    ["GitHub OAuth"]="gho_[A-Za-z0-9]{36}"
    ["GitLab Token"]="glpat-[A-Za-z0-9\-]{20}"
    ["Slack Token"]="xox[baprs]-[0-9]{10,13}-[0-9]{10,13}-[a-zA-Z0-9]{24}"
    ["Slack Webhook"]="https://hooks\.slack\.com/services/T[A-Z0-9]{8}/B[A-Z0-9]{8,12}/[a-zA-Z0-9]{24}"
    ["Discord Webhook"]="https://discord(app)?\.com/api/webhooks/[0-9]+/[A-Za-z0-9_-]+"
    ["Stripe Key"]="sk_live_[0-9a-zA-Z]{24}"
    ["Stripe Publishable"]="pk_live_[0-9a-zA-Z]{24}"
    ["Twilio SID"]="AC[a-z0-9]{32}"
    ["Twilio Auth"]="SK[a-z0-9]{32}"
    ["SendGrid Key"]="SG\.[a-zA-Z0-9]{22}\.[a-zA-Z0-9]{43}"
    ["Mailchimp Key"]="[0-9a-f]{32}-us[0-9]{1,2}"
    ["Google API Key"]="AIza[0-9A-Za-z\-_]{35}"
    ["Google OAuth"]="[0-9]+-[0-9A-Za-z_]{32}\.apps\.googleusercontent\.com"
    ["Firebase Key"]="AAAA[A-Za-z0-9_-]{7}:[A-Za-z0-9_-]{140}"
    ["Heroku API Key"]="[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
    ["NPM Token"]="npm_[A-Za-z0-9]{36}"
    ["PyPI Token"]="pypi-AgEIcHlwaS5vcmc[A-Za-z0-9_-]{50,}"
    ["Supabase Key"]="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+"

    # Private Keys
    ["RSA Private Key"]="-----BEGIN RSA PRIVATE KEY-----"
    ["DSA Private Key"]="-----BEGIN DSA PRIVATE KEY-----"
    ["EC Private Key"]="-----BEGIN EC PRIVATE KEY-----"
    ["OpenSSH Private Key"]="-----BEGIN OPENSSH PRIVATE KEY-----"
    ["PGP Private Key"]="-----BEGIN PGP PRIVATE KEY BLOCK-----"

    # Database URLs
    ["Database URL"]="(postgres|mysql|mongodb|redis)://[^:]+:[^@]+@"

    # Generic patterns
    ["Generic Secret"]="(password|secret|token|apikey|api_key|auth)['\"]\s*[:=]\s*['\"][^'\"]{8,}['\"]"
    ["Generic Bearer"]="Bearer [A-Za-z0-9\-_\.]{20,}"
)

# ============================================================================
# Archivos a escanear
# ============================================================================

get_staged_files() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # En un repo git, solo archivos staged
        git diff --cached --name-only --diff-filter=ACMR 2>/dev/null || echo ""
    else
        # No es repo git, escanear todo
        find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.rb" -o -name "*.java" -o -name "*.env*" -o -name "*.json" -o -name "*.yml" -o -name "*.yaml" -o -name "*.toml" -o -name "*.xml" -o -name "*.config" \) 2>/dev/null
    fi
}

# ============================================================================
# Escaneo de secrets
# ============================================================================

scan_secrets() {
    echo "Scanning for secrets..."
    echo ""

    local files=$(get_staged_files)

    if [ -z "$files" ]; then
        echo -e "${GREEN}No files to scan${NC}"
        return 0
    fi

    local found_secrets=0

    for pattern_name in "${!SECRET_PATTERNS[@]}"; do
        local pattern="${SECRET_PATTERNS[$pattern_name]}"

        while IFS= read -r file; do
            [ -z "$file" ] && continue
            [ ! -f "$file" ] && continue

            # Ignorar archivos binarios y node_modules
            [[ "$file" == *"node_modules"* ]] && continue
            [[ "$file" == *".git"* ]] && continue
            [[ "$file" == *"vendor"* ]] && continue
            [[ "$file" == *".min.js" ]] && continue
            [[ "$file" == *".min.css" ]] && continue

            # Verificar si es binario
            if file "$file" | grep -q "binary"; then
                continue
            fi

            # Buscar patrón
            local matches=$(grep -nE "$pattern" "$file" 2>/dev/null || true)

            if [ -n "$matches" ]; then
                while IFS= read -r match; do
                    [ -z "$match" ] && continue
                    local line_num=$(echo "$match" | cut -d: -f1)

                    # Verificar si es un falso positivo (ejemplo, placeholder)
                    if echo "$match" | grep -qiE "(example|sample|placeholder|xxx|your-|<.*>|\$\{)"; then
                        [ "$DEBUG" = "true" ] && echo "Skipping false positive in $file:$line_num"
                        continue
                    fi

                    echo -e "${RED}CRITICAL${NC} $pattern_name found"
                    echo "  File: $file:$line_num"

                    # Mostrar línea con secret ofuscado
                    local line_content=$(echo "$match" | cut -d: -f2-)
                    local masked=$(echo "$line_content" | sed 's/[A-Za-z0-9]\{4,\}/****/g' | head -c 80)
                    echo "  Line: $masked..."
                    echo ""

                    CRITICAL=$((CRITICAL + 1))
                    found_secrets=$((found_secrets + 1))
                done <<< "$matches"
            fi
        done <<< "$files"
    done

    return $found_secrets
}

# ============================================================================
# Escaneo de archivos peligrosos
# ============================================================================

scan_dangerous_files() {
    echo "Scanning for dangerous files..."
    echo ""

    local files=$(get_staged_files)
    local found=0

    # Archivos que nunca deberían estar en el repo
    DANGEROUS_FILES=(
        ".env"
        ".env.local"
        ".env.production"
        ".env.development.local"
        "id_rsa"
        "id_dsa"
        "id_ecdsa"
        "id_ed25519"
        "*.pem"
        "*.key"
        "*.p12"
        "*.pfx"
        "credentials.json"
        "service-account.json"
        "firebase-adminsdk*.json"
        ".htpasswd"
        "wp-config.php"
        "database.yml"
        "secrets.yml"
        "secrets.json"
        "*.sqlite"
        "*.sqlite3"
    )

    while IFS= read -r file; do
        [ -z "$file" ] && continue

        local basename=$(basename "$file")

        for pattern in "${DANGEROUS_FILES[@]}"; do
            if [[ "$basename" == $pattern ]] || [[ "$file" == *"$pattern"* ]]; then
                # Verificar si está en .gitignore
                if git check-ignore -q "$file" 2>/dev/null; then
                    continue
                fi

                echo -e "${RED}CRITICAL${NC} Dangerous file staged: $file"
                echo "  This file should not be committed to the repository."
                echo ""
                CRITICAL=$((CRITICAL + 1))
                found=$((found + 1))
            fi
        done
    done <<< "$files"

    return $found
}

# ============================================================================
# Escaneo de vulnerabilidades en dependencias
# ============================================================================

scan_dependencies() {
    echo "Scanning dependencies for vulnerabilities..."
    echo ""

    # npm audit
    if [ -f "package-lock.json" ] && command -v npm &> /dev/null; then
        echo "Running npm audit..."
        local audit_result=$(npm audit --json 2>/dev/null || true)

        if [ -n "$audit_result" ]; then
            local critical=$(echo "$audit_result" | jq -r '.metadata.vulnerabilities.critical // 0' 2>/dev/null || echo "0")
            local high=$(echo "$audit_result" | jq -r '.metadata.vulnerabilities.high // 0' 2>/dev/null || echo "0")
            local moderate=$(echo "$audit_result" | jq -r '.metadata.vulnerabilities.moderate // 0' 2>/dev/null || echo "0")

            if [ "$critical" -gt 0 ]; then
                echo -e "${RED}CRITICAL${NC} $critical critical vulnerabilities in npm packages"
                CRITICAL=$((CRITICAL + critical))
            fi
            if [ "$high" -gt 0 ]; then
                echo -e "${RED}HIGH${NC}     $high high vulnerabilities in npm packages"
                HIGH=$((HIGH + high))
            fi
            if [ "$moderate" -gt 0 ]; then
                echo -e "${YELLOW}MEDIUM${NC}   $moderate moderate vulnerabilities in npm packages"
                MEDIUM=$((MEDIUM + moderate))
            fi
        fi
        echo ""
    fi

    # pip audit (si está disponible)
    if [ -f "requirements.txt" ] && command -v pip-audit &> /dev/null; then
        echo "Running pip-audit..."
        local pip_result=$(pip-audit --format json 2>/dev/null || true)

        if [ -n "$pip_result" ]; then
            local vuln_count=$(echo "$pip_result" | jq 'length' 2>/dev/null || echo "0")
            if [ "$vuln_count" -gt 0 ]; then
                echo -e "${RED}HIGH${NC}     $vuln_count vulnerabilities in Python packages"
                HIGH=$((HIGH + vuln_count))
            fi
        fi
        echo ""
    fi

    # cargo audit (si está disponible)
    if [ -f "Cargo.lock" ] && command -v cargo-audit &> /dev/null; then
        echo "Running cargo audit..."
        if ! cargo audit --quiet 2>/dev/null; then
            echo -e "${RED}HIGH${NC}     Vulnerabilities found in Rust dependencies"
            HIGH=$((HIGH + 1))
        fi
        echo ""
    fi
}

# ============================================================================
# Ejecutar escaneos
# ============================================================================

echo -e "${CYAN}Scan Level:${NC} $SCAN_LEVEL"
echo ""

scan_secrets
secrets_found=$?

scan_dangerous_files
dangerous_found=$?

if [ "$SCAN_LEVEL" != "quick" ]; then
    scan_dependencies
fi

# ============================================================================
# Resumen y decisión
# ============================================================================

echo "=========================="
echo "Scan Summary"
echo "=========================="
echo ""

TOTAL=$((CRITICAL + HIGH + MEDIUM + LOW))

if [ $CRITICAL -gt 0 ]; then
    echo -e "${RED}CRITICAL: $CRITICAL${NC}"
fi
if [ $HIGH -gt 0 ]; then
    echo -e "${RED}HIGH:     $HIGH${NC}"
fi
if [ $MEDIUM -gt 0 ]; then
    echo -e "${YELLOW}MEDIUM:   $MEDIUM${NC}"
fi
if [ $LOW -gt 0 ]; then
    echo "LOW:      $LOW"
fi

echo ""

if [ $CRITICAL -gt 0 ]; then
    echo -e "${RED}BLOCKED: Critical security issues found${NC}"
    echo ""
    echo "Please fix the issues above before committing."
    echo "If these are false positives, add them to .gitignore or use:"
    echo "  git commit --no-verify  (not recommended)"
    exit 1
fi

if [ $HIGH -gt 0 ]; then
    if [ "$SCAN_LEVEL" = "strict" ] || [ "$SCAN_LEVEL" = "paranoid" ]; then
        echo -e "${RED}BLOCKED: High severity issues found (strict mode)${NC}"
        exit 1
    else
        echo -e "${YELLOW}WARNING: High severity issues found${NC}"
        echo "Consider fixing before committing."

        if [ "$FAIL_ON_WARNING" = "true" ]; then
            exit 1
        fi
    fi
fi

if [ $MEDIUM -gt 0 ] && [ "$SCAN_LEVEL" = "paranoid" ]; then
    echo -e "${RED}BLOCKED: Medium severity issues found (paranoid mode)${NC}"
    exit 1
fi

if [ $TOTAL -eq 0 ]; then
    echo -e "${GREEN}No security issues found${NC}"
fi

exit 0
