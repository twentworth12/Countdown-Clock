# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI iOS application called "Bougie Countdown Clock" built with Xcode. It's a basic SwiftData-powered app that manages a list of timestamped items.

## Architecture

- **App Entry Point**: `Bougie_Countdown_ClockApp.swift` - Main app struct with SwiftData ModelContainer setup
- **Main View**: `ContentView.swift` - NavigationSplitView with list/detail interface for managing items
- **Data Model**: `Item.swift` - SwiftData model with a single timestamp property
- **Testing**: Uses Swift Testing framework (not XCTest)

The app uses SwiftData for persistence with a ModelContainer configured for the `Item` model. The main interface is a NavigationSplitView with CRUD operations for timestamped items.

## Development Commands

This is an Xcode project, so development happens through Xcode IDE:

- **Build**: Use Xcode's build system (⌘+B) or `xcodebuild`
- **Run**: Use Xcode's run system (⌘+R) or iOS Simulator
- **Test**: Use Xcode's test system (⌘+U) or `xcodebuild test`

## Testing

- Uses Swift Testing framework (import Testing)
- Test files are in `Bougie Countdown ClockTests/` directory
- UI tests are in `Bougie Countdown ClockUITests/` directory
- Main test file: `Bougie_Countdown_ClockTests.swift`

## Key Technologies

- SwiftUI for UI
- SwiftData for data persistence
- Swift Testing for unit tests
- NavigationSplitView for the main interface
- ModelContainer for data management