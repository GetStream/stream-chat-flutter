import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
  channel: createDefaultChannelModel(cid: _channelCid),
);

void main() {
  group('Location events', () {
    channelTest(
      'should handle location.shared event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Verify initial state
        expect(tester.channelState?.activeLiveLocations, isEmpty);

        // Create live location
        final liveLocation = Location(
          channelCid: _channelCid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Dispatch location.shared event
        await tester.emitEvent(
          createDefaultEvent(
            cid: _channelCid,
            type: EventType.locationShared,
            message: locationMessage,
          ),
        );

        // Check if message was added
        final messages = tester.channelState?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message, isNotNull);

        // Check if active live location was updated
        final activeLiveLocations = tester.channelState?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('msg1'));
      },
    );

    channelTest(
      'should handle location.updated event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Setup initial state with location message
        final liveLocation = Location(
          channelCid: _channelCid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial message
        tester.channelState?.addNewMessage(locationMessage);

        // Create updated location
        final updatedLocation = liveLocation.copyWith(
          latitude: 40.7500, // Updated latitude
          longitude: -74.1000, // Updated longitude
        );

        final updatedMessage = locationMessage.copyWith(
          sharedLocation: updatedLocation,
        );

        // Dispatch location.updated event
        await tester.emitEvent(
          createDefaultEvent(
            cid: _channelCid,
            type: EventType.locationUpdated,
            message: updatedMessage,
          ),
        );

        // Check if message was updated
        final messages = tester.channelState?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation?.latitude, equals(40.7500));
        expect(message?.sharedLocation?.longitude, equals(-74.1000));

        // Check if active live location was updated
        final activeLiveLocations = tester.channelState?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
        expect(activeLiveLocations?.first.longitude, equals(-74.1000));
      },
    );

    channelTest(
      'should handle location.expired event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Setup initial state with location message
        final liveLocation = Location(
          channelCid: _channelCid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial message
        tester.channelState?.addNewMessage(locationMessage);
        expect(tester.channelState?.activeLiveLocations, hasLength(1));

        // Create expired location
        final expiredLocation = liveLocation.copyWith(
          endAt: DateTime.timestamp().subtract(const Duration(hours: 1)),
        );

        final expiredMessage = locationMessage.copyWith(
          sharedLocation: expiredLocation,
        );

        // Dispatch location.expired event
        await tester.emitEvent(
          createDefaultEvent(
            cid: _channelCid,
            type: EventType.locationExpired,
            message: expiredMessage,
          ),
        );

        // Check if message was updated
        final messages = tester.channelState?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation?.isExpired, isTrue);

        // Check if active live location was removed
        expect(tester.channelState?.activeLiveLocations, isEmpty);
      },
    );

    channelTest(
      "should auto-expire another user's live location once at endAt",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final liveLocation = Location(
          channelCid: _channelCid,
          userId: 'user1', // Another user.
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().add(const Duration(milliseconds: 800)),
        );

        // The real client processes every event it handles, so collect the
        // handled events the way the old mock captured `client.handleEvent`.
        final captured = <Event>[];
        final subscription = tester.client.on().listen(captured.add);

        tester.channelState?.addNewMessage(
          Message(id: 'msg1', sharedLocation: liveLocation),
        );
        expect(tester.channelState?.activeLiveLocations, hasLength(1));

        // Before endAt no expiry event is emitted.
        await Future.delayed(const Duration(milliseconds: 200));
        expect(captured, isEmpty);

        // After endAt the scheduler emits exactly one location.expired event.
        await Future.delayed(const Duration(milliseconds: 900));
        expect(captured, hasLength(1));
        final event = captured.single;
        expect(event.type, EventType.locationExpired);
        expect(event.message?.id, 'msg1');

        await subscription.cancel();
      },
    );

    channelTest(
      "should not auto-expire the current user's own live location",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final ownLocation = Location(
          channelCid: _channelCid,
          userId: tester.currentUser!.id, // The current user (handled by the client).
          messageId: 'msg-own',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().add(const Duration(milliseconds: 150)),
        );

        final captured = <Event>[];
        final subscription = tester.client.on().listen(captured.add);

        tester.channelState?.addNewMessage(
          Message(id: 'msg-own', sharedLocation: ownLocation),
        );
        expect(tester.channelState?.activeLiveLocations, hasLength(1));

        // The channel scheduler skips the current user's own locations, so no
        // expiry event is emitted even after endAt passes.
        await Future.delayed(const Duration(milliseconds: 300));
        expect(captured, isEmpty);

        await subscription.cancel();
      },
    );

    channelTest(
      "should auto-expire another user's location that arrives expired",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final expiredLocation = Location(
          channelCid: _channelCid,
          userId: 'user1', // Another user.
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().subtract(const Duration(minutes: 5)),
        );

        final captured = <Event>[];
        final subscription = tester.client.on().listen(captured.add);

        // Mirrors a query/watch response whose live location is already past
        // endAt by the local clock, e.g. when the device clock runs ahead of
        // the server or endAt passed while the response was in flight.
        tester.channelState?.updateChannelState(
          ChannelState(messages: const [], activeLiveLocations: [expiredLocation]),
        );
        expect(tester.channelState?.activeLiveLocations, hasLength(1));

        // The scheduler fires straight away and emits exactly one event.
        await Future.delayed(const Duration(milliseconds: 100));
        expect(captured, hasLength(1));
        final event = captured.single;
        expect(event.type, EventType.locationExpired);
        expect(event.message?.id, 'msg1');

        await subscription.cancel();
      },
    );

    channelTest(
      'should not add static location to active locations',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final staticLocation = Location(
          channelCid: _channelCid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          // No endAt - static location
        );

        final staticMessage = Message(
          id: 'msg1',
          text: 'Static location shared',
          sharedLocation: staticLocation,
        );

        // Dispatch location.shared event
        await tester.emitEvent(
          createDefaultEvent(
            cid: _channelCid,
            type: EventType.locationShared,
            message: staticMessage,
          ),
        );

        // Check if message was added
        final messages = tester.channelState?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation, isNotNull);

        // Check if active live location was NOT updated (should remain empty)
        expect(tester.channelState?.activeLiveLocations, isEmpty);
      },
    );

    channelTest(
      'should update active locations when location message is deleted',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final liveLocation = Location(
          channelCid: _channelCid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Verify initial state
        tester.channelState?.addNewMessage(locationMessage);
        expect(tester.channelState?.activeLiveLocations, hasLength(1));

        // Dispatch message.deleted event
        await tester.emitEvent(
          createDefaultEvent(
            type: EventType.messageDeleted,
            cid: _channelCid,
            message: locationMessage.copyWith(
              type: MessageType.deleted,
              deletedAt: DateTime.timestamp(),
            ),
          ),
        );

        // Verify active locations are updated
        expect(tester.channelState?.activeLiveLocations, isEmpty);
      },
    );

    channelTest(
      'should merge locations with same key',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final liveLocation = Location(
          channelCid: _channelCid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial location for setup
        tester.channelState?.addNewMessage(locationMessage);
        expect(tester.channelState?.activeLiveLocations, hasLength(1));

        // Create new location with same user, channel, and device
        final newLocation = Location(
          channelCid: _channelCid,
          userId: 'user1', // Same user
          messageId: 'msg2', // Different message
          latitude: 40.7500,
          longitude: -74.1000,
          createdByDeviceId: 'device1', // Same device
          endAt: DateTime.timestamp().add(const Duration(hours: 2)),
        );

        final newMessage = Message(
          id: 'msg2',
          text: 'Updated location',
          sharedLocation: newLocation,
        );

        // Dispatch location.shared event for the new message
        await tester.emitEvent(
          createDefaultEvent(
            cid: _channelCid,
            type: EventType.locationShared,
            message: newMessage,
          ),
        );

        // Should still have only one active location (merged)
        final activeLiveLocations = tester.channelState?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('msg2'));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
      },
    );

    channelTest(
      'should handle multiple active locations from different devices',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final liveLocation = Location(
          channelCid: _channelCid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add first location for setup
        tester.channelState?.addNewMessage(locationMessage);
        expect(tester.channelState?.activeLiveLocations, hasLength(1));

        // Create location from different device
        final location2 = Location(
          channelCid: _channelCid,
          userId: 'user1', // Same user
          messageId: 'msg2',
          latitude: 34.0522,
          longitude: -118.2437,
          createdByDeviceId: 'device2', // Different device
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final message2 = Message(
          id: 'msg2',
          text: 'Location from device 2',
          sharedLocation: location2,
        );

        // Dispatch location.shared event for the second message
        await tester.emitEvent(
          createDefaultEvent(
            cid: _channelCid,
            type: EventType.locationShared,
            message: message2,
          ),
        );

        // Should have two active locations
        expect(tester.channelState?.activeLiveLocations, hasLength(2));
      },
    );

    channelTest(
      'should handle location messages in threads',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final parentMessage = Message(
          id: 'parent1',
          text: 'Thread parent',
        );

        // Add parent message first for setup
        tester.channelState?.addNewMessage(parentMessage);

        final liveLocation = Location(
          channelCid: _channelCid,
          userId: 'user1',
          messageId: 'thread-msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final threadLocationMessage = Message(
          id: 'thread-msg1',
          text: 'Live location in thread',
          parentId: 'parent1',
          sharedLocation: liveLocation,
        );

        // Dispatch location.shared event for the thread message
        await tester.emitEvent(
          createDefaultEvent(
            cid: _channelCid,
            type: EventType.locationShared,
            message: threadLocationMessage,
          ),
        );

        // Check if thread message was added. The wire round-trip rewrites the
        // local-only message fields (state, local timestamps), so match on id
        // and the location payload instead of whole-message equality.
        final thread = tester.channelState?.threads['parent1'];
        final threadMessage = thread?.firstWhere((m) => m.id == 'thread-msg1');
        expect(threadMessage, isNotNull);
        expect(threadMessage?.sharedLocation, equals(liveLocation));

        // Check if location was added to active locations
        final activeLiveLocations = tester.channelState?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('thread-msg1'));
      },
    );

    channelTest(
      'should update thread location messages',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final parentMessage = Message(
          id: 'parent1',
          text: 'Thread parent',
        );

        final liveLocation = Location(
          channelCid: _channelCid,
          userId: 'user1',
          messageId: 'thread-msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.timestamp().add(const Duration(hours: 1)),
        );

        final threadLocationMessage = Message(
          id: 'thread-msg1',
          text: 'Live location in thread',
          parentId: 'parent1',
          sharedLocation: liveLocation,
        );

        // Add messages
        tester.channelState?.addNewMessage(parentMessage);
        tester.channelState?.addNewMessage(threadLocationMessage);

        // Update the location
        final updatedLocation = liveLocation.copyWith(
          latitude: 40.7500,
          longitude: -74.1000,
        );

        final updatedThreadMessage = threadLocationMessage.copyWith(
          sharedLocation: updatedLocation,
        );

        // Dispatch location.updated event for the thread message
        await tester.emitEvent(
          createDefaultEvent(
            cid: _channelCid,
            type: EventType.locationUpdated,
            message: updatedThreadMessage,
          ),
        );

        // Check if thread message was updated
        final thread = tester.channelState?.threads['parent1'];
        final threadMessage = thread?.firstWhere((m) => m.id == 'thread-msg1');
        expect(threadMessage?.sharedLocation?.latitude, equals(40.7500));
        expect(threadMessage?.sharedLocation?.longitude, equals(-74.1000));

        // Check if active location was updated
        final activeLiveLocations = tester.channelState?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
        expect(activeLiveLocations?.first.longitude, equals(-74.1000));
      },
    );
  });
}
