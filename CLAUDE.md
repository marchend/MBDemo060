# AcmeBank — Project Context

## Overview
AcmeBank is an iOS 17+ mobile banking app built in Swift/SwiftUI that lets customers
view accounts and transactions, initiate transfers, and manage cards. It uses Okta OIDC
for authentication and a clean MVVM + Coordinator architecture. This repository currently
contains the bootstrap scaffold (Hello World shell); all banking features are deferred
to follow-on stories.

## Tech Stack
| Item | Value |
|---|---|
| Platform | iOS 17+, Xcode 16+ |
| Language | Swift 5.10 |
| UI Framework | SwiftUI |
| Architecture | MVVM + Coordinator (`NavigationStack`) |
| Auth | Okta OIDC (`okta-mobile-swift` 2.x) |
| Networking | `URLSession` + async/await |
| DI | Constructor injection |
| Notifications | `NotificationCenter` (typed wrappers) |
| Project file | XcodeGen `project.yml` |
| Bundle ID | `com.acmebank.mobile` |
| Test framework | XCTest (unit) + XCUITest (UI, future) |

## How to Run Locally
```bash
./setup.sh          # installs xcodegen if missing, generates .xcodeproj, opens Xcode
# Manual fallback:
brew install xcodegen && xcodegen generate
open AcmeBank.xcodeproj
```

## How to Run Tests
```bash
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

## Key Directory Structure
```
AcmeBank/
├── App/                    # @main entry + root views (implemented)
├── Core/
│   ├── Auth/               # AuthService, KeychainStore, UserSession (deferred)
│   ├── Networking/         # APIClient, APIRouter, APIError (deferred)
│   ├── Notifications/      # AppNotification, NotificationPublisher (deferred)
│   └── Extensions/         # Decimal+Currency, Date+Greeting, String+Initials (deferred)
├── Domain/
│   ├── Models/             # Account, Transaction, Customer, TransferRequest (deferred)
│   └── Repositories/       # Protocol definitions only (deferred)
├── Data/
│   ├── Remote/             # URLSession-backed repository impls (deferred)
│   └── Mock/               # Hardcoded fixture repositories (deferred)
├── Features/
│   ├── Login/              # LoginCoordinator, LoginView, LoginViewModel (deferred)
│   ├── Home/               # HomeCoordinator, HomeView, HomeViewModel (deferred)
│   ├── Accounts/           # (deferred)
│   ├── Transfer/           # (deferred)
│   └── Cards/              # (deferred)
├── DesignSystem/           # Colors.swift, Typography.swift (deferred)
└── Resources/              # Assets.xcassets, PrivacyInfo.xcprivacy (implemented)
AcmeBankTests/              # Unit test target (implemented — smoke test only)
AcmeBankUITests/            # XCUITest target (deferred — future PR)
project.yml                 # XcodeGen spec (implemented)
setup.sh                    # One-shot materialise script (implemented)
```

## Planned Architecture

### MVVM + Coordinator (deferred — future PR)
- **View** — SwiftUI `View` struct; renders from ViewModel `@Published` state; zero business logic.
- **ViewModel** — `final class: ObservableObject`; holds `@Published` state; calls repositories; no SwiftUI imports.
- **Coordinator** — `ObservableObject` owning `NavigationPath`; creates child Views+VMs; drives push/present declaratively.
- **Repository protocols** live in `Domain/`; concrete impls live in `Data/`.

### Auth — Okta OIDC (deferred — future PR)
Okta browser-based OIDC flow via `okta-mobile-swift`. On success, decode ID-token claims, persist tokens to Keychain via `KeychainStore`, return a `UserSession` value type. `RequestInterceptor` refreshes tokens before every request; expired sessions post `AppNotification.sessionExpired`.

> **Keychain note for feature agents:** every Keychain query dict MUST include
> `kSecUseDataProtectionKeychain: true` to work in CI's `CODE_SIGNING_ALLOWED=NO`
> simulator environment.

### Networking (deferred — future PR)
`APIClient` wraps `URLSession`; decodes via `JSONDecoder` with `.convertFromSnakeCase` + `.iso8601`. `APIRouter` is a typed endpoint enum. `Base URL` is read from `Info.plist` `API_BASE_URL` key injected by CI xcconfig.

### Coordinator tree (deferred — future PR)
```
AppCoordinator → RootView (auth-state switch)
  ├── LoginCoordinator   (no session)
  └── TabBarCoordinator  (authenticated)
        ├── HomeCoordinator
        ├── TransferCoordinator
        ├── CardsCoordinator
        └── MoreCoordinator
```

### Internal Notifications (deferred — future PR)
Typed `Notification.Name` constants in `AppNotification`; posted via `NotificationPublisher.post(_:userInfo:)`. Subscriptions live in coordinators (Combine `sink`), never in ViewModels.

### Design System (deferred — future PR)
`Color` extensions (`acmeNavy`, `acmeBackground`, etc.) and `Font` extensions (`acmeTitle`, `acmeHeadline`, etc.) defined in `DesignSystem/`.

### XCUITest (deferred — future PR)
Critical flows (login, transfer, sign-out) get XCUITest in `AcmeBankUITests/`. Use `accessibilityIdentifier` locators; inject `-UITestMode YES` launch arg to swap in mock repositories.

## Deferred Work
- Authentication (Okta OIDC / `okta-mobile-swift`) — future PR
- MVVM + Coordinator pattern (AppCoordinator, all coordinators) — future PR
- RootView auth-state switching — future PR
- Networking layer (APIClient, APIRouter, APIError, RequestInterceptor) — future PR
- Domain models (Account, Transaction, Customer, TransferRequest) — future PR
- Repository protocols + implementations + Mock repositories — future PR
- All Feature screens (Login, Home, Accounts, Transfer, Cards) — future PR
- Design system (Colors, Typography) — future PR
- Internal notifications (AppNotification, NotificationPublisher) — future PR
- Extensions (Decimal+Currency, Date+Greeting, String+Initials) — future PR
- CI / xcconfig / SwiftLint configuration — future PR
- XCUITest target (AcmeBankUITests) — future PR
- Okta.plist / Okta.plist.example — future PR
- Localizable.strings — future PR

## Git Workflow

> **Default PR target branch: `develop`.** Every feature/refactor/docs PR
> opens against `develop`. PRs are only opened against `qa`, `uat`, or
> `main` for explicit promotion PRs.

**Branch model (`develop` → `qa` → `uat` → `main`):**

| Branch  | Role                                 | Receives PRs from              | Promotes to |
|---------|--------------------------------------|--------------------------------|-------------|
| develop | Default integration branch           | feature branches               | qa          |
| qa      | First quality gate                   | develop (promotion PR)         | uat         |
| uat     | Pre-prod acceptance                  | qa (promotion PR)              | main        |
| main    | Production / release tags            | uat (promotion PR)             | tagged only |

All feature PRs MUST target `develop`. Never open a feature PR against
`qa`, `uat`, or `main`. Promotions happen via dedicated promotion PRs.
