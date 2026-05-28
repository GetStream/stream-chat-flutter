import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/core/util/extension.dart';

/// A map that throws `UnsupportedError` on any mutating operation.
typedef ImmutableMap<K, V> = UnmodifiableMapView<K, V>;

/// A list that throws `UnsupportedError` on any mutating operation.
typedef ImmutableList<E> = UnmodifiableListView<E>;

/// A [Stream] of maps that guarantees every emitted value is immutable.
///
/// The stream is a broadcast stream — multiple subscribers can listen at
/// once. Subscribers receive snapshots that throw `UnsupportedError` on
/// mutation. Callers pass plain maps to [add] / [safeAdd] — wrapping is
/// automatic and unbypassable.
///
/// ```dart
/// final controller = ImmutableMapBehaviorSubject<String, Channel>.seeded(const {});
///
/// controller.listen(print);
/// controller.safeAdd({'general': generalChannel});
///
/// // Reads succeed.
/// final cached = controller.value['general'];
///
/// // Writes throw `UnsupportedError`.
/// controller.value['general'] = otherChannel;
/// ```
///
/// See also:
///
///  * [ImmutableListBehaviorSubject], the list counterpart.
@internal
class ImmutableMapBehaviorSubject<K, V> extends StreamView<ImmutableMap<K, V>> implements Sink<Map<K, V>> {
  /// Creates a subject with no initial value.
  ///
  /// [onListen], [onCancel] and [sync] follow [StreamController.broadcast]
  /// semantics.
  factory ImmutableMapBehaviorSubject({
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) => ImmutableMapBehaviorSubject._(
    BehaviorSubject<ImmutableMap<K, V>>(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    ),
  );

  /// Creates a subject with [seed] as the initial value.
  ///
  /// Subscribers connecting before the first [add] also receive [seed].
  ///
  /// [onListen], [onCancel] and [sync] follow [StreamController.broadcast]
  /// semantics.
  factory ImmutableMapBehaviorSubject.seeded(
    Map<K, V> seed, {
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) => ImmutableMapBehaviorSubject._(
    BehaviorSubject<ImmutableMap<K, V>>.seeded(
      ImmutableMap(seed),
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    ),
  );

  ImmutableMapBehaviorSubject._(this._subject) : super(_subject);

  final BehaviorSubject<ImmutableMap<K, V>> _subject;

  /// A read-only view of the underlying stream.
  Stream<ImmutableMap<K, V>> get stream => _subject.stream;

  /// The most recently emitted value.
  ImmutableMap<K, V> get value => _subject.value;

  /// Sets and emits the new [value].
  set value(Map<K, V> value) => add(value);

  @override
  void add(Map<K, V> value) => _subject.add(ImmutableMap(value));

  /// Adds [value] to the subject. Does nothing if the subject is closed.
  void safeAdd(Map<K, V> value) => _subject.safeAdd(ImmutableMap(value));

  @override
  Future<void> close() => _subject.close();
}

/// A [Stream] of lists that guarantees every emitted value is immutable.
///
/// The stream is a broadcast stream — multiple subscribers can listen at
/// once. Subscribers receive snapshots that throw `UnsupportedError` on
/// mutation. Callers pass plain lists to [add] / [safeAdd] — wrapping is
/// automatic and unbypassable.
///
/// ```dart
/// final controller = ImmutableListBehaviorSubject<Location>.seeded(const []);
///
/// controller.listen(print);
/// controller.safeAdd([userLocation]);
///
/// // Reads succeed.
/// final first = controller.value.first;
///
/// // Writes throw `UnsupportedError`.
/// controller.value.add(otherLocation);
/// ```
///
/// See also:
///
///  * [ImmutableMapBehaviorSubject], the map counterpart.
@internal
class ImmutableListBehaviorSubject<E> extends StreamView<ImmutableList<E>> implements Sink<List<E>> {
  /// Creates a subject with no initial value.
  ///
  /// [onListen], [onCancel] and [sync] follow [StreamController.broadcast]
  /// semantics.
  factory ImmutableListBehaviorSubject({
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) => ImmutableListBehaviorSubject._(
    BehaviorSubject<ImmutableList<E>>(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    ),
  );

  /// Creates a subject with [seed] as the initial value.
  ///
  /// Subscribers connecting before the first [add] also receive [seed].
  ///
  /// [onListen], [onCancel] and [sync] follow [StreamController.broadcast]
  /// semantics.
  factory ImmutableListBehaviorSubject.seeded(
    List<E> seed, {
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) => ImmutableListBehaviorSubject._(
    BehaviorSubject<ImmutableList<E>>.seeded(
      ImmutableList(seed),
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    ),
  );

  ImmutableListBehaviorSubject._(this._subject) : super(_subject);

  final BehaviorSubject<ImmutableList<E>> _subject;

  /// A read-only view of the underlying stream.
  Stream<ImmutableList<E>> get stream => _subject.stream;

  /// The most recently emitted value.
  ImmutableList<E> get value => _subject.value;

  /// Sets and emits the new [value].
  set value(List<E> value) => add(value);

  @override
  void add(List<E> value) => _subject.add(ImmutableList(value));

  /// Adds [value] to the subject. Does nothing if the subject is closed.
  void safeAdd(List<E> value) => _subject.safeAdd(ImmutableList(value));

  @override
  Future<void> close() => _subject.close();
}
