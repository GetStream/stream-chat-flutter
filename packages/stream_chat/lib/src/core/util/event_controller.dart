import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/core/models/event.dart';

/// A function that inspects an event and optionally resolves it into a
/// more specific or refined version of the same type.
///
/// If the resolver does not recognize or handle the event,
/// it returns `null`, allowing other resolvers to attempt resolution.
typedef EventResolver<T extends Event> = T? Function(T event);

/// {@template eventController}
/// A reactive event stream controller for [Event]s that supports conditional
/// resolution before emitting events to subscribers.
///
/// When an event is added:
/// - Each resolver is evaluated in order.
/// - The first resolver that returns a non-null result is used to produce
///   the resolved event that gets emitted.
/// - If no resolver returns a result, the original event is emitted unchanged.
///
/// This is useful for normalizing or refining generic events into more
/// specific ones (e.g. rewriting `pollVoteCasted` into `pollAnswerCasted`)
/// before they reach business logic or state layers.
/// {@endtemplate}
class EventController<T extends Event> extends Subject<T> {
  /// {@macro eventController}
  factory EventController({
    bool sync = false,
    void Function()? onListen,
    void Function()? onCancel,
    List<EventResolver<T>> resolvers = const [],
  }) {
    // ignore: close_sinks
    final controller = StreamController<T>.broadcast(
      sync: sync,
      onListen: onListen,
      onCancel: onCancel,
    );

    return EventController<T>._(
      controller,
      controller.stream,
      resolvers,
    );
  }

  EventController._(
    super.controller,
    super.stream,
    this._resolvers,
  );

  /// The list of resolvers used to inspect and optionally resolve events
  /// before they are emitted.
  ///
  /// Resolvers are evaluated in order. The first to return a non-null result
  /// determines the event that will be emitted. If none apply, the original
  /// event is emitted as-is.
  final List<EventResolver<T>> _resolvers;

  /// Adds an [event] to the stream.
  ///
  /// Each [EventResolver] is applied in order until one returns a non-null
  /// result. That resolved event is emitted, and no further resolvers are
  /// evaluated. If all resolvers return `null`, the original event is emitted.
  @override
  void add(T event) {
    for (final resolver in _resolvers) {
      final result = resolver(event);
      if (result != null) return super.add(result);
    }

    // No resolver matched — emit the event as-is.
    return super.add(event);
  }
}
