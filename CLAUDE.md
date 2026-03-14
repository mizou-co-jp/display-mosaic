# CLAUDE.md

## Development Rules

1. **Always create a branch and open a PR** — Never commit directly to `main`. Create a feature branch (e.g., `feature/xxx`, `fix/xxx`) and open a Pull Request for review.
2. **Tag releases on the branch** — When releasing, tag the commit with the version number (e.g., `v1.0.1`) before merging.

## Project Overview

- macOS menu bar app that applies mosaic effects to the entire display
- Bundle ID: `jp.co.mizou.DisplayMosaic`
- Minimum deployment target: macOS 13.0 (Ventura)
- Pure AppKit + SwiftUI hybrid (no storyboards)
- Entry point: `main.swift` (not SwiftUI App lifecycle)

## Build

```bash
xcodebuild -scheme DisplayMosaic -configuration Release build
```

## Key Architecture Notes

- `NSApplication.delegate` is `weak` — the `AppDelegate` must be held by a global variable in `main.swift`
- Overlay windows must use `orderOut()` instead of `close()` to avoid process termination
- Menu bar icon uses a template image from Asset Catalog (`MenuBarIcon`)
- Login item uses `SMAppService.mainApp`
