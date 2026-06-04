# Official Persistence Client for [Stream Chat](https://getstream.io/chat/sdk/flutter/)

> The official persistence client for Stream Chat, a service for building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_persistence.svg)](https://pub.dartlang.org/packages/stream_chat_persistence)
[![CI](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml/badge.svg?branch=master)](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Documentation](https://getstream.io/chat/docs/sdk/flutter/)
- [V10 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration-guide-10-0/)

### Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_persistence/changelog) to see the latest changes in the package.

## Overview

This package provides a persistence client for fetching and saving chat data locally. It is powered by [Drift](https://github.com/simolus3/drift) (SQLite) and plugs into any of the Stream Chat Flutter packages to add offline storage and optimistic UI updates.

## Add Dependency

Add this to your `pubspec.yaml`, using the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_persistence.svg)](https://pub.dartlang.org/packages/stream_chat_persistence):

```yaml
dependencies:
  stream_chat_persistence: ^latest_version
```

Then run:

```shell
flutter pub get
```

## Usage

1. Create a new instance of `StreamChatPersistenceClient`, providing `logLevel` and `connectionMode`:

```dart
final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.INFO,
  connectionMode: ConnectionMode.regular,
);
```

2. Pass the instance to the `StreamChatClient`:

```dart
final client = StreamChatClient(
  apiKey,
  logLevel: Level.INFO,
)..chatPersistenceClient = chatPersistentClient;
```

And you are ready to go.

## Flutter Web

Due to Drift's web backend you need to include the sql.js library. Add the following to your `web/index.html`:

```html
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <script defer src="sql-wasm.js"></script>
    <script defer src="main.dart.js" type="application/javascript"></script>
</head>
<body></body>
</html>
```

You can grab the latest version of `sql-wasm.js` and `sql-wasm.wasm` [here](https://github.com/sql-js/sql.js/releases) and copy them into your `/web` folder.

## Contributing

We welcome code changes that improve this library or fix a problem. Please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on GitHub.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
