# CLAUDE.md - React Native Mobile App

## Project Overview

This is a React Native mobile application with:
- **Framework**: React Native with Expo
- **Navigation**: React Navigation 6
- **State**: Zustand + React Query
- **Styling**: NativeWind (Tailwind for RN)
- **Backend**: REST API / GraphQL
- **Deployment**: EAS Build

## Architecture

```
src/
├── app/                    # Expo Router screens
│   ├── (tabs)/            # Tab navigation
│   ├── (auth)/            # Auth screens
│   └── _layout.tsx        # Root layout
├── components/            # Reusable components
│   ├── ui/               # Base UI components
│   └── features/         # Feature components
├── hooks/                 # Custom hooks
├── services/             # API services
│   ├── api/              # API client
│   └── queries/          # React Query hooks
├── stores/               # Zustand stores
├── utils/                # Utilities
└── types/                # TypeScript types
```

## Development Commands

```bash
# Development
npx expo start              # Start Expo dev server
npx expo start --ios        # iOS simulator
npx expo start --android    # Android emulator
npx expo start --web        # Web browser

# Building
eas build --platform ios    # iOS build
eas build --platform android # Android build
eas build --platform all    # Both platforms

# Testing
npm run test               # Jest tests
npm run test:watch         # Watch mode
npm run test:coverage      # Coverage report

# Linting
npm run lint               # ESLint
npm run format             # Prettier
npm run typecheck          # TypeScript

# Native
npx expo prebuild          # Generate native projects
npx expo run:ios           # Run on iOS device
npx expo run:android       # Run on Android device
```

## Environment Variables

```bash
# API
EXPO_PUBLIC_API_URL=https://api.myapp.com

# Auth
EXPO_PUBLIC_AUTH_DOMAIN=auth.myapp.com

# Analytics
EXPO_PUBLIC_AMPLITUDE_KEY=xxx

# Push Notifications
EXPO_PUBLIC_ONESIGNAL_APP_ID=xxx
```

## Key Files

| File | Purpose |
|------|---------|
| `app.json` | Expo configuration |
| `eas.json` | EAS Build configuration |
| `src/app/_layout.tsx` | Root navigation |
| `src/services/api/client.ts` | API client |
| `src/stores/auth.ts` | Auth state |

## Coding Standards

### TypeScript
- Strict mode enabled
- Type all props and state
- Use interfaces for component props
- Avoid `any`

### React Native
- Functional components only
- Use hooks for state/effects
- Memoize expensive renders
- Handle keyboard interactions

### Styling
- NativeWind for styling
- Use design tokens
- Support dark mode
- Responsive layouts

### Navigation
- Use Expo Router for navigation
- Type-safe routes
- Deep linking configured
- Back behavior handled

## Platform Considerations

### iOS
- Safe area handling
- Haptic feedback
- Push notifications setup
- App Store guidelines

### Android
- Material Design elements
- Back button handling
- Permissions management
- Play Store requirements

### Cross-Platform
- Platform-specific code when needed
- Consistent UX with platform conventions
- Test on both platforms

## Performance Guidelines

1. Use `FlatList` for long lists
2. Memoize with `useMemo`/`useCallback`
3. Optimize images with Expo Image
4. Lazy load screens
5. Profile with Flipper

## Security Requirements

1. **Secure Storage**: Use expo-secure-store for tokens
2. **SSL Pinning**: Consider for sensitive apps
3. **Obfuscation**: Enable for production
4. **No Secrets in Code**: Use env variables
5. **Input Validation**: Validate user input

## Testing Strategy

- **Unit Tests**: Components, hooks, utils
- **Integration Tests**: Screens, navigation
- **E2E Tests**: Detox for critical flows
- **Manual Testing**: Both platforms

## Recommended Agents

| Task | Agent |
|------|-------|
| Components | React Agent |
| Navigation | React Agent |
| API | API Design Agent |
| Performance | Frontend Performance Agent |
| Accessibility | Accessibility Agent |
| Testing | Test Architect Agent |

## Common Tasks

### Add new screen
1. Create screen in `src/app/`
2. Add navigation type
3. Implement UI
4. Connect to data layer
5. Write tests

### Add API endpoint
1. Add types in `types/`
2. Create query hook in `services/queries/`
3. Handle loading/error states
4. Add to relevant screen

### Fix platform-specific bug
1. Identify platform with `Platform.OS`
2. Create platform-specific file if needed
3. Test on both platforms
4. Document platform differences

## Build & Deploy

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
eas submit --platform ios
eas submit --platform android
```

## Debugging

### Flipper
- Network inspector
- React DevTools
- Performance profiler

### Expo Dev Tools
- Console logs
- Element inspector
- Network requests

### Platform Tools
- Xcode Instruments (iOS)
- Android Profiler (Android)
