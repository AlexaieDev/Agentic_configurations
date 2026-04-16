# Troubleshooting Guide

Solutions for common issues with agents, MCP, hooks, and commands.

---

## Agent Issues

### Agent not following instructions

**Symptoms:**
- Claude ignores agent guidelines
- Behavior doesn't match CLAUDE.md

**Solutions:**

1. **Check CLAUDE.md syntax**
   ```bash
   # Verify file exists and has content
   cat CLAUDE.md | head -50
   ```

2. **Restart session**
   - Claude reads CLAUDE.md at session start
   - Close and reopen Claude Code

3. **Be explicit in prompts**
   ```
   # Instead of:
   "Fix this bug"

   # Say:
   "Acting as Bug Hunter Agent, debug this error..."
   ```

4. **Check for conflicting instructions**
   - Multiple agents in CLAUDE.md may conflict
   - Use one agent or a crew at a time

---

### Wrong agent being used

**Symptoms:**
- Claude acts as different agent
- Responses don't match expected agent

**Solutions:**

1. **Specify agent explicitly**
   ```
   "Using the Security Agent, review this code..."
   ```

2. **Clear CLAUDE.md and re-add**
   ```bash
   # Reset to single agent
   cp agents/security/threat-modeling.md CLAUDE.md
   ```

3. **Check for agent sections**
   - Ensure agent has proper MISIÓN section
   - Verify DEBE HACER and NO DEBE HACER present

---

## MCP Issues

### MCP server not starting

**Symptoms:**
- "Failed to start MCP server"
- Tools not available

**Solutions:**

1. **Check npx works**
   ```bash
   npx -y @modelcontextprotocol/server-github --version
   ```

2. **Verify environment variables**
   ```bash
   # Check if set
   echo $GITHUB_TOKEN

   # If empty, set it
   export GITHUB_TOKEN="ghp_xxx"
   ```

3. **Check settings.json syntax**
   ```bash
   # Validate JSON
   cat .claude/settings.json | jq .
   ```

4. **Restart Claude Code**
   - MCP servers start on session init

---

### MCP tool returns error

**Symptoms:**
- "Unauthorized"
- "Not found"
- "Rate limit exceeded"

**Solutions:**

#### 401 Unauthorized
```bash
# Token expired or invalid
# Regenerate and update:
export GITHUB_TOKEN="new_token"
```

#### 404 Not Found
```bash
# Check resource exists
# For GitHub:
gh repo view owner/repo

# For Jira:
curl -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  "https://$JIRA_HOST/rest/api/3/issue/PROJ-123"
```

#### 429 Rate Limit
```bash
# Wait and retry
# Or use authenticated requests for higher limits
```

---

### Database connection fails

**Symptoms:**
- "Connection refused"
- "Authentication failed"

**Solutions:**

1. **Check connection string**
   ```bash
   # Format
   postgresql://user:password@host:5432/database

   # Test
   psql $DATABASE_URL -c "SELECT 1"
   ```

2. **Check network access**
   ```bash
   # Is port open?
   nc -zv host 5432
   ```

3. **Check credentials**
   ```bash
   # URL encode special characters in password
   # @ → %40
   # : → %3A
   ```

---

## Hook Issues

### Hook not executing

**Symptoms:**
- Hook doesn't run
- No output from hook

**Solutions:**

1. **Check permissions**
   ```bash
   # Make executable
   chmod +x hooks/pre-commit/security-scan.sh
   ```

2. **Check path in settings.json**
   ```json
   {
     "hooks": {
       "PreCommit": [
         {
           "command": "./hooks/pre-commit/security-scan.sh"
         }
       ]
     }
   }
   ```

3. **Test manually**
   ```bash
   # Run hook directly
   ./hooks/pre-commit/security-scan.sh
   ```

---

### Hook times out

**Symptoms:**
- "Hook timed out"
- Operation cancelled

**Solutions:**

1. **Increase timeout**
   ```json
   {
     "hooks": {
       "PreCommit": [
         {
           "command": "./hooks/pre-commit/lint-check.sh",
           "timeout": 120000  // 2 minutes
         }
       ]
     }
   }
   ```

