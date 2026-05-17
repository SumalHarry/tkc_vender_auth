# tkc_vender_auth

Flutter host app for vendor authentication and embedded mini-app launching.

## Features

- Login and automatic session restore on startup
- Silent token refresh (access token refreshed proactively; 401s retried automatically)
- Home launcher that opens embedded Shopping and Concert mini apps
- Authenticated `Dio` instance injected into all mini apps

## Prerequisites

| Tool | Notes |
|------|-------|
| [FVM](https://fvm.app/) | Pins Flutter to `stable` |
| Backend API | Default `http://localhost:3000` |
| `../tkc_shopping` | Sibling path dependency |
| `../tkc_concert_booking` | Sibling path dependency |

## Setup

```bash
cp .env.example .env          # set BASE_URL (and optional PROXYMAN settings)
fvm use stable
fvm flutter pub get
make gen                      # initial code generation
cd ios && pod install && cd .. # iOS only
```

## Running

```bash
fvm flutter run
```

App bundle ID: `com.tkcsupawat.tkc_vender_auth`

## Commands

| Command | Description |
|---------|-------------|
| `fvm flutter run` | Run the app |
| `make gen` | One-shot code generation (clean → build) |
| `make autogen` | Watch mode code generation |
| `fvm flutter test` | Run all tests |
| `fvm flutter test <path>` | Run a single test file |
| `fvm flutter analyze` | Lint |

## Environment

Copy `.env.example` to `.env` and adjust as needed:

```env
BASE_URL=http://localhost:3000

# Proxyman (debug proxy, optional)
ENABLE_PROXYMAN=false
# PROXYMAN_IP=127.0.0.1
```

`.env` is bundled as a Flutter asset and loaded at startup via `flutter_dotenv`.

## Architecture

### Feature structure

Each feature under `lib/features/<name>/` follows Clean Architecture:

```
data/
  datasources/    # remote (Dio) + local (SecureStorage) sources
  repositories/   # concrete implementations
domain/
  entities/       # Freezed value objects
  providers/      # Riverpod providers wiring sources → repository
  repositories/   # abstract interfaces
presentation/
  providers/      # UI state Notifiers
  screens/
  widgets/
```

Shared infrastructure (network, storage, session) lives in `lib/core/`.

### Mini-app system

Mini apps are standalone Flutter packages loaded as path dependencies. Each is adapted with a `MiniAppEntry` in `lib/app/mini_apps/configs/`. The router and home launcher both derive from `miniAppRegistry` — adding a mini app only touches that list.

The host overrides each mini app's Dio provider with the authenticated `coreDioProvider` at startup (`main.dart`), so mini apps share auth headers and token refresh automatically.

### Auth flow

1. On startup `AuthNotifier` checks stored tokens and restores the session.
2. `AuthRefreshInterceptor` proactively refreshes the access token before each request and retries on 401. Concurrent refresh calls are collapsed with a `Completer`.
3. `HeaderInterceptor` reads the current token from `SecureStorage` and attaches `Authorization: Bearer <token>`.
4. `LogoutService` decouples the network layer from `AuthNotifier` — the interceptor calls `LogoutService.logout()` without a direct provider dependency.

### Code generation

`freezed`, `json_serializable`, and `riverpod_generator` produce `.freezed.dart` and `.g.dart` files. Run `make gen` after modifying any annotated class. Never edit generated files directly.
