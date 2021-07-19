# Official Flutter SDK for [Stream Chat](https://getstream.io/chat/)

![](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/images/sdk_hero_v4.png)

> The official Flutter components for Stream Chat, a service for
> building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_flutter.svg)](https://pub.dartlang.org/packages/stream_chat_flutter)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/stream_flutter_workflow/badge.svg?branch=master)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/) 
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)


### Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_flutter/changelog) to see the latest changes in the package.

## Flutter Chat Tutorial

The best place to start is the [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/).
It teaches you how to use this SDK and also shows how to make frequently required changes.

## Example App

This repo includes a fully functional example app with setup instructions.
The example is available under the [example](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_flutter/example) folder.

## Add dependency
Add this to your package's pubspec.yaml file, use the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_flutter.svg)](https://pub.dartlang.org/packages/stream_chat_flutter)
```yaml
dependencies:
 stream_chat_flutter: ^latest_version
```

You should then run `flutter packages get`

### Android

All set ✅

### iOS

The library uses [flutter file picker plugin](https://github.com/miguelpruivo/flutter_file_picker) to pick
files from the os.
Follow [this wiki](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#ios) to fulfill iOS requirements.

We also use [video_player](https://pub.dev/packages/video_player) to reproduce videos. Follow [this guide](https://pub.dev/packages/video_player#installation) to fulfill the requirements.

To pick images from the camera, we use the [image_picker](https://pub.dev/packages/image_picker) plugin.
Follow [these instructions](https://pub.dev/packages/image_picker#ios) to check the requirements.

### Troubleshooting

It may happen that you have some problems building the app.
If it seems related to the [flutter file picker plugin](https://github.com/miguelpruivo/flutter_file_picker) make sure to check [this page](https://github.com/miguelpruivo/flutter_file_picker/wiki/Troubleshooting) 

## Docs

This package provides UI components required for integrating Stream Chat into your application.
Alternatively, you may use the core package [stream_chat_flutter_core](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_flutter_core) which allows more customisation and provides business logic but no UI components.
If you require the maximum amount of control over the API, please use the low level client package: [stream_chat](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat).

### UI Components

These are the available Widgets that you can use to build your application UI.
Every widget uses the `StreamChat` or `StreamChannel` widgets to manage the state and communicate with Stream services.

- [ChannelHeader](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ChannelHeader-class.html)
- [ChannelImage](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ChannelImage-class.html)
- [ChannelListView](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ChannelListView-class.html)
- [ChannelName](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ChannelName-class.html)
- [ChannelPreview](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ChannelPreview-class.html)
- [MessageInput](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/MessageInput-class.html)
- [MessageListView](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/MessageListView-class.html)
- [MessageWidget](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/MessageWidget-class.html)
- [StreamChatTheme](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/StreamChatTheme-class.html)
- [ThreadHeader](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ThreadHeader-class.html)
- ...

### Customizing styles

The Flutter SDK comes with a fully designed set of widgets that you can customize to fit with your application style and typography.
Changing the theme of Chat widgets works in a very similar way that `MaterialApp` and `Theme` do.

Out of the box, all chat widgets use their default styling, and there are two ways to change the styling:

  1. Initialize the `StreamChatTheme` from your existing `MaterialApp` style
  ```dart
  class MyApp extends StatelessWidget {
    final StreamChatClient client;

    MyApp(this.client);

    @override
    Widget build(BuildContext context) {
      final theme = ThemeData(
        primarySwatch: Colors.green,
      );

      return MaterialApp(
        theme: theme,
        builder: (context, child) => StreamChat(
         child: child,
         client: client,
         streamChatThemeData: StreamChatThemeData.fromTheme(theme),
        ),
        home: ChannelListPage(),
        );
    }
  }
  ```

  2. Construct a custom theme and provide all the customizations needed
  ```dart
  class MyApp extends StatelessWidget {
    final StreamChatClient client;

    MyApp(this.client);

    @override
    Widget build(BuildContext context) {
      final theme = ThemeData(
        primarySwatch: Colors.green,
      );

      return MaterialApp(
        theme: theme,
        builder: (context, child) => StreamChat(
         child: child,
         client: client,
         streamChatThemeData: StreamChatThemeData.fromTheme(theme).copyWith(
            ownMessageTheme: MessageTheme(
            messageBackgroundColor: Colors.black,
            messageText: TextStyle(
              color: Colors.white,
            ),
            avatarTheme: AvatarTheme(
              borderRadius: BorderRadius.circular(8),
            ),
            ),
         ),
        ),
        home: ChannelListPage(),
        );
    }
  }
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

We provide an official persistent client in the (stream_chat_persistence)[https://pub.dev/packages/stream_chat_persistence] package.

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

We welcome code changes that improve this library or fix a problem,
please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on Github.
We are pleased to merge your code into the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
