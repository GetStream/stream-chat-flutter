# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a monorepo for Stream Chat Flutter SDK built using [Melos](https://docs.page/invertase/melos). The repository contains multiple packages:

### Core Packages
- **`packages/stream_chat`** - Pure Dart low-level client for Stream Chat service
- **`packages/stream_chat_flutter_core`** - Business logic controllers and utilities for Flutter integration
- **`packages/stream_chat_flutter`** - Complete UI components library with chat widgets
- **`packages/stream_chat_persistence`** - Local persistence client using Drift (SQLite)
- **`packages/stream_chat_localizations`** - Localization files for UI components

### Sample Application
- **`sample_app/`** - Full-featured sample application demonstrating SDK usage

## Development Commands

### Setup
```bash
# Bootstrap the monorepo (run after cloning)
melos bootstrap
```

### Code Quality
```bash
# Run all static analysis checks
melos run lint:all

# Analyze code only
melos run analyze

# Format code
melos run format

# Check metrics
melos run metrics

# Dry-run pub publish
melos run lint:pub
```

### Testing
```bash
# Run all tests (Dart + Flutter)
melos run test:all

# Run only Dart tests
melos run test:dart

# Run only Flutter tests
melos run test:flutter

# Update golden files
melos run update:goldens
```

### Code Generation
```bash
# Generate all files (Dart + Flutter)
melos run generate:all

# Generate Dart files only
melos run generate:dart

# Generate Flutter files only
melos run generate:flutter
```

### Utilities
```bash
# Clean all Flutter projects
melos run clean:flutter

# Remove ignored files from coverage
melos run coverage:ignore-file
```

## Dependency Management

Dependencies are managed centrally through `melos.yaml`. To add or update dependencies:

1. Modify versions in `melos.yaml` 
2. Add new dependencies to both `melos.yaml` and individual `pubspec.yaml` files
3. Run `melos bootstrap` to apply changes

**Do not edit dependency versions in individual `pubspec.yaml` files directly.**

## Code Generation

The codebase uses several code generation tools:
- **Freezed** - For immutable data classes
- **JSON Serializable** - For JSON serialization
- **Build Runner** - For running code generators
- **Drift** - For database schema generation

Generated files have extensions: `.g.dart`, `.freezed.dart`

## Architecture Overview

### Package Dependencies
```
stream_chat_flutter
├── stream_chat_flutter_core
│   └── stream_chat
└── stream_chat_localizations

stream_chat_persistence
└── stream_chat
```

### Key Concepts
- **Client (`StreamChatClient`)** - Core chat client for API communication
- **Channel** - Represents a chat channel/conversation
- **Message** - Individual chat messages with attachments, reactions, etc.
- **User** - Chat participants
- **Controllers** - Business logic controllers in `flutter_core` package
- **Widgets** - Reusable UI components in `flutter` package

### Important Directories
- `lib/src/` - Source code for each package
- `test/` - Unit and widget tests
- `example/` - Example applications for each package
- `assets/` - Static assets (icons, images, animations)

## Testing Guidelines

- Widget tests use `flutter_test` framework
- Golden tests use `alchemist` package
- Mocking uses `mocktail` package
- Coverage reports are generated for all tests
- Tests are run with `--coverage` flag

## Platform Support

The SDK supports:
- Android
- iOS  
- Web
- Windows
- macOS
- Linux

## Linting Rules

The project uses comprehensive Dart linting rules defined in `analysis_options.yaml`, including:
- Prefer single quotes
- Require const constructors where possible
- Enforce public API documentation
- 80-character line limit
- Comprehensive null safety rules

## Key Architecture Files

- `melos.yaml` - Monorepo configuration and script definitions
- `analysis_options.yaml` - Linting and analysis rules
- `pubspec.yaml` files - Package configurations (versions managed by Melos)
- `build.yaml` - Code generation configuration