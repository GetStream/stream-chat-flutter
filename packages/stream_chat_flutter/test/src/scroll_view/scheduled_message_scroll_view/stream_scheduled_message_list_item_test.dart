import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  final uploading = _scheduledMessage(
    text: '',
    status: ScheduledMessageStatus.preparingToSchedule,
    attachments: [
      Attachment(
        type: AttachmentType.image,
        imageUrl: 'https://example.com/a.jpg',
        uploadState: const UploadState.inProgress(uploaded: 1, total: 4),
      ),
    ],
  );
  final failed = _scheduledMessage(
    status: ScheduledMessageStatus.failed,
    failureReason: ScheduledMessageFailureReason.pendingNotSupported,
  );

  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamScheduledMessageListItem looks fine',
      fileName: 'stream_scheduled_message_list_item_scheduled_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 150),
      builder: () => _wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage()),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> StreamScheduledMessageListItem that failed looks fine',
      fileName: 'stream_scheduled_message_list_item_failed_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 150),
      builder: () => _wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: failed),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> StreamScheduledMessageListItem uploading looks fine',
      fileName: 'stream_scheduled_message_list_item_uploading_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 150),
      // The spinner never settles, so pump a fixed frame instead.
      pumpBeforeTest: (tester) async {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
      },
      builder: () => _wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: uploading),
        brightness: brightness,
      ),
    );
  }

  testWidgets('shows when the message is sent', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage())),
    );

    expect(find.text('Send Wed, Oct 21 at 8:00\u202fAM'), findsOneWidget);
  });

  testWidgets('shows a UTC send time in local time', (tester) async {
    final scheduledAt = DateTime.utc(2026, 10, 21, 8);
    final local = scheduledAt.toLocal();
    final scheduledMessage = _scheduledMessage(scheduledAt: scheduledAt);

    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: scheduledMessage)));

    final sendTime = DateFormat.MMMEd('en_US').format(local);
    final time = DateFormat.jm('en_US').format(local);
    expect(find.text('Send $sendTime at $time'), findsOneWidget);
  });

  testWidgets("names the channel from the scheduled message's channel summary when the channel isn't loaded", (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage())),
    );

    expect(find.text('General'), findsOneWidget);
  });

  testWidgets('shows a preview of the message', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage())),
    );

    expect(find.textContaining('Can you review the venue shortlist?', findRichText: true), findsOneWidget);
  });

  testWidgets('shows the no-title text for a channel without a name', (tester) async {
    final untitled = _scheduledMessage(channel: ChannelModel(cid: 'messaging:general'));

    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: untitled)));

    expect(find.text(DefaultTranslations.instance.noTitleText), findsOneWidget);
    expect(find.text('messaging:general'), findsNothing);
  });

  testWidgets('formats the send time with the theme formatter', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage()),
        chatTheme: StreamChatThemeData(
          scheduledMessageListItemTheme: StreamScheduledMessageListItemThemeData(
            sendTimeFormatter: (_, date) => 'At ${date.hour}h',
          ),
        ),
      ),
    );

    expect(find.text('At 8h'), findsOneWidget);
    expect(find.text('Send Wed, Oct 21 at 8:00\u202fAM'), findsNothing);
  });

  testWidgets('starts a reply in a thread with the thread-reply prefix', (tester) async {
    final reply = _scheduledMessage(text: 'Can someone review it?', parentId: 'parent');

    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: reply)));

    expect(find.text('Thread reply: '), findsOneWidget);
  });

  testWidgets('starts a quoting message with the quoted author', (tester) async {
    final quoted = Message(
      id: 'quoted',
      text: 'Ready?',
      user: User(id: 'alex', name: 'Alex Ross'),
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage(quotedMessage: quoted))),
    );

    expect(find.text('Reply to Alex Ross: '), findsOneWidget);
  });

  testWidgets('shows nothing under the preview while it waits for its time', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage())),
    );

    expect(find.byType(StreamLoadingSpinner), findsNothing);
    expect(find.text('Sending…'), findsNothing);
  });

  testWidgets('says it is sending while it is being sent', (tester) async {
    final sending = _scheduledMessage(status: ScheduledMessageStatus.sending);

    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: sending)));

    expect(find.byType(StreamLoadingSpinner), findsOneWidget);
    expect(find.text('Sending…'), findsOneWidget);
  });

  testWidgets('says it is uploading while its attachments upload', (tester) async {
    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: uploading)));

    expect(find.text('Uploading…'), findsOneWidget);
  });

  testWidgets('says why it could not be sent', (tester) async {
    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: failed)));

    expect(find.text('This channel now needs approval. Schedule it again.'), findsOneWidget);
  });

  testWidgets('dims the send time of one that could not be sent', (tester) async {
    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: failed)));

    final colorScheme = tester.element(find.byType(StreamScheduledMessageListItem)).streamColorScheme;
    final sendTime = tester.widget<Text>(find.text('Send Wed, Oct 21 at 8:00\u202fAM'));
    expect(sendTime.style?.color, colorScheme.textDisabled);
  });

  testWidgets('tints the background when selected', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage(), selected: true)),
    );

    final colorScheme = tester.element(find.byType(StreamScheduledMessageListItem)).streamColorScheme;
    expect(_itemBackground(tester), Color.alphaBlend(colorScheme.backgroundSelected, colorScheme.backgroundApp));
  });

  testWidgets('does not tint the background by default', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage())),
    );

    final colorScheme = tester.element(find.byType(StreamScheduledMessageListItem)).streamColorScheme;
    expect(_itemBackground(tester), colorScheme.backgroundApp);
  });

  testWidgets('merges into one accessible node with the spelled-out send time', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage())),
    );

    expect(
      find.bySemanticsLabel(
        RegExp('Scheduled for Wednesday, October 21, 2026, 8:00 AM.*General.*venue shortlist', dotAll: true),
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('truncates instead of overflowing on a narrow width', (tester) async {
    final item = StreamScheduledMessageListItem(scheduledMessage: failed);

    await tester.pumpWidget(_wrapWithMaterialApp(SizedBox(width: 240, child: item)));

    expect(tester.takeException(), isNull);
  });

  testWidgets('truncates a long quoted author instead of overflowing', (tester) async {
    final quoted = Message(
      id: 'quoted',
      text: 'Ready?',
      user: User(id: 'alex', name: 'Alexandra Montgomery-Fitzwilliam the Third'),
    );
    final item = StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage(quotedMessage: quoted));

    await tester.pumpWidget(_wrapWithMaterialApp(SizedBox(width: 240, child: item)));

    expect(tester.takeException(), isNull);
  });

  testWidgets('builds what a registered component builder returns', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage()),
        componentBuilders: StreamComponentBuilders(
          extensions: streamChatComponentBuilders(
            scheduledMessageListItem: (_, props) => Text('custom ${props.scheduledMessage.id}'),
          ),
        ),
      ),
    );

    expect(find.text('custom scheduled-id'), findsOneWidget);
  });

  test('props.copyWith replaces selected and keeps the other fields', () {
    final item = StreamScheduledMessageListItem(scheduledMessage: _scheduledMessage());

    final copy = item.props.copyWith(selected: true);

    expect(copy.selected, isTrue);
    expect(copy.scheduledMessage, item.props.scheduledMessage);
  });
}

