import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('StreamQuotedMessage keeps a top inset above a lone attachment', (tester) async {
    final inset = await _pumpTopInset(tester, contentKind: StreamMessageContentKind.singleAttachment);

    expect(inset, greaterThan(0));
  });

  testWidgets('StreamQuotedMessage has no top inset in a standard message', (tester) async {
    final inset = await _pumpTopInset(tester, contentKind: StreamMessageContentKind.standard);

    expect(inset, 0);
  });
}

// Pumps a quote laid out for [contentKind] and returns how far its card sits
// below the top of the quote.
Future<double> _pumpTopInset(WidgetTester tester, {required StreamMessageContentKind contentKind}) async {
  final currentUser = OwnUser(id: 'maya', name: 'Maya Ross');
  final client = MockClient();
  final clientState = MockClientState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

  final quotedMessage = Message(
    id: 'quoted',
    text: 'Can you send me a voice note?',
    createdAt: DateTime(2026, 8, 26, 14),
    user: User(id: 'jason', name: 'Jason Thompson'),
    state: MessageState.sent,
  );

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
        child: Scaffold(
          body: StreamMessageLayout(
            data: StreamMessageLayoutData(contentKind: contentKind),
            child: Align(
              alignment: Alignment.topLeft,
              child: StreamQuotedMessage(quotedMessage: quotedMessage),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final quote = tester.getRect(find.byType(StreamQuotedMessage));
  final card = tester.getRect(
    find.descendant(of: find.byType(StreamQuotedMessage), matching: find.byType(Material)).first,
  );
  return card.top - quote.top;
}
