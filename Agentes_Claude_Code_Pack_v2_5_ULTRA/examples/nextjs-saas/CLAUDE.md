# CLAUDE.md - Next.js SaaS Application

## Project Overview

This is a Next.js 14+ SaaS application with:
- **Framework**: Next.js 14 with App Router
- **Database**: Supabase (PostgreSQL)
- **Auth**: Supabase Auth
- **Styling**: Tailwind CSS
- **Payments**: Stripe
- **Deployment**: Vercel

## Architecture

```
src/
├── app/                    # App Router pages
│   ├── (auth)/            # Auth routes (login, signup)
│   ├── (dashboard)/       # Protected dashboard routes
│   ├── api/               # API routes
│   └── layout.tsx         # Root layout
├── components/            # React components
│   ├── ui/               # Shadcn/ui components
│   └── features/         # Feature-specific components
├── lib/                   # Utility libraries
│   ├── supabase/         # Supabase client
│   ├── stripe/           # Stripe integration
│   └── utils/            # Helper functions
├── hooks/                 # Custom React hooks
└── types/                 # TypeScript types
```

## Development Commands

```bash
# Development
npm run dev              # Start dev server (port 3000)
npm run build            # Production build
npm run start            # Start production server

# Database
npm run db:generate      # Generate types from Supabase
npm run db:migrate       # Run migrations
npm run db:seed          # Seed database

# Testing
npm run test             # Run Jest tests
npm run test:e2e         # Run Playwright E2E tests
npm run test:coverage    # Generate coverage report

# Linting
npm run lint             # ESLint
npm run format           # Prettier
npm run typecheck        # TypeScript check
```

## Environment Variables

```bash
# Required
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJxxx
SUPABASE_SERVICE_ROLE_KEY=eyJxxx

# Stripe
STRIPE_SECRET_KEY=sk_live_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_xxx

# Optional
NEXT_PUBLIC_APP_URL=https://myapp.com
```

## Key Files

| File | Purpose |
|------|---------|
| `src/app/layout.tsx` | Root layout with providers |
| `src/lib/supabase/client.ts` | Supabase browser client |
| `src/lib/supabase/server.ts` | Supabase server client |
| `src/middleware.ts` | Auth middleware |
| `supabase/migrations/` | Database migrations |

## Coding Standards

### TypeScript
- Strict mode enabled
- No `any` types without justification
- Use Zod for runtime validation
- Prefer `interface` over `type` for objects

### React
- Use Server Components by default
- Client Components only when needed ('use client')
- Prefer Server Actions over API routes
- Use React Query for client-side data fetching

### Styling
- Tailwind CSS for styling
- Use cn() utility for conditional classes
- Shadcn/ui for component primitives
- CSS variables for theming

### Database
- Use Supabase migrations for schema changes
- RLS (Row Level Security) enabled on all tables
- Never expose service_role key to client

## Security Requirements

1. **Authentication**: All /dashboard routes require auth
2. **Authorization**: RLS policies on all user data
3. **Input Validation**: Zod schemas on all forms
4. **CSRF**: Handled by Next.js Server Actions
5. **Rate Limiting**: Implemented on API routes

## Performance Guidelines

1. Use `next/image` for all images
2. Lazy load below-fold components
3. Use Suspense boundaries for loading states
4. Minimize client-side JavaScript
5. Cache Supabase queries where appropriate

## Testing Strategy

- **Unit Tests**: Components with Jest + RTL
- **Integration Tests**: API routes and Server Actions
- **E2E Tests**: Critical user flows with Playwright
- **Visual Tests**: Storybook for component library

## Recommended Agents

For this project, use these agents from the catalog:

| Task | Agent |
|------|-------|
| React components | React Agent |
| Next.js features | Next.js Agent |
| Database | Database Architect Agent |
| Auth | Authentication Agent |
| Security | Security Agent |
| Performance | Frontend Performance Agent |
| Accessibility | Accessibility Agent |
| Payments | API Design Agent |

## Common Tasks

### Add new feature
1. Create migration if schema change needed
2. Update Supabase types: `npm run db:generate`
3. Create Server Actions in `src/app/actions/`
4. Add UI components
5. Write tests

### Add new API route
1. Create route in `src/app/api/`
2. Add rate limiting middleware
3. Validate input with Zod
4. Handle errors consistently
5. Add tests

### Fix bug
1. Reproduce in development
2. Check Sentry for related errors
3. Write failing test
4. Fix the bug
5. Verify test passes

## Deployment Checklist

- [ ] All tests passing
- [ ] TypeScript compiles without errors
- [ ] Environment variables set in Vercel
- [ ] Database migrations applied
- [ ] Stripe webhooks configured
- [ ] Error tracking (Sentry) configured
