import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
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

        // Render the reactions modal and assert avatar tap callback behavior.
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

        final avatarTapTarget = find.ancestor(
          of: avatar.first,
          matching: find.byWidgetPredicate(
            (widget) => widget is GestureDetector && widget.child is StreamUserAvatar,
          ),
        );

        // Verify the avatar widgets and scoped tap target are rendered.
        expect(avatar, findsNWidgets(2));
        expect(avatarTapTarget, findsOneWidget);

        final gestureDetector = tester.widget<GestureDetector>(avatarTapTarget);
        expect(gestureDetector.onTap, isNotNull);

        // Invoke only the tap target that wraps the first avatar.
        gestureDetector.onTap!.call();
        await tester.pump();

        // Verify the callback was called.
        expect(tappedUser, isNotNull);
      },
    );

    testWidgets(
      'pops with SelectReaction when reaction is selected',
      (tester) async {
        MessageAction? messageAction;

        // Define a custom reaction resolver for testing.
        const testReactionResolver = _TestReactionIconResolver(
          defaultReactionTypes: {'like', 'love', 'camera', 'call'},
          iconByType: {
            'like': Icons.thumb_up,
            'love': Icons.favorite,
            'camera': Icons.camera,
            'call': Icons.call,
          },
        );

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            client: mockClient,
            reactionIconResolver: testReactionResolver,
            Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  messageAction = await showStreamDialog(
                    context: context,
                    builder: (_) => StreamMessageReactionsModal(
                      message: message,
                      messageWidget: const Text('Message Widget'),
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Dialog'));

        // Use a longer timeout to ensure everything is rendered
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Verify reaction picker is shown
        expect(find.byType(StreamReactionPicker), findsOneWidget);

        // Find and tap the camera reaction
        final reactionIconFinder = find.byIcon(Icons.camera);
        expect(reactionIconFinder, findsOneWidget);
        await tester.tap(reactionIconFinder);
        await tester.pumpAndSettle();

        expect(messageAction, isA<SelectReaction>());
        // Verify the popped value has correct reaction type
        expect((messageAction! as SelectReaction).reaction.type, 'camera');

        // Open dialog again and tap the call reaction
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final callIconFinder = find.byIcon(Icons.call);
        expect(callIconFinder, findsOneWidget);
        await tester.tap(callIconFinder);
        await tester.pumpAndSettle();

        expect(messageAction, isA<SelectReaction>());
        // Verify the popped value has correct reaction type
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

          return Container(
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
  ReactionIconResolver? reactionIconResolver,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: brightness),
    builder: (context, child) => Portal(
      child: StreamChat(
        client: client,
        // Mock the connectivity stream to always return wifi.
        connectivityStream: Stream.value([ConnectivityResult.wifi]),
        streamChatThemeData: StreamChatThemeData(brightness: brightness),
        streamChatConfigData: StreamChatConfigurationData(
          reactionIconResolver: reactionIconResolver ?? const _TestReactionIconResolver(),
        ),
        child: child,
      ),
    ),
    home: Builder(
      builder: (context) {
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
      },
    ),
  );
}

class _TestReactionIconResolver extends ReactionIconResolver {
  const _TestReactionIconResolver({
    this.defaultReactionTypes = const {'like', 'love', 'haha', 'wow', 'sad'},
    this.iconByType = const {},
  });

  final Set<String> defaultReactionTypes;
  final Map<String, IconData> iconByType;

  @override
  Set<String> get defaultReactions => defaultReactionTypes;

  @override
  Set<String> get supportedReactions => {
    ...defaultReactionTypes,
    ...iconByType.keys,
  };

  @override
  String? emojiCode(String type) => streamSupportedEmojis[type]?.emoji;

  @override
  Widget resolve(BuildContext context, String type) {
    if (iconByType[type] case final icon?) {
      return Icon(icon);
    }

    if (emojiCode(type) case final emoji?) {
      return Text(emoji);
    }

    return const Text('❓');
  }
}
