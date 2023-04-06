// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

void main() {
  testWidgets('Nested Localizations', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      // Creates the outer Localizations widget.
      home: ListView(
        children: <Widget>[
          const LocalizationTracker(key: ValueKey<String>('outer')),
          Localizations(
            locale: const Locale('hi'),
            delegates: GlobalStreamChatLocalizations.delegates,
            child: const LocalizationTracker(key: ValueKey<String>('inner')),
          ),
        ],
      ),
    ));

    final LocalizationTrackerState outerTracker = tester.state(
        find.byKey(const ValueKey<String>('outer'), skipOffstage: false));
    expect(outerTracker.captionFontSize, 12.0);
    final LocalizationTrackerState innerTracker = tester.state(
        find.byKey(const ValueKey<String>('inner'), skipOffstage: false));
    expect(innerTracker.captionFontSize, 13.0);
  });

  testWidgets(
    'Localizations is compatible with ChangeNotifier.dispose() called '
    'during didChangeDependencies',
    (WidgetTester tester) async {
      // PageView calls ScrollPosition.dispose() during didChangeDependencies.
      await tester.pumpWidget(MaterialApp(
        supportedLocales: const <Locale>[
          Locale('en', 'US'),
          Locale('hi', 'IN'),
        ],
        localizationsDelegates: const [
          DummyLocalizations.delegate,
          GlobalStreamChatLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: PageView(),
      ));

      await tester.binding.setLocale('hi', 'IN');
      await tester.pump();
      await tester.pumpWidget(Container());
    },
  );

  testWidgets('Locale without countryCode', (WidgetTester tester) async {
    // Regression test for https://github.com/flutter/flutter/pull/16782
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: GlobalStreamChatLocalizations.delegates,
      supportedLocales: const <Locale>[
        Locale('en', 'US'),
        Locale('hi'),
      ],
      home: Container(),
    ));

    await tester.binding.setLocale('hi', '');
    await tester.pump();
    await tester.binding.setLocale('en', 'US');
    await tester.pump();
  });
}

/// A localizations delegate that does not contain any useful data, and is only
/// used to trigger didChangeDependencies upon locale change.
class _DummyLocalizationsDelegate
    extends LocalizationsDelegate<DummyLocalizations> {
  const _DummyLocalizationsDelegate();

  @override
  Future<DummyLocalizations> load(Locale locale) async => DummyLocalizations();

  @override
  bool isSupported(Locale locale) => true;

  @override
  bool shouldReload(_DummyLocalizationsDelegate old) => true;
}

class DummyLocalizations {
  static const delegate = _DummyLocalizationsDelegate();
}

class LocalizationTracker extends StatefulWidget {
  const LocalizationTracker({super.key});

  @override
  State<StatefulWidget> createState() => LocalizationTrackerState();
}

class LocalizationTrackerState extends State<LocalizationTracker> {
  late double captionFontSize;

  @override
  Widget build(BuildContext context) {
    captionFontSize = Theme.of(context).textTheme.bodySmall!.fontSize!;
    return Container();
  }
}
