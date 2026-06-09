import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

// From the current user so "Edit Message" is semantically correct and the
// modal is right-aligned.
final _message = Message(
  id: 'localization-msg',
  text: 'Localization!!!',
  user: ownUser,
  createdAt: DateTime(2024, 6, 1, 10, 0),
);

// One phone: MaterialApp (locale-aware) > StreamChat > StreamChannel >
//   Stack(clipBehavior: none) {
//     DeviceFrame  → blurred backdrop + centered modal  (no composer inside)
//     Positioned   → StreamChatMessageComposer floating on top of the frame
//   }
class _PhoneWithComposer extends StatelessWidget {
  const _PhoneWithComposer({
    required this.locale,
    required this.client,
    required this.channel,
    required this.leftInset,
    required this.rightInset,
    required this.bottomInset,
  });

  final Locale locale;
  final MockClient client;
  final MockChannel channel;

  final double leftInset;
  final double rightInset;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('it')],
      localizationsDelegates: GlobalStreamChatLocalizations.delegates,
      theme: docsScreenshotsTheme(),
      debugShowCheckedModeBanner: false,
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamChannel(
          showLoading: false,
          channel: channel,
          // Builder gives us a context that carries StreamChat + StreamChannel +
          // locale-aware translations — used by both the DeviceFrame screen AND
          // the floating composer below.
          child: Builder(
            builder: (ctx) => Stack(
              clipBehavior: Clip.none,
              children: [
                DeviceFrame(
                  device: Devices.ios.iPhone13,
                  isFrameVisible: true,
                  screen: const Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: _ChatModalBody(),
                  ),
                ),
                // Composer floats on top of the device frame (not clipped by the
                // screen viewport). bottom: 20 lifts it clear of the very bottom
                // edge of the frame. left/right: 24 aligns with the screen
                // horizontal insets of the iPhone 13 frame at ~460 px width.
                Positioned(
                  bottom: bottomInset,
                  left: leftInset,
                  right: rightInset,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ctx.streamColorScheme.backgroundElevation1,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: StreamMessageComposer(
                        placeholderBuilder: (context, placeholder) => ctx.translations.writeAMessageLabel,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Screen body: blurred faux chat + dark scrim + right-aligned actions modal.
// No composer — it lives outside the DeviceFrame in _PhoneWithComposer.
class _ChatModalBody extends StatelessWidget {
  const _ChatModalBody();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Blurred faux message bubbles.
        const _FauxBlurredMessageList(),
        // 2. Semi-transparent scrim.
        ColoredBox(color: Colors.black.withValues(alpha: 0.25)),
        // 3. Message is from the current user → right-aligned.
        core.StreamMessageLayout(
          data: const core.StreamMessageLayoutData(
            alignment: core.StreamMessageAlignment.end,
          ),
          child: Builder(
            builder: (context) => StreamMessageActionsModal(
              message: _message,
              showReactionPicker: true,
              messageWidget: StreamMessageItem(message: _message),
              messageActions: [
                StreamContextMenuAction<MessageAction>(
                  value: EditMessage(message: _message),
                  leading: Icon(context.streamIcons.edit),
                  label: Text(context.translations.editMessageLabel),
                ),
                StreamContextMenuAction<MessageAction>(
                  value: CopyMessage(message: _message),
                  leading: Icon(context.streamIcons.copy),
                  label: Text(context.translations.copyMessageLabel),
                ),
                StreamContextMenuAction<MessageAction>.destructive(
                  value: DeleteMessage(message: _message),
                  leading: Icon(context.streamIcons.delete),
                  label: Text(context.translations.deleteMessageLabel),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FauxBlurredMessageList extends StatelessWidget {
  const _FauxBlurredMessageList();

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF005FFF);
    const other = Color(0xFFE9E9EB);

    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Bubble(width: 210, color: other, align: CrossAxisAlignment.start),
            SizedBox(height: 10),
            _Bubble(width: 155, color: brand, align: CrossAxisAlignment.end),
            SizedBox(height: 10),
            _Bubble(width: 230, color: other, align: CrossAxisAlignment.start),
            SizedBox(height: 10),
            _Bubble(width: 130, color: brand, align: CrossAxisAlignment.end),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.width, required this.color, required this.align});

  final double width;
  final Color color;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          width: width,
          height: 46,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ],
    );
  }
}

({MockClient client, MockChannel channel}) _buildMockedChannel({required String id}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(type: 'messaging', id: id);
  final channelState = MockChannelState();
  setupMockChannel(
    client: client,
    clientState: clientState,
    channel: channel,
    channelState: channelState,
  );
  stubMockClientCurrentUser(client, ownUser);
  return (client: client, channel: channel);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  docsGoldenTest(
    'localization support',
    fileName: 'localization_support',
    constraints: const BoxConstraints.tightFor(width: 1000, height: 900),
    builder: () {
      final en = _buildMockedChannel(id: 'en-general');
      final it = _buildMockedChannel(id: 'it-general');

      // iPhone 13 frame: 873 × 1771 (physical px, pixelRatio 3.0).
      // At width 460, scale = 460/873 ≈ 0.527 → height ≈ 933 px.
      const phoneW = 460.0;
      const phoneH = 933.0;

      return Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Background: blue gradient (60%) left, grey (40%) right.
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0063F7), Color(0xFF0047CC)],
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: ColoredBox(color: Color(0xFFADB5BD)),
              ),
            ],
          ),
          // Left phone (English): slightly left and down.
          // left: -40 → clips 40 px at the left edge.
          // top: 40   → top bezel starts 40 px from canvas top.
          Positioned(
            left: -40,
            top: 40,
            width: phoneW,
            height: phoneH,
            child: _PhoneWithComposer(
              locale: const Locale('en'),
              client: en.client,
              channel: en.channel,
              leftInset: 60,
              rightInset: -60,
              bottomInset: 130,
            ),
          ),
          // Right phone (Italian): slightly right and up.
          // right: 30 → clips 30 px at the right edge.
          // top: -65  → top 65 px of phone above canvas (notch clipped).
          Positioned(
            right: 30,
            top: -65,
            width: phoneW,
            height: phoneH,
            child: _PhoneWithComposer(
              locale: const Locale('it'),
              client: it.client,
              channel: it.channel,
              leftInset: -10,
              rightInset: -10,
              bottomInset: 70,
            ),
          ),
        ],
      );
    },
  );
}
