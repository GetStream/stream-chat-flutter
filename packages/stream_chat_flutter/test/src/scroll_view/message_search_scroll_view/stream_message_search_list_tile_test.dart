import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  testWidgets('shows a deleted message in the tertiary text color', (tester) async {
    await _pumpTile(tester);

    final colorScheme = tester.element(find.byType(StreamMessageSearchListTile)).streamColorScheme;
    expect(_deletedMessageColor(tester), colorScheme.textTertiary);
  });

  testWidgets('shows a deleted message in an app-wide deleted style', (tester) async {
    await _pumpTile(
      tester,
      chatTheme: StreamChatThemeData(
        messagePreviewTextTheme: const StreamMessagePreviewTextThemeData(
          deletedContentStyle: TextStyle(color: Colors.red),
        ),
      ),
    );

    expect(_deletedMessageColor(tester), Colors.red);
  });
}

Future<void> _pumpTile(WidgetTester tester, {StreamChatThemeData? chatTheme}) async {
  final client = MockClient();
  final clientState = MockClientState();
  final currentUser = OwnUser(id: 'maya', name: 'Maya Ross');

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

  final messageResponse = GetMessageResponse()
    ..message = Message(
      id: 'deleted',
      text: 'Can you send me a voice note?',
      type: MessageType.deleted,
      user: User(id: 'jason', name: 'Jason Thompson'),
      createdAt: DateTime(2026, 8, 26, 14),
      deletedAt: DateTime(2026, 8, 26, 15),
    )
    ..channel = ChannelModel(cid: 'messaging:general', extraData: const {'name': 'General'});

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value(const [ConnectivityResult.wifi]),
        themeData: chatTheme,
        child: Scaffold(
          body: StreamMessageSearchListTile(messageResponse: messageResponse),
        ),
      ),
    ),
  );
}

// The color the "Message deleted" text paints with, after every ancestor
// span's style is applied.
Color? _deletedMessageColor(WidgetTester tester) {
  final text = tester.widget<RichText>(
    find.descendant(of: find.byType(StreamMessagePreviewText), matching: find.byType(RichText)).first,
  );

  Color? color;
  void visit(InlineSpan span, TextStyle? inherited) {
    if (span is! TextSpan) return;
    final style = inherited?.merge(span.style) ?? span.style;
    if (span.text == 'Message deleted') color = style?.color;
    for (final child in span.children ?? const <InlineSpan>[]) {
      visit(child, style);
    }
  }

  visit(text.text, null);
  return color;
}
