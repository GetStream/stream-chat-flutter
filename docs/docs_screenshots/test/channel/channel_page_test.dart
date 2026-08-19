import 'package:device_preview/device_preview.dart' show Devices;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

/// Wraps [surfaceStyle] in the [ThemeData] the docs snapshots are pinned to.
///
/// Mirrors [docsScreenshotsTheme] — same Material flags, same
/// `CupertinoSystemText` family on the Stream text theme — and only swaps the
/// ambient surface style, which is the single difference the guide's
/// docked/floating pair is meant to show.
ThemeData _themeWith(core.StreamSurfaceStyle surfaceStyle) {
  final streamTextTheme = core.StreamTextTheme().apply(
    color: core.StreamColorScheme.light().systemText,
    fontFamily: 'CupertinoSystemText',
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    platform: docsScreenshotsTargetPlatform,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFFFFFFF)),
    extensions: [
      StreamTheme(
        brightness: Brightness.light,
        textTheme: streamTextTheme,
        surfaceStyle: surfaceStyle,
      ),
    ],
  );
}

/// Enough messages to fill the viewport, so floating chrome has content to
/// hover over — a short list would leave both variants looking identical.
List<Message> _buildMessages() {
  return [
    Message(
      id: 'msg-1',
      text: 'Or wholly pretty county in oppose',
      user: noahSmith,
      createdAt: DateTime(2024, 6, 1, 22, 20),
    ),
    Message(
      id: 'msg-2',
      text: 'By impossible of in difficulty discovered celebrated ye',
      user: ownUser,
      createdAt: DateTime(2024, 6, 1, 22, 21),
    ),
    Message(
      id: 'msg-3',
      text: 'Am terminated it excellence invitation projection',
      user: noahSmith,
      createdAt: DateTime(2024, 6, 1, 22, 22),
    ),
    Message(
      id: 'msg-4',
      text: 'As it so contrasted oh estimating instrument',
      user: ownUser,
      createdAt: DateTime(2024, 6, 1, 22, 23),
    ),
    Message(
      id: 'msg-5',
      text: 'Size like body some one had',
      user: noahSmith,
      createdAt: DateTime(2024, 6, 1, 22, 24),
    ),
    Message(
      id: 'msg-6',
      text: 'Cool!',
      user: ownUser,
      createdAt: DateTime(2024, 6, 1, 22, 25),
    ),
    Message(
      id: 'msg-7',
      text: 'Sure, let us do that',
      user: noahSmith,
      createdAt: DateTime(2024, 6, 1, 22, 26),
    ),
    Message(
      id: 'msg-8',
      text: 'Dinner tonight?',
      user: ownUser,
      createdAt: DateTime(2024, 6, 1, 22, 27),
    ),
  ];
}

Widget _buildChannelPage({required String id}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(type: 'messaging', id: 'chrome-$id');
  final channelState = MockChannelState();

  setupMockChannel(
    client: client,
    clientState: clientState,
    channel: channel,
    channelState: channelState,
    channelName: 'Feline Brown',
    messages: _buildMessages(),
    members: [
      Member(userId: ownUser.id, user: ownUser),
      Member(userId: noahSmith.id, user: noahSmith),
    ],
  );

  // The header's back button carries a StreamUnreadIndicator, which reads the
  // client-wide unread counters and the channel map behind excludeCid. Stub
  // them on the same state instance setupMockChannel wired to client.state.
  when(() => clientState.currentUser).thenReturn(ownUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));
  when(() => clientState.totalUnreadCount).thenReturn(0);
  when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(0));
  when(() => clientState.channels).thenReturn({});

  return StreamChat(
    client: client,
    connectivityStream: Stream.value([ConnectivityResult.mobile]),
    // The floating date divider tracks the scroll position and fades as it
    // nears an inline one. A static snapshot freezes it mid-transition over a
    // bubble, which reads as a glitch in a screenshot about chrome styles.
    configData: StreamChatConfigurationData(
      messageListViewConfiguration: const StreamMessageListViewConfiguration(
        showFloatingDateDivider: false,
      ),
    ),
    child: StreamChannel(
      showLoading: false,
      channel: channel,
      child: const StreamChannelPage(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // StreamChannelPage builds its composer with voice recording enabled, which
  // reaches for the record plugin on mount.
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  // --------------------------------------------------------------------------
  // Floating vs. docked chrome — the same StreamChannelPage under both ambient
  // surface styles, since the page follows whatever the theme sets.
  // --------------------------------------------------------------------------

  docsGoldenTest(
    'channel page with docked chrome',
    fileName: 'channel_page_docked',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
    deviceFrame: Devices.ios.iPhone13,
    app: (home) => MaterialApp(
      theme: _themeWith(core.StreamSurfaceStyle.regular),
      debugShowCheckedModeBanner: false,
      home: home,
    ),
    builder: () => _buildChannelPage(id: 'docked'),
  );

  docsGoldenTest(
    'channel page with floating chrome',
    fileName: 'channel_page_floating',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
    deviceFrame: Devices.ios.iPhone13,
    app: (home) => MaterialApp(
      theme: _themeWith(core.StreamSurfaceStyle.floating),
      debugShowCheckedModeBanner: false,
      home: home,
    ),
    builder: () => _buildChannelPage(id: 'floating'),
  );
}
