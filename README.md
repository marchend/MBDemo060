# AcmeBank iOS

An iOS 17+ mobile banking app built with SwiftUI, featuring account management,
transaction history, fund transfers, and Okta OIDC authentication.

> **Status:** Bootstrap scaffold — Hello World shell. Feature development begins in
> follow-on stories.

## Quick Start

```bash
# Clone the repo, then:
./setup.sh
```

`setup.sh` installs [XcodeGen](https://github.com/yonaskolb/XcodeGen) via Homebrew
(if not already present), generates `AcmeBank.xcodeproj` from `project.yml`, and opens
the project in Xcode.

**Manual fallback** (for environments that block shell scripts):
```bash
brew install xcodegen
xcodegen generate
open AcmeBank.xcodeproj
```

## Running Tests

```bash
xcodebuild test \
  -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

## Tech Stack

| Item | Value |
|---|---|
| Platform | iOS 17+, Xcode 16+ |
| Language | Swift 5.10 |
| UI Framework | SwiftUI |
| Architecture | MVVM + Coordinator |
| Auth | Okta OIDC (`okta-mobile-swift`) |
| Project file | XcodeGen `project.yml` |

## Project Structure

```
AcmeBank/App/          — @main entry point + ContentView
AcmeBank/Resources/    — Assets, PrivacyInfo.xcprivacy
AcmeBankTests/         — Unit tests
project.yml            — XcodeGen source of truth
setup.sh               — One-shot post-clone setup
```

See [CLAUDE.md](CLAUDE.md) for full architecture docs, planned directory layout,
and the git branching model.
