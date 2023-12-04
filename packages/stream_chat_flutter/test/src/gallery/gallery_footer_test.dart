import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  late MockClient client;
  late MockClientState clientState;
  late MockChannel channel;
  late MockChannelState channelState;
  const methodChannel =
      MethodChannel('dev.fluttercommunity.plus/connectivity_status');

  setUpAll(() {
    client = MockClient();
    clientState = MockClientState();
    channel = MockChannel();
    channelState = MockChannelState();
    final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
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
  });

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (MethodCall methodCall) async {
      if (methodCall.method == 'listen') {
        try {
          await TestDefaultBinaryMessengerBinding
              .instance.defaultBinaryMessenger
              .handlePlatformMessage(
            methodChannel.name,
            methodChannel.codec.encodeSuccessEnvelope('wifi'),
            (_) {},
          );
        } catch (e) {
          print(e);
        }
      }
      return null;
    });
  });

  testWidgets(
    'it should show channel typing',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: PopScope(
                onPopInvoked: (bool didPop) async => false,
                child: const Scaffold(
                  body: StreamGalleryFooter(
                    mediaAttachmentPackages: [],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StreamSvgIcon), findsNWidgets(2));
    },
  );

  testGoldens('golden test for GalleryFooter', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: PopScope(
              onPopInvoked: (bool didPop) async => false,
              child: const Scaffold(
                body: StreamGalleryFooter(
                  mediaAttachmentPackages: [],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'gallery_footer_0');
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });
}
