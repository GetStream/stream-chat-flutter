# Official Flutter packages for [Stream Chat](https://getstream.io/chat/sdk/flutter/)

![](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/images/sdk_hero_v4.png)

![CI](https://github.com/GetStream/stream-chat-flutter/workflows/stream_flutter_workflow/badge.svg?branch=master)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat SDK Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)
- [Sample apps](https://github.com/GetStream/flutter-samples)

This repository contains code for our [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/) chat clients.

Stream allows developers to rapidly deploy scalable feeds and chat messaging with an industry leading 99.999% uptime SLA guarantee.

## Sample apps and demos 
Our team maintains a dedicated repository for fully-fledged sample applications and demos. Consider checking out [GetStream/flutter-samples](https://github.com/GetStream/flutter-samples) to learn more or get started by looking at our latest [Stream Chat demo](https://github.com/GetStream/flutter-samples/tree/main/packages/stream_chat_v1). 

## Free for Makers

Stream is free for most side and hobby projects. To qualify your project/company needs to have < 5 team members and < $10k in monthly revenue.
For complete pricing details visit our [Chat Pricing Page](https://getstream.io/chat/pricing/)

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
This package provides business logic to fetch common things required for integrating Stream Chat into your application. The `core` package allows more customisation and hence provides business logic but no UI components.

### [stream_chat_flutter](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_flutter)
This library includes both a low-level chat SDK and a set of reusable and customizable UI components.

### [stream_chat_localizations](https://github.com/GetStream/stream-chat-flutter/tree/master/packages/stream_chat_localizations)
This library includes a set of localization files for the Flutter UI components.

## Flutter Chat Tutorial

The best place to start is the [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/).
It teaches you how to use this SDK and also shows how to make frequently required changes.

## Example Apps

Every package folder includes a fully functional example with setup instructions.

We also provide a set of sample apps created using the Stream Flutter SDK at [this location](https://github.com/GetStream/flutter-samples).

## Versioning Policy

All of the Stream Chat packages follow [semantic versioning (semver)](https://semver.org/).

That means that with a version number x.y.z (major.minor.patch):

- When releasing critical bug fixes, we make a patch release by changing the z number (ex: 3.6.2 to 3.6.3).
- When releasing new features or non-critical fixes, we make a minor release by changing the y number (ex: 3.6.2 to 3.7.0).
- When releasing breaking changes (backward incompatible), we make a major release by changing the x number (ex: 3.6.2 to 4.0.0).

See the [semantic versioning](https://dart.dev/tools/pub/versioning#semantic-versions) section from the Dart docs for more information.

This versioning policy does not apply to prerelease packages (below major version of 1). See this
[StackOverflow thread](https://stackoverflow.com/questions/66201337/how-do-dart-package-versions-work-how-should-i-version-my-flutter-plugins)
for more information on Dart package versioning.

Whenever possible, we will add deprecation warnings in preparation for future breaking changes.

## We are hiring

We've recently closed a [\$38 million Series B funding round](https://techcrunch.com/2021/03/04/stream-raises-38m-as-its-chat-and-activity-feed-apis-power-communications-for-1b-users/) and we keep actively growing.
Our APIs are used by more than a billion end-users, and you'll have a chance to make a huge impact on the product within a team of the strongest engineers all over the world.

Check out our current openings and apply via [Stream's website](https://getstream.io/team/#jobs).

