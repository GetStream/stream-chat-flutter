import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/message_input/stream_chat_message_input.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  testWidgets('composer is docked when the app style is regular', (tester) async {
    await _pumpComposer(tester, appStyle: StreamAppStyle.regular);

    expect(_resolvedLocation(tester), StreamComposerLocation.docked);
  });

  testWidgets('composer floats when the app style is floating', (tester) async {
    await _pumpComposer(tester, appStyle: StreamAppStyle.floating);

    expect(_resolvedLocation(tester), StreamComposerLocation.floating);
  });

  testWidgets('the global composer theme overrides the app style', (tester) async {
    await _pumpComposer(
      tester,
      appStyle: StreamAppStyle.regular,
      globalTheme: const StreamMessageComposerThemeData(location: StreamComposerLocation.floating),
    );

    expect(_resolvedLocation(tester), StreamComposerLocation.floating);
  });

  testWidgets('a local composer theme overrides the global theme', (tester) async {
    await _pumpComposer(
      tester,
      appStyle: StreamAppStyle.floating,
      globalTheme: const StreamMessageComposerThemeData(location: StreamComposerLocation.floating),
      localTheme: const StreamMessageComposerThemeData(location: StreamComposerLocation.docked),
    );

    expect(_resolvedLocation(tester), StreamComposerLocation.docked);
  });

  testWidgets('the location property overrides both the theme and the app style', (tester) async {
    await _pumpComposer(
      tester,
      appStyle: StreamAppStyle.floating,
      globalTheme: const StreamMessageComposerThemeData(location: StreamComposerLocation.floating),
      location: StreamComposerLocation.docked,
    );

    expect(_resolvedLocation(tester), StreamComposerLocation.docked);
  });

  testWidgets('the docked composer fills its background with the elevation-1 color', (tester) async {
    await _pumpComposer(tester, appStyle: StreamAppStyle.regular);

    expect(_backgroundFillFinder(tester), findsOneWidget);
  });

  testWidgets('the floating composer does not fill its background', (tester) async {
    // Floating paints a fading backdrop instead of an opaque fill, so the
    // message list stays visible behind the composer.
    await _pumpComposer(tester, appStyle: StreamAppStyle.floating);

    expect(_backgroundFillFinder(tester), findsNothing);
  });

  testWidgets('the floating composer lifts the input above the bottom safe area', (tester) async {
    const bottomInset = 34.0;
    await _pumpComposer(tester, appStyle: StreamAppStyle.floating, bottomPadding: bottomInset);

    final gap = _gapBelowInput(tester);

    expect(gap, moreOrLessEquals(bottomInset));
  });

  testWidgets('the floating composer keeps a minimum gap when there is no safe area', (tester) async {
    await _pumpComposer(tester, appStyle: StreamAppStyle.floating);

    final gap = _gapBelowInput(tester);

    // Falls back to `spacing.md` so the pill never sits flush with the edge.
    final context = tester.element(find.byType(StreamChatMessageInput));
    expect(gap, moreOrLessEquals(context.streamSpacing.md));
  });

  testWidgets('the floating composer leaves no gap when the safe area is disabled', (tester) async {
    await _pumpComposer(
      tester,
      appStyle: StreamAppStyle.floating,
      bottomPadding: 34,
      enableSafeArea: false,
    );

    final gap = _gapBelowInput(tester);

    expect(gap, moreOrLessEquals(0));
  });
}

/// The location the composer resolved, read back from the input it built.
StreamComposerLocation _resolvedLocation(WidgetTester tester) {
  final input = tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput));
  return input.isFloating ? StreamComposerLocation.floating : StreamComposerLocation.docked;
}

/// Finds the opaque background fill the docked composer paints behind itself.
Finder _backgroundFillFinder(WidgetTester tester) {
  final context = tester.element(find.byType(StreamChatMessageInput));
  final fill = BoxDecoration(color: context.streamColorScheme.backgroundElevation1);

  return find.descendant(
    of: find.byType(StreamMessageComposer),
    matching: find.byWidgetPredicate((widget) => widget is DecoratedBox && widget.decoration == fill),
  );
}

/// The vertical distance between the bottom of the input pill and the bottom
/// of the composer.
double _gapBelowInput(WidgetTester tester) {
  final composer = tester.getRect(find.byType(StreamMessageComposer));
  final input = tester.getRect(find.byType(StreamChatMessageInput));

  return composer.bottom - input.bottom;
}

/// Pumps a [StreamMessageComposer] with the given placement inputs.
///
/// The composer is placed at the bottom of the screen so its rect can be
/// compared against the input pill's.
Future<void> _pumpComposer(
  WidgetTester tester, {
  required StreamAppStyle appStyle,
  StreamMessageComposerThemeData? globalTheme,
  StreamMessageComposerThemeData? localTheme,
  StreamComposerLocation? location,
  bool? enableSafeArea,
  double bottomPadding = 0,
}) async {
  final originalRecordPlatform = RecordPlatform.instance;
  RecordPlatform.instance = FakeRecordPlatform();
  addTearDown(() => RecordPlatform.instance = originalRecordPlatform);

  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.client).thenReturn(client);
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channel.lastMessageAt).thenReturn(null);
  when(() => channel.extraData).thenReturn({'name': 'test'});
  when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({'name': 'test'}));
  when(() => channelState.members).thenReturn([]);
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.messages).thenReturn([]);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.draft).thenReturn(null);

  final composer = StreamMessageComposer(
    location: location,
    enableSafeArea: enableSafeArea,
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: [StreamTheme(appStyle: appStyle)]),
      // Overrides only the padding, so the ambient size, text scale and platform
      // brightness the test binding provides are preserved.
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(padding: EdgeInsets.only(bottom: bottomPadding)),
          child: StreamChat(
            client: client,
            themeData: StreamChatThemeData(messageComposerTheme: globalTheme),
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: switch (localTheme) {
                    final localTheme? => StreamMessageComposerTheme(data: localTheme, child: composer),
                    _ => composer,
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
