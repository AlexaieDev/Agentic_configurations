# Next.js SaaS Example

Example configuration for a Next.js 14 SaaS application with Supabase, Stripe, and modern tooling.

## Stack

| Technology | Purpose |
|------------|---------|
| Next.js 14 | React framework with App Router |
| TypeScript | Type safety |
| Supabase | Database, Auth, Storage |
| Stripe | Payments |
| Tailwind CSS | Styling |
| Shadcn/ui | Component library |
| Vercel | Deployment |

## Files Included

```
nextjs-saas/
├── CLAUDE.md              # Instructions for Claude
├── .claude/
│   └── settings.json      # Claude Code settings
└── README.md              # This file
```

## How to Use

### 1. Copy to Your Project

```bash
# Copy CLAUDE.md to root
cp CLAUDE.md /path/to/your-project/

# Copy settings
mkdir -p /path/to/your-project/.claude
cp .claude/settings.json /path/to/your-project/.claude/
```

### 2. Configure Environment

Set these environment variables:

```bash
# Supabase
export SUPABASE_URL="https://xxx.supabase.co"
export SUPABASE_SERVICE_ROLE_KEY="eyJxxx"

# GitHub (for MCP)
export GITHUB_TOKEN="ghp_xxx"

# Sentry (optional)
export SENTRY_AUTH_TOKEN="sntrys_xxx"
export SENTRY_ORG="your-org"
```

### 3. Start Claude Code

```bash
cd /path/to/your-project
claude-code
```

## Recommended Agents

### For Daily Development

| Agent | When to Use |
|-------|-------------|
| **Next.js Agent** | Routing, SSR, App Router |
| **React Agent** | Components, hooks, state |
| **TypeScript Agent** | Types, interfaces |

### For Features

| Agent | When to Use |
|-------|-------------|
| **Database Architect Agent** | Schema design, migrations |
| **Authentication Agent** | Auth flows, sessions |
| **API Design Agent** | API routes, Server Actions |

### For Quality

| Agent | When to Use |
|-------|-------------|
| **Code Review Agent** | PR reviews |
| **Security Agent** | Security audits |
| **Test Architect Agent** | Testing strategy |

## MCP Integrations

### Supabase
- Query database
- Manage tables
- Check RLS policies

### GitHub
- Create issues from bugs
- Manage PRs
- Search code

### Sentry
- Debug errors
- Track performance
- Analyze releases

## Common Workflows

### Start New Feature

```
1. "Create database migration for feature X"
2. "Generate Supabase types"
3. "Create Server Action for feature X"
4. "Create React component for feature X"
5. "Write tests for feature X"
```

### Debug Production Issue

```
1. "Show recent errors in Sentry"
2. "Get stack trace for error X"
3. "Find related code"
4. "Create fix and write test"
```

### Optimize Performance

```
1. "Analyze bundle size"
2. "Find slow components"
3. "Suggest optimizations"
4. "Implement lazy loading"
```

## Customization

### Add More Agents

Edit `.claude/settings.json`:

```json
{
  "agents": {
    "default": ["Next.js Agent", "React Agent", "Your Agent"]
  }
}
```

### Add MCP Servers

```json
{
  "mcpServers": {
    "your-service": {
      "command": "npx",
      "args": ["-y", "@your/mcp-server"]
    }
  }
}
```

### Add Hooks

```json
{
  "hooks": {
    "PreCommit": [
      {
        "command": "your-script.sh",
        "timeout": 30000
      }
    ]
  }
}
```

## Best Practices

1. **Keep CLAUDE.md updated** - Document changes to architecture
2. **Use specific agents** - Match agent to task
3. **Leverage MCP** - Query Supabase directly, check Sentry for errors
4. **Run hooks** - Pre-commit checks catch issues early
5. **Test before push** - Pre-push hook runs tests

## Resources

- [Next.js Docs](https://nextjs.org/docs)
- [Supabase Docs](https://supabase.com/docs)
- [Shadcn/ui](https://ui.shadcn.com/)
- [Tailwind CSS](https://tailwindcss.com/docs)
