import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/message_input/stream_chat_message_input.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

/// A message scheduled in the channel.
ScheduledMessage scheduledMessage() {
  return ScheduledMessage(
    id: 'scheduled-id',
    cid: 'test-chanel-type:test-channel-id',
    user: User(id: 'user-id'),
    message: Message(id: 'scheduled-id', text: 'Later'),
    scheduledAt: DateTime(2026, 10, 23, 9),
    status: ScheduledMessageStatus.scheduled,
  );
}

/// The visible pill of the scheduled messages banner, inside its margin.
Rect bannerPill(WidgetTester tester) {
  final pill = find.descendant(of: find.byType(StreamScheduledMessagesBanner), matching: find.byType(Material));
  return tester.getRect(pill.first);
}

/// The page's message list.
StreamMessageListView messageListView(WidgetTester tester) {
  return tester.widget<StreamMessageListView>(find.byType(StreamMessageListView));
}

/// The controller the page created and handed to its composer.
StreamMessageComposerController composerController(WidgetTester tester) {
  return tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput)).controller!;
}

/// The focus node the page created and handed to its composer.
FocusNode composerFocusNode(WidgetTester tester) {
  return tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput)).focusNode!;
}

/// Pumps a [StreamChannelPage] for a channel holding [scheduledMessages].
Future<void> pumpChannelPage(
  WidgetTester tester, {
  StreamSurfaceStyle surfaceStyle = StreamSurfaceStyle.regular,
  StreamSurfaceStyle? composerSurfaceStyle,
  StreamSurfaceStyle? headerSurfaceStyle,
  void Function(BuildContext context, Channel channel)? onChannelAvatarPressed,
  bool automaticallyImplyLeading = true,
  VoidCallback? onBackPressed,
  bool pushOntoARoute = false,
  List<ScheduledMessage> scheduledMessages = const [],
  Stream<List<ScheduledMessage>>? scheduledMessagesStream,
  bool showScheduledMessagesBanner = true,
  StreamScheduledMessagesViewAllCallback? onScheduledMessagesViewAllPressed,
}) async {
  final originalRecordPlatform = RecordPlatform.instance;
  RecordPlatform.instance = FakeRecordPlatform();
  addTearDown(() => RecordPlatform.instance = originalRecordPlatform);

  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(
    ownCapabilities: [
      ChannelCapability.sendMessage,
      ChannelCapability.uploadFile,
      ChannelCapability.scheduleMessage,
    ],
  );
  final channelState = MockChannelState();
  final currentUser = OwnUser(id: 'user-id');

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
  when(() => clientState.totalUnreadCount).thenReturn(0);
  when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(0));
  // Keyed by cid so the header's back button can resolve the open channel's
  // unread count and exclude it from the total.
  when(() => clientState.channels).thenReturn({channel.cid!: channel});

  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelState);
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channel.lastMessageAt).thenReturn(null);
  when(() => channel.name).thenReturn('test');
  when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
  when(() => channel.image).thenReturn(null);
  when(() => channel.imageStream).thenAnswer((_) => Stream.value(null));
  when(() => channel.isMuted).thenReturn(false);
  when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));
  when(() => channel.extraData).thenReturn({'name': 'test'});
  when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({'name': 'test'}));

  when(() => channelState.members).thenReturn([]);
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.messages).thenReturn([]);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.threadsStream).thenAnswer((_) => const Stream.empty());
  when(() => channelState.draft).thenReturn(null);
  when(() => channelState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
  when(() => channelState.unreadCount).thenReturn(0);
  when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(0));
  when(() => channelState.readStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.currentUserRead).thenReturn(null);
  when(() => channelState.currentUserReadStream).thenAnswer((_) => const Stream.empty());
  when(() => clientState.scheduledMessages).thenReturn(scheduledMessages);
  when(
    () => clientState.scheduledMessagesStream,
  ).thenAnswer((_) => scheduledMessagesStream ?? Stream.value(scheduledMessages));

  final page = StreamChannelPage(
    onChannelAvatarPressed: onChannelAvatarPressed,
    automaticallyImplyLeading: automaticallyImplyLeading,
    onBackPressed: onBackPressed,
    showScheduledMessagesBanner: showScheduledMessagesBanner,
    onScheduledMessagesViewAllPressed: onScheduledMessagesViewAllPressed,
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: [StreamTheme(surfaceStyle: surfaceStyle)]),
      // Chat context lives above the navigator so it survives a pop.
      builder: (context, child) {
        Widget content = StreamChannel(channel: channel, child: child!);
        if (composerSurfaceStyle != null) {
          content = StreamMessageComposerTheme(
            data: StreamMessageComposerThemeData(surfaceStyle: composerSurfaceStyle),
            child: content,
          );
        }
        return StreamChat(
          client: client,
          themeData: switch (headerSurfaceStyle) {
            final surfaceStyle? => StreamChatThemeData(
              channelHeaderTheme: StreamAppBarThemeData(style: StreamAppBarStyle(surfaceStyle: surfaceStyle)),
            ),
            _ => null,
          },
          child: content,
        );
      },
      // '/channel' seeds the stack with '/' underneath it, giving the back
      // button something to pop to.
      initialRoute: pushOntoARoute ? '/channel' : '/',
      routes: {
        '/': (_) => pushOntoARoute ? const Scaffold(body: SizedBox.shrink()) : page,
        '/channel': (_) => page,
      },
    ),
  );

  await tester.pumpAndSettle();
}
