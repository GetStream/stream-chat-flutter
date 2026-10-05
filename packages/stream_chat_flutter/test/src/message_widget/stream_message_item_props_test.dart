import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final message = Message(
    id: 'message',
    text: 'Hello',
    user: User(id: 'user'),
  );

  void onMessageTap(Message message) {}

  test('StreamMessageItemProps built from the same values are equal', () {
    final first = StreamMessageItemProps(message: message, swipeToReply: true, onMessageTap: onMessageTap);
    final second = StreamMessageItemProps(message: message, swipeToReply: true, onMessageTap: onMessageTap);

    expect(first, second);
  });

  test('StreamMessageItemProps with a different callback are not equal', () {
    final first = StreamMessageItemProps(message: message, onMessageTap: onMessageTap);
    final second = StreamMessageItemProps(message: message, onMessageTap: (_) {});

    expect(first, isNot(second));
  });
}
