# React Native Mobile App Example

Example configuration for a React Native mobile app with Expo, TypeScript, and modern tooling.

## Stack

| Technology | Purpose |
|------------|---------|
| React Native | Mobile framework |
| Expo | Development platform |
| TypeScript | Type safety |
| Expo Router | Navigation |
| Zustand | State management |
| React Query | Data fetching |
| NativeWind | Styling (Tailwind) |
| EAS | Build & deploy |

## Files Included

```
mobile-app/
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

```bash
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

### For Development

| Agent | When to Use |
|-------|-------------|
| **React Agent** | Components, hooks |
| **TypeScript Agent** | Types, interfaces |

### For Quality

| Agent | When to Use |
|-------|-------------|
| **Test Architect Agent** | Testing strategy |
| **Accessibility Agent** | A11y compliance |
| **Frontend Performance Agent** | Optimization |

## Platform-Specific Code

### iOS Only
```typescript
import { Platform } from 'react-native';

if (Platform.OS === 'ios') {
  // iOS specific code
}
```

### Android Only
```typescript
if (Platform.OS === 'android') {
  // Android specific code
}
```

### Platform Files
```
Button.tsx         # Shared
Button.ios.tsx     # iOS override
Button.android.tsx # Android override
```

## Common Workflows

### Create New Screen

```
1. "Create new screen for feature X"
2. "Add navigation route"
3. "Implement UI with NativeWind"
4. "Connect to data layer"
5. "Test on both platforms"
```

### Fix Platform Bug

```
1. "Identify which platform has the issue"
2. "Create platform-specific fix"
3. "Test on both platforms"
4. "Document platform differences"
```

### Optimize Performance

```
1. "Profile with Flipper"
2. "Identify slow renders"
3. "Add memoization"
4. "Optimize list rendering"
```

## Testing

### Unit Tests
```bash
npm run test
```

### E2E Tests (Detox)
```bash
detox test --configuration ios.sim.debug
```

### Manual Testing
Always test on both iOS and Android before submitting.

## Building

### Development
```bash
npx expo start
```

### Preview Build
```bash
eas build --profile preview
```

### Production
```bash
eas build --profile production
```

### Submitting
```bash
eas submit --platform ios
eas submit --platform android
```

## Best Practices

1. **Test both platforms** - Behavior differs
2. **Handle safe areas** - iPhone notch, Android navigation
3. **Optimize images** - Use appropriate sizes
4. **Lazy load screens** - Improve startup time
5. **Handle offline** - Cache data appropriately

## Resources

- [Expo Docs](https://docs.expo.dev/)
- [React Native Docs](https://reactnative.dev/docs/getting-started)
- [React Navigation](https://reactnavigation.org/)
- [NativeWind](https://www.nativewind.dev/)
