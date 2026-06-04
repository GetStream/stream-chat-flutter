# Official Flutter UI SDK for [Stream Chat](https://getstream.io/chat/sdk/flutter/)

![](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/images/sdk_hero_v10.png)

> The official Flutter UI components for Stream Chat, a service for building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_flutter.svg)](https://pub.dartlang.org/packages/stream_chat_flutter)
[![CI](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml/badge.svg?branch=master)](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [UI Docs](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter/introduction/)
- [V10 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration-guide-10-0/)

### Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_flutter/changelog) to see the latest changes in the package.

## Overview

`stream_chat_flutter` is the full UI SDK — a set of reusable and customizable Flutter widgets built on top of [`stream_chat_flutter_core`](https://pub.dev/packages/stream_chat_flutter_core) and the low-level client [`stream_chat`](https://pub.dev/packages/stream_chat). It targets Android, iOS, Web, macOS, Windows, and Linux from a single Dart codebase.

**This is the recommended starting point for most apps.**

### Features

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

## Flutter Chat Tutorial

The best place to start is the [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/).
It teaches you how to use this SDK and also shows how to make frequently required changes.

## Example App

This repository includes a fully functional example app with setup instructions.
The example is available under the [example](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_flutter/example) folder.

## Add Dependency

Add this to your `pubspec.yaml`, using the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_flutter.svg)](https://pub.dartlang.org/packages/stream_chat_flutter):

```yaml
dependencies:
  stream_chat_flutter: ^latest_version
```

Then run:

```shell
flutter pub get
```

### Android

The package uses [`photo_manager`](https://pub.dev/packages/photo_manager) to access the device's photo library.
Follow [this wiki](https://pub.dev/packages/photo_manager#android-10-q-29) to fulfill the Android requirements.
You need to take additional steps if you are targeting Android 13. Read [this section](https://pub.dev/packages/photo_manager#android-13-api-33-extra-configs) for more information.

### iOS

The library uses the [file picker plugin](https://github.com/miguelpruivo/flutter_file_picker) to pick files from the OS.
Follow [this wiki](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#ios) to fulfill iOS requirements.

We also use [`video_player`](https://pub.dev/packages/video_player) to play videos. Follow [this guide](https://pub.dev/packages/video_player#installation) to fulfill the requirements.

To pick images from the camera, we use the [`image_picker`](https://pub.dev/packages/image_picker) plugin.
Follow [these instructions](https://pub.dev/packages/image_picker#ios) to check the requirements.

### Web

Edit your `index.html` and add the following to the `<body>` tag to allow the SDK to override the right-click behaviour:

```html
<body oncontextmenu="return false;">
```

### macOS

You need to add the following [entitlement](https://docs.flutter.dev/development/platform-integration/desktop#entitlements-and-the-app-sandbox):

```xml
<key>com.apple.security.network.client</key>
<true/>
```

For file picking on macOS, see the [`file_selector`](https://pub.dev/packages/file_selector#macos) package.

### Troubleshooting

If you encounter build issues related to the file picker, check the [troubleshooting page](https://github.com/miguelpruivo/flutter_file_picker/wiki/Troubleshooting).

## UI Components

These are the key widgets available to build your application UI. Every widget uses the `StreamChat` or `StreamChannel` widgets to manage state and communicate with Stream services.

- [StreamChannelListView](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter/channel-list-view/)
- [StreamChannelListItem](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter/channel-list-view/)
- [StreamChannelHeader](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter/stream-channel-header/)
- [StreamMessageListView](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter/message-list-view/)
- [StreamMessageWidget](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter/message-list-view/)
- [StreamMessageComposer](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter/message-composer/)
- ...

## Theming

The Flutter SDK ships with a fully designed set of widgets that you can customize to match your application style.

Starting with V10, theming uses `StreamTheme` — a Flutter `ThemeExtension` registered on `MaterialApp`:

```dart
MaterialApp(
  theme: ThemeData(
    brightness: Brightness.light,
    extensions: [StreamTheme.light()],
  ),
  darkTheme: ThemeData(
    brightness: Brightness.dark,
    extensions: [StreamTheme.dark()],
  ),
  home: StreamChat(
    client: client,
    child: const MyHomePage(),
  ),
)
```

If no `StreamTheme` is provided, a default theme is automatically created based on `Theme.of(context).brightness`.

### Customizing Colors

Set `brand` and `chrome` color swatches on `StreamColorScheme` to customize the palette — the SDK automatically derives accent and background colors:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      StreamTheme(
        brightness: Brightness.light,
        colorScheme: StreamColorScheme.light(
          brand: StreamColorSwatch.fromColor(Colors.indigo),
          chrome: StreamColorSwatch.fromColor(Colors.blueGrey),
        ),
      ),
    ],
  ),
  home: MyHomePage(),
)
```

See the [Theming](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter/stream-chat-and-theming/) page for full details.

### Customizing Widgets

Widget-level customization is done through [`StreamComponentFactory`](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter/customizing-widgets/) — a single entry point for overriding individual builders across the UI SDK.

## Offline Storage

To add data persistence, use the official [`stream_chat_persistence`](https://pub.dev/packages/stream_chat_persistence) package:

```dart
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.INFO,
  connectionMode: ConnectionMode.regular,
);

final client = StreamChatClient(
  apiKey,
  logLevel: Level.INFO,
)..chatPersistenceClient = chatPersistentClient;
```

## Contributing

We welcome code changes that improve this library or fix a problem. Please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on GitHub.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
