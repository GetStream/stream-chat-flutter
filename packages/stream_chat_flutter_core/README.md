# Official Core Flutter Package for [Stream Chat](https://getstream.io/chat/sdk/flutter/)

> The official Flutter core components for Stream Chat, a service for building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_flutter_core.svg)](https://pub.dartlang.org/packages/stream_chat_flutter_core)
[![CI](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml/badge.svg?branch=master)](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Documentation](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter-core/introduction/)
- [V10 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration-guide-10-0/)

## Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_flutter_core/changelog) to see the latest changes in the package.

## Overview

`stream_chat_flutter_core` provides the business logic, controllers, and builders required to integrate Stream Chat into a Flutter app — without shipping any UI of its own. It sits between the low-level client ([`stream_chat`](https://pub.dev/packages/stream_chat)) and the full UI SDK ([`stream_chat_flutter`](https://pub.dev/packages/stream_chat_flutter)).

Use this package when your application requires a UI that is completely different from what `stream_chat_flutter` provides — you implement your own widgets on top of these controllers without writing the data fetching, pagination, and state management logic yourself. It also has very few dependencies, making it suitable for apps with strict build constraints.

## Getting Started

### Add Dependency

Add this to your `pubspec.yaml`, using the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_flutter_core.svg)](https://pub.dartlang.org/packages/stream_chat_flutter_core):

```yaml
dependencies:
  stream_chat_flutter_core: ^10.0.0
```

Then run:

```shell
flutter pub get
```

This package requires no custom setup on any platform since it has no platform-specific dependencies.

## Example App

This repository includes a fully functional example app with setup instructions.
The example is available under the [example](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_flutter_core/example) folder.

## Controllers

The package provides a set of controllers that handle the business logic of chat. You can use them together with the UI widgets in `stream_chat_flutter`, or build your own UI on top of them:

- `StreamChannelListController` — manages a paged list of channels
- `StreamMessageSearchListController` — manages message search results
- `StreamUserListController` — manages a paged list of users
- `StreamMemberListController` — manages a paged list of channel members
- `StreamThreadListController` — manages a list of threads
- `StreamDraftListController` — manages draft messages
- `StreamMessageReminderListController` — manages message reminders
- `StreamPollController` — manages poll state and voting
- `StreamMessageComposerController` — manages message composition state

## Utilities

- `BetterStreamBuilder<T>` — a `StreamBuilder` that only rebuilds when data actually changes
- `LazyLoadScrollView` — triggers a callback when the user scrolls near the end of a list
- `PagedValueNotifier<Key, Value>` — base class for all list controllers
- `PagedValueListenableBuilder<Key, Value>` — builds UI from a `PagedValueNotifier`

## Contributing

We welcome code changes that improve this library or fix a problem. Please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on GitHub.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
