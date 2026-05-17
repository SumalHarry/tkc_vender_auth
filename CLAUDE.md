# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Flutter host app (`tkc_vender_auth`) for vendor authentication and launching embedded mini apps. Uses FVM to pin the Flutter version to `stable`.

## Prerequisites

- [FVM](https://fvm.app/) installed — all `flutter` commands must be prefixed with `fvm`
- Sibling packages at `../tkc_shopping` and `../tkc_concert_booking` (path dependencies)
- Backend API running at `http://localhost:3000` (default)

## Setup

```bash
cp .env.example .env        # configure BASE_URL and optional PROXYMAN settings
fvm flutter pub get
make gen                    # run code generation after first setup
cd ios && pod install && cd ..  # iOS only
```

## Commands

```bash
# Run
fvm flutter run

# Code generation (freezed, riverpod_generator, json_serializable)
make gen        # clean + build once
make autogen    # watch mode

# Test
fvm flutter test                                 # all tests
fvm flutter test test/widget_test.dart           # single file

# Lint
fvm flutter analyze
```

## Architecture

### Layer structure (per feature)

Each feature under `lib/features/<name>/` follows Clean Architecture:

```
data/
  datasources/   # remote (Dio) and local (SecureStorage) data sources
  repositories/  # concrete implementations of domain interfaces
domain/
  entities/      # Freezed value objects
  providers/     # Riverpod providers wiring datasources → repository
  repositories/  # abstract interfaces
presentation/
  providers/     # UI state (Notifiers) consuming domain providers
  screens/
  widgets/
```

Shared infrastructure lives in `lib/core/` (network, storage, session).

### Mini-app system

Mini apps are Flutter packages (`miniapp_shopping`, `miniapp_concert`) loaded as path dependencies. Each is adapted via a `MiniAppEntry` implementation in `lib/app/mini_apps/configs/`. Adding a mini app means:

1. Create a `MiniAppEntry` adapter under `lib/app/mini_apps/configs/`
2. Add it to `miniAppRegistry` in `lib/app/mini_apps/mini_app_registry.dart`

The router and home launcher both derive purely from that registry list. `assertMiniAppContract()` (called at router build time) validates no duplicate IDs, namespaces, or route escapes in debug mode.

### Dio injection

Mini apps receive an authenticated `Dio` instance from the host rather than constructing their own. `main.dart` overrides each mini app's `dioProvider` with `coreDioProvider` via `ProviderContainer.overrides`. This means all network calls from mini apps automatically carry auth headers and share the token-refresh logic.

### Auth flow

- `AuthNotifier` (keepAlive) bootstraps by checking stored tokens on startup via `_restoreSession`.
- `AuthRefreshInterceptor` handles proactive pre-request token refresh and reactive 401 retry. Concurrent refresh requests are collapsed with a `Completer` (`_isRefreshing` flag).
- `HeaderInterceptor` reads the (possibly just-refreshed) token from `SecureStorage` and attaches `Authorization: Bearer <token>`.
- `LogoutService` is a keepAlive Riverpod notifier that holds a registered handler; the network interceptor calls it to trigger logout without a direct dependency on `AuthNotifier`.

### Router

`appRouter` (GoRouter, keepAlive) listens to `authProvider` via a `ValueNotifier`-based `refreshListenable`. The redirect guard sends unauthenticated users to `/auth` while letting `/splash` and `/auth` through as public paths. Mini app routes are injected via `withFadeTransition(app.routes)`.

### Code generation

`freezed` + `json_serializable` + `riverpod_generator` — generated files end in `.freezed.dart` and `.g.dart`. Run `make gen` after modifying any annotated classes. Never edit generated files directly.
