import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('Live Location Event Handling', () {
    chatClientTest(
      'should handle location.shared event',
      body: (tester) async {
        final location = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: tester.currentUser!.id,
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final event = createDefaultEvent(
          type: EventType.locationShared,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: location,
          ),
        );

        // Initially empty
        expect(tester.clientState.activeLiveLocations, isEmpty);

        // Trigger the event
        await tester.emitEvent(event);

        // Should add location to active live locations
        final activeLiveLocations = tester.clientState.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations.first.messageId, equals('message-123'));
      },
    );

    chatClientTest(
      'should handle location.updated event',
      body: (tester) async {
        final initialLocation = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: tester.currentUser!.id,
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        // Set initial location
        tester.clientState.activeLiveLocations = [initialLocation];

        final updatedLocation = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: tester.currentUser!.id,
          latitude: 40.7500, // Updated latitude
          longitude: -74.1000, // Updated longitude
          createdByDeviceId: 'device-1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final event = createDefaultEvent(
          type: EventType.locationUpdated,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: updatedLocation,
          ),
        );

        // Trigger the event
        await tester.emitEvent(event);

        // Should update the location
        final activeLiveLocations = tester.clientState.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations.first.latitude, equals(40.7500));
        expect(activeLiveLocations.first.longitude, equals(-74.1000));
      },
    );

    chatClientTest(
      'should handle location.expired event',
      body: (tester) async {
        final location = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: tester.currentUser!.id,
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        // Set initial location
        tester.clientState.activeLiveLocations = [location];
        expect(tester.clientState.activeLiveLocations, hasLength(1));

        final expiredLocation = location.copyWith(
          endAt: DateTime.timestamp().subtract(const Duration(hours: 1)),
        );

        final event = createDefaultEvent(
          type: EventType.locationExpired,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: expiredLocation,
          ),
        );

        // Trigger the event
        await tester.emitEvent(event);

        // Should remove the location
        expect(tester.clientState.activeLiveLocations, isEmpty);
      },
    );

    chatClientTest(
      'should auto-expire an active live location once at endAt',
      body: (tester) async {
        final expiredEvents = <Event>[];
        final sub = tester.client.on(EventType.locationExpired).listen(expiredEvents.add);
        addTearDown(sub.cancel);

        // Setting an active location schedules a one-shot expiry timer.
        tester.clientState.activeLiveLocations = [
          Location(
            channelCid: 'test-channel:123',
            messageId: 'message-123',
            userId: tester.currentUser!.id,
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device-1',
            endAt: DateTime.timestamp().add(const Duration(milliseconds: 800)),
          ),
        ];
        expect(tester.clientState.activeLiveLocations, hasLength(1));

        // Before endAt nothing is emitted and the location stays active.
        await Future.delayed(const Duration(milliseconds: 200));
        expect(expiredEvents, isEmpty);
        expect(tester.clientState.activeLiveLocations, hasLength(1));

        // After endAt the timer fires once and the location is removed.
        await Future.delayed(const Duration(milliseconds: 900));
        expect(expiredEvents, hasLength(1));
        expect(tester.clientState.activeLiveLocations, isEmpty);

        // The timer is one-shot: no further events are emitted.
        await Future.delayed(const Duration(milliseconds: 300));
        expect(expiredEvents, hasLength(1));
      },
    );

    chatClientTest(
      'should ignore location events for other users',
      body: (tester) async {
        final location = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: 'other-user', // Different user
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final event = createDefaultEvent(
          type: EventType.locationShared,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: location,
          ),
        );

        // Trigger the event
        await tester.emitEvent(event);

        // Should not add location from other user
        expect(tester.clientState.activeLiveLocations, isEmpty);
      },
    );

    chatClientTest(
      'should ignore static location events',
      body: (tester) async {
        final staticLocation = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: tester.currentUser!.id,
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          // No endAt means it's static
        );

        final event = createDefaultEvent(
          type: EventType.locationShared,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: staticLocation,
          ),
        );

        // Trigger the event
        await tester.emitEvent(event);

        // Should not add static location
        expect(tester.clientState.activeLiveLocations, isEmpty);
      },
    );

    chatClientTest(
      'should merge locations with same key',
      body: (tester) async {
        final location1 = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-123',
          userId: tester.currentUser!.id,
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device-1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final location2 = Location(
          channelCid: 'test-channel:123',
          messageId: 'message-456',
          userId: tester.currentUser!.id,
          latitude: 40.7500,
          longitude: -74.1000,
          createdByDeviceId: 'device-1', // Same device, should merge
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final event1 = createDefaultEvent(
          type: EventType.locationShared,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-123',
            sharedLocation: location1,
          ),
        );

        final event2 = createDefaultEvent(
          type: EventType.locationShared,
          cid: 'test-channel:123',
          message: Message(
            id: 'message-456',
            sharedLocation: location2,
          ),
        );

        // Trigger first event
        await tester.emitEvent(event1);

        final activeLiveLocations = tester.clientState.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations.first.messageId, equals('message-123'));

        // Trigger second event - should merge/update
        await tester.emitEvent(event2);

        final activeLiveLocations2 = tester.clientState.activeLiveLocations;
        expect(activeLiveLocations2, hasLength(1));
        expect(activeLiveLocations2.first.messageId, equals('message-456'));
      },
    );
  });
}
