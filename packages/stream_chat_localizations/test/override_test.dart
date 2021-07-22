// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/src/stream_chat_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class FooStreamChatLocalizations extends StreamChatLocalizationsEn {
  FooStreamChatLocalizations(
    Locale localeName,
    this.launchUrlError,
  ) : super(localeName: localeName.toString());

  @override
  final String launchUrlError;
}

class FooStreamChatLocalizationsDelegate
    extends LocalizationsDelegate<StreamChatLocalizations> {
  const FooStreamChatLocalizationsDelegate({
    this.supportedLanguage = 'en',
    this.launchUrlError = 'foo',
  });

  final String supportedLanguage;
  final String launchUrlError;

  @override
  bool isSupported(Locale locale) =>
      supportedLanguage == 'allLanguages' ||
      locale.languageCode == supportedLanguage;

  @override
  Future<FooStreamChatLocalizations> load(Locale locale) =>
      SynchronousFuture<FooStreamChatLocalizations>(
        FooStreamChatLocalizations(locale, launchUrlError),
      );

  @override
  bool shouldReload(FooStreamChatLocalizationsDelegate old) => false;
}

Widget buildFrame({
  Locale? locale,
  Iterable<LocalizationsDelegate> delegates =
      GlobalStreamChatLocalizations.delegates,
  required WidgetBuilder buildContent,
  LocaleResolutionCallback? localeResolutionCallback,
  Iterable<Locale> supportedLocales = const <Locale>[
    Locale('en', 'US'),
    Locale('hi', 'IN'),
  ],
}) =>
    MaterialApp(
      color: const Color(0xFFFFFFFF),
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: delegates,
      localeResolutionCallback: localeResolutionCallback,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
          builder: (BuildContext context) => buildContent(context)),
    );

