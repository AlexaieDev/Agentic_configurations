# Best Practices Guide

Guidelines for getting the most out of the Agent Catalog.

---

## Agent Usage

### 1. Be Specific About Which Agent to Use

```markdown
# Instead of:
"Review this code"

# Say:
"Using the Security Agent, review this code for vulnerabilities"
```

This ensures Claude adopts the right persona and checklist.

---

### 2. Use One Agent at a Time

Multiple agents in CLAUDE.md can cause confusion. Either:

- Use a single agent for focused work
- Use a pre-built crew for multi-agent tasks
- Sequence agents explicitly in your prompts

```markdown
# Good: Single agent
cp agents/security/threat-modeling.md CLAUDE.md

# Good: Using crew
cp crews/security-audit-crew.md CLAUDE.md

# Avoid: Multiple uncoordinated agents
cat agents/security/*.md >> CLAUDE.md  # Don't do this
```

---

### 3. Match Agent to Task Phase

| Phase | Agent Type |
|-------|------------|
| Planning | Architecture, API Design |
| Coding | Stack-specific (React, Python, etc.) |
| Testing | Test Architect |
| Review | Code Review, Security |
| Deploy | Release Manager, SRE |

---

### 4. Combine Agents Strategically

For complex tasks, use agents in sequence:

```markdown
1. "Using API Design Agent, design the endpoint"
2. "Using Python Agent, implement the handler"
3. "Using Test Architect, write tests"
4. "Using Code Review Agent, review everything"
```

---

## MCP Integrations

### 1. Minimal Permissions

Only enable scopes you actually need:

```bash
# GitHub: Only request needed scopes
# - repo (if you need private repos)
# - read:org (if you need org access)
# - Don't add admin scopes unless necessary
```

---

### 2. Use Read-Only When Possible

```sql
-- For database MCP, create read-only user
CREATE USER claude_reader WITH PASSWORD 'xxx';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO claude_reader;
```

---

### 3. Rotate Credentials Regularly

```bash
# Set expiration on tokens
# GitHub: 90 days max
# Regenerate and update in env

export GITHUB_TOKEN="new_token_here"
```

---

### 4. Don't Commit Secrets

```bash
# Add to .gitignore
.env
.env.local
*.pem
*.key

# Use environment variables
export GITHUB_TOKEN="xxx"
```

---

## Hooks

### 1. Keep Hooks Fast

Hooks run on every operation. Slow hooks = slow development.

```bash
# Good: Only lint changed files
FILES=$(git diff --cached --name-only --diff-filter=ACMR)
eslint $FILES

# Avoid: Lint entire codebase
eslint .  # Slow!
```

---

### 2. Make Hooks Non-Blocking When Appropriate

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "command": "./hooks/log-actions.sh",
        "blocking": false  // Don't wait for this
      }
    ]
  }
}
```

---

### 3. Provide Clear Error Messages

```bash
#!/bin/bash
if [ $ERRORS -gt 0 ]; then
    echo "BLOCKED: Found $ERRORS security issues"
    echo ""
    echo "To fix:"
    echo "  1. Review the issues above"
    echo "  2. Fix or add to allowlist"
    echo ""
    exit 1
fi
```

---

### 4. Allow Escape Hatches

Document how to bypass hooks for emergencies:

```bash
# In hook documentation:
# To skip: git commit --no-verify
# Only use in emergencies!
```

---

## Commands

### 1. Use Arguments for Flexibility

```yaml
---
name: security-review
args:
  - name: scope
    default: "all"
  - name: severity
    default: "medium"
---
```

Usage:
```
/security-review scope=auth severity=high
```

---

### 2. Reference Existing Agents

Commands should use agents from the catalog:

```yaml
agents:
  - Threat Modeling Agent      # Real agent name
  - Vulnerability Management Agent
```

---

### 3. Define Clear Output

Tell users what to expect:

```markdown
## Output

- Severity rating (A-F)
- List of findings with:
  - ID, severity, description
  - Remediation steps
  - References
```

---

## Project Configuration

### 1. Keep CLAUDE.md Focused

```markdown
# Good: Focused on project specifics
## Project Overview
This is a Next.js SaaS with Supabase...

## Key Commands
npm run dev
npm run test

## Important Files
- src/lib/supabase/client.ts
- src/app/api/...

# Avoid: Generic boilerplate
```

---

### 2. Use settings.json for Automation

```json
{
  "hooks": {...},
  "commands": {...},
  "mcpServers": {...}
}
```

Keep CLAUDE.md for human-readable context.

---

### 3. Version Control Your Config

```bash
# Commit these
git add CLAUDE.md
git add .claude/settings.json

# Don't commit
.claude/logs/
.env
```

---

## Security

### 1. Review Before Committing

Always review Claude's changes before committing:

```bash
git diff --staged
```

---

### 2. Use Security Hooks

Enable pre-commit security scanning:

```json
{
  "hooks": {
    "PreCommit": [
      {
        "command": "./hooks/pre-commit/security-scan.sh",
        "blocking": true
      }
    ]
  }
}
```

---

### 3. Don't Trust External Data

When using MCP to query external services, validate responses:

```markdown
"Query the database for user data, then validate:
- No PII in response
- Data matches expected schema"
```

---

## Performance

### 1. Be Specific in Queries

```markdown
# Good: Specific
"Search for 'getUserById' in src/services/user.ts"

# Slow: Broad
"Search everywhere for anything related to users"
```

---

### 2. Limit MCP Results

```sql
-- Good
SELECT * FROM users WHERE id = $1 LIMIT 1;

-- Avoid
SELECT * FROM users;  -- Could be millions
```

---

### 3. Use Appropriate Agents

Stack-specific agents are faster because they know the patterns:

```markdown
# Good: Specific agent
"Using React Agent, optimize this component"

# Slower: Generic agent needs to figure out the stack
"Optimize this code"
```

---

## Team Collaboration

### 1. Standardize CLAUDE.md

Create a template for your team:

```markdown
# CLAUDE.md Template

## Project Overview
[Description]

## Stack
[Technologies]

## Key Commands
[Commands]

## Architecture
[Structure]
```

---

### 2. Share settings.json

Check in a team settings.json:

```json
{
  "project": {
    "name": "our-project",
    "type": "api"
  },
  "hooks": {
    "PreCommit": [...]
  }
}
```

---

### 3. Document Agent Choices

```markdown
## Recommended Agents

For this project, use:
- Bug fixes: Bug Hunter Agent
- Features: React Agent + API Design Agent
- Security: Security Audit Crew
```

---

## Debugging

### 1. Enable Verbose Logging

```bash
DEBUG=1 claude-code
```

---

### 2. Test Hooks Manually

```bash
# Run hook directly to see output
./hooks/pre-commit/lint-check.sh
```

---

### 3. Validate Configuration

```bash
# Check JSON syntax
jq . .claude/settings.json

# Check CLAUDE.md structure
head -50 CLAUDE.md
```

---

## Summary Checklist

- [ ] Use specific agents for specific tasks
- [ ] Keep credentials secure (env vars, not in code)
- [ ] Enable security hooks
- [ ] Keep hooks fast
- [ ] Review Claude's changes before committing
- [ ] Use crews for complex multi-agent tasks
- [ ] Document agent choices for team
- [ ] Version control configuration files
- [ ] Rotate credentials regularly
- [ ] Test configurations in development first
