import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final originalPathProviderPlatform = PathProviderPlatform.instance;
  setUp(() => PathProviderPlatform.instance = FakePathProviderPlatform());
  tearDown(() => PathProviderPlatform.instance = originalPathProviderPlatform);

  testWidgets(
    'it should show basic channel information',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream).thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));
      when(() => channelState.unreadCountStream).thenAnswer((i) => Stream.value(1));
      when(() => clientState.totalUnreadCount).thenAnswer((i) => 1);
      when(() => clientState.totalUnreadCountStream).thenAnswer((i) => Stream.value(1));
      when(() => clientState.channels).thenReturn({channel.cid!: channel});
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          ),
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const Scaffold(
                body: StreamChannelHeader(),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.text('test'), findsOneWidget);
      expect(find.byType(StreamChannelAvatar), findsOneWidget);
      expect(find.byType(StreamChannelInfo), findsOneWidget);
    },
  );

  testWidgets(
    'it should show the InfoTile message if disconnected',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream).thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => channelState.unreadCountStream).thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          ),
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.disconnected));
      when(() => client.wsConnectionStatus).thenReturn(ConnectionStatus.disconnected);
      when(() => clientState.totalUnreadCount).thenAnswer((i) => 1);
      when(() => clientState.totalUnreadCountStream).thenAnswer((i) => Stream.value(1));
      when(() => clientState.channels).thenReturn({channel.cid!: channel});

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const Scaffold(
                body: StreamChannelHeader(
                  showConnectionStateTile: true,
                ),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(tester.widget<StreamInfoTile>(find.byType(StreamInfoTile)).showMessage, true);
      expect(tester.widget<StreamInfoTile>(find.byType(StreamInfoTile)).message, 'Disconnected');
    },
  );

  testWidgets(
    'it should show the InfoTile message if connecting',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream).thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => channelState.unreadCountStream).thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          ),
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connecting));
      when(() => clientState.totalUnreadCount).thenAnswer((i) => 1);
      when(() => clientState.totalUnreadCountStream).thenAnswer((i) => Stream.value(1));
      when(() => clientState.channels).thenReturn({channel.cid!: channel});

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              showLoading: false,
              child: const Scaffold(
                body: StreamChannelHeader(
                  showConnectionStateTile: true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(tester.widget<StreamInfoTile>(find.byType(StreamInfoTile)).showMessage, true);
      expect(tester.widget<StreamInfoTile>(find.byType(StreamInfoTile)).message, 'Reconnecting...');
    },
  );

  testWidgets(
    'it should apply passed properties',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.extraDataStream).thenAnswer(
        (i) => Stream.value({
          'name': 'test',
        }),
      );
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => channelState.unreadCountStream).thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          ),
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connecting));
      when(() => clientState.totalUnreadCountStream).thenAnswer((i) => Stream.value(1));

      await tester.pumpWidget(
        MaterialAppWrapper(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const Scaffold(
                body: StreamChannelHeader(
                  leading: Text('leading'),
                  subtitle: Text('subtitle'),
                  trailing: Text('action'),
                  title: Text('title'),
                ),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.text('test'), findsNothing);
      expect(find.byType(StreamBackButton), findsNothing);
      expect(find.byType(StreamChannelAvatar), findsNothing);
      expect(find.byType(StreamChannelInfo), findsNothing);
      expect(find.text('leading'), findsOneWidget);
      expect(find.text('title'), findsOneWidget);
      expect(find.text('subtitle'), findsOneWidget);
      expect(find.text('action'), findsOneWidget);
    },
  );

  testWidgets(
    'showBackButton: false should hide the StreamBackButton and '
    'showTypingIndicator: false should hide the typing indicator and '
    'showConnectionStateTile: false should be passed to the infotile',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream).thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => channelState.unreadCountStream).thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          ),
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.disconnected));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const Scaffold(
                body: StreamChannelHeader(
                  automaticallyImplyLeading: false,
                  leading: SizedBox(),
                ),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.byType(StreamBackButton), findsNothing);
      expect(tester.widget<StreamInfoTile>(find.byType(StreamInfoTile)).showMessage, false);
    },
  );

  testWidgets(
    'should apply passed callbacks',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream).thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => channelState.unreadCountStream).thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          ),
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connecting));
      when(() => clientState.totalUnreadCount).thenAnswer((i) => 1);
      when(() => clientState.totalUnreadCountStream).thenAnswer((i) => Stream.value(1));
      when(() => clientState.channels).thenReturn({channel.cid!: channel});

      var backPressed = false;
      var imageTapped = false;
      var titleTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamChannelHeader(
                  leading: StreamBackButton(onPressed: () => backPressed = true),
                  trailing: GestureDetector(
                    onTap: () => imageTapped = true,
                    child: StreamChannelAvatar(size: .lg, channel: channel),
                  ),
                  title: GestureDetector(
                    onTap: () => titleTapped = true,
                    child: StreamChannelName(channel: channel),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pump(Duration.zero);

      await tester.tap(find.byType(StreamBackButton));
      await tester.tap(find.byType(StreamChannelAvatar));
      await tester.tap(find.byType(StreamChannelName));

      expect(backPressed, true);
      expect(imageTapped, true);
      expect(titleTapped, true);
    },
  );

  testWidgets(
    'onBackPressed replaces the default back button pop',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));
      when(() => clientState.totalUnreadCount).thenReturn(0);
      when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(0));
      when(() => clientState.channels).thenReturn({channel.cid!: channel});
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));

      when(() => channel.client).thenReturn(client);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.lastMessageAt).thenReturn(null);
      when(() => channel.name).thenReturn('test');
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.image).thenReturn(null);
      when(() => channel.imageStream).thenAnswer((_) => Stream.value(null));
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));

      when(() => channelState.members).thenReturn([]);
      when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
      when(() => channelState.unreadCount).thenReturn(0);
      when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(0));

      var backPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamChannelHeader(onBackPressed: () => backPressed = true),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(StreamBackButton));

      expect(backPressed, true);
    },
  );

  group('default slot floating behavior', () {
    // The header layers channelHeaderTheme under `style` and hands the pair to
    // the bar, which republishes what it resolved to its slots. Both default
    // slots therefore have to agree with the bar and with each other, whichever
    // link in the chain set the behavior.
    Future<void> pumpHeader(
      WidgetTester tester, {
      StreamSurfaceStyle surfaceStyle = StreamSurfaceStyle.regular,
      StreamSurfaceStyle? themeSurfaceStyle,
      StreamSurfaceStyle? styleSurfaceStyle,
      StreamSurfaceStyle? ancestorSurfaceStyle,
    }) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(user));
      when(() => clientState.totalUnreadCount).thenReturn(0);
      when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(0));
      when(() => clientState.channels).thenReturn({channel.cid!: channel});
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));

      when(() => channel.client).thenReturn(client);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.lastMessageAt).thenReturn(null);
      when(() => channel.name).thenReturn('test');
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.image).thenReturn(null);
      when(() => channel.imageStream).thenAnswer((_) => Stream.value(null));
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));

      when(() => channelState.members).thenReturn([]);
      when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
      when(() => channelState.unreadCount).thenReturn(0);
      when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(0));

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [StreamTheme(surfaceStyle: surfaceStyle)]),
          home: StreamChat(
            client: client,
            themeData: StreamChatThemeData(
              channelHeaderTheme: switch (themeSurfaceStyle) {
                final surfaceStyle? => StreamAppBarThemeData(style: StreamAppBarStyle(surfaceStyle: surfaceStyle)),
                _ => null,
              },
            ),
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    Widget header = StreamChannelHeader(
                      style: switch (styleSurfaceStyle) {
                        final surfaceStyle? => StreamAppBarStyle(surfaceStyle: surfaceStyle),
                        _ => null,
                      },
                    );
                    // An app-level per-component override placed above the header.
                    if (ancestorSurfaceStyle case final surfaceStyle?) {
                      header = StreamAppBarTheme(
                        data: StreamAppBarThemeData(style: StreamAppBarStyle(surfaceStyle: surfaceStyle)),
                        child: header,
                      );
                    }
                    return header;
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    bool? avatarIsFloating(WidgetTester tester) {
      return tester.widget<StreamChannelAvatar>(find.byType(StreamChannelAvatar)).isFloating;
    }

    bool? backButtonIsFloating(WidgetTester tester) {
      final button = find.descendant(of: find.byType(StreamBackButton), matching: find.byType(StreamButton));
      return tester.widget<StreamButton>(button).props.isFloating;
    }

    testWidgets('is not floating by default', (tester) async {
      await pumpHeader(tester);

      expect(avatarIsFloating(tester), isNot(isTrue));
    });

    testWidgets('floats when the app style is floating', (tester) async {
      await pumpHeader(tester, surfaceStyle: StreamSurfaceStyle.floating);

      expect(avatarIsFloating(tester), isTrue);
    });

    testWidgets('floats when the header theme says so, over a regular app style', (tester) async {
      await pumpHeader(tester, themeSurfaceStyle: StreamSurfaceStyle.floating);

      expect(avatarIsFloating(tester), isTrue);
    });

    testWidgets('floats when an ancestor StreamAppBarTheme override says so, over a regular app style', (tester) async {
      // Regression: the header must not stand between the bar and a caller's
      // StreamAppBarTheme, or an app-level surfaceStyle never reaches it.
      await pumpHeader(tester, ancestorSurfaceStyle: StreamSurfaceStyle.floating);

      expect(avatarIsFloating(tester), isTrue);
      expect(backButtonIsFloating(tester), isTrue);
    });

    testWidgets('the header theme wins over an ancestor StreamAppBarTheme override', (tester) async {
      await pumpHeader(
        tester,
        ancestorSurfaceStyle: StreamSurfaceStyle.floating,
        themeSurfaceStyle: StreamSurfaceStyle.regular,
      );

      expect(avatarIsFloating(tester), isNot(isTrue));
    });

    testWidgets('the header style wins over both the header theme and the app style', (tester) async {
      await pumpHeader(
        tester,
        surfaceStyle: StreamSurfaceStyle.floating,
        themeSurfaceStyle: StreamSurfaceStyle.floating,
        styleSurfaceStyle: StreamSurfaceStyle.regular,
      );

      expect(avatarIsFloating(tester), isNot(isTrue));
    });

    testWidgets('the default back button agrees with the avatar under the header theme', (tester) async {
      await pumpHeader(tester, themeSurfaceStyle: StreamSurfaceStyle.floating);

      expect(backButtonIsFloating(tester), isTrue);
      expect(backButtonIsFloating(tester), avatarIsFloating(tester));
    });

    testWidgets('the default back button agrees with the avatar under the header style', (tester) async {
      await pumpHeader(
        tester,
        surfaceStyle: StreamSurfaceStyle.floating,
        styleSurfaceStyle: StreamSurfaceStyle.regular,
      );

      expect(backButtonIsFloating(tester), isNot(isTrue));
      expect(backButtonIsFloating(tester), avatarIsFloating(tester));
    });
  });
}
