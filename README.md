# Flutter Chat Components

<a href="https://getstream.io/chat/"><img src="https://i.imgur.com/L4Mj8S2.png" alt="Flutter Chat" /></a>

> The official Flutter components for Stream Chat, a service for
> building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_flutter.svg)](https://pub.dartlang.org/packages/stream_chat_flutter)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/CI/badge.svg?branch=master)
[![codecov](https://codecov.io/gh/GetStream/stream-chat-flutter/branch/master/graph/badge.svg)](https://codecov.io/gh/GetStream/stream-chat-flutter)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/) 
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)

## Flutter Chat Tutorial

The best place to start is the [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/).
It teaches you how to use this SDK and also shows how to make common changes.

## Example App

This repo includes a fully functional example app with setup instructions.
The example is available under the [example](https://github.com/GetStream/stream-chat-flutter/tree/master/example) folder.

## Add dependency

```yaml
dependencies:
 stream_chat_flutter: ^0.1.11
```

You should then run `flutter packages get`

### Android

All set ✅

### iOS

The library uses [flutter file picker plugin](https://github.com/miguelpruivo/flutter_file_picker) to pick
files from the os.

Follow [this wiki](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#ios) to fulfill iOS requirements.

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

The Flutter SDK comes with a fully designed set of widgets which you can customize to fit with your application style and typography.
Changing the theme of Chat widgets works in a very similar way that `MaterialApp` and `Theme` do.

Out of the box all chat widgets use their own default styling, there are two ways to change the styling:

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
We are very happy to merge your code in the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
