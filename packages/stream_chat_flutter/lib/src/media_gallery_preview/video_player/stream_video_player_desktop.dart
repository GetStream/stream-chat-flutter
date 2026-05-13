import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:stream_chat_flutter/src/media_gallery_preview/video_player/stream_video_player_activity_mixin.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Video player used on Linux and Windows inside a
/// [StreamMediaGalleryPreview].
///
/// Pauses itself when the enclosing preview swipes away from this page
/// and resumes on return if the user had it playing before.
///
/// Routed to internally by [StreamVideoPlayer]; you generally don't need
/// to construct this directly.
class StreamVideoPlayerDesktop extends StatefulWidget {
  /// Creates a [StreamVideoPlayerDesktop].
  const StreamVideoPlayerDesktop({
    super.key,
    required this.attachment,
    required this.pageIndex,
    this.autoplay = false,
  });

  /// The video attachment to play.
  final Attachment attachment;

  /// The 0-based index of this page in the enclosing
  /// [StreamMediaGalleryPreview].
  final int pageIndex;

  /// Whether playback should auto-start when this page first becomes
  /// active.
  final bool autoplay;

  @override
  State<StreamVideoPlayerDesktop> createState() => _StreamVideoPlayerDesktopState();
}

class _StreamVideoPlayerDesktopState extends State<StreamVideoPlayerDesktop>
    with
        StreamVideoPlayerActivityMixin<StreamVideoPlayerDesktop>,
        AutomaticKeepAliveClientMixin<StreamVideoPlayerDesktop> {
  final _player = _MediaKitVideoPlayer();
  Object? _error;

  @override
  int get pageIndex => widget.pageIndex;

  @override
  bool get autoplay => widget.autoplay;

  @override
  bool get isPlayerReady => _player.isReady;

  @override
  bool get isPlaying => _player.isPlaying;

  @override
  void play() => _player.play();

  @override
  void pause() => _player.pause();

  // Keep the page mounted in the enclosing PageView once the controller is
  // ready, so swiping away and back doesn't re-initialise and replay the
  // loading spinner.
  @override
  bool get wantKeepAlive => _player.isReady;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _player.open(widget.attachment);
      if (!mounted) return;
      setState(() {});
      updateKeepAlive();
      syncPlayState();
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_error != null) return const Center(child: StreamImageErrorPlaceholder());
    if (_player.controller case final controller?) return Video(controller: controller);
    return const Center(child: StreamScrollViewLoadingWidget());
  }
}

/// Holds the [Player] / [VideoController] pair so the state class doesn't
/// have to coordinate them inline.
///
/// [controller] is the public ready signal — non-null once [open]
/// resolves successfully, null while loading or after [dispose].
class _MediaKitVideoPlayer {
  Player? _player;
  VideoController? _controller;

  /// The video controller used for rendering once initialisation has
  /// completed. `null` until [open] resolves.
  VideoController? get controller => _controller;

  /// Whether the underlying media player is ready for playback.
  bool get isReady => _controller != null;

  /// Whether the underlying media player is currently playing.
  bool get isPlaying => _player?.state.playing ?? false;

  /// Initialises the player for [attachment]. Throws when there is no
  /// usable source URL.
  Future<void> open(Attachment attachment) async {
    final assetUrl = attachment.assetUrl;
    if (assetUrl == null) {
      throw StateError('No video source on attachment ${attachment.id}');
    }

    final player = Player();
    _player = player;
    final controller = VideoController(player);
    await player.open(Media(assetUrl), play: false);
    _controller = controller;
  }

  /// Starts playback. No-op if not yet ready.
  void play() => _player?.play();

  /// Pauses playback. No-op if not yet ready.
  void pause() => _player?.pause();

  /// Releases the player.
  void dispose() => _player?.dispose();
}
