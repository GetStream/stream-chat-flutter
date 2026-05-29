import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

import '../../mocks.dart';

void main() {
  late MockClient mockClient;

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
    registerFallbackValue(Filter.equal('type', 'like'));
  });

  setUp(() {
    mockClient = MockClient();

    final mockClientState = MockClientState();
    when(() => mockClient.state).thenReturn(mockClientState);

    final currentUser = OwnUser(id: 'current-user', name: 'Current User');
    when(() => mockClientState.currentUser).thenReturn(currentUser);
  });

  tearDown(() => reset(mockClient));

  testWidgets('shows total reaction count and all reactions by default', (tester) async {
    final reactions = [
      Reaction(
        type: 'love',
        messageId: 'test-message',
        userId: 'user-1',
        user: User(id: 'user-1', name: 'User 1'),
        createdAt: DateTime.now(),
      ),
      Reaction(
        type: 'like',
        messageId: 'test-message',
        userId: 'user-2',
        user: User(id: 'user-2', name: 'User 2'),
        createdAt: DateTime.now(),
      ),
    ];

    when(
      () => mockClient.queryReactions(
        'test-message',
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        pagination: any(named: 'pagination'),
      ),
    ).thenAnswer(
      (_) async => QueryReactionsResponse()
        ..reactions = reactions
        ..next = null,
    );

    final message = _buildMessage(
      reactionGroups: {
        'love': ReactionGroup(count: 1, sumScores: 1),
        'like': ReactionGroup(count: 1, sumScores: 1),
      },
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: mockClient,
        _ReactionDetailSheetLauncher(message: message),
      ),
    );

    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(find.byType(ReactionDetailSheet), findsOneWidget);
    expect(find.text('2 Reactions'), findsOneWidget);
    expect(find.byType(StreamUserAvatar), findsNWidgets(2));
    expect(find.text('User 1'), findsOneWidget);
    expect(find.text('User 2'), findsOneWidget);
  });

  testWidgets('applies initial reaction filter when provided', (tester) async {
    final loveReaction = Reaction(
      type: 'love',
      messageId: 'test-message',
      userId: 'user-1',
      user: User(id: 'user-1', name: 'User 1'),
      createdAt: DateTime.now(),
    );

    // The controller is initialised with filter: type == 'love', so
    // queryReactions will return only the love reaction.
    when(
      () => mockClient.queryReactions(
        'test-message',
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        pagination: any(named: 'pagination'),
      ),
    ).thenAnswer(
      (_) async => QueryReactionsResponse()
        ..reactions = [loveReaction]
        ..next = null,
    );

    final message = _buildMessage(
      reactionGroups: {
        'love': ReactionGroup(count: 1, sumScores: 1),
        'like': ReactionGroup(count: 1, sumScores: 1),
      },
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: mockClient,
        _ReactionDetailSheetLauncher(
          message: message,
          initialReactionType: 'love',
        ),
      ),
    );

    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(find.text('1 Reaction'), findsOneWidget);
    expect(find.byType(StreamUserAvatar), findsOneWidget);
    expect(find.text('User 1'), findsOneWidget);
    expect(find.text('User 2'), findsNothing);
  });

  testWidgets('pops with SelectReaction when own reaction row is tapped', (tester) async {
    MessageAction? action;

    final reaction = Reaction(
      type: 'love',
      messageId: 'test-message',
      userId: 'current-user',
      user: User(id: 'current-user', name: 'Current User'),
      createdAt: DateTime.now(),
    );

    when(
      () => mockClient.queryReactions(
        'test-message',
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        pagination: any(named: 'pagination'),
      ),
    ).thenAnswer(
      (_) async => QueryReactionsResponse()
        ..reactions = [reaction]
        ..next = null,
    );

    final message = _buildMessage(
      ownReactions: [reaction],
      reactionGroups: {
        'love': ReactionGroup(count: 1, sumScores: 1),
      },
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: mockClient,
        _ReactionDetailSheetLauncher(
          message: message,
          onAction: (value) => action = value,
        ),
      ),
    );

    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Tap to remove'), findsOneWidget);

    await tester.tap(find.text('Current User'));
    await tester.pumpAndSettle();

    expect(action, isA<SelectReaction>());
    expect((action! as SelectReaction).reaction.type, 'love');
  });

  testWidgets('does not pop when non-own reaction row is tapped', (tester) async {
    MessageAction? action;

    final otherReaction = Reaction(
      type: 'love',
      messageId: 'test-message',
      userId: 'user-1',
      user: User(id: 'user-1', name: 'User 1'),
      createdAt: DateTime.now(),
    );

    when(
      () => mockClient.queryReactions(
        'test-message',
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        pagination: any(named: 'pagination'),
      ),
    ).thenAnswer(
      (_) async => QueryReactionsResponse()
        ..reactions = [otherReaction]
        ..next = null,
    );

    final message = _buildMessage(
      ownReactions: [
        Reaction(
          type: 'love',
          messageId: 'test-message',
          userId: 'current-user',
          user: User(id: 'current-user', name: 'Current User'),
          createdAt: DateTime.now(),
        ),
      ],
      reactionGroups: {
        'love': ReactionGroup(count: 1, sumScores: 1),
      },
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: mockClient,
        _ReactionDetailSheetLauncher(
          message: message,
          onAction: (value) => action = value,
        ),
      ),
    );

    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Tap to remove'), findsNothing);

    await tester.tap(find.text('User 1'));
    await tester.pumpAndSettle();

    expect(action, isNull);
    expect(find.byType(ReactionDetailSheet), findsOneWidget);
  });

  testWidgets('emoji sheet is limited to supportedReactions from resolver when add-emoji chip is tapped',
      (tester) async {
    when(
      () => mockClient.queryReactions(
        'test-message',
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        pagination: any(named: 'pagination'),
      ),
    ).thenAnswer(
      (_) async => QueryReactionsResponse()
        ..reactions = []
        ..next = null,
    );

    final message = _buildMessage(
      reactionGroups: {
        'love': ReactionGroup(count: 1, sumScores: 1),
      },
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: mockClient,
        // _SubsetDetailResolver: supportedReactions = {'love', 'like'} (2 items)
        reactionIconResolver: const _SubsetDetailResolver(),
        _ReactionDetailSheetLauncher(message: message),
      ),
    );

    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(find.byType(ReactionDetailSheet), findsOneWidget);

    // Tap the add-emoji chip to open the full emoji sheet.
    await tester.tap(find.byType(StreamEmojiChip).first);
    await tester.pumpAndSettle();

    expect(find.byType(StreamEmojiPickerSheet), findsOneWidget);

    // The sheet should show exactly 2 emoji buttons (supportedReactions count).
    // Without the fix it would show ~120 (full streamSupportedEmojis catalog).
    expect(find.byType(StreamEmojiButton), findsNWidgets(2));
  });

  group('ReactionDetailSheet Golden Tests', () {
    final reactions = [
      Reaction(
        type: 'love',
        messageId: 'test-message',
        userId: 'user-1',
        user: User(id: 'user-1', name: 'User 1'),
        createdAt: DateTime(2026, 1, 1, 10, 0),
      ),
      Reaction(
        type: 'like',
        messageId: 'test-message',
        userId: 'user-2',
        user: User(id: 'user-2', name: 'User 2'),
        createdAt: DateTime(2026, 1, 1, 10, 1),
      ),
    ];

    final message = _buildMessage(
      reactionGroups: {
        'love': ReactionGroup(count: 1, sumScores: 1),
        'like': ReactionGroup(count: 1, sumScores: 1),
      },
    );

    for (final brightness in Brightness.values) {
      final theme = brightness.name;

      goldenTest(
        'ReactionDetailSheet in $theme theme',
        fileName: 'reaction_detail_sheet_$theme',
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
        pumpBeforeTest: (tester) async {
          when(
            () => mockClient.queryReactions(
              'test-message',
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenAnswer(
            (_) async => QueryReactionsResponse()
              ..reactions = reactions
              ..next = null,
          );
          // Pump once to trigger post-frame modal opening, then settle animation.
          await tester.pump();
          await tester.pumpAndSettle(const Duration(seconds: 1));
        },
        builder: () => _wrapWithMaterialApp(
          client: mockClient,
          brightness: brightness,
          _ReactionDetailSheetGoldenHost(message: message),
        ),
      );

      goldenTest(
        'ReactionDetailSheet filtered in $theme theme',
        fileName: 'reaction_detail_sheet_filtered_$theme',
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
        pumpBeforeTest: (tester) async {
          when(
            () => mockClient.queryReactions(
              'test-message',
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenAnswer(
            (_) async => QueryReactionsResponse()
              ..reactions = reactions.where((r) => r.type == 'love').toList()
              ..next = null,
          );
          // Pump once to trigger post-frame modal opening, then settle animation.
          await tester.pump();
          await tester.pumpAndSettle(const Duration(seconds: 1));
        },
        builder: () => _wrapWithMaterialApp(
          client: mockClient,
          brightness: brightness,
          _ReactionDetailSheetGoldenHost(
            message: message,
            initialReactionType: 'love',
          ),
        ),
      );
    }
  });
}

class _ReactionDetailSheetLauncher extends StatelessWidget {
  const _ReactionDetailSheetLauncher({
    required this.message,
    this.initialReactionType,
    this.onAction,
  });

  final Message message;
  final String? initialReactionType;
  final ValueChanged<MessageAction?>? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          final action = await ReactionDetailSheet.show(
            context: context,
            message: message,
            initialReactionType: initialReactionType,
          );

          onAction?.call(action);
        },
        child: const Text('Open Sheet'),
      ),
    );
  }
}