ScheduledMessage _scheduledMessage({
  String text = 'Can you review the venue shortlist?',
  ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
  ScheduledMessageFailureReason? failureReason,
  List<Attachment> attachments = const [],
  String? parentId,
  Message? quotedMessage,
  ChannelModel? channel,
  DateTime? scheduledAt,
}) {
  return ScheduledMessage(
    cid: 'messaging:general',
    channel: channel ?? ChannelModel(cid: 'messaging:general', extraData: const {'name': 'General'}),
    user: User(id: 'current-user-id'),
    message: Message(
      id: 'scheduled-id',
      text: text,
      attachments: attachments,
      parentId: parentId,
      quotedMessageId: quotedMessage?.id,
      quotedMessage: quotedMessage,
    ),
    scheduledAt: scheduledAt ?? DateTime(2026, 10, 21, 8),
    status: status,
    failureReason: failureReason,
  );
}

Color? _itemBackground(WidgetTester tester) {
  final ink = tester.widget<Ink>(
    find.descendant(of: find.byType(StreamScheduledMessageListItem), matching: find.byType(Ink)).first,
  );
  return (ink.decoration! as ShapeDecoration).color;
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness brightness = Brightness.light,
  StreamChatThemeData? chatTheme,
  StreamComponentBuilders? componentBuilders,
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final currentUser = OwnUser(id: 'current-user-id', name: 'Current User');

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.channels).thenReturn({});

  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: StreamChat(
      client: client,
      componentBuilders: componentBuilders,
      configData: StreamChatConfigurationData(),
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      themeData: chatTheme ?? StreamChatThemeData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: context.streamColorScheme.backgroundApp,
            body: Center(child: widget),
          );
        },
      ),
    ),
  );
}
