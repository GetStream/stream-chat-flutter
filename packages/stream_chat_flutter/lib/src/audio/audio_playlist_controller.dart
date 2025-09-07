import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';

/// {@template streamAudioPlaylistController}
/// A controller for managing an audio playlist.
/// {@endtemplate}
class StreamAudioPlaylistController extends ValueNotifier<AudioPlaylistState> {
  /// {@macro streamAudioPlaylistController}
  factory StreamAudioPlaylistController(List<PlaylistTrack> tracks) {
    return StreamAudioPlaylistController.raw(
      state: AudioPlaylistState(tracks: tracks),
    );
  }

  /// {@macro streamAudioPlaylistController}
  @visibleForTesting
  StreamAudioPlaylistController.raw({
    AudioPlayer? player,
    AudioPlaylistState state = const AudioPlaylistState(tracks: []),
  })  : _player = player ?? AudioPlayer(),
        super(state);

  final AudioPlayer _player;

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<double>? _speedSubscription;

  /// Initializes the controller and starts listening to player state changes.
  Future<void> initialize() async {
    // Listen to player state changes
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      // Handle auto-advance when track completes
      if (state.playing && state.processingState == ProcessingState.completed) {
        return _onTrackComplete();
      }

      final currentIndex = value.currentIndex;
      if (currentIndex == null) return;

      final tracks = [
        ...value.tracks.mapIndexed((index, track) {
          final trackState = switch (index == currentIndex) {
            true => state.playing
                ? TrackState.playing
                : switch (state.processingState) {
                    ProcessingState.idle => TrackState.idle,
                    ProcessingState.loading => TrackState.loading,
                    _ => TrackState.paused,
                  },
            false => switch (track.state) {
                TrackState.idle => TrackState.idle,
                _ => TrackState.paused,
              },
          };

          return track.copyWith(state: trackState);
        })
      ];

      value = value.copyWith(tracks: tracks);
    });

    // Listen to position changes
    _positionSubscription = _player.positionStream.listen((position) {
      final currentIndex = value.currentIndex;
      if (currentIndex == null) return;

      final tracks = [
        ...value.tracks.mapIndexed((index, track) {
          if (index != currentIndex) return track;
          return track.copyWith(position: position);
        })
      ];

      value = value.copyWith(tracks: tracks);
    });

    // Listen to speed changes
    _speedSubscription = _player.speedStream.listen((speed) {
      value = value.copyWith(speed: PlaybackSpeed.fromValue(speed));
    });
  }

  void _onTrackComplete() async {
    final currentIndex = value.currentIndex;
    if (currentIndex == null) return;

    return pause().then((_) => seek(Duration.zero)).then((_) => skipToNext());
  }

  int? get _nextIndex => _getRelativeIndex(1);
  int? get _previousIndex => _getRelativeIndex(-1);
  int? _getRelativeIndex(int offset) {
    final currentIndex = value.currentIndex;
    if (currentIndex == null) return null;

    return switch (value.loopMode) {
      PlaylistLoopMode.one => currentIndex,
      PlaylistLoopMode.off => currentIndex + offset,
      PlaylistLoopMode.all => (currentIndex + offset) % value.tracks.length,
    };
  }

  /// Plays the current track.
  Future<void> play() => _player.play();

  /// Pauses the current track.
  Future<void> pause() => _player.pause();

  /// Stops the current track.
  Future<void> stop() => _player.stop();

  /// Sets the speed of the current track.
  Future<void> setSpeed(PlaybackSpeed speed) => _player.setSpeed(speed.speed);

  /// Seeks to the given position in the current track.
  Future<void> seek(Duration position) => _player.seek(position);

  /// Sets the loop mode of the playlist.
  Future<void> setLoopMode(PlaylistLoopMode loopMode) async {
    value = value.copyWith(loopMode: loopMode);
  }

  /// Plays the next track in the playlist.
  Future<void> skipToNext({Duration? position}) async {
    final index = _nextIndex;
    if (index == null) return;

    return skipToItem(index, position: position);
  }

  /// Plays the previous track in the playlist.
  Future<void> skipToPrevious({Duration? position}) async {
    final index = _previousIndex;
    if (index == null) return;

    return skipToItem(index, position: position);
  }

  /// Seeks to the given position in the current track in the playlist and
  /// resumes playing.
  Future<void> skipToItem(int index, {Duration? position}) async {
    final tracks = value.tracks;
    if (tracks.isEmpty) return;

    if (index < 0 || index >= tracks.length) return;
    value = value.copyWith(currentIndex: index);

    final track = tracks[index];
    final seekPosition = position ?? track.position;
    final audioSource = AudioSource.uri(track.uri);

    final duration = await _player.setAudioSource(
      audioSource,
      initialPosition: seekPosition,
    );

    value = value.copyWith(
      tracks: [
        ...tracks.mapIndexed((i, track) {
          if (i != index) return track;
          return track.copyWith(duration: duration);
        }),
      ],
    );

    return play();
  }

  /// Updates the playlist with the given tracks.
  ///
  /// Note: This will stop the player if it is currently playing.
  Future<void> updatePlaylist(List<PlaylistTrack> tracks) async {
    if (tracks.isEmpty) return; // No tracks to update

    unawaited(_player.stop());

    value = AudioPlaylistState(
      tracks: tracks,
      speed: value.speed,
      loopMode: value.loopMode,
    );
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _speedSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }
}
