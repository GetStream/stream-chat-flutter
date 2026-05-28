import 'dart:async';
import 'dart:collection';

import 'package:stream_chat/src/core/util/immutable_collection_subjects.dart';
import 'package:test/test.dart';

void main() {
  group('ImmutableMapBehaviorSubject', () {
    test('non-seeded constructor throws when reading `value` before any add', () {
      final controller = ImmutableMapBehaviorSubject<String, int>();
      addTearDown(controller.close);

      expect(() => controller.value, throwsA(isA<Error>()));
    });

    test('non-seeded constructor surfaces the first add as `value`', () {
      final controller = ImmutableMapBehaviorSubject<String, int>();
      addTearDown(controller.close);

      controller.add({'a': 1});

      expect(controller.value, equals({'a': 1}));
      expect(controller.value, isA<UnmodifiableMapView<String, int>>());
    });

    test('seeded constructor exposes the seed wrapped as unmodifiable', () {
      final controller = ImmutableMapBehaviorSubject<String, int>.seeded({'a': 1});
      addTearDown(controller.close);

      expect(controller.value, equals({'a': 1}));
      expect(controller.value, isA<UnmodifiableMapView<String, int>>());
      expect(() => controller.value['b'] = 2, throwsUnsupportedError);
    });

    test('`add` wraps plain maps as unmodifiable', () {
      final controller = ImmutableMapBehaviorSubject<String, int>.seeded({});
      addTearDown(controller.close);

      controller.add({'a': 1});

      expect(controller.value, equals({'a': 1}));
      expect(controller.value, isA<UnmodifiableMapView<String, int>>());
      expect(() => controller.value['b'] = 2, throwsUnsupportedError);
    });

    test('`add` throws after close', () async {
      final controller = ImmutableMapBehaviorSubject<String, int>.seeded({'a': 1});
      await controller.close();

      expect(() => controller.add({'b': 2}), throwsStateError);
    });

    test('`safeAdd` wraps plain maps as unmodifiable', () {
      final controller = ImmutableMapBehaviorSubject<String, int>.seeded({});
      addTearDown(controller.close);

      controller.safeAdd({'a': 1});

      expect(controller.value, equals({'a': 1}));
      expect(controller.value, isA<UnmodifiableMapView<String, int>>());
    });

    test('`safeAdd` is a no-op after close', () async {
      final controller = ImmutableMapBehaviorSubject<String, int>.seeded({'a': 1});
      await controller.close();

      // Should not throw.
      controller.safeAdd({'b': 2});
    });

    test('subscribers receive unmodifiable maps', () async {
      final controller = ImmutableMapBehaviorSubject<String, int>.seeded({'seed': 0});
      addTearDown(controller.close);

      final received = <Map<String, int>>[];
      final sub = controller.listen(received.add);
      addTearDown(sub.cancel);

      controller
        ..add({'a': 1})
        ..safeAdd({'b': 2});
      await Future<void>.delayed(Duration.zero);

      expect(received, hasLength(3));
      for (final map in received) {
        expect(map, isA<UnmodifiableMapView<String, int>>());
        expect(() => map['x'] = 9, throwsUnsupportedError);
      }
    });

    test('IS-A Stream / Sink', () {
      final controller = ImmutableMapBehaviorSubject<String, int>.seeded({'a': 1});
      addTearDown(controller.close);

      expect(controller, isA<Stream<Map<String, int>>>());
      expect(controller, isA<Sink<Map<String, int>>>());
    });
  });

  group('ImmutableListBehaviorSubject', () {
    test('non-seeded constructor throws when reading `value` before any add', () {
      final controller = ImmutableListBehaviorSubject<int>();
      addTearDown(controller.close);

      expect(() => controller.value, throwsA(isA<Error>()));
    });

    test('non-seeded constructor surfaces the first add as `value`', () {
      final controller = ImmutableListBehaviorSubject<int>();
      addTearDown(controller.close);

      controller.add([1, 2, 3]);

      expect(controller.value, equals([1, 2, 3]));
      expect(controller.value, isA<UnmodifiableListView<int>>());
    });

    test('seeded constructor exposes the seed wrapped as unmodifiable', () {
      final controller = ImmutableListBehaviorSubject<int>.seeded(const [1, 2, 3]);
      addTearDown(controller.close);

      expect(controller.value, equals([1, 2, 3]));
      expect(controller.value, isA<UnmodifiableListView<int>>());
      expect(() => controller.value.add(4), throwsUnsupportedError);
    });

    test('`add` wraps plain lists as unmodifiable', () {
      final controller = ImmutableListBehaviorSubject<int>.seeded(const []);
      addTearDown(controller.close);

      controller.add([1, 2, 3]);

      expect(controller.value, equals([1, 2, 3]));
      expect(controller.value, isA<UnmodifiableListView<int>>());
      expect(() => controller.value.add(4), throwsUnsupportedError);
    });

    test('`add` throws after close', () async {
      final controller = ImmutableListBehaviorSubject<int>.seeded(const [1]);
      await controller.close();

      expect(() => controller.add([2]), throwsStateError);
    });

    test('`safeAdd` wraps plain lists as unmodifiable', () {
      final controller = ImmutableListBehaviorSubject<int>.seeded(const []);
      addTearDown(controller.close);

      controller.safeAdd([1, 2, 3]);

      expect(controller.value, equals([1, 2, 3]));
      expect(controller.value, isA<UnmodifiableListView<int>>());
    });

    test('`safeAdd` is a no-op after close', () async {
      final controller = ImmutableListBehaviorSubject<int>.seeded(const [1]);
      await controller.close();

      // Should not throw.
      controller.safeAdd([2]);
    });

    test('subscribers receive unmodifiable lists', () async {
      final controller = ImmutableListBehaviorSubject<int>.seeded(const [0]);
      addTearDown(controller.close);

      final received = <List<int>>[];
      final sub = controller.listen(received.add);
      addTearDown(sub.cancel);

      controller
        ..add([1])
        ..safeAdd([1, 2]);
      await Future<void>.delayed(Duration.zero);

      expect(received, hasLength(3));
      for (final list in received) {
        expect(list, isA<UnmodifiableListView<int>>());
        expect(() => list.add(99), throwsUnsupportedError);
      }
    });

    test('IS-A Stream / Sink', () {
      final controller = ImmutableListBehaviorSubject<int>.seeded(const [1]);
      addTearDown(controller.close);

      expect(controller, isA<Stream<List<int>>>());
      expect(controller, isA<Sink<List<int>>>());
    });
  });
}
