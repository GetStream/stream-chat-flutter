# Official Low-Level Dart Client for [Stream Chat](https://getstream.io/chat/)

> The official low-level Dart client for Stream Chat, a service for building chat applications. This library can be used on any Dart project and on both mobile and web apps with Flutter.

[![Pub](https://img.shields.io/pub/v/stream_chat.svg)](https://pub.dartlang.org/packages/stream_chat)
[![CI](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml/badge.svg?branch=master)](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Documentation](https://getstream.io/chat/docs/sdk/flutter/)
- [V10 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration-guide-10-0/)

## Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat/changelog) to see the latest changes in the package.

## Overview

`stream_chat` is the low-level client (LLC) of the Stream Chat Flutter SDK. It wraps the Stream Chat API and gives you the most control over UI, data, and architecture — at the cost of more plumbing. If you want built-in Flutter widgets, see [`stream_chat_flutter`](https://pub.dev/packages/stream_chat_flutter). If you want controllers and business logic without UI, see [`stream_chat_flutter_core`](https://pub.dev/packages/stream_chat_flutter_core).

> **Note:** This is a front-end client SDK intended for use in Dart/Flutter applications. There are no plans to provide a backend (server-side) Dart SDK — backend integrations should use the [Stream server-side SDKs](https://getstream.io/chat/docs/) available for Node.js, Python, Go, and other platforms.

## Getting Started

### Add dependency

Add this to your `pubspec.yaml`, using the latest version [![Pub](https://img.shields.io/pub/v/stream_chat.svg)](https://pub.dartlang.org/packages/stream_chat):

```yaml
dependencies:
  stream_chat: ^10.0.0
```

Then run:

```shell
dart pub get
```

## Example Project

There is a detailed example project in the [`example`](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat/example) folder. You can run it directly to explore the API.

## Setup API Client

First, instantiate a chat client. The client manages API calls, event handling, and the WebSocket connection to Stream Chat servers. You should create it once and re-use it across your application.

```dart
final client = StreamChatClient('stream-chat-api-key');
```

### Logging

By default, the chat client writes all messages with level Warn or Error to stdout.

#### Change Logging Level

During development you might want to enable more logging information:

```dart
final client = StreamChatClient('stream-chat-api-key', logLevel: Level.INFO);
```

#### Custom Logger

You can handle log messages directly instead of writing them to stdout — useful for error tracking tools:

```dart
myLogHandlerFunction = (LogRecord record) {
  // do something with the record (e.g. send it to Sentry or Firebase Crashlytics)
};

final client = StreamChatClient(
  'stream-chat-api-key',
  logHandlerFunction: myLogHandlerFunction,
);
```

### Offline Storage

To add data persistence, extend `ChatPersistenceClient` and pass an instance to `StreamChatClient`:

```dart
class CustomChatPersistentClient extends ChatPersistenceClient {
  // ...
}

final client = StreamChatClient(
  apiKey,
  logLevel: Level.INFO,
)..chatPersistenceClient = CustomChatPersistentClient();
```

We provide an official persistence client in the [`stream_chat_persistence`](https://pub.dev/packages/stream_chat_persistence) package:

```dart
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.INFO,
  connectionMode: ConnectionMode.background,
);

final client = StreamChatClient(
  apiKey,
  logLevel: Level.INFO,
)..chatPersistenceClient = chatPersistentClient;
```

## Contributing

We welcome code changes that improve this library or fix a problem. Please make sure to follow all best practices and add tests where applicable before submitting a Pull Request on GitHub.

### Code Conventions

- Make sure all public methods and functions are well documented.

### Running Tests

```shell
dart test
```

### Code Generation

JSON serialization relies on code generation. Keep it running while you make changes:

```shell
dart run build_runner watch
```
