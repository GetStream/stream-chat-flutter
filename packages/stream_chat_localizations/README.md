# Official Localizations for [Stream Chat Flutter](https://getstream.io/chat/sdk/flutter/)

> The official localizations for Stream Chat Flutter, a service for building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_localizations.svg)](https://pub.dev/packages/stream_chat_localizations)
[![CI](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml/badge.svg?branch=master)](https://github.com/GetStream/stream-chat-flutter/actions/workflows/stream_flutter_workflow.yml)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/)
- [Localization Docs](https://getstream.io/chat/docs/sdk/flutter/stream-chat-flutter/localization/)
- [V10 Migration Guide](https://getstream.io/chat/docs/sdk/flutter/guides/migration-guide-10-0/)

## Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_localizations/changelog) to see the latest changes in the package.

## Overview

This package provides localized strings for all Stream Chat Flutter widgets. Depending on the application locale, Stream Chat widgets automatically display the appropriate language. The locale can be set automatically from system preferences or programmatically in your app.

## Supported Languages

- [English](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_en.dart)
- [Hindi](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_hi.dart)
- [Italian](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_it.dart)
- [French](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_fr.dart)
- [Spanish](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_es.dart)
- [Catalan](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_ca.dart)
- [Japanese](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_ja.dart)
- [Korean](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_ko.dart)
- [Portuguese](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_pt.dart)
- [German](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_de.dart)
- [Norwegian](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_no.dart)

More languages will be added in the future. Feel free to [contribute](https://github.com/GetStream/stream-chat-flutter/blob/master/CONTRIBUTING.md) to add more.

## Add Dependency

Add this to your `pubspec.yaml`, using the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_localizations.svg)](https://pub.dev/packages/stream_chat_localizations):

```yaml
dependencies:
  stream_chat_localizations: ^10.0.0
```

Then run:

```shell
flutter pub get
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Add all the supported locales
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('fr'),
        Locale('it'),
        Locale('es'),
        Locale('ca'),
        Locale('ja'),
        Locale('ko'),
        Locale('pt'),
        Locale('de'),
        Locale('no'),
      ],
      // Add GlobalStreamChatLocalizations.delegates
      localizationsDelegates: GlobalStreamChatLocalizations.delegates,
      builder: (context, widget) => StreamChat(
        client: client,
        child: widget,
      ),
      home: StreamChannel(
        channel: channel,
        child: const ChannelPage(),
      ),
    );
  }
}
```

## Adding a New Language

To add a new language, create a new class extending `GlobalStreamChatLocalizations` and create a delegate for it, adding it to the `delegates` array.

Check out [this example](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/example/lib/add_new_lang.dart) to see how to add a new language.

## Overriding Existing Languages

To override an existing language, create a new class extending that particular language class and create a delegate for it, adding it to the `delegates` array.

Check out [this example](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/example/lib/override_lang.dart) to see how to override an existing language.

## Note on iOS

For translations to work on **iOS** you need to add supported locales to `ios/Runner/Info.plist` as described in the [Flutter docs: Localizing for iOS — updating the iOS app bundle](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#localizing-for-ios-updating-the-ios-app-bundle).

Example:

```xml
<key>CFBundleLocalizations</key>
<array>
  <string>en</string>
  <string>hi</string>
  <string>fr</string>
  <string>it</string>
  <string>es</string>
  <string>ca</string>
  <string>ja</string>
  <string>ko</string>
  <string>pt</string>
  <string>de</string>
  <string>no</string>
</array>
```

## Contributing

We welcome code changes that improve this library or fix a problem. Please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on GitHub.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
