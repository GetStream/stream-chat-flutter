# Stream Chat Persistence Example
Please see `lib/` for example code.

## Setting a language
The application language can be changed through system preferences or programmatically.

### System Preferences
The application locale can be changed by changing the language for your device or emulator within the device's system preferences.

[iOS change language](https://support.apple.com/en-us/HT204031)

[Android change language](https://support.google.com/websearch/answer/3333234?co=GENIE.Platform%3DAndroid&hl=en)

Note that the language needs to be supported in your application to work.

### Programmatically
You can also set the locale programmatically in your Flutter application without changing the device's language.

```dart
return MaterialApp(
 ...
 locale: const Locale('fr'),
 ...
);
```

There are many ways that this can be set for additional control. For information and examples, see this [Stack Overflow post](https://stackoverflow.com/questions/49441212/flutter-multi-lingual-application-how-to-override-the-locale).