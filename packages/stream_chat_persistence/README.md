# Official Chat Persistence Client for [Stream Chat](https://getstream.io/chat/)

<p align="center">
  <a href="https://getstream.io/chat/flutter/tutorial/"><img src="https://i.imgur.com/L4Mj8S2.png" alt="Flutter Chat" width="60%" /></a>
</p>

> The official Chat Persistence Client for Stream Chat, a service for
> building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_persistence.svg)](https://pub.dartlang.org/packages/stream_chat_persistence)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
[![Gitter](https://badges.gitter.im/GetStream/stream_chat_persistence.svg)](https://gitter.im/GetStream/stream-chat-flutter?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/CI/badge.svg?branch=master)
<img align="right" src="https://getstream.imgix.net/images/ios-chat-tutorial/iphone_chat_art@1x.png?auto=format,enhance" width="50%" />

This package provides a persistence client for fetching and saving chat data locally.
Stream Chat Persistence uses [Moor](https://github.com/simolus3/moor) as a disk cache.

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
