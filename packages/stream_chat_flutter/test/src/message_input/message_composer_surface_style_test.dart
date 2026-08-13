import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/message_input/stream_chat_message_input.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  testWidgets('composer is regular when the app style is regular', (tester) async {
    await _pumpComposer(tester, surfaceStyle: StreamSurfaceStyle.regular);

    expect(_resolvedSurfaceStyle(tester), StreamSurfaceStyle.regular);
  });

  testWidgets('composer floats when the app style is floating', (tester) async {
    await _pumpComposer(tester, surfaceStyle: StreamSurfaceStyle.floating);

    expect(_resolvedSurfaceStyle(tester), StreamSurfaceStyle.floating);
  });

  testWidgets('the global composer theme overrides the app style', (tester) async {
    await _pumpComposer(
      tester,
      surfaceStyle: StreamSurfaceStyle.regular,
      globalTheme: const StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.floating),
    );

    expect(_resolvedSurfaceStyle(tester), StreamSurfaceStyle.floating);
  });

  testWidgets('a local composer theme overrides the global theme', (tester) async {
    await _pumpComposer(
      tester,
      surfaceStyle: StreamSurfaceStyle.floating,
      globalTheme: const StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.floating),
      localTheme: const StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.regular),
    );

    expect(_resolvedSurfaceStyle(tester), StreamSurfaceStyle.regular);
  });

  testWidgets('the surfaceStyle property overrides both the theme and the app style', (tester) async {
    await _pumpComposer(
      tester,
      surfaceStyle: StreamSurfaceStyle.floating,
      globalTheme: const StreamMessageComposerThemeData(surfaceStyle: StreamSurfaceStyle.floating),
      composerSurfaceStyle: StreamSurfaceStyle.regular,
    );

    expect(_resolvedSurfaceStyle(tester), StreamSurfaceStyle.regular);
  });

  testWidgets('the regular composer fills its background with the elevation-1 color', (tester) async {
    await _pumpComposer(tester, surfaceStyle: StreamSurfaceStyle.regular);

    expect(_backgroundFillFinder(tester), findsOneWidget);
  });

  testWidgets('the floating composer does not fill its background', (tester) async {
    // Floating paints a fading backdrop instead of an opaque fill, so the
    // message list stays visible behind the composer.
    await _pumpComposer(tester, surfaceStyle: StreamSurfaceStyle.floating);

    expect(_backgroundFillFinder(tester), findsNothing);
  });

  testWidgets('the composer clears the bottom inset by a margin', (tester) async {
    const bottomInset = 34.0;
    await _pumpComposer(tester, surfaceStyle: StreamSurfaceStyle.floating, bottomPadding: bottomInset);

    final gap = _gapBelowInput(tester);

    // The margin is added on top of the inset, so the composer clears the system
    // bar rather than sitting flush against it.
    final context = tester.element(find.byType(StreamChatMessageInput));
    expect(gap, moreOrLessEquals(bottomInset + context.streamSpacing.md));
  });

  testWidgets('the composer keeps its margin without an inset', (tester) async {
    // No inset means the window does not extend behind the system bar, so the
    // margin stands in for it rather than stacking on a bar the composer can't
    // see.
    await _pumpComposer(tester, surfaceStyle: StreamSurfaceStyle.floating);

    final gap = _gapBelowInput(tester);

    final context = tester.element(find.byType(StreamChatMessageInput));
    expect(gap, moreOrLessEquals(context.streamSpacing.md));
  });

  testWidgets('the composer rests on the bottom inset on Apple platforms', (tester) async {
    const bottomInset = 34.0;
    await _pumpComposer(
      tester,
      surfaceStyle: StreamSurfaceStyle.floating,
      bottomPadding: bottomInset,
      platform: TargetPlatform.iOS,
    );

    // Apple platforms add no margin — the home indicator inset is the gap.
    expect(_gapBelowInput(tester), moreOrLessEquals(bottomInset));
  });

  testWidgets('the composer keeps a margin on Apple platforms without an inset', (tester) async {
    // iPhones without a home indicator, iPads with a home button, macOS and web
    // on either: no inset to rest on, so the margin applies after all.
    await _pumpComposer(tester, surfaceStyle: StreamSurfaceStyle.floating, platform: TargetPlatform.iOS);

    final context = tester.element(find.byType(StreamChatMessageInput));
    expect(_gapBelowInput(tester), moreOrLessEquals(context.streamSpacing.md));
  });

  testWidgets('the floating composer leaves no gap when the safe area is disabled', (tester) async {
    await _pumpComposer(
      tester,
      surfaceStyle: StreamSurfaceStyle.floating,
      bottomPadding: 34,
      enableSafeArea: false,
    );

    final gap = _gapBelowInput(tester);

    expect(gap, moreOrLessEquals(0));
  });

  testWidgets('the floating composer collapses the bottom inset while the attachment picker is open', (tester) async {
    // The inset lifts the pill above the system inset when the picker is closed,
    // but must collapse to zero while it is open so the edge-to-edge attachment
    // gallery can reach the screen bottom.
    await _pumpComposer(tester, surfaceStyle: StreamSurfaceStyle.floating, bottomPadding: 34);

    double insetBottom() {
      // The applied inset is the outermost Padding inside the composer's safe area.
      final padding = tester.widget<Padding>(
        find.descendant(of: find.byType(StreamSafeArea), matching: find.byType(Padding)).first,
      );
      return padding.padding.resolve(TextDirection.ltr).bottom;
    }

    // Closed: the injected inset (34) plus the margin.
    final context = tester.element(find.byType(StreamChatMessageInput));
    expect(insetBottom(), moreOrLessEquals(34 + context.streamSpacing.md));

    await tester.tap(_attachmentButtonFinder);
    await tester.pumpAndSettle();

    // Open: the inset has collapsed.
    expect(insetBottom(), moreOrLessEquals(0));
  });
}

