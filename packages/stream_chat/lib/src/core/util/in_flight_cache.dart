import 'dart:async';

/// Coalesces concurrent identical async calls by sharing a single in-flight
/// [Future] keyed by [K].
///
/// When [run] is called and no [Future] is in flight for [key], the [work]
/// closure runs and its [Future] is cached. Concurrent callers passing the
/// same [key] receive the cached [Future] and share its eventual outcome —
/// both success and failure. Sequential callers arriving after the [Future]
/// settles see an empty cache and start fresh.
///
/// Sharing failures is intentional: falling through to a fresh call on
/// error would defeat the dedup precisely when it matters most (e.g., a
/// rate-limit storm), turning one rejected request into N.
///
/// Mirrors the `DistinctChatApi` / `DistinctCall` design used across the
/// Android Stream Chat SDK.
class InFlightCache<K, V> {
  final _inFlight = <K, Future<V>>{};

  /// Returns the in-flight [Future] for [key] if one exists, otherwise runs
  /// [work], caches its [Future], and frees the slot when it settles.
  Future<V> run(K key, Future<V> Function() work) {
    if (_inFlight[key] case final existing?) return existing;

    // [Future.sync] runs [work] synchronously on the current microtask and
    // wraps any synchronous throw in a rejected [Future] — so concurrent
    // callers in the same tick share the same single invocation.
    final future = Future.sync(work);
    _inFlight[key] = future;

    // The cleanup chain runs regardless of outcome. The trailing [ignore]
    // silences unhandled-error reporting on the chained future since
    // [whenComplete] forwards the original error rather than handling it.
    future.whenComplete(() => _inFlight.remove(key)).ignore();

    return future;
  }
}
