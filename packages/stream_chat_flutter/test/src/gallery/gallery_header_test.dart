import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  late MockClient client;
  late MockClientState clientState;
  late MockChannel channel;
  late MockChannelState channelState;

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

  testWidgets(
    'renders auto-implied back button alongside the overflow action',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            connectivityStream: .value([.wifi]),
            child: StreamChannel(
              channel: channel,
              child: child!,
            ),
          ),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => Scaffold(
                        appBar: StreamGalleryHeader(
                          attachment: MockAttachment(),
                          message: Message(),
                        ),
                      ),
                    ),
                  ),
                  child: const Text('Open gallery'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(Icon), findsNWidgets(2));
    },
  );

  goldenTest(
    'golden test for GalleryHeader',
    fileName: 'gallery_header_0',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () {
      return MaterialAppWrapper(
        home: StreamChat(
          client: client,
          connectivityStream: .value([.wifi]),
          child: StreamChannel(
            channel: channel,
            child: PopScope(
              onPopInvokedWithResult: (bool didPop, res) async => false,
              child: Scaffold(
                appBar: StreamGalleryHeader(
                  userName: 'User',
                  sentAt: '12:02 AM',
                  message: Message(),
                  attachment: MockAttachment(),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
