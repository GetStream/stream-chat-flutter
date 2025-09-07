import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  group('StreamChat.of()', () {
    testWidgets(
      'should return StreamChatState when StreamChat is found in widget tree',
      (tester) async {
        final mockClient = MockClient();
        StreamChatState? chatState;

        final testWidget = StreamChat(
          client: mockClient,
          child: Builder(
            builder: (context) {
              chatState = StreamChat.of(context);
              return const Text('Child Widget');
            },
          ),
        );

        await tester.pumpWidget(MaterialApp(home: testWidget));

        expect(chatState, isNotNull);
        expect(chatState?.client, equals(mockClient));
      },
    );

    testWidgets(
      'should throw FlutterError when StreamChat is not found in widget tree',
      (tester) async {
        Object? caughtError;

        final testWidget = MaterialApp(
          home: Builder(
            builder: (context) {
              try {
                StreamChat.of(context);
              } catch (error) {
                caughtError = error;
              }
              return const Text('Child Widget');
            },
          ),
        );

        await tester.pumpWidget(testWidget);

        expect(caughtError, isA<FlutterError>());
      },
    );
  });

  group('StreamChat.maybeOf()', () {
    testWidgets(
      'should return StreamChatState when StreamChat is found in widget tree',
      (tester) async {
        final mockClient = MockClient();
        StreamChatState? chatState;

        final testWidget = StreamChat(
          client: mockClient,
          child: Builder(
            builder: (context) {
              chatState = StreamChat.maybeOf(context);
              return const Text('Child Widget');
            },
          ),
        );

        await tester.pumpWidget(MaterialApp(home: testWidget));

        expect(chatState, isNotNull);
        expect(chatState?.client, equals(mockClient));
      },
    );

    testWidgets(
      'should return null when StreamChat is not found in widget tree',
      (tester) async {
        StreamChatState? chatState;

        final testWidget = MaterialApp(
          home: Builder(
            builder: (context) {
              chatState = StreamChat.maybeOf(context);
              return const Text('Child Widget');
            },
          ),
        );

        await tester.pumpWidget(testWidget);

        expect(chatState, isNull);
      },
    );
  });

  group('StreamChat widget', () {
    testWidgets(
      'should render child widget when valid client is provided',
      (tester) async {
        final mockClient = MockClient();

        final testWidget = StreamChat(
          client: mockClient,
          child: const Text('Test Child'),
        );

        await tester.pumpWidget(MaterialApp(home: testWidget));

        expect(find.text('Test Child'), findsOneWidget);
      },
    );

    testWidgets(
      'should expose client through StreamChatState',
      (tester) async {
        final mockClient = MockClient();
        StreamChatClient? exposedClient;

        final testWidget = StreamChat(
          client: mockClient,
          child: Builder(
            builder: (context) {
              final chatState = StreamChat.of(context);
              exposedClient = chatState.client;
              return const Text('Child Widget');
            },
          ),
        );

        await tester.pumpWidget(MaterialApp(home: testWidget));

        expect(exposedClient, equals(mockClient));
      },
    );
  });
}
