import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  test('copyWith with no arguments returns an equal MessageComposerThemeData', () {
    const themeData = StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.floating);

    expect(themeData.copyWith(), themeData);
  });

  test('copyWith with no arguments preserves the hashCode', () {
    const themeData = StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.floating);

    expect(themeData.copyWith().hashCode, themeData.hashCode);
  });

  test('copyWith overrides the surfaceStyle', () {
    const regular = StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.regular);

    expect(
      regular.copyWith(surfaceStyle: StreamSurfaceStyle.floating).surfaceStyle,
      StreamSurfaceStyle.floating,
    );
  });

  test('MessageComposerThemeData instances with different behaviors are not equal', () {
    expect(
      const StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.regular),
      isNot(const StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.floating)),
    );
  });

  test('lerp at t = 0 resolves to the start surfaceStyle', () {
    expect(
      StreamMessageComposerThemeData.lerp(_regularTheme, _floatingTheme, 0)?.surfaceStyle,
      StreamSurfaceStyle.regular,
    );
  });

  test('lerp below the halfway point resolves to the start surfaceStyle', () {
    expect(
      StreamMessageComposerThemeData.lerp(_regularTheme, _floatingTheme, 0.49)?.surfaceStyle,
      StreamSurfaceStyle.regular,
    );
  });

  test('lerp at or past the halfway point resolves to the end surfaceStyle', () {
    expect(
      StreamMessageComposerThemeData.lerp(_regularTheme, _floatingTheme, 0.5)?.surfaceStyle,
      StreamSurfaceStyle.floating,
    );
  });

  test('lerp at t = 1 resolves to the end surfaceStyle', () {
    expect(StreamMessageComposerThemeData.lerp(_regularTheme, _floatingTheme, 1), _floatingTheme);
  });

  test('merge with null keeps the original surfaceStyle', () {
    expect(_regularTheme.merge(null), _regularTheme);
  });

  test('merge overrides the surfaceStyle with the other theme', () {
    expect(_regularTheme.merge(_floatingTheme), _floatingTheme);
  });

  test('merge with an empty theme keeps the original surfaceStyle', () {
    expect(_floatingTheme.merge(const StreamMessageComposerThemeData()), _floatingTheme);
  });

  testWidgets('of returns a null surfaceStyle when no theme is configured', (tester) async {
    final context = await _pumpAndCaptureContext(tester);

    expect(StreamMessageComposerTheme.of(context).surfaceStyle, isNull);
  });

  testWidgets('of returns the global theme surfaceStyle when no local theme is present', (tester) async {
    final context = await _pumpAndCaptureContext(tester, globalTheme: _floatingTheme);

    expect(StreamMessageComposerTheme.of(context).surfaceStyle, StreamSurfaceStyle.floating);
  });

  testWidgets('of merges the local theme over the global theme', (tester) async {
    final context = await _pumpAndCaptureContext(
      tester,
      globalTheme: _regularTheme,
      localTheme: _floatingTheme,
    );

    expect(StreamMessageComposerTheme.of(context).surfaceStyle, StreamSurfaceStyle.floating);
  });

  testWidgets('of falls back to the global theme when the local theme sets no surfaceStyle', (tester) async {
    final context = await _pumpAndCaptureContext(
      tester,
      globalTheme: _floatingTheme,
      localTheme: const StreamMessageComposerThemeData(),
    );

    expect(StreamMessageComposerTheme.of(context).surfaceStyle, StreamSurfaceStyle.floating);
  });

  testWidgets('wrap re-establishes the theme in a detached subtree', (tester) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            // `wrap` is what InheritedTheme.captureAll calls to carry the theme
            // across a route boundary; assert it round-trips the same data.
            final theme = StreamMessageComposerTheme(
              data: _floatingTheme,
              child: Builder(
                builder: (context) {
                  capturedContext = context;
                  return const SizedBox.shrink();
                },
              ),
            );

            return theme.wrap(context, theme.child);
          },
        ),
      ),
    );

    expect(StreamMessageComposerTheme.of(capturedContext).surfaceStyle, StreamSurfaceStyle.floating);
  });

  testWidgets('updateShouldNotify is true when the data changes', (tester) async {
    const oldWidget = StreamMessageComposerTheme(data: _regularTheme, child: SizedBox.shrink());
    const newWidget = StreamMessageComposerTheme(data: _floatingTheme, child: SizedBox.shrink());

    expect(newWidget.updateShouldNotify(oldWidget), isTrue);
  });

  testWidgets('updateShouldNotify is false when the data is unchanged', (tester) async {
    const oldWidget = StreamMessageComposerTheme(data: _regularTheme, child: SizedBox.shrink());
    const newWidget = StreamMessageComposerTheme(data: _regularTheme, child: SizedBox.shrink());

    expect(newWidget.updateShouldNotify(oldWidget), isFalse);
  });
}

const _regularTheme = StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.regular);
const _floatingTheme = StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.floating);

// Pumps a [StreamChat] configured with [globalTheme], optionally wrapped in a
// local [StreamMessageComposerTheme] carrying [localTheme], and returns a
// context below both.
Future<BuildContext> _pumpAndCaptureContext(
  WidgetTester tester, {
  StreamMessageComposerThemeData? globalTheme,
  StreamMessageComposerThemeData? localTheme,
}) async {
  late BuildContext capturedContext;

  final leaf = Builder(
    builder: (context) {
      capturedContext = context;
      return const SizedBox.shrink();
    },
  );

  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => StreamChat(
        client: MockClient(),
        themeData: StreamChatThemeData(messageComposerTheme: globalTheme),
        child: child,
      ),
      home: switch (localTheme) {
        final localTheme? => StreamMessageComposerTheme(data: localTheme, child: leaf),
        _ => leaf,
      },
    ),
  );

  return capturedContext;
}
