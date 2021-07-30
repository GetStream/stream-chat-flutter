# Official Chat Persistence Client for [Stream Chat](https://getstream.io/chat/)

> The official Chat Persistence Client for Stream Chat, a service for
> building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_persistence.svg)](https://pub.dartlang.org/packages/stream_chat_persistence)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/stream_flutter_workflow/badge.svg?branch=master)


**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/) 
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)
- [Flutter Offline Docs](https://getstream.io/chat/docs/flutter-dart/flutter_offline/)

This package provides a persistence client for fetching and saving chat data locally.
Stream Chat Persistence uses [Moor](https://github.com/simolus3/moor) as a disk cache.

### Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_persistence/changelog) to see the latest changes in the package.

## Add dependency
Add this to your package's pubspec.yaml file, use the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_persistence.svg)](https://pub.dartlang.org/packages/stream_chat_persistence)
```yaml
dependencies:
 stream_chat_persistence: ^latest_version
```

You should then run `flutter packages get`

## Usage
The usage is pretty simple.
1. Create a new instance of StreamChatPersistenceClient providing `logLevel` and `connectionMode`.
```dart
final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.INFO,
  connectionMode: ConnectionMode.background,
);
```
2. Pass the instance to the official Stream chat client.
```dart
  final client = StreamChatClient(
    apiKey ?? kDefaultStreamApiKey,
    logLevel: Level.INFO,
  )..chatPersistenceClient = chatPersistentClient;
```

And you are ready to go...

## Flutter Web

Due to Moor web (for offline storage) you need to include the sql.js library:

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

You can grab the latest version of sql-wasm.js and sql-wasm.wasm [here](https://github.com/sql-js/sql.js/releases) and copy them into your `/web` folder.

## Contributing

We welcome code changes that improve this library or fix a problem,
please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on Github.
We are pleased to merge your code into the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
