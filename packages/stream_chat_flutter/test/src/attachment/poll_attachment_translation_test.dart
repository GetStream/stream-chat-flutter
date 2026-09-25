import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  final message = Message(
    id: 'poll-message',
    createdAt: DateTime(2026),
    user: User(id: 'other-user'),
    poll: Poll(
      id: 'poll-1',
      name: 'Favourite colour?',
      nameI18n: const {'language': 'en', 'nl_text': 'Favoriete kleur?'},
      options: const [
        PollOption(id: 'option-1', text: 'Red', textI18n: {'language': 'en', 'nl_text': 'Rood'}),
        PollOption(id: 'option-2', text: 'Blue', textI18n: {'language': 'en', 'nl_text': 'Blauw'}),
      ],
      // Votes and answers, so the footer offers to view the results and the
      // comments.
      voteCount: 1,
      voteCountsByOption: const {'option-1': 1},
      answersCount: 1,
    ),
  );

  Future<void> pumpPollAttachment(
    WidgetTester tester, {
    String? userLanguage = 'nl',
    StreamMessageTranslationConfiguration translationConfig = const StreamMessageTranslationConfiguration(),
    StreamMessageTranslationStore? translationStore,
  }) {
    final currentUser = OwnUser(id: 'current-user', language: userLanguage);

    final client = MockClient();
    final clientState = MockClientState();
    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(currentUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

    final channel = MockChannel();
    when(
      () => channel.queryPollVotes(
        any(),
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        pagination: any(named: 'pagination'),
      ),
    ).thenAnswer(
      (_) async => QueryPollVotesResponse()
        ..votes = [
          PollVote(
            id: 'answer-1',
            answerText: 'I like yellow',
            answerTextI18n: const {'language': 'en', 'nl_text': 'Ik hou van geel'},
          ),
        ]
        ..next = null,
    );

    Widget child = Scaffold(
      body: StreamChannel.value(
        channel: channel,
        child: StreamPollAttachment(message: message),
      ),
    );
    if (translationStore != null) {
      child = StreamMessageTranslations(store: translationStore, child: child);
    }

    return tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          configData: StreamChatConfigurationData(messageTranslation: translationConfig),
          child: child,
        ),
      ),
    );
  }

  testWidgets('StreamPollAttachment shows the poll translated into the current user language', (tester) async {
    await pumpPollAttachment(tester);

    expect(find.text('Favoriete kleur?'), findsOneWidget);
    expect(find.text('Rood'), findsOneWidget);
    expect(find.text('Blauw'), findsOneWidget);
    expect(find.text('Favourite colour?'), findsNothing);
  });

  testWidgets('StreamPollAttachment shows the original poll when translations are disabled', (tester) async {
    await pumpPollAttachment(
      tester,
      translationConfig: const StreamMessageTranslationConfiguration(enabled: false),
    );

    expect(find.text('Favourite colour?'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Favoriete kleur?'), findsNothing);
  });

  testWidgets('StreamPollAttachment shows the original poll for a reader of the language it was written in', (
    tester,
  ) async {
    await pumpPollAttachment(tester, userLanguage: 'en');

    expect(find.text('Favourite colour?'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
  });

  testWidgets('StreamPollAttachment switches to the original poll when its message is toggled to its original text', (
    tester,
  ) async {
    final translationStore = StreamMessageTranslationStore();
    addTearDown(translationStore.dispose);

    await pumpPollAttachment(tester, translationStore: translationStore);
    expect(find.text('Favoriete kleur?'), findsOneWidget);

    translationStore.toggleOriginalText(message.id);
    await tester.pump();

    expect(find.text('Favourite colour?'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Favoriete kleur?'), findsNothing);
  });

  testWidgets('the poll results sheet shows the poll translated into the current user language', (tester) async {
    await pumpPollAttachment(tester);

    await tester.tap(find.text('View Results'));
    await tester.pumpAndSettle();

    final sheet = find.byType(StreamPollResultsSheet);
    expect(find.descendant(of: sheet, matching: find.text('Favoriete kleur?')), findsOneWidget);
    expect(find.descendant(of: sheet, matching: find.text('Rood')), findsOneWidget);
    expect(find.descendant(of: sheet, matching: find.text('Favourite colour?')), findsNothing);
  });

  testWidgets('the poll comments sheet shows the comments translated into the current user language', (tester) async {
    await pumpPollAttachment(tester);

    await tester.tap(find.text('View Comments'));
    await tester.pumpAndSettle();

    expect(find.text('Ik hou van geel'), findsOneWidget);
    expect(find.text('I like yellow'), findsNothing);
  });

  testWidgets('the poll comments sheet shows the comments as written when translations are disabled', (tester) async {
    await pumpPollAttachment(
      tester,
      translationConfig: const StreamMessageTranslationConfiguration(enabled: false),
    );

    await tester.tap(find.text('View Comments'));
    await tester.pumpAndSettle();

    expect(find.text('I like yellow'), findsOneWidget);
    expect(find.text('Ik hou van geel'), findsNothing);
  });
}
