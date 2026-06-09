import 'package:alchemist/alchemist.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

import 'golden_component_factory.dart';

/// The platform doc snapshots are pinned to.
///
/// Three platform reads must agree so widgets render identically on every
/// host:
/// 1. Stream's [CurrentPlatform] (used by hand-written checks like
///    `CurrentPlatform.isAndroid`).
/// 2. Flutter's [defaultTargetPlatform] (read directly by Cupertino widgets
///    and any code that doesn't go through a [Theme]).
/// 3. Material's [Theme.of].platform (set via [docsScreenshotsTheme]).
///
/// 1 and 2 are pinned per-test by [docsGoldenTest]; 3 is set on the
/// [ThemeData] returned from [docsScreenshotsTheme].
const docsScreenshotsPlatform = PlatformType.ios;
const docsScreenshotsTargetPlatform = TargetPlatform.iOS;

/// A [goldenTest] wrapper that pins the platform for the duration of each
/// snapshot.
///
/// The [builder] returns the `home:` widget of a [MaterialApp]; [app] wraps
/// it (defaulting to a standard `MaterialApp(theme: docsScreenshotsTheme())`).
/// Override [app] for tests that need a custom theme, locale, or localization
/// delegates.
///
/// Sets [CurrentPlatform.debugCurrentPlatformOverride] and
/// [debugDefaultTargetPlatformOverride] before the widget is pumped, and
/// resets them after the golden comparison via [Interaction]'s cleanup hook —
/// which is the latest point inside the test body, before
/// `_verifyInvariants` enforces that foundation debug vars are null.
///
/// The default [pumpBeforeTest] does [WidgetTester.pumpAndSettle] first so
/// deferred UI (modal sheets, paginated lists) renders, then [precacheImages]
/// so avatar fixtures decode before the snapshot is taken. Order matters:
/// precaching before settling would scan an empty tree and miss images that
/// only mount after async work completes.
///
/// All [goldenTest] parameters are forwarded; pass a custom [pumpWidget] or
/// [whilePerforming] and they will be composed with the platform pin.
@isTest
void docsGoldenTest(
  String description, {
  required String fileName,
  bool skip = false,
  List<String> tags = const ['golden'],
  double textScaleFactor = 1.0,
  BoxConstraints constraints = const BoxConstraints(),
  PumpAction pumpBeforeTest = _settleThenPrecacheImages,
  PumpWidget pumpWidget = onlyPumpWidget,
  Interaction? whilePerforming,
  DeviceInfo? deviceFrame,
  Widget Function(Widget home) app = _defaultDocsScreenshotsApp,
  required ValueGetter<Widget> builder,
}) {
  Widget wrapped() {
    final home = builder();
    final framed = deviceFrame == null
        ? home
        : DeviceFrame(
            device: deviceFrame,
            isFrameVisible: true,
            screen: home,
          );
    return app(framed);
  }

  goldenTest(
    description,
    fileName: fileName,
    skip: skip,
    tags: tags,
    textScaleFactor: textScaleFactor,
    constraints: constraints,
    pumpBeforeTest: pumpBeforeTest,
    pumpWidget: (tester, widget) async {
      CurrentPlatform.debugCurrentPlatformOverride = docsScreenshotsPlatform;
      debugDefaultTargetPlatformOverride = docsScreenshotsTargetPlatform;
      await pumpWidget(tester, GoldenComponentFactory(child: widget));
    },
    whilePerforming: (tester) async {
      final userCleanup = await whilePerforming?.call(tester);
      return () async {
        await userCleanup?.call();
        CurrentPlatform.debugCurrentPlatformOverride = null;
        debugDefaultTargetPlatformOverride = null;
      };
    },
    builder: wrapped,
  );
}

// Settle async work (post-frame sheets, paginated lists) before precaching so
// avatar Images that only mount after the load finishes get decoded.
Future<void> _settleThenPrecacheImages(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await precacheImages(tester);
}

/// Default [MaterialApp] wrapper used by [docsGoldenTest].
///
/// Applies [docsScreenshotsTheme] and hides the debug banner. Tests that need
/// a different theme, locale, or localization delegates pass their own [app]
/// callback to [docsGoldenTest].
Widget _defaultDocsScreenshotsApp(Widget home) => MaterialApp(
  theme: docsScreenshotsTheme(),
  debugShowCheckedModeBanner: false,
  home: home,
);

// ---------------------------------------------------------------------------
// StreamTheme (stream_core_flutter) — drives new message text rendering
// ---------------------------------------------------------------------------
//
// core.DefaultStreamMessageText reads its text style from
// StreamTheme.of(context).textTheme.bodyDefault. Those styles carry no
// fontFamily by default; when MarkdownBody passes them as the `p` style to
// RichText, RichText does NOT inherit DefaultTextStyle, so Flutter falls back
// to the Ahem test font (black rectangles).
//
// Fix: apply the iOS body-text family alias (CupertinoSystemText) so message
// content matches Material's iOS typography. The font itself is registered
// under that alias by `_loadAppleSystemFont` in flutter_test_config.dart.

ThemeData docsScreenshotsTheme() {
  final streamTextTheme = core.StreamTextTheme().apply(
    color: core.StreamColorScheme.light().systemText,
    fontFamily: 'CupertinoSystemText',
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    platform: docsScreenshotsTargetPlatform,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
    ),
    extensions: [
      StreamTheme(brightness: Brightness.light, textTheme: streamTextTheme),
    ],
  );
}

ThemeData docsScreenshotsDarkTheme() {
  final streamTextTheme = core.StreamTextTheme().apply(
    color: core.StreamColorScheme.dark().systemText,
    fontFamily: 'CupertinoSystemText',
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    platform: docsScreenshotsTargetPlatform,
    scaffoldBackgroundColor: const Color(0xFF000000),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF000000),
    ),
    extensions: [
      StreamTheme(brightness: Brightness.dark, textTheme: streamTextTheme),
    ],
  );
}
