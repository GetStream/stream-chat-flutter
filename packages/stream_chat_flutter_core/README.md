# Official Core [Flutter SDK](https://getstream.io/chat/sdk/flutter/) for [Stream Chat API](https://getstream.io/chat/)

> The official Flutter core components for Stream Chat, a service for
> building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_flutter_core.svg)](https://pub.dartlang.org/packages/stream_chat_flutter_core)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/stream_flutter_workflow/badge.svg?branch=master)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)

### Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_flutter_core/changelog) to see the latest changes in the package.

## Flutter Chat Tutorial

The best place to start is the [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/).
It teaches you how to use this SDK and also shows how to make frequently required changes.

## Example App

This repo includes a fully functional example app with setup instructions.
The example is available under the [example](https://github.com/GetStream/stream-chat-flutter-core/tree/master/example) folder.

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
Please use the stream_chat_flutter package for the full fledged suite of UI components or stream_chat for the low-level client.

The package primarily contains three types of classes:

1) Business Logic Components
2) Core Components
3) Core Controllers

### Business Logic Components

These components allow you to have the maximum and lower-level control of the queries being executed.
The BLoCs we provide are:

1) ChannelsBloc
2) MessageSearchBloc
3) UsersBloc

### Core Components

Core components usually are an easy way to fetch data associated with Stream Chat which are decoupled from UI and often expose UI builders.
Data fetching can be controlled with the controllers of the respective core components.

1) ChannelListCore (Fetch a list of channels)
2) MessageListCore (Fetch a list of messages from a channel)
3) MessageSearchListCore (Fetch a list of search messages)
4) UserListCore (Fetch  a list of users)
5) StreamChatCore (This is different from the other core components - it is a version of StreamChat decoupled from theme and initialisations.)

### Core Controllers

Core Controllers are supplied to respective CoreList widgets which allows reloading and pagination of data whenever needed.

1) ChannelListController
2) MessageListController
3) MessageSearchListController
4) ChannelListController

## Contributing

We welcome code changes that improve this library or fix a problem,
please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on Github.
We are pleased to merge your code into the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
