import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_client_stubs.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

// ---------------------------------------------------------------------------
// Hero showcase image: split blue/black background with a centered Flutter
// logo and four screen crops arranged symmetrically.
//
// Two unique screens, each rendered twice (light + dark, same data):
//   - StreamMessageListView  → Phone 1 (light, far left)  + Phone 4 (dark, far right)
//   - StreamChannelListView  → Phone 2 (light, mid-left)  + Phone 3 (dark, mid-right)
//
// No device frame — screens fill the positioned area directly.
//
// Layout (canvas 1024 × 768):
//
//   ┌──────────────────────────────────────────────────────────┐
//   │            blue (left 512px) │ black (right 512px)       │
//   │                   [Flutter logo]                          │
//   │  [P1 175px]  [gap]  [P2 215px│P3 215px]  [gap]  [P4 175px]  │
//   └──────────────────────────────────────────────────────────┘
//
// Outer phones (P1/P4) each show 175 px. The date indicator is centred at
// x=215 of a 430 px phone → it is off-canvas for both outer phones.
// Inner phones (P2/P3) share a 430 px window split exactly at x=512.
// ---------------------------------------------------------------------------

const _canvasWidth = 1024.0;
const _canvasHeight = 768.0;

// Phone screen dimensions (no device frame, screen fills the area).
const _phoneWidth = 430.0;
const _phoneHeight = 931.0;

// How much of each outer phone (1 and 4) is visible on canvas.
// Must be < 215 (half phone width) so centred content stays off-canvas.
const _outerVisible = 175.0;

// Inner phones: each half = 215 px, combined = 430 px centred at canvas centre.
const _halfPhone = _phoneWidth / 2; // 215
const _innerLeft = _canvasWidth / 2 - _halfPhone; // 297 – left edge of combined phone

// Vertical position: phones start here; their bottoms are clipped by the canvas.
const _phoneTop = 200.0;

const _streamBlue = Color(0xFF005FFF);
const _streamBlack = Color(0xFF000000);

// Phone factory — no device frame, just MaterialApp + StreamChat.
// The Positioned / OverflowBox parent controls the rendered size.
class _Phone extends StatelessWidget {
  const _Phone({
    required this.brightness,
    required this.client,
    required this.screen,
  });

  final Brightness brightness;
  final MockClient client;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    final isLight = brightness == Brightness.light;
    return MaterialApp(
      theme: isLight ? docsScreenshotsTheme() : docsScreenshotsDarkTheme(),
      debugShowCheckedModeBanner: false,
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: screen,
      ),
    );
  }
}

// channelId must be unique per phone instance (widget trees cannot be shared).
({MockClient client, MockChannel channel}) _buildMessageScreenMocks({required String channelId}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(type: 'messaging', id: channelId);
  final channelState = MockChannelState();

  final messages = <Message>[
    Message(
      id: '$channelId-msg',
      text:
          'I wish I could go back in time and see this in person. '
          'Check https://flutter.dev for the latest updates!',
      user: noahSmith,
      createdAt: DateTime(2024, 6, 1, 14, 50),
      replyCount: 3,
    ),
    Message(
      id: '$channelId-reply-1',
      text: 'Same here!',
      user: ownUser,
      createdAt: DateTime(2024, 6, 1, 14, 55),
    ),
    Message(
      id: '$channelId-reply-2',
      text: 'It would be amazing.',
      user: noahSmith,
      createdAt: DateTime(2024, 6, 1, 14, 58),
    ),
  ];

  setupMockChannel(
    client: client,
    clientState: clientState,
    channel: channel,
    channelState: channelState,
    channelName: 'Sandbox',
    messages: messages,
  );

  // Stub currentUser + unread count on the SAME clientState `setupMockChannel`
  // installed on `client.state`. Using `stubMockClientCurrentUser` would
  // create a fresh `MockClientState` and the unread stubs below would land
  // on a now-orphaned instance.
  when(() => clientState.currentUser).thenReturn(ownUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));
  when(() => clientState.totalUnreadCount).thenReturn(4);
  when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(4));

  return (client: client, channel: channel);
}

Widget _buildMessageScreen(MockChannel channel) {
  return StreamChannel(
    showLoading: false,
    channel: channel,
    child: const Scaffold(
      appBar: StreamChannelHeader(),
      // reverse: false anchors messages at the top so they are visible in the
      // cropped device views rather than pushed off the bottom of the canvas.
      body: StreamMessageListView(
        reverse: false,
        shrinkWrap: true,
      ),
    ),
  );
}