class _ReactionDetailSheetGoldenHost extends StatefulWidget {
  const _ReactionDetailSheetGoldenHost({
    required this.message,
    this.initialReactionType,
  });

  final Message message;
  final String? initialReactionType;

  @override
  State<_ReactionDetailSheetGoldenHost> createState() => _ReactionDetailSheetGoldenHostState();
}

class _ReactionDetailSheetGoldenHostState extends State<_ReactionDetailSheetGoldenHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ReactionDetailSheet.show(
        context: context,
        message: widget.message,
        initialReactionType: widget.initialReactionType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand();
  }
}

Message _buildMessage({
  List<Reaction>? latestReactions,
  List<Reaction>? ownReactions,
  Map<String, ReactionGroup>? reactionGroups,
}) {
  return Message(
    id: 'test-message',
    text: 'This is a test message',
    createdAt: DateTime.now(),
    user: User(id: 'test-user', name: 'Test User'),
    latestReactions: latestReactions,
    ownReactions: ownReactions,
    reactionGroups: reactionGroups,
  );
}

Widget _wrapWithMaterialApp(
  Widget child, {
  required StreamChatClient client,
  Brightness brightness = Brightness.light,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: brightness),
    builder: (context, child) => StreamChat(
      client: client,
      // Mock the connectivity stream to always return wifi.
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      streamChatThemeData: StreamChatThemeData(),
      child: child ?? const SizedBox.shrink(),
    ),
    home: Builder(
      builder: (context) {
        final colorScheme = context.streamColorScheme;
        return Scaffold(
          backgroundColor: colorScheme.backgroundApp,
          body: ColoredBox(
            color: colorScheme.backgroundOverlayLight,
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
