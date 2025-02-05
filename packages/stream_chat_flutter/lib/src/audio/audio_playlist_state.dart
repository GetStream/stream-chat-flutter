import 'dart:math' as math;

import 'package:collection/collection.dart';

/// {@template playlistLoopMode}
/// Represents the loop mode of a playlist.
/// {@endtemplate}
enum PlaylistLoopMode {
  /// The playlist will not loop.
  off,

  /// The playlist will loop all tracks.
  all,

  /// The playlist will loop the current track.
  one,
}

/// {@template audioPlaylistState}
/// Represents the current state of an audio playlist.
/// {@endtemplate}
class AudioPlaylistState {
  /// {@macro audioPlaylistState}
  const AudioPlaylistState({
    required this.tracks,
    this.currentIndex,
    this.speed = PlaybackSpeed.regular,
    this.loopMode = PlaylistLoopMode.off,
  });

  /// The list of tracks in the playlist.
  final List<PlaylistTrack> tracks;

  /// The index of the current track being played in the playlist.
  ///
  /// Defaults to `null`.
  final int? currentIndex;

  /// The current playback speed of the playlist.
  final PlaybackSpeed speed;

  /// The current loop mode of the playlist.
  final PlaylistLoopMode loopMode;

  /// Creates a copy of this [AudioPlaylistState] but with the given fields
  /// replaced by the new values.
  AudioPlaylistState copyWith({
    List<PlaylistTrack>? tracks,
    int? currentIndex,
    PlaybackSpeed? speed,
    PlaylistLoopMode? loopMode,
  }) {
    return AudioPlaylistState(
      tracks: tracks ?? this.tracks,
      currentIndex: currentIndex ?? this.currentIndex,
      speed: speed ?? this.speed,
      loopMode: loopMode ?? this.loopMode,
    );
  }

  @override
  int get hashCode => Object.hash(tracks, currentIndex, speed, loopMode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioPlaylistState &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(tracks, other.tracks) &&
          currentIndex == other.currentIndex &&
          speed == other.speed &&
          loopMode == other.loopMode;
}

/// {@template trackState}
/// Represents the current state of a track.
/// {@endtemplate}
enum TrackState {
  /// The track has not been loaded yet.
  idle,

  /// The track is currently being loaded.
  loading,

  /// The track is currently playing.
  playing,

  /// The track is currently paused.
  paused;

  /// Returns `true` if the track is currently idle.
  bool get isIdle => this == TrackState.idle;

  /// Returns `true` if the track is currently loading.
  bool get isLoading => this == TrackState.loading;

  /// Returns `true` if the track is currently playing.
  bool get isPlaying => this == TrackState.playing;

  /// Returns `true` if the track is currently paused.
  bool get isPaused => this == TrackState.paused;
}

/// {@template playbackSpeed}
/// Represents the speed of a track.
/// {@endtemplate}
enum PlaybackSpeed {
  /// The regular speed of the playback (1x).
  regular._(1),

  /// A faster speed of the playback (1.5x).
  faster._(1.5),

  /// The fastest speed of the playback (2x).
  fastest._(2);

  const PlaybackSpeed._(this.speed);

  /// Creates a [PlaybackSpeed] from the given value.
  factory PlaybackSpeed.fromValue(double speed) {
    return PlaybackSpeed.values.firstWhere(
      (it) => it.speed == speed,
      orElse: () => PlaybackSpeed.regular,
    );
  }

  /// The speed of the playback.
  final double speed;
}

/// Helper extension for [PlaybackSpeed].
extension StreamAudioPlayerExtension on PlaybackSpeed {
  /// Returns the next [PlaybackSpeed] value.
  PlaybackSpeed get next {
    return switch (this) {
      PlaybackSpeed.regular => PlaybackSpeed.faster,
      PlaybackSpeed.faster => PlaybackSpeed.fastest,
      PlaybackSpeed.fastest => PlaybackSpeed.regular,
    };
  }
}

/// {@template playlistTrack}
/// Represents a track in a playlist.
/// {@endtemplate}
class PlaylistTrack {
  /// {@macro playlistTrack}
  const PlaylistTrack({
    required this.uri,
    this.title,
    this.waveform = const [],
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.state = TrackState.idle,
  });

  /// The uri of the track.
  final Uri uri;

  /// The title of the track.
  final String? title;

  /// The waveform of the track.
  ///
  /// Defaults to an empty list.
  final List<double> waveform;

  /// The total duration of the track.
  ///
  /// Defaults to `Duration.zero`.
  final Duration duration;

  /// The current playback position of the track.
  ///
  /// Defaults to `Duration.zero`.
  final Duration position;

  /// The current state of the track.
  final TrackState state;

  /// The current progress of the track.
  double get progress {
    final position = this.position.inMicroseconds;
    if (position == 0) return 0;

    final duration = this.duration.inMicroseconds;
    if (duration == 0) return 0;

    return math.min(position / duration, 1);
  }

  /// Creates a copy of this [PlaylistTrack] but with the given fields replaced
  /// by the new values.
  PlaylistTrack copyWith({
    Uri? uri,
    String? title,
    Duration? duration,
    List<double>? waveform,
    Duration? position,
    TrackState? state,
  }) {
    return PlaylistTrack(
      uri: uri ?? this.uri,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      waveform: waveform ?? this.waveform,
      position: position ?? this.position,
      state: state ?? this.state,
    );
  }

  @override
  int get hashCode {
    return Object.hash(uri, title, duration, waveform, position, state);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistTrack &&
          runtimeType == other.runtimeType &&
          uri == other.uri &&
          title == other.title &&
          duration == other.duration &&
          waveform == other.waveform &&
          position == other.position &&
          state == other.state;
}
