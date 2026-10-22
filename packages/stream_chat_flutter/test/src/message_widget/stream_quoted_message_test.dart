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

  testWidgets('StreamQuotedMessage titles a quote of your own message "You"', (tester) async {
    await _pumpQuote(
      tester,
      quotedMessage: _textMessage(
        author: User(id: 'maya', name: 'Maya Ross'),
      ),
      layout: const StreamMessageLayoutData(alignment: StreamMessageAlignment.end),
    );

    expect(find.text('You'), findsOneWidget);
    expect(find.text('Maya Ross'), findsNothing);
  });

  testWidgets("StreamQuotedMessage titles a quote of someone else's message with their name", (tester) async {
    await _pumpQuote(
      tester,
      quotedMessage: _textMessage(
        author: User(id: 'jason', name: 'Jason Thompson'),
      ),
      layout: const StreamMessageLayoutData(alignment: StreamMessageAlignment.end),
    );

    expect(find.text('Jason Thompson'), findsOneWidget);
    expect(find.text('You'), findsNothing);
  });

  testWidgets('StreamQuotedMessage shows a deleted quote in the outgoing text color', (tester) async {
    await _pumpQuote(
      tester,
      quotedMessage: _deletedMessage(),
      layout: const StreamMessageLayoutData(alignment: StreamMessageAlignment.end),
    );

    final colorScheme = tester.element(find.byType(StreamQuotedMessage)).streamColorScheme;
    expect(_deletedLabelColor(tester), colorScheme.brand.shade900);
    expect(_deletedIconColor(tester), colorScheme.brand.shade900);
  });

  testWidgets('StreamQuotedMessage shows a deleted quote in the incoming text color', (tester) async {
    await _pumpQuote(
      tester,
      quotedMessage: _deletedMessage(),
      layout: const StreamMessageLayoutData(alignment: StreamMessageAlignment.start),
    );

    final colorScheme = tester.element(find.byType(StreamQuotedMessage)).streamColorScheme;
    expect(_deletedLabelColor(tester), colorScheme.textPrimary);
    expect(_deletedIconColor(tester), colorScheme.textPrimary);
  });

  testWidgets('StreamQuotedMessage shows a deleted quote in an app-wide deleted style', (tester) async {
    await _pumpQuote(
      tester,
      quotedMessage: _deletedMessage(),
      layout: const StreamMessageLayoutData(alignment: StreamMessageAlignment.end),
      chatTheme: StreamChatThemeData(
        messagePreviewTextTheme: const StreamMessagePreviewTextThemeData(
          deletedMessageStyle: TextStyle(color: Colors.red),
        ),
      ),
    );

    expect(_deletedLabelColor(tester), Colors.red);
    expect(_deletedIconColor(tester), Colors.red);
  });

  testWidgets('StreamQuotedMessage shows a deleted quote in the themed preview style', (tester) async {
    await _pumpQuote(
      tester,
      quotedMessage: _deletedMessage(),
      layout: const StreamMessageLayoutData(alignment: StreamMessageAlignment.end),
      theme: const StreamQuotedMessageThemeData(
        messagePreviewTextTheme: StreamMessagePreviewTextThemeData(
          deletedMessageStyle: TextStyle(color: Colors.orange),
        ),
      ),
    );

    expect(_deletedLabelColor(tester), Colors.orange);
    expect(_deletedIconColor(tester), Colors.orange);
  });
}

Message _textMessage({required User author}) => Message(
  id: 'quoted',
  text: 'Can you send me a voice note?',
  createdAt: DateTime(2026, 8, 26, 14),
  user: author,
  state: MessageState.sent,
);

Message _deletedMessage() => Message(
  id: 'quoted',
  text: 'Can you send me a voice note?',
  type: MessageType.deleted,
  createdAt: DateTime(2026, 8, 26, 14),
  deletedAt: DateTime(2026, 8, 26, 15),
  user: User(id: 'jason', name: 'Jason Thompson'),
  state: MessageState.softDeleted,
);

// Pumps a quote laid out for [contentKind] and returns how far its card sits
// below the top of the quote.
Future<double> _pumpTopInset(WidgetTester tester, {required StreamMessageContentKind contentKind}) async {
  await _pumpQuote(
    tester,
    quotedMessage: Message(
      id: 'quoted',
      text: 'Can you send me a voice note?',
      createdAt: DateTime(2026, 8, 26, 14),
      user: User(id: 'jason', name: 'Jason Thompson'),
      state: MessageState.sent,
    ),
    layout: StreamMessageLayoutData(contentKind: contentKind),
  );

  final quote = tester.getRect(find.byType(StreamQuotedMessage));
  final card = tester.getRect(
    find.descendant(of: find.byType(StreamQuotedMessage), matching: find.byType(Material)).first,
  );
  return card.top - quote.top;
}

Future<void> _pumpQuote(
  WidgetTester tester, {
  required Message quotedMessage,
  required StreamMessageLayoutData layout,
  StreamQuotedMessageThemeData theme = const StreamQuotedMessageThemeData(),
  StreamChatThemeData? chatTheme,
}) async {
  final currentUser = OwnUser(id: 'maya', name: 'Maya Ross');
  final client = MockClient();
  final clientState = MockClientState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
        themeData: chatTheme,
        child: Scaffold(
          body: StreamMessageLayout(
            data: layout,
            child: Align(
              alignment: Alignment.topLeft,
              child: StreamQuotedMessageTheme(
                data: theme,
                child: StreamQuotedMessage(quotedMessage: quotedMessage),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

// The color the "Message deleted" label paints with, after every ancestor
// span's style is applied.
Color? _deletedLabelColor(WidgetTester tester) {
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

// The color the deleted-message icon paints with.
Color? _deletedIconColor(WidgetTester tester) {
  final finder = find.descendant(of: find.byType(StreamMessagePreviewText), matching: find.byType(Icon));
  return tester.widget<Icon>(finder).color ?? IconTheme.of(tester.element(finder)).color;
}
