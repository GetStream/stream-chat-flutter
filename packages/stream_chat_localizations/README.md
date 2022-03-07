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
- [UI Docs](https://getstream.io/chat/docs/sdk/flutter/stream_chat_flutter/introduction/)

### Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_chat_localizations/changelog) to see the latest changes in the package.

![localization_support](https://user-images.githubusercontent.com/13705472/127504329-a9690184-ce0f-4442-adb4-a33b5e3a3bf1.png)

## What is Localization?

If you deploy your app to users who speak another language, you'll need to internationalize (localize) it. That means you need to write the app in a way that makes it possible to localize values like text and layouts for each language or locale that the app supports. For more information, see the [Flutter documentation](https://flutter.dev/docs/development/accessibility-and-localization/**internationalization**).

What this package allows you to do is to provide localized strings for the Stream chat widgets. For example, depending on the application locale, the Stream Chat widgets will display the appropriate language. The locale will be set automatically, based on system preferences, or you could set it programmatically in your app. The package supports several different languages, with more to be added. The package allows you to override any supported language or add a new language that isn't supported.

## Supported languages

At the moment we support the following languages:
- [English](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_en.dart)
- [Hindi](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_hi.dart)
- [Italian](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_it.dart)
- [French](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_fr.dart)
- [Spanish](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_es.dart)
- [Japanese](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_ja.dart)
- [Korean](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_ko.dart)
- [Portuguese](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/lib/src/stream_chat_localizations_pt.dart)

More languages will be added in the future. Feel free to [contribute](https://github.com/GetStream/stream-chat-flutter/blob/master/CONTRIBUTING.md) to add more languages.

## Add dependency

Add this to your package's pubspec.yaml file, use the latest version [![Pub](https://img.shields.io/pub/v/stream_chat_localizations.svg)](https://pub.dartlang.org/packages/stream_chat_localizations)
```yaml
dependencies:
 stream_chat_localizations: ^latest_version
```

Then run `flutter packages get`

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
        Locale('es'),
        Locale('ja'),
        Locale('ko'),
        Locale('pt'),
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

To add a new language, create a new class extending `GlobalStreamChatLocalizations` and create a delegate for it, adding it to the `delegates` array.

Check out [this example](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/example/lib/add_new_lang.dart) to see how to add a new language.

### Override existing languages

To override an existing language, create a new class extending that particular language class and create a delegate for it, adding it to the `delegates` array.

Check out [this example](https://github.com/GetStream/stream-chat-flutter/blob/master/packages/stream_chat_localizations/example/lib/override_lang.dart) to see how to override an existing language.

### ⚠️ Note on **iOS**

For translation to work on **iOS** you need to add supported locales to 
`ios/Runner/Info.plist` as described [here](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#localizing-for-ios-updating-the-ios-app-bundle).

Example:

```xml
<key>CFBundleLocalizations</key>
<array>
  <string>en</string>
  <string>hi</string>
  <string>fr</string>
  <string>it</string>
  <string>es</string>
  <string>ja</string>
  <string>ko</string>
  <string>pt</string>
</array>
```

## Contributing

We welcome code changes that improve this library or fix a problem. Please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on Github.
We are pleased to merge your code into the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