2. **Optimize hook**
   - Only process changed files
   - Use cached results when possible

---

### Hook blocks commit incorrectly

**Symptoms:**
- Can't commit due to hook
- False positive from security scan

**Solutions:**

1. **Check hook output**
   ```bash
   # Run manually to see errors
   ./hooks/pre-commit/security-scan.sh
   ```

2. **Adjust sensitivity**
   ```bash
   # In hook, set less strict mode
   export SCAN_LEVEL=normal  # instead of strict
   ```

3. **Skip hook (temporarily)**
   ```bash
   # Only if you're sure it's a false positive
   git commit --no-verify
   ```

---

## Command Issues

### Command not found

**Symptoms:**
- "/command not recognized"

**Solutions:**

1. **Check commands enabled**
   ```json
   {
     "commands": {
       "enabled": true,
       "directory": "./commands"
     }
   }
   ```

2. **Verify file exists**
   ```bash
   ls commands/security-review.md
   ```

3. **Check frontmatter**
   ```yaml
   ---
   name: security-review
   description: ...
   ---
   ```

---

### Command uses wrong agents

**Symptoms:**
- Command doesn't use specified agents

**Solutions:**

1. **Check agents in frontmatter**
   ```yaml
   ---
   agents:
     - Security Agent
     - Threat Modeling Agent
   ---
   ```

2. **Verify agent names match**
   - Names must match exactly
   - Check `index.json` for correct names

---

## Configuration Issues

### settings.json not loading

**Symptoms:**
- Settings ignored
- Default behavior used

**Solutions:**

1. **Check file location**
   ```bash
   # Must be in .claude/ folder
   ls -la .claude/settings.json
   ```

2. **Validate JSON**
   ```bash
   jq . .claude/settings.json
   ```

3. **Check for syntax errors**
   - Trailing commas
   - Missing quotes
   - Unescaped characters

---

### Environment variables not found

**Symptoms:**
- "${VAR_NAME}" appears literally
- "undefined" in config

**Solutions:**

1. **Check variable is set**
   ```bash
   echo $GITHUB_TOKEN
   ```

2. **Export in shell profile**
   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   export GITHUB_TOKEN="ghp_xxx"
   source ~/.zshrc
   ```

3. **Use .env file**
   ```bash
   # Create ~/.claude/.env
   GITHUB_TOKEN=ghp_xxx
   ```

---

## Performance Issues

### Claude Code slow to start

**Solutions:**

1. **Reduce MCP servers**
   - Only enable needed servers
   - Lazy load if possible

2. **Simplify CLAUDE.md**
   - Shorter agent instructions load faster

3. **Check hook timeouts**
   - SessionStart hooks delay startup

---

### Responses are slow

**Solutions:**

1. **Reduce context**
   - Smaller CLAUDE.md
   - Fewer active agents

2. **Use specific queries**
   - "Search this file" vs "search everywhere"

3. **Check MCP server health**
   - Slow external services affect responses

---

## Common Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| "CLAUDE.md not found" | Missing file | Create CLAUDE.md |
| "Invalid JSON in settings" | Syntax error | Validate with `jq` |
| "MCP server failed" | Bad config | Check env vars |
| "Hook timed out" | Slow script | Increase timeout |
| "Permission denied" | File perms | `chmod +x` script |
| "Connection refused" | Service down | Check service status |
| "Rate limit exceeded" | Too many requests | Wait and retry |

---

## Getting Help

1. **Check logs**
   ```bash
   # MCP logs
   cat ~/.claude/logs/mcp-*.log

   # Error logs
   cat ~/.claude/logs/errors.log
   ```

2. **Enable debug mode**
   ```bash
   DEBUG=1 claude-code
   ```

3. **Report issues**
   - https://github.com/anthropics/claude-code/issues

---

## Reset Everything

If all else fails:

```bash
# Backup current config
mv .claude .claude.backup

# Remove global config
rm -rf ~/.claude/settings.json

# Start fresh
claude-code

# Re-add configurations one by one
```
