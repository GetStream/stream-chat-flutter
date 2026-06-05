import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

Widget _buildIndicatorRow(MockClient client) {
  final sendingMsg = Message(
    id: 'msg-sending',
    text: '',
    user: ownUser,
    state: MessageState.sending,
  );
  final sentMsg = Message(
    id: 'msg-sent',
    text: '',
    user: ownUser,
    state: MessageState.sent,
  );

  return StreamChat(
    client: client,
    connectivityStream: Stream.value([ConnectivityResult.mobile]),
    child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamSendingIndicator(message: sendingMsg, size: 20),
            StreamSendingIndicator(message: sentMsg, size: 20),
            StreamSendingIndicator(
              message: sentMsg,
              isMessageDelivered: true,
              size: 20,
            ),
            StreamSendingIndicator(
              message: sentMsg,
              isMessageRead: true,
              size: 20,
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'message delivery states',
    fileName: 'message_delivery_states',
    constraints: const BoxConstraints.tightFor(width: 375, height: 60),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(ownUser);
      return _buildIndicatorRow(client);
    },
  );
}
