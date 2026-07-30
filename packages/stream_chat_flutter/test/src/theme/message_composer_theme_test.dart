import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  test('copyWith with no arguments returns an equal MessageComposerThemeData', () {
    const themeData = StreamMessageComposerThemeData(location: StreamComposerLocation.floating);

    expect(themeData.copyWith(), themeData);
  });

  test('copyWith with no arguments preserves the hashCode', () {
    const themeData = StreamMessageComposerThemeData(location: StreamComposerLocation.floating);

    expect(themeData.copyWith().hashCode, themeData.hashCode);
  });

  test('copyWith overrides the location', () {
    const docked = StreamMessageComposerThemeData(location: StreamComposerLocation.docked);

    expect(docked.copyWith(location: StreamComposerLocation.floating).location, StreamComposerLocation.floating);
  });

  test('MessageComposerThemeData instances with different locations are not equal', () {
    expect(
      const StreamMessageComposerThemeData(location: StreamComposerLocation.docked),
      isNot(const StreamMessageComposerThemeData(location: StreamComposerLocation.floating)),
    );
  });

  test('lerp at t = 0 resolves to the start location', () {
    expect(
      StreamMessageComposerThemeData.lerp(_dockedTheme, _floatingTheme, 0)?.location,
      StreamComposerLocation.docked,
    );
  });

  test('lerp below the halfway point resolves to the start location', () {
    expect(
      StreamMessageComposerThemeData.lerp(_dockedTheme, _floatingTheme, 0.49)?.location,
      StreamComposerLocation.docked,
    );
  });

  test('lerp at or past the halfway point resolves to the end location', () {
    expect(
      StreamMessageComposerThemeData.lerp(_dockedTheme, _floatingTheme, 0.5)?.location,
      StreamComposerLocation.floating,
    );
  });

  test('lerp at t = 1 resolves to the end location', () {
    expect(StreamMessageComposerThemeData.lerp(_dockedTheme, _floatingTheme, 1), _floatingTheme);
  });

  test('merge with null keeps the original location', () {
    expect(_dockedTheme.merge(null), _dockedTheme);
  });

  test('merge overrides the location with the other theme', () {
    expect(_dockedTheme.merge(_floatingTheme), _floatingTheme);
  });

  test('merge with an empty theme keeps the original location', () {
    expect(_floatingTheme.merge(const StreamMessageComposerThemeData()), _floatingTheme);
  });

  testWidgets('of returns a null location when no theme is configured', (tester) async {
    final context = await _pumpAndCaptureContext(tester);

    expect(StreamMessageComposerTheme.of(context).location, isNull);
  });

  testWidgets('of returns the global theme location when no local theme is present', (tester) async {
    final context = await _pumpAndCaptureContext(tester, globalTheme: _floatingTheme);

    expect(StreamMessageComposerTheme.of(context).location, StreamComposerLocation.floating);
  });

  testWidgets('of merges the local theme over the global theme', (tester) async {
    final context = await _pumpAndCaptureContext(
      tester,
      globalTheme: _dockedTheme,
      localTheme: _floatingTheme,
    );

    expect(StreamMessageComposerTheme.of(context).location, StreamComposerLocation.floating);
  });

  testWidgets('of falls back to the global theme when the local theme sets no location', (tester) async {
    final context = await _pumpAndCaptureContext(
      tester,
      globalTheme: _floatingTheme,
      localTheme: const StreamMessageComposerThemeData(),
    );

    expect(StreamMessageComposerTheme.of(context).location, StreamComposerLocation.floating);
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

    expect(StreamMessageComposerTheme.of(capturedContext).location, StreamComposerLocation.floating);
  });

  testWidgets('updateShouldNotify is true when the data changes', (tester) async {
    const oldWidget = StreamMessageComposerTheme(data: _dockedTheme, child: SizedBox.shrink());
    const newWidget = StreamMessageComposerTheme(data: _floatingTheme, child: SizedBox.shrink());

    expect(newWidget.updateShouldNotify(oldWidget), isTrue);
  });

  testWidgets('updateShouldNotify is false when the data is unchanged', (tester) async {
    const oldWidget = StreamMessageComposerTheme(data: _dockedTheme, child: SizedBox.shrink());
    const newWidget = StreamMessageComposerTheme(data: _dockedTheme, child: SizedBox.shrink());

    expect(newWidget.updateShouldNotify(oldWidget), isFalse);
  });
}

const _dockedTheme = StreamMessageComposerThemeData(location: StreamComposerLocation.docked);
const _floatingTheme = StreamMessageComposerThemeData(location: StreamComposerLocation.floating);

/// Pumps a [StreamChat] configured with [globalTheme], optionally wrapped in a
/// local [StreamMessageComposerTheme] carrying [localTheme], and returns a
/// context below both.
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
