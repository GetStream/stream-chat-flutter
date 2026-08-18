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

/// The brand color the theming guide seeds its examples with.
///
/// Shared by the app snapshot and the swatch ladders so the guide tells one
/// story: this color in, that palette out.
const _brand = Color(0xFFE91E63);

/// Wraps [colorScheme] in the [ThemeData] the docs snapshots are pinned to.
///
/// Mirrors [docsScreenshotsTheme] — same Material flags, same
/// `CupertinoSystemText` family on the Stream text theme — but takes the color
/// scheme from the caller so each theming snapshot can seed its own.
ThemeData _themeFrom(core.StreamColorScheme colorScheme) {
  final streamTextTheme = core.StreamTextTheme().apply(
    color: colorScheme.systemText,
    fontFamily: 'CupertinoSystemText',
  );

  return ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    platform: docsScreenshotsTargetPlatform,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFFFFFFF)),
    extensions: [
      StreamTheme(colorScheme: colorScheme, textTheme: streamTextTheme),
    ],
  );
}

/// `StreamColorScheme.fromSeed(brand:)` — derives both the brand scale and a
/// near-neutral chrome scale from one seed, so the whole palette carries the
/// brand hue without the caller picking a second color.
ThemeData _seededTheme() => _themeFrom(core.StreamColorScheme.fromSeed(brand: _brand));

/// The shade keys [core.StreamColorSwatch.fromColor] generates, in ladder order.
///
/// `0` and `1000` are the scale's pinned endpoints (white and black in light
/// mode) and carry no hue, so the ladder below shows only the derived shades.
const _shades = [50, 100, 150, 200, 300, 400, 500, 600, 700, 800, 900];

/// A labelled row of swatches for one [core.StreamColorSwatch].
Widget _swatchLadder(String label, core.StreamColorSwatch swatch) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Row(
        children: [
          for (final shade in _shades)
            Expanded(
              child: Container(height: 44, color: swatch[shade]),
            ),
        ],
      ),
    ],
  );
}

/// The two scales `fromSeed` builds from a single seed, against the default
/// chrome it replaces.
///
/// The chrome pair is the point: the derived neutrals carry the brand hue at
/// [core.StreamColorScheme.neutralChroma] instead of the SDK's cool greys, which
/// is what makes a seeded palette read as one family.
Widget _buildSwatchComparison() {
  final seeded = core.StreamColorScheme.fromSeed(brand: _brand);

  return Scaffold(
    backgroundColor: Colors.white,
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _swatchLadder('brand — derived from the seed', seeded.brand),
          const SizedBox(height: 24),
          _swatchLadder('chrome — SDK default', core.StreamColorScheme.light().chrome),
          const SizedBox(height: 24),
          _swatchLadder('chrome — derived from the seed', seeded.chrome),
        ],
      ),
    ),
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

  // The "after" half of the theming guide's before/after pair, and the scales
  // behind it. Both are seeded from `_brand` via `StreamColorScheme.fromSeed`,
  // so the guide can show one color going in and the whole palette coming out.

  docsGoldenTest(
    'theming brand color seeding the whole scheme',
    fileName: 'theming_red',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
    deviceFrame: Devices.ios.iPhone13,
    app: (home) => MaterialApp(
      theme: _seededTheme(),
      debugShowCheckedModeBanner: false,
      home: home,
    ),
    builder: () => _buildThemingShowcase(id: 'red', inputText: 'Hey in red!'),
  );

  docsGoldenTest(
    'theming brand and chrome swatch ladders',
    fileName: 'theming_seed_swatches',
    constraints: const BoxConstraints.tightFor(width: 600, height: 300),
    builder: _buildSwatchComparison,
  );
}
