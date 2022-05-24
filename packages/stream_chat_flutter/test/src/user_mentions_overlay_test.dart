import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/user_mentions_overlay.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'It should display the users from the usersToMention parameter',
    (WidgetTester tester) async {
      final client = MockClient();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => channel.state).thenReturn(channelState);

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamUserMentionsOverlay(
            query: '',
            channel: channel,
            size: const Size(200, 200),
            usersToMention: [
              User(id: 'user-id-0', name: 'user-name-0'),
              User(id: 'user-id-1', name: 'user-name-1'),
              User(id: 'user-id-2', name: 'user-name-2'),
              User(id: 'user-id-3', name: 'user-name-3'),
            ],
          ),
        ),
      ));

      await tester.pump();

      expect(
        find.byType(StreamUserMentionTile),
        findsNWidgets(4),
        reason: 'The 4 provided users should be displayed as options to be'
            ' mentioned',
      );
      // It should display the 4 provided users.
      expect(find.text('user-name-0'), findsOneWidget);
      expect(find.text('@user-id-0'), findsOneWidget);
      expect(find.text('user-name-1'), findsOneWidget);
      expect(find.text('@user-id-1'), findsOneWidget);
      expect(find.text('user-name-2'), findsOneWidget);
      expect(find.text('@user-id-2'), findsOneWidget);
      expect(find.text('user-name-3'), findsOneWidget);
      expect(find.text('@user-id-3'), findsOneWidget);

      // It should not have queried the users from the channel.
      verifyNever(
        () => channel.queryMembers(
          pagination: any(named: 'pagination'),
          filter: any(named: 'filter'),
        ),
      );
    },
  );

  testWidgets(
    'It should display the filtered users from the usersToMention parameter',
    (WidgetTester tester) async {
      final client = MockClient();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => channel.state).thenReturn(channelState);

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamUserMentionsOverlay(
            query: '2',
            channel: channel,
            size: const Size(200, 200),
            usersToMention: [
              User(id: 'user-id-0', name: 'user-name-0'),
              User(id: 'user-id-1', name: 'user-name-1'),
              User(id: 'user-id-2', name: 'user-name-2'),
              User(id: 'user-id-3', name: 'user-name-3'),
            ],
          ),
        ),
      ));

      await tester.pump();

      expect(
        find.byType(StreamUserMentionTile),
        findsOneWidget,
        reason: 'The 4 provided users should be filtered and only one should'
            ' be displayed',
      );
      // It should only display the 1 user from the provided ones.
      expect(find.text('user-name-0'), findsNothing);
      expect(find.text('@user-id-0'), findsNothing);
      expect(find.text('user-name-1'), findsNothing);
      expect(find.text('@user-id-1'), findsNothing);
      expect(find.text('user-name-2'), findsOneWidget);
      expect(find.text('@user-id-2'), findsOneWidget);
      expect(find.text('user-name-3'), findsNothing);
      expect(find.text('@user-id-3'), findsNothing);

      // It should not have queried the users from the channel.
      verifyNever(
        () => channel.queryMembers(
          pagination: any(named: 'pagination'),
          filter: any(named: 'filter'),
        ),
      );
    },
  );
}
