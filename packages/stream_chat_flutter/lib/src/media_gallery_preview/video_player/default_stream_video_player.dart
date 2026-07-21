import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

/// Video player used on Android, iOS, macOS, and web inside a
/// [StreamMediaGalleryPreview].
///
/// Pauses itself when the enclosing preview swipes away from this page
/// and resumes on return if the user had it playing before.
///
/// Routed to internally by [StreamVideoPlayer]; you generally don't need
/// to construct this directly.
class DefaultStreamVideoPlayer extends StatefulWidget {
  /// Creates a [DefaultStreamVideoPlayer].
  const DefaultStreamVideoPlayer({
    super.key,
    required this.props,
  });

  /// The properties that configure this video player.
  final StreamVideoPlayerProps props;

  /// The video attachment to play.
  Attachment get attachment => props.attachment;

  /// The 0-based index of this page in the enclosing
  /// [StreamMediaGalleryPreview].
  int get pageIndex => props.pageIndex;

  /// Whether playback should auto-start when this page first becomes
  /// active.
  bool get autoplay => props.autoplay;

  @override
  State<DefaultStreamVideoPlayer> createState() => _StreamVideoPlayerDefaultState();
}

class _StreamVideoPlayerDefaultState extends State<DefaultStreamVideoPlayer>
    with
        StreamVideoPlayerActivityMixin<DefaultStreamVideoPlayer>,
        AutomaticKeepAliveClientMixin<DefaultStreamVideoPlayer> {
  final _player = _ChewieVideoPlayer();
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
    if (_player.controller case final controller?) return Chewie(controller: controller);
    return const Center(child: StreamScrollViewLoadingWidget());
  }
}

/// Holds the [VideoPlayerController] / [ChewieController] pair so the
/// state class doesn't have to coordinate them inline.
///
/// [controller] is the public ready signal — non-null once [open]
/// resolves successfully, null while loading or after [dispose].
class _ChewieVideoPlayer {
  VideoPlayerController? _video;
  ChewieController? _chewie;

  /// The chewie controller used for playback once initialisation has
  /// completed. `null` until [open] resolves.
  ChewieController? get controller => _chewie;

  /// Whether the underlying video player is ready for playback.
  bool get isReady => _chewie != null;

  /// Whether the underlying video player is currently playing.
  bool get isPlaying => _video?.value.isPlaying ?? false;

  /// Initialises the controller pair for [attachment]. Throws when there
  /// is no usable source URL.
  Future<void> open(Attachment attachment) async {
    final localUri = attachment.localUri;
    final assetUrl = attachment.assetUrl;
    if (localUri == null && assetUrl == null) {
      throw StateError('No video source on attachment ${attachment.id}');
    }

    // Local files take precedence over the network asset; on web the
    // local branch is unreachable since `localUri` is always null there.
    final video = localUri != null
        ? VideoPlayerController.file(File.fromUri(localUri))
        : VideoPlayerController.networkUrl(Uri.parse(assetUrl!));
    _video = video;
    await video.initialize();
    _chewie = ChewieController(
      videoPlayerController: video,
      autoInitialize: true,
      aspectRatio: video.value.aspectRatio,
    );
  }

  /// Starts playback. No-op if not yet ready.
  void play() => _chewie?.play();

  /// Pauses playback. No-op if not yet ready.
  void pause() => _chewie?.pause();

  /// Releases both controllers.
  void dispose() {
    _chewie?.dispose();
    _video?.dispose();
  }
}