void main() {
  testWidgets(
    'Locale fallbacks',
    (WidgetTester tester) async {
      final Key textKey = UniqueKey();

      await tester.pumpWidget(
        buildFrame(
          buildContent: (BuildContext context) => Text(
            StreamChatLocalizations.of(context)!.launchUrlError,
            key: textKey,
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.byKey(textKey)).data,
        'Cannot launch the url',
      );

      // Unrecognized locale falls back to 'en'
      await tester.binding.setLocale('foo', 'BAR');
      await tester.pump();
      expect(
        tester.widget<Text>(find.byKey(textKey)).data,
        'Cannot launch the url',
      );

      // Indian hindi locale, falls back to just 'hi'
      await tester.binding.setLocale('hi', 'IN');
      await tester.pump();
      expect(
        tester.widget<Text>(find.byKey(textKey)).data,
        'यूआरएल लॉन्च नहीं कर सकते',
      );
    },
  );

  testWidgets(
    "Localizations.override widget tracks parent's locale",
    (WidgetTester tester) async {
      Widget buildLocaleFrame(Locale locale) => buildFrame(
            locale: locale,
            supportedLocales: <Locale>[locale],
            buildContent: (BuildContext context) => Localizations.override(
              context: context,
              child: Builder(
                builder: (BuildContext context) {
                  // No StreamChatLocalizations are defined for the first
                  // Localizations ancestor, so we should get the values from
                  // the default one, i.e. the one created by WidgetsApp via
                  // the LocalizationsDelegate provided by MaterialApp.
                  return Text(
                    StreamChatLocalizations.of(context)!.launchUrlError,
                  );
                },
              ),
            ),
          );

      await tester.pumpWidget(buildLocaleFrame(const Locale('en', 'US')));
      expect(find.text('Cannot launch the url'), findsOneWidget);

      await tester.pumpWidget(buildLocaleFrame(const Locale('hi', 'IN')));
      expect(find.text('यूआरएल लॉन्च नहीं कर सकते'), findsOneWidget);
    },
  );

  testWidgets('Localizations.override widget with hardwired locale',
      (WidgetTester tester) async {
    Widget buildLocaleFrame(Locale locale) => buildFrame(
          locale: locale,
          buildContent: (BuildContext context) {
            return Localizations.override(
              context: context,
              locale: const Locale('en', 'US'),
              child: Builder(
                builder: (BuildContext context) {
                  // No StreamChatLocalizations are defined for the first
                  // Localizations ancestor, so we should get the values from
                  // the default one, i.e. the one created by WidgetsApp via
                  // the LocalizationsDelegate provided by MaterialApp.
                  return Text(
                    StreamChatLocalizations.of(context)!.launchUrlError,
                  );
                },
              ),
            );
          },
        );

    await tester.pumpWidget(buildLocaleFrame(const Locale('en', 'US')));
    expect(find.text('Cannot launch the url'), findsOneWidget);

    await tester.pumpWidget(buildLocaleFrame(const Locale('hi', 'IN')));
    expect(find.text('Cannot launch the url'), findsOneWidget);
  });

  testWidgets(
    'MaterialApp adds StreamChatLocalizations for additional languages',
    (WidgetTester tester) async {
      final Key textKey = UniqueKey();

      await tester.pumpWidget(buildFrame(
        delegates: <LocalizationsDelegate<StreamChatLocalizations>>[
          GlobalStreamChatLocalizations.delegate,
          const FooStreamChatLocalizationsDelegate(
            supportedLanguage: 'fr',
            launchUrlError: "Impossible de lancer l'url",
          ),
          const FooStreamChatLocalizationsDelegate(
            supportedLanguage: 'de',
            launchUrlError: 'Kann die URL nicht starten',
          ),
        ],
        supportedLocales: const <Locale>[
          Locale('en'),
          Locale('hi'),
          Locale('fr'),
          Locale('de'),
        ],
        buildContent: (BuildContext context) => Text(
          StreamChatLocalizations.of(context)!.launchUrlError,
          key: textKey,
        ),
      ));

      expect(
        tester.widget<Text>(find.byKey(textKey)).data,
        'Cannot launch the url',
      );

      await tester.binding.setLocale('hi', 'IN');
      await tester.pump();
      expect(find.text('यूआरएल लॉन्च नहीं कर सकते'), findsOneWidget);

      await tester.binding.setLocale('fr', 'CA');
      await tester.pump();
      expect(find.text("Impossible de lancer l'url"), findsOneWidget);

      await tester.binding.setLocale('de', 'DE');
      await tester.pump();
      expect(find.text('Kann die URL nicht starten'), findsOneWidget);
    },
  );

  testWidgets(
    'MaterialApp overrides MaterialLocalizations for all locales',
    (WidgetTester tester) async {
      final Key textKey = UniqueKey();

      await tester.pumpWidget(buildFrame(
        // Accept whatever locale we're given
        localeResolutionCallback:
            (Locale? locale, Iterable<Locale> supportedLocales) => locale,
        delegates: <FooStreamChatLocalizationsDelegate>[
          const FooStreamChatLocalizationsDelegate(
            supportedLanguage: 'allLanguages',
          ),
        ],
        buildContent: (BuildContext context) {
          // Should always be 'foo', no matter what the locale is
          return Text(
            StreamChatLocalizations.of(context)!.launchUrlError,
            key: textKey,
          );
        },
      ));

      expect(tester.widget<Text>(find.byKey(textKey)).data, 'foo');

      await tester.binding.setLocale('zh', 'CN');
      await tester.pump();
      expect(find.text('foo'), findsOneWidget);

      await tester.binding.setLocale('de', 'DE');
      await tester.pump();
      expect(find.text('foo'), findsOneWidget);
    },
  );

  testWidgets(
    'MaterialApp overrides MaterialLocalizations for default locale',
    (WidgetTester tester) async {
      final Key textKey = UniqueKey();

      await tester.pumpWidget(buildFrame(
        delegates: <FooStreamChatLocalizationsDelegate>[
          const FooStreamChatLocalizationsDelegate(),
        ],
        // supportedLocales not specified, so all locales resolve to 'en'
        buildContent: (BuildContext context) => Text(
          StreamChatLocalizations.of(context)!.launchUrlError,
          key: textKey,
        ),
      ));

      // Unsupported locale '_' (the widget tester's default) resolves to 'en'.
      expect(tester.widget<Text>(find.byKey(textKey)).data, 'foo');

      // Unsupported locale 'zh' resolves to 'en'.
      await tester.binding.setLocale('zh', 'CN');
      await tester.pump();
      expect(find.text('foo'), findsOneWidget);

      // Unsupported locale 'de' resolves to 'en'.
      await tester.binding.setLocale('de', 'DE');
      await tester.pump();
      expect(find.text('foo'), findsOneWidget);
    },
  );
}
