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

  group('StreamChat theme injection', () {
    testWidgets(
      'descendants find StreamTheme via Theme.of(context).extension when host '
      'app did not register one',
      (tester) async {
        final mockClient = MockClient();
        StreamTheme? captured;

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: mockClient,
              child: Builder(
                builder: (context) {
                  captured = Theme.of(context).extension<StreamTheme>();
                  return const Text('Child');
                },
              ),
            ),
          ),
        );

        expect(captured, isNotNull);
      },
    );

    testWidgets(
      'preserves a StreamTheme that the host app already registered on '
      'MaterialApp.theme.extensions',
      (tester) async {
        final mockClient = MockClient();
        final registered = StreamTheme.light();
        StreamTheme? captured;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [registered]),
            home: StreamChat(
              client: mockClient,
              child: Builder(
                builder: (context) {
                  captured = Theme.of(context).extension<StreamTheme>();
                  return const Text('Child');
                },
              ),
            ),
          ),
        );

        expect(captured, same(registered));
      },
    );

    testWidgets(
      'preserves other Material theme extensions registered above StreamChat',
      (tester) async {
        final mockClient = MockClient();
        const sibling = _SiblingThemeExtension(label: 'kept');
        _SiblingThemeExtension? captured;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: const [sibling]),
            home: StreamChat(
              client: mockClient,
              child: Builder(
                builder: (context) {
                  captured = Theme.of(context).extension<_SiblingThemeExtension>();
                  return const Text('Child');
                },
              ),
            ),
          ),
        );

        expect(captured, same(sibling));
      },
    );
  });
}

class _SiblingThemeExtension extends ThemeExtension<_SiblingThemeExtension> {
  const _SiblingThemeExtension({required this.label});

  final String label;

  @override
  ThemeExtension<_SiblingThemeExtension> copyWith({String? label}) =>
      _SiblingThemeExtension(label: label ?? this.label);

  @override
  ThemeExtension<_SiblingThemeExtension> lerp(
    covariant ThemeExtension<_SiblingThemeExtension>? other,
    double t,
  ) => this;
}
