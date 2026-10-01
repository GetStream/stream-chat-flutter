import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const PaginationParams());
    registerFallbackValue(Message());
    registerFallbackValue(Poll(name: 'fallback', options: const []));
    registerFallbackValue(const PollOption(text: 'fallback'));
  });

  testWidgets('StreamMessageContent shows the poll translated into the current user language', (tester) async {
    await _pumpMessageContent(tester);

    expect(find.text('Favoriete kleur?'), findsOneWidget);
    expect(find.text('Rood'), findsOneWidget);
    expect(find.text('Blauw'), findsOneWidget);
    expect(find.text('Favourite colour?'), findsNothing);
  });

  testWidgets('StreamMessageContent shows the original poll when translations are disabled', (tester) async {
    await _pumpMessageContent(
      tester,
      translationConfig: const StreamMessageTranslationConfiguration(enabled: false),
    );

    expect(find.text('Favourite colour?'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Favoriete kleur?'), findsNothing);
  });

  testWidgets('StreamMessageContent shows the original poll for a reader of the language it was written in', (
    tester,
  ) async {
    await _pumpMessageContent(tester, userLanguage: 'en');

    expect(find.text('Favourite colour?'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
  });

  testWidgets('StreamMessageContent shows the original poll when the message is shown in its original text', (
    tester,
  ) async {
    await _pumpMessageContent(tester, showTranslatedText: false);

    expect(find.text('Favourite colour?'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Favoriete kleur?'), findsNothing);
  });

  testWidgets('StreamMessageContent follows a change of the current user language', (tester) async {
    final currentUser = StreamController<OwnUser?>.broadcast();
    addTearDown(currentUser.close);

    await _pumpMessageContent(tester, currentUserStream: currentUser.stream);
    expect(find.text('Favoriete kleur?'), findsOneWidget);

    currentUser.add(OwnUser(id: _currentUserId, language: 'fr'));
    // Settled, as the attachment picks the new message up a frame later.
    await tester.pumpAndSettle();

    expect(find.text('Couleur préférée ?'), findsOneWidget);
    expect(find.text('Rouge'), findsOneWidget);
    expect(find.text('Favoriete kleur?'), findsNothing);
  });

  testWidgets('StreamMessageContent shows the original poll after switching to the original text', (tester) async {
    final currentUser = StreamController<OwnUser?>.broadcast();
    addTearDown(currentUser.close);

    await _pumpMessageContent(tester, currentUserStream: currentUser.stream);
    expect(find.text('Favoriete kleur?'), findsOneWidget);

    await _pumpMessageContent(tester, currentUserStream: currentUser.stream, showTranslatedText: false);
    // Settled, as the attachment picks the new message up a frame later.
    await tester.pumpAndSettle();

    expect(find.text('Favourite colour?'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Favoriete kleur?'), findsNothing);
  });

  testWidgets('StreamMessageContent passes the poll as displayed to the attachment builders', (tester) async {
    Message? builtMessage;

    await _pumpMessageContent(
      tester,
      attachmentBuilders: [_CapturingPollBuilder((message) => builtMessage = message)],
    );

    expect(builtMessage?.poll?.name, 'Favoriete kleur?');
  });

  testWidgets('StreamMessageContent passes the text as written to the attachment builders', (tester) async {
    Message? builtMessage;
    final message = _pollMessage().copyWith(
      text: 'Vote please',
      i18n: const {'language': 'en', 'nl_text': 'Stem alsjeblieft'},
    );

    await _pumpMessageContent(
      tester,
      message: message,
      attachmentBuilders: [_CapturingPollBuilder((message) => builtMessage = message)],
    );

    expect(find.text('Stem alsjeblieft'), findsOneWidget);
    expect(builtMessage?.text, 'Vote please');
  });

  testWidgets('voting on a translated option sends the ids of the poll and the option', (tester) async {
    final channel = _mockChannel();

    await _pumpMessageContent(tester, channel: channel);
    await tester.tap(find.text('Rood'));
    await tester.pump();

    final captured = verify(() => channel.castPollVote(captureAny(), captureAny(), captureAny())).captured;
    expect((captured[0] as Message).id, 'poll-message');
    expect((captured[1] as Poll).id, 'poll-1');
    expect((captured[2] as PollOption).id, 'option-1');
  });

  testWidgets('the poll results sheet shows the poll translated into the current user language', (tester) async {
    await _pumpMessageContent(tester);

    await tester.tap(find.text('View Results'));
    await tester.pumpAndSettle();

    final sheet = find.byType(StreamPollResultsSheet);
    expect(find.descendant(of: sheet, matching: find.text('Favoriete kleur?')), findsOneWidget);
    expect(find.descendant(of: sheet, matching: find.text('Rood')), findsOneWidget);
    expect(find.descendant(of: sheet, matching: find.text('Favourite colour?')), findsNothing);
  });

  testWidgets('the poll results sheet follows a change of the current user language while open', (tester) async {
    final currentUser = StreamController<OwnUser?>.broadcast();
    addTearDown(currentUser.close);

    await _pumpMessageContent(tester, currentUserStream: currentUser.stream);
    await tester.tap(find.text('View Results'));
    await tester.pumpAndSettle();

    currentUser.add(OwnUser(id: _currentUserId, language: 'fr'));
    await tester.pumpAndSettle();

    final sheet = find.byType(StreamPollResultsSheet);
    expect(find.descendant(of: sheet, matching: find.text('Couleur préférée ?')), findsOneWidget);
  });

  testWidgets('the poll option votes sheet shows the option translated into the current user language', (
    tester,
  ) async {
    await _pumpMessageContent(tester, message: _pollMessage(votesForFirstOption: 6));

    await tester.tap(find.text('View Results'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View all'));
    await tester.pumpAndSettle();

    final sheet = find.byType(StreamPollOptionVotesSheet);
    expect(find.descendant(of: sheet, matching: find.text('Rood')), findsOneWidget);
  });

  testWidgets('the poll option votes sheet follows a change of the current user language while open', (tester) async {
    final currentUser = StreamController<OwnUser?>.broadcast();
    addTearDown(currentUser.close);

    await _pumpMessageContent(
      tester,
      message: _pollMessage(votesForFirstOption: 6),
      currentUserStream: currentUser.stream,
    );
    await tester.tap(find.text('View Results'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View all'));
    await tester.pumpAndSettle();

    currentUser.add(OwnUser(id: _currentUserId, language: 'fr'));
    await tester.pumpAndSettle();

    final sheet = find.byType(StreamPollOptionVotesSheet);
    expect(find.descendant(of: sheet, matching: find.text('Rouge')), findsOneWidget);
  });

  testWidgets('the poll options sheet shows the options translated into the current user language', (tester) async {
    await _pumpMessageContent(tester, message: _pollMessage(extraOptions: 5));

    await tester.tap(find.textContaining('See all'));
    await tester.pumpAndSettle();

    final sheet = find.byType(StreamPollOptionsSheet);
    expect(find.descendant(of: sheet, matching: find.text('Optie 7')), findsOneWidget);
    expect(find.descendant(of: sheet, matching: find.text('Option 7')), findsNothing);
  });

  testWidgets('the poll comments sheet shows the comments translated into the current user language', (tester) async {
    await _pumpMessageContent(tester);

    await tester.tap(find.text('View Comments'));
    await tester.pumpAndSettle();

    expect(find.text('Ik hou van geel'), findsOneWidget);
    expect(find.text('I like yellow'), findsNothing);
  });

  testWidgets('the poll comments sheet shows the comments as written when translations are disabled', (tester) async {
    await _pumpMessageContent(
      tester,
      translationConfig: const StreamMessageTranslationConfiguration(enabled: false),
    );

    await tester.tap(find.text('View Comments'));
    await tester.pumpAndSettle();

    expect(find.text('I like yellow'), findsOneWidget);
    expect(find.text('Ik hou van geel'), findsNothing);
  });

  testWidgets('the poll comments sheet shows the comments as written when the message is shown in its original text', (
    tester,
  ) async {
    await _pumpMessageContent(tester, showTranslatedText: false);

    await tester.tap(find.text('View Comments'));
    await tester.pumpAndSettle();

    expect(find.text('I like yellow'), findsOneWidget);
    expect(find.text('Ik hou van geel'), findsNothing);
  });

  testWidgets('the poll comments sheet prefills the update dialog with the comment as written', (tester) async {
    final ownAnswer = PollVote(
      id: 'answer-1',
      answerText: 'I like yellow',
      answerTextI18n: const {'language': 'en', 'nl_text': 'Ik hou van geel'},
      userId: _currentUserId,
      user: User(id: _currentUserId),
    );
    final message = _pollMessage().copyWith(
      poll: _pollMessage().poll!.copyWith(ownVotesAndAnswers: [ownAnswer], latestAnswers: [ownAnswer]),
    );

    await _pumpMessageContent(
      tester,
      message: message,
      channel: _mockChannel(comments: [ownAnswer]),
    );

    await tester.tap(find.text('View Comments'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update your comment'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'I like yellow'), findsOneWidget);
  });
}

const _currentUserId = 'current-user';

// A poll written in English with Dutch and French translations, sent by
// another user.
//
// [extraOptions] adds untranslated-into-French options after the first two,
// so the attachment offers to see all of them; [votesForFirstOption] above
// the results sheet's limit makes it offer to show all votes of that option.
Message _pollMessage({int extraOptions = 0, int votesForFirstOption = 1}) {
  final votes = [
    for (var i = 0; i < votesForFirstOption; i++)
      PollVote(
        id: 'vote-$i',
        optionId: 'option-1',
        userId: 'voter-$i',
        user: User(id: 'voter-$i'),
        createdAt: DateTime(2026),
      ),
  ];

  return Message(
    id: 'poll-message',
    createdAt: DateTime(2026),
    user: User(id: 'other-user'),
    poll: Poll(
      id: 'poll-1',
      name: 'Favourite colour?',
      nameI18n: const {'language': 'en', 'nl_text': 'Favoriete kleur?', 'fr_text': 'Couleur préférée ?'},
      options: [
        const PollOption(
          id: 'option-1',
          text: 'Red',
          textI18n: {'language': 'en', 'nl_text': 'Rood', 'fr_text': 'Rouge'},
        ),
        const PollOption(
          id: 'option-2',
          text: 'Blue',
          textI18n: {'language': 'en', 'nl_text': 'Blauw', 'fr_text': 'Bleu'},
        ),
        for (var i = 3; i < 3 + extraOptions; i++)
          PollOption(id: 'option-$i', text: 'Option $i', textI18n: {'language': 'en', 'nl_text': 'Optie $i'}),
      ],
      // Votes and answers, so the footer offers to view the results and the
      // comments.
      voteCount: votesForFirstOption,
      voteCountsByOption: {'option-1': votesForFirstOption},
      latestVotesByOption: {'option-1': votes},
      answersCount: 1,
    ),
  );
}

MockChannel _mockChannel({List<PollVote>? comments}) {
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
      ..votes =
          comments ??
          [
            PollVote(
              id: 'answer-1',
              answerText: 'I like yellow',
              answerTextI18n: const {'language': 'en', 'nl_text': 'Ik hou van geel'},
            ),
          ]
      ..next = null,
  );
  when(() => channel.castPollVote(any(), any(), any())).thenAnswer((_) async => CastPollVoteResponse());
  return channel;
}

Future<void> _pumpMessageContent(
  WidgetTester tester, {
  Message? message,
  MockChannel? channel,
  Stream<OwnUser?>? currentUserStream,
  List<StreamAttachmentWidgetBuilder>? attachmentBuilders,
  String? userLanguage = 'nl',
  StreamMessageTranslationConfiguration translationConfig = const StreamMessageTranslationConfiguration(),
  bool showTranslatedText = true,
}) {
  OwnUser? currentUser = OwnUser(id: _currentUserId, language: userLanguage);
  // Like the client's own state, the current user follows its stream.
  final userSubscription = currentUserStream?.listen((user) => currentUser = user);
  if (userSubscription != null) addTearDown(userSubscription.cancel);

  final client = MockClient();
  final clientState = MockClientState();
  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenAnswer((_) => currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => currentUserStream ?? Stream.value(currentUser));

  return tester.pumpWidget(
    MaterialApp(
      // Above the navigator, so the poll sheets can read the current user.
      builder: (context, child) => StreamChat(
        client: client,
        configData: StreamChatConfigurationData(messageTranslation: translationConfig),
        child: child,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: StreamChannel.value(
            channel: channel ?? _mockChannel(),
            child: StreamMessageContent(
              message: message ?? _pollMessage(),
              showTranslatedText: showTranslatedText,
              attachmentBuilders: attachmentBuilders,
            ),
          ),
        ),
      ),
    ),
  );
}

// Builds the poll as the default builder does, reporting the message it is
// given.
class _CapturingPollBuilder extends PollAttachmentBuilder {
  _CapturingPollBuilder(this.onBuild);

  final ValueSetter<Message> onBuild;

  @override
  Widget? build(BuildContext context, Message message, Map<String, List<Attachment>> attachments) {
    onBuild(message);
    return super.build(context, message, attachments);
  }
}
