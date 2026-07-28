import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final currentUser = OwnUser(id: 'current-user');
  final otherUser = User(id: 'other-user');

  StreamAutoScrollDetails detailsWith({
    required bool isOwnMessage,
    required bool isAtBottom,
  }) {
    return StreamAutoScrollDetails(
      message: Message(text: 'hi', user: isOwnMessage ? currentUser : otherUser),
      currentUser: currentUser,
      isAtBottom: isAtBottom,
    );
  }

  group('StreamAutoScrollPolicy.whenOwnMessageOrAtBottom', () {
    const policy = StreamAutoScrollPolicy.whenOwnMessageOrAtBottom;

    test('animates an own message even when away from the bottom', () {
      final details = detailsWith(isOwnMessage: true, isAtBottom: false);
      expect(policy.resolve(details), StreamAutoScrollBehavior.animate);
    });

    test("animates another user's message while at the bottom", () {
      final details = detailsWith(isOwnMessage: false, isAtBottom: true);
      expect(policy.resolve(details), StreamAutoScrollBehavior.animate);
    });

    test("does not scroll for another user's message away from the bottom", () {
      final details = detailsWith(isOwnMessage: false, isAtBottom: false);
      expect(policy.resolve(details), StreamAutoScrollBehavior.none);
    });
  });

  group('StreamAutoScrollPolicy.whenAtBottom', () {
    const policy = StreamAutoScrollPolicy.whenAtBottom;

    test('animates while at the bottom regardless of sender', () {
      final own = detailsWith(isOwnMessage: true, isAtBottom: true);
      final other = detailsWith(isOwnMessage: false, isAtBottom: true);
      expect(policy.resolve(own), StreamAutoScrollBehavior.animate);
      expect(policy.resolve(other), StreamAutoScrollBehavior.animate);
    });

    test('does not scroll an own message when away from the bottom', () {
      final details = detailsWith(isOwnMessage: true, isAtBottom: false);
      expect(policy.resolve(details), StreamAutoScrollBehavior.none);
    });
  });

  group('StreamAutoScrollPolicy.disabled', () {
    const policy = StreamAutoScrollPolicy.disabled;

    test('never scrolls for an own message at the bottom', () {
      final details = detailsWith(isOwnMessage: true, isAtBottom: true);
      expect(policy.resolve(details), StreamAutoScrollBehavior.none);
    });

    test('never scrolls for an incoming message away from the bottom', () {
      final details = detailsWith(isOwnMessage: false, isAtBottom: false);
      expect(policy.resolve(details), StreamAutoScrollBehavior.none);
    });
  });

  group('StreamAutoScrollPolicy.custom', () {
    test('delegates to the provided resolver', () {
      final policy = StreamAutoScrollPolicy.custom((_) => StreamAutoScrollBehavior.jump);
      final details = detailsWith(isOwnMessage: false, isAtBottom: false);
      expect(policy.resolve(details), StreamAutoScrollBehavior.jump);
    });

    test('forwards the details to the resolver', () {
      StreamAutoScrollDetails? received;
      final policy = StreamAutoScrollPolicy.custom((details) {
        received = details;
        return StreamAutoScrollBehavior.none;
      });
      final details = detailsWith(isOwnMessage: true, isAtBottom: false);

      policy.resolve(details);

      expect(received, same(details));
    });
  });
}
