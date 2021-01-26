# Official Flutter SDK Core for [Stream Chat](https://getstream.io/chat/)

<p align="center">
  <a href="https://getstream.io/tutorials/ios-chat/"><img src="https://i.imgur.com/L4Mj8S2.png" alt="Flutter Chat" width="60%" /></a>
</p>

> The official Flutter core components for Stream Chat, a service for
> building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_flutter.svg)](https://pub.dartlang.org/packages/stream_chat_flutter)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
[![Gitter](https://badges.gitter.im/GetStream/stream-chat-flutter.svg)](https://gitter.im/GetStream/stream-chat-flutter?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/CI/badge.svg?branch=master)
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
Add this to your package's pubspec.yaml file, use the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_flutter.svg)](https://pub.dartlang.org/packages/stream_chat_flutter)
```yaml
dependencies:
 stream_chat_flutter_core: ^latest_version
```

You should then run `flutter packages get`

This package requires no custom setup on any platform since it does not depend on any platform-specific dependency

## Docs

This package provides business logic to fetch common things required for integrating Stream Chat into your application.
The core package allows more customisation and hence provides business logic but no UI components.
Please use the stream_chat_flutter package for the full fledged suite of UI components.

### Business logic components

We provide widgets dedicated to business logic and state management:

- [StreamChatCore](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/StreamChat-class.html)
- [StreamChannel](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/StreamChannel-class.html)
- [ChannelsBloc](https://pub.dev/documentation/stream_chat_flutter/0.2.0-alpha+2/stream_chat_flutter/ChannelsBloc-class.html)
- [MessageSearchBloc]
- [UsersBloc]
- [ChannelListCore]
- [MessageListCore]
- [MessageSearchListCore]
- [UserListCore]

## Contributing

We welcome code changes that improve this library or fix a problem,
please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on Github.
We are pleased to merge your code into the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
