# Bootstrap Plan — AcmeBank iOS

## In scope (this PR)

### Project name + tech stack
- **App Name:** AcmeBank
- **Platform:** iOS 17+, Swift 5.10
- **UI Framework:** SwiftUI (`@main` App entry point)
- **Architecture:** MVVM + Coordinator (deferred to future PRs — bootstrap uses a flat entry)
- **Test runner:** XCTest (unit test target)
- **Project file:** XcodeGen `project.yml` (no hand-crafted .xcodeproj)
- **Bundle ID:** `com.acmebank.mobile`
- **Minimum Xcode:** 16.0

### Directory structure (bootstrap only)

```
AcmeBank/                          ← source root
├── App/
│   ├── AcmeBankApp.swift          ← @main SwiftUI entry
│   └── ContentView.swift          ← Hello World placeholder view
├── Resources/
│   ├── Assets.xcassets/
│   │   ├── Contents.json
│   │   └── AppIcon.appiconset/
│   │       └── Contents.json
│   └── PrivacyInfo.xcprivacy
└── AcmeBank.entitlements

AcmeBankTests/
└── AcmeBankTests.swift            ← one trivial smoke test

project.yml                        ← XcodeGen spec
.gitignore
setup.sh
bootstrap_plan.md
CLAUDE.md
AGENT.md
README.md
```

### Files this PR creates
| File | Purpose |
|---|---|
| `project.yml` | XcodeGen spec — produces `AcmeBank.xcodeproj` |
| `AcmeBank/App/AcmeBankApp.swift` | `@main` SwiftUI entry point |
| `AcmeBank/App/ContentView.swift` | Hello World placeholder view |
| `AcmeBank/Resources/Assets.xcassets/Contents.json` | Asset catalog root |
| `AcmeBank/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json` | AppIcon stub (required by actool) |
| `AcmeBank/Resources/PrivacyInfo.xcprivacy` | Privacy manifest (UserDefaults) |
| `AcmeBank/AcmeBank.entitlements` | Keychain access groups stub |
| `AcmeBankTests/AcmeBankTests.swift` | Smoke test — proves test runner works |
| `CLAUDE.md` | Project context for AI agents |
| `AGENT.md` | Identical to CLAUDE.md |
| `README.md` | Human-readable project overview |
| `.gitignore` | Standard iOS/XcodeGen ignores |
| `setup.sh` | One-shot materialise + open script |

### How to run locally
```bash
./setup.sh          # installs xcodegen if missing, generates .xcodeproj, opens in Xcode
# Manual fallback:
brew install xcodegen && xcodegen generate
open AcmeBank.xcodeproj
```

### How to run tests
```bash
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

### Definition of Hello World
The app launches and displays a single centered screen with the text **"AcmeBank"** on a system background. The unit test target compiles and links against the app module by instantiating `ContentView`.

---

## Out of scope — deferred to future work

- **Authentication (Okta OIDC / `okta-mobile-swift`)** — future PR
- **MVVM + Coordinator pattern** (AppCoordinator, LoginCoordinator, TabBarCoordinator, etc.) — future PR
- **RootView auth-state switching** (login vs. tab bar) — future PR
- **Networking layer** (APIClient, APIRouter, APIError, RequestInterceptor, URLSession) — future PR
- **Domain models** (Account, Transaction, Customer, TransferRequest) — future PR
- **Repository protocols** (AccountRepositoryProtocol, TransactionRepositoryProtocol, etc.) — future PR
- **Data layer** — Remote API repositories and Mock repositories — future PR
- **Features** — Login, Home, Accounts, Transfer, Cards screens — future PR
- **Design system** (Colors, Typography, Assets) — future PR
- **Internal notifications** (AppNotification, NotificationPublisher, NotificationKey) — future PR
- **Extensions** (Decimal+Currency, Date+Greeting, String+Initials) — future PR
- **CI / xcconfig / SwiftLint configuration** — future PR
- **XCUITest target** (AcmeBankUITests) — future PR; no UI-testing target in bootstrap
- **Okta.plist / Okta.plist.example** — future PR
- **Localizable.strings** — future PR
- **80% unit-test coverage requirement** — applies to feature stories, not bootstrap
