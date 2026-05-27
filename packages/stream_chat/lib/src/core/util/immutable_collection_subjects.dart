import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/core/util/extension.dart';

/// A [ValueStream] of maps that guarantees every emitted value is immutable.
///
/// Subscribers receive snapshots that throw `UnsupportedError` on mutation.
/// Callers pass plain maps to [add] / [safeAdd] — the wrap is handled here
/// so it cannot be forgotten or bypassed.
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
class ImmutableMapBehaviorSubject<K, V> extends StreamView<Map<K, V>>
    implements ValueStream<Map<K, V>>, Sink<Map<K, V>> {
  /// Creates an [ImmutableMapBehaviorSubject] with no initial value.
  ///
  /// See [StreamController.broadcast] for [onListen], [onCancel] and [sync].
  factory ImmutableMapBehaviorSubject({
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) => ImmutableMapBehaviorSubject._(
    BehaviorSubject<UnmodifiableMapView<K, V>>(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    ),
  );

  /// Creates the subject with [seed] as the initial value.
  ///
  /// Subscribers connecting before the first [add] also receive [seed].
  ///
  /// See [StreamController.broadcast] for [onListen], [onCancel] and [sync].
  factory ImmutableMapBehaviorSubject.seeded(
    Map<K, V> seed, {
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) => ImmutableMapBehaviorSubject._(
    BehaviorSubject<UnmodifiableMapView<K, V>>.seeded(
      UnmodifiableMapView(seed),
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    ),
  );

  ImmutableMapBehaviorSubject._(this._subject) : super(_subject);

  final BehaviorSubject<UnmodifiableMapView<K, V>> _subject;

  /// A read-only view of the underlying stream.
  ValueStream<Map<K, V>> get stream => _subject.stream;

  @override
  Map<K, V> get value => _subject.value;

  /// Sets and emits the new [value].
  set value(Map<K, V> value) => add(value);

  @override
  Map<K, V>? get valueOrNull => _subject.valueOrNull;

  @override
  bool get hasValue => _subject.hasValue;

  @override
  Object get error => _subject.error;

  @override
  Object? get errorOrNull => _subject.errorOrNull;

  @override
  bool get hasError => _subject.hasError;

  @override
  StackTrace? get stackTrace => _subject.stackTrace;

  @override
  StreamNotification<Map<K, V>>? get lastEventOrNull => _subject.lastEventOrNull;

  @override
  void add(Map<K, V> value) => _subject.add(UnmodifiableMapView(value));

  /// Adds [value] to the subject. Does nothing if the subject is closed.
  void safeAdd(Map<K, V> value) => _subject.safeAdd(UnmodifiableMapView(value));

  @override
  Future<void> close() => _subject.close();
}

/// A [ValueStream] of lists that guarantees every emitted value is immutable.
///
/// Subscribers receive snapshots that throw `UnsupportedError` on mutation.
/// Callers pass plain lists to [add] / [safeAdd] — the wrap is handled here
/// so it cannot be forgotten or bypassed.
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
class ImmutableListBehaviorSubject<E> extends StreamView<List<E>> implements ValueStream<List<E>>, Sink<List<E>> {
  /// Creates an [ImmutableListBehaviorSubject] with no initial value.
  ///
  /// See [StreamController.broadcast] for [onListen], [onCancel] and [sync].
  factory ImmutableListBehaviorSubject({
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) => ImmutableListBehaviorSubject._(
    BehaviorSubject<UnmodifiableListView<E>>(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    ),
  );

  /// Creates the subject with [seed] as the initial value.
  ///
  /// Subscribers connecting before the first [add] also receive [seed].
  ///
  /// See [StreamController.broadcast] for [onListen], [onCancel] and [sync].
  factory ImmutableListBehaviorSubject.seeded(
    List<E> seed, {
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) => ImmutableListBehaviorSubject._(
    BehaviorSubject<UnmodifiableListView<E>>.seeded(
      UnmodifiableListView(seed),
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    ),
  );

  ImmutableListBehaviorSubject._(this._subject) : super(_subject);

  final BehaviorSubject<UnmodifiableListView<E>> _subject;

  /// A read-only view of the underlying stream.
  ValueStream<List<E>> get stream => _subject.stream;

  @override
  List<E> get value => _subject.value;

  /// Sets and emits the new [value].
  set value(List<E> value) => add(value);

  @override
  List<E>? get valueOrNull => _subject.valueOrNull;

  @override
  bool get hasValue => _subject.hasValue;

  @override
  Object get error => _subject.error;

  @override
  Object? get errorOrNull => _subject.errorOrNull;

  @override
  bool get hasError => _subject.hasError;

  @override
  StackTrace? get stackTrace => _subject.stackTrace;

  @override
  StreamNotification<List<E>>? get lastEventOrNull => _subject.lastEventOrNull;

  @override
  void add(List<E> value) => _subject.add(UnmodifiableListView(value));

  /// Adds [value] to the subject. Does nothing if the subject is closed.
  void safeAdd(List<E> value) => _subject.safeAdd(UnmodifiableListView(value));

  @override
  Future<void> close() => _subject.close();
}
