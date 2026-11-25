import 'package:meta/meta.dart';

/// Tells when playback has really started, from a player's updates.
///
/// Pressing play only asks the player to play: it may still be loading,
/// buffering or failing. Playback counts as started once the position moves
/// past where it was when play was pressed. A pause, or a switch to another
/// [key], starts the count again.
@internal
class PlaybackStartTracker {
  Object? _key;
  Duration? _startPosition;
  var _reported = false;

  /// Takes the player's latest state, and returns `true` once per start.
  ///
  /// [key] identifies what is playing, such as one recording in a playlist.
  bool update({
    required bool isPlaying,
    required Duration position,
    Object? key,
  }) {
    if (!isPlaying) {
      _startPosition = null;
      _reported = false;
      return false;
    }

    final startPosition = _startPosition;
    if (startPosition == null || key != _key) {
      _key = key;
      _startPosition = position;
      _reported = false;
      return false;
    }

    if (_reported || position <= startPosition) return false;
    return _reported = true;
  }
}
