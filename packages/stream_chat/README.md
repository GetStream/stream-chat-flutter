# Official Dart Client for [Stream Chat](https://getstream.io/chat/)

>The official Dart client for Stream Chat, a service for building chat applications. This library can be used on any Dart project and on both mobile and web apps with Flutter.

[![Pub](https://img.shields.io/pub/v/stream_chat.svg)](https://pub.dartlang.org/packages/stream_chat)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
[![Gitter](https://badges.gitter.im/GetStream/stream-chat-flutter.svg)](https://gitter.im/GetStream/stream-chat-flutter?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/stream_flutter_workflow/badge.svg?branch=master)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/) 
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)

## Getting started

### Add dependency
Add this to your package's pubspec.yaml file, use the latest version [![Pub](https://img.shields.io/pub/v/stream_chat.svg)](https://pub.dartlang.org/packages/stream_chat)

```yaml
dependencies:
 stream_chat: ^latest-version
```

You should then run `flutter packages get`

## Example Project

There is a detailed Flutter example project in the `example` folder. You can directly run and play on it. 

## Setup API Client

First you need to instantiate a chat client. The Chat client will manage API call, event handling and manage the websocket connection to Stream Chat servers. You should only create the client once and re-use it across your application.

```dart
final client = StreamChatClient("stream-chat-api-key");
```

### Logging

By default the Chat Client will write all messages with level Warn or Error to stdout.

#### Change Logging Level

During development you might want to enable more logging information, you can change the default log level when constructing the client.

```dart 
final client = StreamChatClient("stream-chat-api-key", logLevel: Level.INFO);
```

#### Custom Logger

You can handle the log messages directly instead of have them written to stdout, this is very convenient if you use an error tracking tool or if you want to centralize your logs into one facility.

```dart
myLogHandlerFunction = (LogRecord record) {
  // do something with the record (ie. send it to Sentry or Fabric)
}

final client = StreamChatClient("stream-chat-api-key", logHandlerFunction: myLogHandlerFunction);
```

### Offline storage 

To add data persistance you can extend the class `ChatPersistenceClient` and pass an instance to the `StreamChatClient`.

```dart
class CustomChatPersistentClient extends ChatPersistenceClient {
...
}

final client = StreamChatClient(
  apiKey ?? kDefaultStreamApiKey,
  logLevel: Level.INFO,
)..chatPersistenceClient = CustomChatPersistentClient();
```

We provide an official persistent client in the [stream_chat_persistence](https://pub.dev/packages/stream_chat_persistence) package.

```dart
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.INFO,
  connectionMode: ConnectionMode.background,
);

final client = StreamChatClient(
  apiKey ?? kDefaultStreamApiKey,
  logLevel: Level.INFO,
)..chatPersistenceClient = chatPersistentClient;
```

## Contributing

### Code conventions

- Make sure that you run `dartfmt` before commiting your code
- Make sure all public methods and functions are well documented

### Running tests 

- run `flutter test`

### Releasing a new version

- update the package version on `pubspec.yaml` and `version.dart`

- add a changelog entry on `CHANGELOG.md`

- run `flutter pub publish` to publish the package

### Watch models and generate JSON code

JSON serialization relies on code generation; make sure to keep that running while you make changes to the library

```bash
flutter pub run build_runner watch
```
