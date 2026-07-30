import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../test_utils/data_generator.dart';
import '../mocks.dart';

void main() {
  late StreamChatClient client;
  late Channel channel;
  late ChannelClientState channelClientState;
  late ClientState clientState;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'testid'));
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'testid')));
    channel = MockChannel();
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);
    when(() => channelClientState.threadsStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messagesStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messages).thenReturn([]);
    when(() => channelClientState.isUpToDate).thenReturn(true);
    when(() => channelClientState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
    when(() => channelClientState.unreadCountStream).thenAnswer((_) => Stream.value(0));
    when(() => channelClientState.unreadCount).thenReturn(0);
    when(() => channelClientState.readStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.read).thenReturn([]);
    when(() => channelClientState.membersStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
    when(() => channelClientState.currentUserRead).thenReturn(null);
    when(() => channelClientState.currentUserReadStream).thenAnswer((_) => const Stream.empty());
  });

  // https://github.com/GetStream/stream-chat-flutter/issues/674
  testWidgets('renders empty message list view', (tester) async {
    const emptyWidgetKey = Key('empty_widget');

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: StreamMessageListView(
              builders: StreamMessageListViewBuilders(
                empty: (_) => Container(key: emptyWidgetKey),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StreamMessageListView), findsOneWidget);
    expect(find.byKey(emptyWidgetKey), findsOneWidget);
  });

  testWidgets('renders a non empty message list view with custom background', (tester) async {
    final message = Message(
      id: 'message1',
      text: 'Hello world!',
      user: User(
        id: 'user',
        name: 'Test User',
      ),
    );

    when(() => channelClientState.messagesStream).thenAnswer(
      (_) => Stream.value([message]),
    );
    when(() => channelClientState.messages).thenReturn([message]);

    const nonEmptyWidgetKey = Key('non_empty_widget');
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: rootBundle,
            child: StreamChat(
              client: client,
              themeData: StreamChatThemeData(
                messageListViewTheme: const StreamMessageListViewThemeData(
                  backgroundColor: Colors.grey,
                  backgroundImage: DecorationImage(
                    image: AssetImage(
                      'lib/assets/images/placeholder.png',
                      package: 'stream_chat_flutter',
                    ),
                    fit: BoxFit.none,
                  ),
                ),
              ),
              child: StreamChannel(
                channel: channel,
                child: const StreamMessageListView(
                  key: nonEmptyWidgetKey,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    });

    bool findBackground(Widget widget) =>
        widget is DecoratedBox &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).image != null;

    expect(find.byType(StreamMessageListView), findsOneWidget);
    expect(find.byKey(nonEmptyWidgetKey), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        findBackground,
        description: 'findBackground',
      ),
      findsOneWidget,
    );
  });

  testWidgets('renders a non empty message list view with unread messages', (tester) async {
    final user = OwnUser(id: 'testid');
    final message = Message(
      id: 'message1',
      text: 'Hello world!',
      user: User(
        id: 'testid',
        name: 'Test User',
      ),
    );

    when(() => channelClientState.read).thenReturn([Read(lastRead: DateTime.now(), user: user)]);

    when(() => channelClientState.messagesStream).thenAnswer(
      (_) => Stream.value([message]),
    );
    when(() => channelClientState.messages).thenReturn([message]);

    const nonEmptyWidgetKey = Key('non_empty_widget');
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: rootBundle,
            child: StreamChat(
              client: client,
              themeData: StreamChatThemeData(
                messageListViewTheme: const StreamMessageListViewThemeData(
                  backgroundColor: Colors.grey,
                  backgroundImage: DecorationImage(
                    image: AssetImage(
                      'lib/assets/images/placeholder.png',
                      package: 'stream_chat_flutter',
                    ),
                    fit: BoxFit.none,
                  ),
                ),
              ),
              child: StreamChannel(
                channel: channel,
                child: const StreamMessageListView(
                  key: nonEmptyWidgetKey,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    });

    expect(find.byType(StreamMessageListView), findsOneWidget);
    expect(find.byKey(nonEmptyWidgetKey), findsOneWidget);
  });

  testWidgets('scrolls to bottom when arrow button is pressed', (tester) async {
    final own = OwnUser(id: 'ownid');
    final other = User(id: 'otherid');
    final messages = generateConversation(20, users: [own, other]);

    when(() => channelClientState.messagesStream).thenAnswer(
      (_) => Stream.value(messages),
    );
    when(() => channelClientState.messages).thenReturn(messages);

    const nonEmptyWidgetKey = Key('non_empty_widget');
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: rootBundle,
            child: StreamChat(
              client: client,
              themeData: StreamChatThemeData(
                messageListViewTheme: const StreamMessageListViewThemeData(
                  backgroundColor: Colors.grey,
                  backgroundImage: DecorationImage(
                    image: AssetImage(
                      'lib/assets/images/placeholder.png',
                      package: 'stream_chat_flutter',
                    ),
                    fit: BoxFit.none,
                  ),
                ),
              ),
              child: StreamChannel(
                channel: channel,
                child: const StreamMessageListView(
                  key: nonEmptyWidgetKey,
                  initialScrollIndex: 7,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    });

    expect(find.byType(StreamButton), findsOneWidget);

    await tester.tap(find.byType(StreamButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamButton), findsNothing);
  });

  group('effective configuration', () {
    // The scroll-to-bottom button is the observable: it renders as a
    // StreamButton, and `showScrollToBottom` decides whether it exists at all.
    // Scrolled away from the bottom so it would otherwise be visible.
    Future<void> pumpScrolledAwayList(
      WidgetTester tester, {
      StreamMessageListViewConfiguration? config,
      StreamMessageListViewConfiguration? globalConfig,
    }) async {
      final messages = generateConversation(
        20,
        users: [
          OwnUser(id: 'ownid'),
          User(id: 'otherid'),
        ],
      );
      when(() => channelClientState.messagesStream).thenAnswer((_) => Stream.value(messages));
      when(() => channelClientState.messages).thenReturn(messages);

      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: DefaultAssetBundle(
              bundle: rootBundle,
              child: StreamChat(
                client: client,
                configData: switch (globalConfig) {
                  final globalConfig? => StreamChatConfigurationData(messageListViewConfiguration: globalConfig),
                  _ => null,
                },
                child: StreamChannel(
                  channel: channel,
                  child: StreamMessageListView(
                    initialScrollIndex: 7,
                    config: config,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      });
    }

    testWidgets('falls back to the global configuration when config is null', (tester) async {
      await pumpScrolledAwayList(
        tester,
        globalConfig: const StreamMessageListViewConfiguration(showScrollToBottom: false),
      );

      expect(find.byType(StreamButton), findsNothing);
    });

    testWidgets('prefers an explicit config over the global one', (tester) async {
      await pumpScrolledAwayList(
        tester,
        globalConfig: const StreamMessageListViewConfiguration(showScrollToBottom: false),
        config: const StreamMessageListViewConfiguration(),
      );

      expect(find.byType(StreamButton), findsOneWidget);
    });

    testWidgets('picks up a changed global configuration', (tester) async {
      await pumpScrolledAwayList(
        tester,
        globalConfig: const StreamMessageListViewConfiguration(showScrollToBottom: false),
      );
      expect(find.byType(StreamButton), findsNothing);

      // Guards the didChangeDependencies re-resolve.
      await pumpScrolledAwayList(
        tester,
        globalConfig: const StreamMessageListViewConfiguration(),
      );

      expect(find.byType(StreamButton), findsOneWidget);
    });

    // Guards the didUpdateWidget re-resolve. The config is cached in a field, so
    // a swapped `config` has to invalidate it.
    //
    // Swapping via setState below the StreamChat ancestor rather than a second
    // pumpWidget, because StreamChatConfigurationData has no `==` — rebuilding
    // StreamChat hands StreamChatConfiguration a fresh instance, which notifies
    // every dependent and re-runs didChangeDependencies. That would resolve the
    // config for the wrong reason and hide a missing didUpdateWidget.
    testWidgets('picks up a changed config without a dependency change', (tester) async {
      final messages = generateConversation(
        20,
        users: [
          OwnUser(id: 'ownid'),
          User(id: 'otherid'),
        ],
      );
      when(() => channelClientState.messagesStream).thenAnswer((_) => Stream.value(messages));
      when(() => channelClientState.messages).thenReturn(messages);

      final swapper = GlobalKey<_ConfigSwapperState>();

      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: DefaultAssetBundle(
              bundle: rootBundle,
              child: StreamChat(
                client: client,
                child: StreamChannel(
                  channel: channel,
                  child: _ConfigSwapper(
                    key: swapper,
                    initialConfig: const StreamMessageListViewConfiguration(),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      });

      expect(find.byType(StreamButton), findsOneWidget);

      swapper.currentState!.swap(const StreamMessageListViewConfiguration(showScrollToBottom: false));
      await tester.pumpAndSettle();

      expect(find.byType(StreamButton), findsNothing);
    });
  });
}

/// Rebuilds only its [StreamMessageListView] child when [swap] is called,
/// leaving every ancestor untouched.
class _ConfigSwapper extends StatefulWidget {
  const _ConfigSwapper({super.key, required this.initialConfig});

  final StreamMessageListViewConfiguration initialConfig;

  @override
  State<_ConfigSwapper> createState() => _ConfigSwapperState();
}

class _ConfigSwapperState extends State<_ConfigSwapper> {
  late StreamMessageListViewConfiguration _config = widget.initialConfig;

  void swap(StreamMessageListViewConfiguration config) => setState(() => _config = config);

  @override
  Widget build(BuildContext context) => StreamMessageListView(initialScrollIndex: 7, config: _config);
}
