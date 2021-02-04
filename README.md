# Official Flutter packages for [Stream Chat](https://getstream.io/chat/)

![](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/hotfix/readmes/images/sdk_hero_v4.png)

[![Gitter](https://badges.gitter.im/GetStream/stream-chat-flutter.svg)](https://gitter.im/GetStream/stream-chat-flutter?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/stream_flutter_workflow/badge.svg?branch=master)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)

This repository contains code for our [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/) chat clients.

Stream allows developers to rapidly deploy scalable feeds and chat messaging with an industry leading 99.999% uptime SLA guarantee.

## Structure
Stream Chat Dart is a monorepo built using [Melos](https://docs.page/invertase/melos). Individual packages can be found in the `packages` directory while configuration and top level commands can be found in `melos.yaml`. 

To get started, run `bootstrap` after cloning the project. 

```shell
melos bootstrap
```

## Packages 
We provide a variety of packages depending on the level of customization you want to achieve.

### [stream_chat](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat)
A pure Dart package that can be used on any Dart project. It provides a low-level client to access the Stream Chat service.

### [stream_chat_persistence](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_persistence)
This package provides a persistence client for fetching and saving chat data locally. Stream Chat Persistence uses Moor as a disk cache.

### [stream_chat_flutter_core](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_flutter_core)
This package provides business logic to fetch common things required for integrating Stream Chat into your application. The core package allows more customisation and hence provides business logic but no UI components.

### [stream_chat_flutter](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_flutter)
This library includes both a low-level chat SDK and a set of reusable and customizable UI components.

## Flutter Chat Tutorial

The best place to start is the [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/).
It teaches you how to use this SDK and also shows how to make frequently required changes.

## Example Apps

Every package folder includes a fully functional example with setup instructions.

We also provide a set of sample apps created using the Stream Flutter SDK at this location. https://github.com/GetStream/flutter-samples