# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **Before writing or reviewing code, read [`STYLE_GUIDE.md`](STYLE_GUIDE.md).** It is
> the source of truth for coding conventions, documentation style, testing, changelog
> policy, and repo-specific rules that diverge from the Flutter / Dart defaults. This
> file is a repo overview; the style guide is the rulebook.

## Overview

This is a Dart/Flutter monorepo for Stream Chat's official Flutter SDK, managed with [Melos](https://pub.dev/packages/melos). All packages live under `packages/`.

## Common Commands

### Setup
```bash
melos bootstrap          # Fetch and link all dependencies (equivalent to pub get for all packages)
```

### Testing
```bash
melos run test:all       # Run all Dart & Flutter tests
melos run test:dart      # Run Dart-only tests
melos run test:flutter   # Run Flutter tests
# Run tests in a specific package:
cd packages/stream_chat_flutter && flutter test
cd packages/stream_chat_flutter && flutter test test/src/path/to/test_file.dart
```

See [`TESTING.md`](TESTING.md) for guidance on writing effective tests.

### Golden Tests
```bash
melos run update:goldens    # Regenerate all golden image files
# In CI, CI goldens are used; locally, platform goldens are used (configured via alchemist)
```

### Linting & Formatting
```bash
melos run lint:all       # Run analyze + format
melos run analyze        # Run dart analyze --fatal-infos on all packages
melos run format   # Check formatting (page width: 120)
```

### Code Generation
```bash
melos run generate:all      # Run build_runner for all packages
melos run generate:flutter  # Run build_runner for Flutter packages only
melos run generate:dart     # Run build_runner for Dart packages only
```

### Versioning
```bash
melos run version:update    # Regenerate version.dart from pubspec.yaml (runs automatically after bootstrap)
```

## Package Architecture

The SDK is layered — each package builds on top of the previous:

```
stream_chat                    # Pure Dart, no Flutter dependency
  └── stream_chat_persistence  # Local disk cache using Drift (optional)
      └── stream_chat_flutter_core  # Flutter business logic, no UI
          └── stream_chat_flutter  # Full UI component library
              └── stream_chat_localizations  # i18n for UI components
```

### `stream_chat`
Low-level Dart client. Key types:
- `StreamChatClient` — central API client, manages WebSocket, REST, and state
- `Channel` — represents a chat channel, has its own state and streaming APIs
- Models in `lib/src/core/models/`: `Message`, `User`, `Member`, `Reaction`, `Poll`, `Event`, `Attachment`, `Draft`, etc.
- Generated code (`.g.dart`, `.freezed.dart`) for JSON serialization/immutable models — do not edit manually

### `stream_chat_flutter_core`
Business logic layer. Key types:
- `StreamChatCore` — root widget, manages app lifecycle, WebSocket reconnection, and connectivity
- `StreamChannel` — provides a `Channel` to the widget tree via `StreamChannel.of(context)`
- `PagedValueNotifier<Key, Value>` — base class for all list controllers
- Controllers: `StreamChannelListController`, `StreamMessageListController` (via `MessageListCore`), `StreamUserListController`, `StreamMemberListController`, `StreamThreadListController`, `StreamDraftListController`, `StreamMessageReminderListController`, `StreamPollController`
- `BetterStreamBuilder<T>` — efficient StreamBuilder that only rebuilds when data changes

### `stream_chat_flutter`
Full UI package. Key architectural points:

**Root widget hierarchy:**
`StreamChat` → `StreamChatTheme` → `StreamChatConfiguration` → `StreamChatCore` → app content

**Theming:** `StreamChatThemeData` (accessed via `StreamChatTheme.of(context)`) contains per-component theme data objects. Components read their theme from context. `StreamChatConfigurationData` holds non-theme UI config.

**Widget tree integration pattern:**
- `StreamChat.of(context)` — get the chat state (current user, client)
- `StreamChannel.of(context)` — get the current channel state
- `StreamChatTheme.of(context)` — get current theme data

**Key UI components:**
- `StreamChannelListView` + `StreamChannelListTile` — channel list using `StreamChannelListController`
- `StreamMessageListView` — message list with floating date dividers, unread indicators, thread separators
- `StreamMessageComposer` (full-featured) / `StreamChatMessageInput` (new design system, UI-only) — message composition
- `StreamMessageWidget` — renders individual messages with attachments, reactions, threads
- Scroll views in `lib/src/scroll_view/` — generic paged scroll views for channels, threads, members, users, drafts, polls

**New design system components** (`lib/src/components/`):
- `StreamUserAvatar`, `StreamChannelAvatar`, `StreamUserAvatarGroup` — avatar components; these are chat-domain wrappers around the base components in `stream_core_flutter`
- `StreamChatMessageInput` — new composer using `MessageComposerFactory` for custom layouts

**Golden tests:** Use `alchemist` package. Platform goldens used locally, CI goldens used in CI (detected via `CI`/`GITHUB_ACTIONS` env vars). Goldens stored alongside tests in `goldens/` subdirectories.

### `stream_chat_localizations`
Provides `StreamChatLocalizations` — Flutter localizations delegate with translations for all UI strings.

### `stream_chat_persistence`
Optional local persistence using Drift (SQLite). Implements `ChatPersistenceClient` from `stream_chat`.

## Code Style

- Line length: **120 characters** (configured in `analysis_options.yaml`)
- Imports: always use package imports (`always_use_package_imports`), not relative imports
- All public APIs **must** have doc comments (`public_member_api_docs`)
- Sort constructors first, unnamed constructors before named
- Prefer `const` constructors, `final` locals, single quotes
- Trailing commas: `preserve` (formatter setting)
- Generated files (`.g.dart`, `.freezed.dart`) are excluded from analysis

## PR & Commit Conventions

PR titles follow [Conventional Commits](https://www.conventionalcommits.org/):
- `fix(scope): description` — bug fix
- `feat(scope): description` — new feature
- `refactor(scope)!: description` — breaking change
- `chore(scope): description`, `docs:`, `test:`, etc.

After modifying any package, update its `CHANGELOG.md`.

## Figma Designs

UI designs for this SDK are in the [Chat SDK Design System](https://www.figma.com/design/Us73erK1xFNcB5EH3hyq6Y/Chat-SDK-Design-System) Figma project. Use the Figma MCP server to look up designs when implementing or updating UI components.

## `stream_core_flutter` (external sibling repo)

Basic UI components that can be shared across Stream products live in the `stream_core_flutter` package in the **stream-core-flutter** repository (a sibling repo, not inside this monorepo). These components:
- Never depend on chat domain models (`Channel`, `Message`, `User`, etc.)
- Provide primitive building blocks: avatars, layout primitives, theming tokens, etc.

Components in this repo can be wrappers around those base components, adding chat domain models and extra logic on top. For example, `StreamChannelAvatar` wraps the base `StreamAvatarGroup` from `stream_core_flutter` and adds channel-specific member resolution logic.

`stream_core_flutter` types used here are re-exported via a `show` allowlist in `lib/stream_chat_flutter.dart`. When adding a new type from `stream_core_flutter`, add it to that allowlist.

## Dependency Management

Dependencies are centrally managed in `melos.yaml` under `command.bootstrap.dependencies`. Do **not** edit version constraints directly in individual `pubspec.yaml` files — update `melos.yaml` and run `melos bootstrap`.

> Note: `stream_chat_flutter` uses a local path dependency to `stream_core_flutter` (pointing to the sibling repo) when making changes to both repos together. Use a git dependency when no local changes to `stream_core_flutter` are needed.
