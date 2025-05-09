import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_modal/message_reactions_modal.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reactions_card.dart';
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
      Reaction(
        type: 'wow',
        messageId: 'test-message',
        user: User(id: 'user-3', name: 'User 3'),
        createdAt: DateTime.now(),
      ),
    ],
    reactionCounts: const {'love': 1, 'like': 1, 'wow': 1},
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
        expect(find.byType(ReactionsCard), findsOneWidget);
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
          of: find.byType(ReactionsCard),
          matching: find.byType(StreamUserAvatar),
        );

        // Verify the avatar is rendered
        expect(avatar, findsNWidgets(3));

        // Tap on the first avatar directly
        await tester.tap(avatar.first);
        await tester.pumpAndSettle();

        // Verify the callback was called
        expect(tappedUser, isNotNull);
      },
    );

    testWidgets(
      'calls onReactionPicked when reaction is selected',
      (tester) async {
        String? selectedReactionType;

        // Define custom reaction icons for testing
        final testReactionIcons = [
          StreamReactionIcon(
            type: 'like',
            builder: (_, __, ___) => const Icon(Icons.thumb_up),
          ),
          StreamReactionIcon(
            type: 'love',
            builder: (_, __, ___) => const Icon(Icons.favorite),
          ),
        ];

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            client: mockClient,
            reactionIcons: testReactionIcons,
            StreamMessageReactionsModal(
              message: message,
              messageWidget: const Text('Message Widget'),
              onReactionPicked: (reaction) {
                selectedReactionType = reaction.type;
              },
            ),
          ),
        );

        // Use a longer timeout to ensure everything is rendered
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Verify reaction picker is shown
        expect(find.byType(StreamReactionPicker), findsOneWidget);

        Finder reactionPickerIconFinder(IconData icon) {
          return find.descendant(
            of: find.byType(StreamReactionPicker),
            matching: find.byIcon(icon),
          );
        }

        // Find and tap the first reaction (like)
        final likeIconFinder = reactionPickerIconFinder(Icons.thumb_up);
        expect(likeIconFinder, findsOneWidget);
        await tester.tap(likeIconFinder);
        await tester.pumpAndSettle();

        // Verify callback was called with correct reaction type
        expect(selectedReactionType, 'like');

        // Reset selected reaction
        selectedReactionType = null;

        // Find and tap the second reaction (love)
        final loveIconFinder = reactionPickerIconFinder(Icons.favorite);
        expect(loveIconFinder, findsOneWidget);
        await tester.tap(loveIconFinder);
        await tester.pumpAndSettle();

        // Verify callback was called with correct reaction type
        expect(selectedReactionType, 'love');
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
