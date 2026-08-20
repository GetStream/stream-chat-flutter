// Tests for [UnreadIndicatorButton]'s two modes.
//
//  - Legacy (no `unreadCount`): the widget subscribes to the current user's
//    read state itself, hides while there is nothing unread, and reports the
//    boundary's `lastReadMessageId` to `onJumpTap`. This is the pre-existing
//    public contract and must keep working for hosts outside the SDK.
//  - Host-driven (`unreadCount` supplied): purely presentational — renders
//    unconditionally with the given count and never touches read state.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  late StreamChatClient client;
  late Channel channel;
  late ChannelClientState channelClientState;
  late ClientState clientState;
  late OwnUser ownUser;
  late StreamController<Read?> currentUserReadController;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    ownUser = OwnUser(id: 'ownid');
    when(() => clientState.currentUser).thenReturn(ownUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));

    currentUserReadController = StreamController<Read?>.broadcast();
    addTearDown(currentUserReadController.close);

    channel = MockChannel();
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);
    when(() => channelClientState.currentUserReadStream).thenAnswer((_) => currentUserReadController.stream);
  });

  Future<void> pumpButton(
    WidgetTester tester, {
    required Future<void> Function(String?) onJumpTap,
    int? unreadCount,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StreamChat(
            client: client,
            themeData: StreamChatThemeData(),
            child: StreamChannel.value(
              channel: channel,
              child: UnreadIndicatorButton(
                unreadCount: unreadCount,
                onJumpTap: onJumpTap,
                onDismissTap: () async {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('legacy mode (no unreadCount)', () {
    testWidgets('hides itself while there is nothing unread', (tester) async {
      when(() => channelClientState.currentUserRead).thenReturn(
        Read(user: ownUser, lastRead: DateTime.now(), unreadMessages: 0),
      );

      await pumpButton(tester, onJumpTap: (_) async {});

      expect(find.byType(StreamJumpToUnreadButton), findsNothing);
    });

    testWidgets('shows itself and reports lastReadMessageId when there is unread', (tester) async {
      when(() => channelClientState.currentUserRead).thenReturn(
        Read(
          user: ownUser,
          lastRead: DateTime.now(),
          unreadMessages: 7,
          lastReadMessageId: 'boundary-id',
        ),
      );

      String? received;
      var called = false;
      await pumpButton(
        tester,
        onJumpTap: (id) async {
          received = id;
          called = true;
        },
      );

      final pill = find.byType(StreamJumpToUnreadButton);
      expect(pill, findsOneWidget);

      // Tapping the widget's own jump area, rather than calling `onJumpTap`
      // directly: what has to keep working is the wiring from the leading
      // section to the callback, including the argument the widget passes.
      final label = tester.widget<StreamJumpToUnreadButton>(pill).props.label;
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(called, isTrue);
      expect(received, 'boundary-id');
    });
  });

  group('host-driven mode (unreadCount supplied)', () {
    testWidgets('renders with the supplied count without reading channel state', (tester) async {
      // Deliberately no `currentUserRead` stub: touching it would throw, so
      // this also proves the widget never consults read state in this mode.
      await pumpButton(tester, onJumpTap: (_) async {}, unreadCount: 3);

      expect(find.byType(StreamJumpToUnreadButton), findsOneWidget);
      verifyNever(() => channelClientState.currentUserRead);
    });

    testWidgets('renders even when the supplied count is zero', (tester) async {
      // Visibility belongs to the host in this mode, so the widget must not
      // second-guess it.
      await pumpButton(tester, onJumpTap: (_) async {}, unreadCount: 0);

      expect(find.byType(StreamJumpToUnreadButton), findsOneWidget);
    });
  });
}