// idSuffix must differ per phone to keep channel IDs unique.
({MockClient client, StreamChannelListController controller}) _buildChannelListMocks({required String idSuffix}) {
  final client = MockClient();

  final channels = [
    fakeChannel(
      client: client,
      id: 'general-$idSuffix',
      name: 'Daniel Atkins',
      messages: [
        Message(
          id: 'msg-1-$idSuffix',
          text: 'The weather will be perfect for the storm.',
          user: noahSmith,
          createdAt: DateTime(2024, 6, 1, 14, 14),
        ),
      ],
      unreadCount: 1,
    ),
    fakeChannel(
      client: client,
      id: 'photographers-$idSuffix',
      name: 'Photographers',
      messages: [
        Message(
          id: 'msg-2-$idSuffix',
          text: '@Philippe: Hmm, are you sure?',
          user: charlotteAnderson,
          createdAt: DateTime(2024, 6, 1, 22, 16),
        ),
      ],
      unreadCount: 80,
    ),
    fakeChannel(
      client: client,
      id: 'erin-ursula-$idSuffix',
      name: 'Erin, Ursula, Matthew',
      messages: [
        Message(
          id: 'msg-3-$idSuffix',
          text: 'You: The store only has (gasp!) 2% milk.',
          user: ownUser,
          createdAt: DateTime(2024, 6, 1, 14, 14),
        ),
      ],
      unreadCount: 1,
    ),
    fakeChannel(
      client: client,
      id: 'nelms-$idSuffix',
      name: 'Nelms, Clayton, Wagner, Morgan',
      messages: [
        Message(
          id: 'msg-4-$idSuffix',
          text: "You: The game went into OT, it's gonna be close.",
          user: ownUser,
          createdAt: DateTime(2024, 5, 31, 15, 0),
        ),
      ],
    ),
  ];

  final controller = StreamChannelListController.fromValue(
    PagedValue(items: channels),
    client: client,
  );

  stubQueryChannelsForGoldens(client, channels);
  stubMockClientCurrentUser(client, ownUser);

  return (client: client, controller: controller);
}

Widget _buildChannelListScreen(StreamChannelListController controller) {
  return Builder(
    builder: (context) {
      final icons = context.streamIcons;
      return Scaffold(
        appBar: StreamChannelListHeader(
          title: const Text('Chats'),
          trailing: StreamButton.icon(
            icon: Icon(icons.plus),
            onPressed: () {},
          ),
        ),
        body: StreamChannelListView(
          controller: controller,
          shrinkWrap: true,
        ),
      );
    },
  );
}

class _FlutterLogoCard extends StatelessWidget {
  const _FlutterLogoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Center(child: FlutterLogo(size: 56)),
    );
  }
}

// Half-phone crop using OverflowBox + ClipRect.
//
// The phone renders at full _phoneWidth × _phoneHeight inside the overflow
// box. The container (width = _halfPhone) clips exactly half.
// alignment = Alignment.centerLeft  → shows LEFT  half (phone 2, light)
// alignment = Alignment.centerRight → shows RIGHT half (phone 3, dark)
Widget _halfPhoneCrop({
  required Alignment alignment,
  required Widget child,
}) {
  return ClipRect(
    child: OverflowBox(
      alignment: alignment,
      minWidth: _phoneWidth,
      maxWidth: _phoneWidth,
      child: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'flutter sdk showcase',
    fileName: 'flutter_showcase',
    constraints: const BoxConstraints.tightFor(width: _canvasWidth, height: _canvasHeight),
    builder: () {
      // Each phone needs its own independent mock + widget tree.
      final msgLight = _buildMessageScreenMocks(channelId: 'showcase-light');
      final msgDark = _buildMessageScreenMocks(channelId: 'showcase-dark');
      final chanLight = _buildChannelListMocks(idSuffix: 'light');
      final chanDark = _buildChannelListMocks(idSuffix: 'dark');

      return SizedBox(
        width: _canvasWidth,
        height: _canvasHeight,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Background: brand-blue (left) │ black (right)
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(child: Container(color: _streamBlue)),
                  Expanded(child: Container(color: _streamBlack)),
                ],
              ),
            ),

            // Flutter logo card centred near top.
            const Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(child: _FlutterLogoCard()),
            ),

            // Phone 1 (light, message): far left.
            // Positioned so right edge = _outerVisible (175 px).
            // Own x=255 to x=430 visible → centred title/date (x=215) hidden.
            Positioned(
              left: -(_phoneWidth - _outerVisible), // -255
              top: _phoneTop,
              width: _phoneWidth,
              height: _phoneHeight,
              child: _Phone(
                brightness: Brightness.light,
                client: msgLight.client,
                screen: _buildMessageScreen(msgLight.channel),
              ),
            ),

            // Phone 2 (light, channel list): left half of centre pair.
            // Container is 215 px wide at x=297–512.
            // OverflowBox renders phone at 430 px; ClipRect shows left 215 px.
            Positioned(
              left: _innerLeft, // 297
              top: _phoneTop,
              width: _halfPhone, // 215
              height: _phoneHeight,
              child: _halfPhoneCrop(
                alignment: Alignment.centerLeft,
                child: _Phone(
                  brightness: Brightness.light,
                  client: chanLight.client,
                  screen: _buildChannelListScreen(chanLight.controller),
                ),
              ),
            ),

            // Phone 3 (dark, channel list): right half of centre pair.
            // Container is 215 px wide at x=512–727.
            // OverflowBox renders phone at 430 px; ClipRect shows right 215 px.
            Positioned(
              left: _canvasWidth / 2, // 512
              top: _phoneTop,
              width: _halfPhone, // 215
              height: _phoneHeight,
              child: _halfPhoneCrop(
                alignment: Alignment.centerRight,
                child: _Phone(
                  brightness: Brightness.dark,
                  client: chanDark.client,
                  screen: _buildChannelListScreen(chanDark.controller),
                ),
              ),
            ),

            // Phone 4 (dark, message): far right.
            // Positioned so left edge = canvas width − _outerVisible (849 px).
            // Own x=0 to x=175 visible → centred title/date (x=215) hidden.
            Positioned(
              left: _canvasWidth - _outerVisible, // 849
              top: _phoneTop,
              width: _phoneWidth,
              height: _phoneHeight,
              child: _Phone(
                brightness: Brightness.dark,
                client: msgDark.client,
                screen: _buildMessageScreen(msgDark.channel),
              ),
            ),
          ],
        ),
      );
    },
  );
}
