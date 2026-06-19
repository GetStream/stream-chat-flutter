import 'package:device_preview/device_preview.dart' show Devices;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

const _redBrand = Color(0xFFE91E63);
const _redChrome = Color(0xFFC9A8A8);

ThemeData _redTheme() {
  final streamTextTheme = core.StreamTextTheme().apply(
    color: core.StreamColorScheme.light(
      brand: core.StreamColorSwatch.fromColor(_redBrand),
      chrome: core.StreamColorSwatch.fromColor(_redChrome),
    ).systemText,
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
        colorScheme: core.StreamColorScheme.light(
          brand: core.StreamColorSwatch.fromColor(_redBrand),
          chrome: core.StreamColorSwatch.fromColor(_redChrome),
        ),
        textTheme: streamTextTheme,
      ),
    ],
  );
}

List<Message> _buildMessages() {
  return [
    Message(
      id: 'msg-1',
      text: 'Or wholly pretty county in oppose',
      user: noahSmith,
      createdAt: DateTime(2024, 6, 1, 22, 27),
    ),
    Message(
      id: 'msg-2',
      text: 'By impossible of in difficulty discovered celebrated ye',
      user: ownUser,
      createdAt: DateTime(2024, 6, 1, 22, 27),
    ),
    Message(
      id: 'msg-3',
      text: 'Cool!',
      user: ownUser,
      createdAt: DateTime(2024, 6, 1, 22, 27),
    ),
    Message(
      id: 'msg-4',
      text: 'Dinner tonight?',
      user: ownUser,
      createdAt: DateTime(2024, 6, 1, 22, 27),
    ),
  ];
}

Widget _buildThemingShowcase({required String id, required String inputText}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(type: 'messaging', id: 'theming-$id');
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

  stubMockClientCurrentUser(client, ownUser);

  final controller = StreamMessageComposerController()..text = inputText;

  return StreamChat(
    client: client,
    connectivityStream: Stream.value([ConnectivityResult.mobile]),
    child: StreamChannel(
      showLoading: false,
      channel: channel,
      child: Scaffold(
        appBar: const StreamChannelHeader(automaticallyImplyLeading: false),
        body: Column(
          children: [
            const Expanded(child: StreamMessageListView()),
            StreamMessageComposer(messageComposerController: controller),
          ],
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  docsGoldenTest(
    'theming default brand and chrome',
    fileName: 'theming_default',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
    deviceFrame: Devices.ios.iPhone13,
    builder: () => _buildThemingShowcase(id: 'default', inputText: 'Hey in blue!'),
  );

  docsGoldenTest(
    'theming red brand and chrome',
    fileName: 'theming_red',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
    deviceFrame: Devices.ios.iPhone13,
    app: (home) => MaterialApp(
      theme: _redTheme(),
      debugShowCheckedModeBanner: false,
      home: home,
    ),
    builder: () => _buildThemingShowcase(id: 'red', inputText: 'Hey in red!'),
  );
}
