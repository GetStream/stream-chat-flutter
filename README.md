# Official Flutter SDK for [Stream Chat](https://getstream.io/chat/)

<p align="center">
  <a href="https://getstream.io/tutorials/ios-chat/"><img src="https://i.imgur.com/L4Mj8S2.png" alt="Flutter Chat" width="60%" /></a>
</p>

> The official Flutter components for Stream Chat, a service for
> building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_flutter.svg)](https://pub.dartlang.org/packages/stream_chat_flutter)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
[![Gitter](https://badges.gitter.im/GetStream/stream-chat-flutter.svg)](https://gitter.im/GetStream/stream-chat-flutter?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

<img align="right" src="https://getstream.imgix.net/images/ios-chat-tutorial/iphone_chat_art@1x.png?auto=format,enhance" width="50%" />

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/) 
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)

## Flutter Chat Tutorial

The best place to start is the [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/).
It teaches you how to use this SDK and also shows how to make frequently required changes.

## Example App

This repo includes a fully functional example app with setup instructions.
The example is available under the [example](https://github.com/GetStream/stream-chat-flutter/tree/master/example) folder.

## Add dependency

```yaml
dependencies:
 stream_chat_flutter: ^0.1.21
```

You should then run `flutter packages get`

### Alpha version

Use version `^0.2.0-alpha+1` to use the latest available version.

Note that this is still an alpha version. There may be some bugs, and the API can change in breaking ways.

Thanks to whoever tries these versions and reports bugs or suggestions.

### Android

All set ✅

### iOS

The library uses [flutter file picker plugin](https://github.com/miguelpruivo/flutter_file_picker) to pick
files from the os.
Follow [this wiki](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#ios) to fulfill iOS requirements.

We also use [video_player](https://pub.dev/packages/video_player) to reproduce videos. Follow [this guide](https://pub.dev/packages/video_player#installation) to fulfill the requirements.

To pick images from the camera, we use the [image_picker](https://pub.dev/packages/image_picker) plugin.
Follow [these instructions](https://pub.dev/packages/image_picker#ios) to check the requirements.

## Docs

### Business logic components

We provide 2 Widgets dedicated to business logic and state management:

- [StreamChat](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/StreamChat-class.html)
- [StreamChannel](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/StreamChannel-class.html)

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

### Customizing styles

The Flutter SDK comes with a fully designed set of widgets that you can customize to fit with your application style and typography.
Changing the theme of Chat widgets works in a very similar way that `MaterialApp` and `Theme` do.

Out of the box, all chat widgets use their default styling, and there are two ways to change the styling:

  1. Initialize the `StreamChatTheme` from your existing `MaterialApp` style
  ```dart
  class MyApp extends StatelessWidget {
    final Client client;

    MyApp(this.client);

    @override
    Widget build(BuildContext context) {
      final theme = ThemeData(
        primarySwatch: Colors.green,
      );

      return MaterialApp(
        theme: theme,
        home: Container(
          child: StreamChat(
           streamChatThemeData: StreamChatThemeData.fromTheme(theme),
            client: client,
            child: ChannelListPage(),
          ),
        ),
      );
    }
  }
  ```

  2. Construct a custom theme and provide all the customizations needed
  ```dart
  class MyApp extends StatelessWidget {
    final Client client;

    MyApp(this.client);

    @override
    Widget build(BuildContext context) {
      final theme = ThemeData(
        primarySwatch: Colors.green,
      );

      return MaterialApp(
        theme: theme,
        home: Container(
          child: StreamChat(
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
            client: client,
            child: ChannelListPage(),
          ),
        ),
      );
    }
  }
  ```

## Contributing

We welcome code changes that improve this library or fix a problem,
please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on Github.
We are pleased to merge your code into the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
