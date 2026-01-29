import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_controller.dart';
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

class FakeAudioSource extends Fake implements AudioSource {}

void main() {
  group('StreamAudioPlaylistController', () {
    late MockAudioPlayer mockPlayer;
    late StreamAudioPlaylistController controller;
    late PublishSubject<PlayerState> stateController;
    late PublishSubject<Duration> positionController;
    late PublishSubject<double> speedController;

    final fakeTrack1 = PlaylistTrack(
      title: 'test1.m4a',
      uri: Uri.file('voice_recordings/test1.m4a'),
      waveform: List.filled(50, 0.5),
      duration: const Duration(seconds: 300),
    );

    final fakeTrack2 = PlaylistTrack(
      title: 'test2.m4a',
      uri: Uri.file('voice_recordings/test2.m4a'),
      waveform: List.filled(50, 0.5),
      duration: const Duration(seconds: 900),
    );

    Future<Duration?> _setAudioSource() {
      return mockPlayer.setAudioSource(
        any(),
        initialPosition: any(named: 'initialPosition'),
      );
    }

    setUpAll(() {
      registerFallbackValue(Duration.zero);
      registerFallbackValue(FakeAudioSource());
    });

    setUp(() {
      mockPlayer = MockAudioPlayer();
      when(() => mockPlayer.dispose()).thenAnswer((_) async {});

      stateController = PublishSubject<PlayerState>();
      positionController = PublishSubject<Duration>();
      speedController = PublishSubject<double>();

      // Default mock behaviors
      when(() => mockPlayer.playerStateStream).thenAnswer((_) => stateController.stream);
      when(() => mockPlayer.positionStream).thenAnswer((_) => positionController.stream);
      when(() => mockPlayer.speedStream).thenAnswer((_) => speedController.stream);

      controller = StreamAudioPlaylistController.raw(
        player: mockPlayer,
        state: AudioPlaylistState(tracks: [fakeTrack1, fakeTrack2]),
      )..initialize();
    });

    tearDown(() {
      stateController.close();
      positionController.close();
      speedController.close();
      controller.dispose();
    });

    test('controller initializes with correct default state', () {
      expect(controller.value.tracks.length, equals(2));
      expect(controller.value.currentIndex, isNull);
      expect(controller.value.speed, equals(PlaybackSpeed.regular));
      expect(controller.value.loopMode, equals(PlaylistLoopMode.off));
    });

    group('Track Navigation', () {
      test('skipToItem selects correct track', () async {
        when(_setAudioSource).thenAnswer((_) async => null);
        when(() => mockPlayer.play()).thenAnswer((_) async {});

        await controller.skipToItem(1);

        expect(controller.value.currentIndex, equals(1));
        verify(_setAudioSource).called(1);
        verify(() => mockPlayer.play()).called(1);
      });

      test('skipToNext cycles through tracks', () async {
        when(_setAudioSource).thenAnswer((_) async => null);
        when(() => mockPlayer.play()).thenAnswer((_) async {});

        await controller.skipToItem(0);
        await controller.skipToNext();

        expect(controller.value.currentIndex, equals(1));
        verify(_setAudioSource).called(2);
        verify(() => mockPlayer.play()).called(2);
      });

      test('skipToPrevious cycles through tracks', () async {
        when(_setAudioSource).thenAnswer((_) async => null);
        when(() => mockPlayer.play()).thenAnswer((_) async {});

        await controller.skipToItem(1);
        await controller.skipToPrevious();

        expect(controller.value.currentIndex, equals(0));
        verify(_setAudioSource).called(2);
        verify(() => mockPlayer.play()).called(2);
      });
    });

    group('Playlist Management', () {
      test('updatePlaylist replaces tracks', () async {
        when(() => mockPlayer.stop()).thenAnswer((_) async {});

        final newTracks = [
          PlaylistTrack(
            title: 'new-track.mp3',
            uri: Uri.parse('https://example.com/new-track.mp3'),
          ),
        ];

        await controller.updatePlaylist(newTracks);

        expect(controller.value.currentIndex, isNull);
        expect(controller.value.tracks, equals(newTracks));
        verify(() => mockPlayer.stop()).called(1);
      });

      test('setLoopMode updates playlist loop configuration', () async {
        await controller.setLoopMode(PlaylistLoopMode.all);
        expect(controller.value.loopMode, equals(PlaylistLoopMode.all));

        await controller.setLoopMode(PlaylistLoopMode.one);
        expect(controller.value.loopMode, equals(PlaylistLoopMode.one));

        await controller.setLoopMode(PlaylistLoopMode.off);
        expect(controller.value.loopMode, equals(PlaylistLoopMode.off));
      });
    });

    group('Playback Control', () {
      test('play invokes audio player', () async {
        when(() => mockPlayer.play()).thenAnswer((_) async {});

        await controller.play();

        verify(() => mockPlayer.play()).called(1);
      });

      test('pause stops playback', () async {
        when(() => mockPlayer.pause()).thenAnswer((_) async {});

        await controller.pause();

        verify(() => mockPlayer.pause()).called(1);
      });

      test('setSpeed changes playback rate', () async {
        when(() => mockPlayer.setSpeed(any())).thenAnswer((_) async {});

        const playbackSpeed = PlaybackSpeed.faster;
        await controller.setSpeed(playbackSpeed);

        verify(() => mockPlayer.setSpeed(playbackSpeed.speed)).called(1);
      });
    });

    group('Stream Interactions', () {
      setUp(() {
        when(_setAudioSource).thenAnswer((_) async => null);
        when(() => mockPlayer.play()).thenAnswer((_) async {});
        when(() => mockPlayer.pause()).thenAnswer((_) async {});
        when(() => mockPlayer.seek(any())).thenAnswer((_) async {});
      });

      test('playerStateStream updates track state', () async {
        await controller.skipToItem(0);

        // Simulate track idle
        stateController.add(PlayerState(false, ProcessingState.idle));
        await Future.delayed(Duration.zero);
        expect(controller.value.tracks[0].state, equals(TrackState.idle));

        // Simulate track loading
        stateController.add(PlayerState(false, ProcessingState.loading));
        await Future.delayed(Duration.zero);
        expect(controller.value.tracks[0].state, equals(TrackState.loading));

        // Simulate track paused
        stateController.add(PlayerState(false, ProcessingState.ready));
        await Future.delayed(Duration.zero);
        expect(controller.value.tracks[0].state, equals(TrackState.paused));

        // Simulate track playing
        stateController.add(PlayerState(true, ProcessingState.ready));
        await Future.delayed(Duration.zero);
        expect(controller.value.tracks[0].state, equals(TrackState.playing));
      });

      test('positionStream updates track position', () async {
        await controller.skipToItem(0);

        const testPosition = Duration(seconds: 30);
        positionController.add(testPosition);
        await Future.delayed(Duration.zero);

        expect(controller.value.tracks[0].position, equals(testPosition));
      });

      test('speedStream updates playback speed', () async {
        speedController.add(1.5);
        await Future.delayed(Duration.zero);
        expect(controller.value.speed, equals(PlaybackSpeed.faster));

        speedController.add(2);
        await Future.delayed(Duration.zero);
        expect(controller.value.speed, equals(PlaybackSpeed.fastest));

        speedController.add(1);
        await Future.delayed(Duration.zero);
        expect(controller.value.speed, equals(PlaybackSpeed.regular));
      });

      test('track completes and auto-advances', () async {
        await controller.skipToItem(0);

        // Simulate track completion
        stateController.add(PlayerState(true, ProcessingState.completed));
        await Future.delayed(Duration.zero);

        // Verify auto-advance occurs
        expect(controller.value.currentIndex, equals(1));
      });
    });
  });
}
