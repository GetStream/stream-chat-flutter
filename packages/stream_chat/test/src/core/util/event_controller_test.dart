// ignore_for_file: cascade_invocations, avoid_redundant_argument_values

import 'dart:async';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/util/event_controller.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:test/test.dart';

void main() {
  group('EventController events', () {
    late EventController<Event> controller;

    setUp(() {
      controller = EventController<Event>();
    });

    tearDown(() {
      controller.close();
    });

    test('should emit events without resolvers', () async {
      final event = Event(type: EventType.messageNew);

      final streamEvents = <Event>[];
      controller.listen(streamEvents.add);

      controller.add(event);

      await Future.delayed(Duration.zero);

      expect(streamEvents, hasLength(1));
      expect(streamEvents.first.type, EventType.messageNew);
    });

    test('should apply resolvers in order', () async {
      Event? firstResolver(Event event) {
        if (event.type == EventType.messageNew) {
          return event.copyWith(type: EventType.pollCreated);
        }
        return null;
      }

      Event? secondResolver(Event event) {
        if (event.type == EventType.pollCreated) {
          return event.copyWith(type: EventType.locationShared);
        }
        return null;
      }

      controller = EventController<Event>(
        resolvers: [firstResolver, secondResolver],
      );

      final streamEvents = <Event>[];
      controller.listen(streamEvents.add);

      final originalEvent = Event(type: EventType.messageNew);
      controller.add(originalEvent);

      await Future.delayed(Duration.zero);

      expect(streamEvents, hasLength(1));
      expect(streamEvents.first.type, EventType.pollCreated);
    });

    test('should stop at first matching resolver', () async {
      var firstResolverCalled = false;
      var secondResolverCalled = false;

      Event? firstResolver(Event event) {
        firstResolverCalled = true;
        if (event.type == EventType.messageNew) {
          return event.copyWith(type: EventType.pollCreated);
        }
        return null;
      }

      Event? secondResolver(Event event) {
        secondResolverCalled = true;
        return event.copyWith(type: EventType.locationShared);
      }

      controller = EventController<Event>(
        resolvers: [firstResolver, secondResolver],
      );

      final streamEvents = <Event>[];
      controller.listen(streamEvents.add);

      final originalEvent = Event(type: EventType.messageNew);
      controller.add(originalEvent);

      await Future.delayed(Duration.zero);

      expect(firstResolverCalled, isTrue);
      expect(secondResolverCalled, isFalse);
      expect(streamEvents, hasLength(1));
      expect(streamEvents.first.type, EventType.pollCreated);
    });

    test('should emit original event when no resolver matches', () async {
      Event? resolver(Event event) {
        if (event.type == EventType.pollCreated) {
          return event.copyWith(type: EventType.locationShared);
        }
        return null;
      }

      controller = EventController<Event>(
        resolvers: [resolver],
      );

      final streamEvents = <Event>[];
      controller.listen(streamEvents.add);

      final originalEvent = Event(type: EventType.messageNew);
      controller.add(originalEvent);

      await Future.delayed(Duration.zero);

      expect(streamEvents, hasLength(1));
      expect(streamEvents.first.type, EventType.messageNew);
    });

    test('should work with multiple resolvers that return null', () async {
      Event? firstResolver(Event event) => null;
      Event? secondResolver(Event event) => null;
      Event? thirdResolver(Event event) => null;

      controller = EventController<Event>(
        resolvers: [firstResolver, secondResolver, thirdResolver],
      );

      final streamEvents = <Event>[];
      controller.listen(streamEvents.add);

      final originalEvent = Event(type: EventType.messageNew);
      controller.add(originalEvent);

      await Future.delayed(Duration.zero);

      expect(streamEvents, hasLength(1));
      expect(streamEvents.first.type, EventType.messageNew);
    });

    test('should handle empty resolvers list', () async {
      controller = EventController<Event>(resolvers: []);

      final streamEvents = <Event>[];
      controller.listen(streamEvents.add);

      final originalEvent = Event(type: EventType.messageNew);
      controller.add(originalEvent);

      await Future.delayed(Duration.zero);

      expect(streamEvents, hasLength(1));
      expect(streamEvents.first.type, EventType.messageNew);
    });

    test('should support custom onListen callback', () async {
      var onListenCalled = false;

      controller = EventController<Event>(
        onListen: () => onListenCalled = true,
      );

      expect(onListenCalled, isFalse);

      controller.listen((_) {});

      expect(onListenCalled, isTrue);
    });

    test('should support custom onCancel callback', () async {
      var onCancelCalled = false;

      controller = EventController<Event>(
        onCancel: () => onCancelCalled = true,
      );

      final subscription = controller.listen((_) {});

      expect(onCancelCalled, isFalse);

      await subscription.cancel();

      expect(onCancelCalled, isTrue);
    });

    test('should support sync mode', () async {
      controller = EventController<Event>(sync: true);

      final streamEvents = <Event>[];
      controller.listen(streamEvents.add);

      final originalEvent = Event(type: EventType.messageNew);
      controller.add(originalEvent);

      // In sync mode, events should be available immediately
      expect(streamEvents, hasLength(1));
      expect(streamEvents.first.type, EventType.messageNew);
    });

    test('should handle resolver exceptions gracefully', () async {
      Event? failingResolver(Event event) {
        throw Exception('Resolver failed');
      }

      Event? workingResolver(Event event) {
        return event.copyWith(type: EventType.pollCreated);
      }

      controller = EventController<Event>(
        resolvers: [failingResolver, workingResolver],
      );

      final streamEvents = <Event>[];
      controller.listen(streamEvents.add);

      final originalEvent = Event(type: EventType.messageNew);

      // This should throw an exception because the resolver throws
      expect(() => controller.add(originalEvent), throwsException);
    });

    test('should be compatible with stream operations', () async {
      final event1 = Event(type: EventType.messageNew);
      final event2 = Event(type: EventType.messageUpdated);

      final streamEvents = <Event>[];
      controller
          .where((event) => event.type == EventType.messageNew)
          .listen(streamEvents.add);

      controller.add(event1);
      controller.add(event2);

      await Future.delayed(Duration.zero);

      expect(streamEvents, hasLength(1));
      expect(streamEvents.first.type, EventType.messageNew);
    });

    test('should work with multiple listeners', () async {
      final streamEvents1 = <Event>[];
      final streamEvents2 = <Event>[];

      controller.listen(streamEvents1.add);
      controller.listen(streamEvents2.add);

      final originalEvent = Event(type: EventType.messageNew);
      controller.add(originalEvent);

      await Future.delayed(Duration.zero);

      expect(streamEvents1, hasLength(1));
      expect(streamEvents2, hasLength(1));
      expect(streamEvents1.first.type, EventType.messageNew);
      expect(streamEvents2.first.type, EventType.messageNew);
    });

    test('should preserve event properties through resolvers', () async {
      final originalEvent = Event(
        type: EventType.messageNew,
        userId: 'user123',
        cid: 'channel123',
        connectionId: 'conn123',
        me: null,
        user: null,
        extraData: {'custom': 'data'},
      );

      Event? resolver(Event event) {
        if (event.type == EventType.messageNew) {
          return event.copyWith(type: EventType.pollCreated);
        }
        return null;
      }

      controller = EventController<Event>(
        resolvers: [resolver],
      );

      final streamEvents = <Event>[];
      controller.listen(streamEvents.add);

      controller.add(originalEvent);

      await Future.delayed(Duration.zero);

      expect(streamEvents, hasLength(1));
      final resolvedEvent = streamEvents.first;
      expect(resolvedEvent.type, EventType.pollCreated);
      expect(resolvedEvent.userId, 'user123');
      expect(resolvedEvent.cid, 'channel123');
      expect(resolvedEvent.connectionId, 'conn123');
      expect(resolvedEvent.extraData, {'custom': 'data'});
    });

    test('should handle resolver modifying event data', () async {
      final originalEvent = Event(
        type: EventType.messageNew,
        userId: 'user123',
        extraData: {'original': 'data'},
      );

      Event? resolver(Event event) {
        if (event.type == EventType.messageNew) {
          return event.copyWith(
            type: EventType.pollCreated,
            userId: 'modified_user',
            extraData: {'modified': 'data'},
          );
        }
        return null;
      }

      controller = EventController<Event>(
        resolvers: [resolver],
      );

      final streamEvents = <Event>[];
      controller.listen(streamEvents.add);

      controller.add(originalEvent);

      await Future.delayed(Duration.zero);

      expect(streamEvents, hasLength(1));
      final resolvedEvent = streamEvents.first;
      expect(resolvedEvent.type, EventType.pollCreated);
      expect(resolvedEvent.userId, 'modified_user');
      expect(resolvedEvent.extraData, {'modified': 'data'});
    });
  });
}
