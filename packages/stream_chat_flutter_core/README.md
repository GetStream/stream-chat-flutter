# Official Core [Flutter SDK](https://getstream.io/chat/sdk/flutter/) for [Stream Chat](https://getstream.io/chat/)

> The official Flutter core components for Stream Chat, a service for
> building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_flutter_core.svg)](https://pub.dartlang.org/packages/stream_chat_flutter_core)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/stream_flutter_workflow/badge.svg?branch=master)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)
- [Core Docs](https://getstream.io/chat/docs/sdk/flutter/stream_chat_flutter_core/introduction/)

### Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_flutter_core/changelog) to see the latest changes in the package.

## Flutter Chat Tutorial

The best place to start is the [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/).
It teaches you how to use this SDK and also shows how to make frequently required changes.

## Example App

This repo includes a fully functional example app with setup instructions.
The example is available under the [example](https://github.com/GetStream/stream-chat-flutter/tree/main/packages/stream_chat_flutter_core/example) folder.

## Add dependency
Add this to your package's pubspec.yaml file, use the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_flutter_core.svg)](https://pub.dartlang.org/packages/stream_chat_flutter_core)
```yaml
dependencies:
 stream_chat_flutter_core: ^latest_version
```

You should then run `flutter packages get`

This package requires no custom setup on any platform since it does not depend on any platform-specific dependency

## Docs

This package provides business logic to fetch common things required for integrating Stream Chat into your application.
The core package allows more customisation and hence provides business logic but no UI components.
Please use the `stream_chat_flutter` package for the full fledged suite of UI components or `stream_chat` for the low-level client.

### Business Logic Components

These components allow you to have the maximum and lower-level control of the queries being executed.
The BLoCs we provide are:

1) ChannelsBloc
2) MessageSearchBloc
3) UsersBloc

### Core Components

In the early days of the Flutter SDK, the SDK was only split into the LLC (`stream_chat`) and
the UI package (`stream_chat_flutter`). With this you could use a fully built interface with the UI package
or a fully custom interface with the LLC. However, we soon recognised the need for a third intermediary
package which made tasks like building and modifying a list of channels or messages easy but without
the complexity of using low level components. The Core package (`stream_chat_flutter_core`) is a manifestation
of the same idea and allows you to build an interface with Stream Chat without having to deal with
low level code and architecture as well as implementing your own theme and UI effortlessly. 
Also, it has very few dependencies.

The package primarily contains a bunch of controller classes.
Controllers are used to handle the business logic of the chat. You can use them together with our UI widgets, or you can even use them to build your own UI.

* StreamChannelListController
* StreamUserListController
* StreamMessageSearchListController
* StreamMessageInputController
* LazyLoadScrollView
* PagedValueListenableBuilder

## Contributing

We welcome code changes that improve this library or fix a problem,
please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on Github.
We are pleased to merge your code into the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