// The composer's attachment (picker) button, in the leading slot.
final _attachmentButtonFinder = find.descendant(
  of: find.byType(DefaultStreamMessageComposerLeading),
  matching: find.byType(StreamButton),
);

// The surface style the composer resolved, read back from the input it built.
StreamSurfaceStyle _resolvedSurfaceStyle(WidgetTester tester) {
  final input = tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput));
  return input.isFloating ? StreamSurfaceStyle.floating : StreamSurfaceStyle.regular;
}

// Finds the opaque background fill the regular composer paints behind itself.
Finder _backgroundFillFinder(WidgetTester tester) {
  final context = tester.element(find.byType(StreamChatMessageInput));
  final fill = BoxDecoration(color: context.streamColorScheme.backgroundElevation1);

  return find.descendant(
    of: find.byType(StreamMessageComposer),
    matching: find.byWidgetPredicate((widget) => widget is DecoratedBox && widget.decoration == fill),
  );
}

// The vertical distance between the bottom of the input pill and the bottom
// of the composer.
double _gapBelowInput(WidgetTester tester) {
  final composer = tester.getRect(find.byType(StreamMessageComposer));
  final input = tester.getRect(find.byType(StreamChatMessageInput));

  return composer.bottom - input.bottom;
}

// Pumps a [StreamMessageComposer] with the given placement inputs.
//
// The composer is placed at the bottom of the screen so its rect can be
// compared against the input pill's.
Future<void> _pumpComposer(
  WidgetTester tester, {
  required StreamSurfaceStyle surfaceStyle,
  StreamMessageComposerThemeData? globalTheme,
  StreamMessageComposerThemeData? localTheme,
  StreamSurfaceStyle? composerSurfaceStyle,
  bool? enableSafeArea,
  double bottomPadding = 0,
  TargetPlatform? platform,
}) async {
  final originalRecordPlatform = RecordPlatform.instance;
  RecordPlatform.instance = FakeRecordPlatform();
  addTearDown(() => RecordPlatform.instance = originalRecordPlatform);

  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  // Read by the attachment validator when the picker opens.
  when(() => client.appSettings).thenReturn(
    const AppSettings(fileUploadConfig: UploadConfig(), imageUploadConfig: UploadConfig()),
  );
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
    surfaceStyle: composerSurfaceStyle,
    enableSafeArea: enableSafeArea,
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        platform: platform,
        extensions: [StreamTheme(surfaceStyle: surfaceStyle)],
      ),
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
