# Official Flutter packages for [Stream Chat](https://getstream.io/chat/sdk/flutter/)

![Stream Chat Flutter SDK hero image](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/images/sdk_hero_v10.png)

[![CI](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml/badge.svg?branch=master)](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml)
[![Melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

V10 brings a modern redesign, a unified design system shared across all Stream SDK platforms, and improved developer experience.

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat SDK Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Documentation](https://getstream.io/chat/docs/sdk/flutter/)
- [Sample app](sample_app)

## What's New in V10

Version 10 is a major update to the Stream Chat Flutter SDK:

- **Modern redesign** — refreshed channel list, message list, composer, reactions, avatars, and media viewer with a cleaner, more polished default look.
- **Unified design system** — design tokens (colors, typography, spacing, icons) are now consistent across all Stream SDK platforms. Theming is rebuilt around `StreamTheme`, a Flutter `ThemeExtension` registered on `MaterialApp.theme`.
- **Cross-platform name alignment** — APIs and component names now match their iOS, Android, React, and React Native counterparts (e.g. `StreamMessageComposer`, `StreamChannelListItem`).
- **`StreamComponentFactory`** — a single customization entry point that replaces the scattered builder slots that previously lived on each widget.
- **Cookbook** — new task-oriented recipes for common customizations.

See the [V10 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration-guide-10-0/) for a full list of breaking changes and upgrade instructions.

## Features

The UI package ships an extensive set of performant and customizable widgets:

- Rich media messages with Markdown rendering
- Reactions
- Threads and quoted replies
- Typing and read indicators
- Channel and message lists
- Message composer with autocomplete triggers (`@` mentions, `/` commands)
- Image, video, and file uploads with previews and a built-in media gallery viewer
- Voice messages
- Polls
- Drafts
- Pinned messages
- Message reminders
- Message actions context menu (reply, edit, copy, pin, delete, flag, mute, block, and more)
- Message search
- Giphy support
- AI assistant streaming responses
- Push notifications (Firebase, APN, and Huawei)
- Offline storage and optimistic updates
- Static and live location sharing
- Localization
- and a lot more.

## Sample App

Check out the [`sample_app`](sample_app) in this repository — a fully functional messenger built with `stream_chat_flutter` that demonstrates the SDK's core features end to end. It is the recommended reference when wiring things up in your own app.

For more sample apps and demos, visit [GetStream/flutter-samples](https://github.com/GetStream/flutter-samples).

## Free for Makers

Stream is free for most side and hobby projects. To qualify, your project/company needs to have fewer than five team members and under $10,000 in monthly revenue.
For complete pricing details, visit our [Chat Pricing Page](https://getstream.io/chat/pricing/).

## Packages

Stream Chat Dart is a monorepo built using [Melos](https://docs.page/invertase/melos). Individual packages can be found in the `packages` directory; configuration and top-level commands live in `melos.yaml`.

The SDK is layered — each package builds on top of the previous:

### [`stream_chat`](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat)

The low-level client (LLC), a pure Dart package that wraps the Stream Chat API. Use it directly if you want to build your own UI and state layer.

### [`stream_chat_flutter_core`](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_flutter_core)

Provides the business logic, controllers, and builders required to integrate Stream Chat into a Flutter app, without shipping any UI of its own.

### [`stream_chat_flutter`](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_flutter)

The full UI SDK. Includes a set of reusable and customizable UI widgets on top of the core and low-level client packages. **This is the recommended starting point for most apps.**

### [`stream_chat_persistence`](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_persistence)

Provides a Drift-backed persistence client for offline storage. Plugs into any of the packages above.

### [`stream_chat_localizations`](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_localizations)

Provides a set of localizations for the UI SDK.

### Choosing the Right Package

We recommend using `stream_chat_flutter` for most apps. Unless your UI is completely different from the common industry standard, you should be able to customize the built-in widgets to match your needs.

- Use `stream_chat_flutter_core` if you need full UI control but want the data/state logic handled for you.
- Use `stream_chat` directly for maximum control over architecture, UI, and data.

You can also mix and match — it is common to use the UI SDK for most screens and drop down to the low-level client for specific operations.

## Getting Started

To get started, run `bootstrap` after cloning the project:

```shell
melos bootstrap
```

The best place to start is the [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/).
It teaches you how to use this SDK and shows how to make frequently required changes.

Every package folder also includes a fully functional `example` with setup instructions.

## Versioning Policy

All of the Stream Chat packages follow [semantic versioning](https://semver.org/):

- Bug fixes and behavior improvements cause a **patch** version bump.
- New features are shipped with an increased **minor** version.
- Incompatible API changes cause a **major** version increase.

Occasionally, the SDK can include visual changes (whitespace, color, sizing) in minor versions as we continuously improve the default look of our UI widgets.

See the [installation docs](https://getstream.io/chat/docs/sdk/flutter/basics/installation/) and the [releases page](https://github.com/GetStream/stream-chat-flutter/releases) for the full version history.

## We Are Hiring

We've recently closed a [$38 million Series B funding round](https://techcrunch.com/2021/03/04/stream-raises-38m-as-its-chat-and-activity-feed-apis-power-communications-for-1b-users/) and we keep actively growing.
Our APIs are used by more than a billion end-users, and you'll have a chance to make a huge impact on the product within a team of the strongest engineers all over the world.

Check out our current openings and apply via [Stream's website](https://getstream.io/team/#jobs).
