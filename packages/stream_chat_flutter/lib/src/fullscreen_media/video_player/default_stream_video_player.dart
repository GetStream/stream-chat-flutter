import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The default `chewie`/`video_player`-backed implementation of
/// [StreamVideoPlayer].
///
/// Initializes its own [VideoPackage] lazily once built, and pauses itself
/// when the enclosing gallery swipes away from this page, resuming on
/// return if the user had it playing before.
///
/// Note: `video_player` has no Windows or Linux implementation, so on
/// those platforms this widget shows an error placeholder unless the app
/// overrides [StreamChatConfigurationData.videoPlayer] with a player that
/// supports desktop playback (e.g. via `media_kit`).
///
/// Routed to internally by [StreamVideoPlayer]; you generally don't need
/// to construct this directly.
class DefaultStreamVideoPlayer extends StatefulWidget {
  /// Creates a [DefaultStreamVideoPlayer].
  const DefaultStreamVideoPlayer({super.key, required this.props});

  /// The properties that configure this video player.
  final StreamVideoPlayerProps props;

  /// The video attachment to play.
  Attachment get attachment => props.attachment;

  /// The 0-based index of this page in the enclosing
  /// `StreamFullScreenMedia`.
  int get pageIndex => props.pageIndex;

  /// Whether playback should auto-start when this page first becomes
  /// active.
  bool get autoplay => props.autoplay;

  @override
  State<DefaultStreamVideoPlayer> createState() =>
      _DefaultStreamVideoPlayerState();
}

class _DefaultStreamVideoPlayerState extends State<DefaultStreamVideoPlayer>
    with
        StreamVideoPlayerActivityMixin<DefaultStreamVideoPlayer>,
        AutomaticKeepAliveClientMixin<DefaultStreamVideoPlayer> {
  VideoPackage? _package;
  Object? _error;

  @override
  int get pageIndex => widget.pageIndex;

  @override
  bool get autoplay => widget.autoplay;

  @override
  bool get isPlayerReady => _package?.initialized ?? false;

  @override
  bool get isPlaying => _package?.videoPlayer.value.isPlaying ?? false;

  @override
  void play() => _package?.chewieController?.play();

  @override
  void pause() => _package?.chewieController?.pause();

  // Keep the page mounted in the enclosing PageView once the controller is
  // ready, so swiping away and back doesn't re-initialise and replay the
  // loading spinner.
  @override
  bool get wantKeepAlive => isPlayerReady;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final package = VideoPackage(widget.attachment, showControls: true);
    _package = package;
    try {
      await package.initialize();
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
    _package?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_error != null) {
      return Center(
        child: Icon(
          Icons.error_outline_rounded,
          size: 48,
          color: StreamChatTheme.of(context).colorTheme.disabled,
        ),
      );
    }

    final chewieController = _package?.chewieController;
    if (chewieController == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return Chewie(controller: chewieController);
  }
}
