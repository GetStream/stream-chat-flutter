# Official Localizations for [Stream Chat Flutter](https://getstream.io/chat/sdk/flutter/) library.

> The Official localizations for Stream Chat Flutter, a service for
> building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_localizations.svg)](https://pub.dartlang.org/packages/stream_chat_localizations)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/stream_flutter_workflow/badge.svg?branch=master)


**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/) 
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)

This package provides localized strings for the stream chat widgets for many languages.

### Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_localizations/changelog) to see the latest changes in the package.

## Supported languages

At the moment we support the following languages:
- [English](https://pub.dev/documentation/stream_chat_localizations/latest/stream_chat_localizations/StreamChatLocalizationsEn-class.html)
- [Hindi](https://pub.dev/documentation/stream_chat_localizations/latest/stream_chat_localizations/StreamChatLocalizationsHi-class.html)
- [Italian](https://pub.dev/documentation/stream_chat_localizations/latest/stream_chat_localizations/StreamChatLocalizationsIt-class.html)
- [French](https://pub.dev/documentation/stream_chat_localizations/latest/stream_chat_localizations/StreamChatLocalizationsFr-class.html)

More languages will be added in the future. Feel free to [contribute](https://github.com/GetStream/stream-chat-flutter/blob/master/CONTRIBUTING.md) to add more languages.

## Add dependency

Add this to your package's pubspec.yaml file, use the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_localizations.svg)](https://pub.dartlang.org/packages/stream_chat_localizations)
```yaml
dependencies:
 stream_chat_localizations: ^latest_version
```

You should then run `flutter packages get`

### Usage

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

### Adding a new language

To add a new language, you need to create a new class extending `GlobalStreamChatLocalizations` and create a delegate for it adding it to the `delegates` array.

Checkout [this example](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/example/lib/add_new_lang.dart) to see how to add a new language.

### Override exisiting languages

To override an existing language, you need to create a new class extending that particular language class and create a delegate for it adding it to the `delegates` array.

Checkout [this example](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/example/lib/override_lang.dart) to see how to override an existing language.

### ⚠️ Note on **iOS**

For translation to work on **iOS** you need to add supported locales to 
`ios/Runner/Info.plist` as described [here](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#specifying-supportedlocales).

Example:

```xml
<key>CFBundleLocalizations</key>
<array>
	<string>en</string>
	<string>nb</string>
	<string>fr</string>
	<string>it</string>
</array>
```

## Contributing

We welcome code changes that improve this library or fix a problem,
please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on Github.
We are pleased to merge your code into the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
