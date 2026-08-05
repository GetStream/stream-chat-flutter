import 'dart:async';

import 'package:stream_chat/src/core/models/location.dart';

/// {@template liveLocationExpirationScheduler}
/// Schedules a one-shot [Timer] per live [Location] that fires once at the
/// location's `endAt`, invoking [onExpired] for that location.
///
/// Timers are keyed by message id and only (re)scheduled when a location's
/// `endAt` changes, so coordinate-only updates leave the existing timers
/// untouched.
/// {@endtemplate}
class LiveLocationExpirationScheduler {
  /// {@macro liveLocationExpirationScheduler}
  LiveLocationExpirationScheduler({required this.onExpired});

  /// Called once when a scheduled live location reaches its `endAt`.
  final void Function(Location location) onExpired;

  // The currently running expiry timers, keyed by message id.
  final _scheduledTimers = <String, _ScheduledExpiration>{};

  /// Reconciles the running expiry timers with the given live [locations].
  ///
  /// Timers for locations that are no longer present are cancelled; the rest
  /// are reused when their `endAt` is unchanged (refreshing the coordinates) or
  /// (re)armed when new or when their `endAt` changed.
  void schedule(Iterable<Location> locations) {
    // The live locations that should have an expiry timer, keyed by message id.
    final locationsToSchedule = <String, Location>{
      for (final location in locations)
        if (_shouldSchedule(location)) location.messageId!: location,
    };

    _cancelTimersForRemovedLocations(locationsToSchedule);
    for (final entry in locationsToSchedule.entries) {
      _reuseOrRescheduleTimer(entry.key, entry.value);
    }
  }

  /// Cancels all scheduled expiry timers.
  void cancel() {
    for (final scheduled in _scheduledTimers.values) {
      scheduled.timer.cancel();
    }
    _scheduledTimers.clear();
  }

  // Whether the [location] is a live location that should get an expiry timer.
  bool _shouldSchedule(Location location) {
    return location.messageId != null && location.endAt != null && !location.isExpired;
  }

  // Cancels the timers of locations that are no longer scheduled.
  void _cancelTimersForRemovedLocations(
    Map<String, Location> locationsToSchedule,
  ) {
    _scheduledTimers.removeWhere((messageId, scheduled) {
      if (locationsToSchedule.containsKey(messageId)) return false;
      scheduled.timer.cancel();
      return true;
    });
  }

  // Reuses the existing timer when the [location]'s expiry time is unchanged,
  // otherwise cancels the stale timer and arms a fresh one.
  void _reuseOrRescheduleTimer(String messageId, Location location) {
    final scheduled = _scheduledTimers[messageId];

    // Same expiry time: keep the timer, just refresh the coordinates so an
    // expiry reports the latest position.
    if (scheduled != null && !_endAtChanged(location, scheduled)) {
      scheduled.location = location;
      return;
    }

    // New location, or its expiry time changed: arm a fresh timer.
    scheduled?.timer.cancel();
    _scheduledTimers[messageId] = _ScheduledExpiration(
      location,
      _createTimer(messageId, location.endAt!),
    );
  }

  // Whether the [location]'s `endAt` differs from the one currently scheduled.
  bool _endAtChanged(Location location, _ScheduledExpiration scheduled) {
    return location.endAt != scheduled.location.endAt;
  }

  Timer _createTimer(String messageId, DateTime endAt) {
    final delay = endAt.difference(DateTime.now());
    return Timer(
      delay.isNegative ? Duration.zero : delay,
      () => _onTimerFired(messageId),
    );
  }

  void _onTimerFired(String messageId) {
    final scheduled = _scheduledTimers[messageId];
    if (scheduled == null) return;

    final location = scheduled.location;
    // Re-check against the current clock; re-arm rather than fire if it isn't
    // actually expired yet (e.g. the clock moved back or `endAt` was extended).
    if (!location.isExpired) {
      scheduled.timer = _createTimer(messageId, location.endAt!);
      return;
    }

    _scheduledTimers.remove(messageId);
    onExpired(location);
  }
}

class _ScheduledExpiration {
  _ScheduledExpiration(this.location, this.timer);

  Location location;
  Timer timer;
}
