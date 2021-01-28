import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

class MockShowLocalNotifications extends Mock {
  void call(Message m, ChannelModel cm);
}

void main() {
  testWidgets(
    'StreamChatCore.of(context) should throw an exception',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(() => StreamChatCore.of(context), throwsException);
            return Container();
          },
        ),
      );
    },
  );

  testWidgets(
    'StreamChatCore.of(context) should return the StreamChatCore ancestor',
    (WidgetTester tester) async {
      final client = MockClient();
      await tester.pumpWidget(
        StreamChatCore(
          client: client,
          child: Builder(
            builder: (context) {
              final sc = StreamChatCore.of(context);
              expect(sc, isNotNull);
              return Container();
            },
          ),
        ),
      );
    },
  );

  testWidgets(
    'StreamChatCore.of(context).client should return the client',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(
        OwnUser(
          id: 'test',
        ),
      );
      final userStream = Stream<OwnUser>.value(
        OwnUser(
          id: 'test',
        ),
      );
      when(clientState.userStream).thenAnswer(
        (_) => userStream,
      );

      await tester.pumpWidget(
        StreamChatCore(
          client: client,
          child: Builder(
            builder: (context) {
              final sc = StreamChatCore.of(context);
              expect(sc.client, client);
              expect(sc.user, client.state.user);
              expect(sc.userStream, userStream);
              return Container();
            },
          ),
        ),
      );
    },
  );

  testWidgets(
    'StreamChatCore should disconnect on background',
    (WidgetTester tester) async {
      await fakeAsync((_async) {
        final client = MockClient();
        final clientState = MockClientState();
        final channel = MockChannel();
        when(client.state).thenReturn(clientState);
        when(clientState.user).thenReturn(
          OwnUser(
            id: 'test',
          ),
        );
        final showLocalNotificationMock = MockShowLocalNotifications().call;
        when(client.showLocalNotification)
            .thenReturn(showLocalNotificationMock);
        when(client.backgroundKeepAlive).thenReturn(Duration(
          seconds: 4,
        ));
        final eventStreamController = StreamController<Event>();
        when(client.on(EventType.messageNew))
            .thenAnswer((_) => eventStreamController.stream);

        when(client.channel('test', id: 'testid')).thenReturn(channel);

        final scKey = GlobalKey<StreamChatCoreState>();
        tester.pumpWidget(
          StreamChatCore(
            key: scKey,
            client: client,
            child: Builder(
              builder: (context) {
                return Container();
              },
            ),
          ),
        );

        final sc = scKey.currentState;
        sc.didChangeAppLifecycleState(AppLifecycleState.paused);

        _async.elapse(Duration(seconds: 5));

        verify(client.disconnect()).called(1);
      });
    },
  );

  testWidgets(
    'StreamChatCore should handle notifications when on background and connected',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(
        OwnUser(
          id: 'test',
        ),
      );
      final showLocalNotificationMock = MockShowLocalNotifications().call;
      when(client.showLocalNotification).thenReturn(showLocalNotificationMock);
      when(client.backgroundKeepAlive).thenReturn(Duration(
        seconds: 4,
      ));
      final eventStreamController = StreamController<Event>();
      when(client.on(EventType.messageNew))
          .thenAnswer((_) => eventStreamController.stream);

      when(client.channel('test', id: 'testid')).thenReturn(channel);

      final scKey = GlobalKey<StreamChatCoreState>();
      await tester.pumpWidget(
        StreamChatCore(
          key: scKey,
          client: client,
          child: Builder(
            builder: (context) {
              return Container();
            },
          ),
        ),
      );

      final sc = scKey.currentState;
      sc.didChangeAppLifecycleState(AppLifecycleState.paused);
      final event = Event(
        type: EventType.messageNew,
        message: Message(text: 'hey'),
        channelType: 'test',
        channelId: 'testid',
        user: User(id: 'other user'),
      );
      eventStreamController.add(event);

      await untilCalled(showLocalNotificationMock(any, any));

      verify(showLocalNotificationMock(
        event.message,
        any,
      )).called(1);
    },
  );
}
