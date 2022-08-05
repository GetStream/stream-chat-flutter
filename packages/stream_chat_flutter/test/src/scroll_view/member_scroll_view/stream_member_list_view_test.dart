import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

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
    when(() => clientState.currentUserStream)
        .thenAnswer((_) => Stream.value(OwnUser(id: 'testid')));
    channel = MockChannel();
    when(() => channel.on(any(), any(), any(), any()))
        .thenAnswer((_) => const Stream.empty());
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);

    when(() => channelClientState.membersStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
  });

  testWidgets('renders empty member list view', (tester) async {
    const emptyWidgetKey = Key('empty_widget');
    final controller = MockStreamMemberListController();

    when(controller.doInitialLoad).thenAnswer((_) async {
      controller.value = const PagedValue(items: []);
    });

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: StreamMemberListView(
                emptyBuilder: (_) => Container(key: emptyWidgetKey),
                controller: controller,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StreamMemberListView), findsOneWidget);
    expect(find.byKey(emptyWidgetKey), findsOneWidget);
  });
}
