import 'package:stream_chat/src/client/live_location_expiration_scheduler.dart';
import 'package:stream_chat/src/core/models/location.dart';
import 'package:test/test.dart';

import '../utils.dart';

Location _location({
  String? messageId = 'msg1',
  String userId = 'user1',
  double latitude = 40.7128,
  double longitude = -74.0060,
  Duration? endsIn = const Duration(milliseconds: 200),
}) {
  return Location(
    channelCid: 'messaging:123',
    messageId: messageId,
    userId: userId,
    latitude: latitude,
    longitude: longitude,
    endAt: endsIn == null ? null : DateTime.now().add(endsIn),
  );
}

void main() {
  group('LiveLocationExpirationScheduler', () {
    late List<Location> expired;
    late LiveLocationExpirationScheduler scheduler;

    setUp(() {
      expired = <Location>[];
      scheduler = LiveLocationExpirationScheduler(onExpired: expired.add);
    });

    tearDown(() => scheduler.cancel());

    test('fires onExpired exactly once at endAt', () async {
      scheduler.schedule([_location(endsIn: const Duration(milliseconds: 200))]);

      // Before endAt nothing fires.
      await delay(80);
      expect(expired, isEmpty);

      // After endAt it fires exactly once.
      await delay(250);
      expect(expired, hasLength(1));
      expect(expired.single.messageId, 'msg1');

      // The timer is one-shot: no repeats even after more time passes.
      await delay(200);
      expect(expired, hasLength(1));
    });

    test('ignores static, already-expired and message-id-less locations', () async {
      scheduler.schedule([
        _location(messageId: 'static', endsIn: null),
        _location(messageId: 'expired', endsIn: const Duration(milliseconds: -1)),
        _location(messageId: null),
      ]);

      await delay(150);
      expect(expired, isEmpty);
    });

    test('reports latest coordinates and keeps expiry time on update', () async {
      // A moving live location updates its coordinates but keeps the same
      // endAt.
      final original = _location(
        latitude: 1,
        longitude: 1,
        endsIn: const Duration(milliseconds: 250),
      );
      scheduler.schedule([original]);

      await delay(80);
      // Same messageId and endAt, only the coordinates differ.
      final moved = original.copyWith(latitude: 2, longitude: 2);
      scheduler.schedule([moved]);

      // Still fires once at the original endAt (the update didn't shift it)...
      await delay(250);
      expect(expired, hasLength(1));
      // ...and reports the latest coordinates, not the original ones.
      expect(expired.single.latitude, 2);
    });

    test('reschedules when endAt changes', () async {
      final original = _location(endsIn: const Duration(milliseconds: 500));
      scheduler.schedule([original]);

      await delay(60);
      final rescheduled = original.copyWith(
        endAt: DateTime.now().add(const Duration(milliseconds: 150)),
      );
      scheduler.schedule([rescheduled]);

      // Fires at the new (earlier) endAt, before the original one.
      await delay(250);
      expect(expired, hasLength(1));
      expect(expired.single.endAt, rescheduled.endAt);

      // The original timer was cancelled, so it never fires.
      await delay(350);
      expect(expired, hasLength(1));
    });

    test('does not fire for a location removed before expiry', () async {
      scheduler.schedule([_location(endsIn: const Duration(milliseconds: 300))]);

      await delay(80);
      scheduler.schedule([]); // Removed from the active set.

      await delay(350);
      expect(expired, isEmpty);
    });

    test('cancel() prevents pending timers from firing', () async {
      scheduler
        ..schedule([_location(endsIn: const Duration(milliseconds: 200))])
        ..cancel();

      await delay(300);
      expect(expired, isEmpty);
    });
  });
}
