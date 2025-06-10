import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  final message = Message(
    id: 'test-message',
    text: 'This is a test message',
    createdAt: DateTime.now(),
    user: User(id: 'test-user', name: 'Test User'),
    latestReactions: [
      Reaction(
        type: 'love',
        messageId: 'test-message',
        user: User(id: 'user-1', name: 'User 1'),
        createdAt: DateTime.now(),
      ),
      Reaction(
        type: 'like',
        messageId: 'test-message',
        user: User(id: 'user-2', name: 'User 2'),
        createdAt: DateTime.now(),
      ),
    ],
    reactionGroups: {
      'love': ReactionGroup(count: 1, sumScores: 1),
      'like': ReactionGroup(count: 1, sumScores: 1),
    },
  );

  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();

    final mockClientState = MockClientState();
    when(() => mockClient.state).thenReturn(mockClientState);

    // Mock the current user for the message reactions test
    final currentUser = OwnUser(id: 'current-user', name: 'Current User');
    when(() => mockClientState.currentUser).thenReturn(currentUser);
  });

  tearDown(() => reset(mockClient));

  group('StreamMessageReactionsModal', () {
    testWidgets(
      'renders message widget and reactions correctly',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            client: mockClient,
            StreamMessageReactionsModal(
              message: message,
              messageWidget: const Text('Message Widget'),
            ),
          ),
        );

        // Use a longer timeout to ensure everything is rendered
        await tester.pumpAndSettle(const Duration(seconds: 2));
        expect(find.text('Message Widget'), findsOneWidget);
        // Check for reaction picker
        expect(find.byType(StreamReactionPicker), findsOneWidget);
        // Check for reaction details
        expect(find.byType(StreamUserReactions), findsOneWidget);
      },
    );

    testWidgets(
      'calls onUserAvatarTap when user avatar is tapped',
      (tester) async {
        User? tappedUser;

        // Create just the StreamUserAvatar directly
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            client: mockClient,
            StreamMessageReactionsModal(
              message: message,
              messageWidget: const Text('Message Widget'),
              onUserAvatarTap: (user) {
                tappedUser = user;
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        final avatar = find.descendant(
          of: find.byType(StreamUserReactions),
          matching: find.byType(StreamUserAvatar),
        );

        // Verify the avatar is rendered
        expect(avatar, findsNWidgets(2));

        // Tap on the first avatar directly
        await tester.tap(avatar.first);
        await tester.pumpAndSettle();

        // Verify the callback was called
        expect(tappedUser, isNotNull);
      },
    );

    testWidgets(
      'calls onReactionPicked with SelectReaction when reaction is selected',
      (tester) async {
        MessageAction? messageAction;

        // Define custom reaction icons for testing
        final testReactionIcons = [
          StreamReactionIcon(
            type: 'like',
            builder: (context, isActive, size) => const Icon(Icons.thumb_up),
          ),
          StreamReactionIcon(
            type: 'love',
            builder: (context, isActive, size) => const Icon(Icons.favorite),
          ),
          StreamReactionIcon(
            type: 'camera',
            builder: (context, isActive, size) => const Icon(Icons.camera),
          ),
          StreamReactionIcon(
            type: 'call',
            builder: (context, isActive, size) => const Icon(Icons.call),
          ),
        ];

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            client: mockClient,
            reactionIcons: testReactionIcons,
            StreamMessageReactionsModal(
              message: message,
              messageWidget: const Text('Message Widget'),
              onReactionPicked: (action) => messageAction = action,
            ),
          ),
        );

        // Use a longer timeout to ensure everything is rendered
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Verify reaction picker is shown
        expect(find.byType(StreamReactionPicker), findsOneWidget);

        // Find and tap the camera reaction (camera)
        final reactionIconFinder = find.byIcon(Icons.camera);
        expect(reactionIconFinder, findsOneWidget);
        await tester.tap(reactionIconFinder);
        await tester.pumpAndSettle();

        expect(messageAction, isA<SelectReaction>());
        // Verify callback was called with correct reaction type
        expect((messageAction! as SelectReaction).reaction.type, 'camera');

        // Find and tap the call reaction (call)
        final loveIconFinder = find.byIcon(Icons.call);
        expect(loveIconFinder, findsOneWidget);
        await tester.tap(loveIconFinder);
        await tester.pumpAndSettle();

        expect(messageAction, isA<SelectReaction>());
        // Verify callback was called with correct reaction type
        expect((messageAction! as SelectReaction).reaction.type, 'call');
      },
    );
  });

  group('StreamMessageReactionsModal Golden Tests', () {
    Widget buildMessageWidget({bool reverse = false}) {
      return Builder(
        builder: (context) {
          final theme = StreamChatTheme.of(context);
          final messageTheme = theme.getMessageTheme(reverse: reverse);

          return Align(
            alignment: reverse ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: messageTheme.messageBackgroundColor,
              ),
              child: Text(
                message.text ?? '',
                style: messageTheme.messageTextStyle,
              ),
            ),
          );
        },
      );
    }

    for (final brightness in Brightness.values) {
      final theme = brightness.name;

      goldenTest(
        'StreamMessageReactionsModal in $theme theme',
        fileName: 'stream_message_reactions_modal_$theme',
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        builder: () => _wrapWithMaterialApp(
          client: mockClient,
          brightness: brightness,
          StreamMessageReactionsModal(
            message: message,
            messageWidget: buildMessageWidget(),
            onReactionPicked: (_) {},
          ),
        ),
      );

      goldenTest(
        'StreamMessageReactionsModal reversed in $theme theme',
        fileName: 'stream_message_reactions_modal_reversed_$theme',
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        builder: () => _wrapWithMaterialApp(
          client: mockClient,
          brightness: brightness,
          StreamMessageReactionsModal(
            message: message,
            messageWidget: buildMessageWidget(reverse: true),
            reverse: true,
            onReactionPicked: (_) {},
          ),
        ),
      );
    }
  });
}

Widget _wrapWithMaterialApp(
  Widget child, {
  required StreamChatClient client,
  Brightness? brightness,
  List<StreamReactionIcon>? reactionIcons,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamChat(
      client: client,
      // Mock the connectivity stream to always return wifi.
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      child: StreamChatConfiguration(
        data: StreamChatConfigurationData(reactionIcons: reactionIcons),
        child: StreamChatTheme(
          data: StreamChatThemeData(brightness: brightness),
          child: Builder(builder: (context) {
            final theme = StreamChatTheme.of(context);
            return Scaffold(
              backgroundColor: theme.colorTheme.appBg,
              body: ColoredBox(
                color: theme.colorTheme.overlay,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: child,
                ),
              ),
            );
          }),
        ),
      ),
    ),
  );
}
