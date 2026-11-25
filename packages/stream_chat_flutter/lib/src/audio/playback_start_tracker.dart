import 'package:flutter/foundation.dart';

/// Tells when playback has really started, from a player's updates.
///
/// Pressing play only asks the player to play: it may still be loading,
/// buffering or failing. Playback counts as started once the position moves
/// past where it was when play was pressed, and [onStarted] is then called
/// once with the [handleUpdate] key. A pause, or a switch to another key,
/// starts the count again. Playback that never moves, such as an empty clip
/// or a resume at the very end, is never reported.
@internal
class PlaybackStartTracker {
  /// Creates a tracker that calls [onStarted] each time playback starts.
  PlaybackStartTracker({required this.onStarted});

  /// Called with the key of what started playing.
  final ValueChanged<Object?> onStarted;

  Object? _key;
  Duration? _startPosition;
  var _reported = false;

  /// Takes the player's latest state.
  ///
  /// [key] identifies what is playing, such as one recording in a playlist.
  void handleUpdate({
    required bool isPlaying,
    required Duration position,
    Object? key,
  }) {
    if (!isPlaying) {
      _key = null;
      _startPosition = null;
      _reported = false;
      return;
    }

    final startPosition = _startPosition;
    if (startPosition == null || key != _key) {
      _key = key;
      _startPosition = position;
      _reported = false;
      return;
    }

    if (_reported || position <= startPosition) return;
    _reported = true;
    onStarted(key);
  }
}
