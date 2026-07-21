import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A `media_kit`-backed video player for [StreamVideoPlayerProps].
///
/// The SDK's default video player (`chewie`/`video_player`) has no Windows
/// or Linux implementation, so this app registers this player via
/// `StreamChatConfigurationData.videoPlayer` to support video playback on
/// desktop. See `app.dart` for the registration.
///
/// Like the SDK's `DefaultStreamVideoPlayer`, this pauses itself when the
/// enclosing `StreamFullScreenMedia` gallery swipes away from this page and
/// resumes on return if the user had it playing before.
class MediaKitVideoPlayer extends StatefulWidget {
  /// Creates a [MediaKitVideoPlayer].
  const MediaKitVideoPlayer({super.key, required this.props});

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
  State<MediaKitVideoPlayer> createState() => _MediaKitVideoPlayerState();
}

class _MediaKitVideoPlayerState extends State<MediaKitVideoPlayer>
    with
        StreamVideoPlayerActivityMixin<MediaKitVideoPlayer>,
        AutomaticKeepAliveClientMixin<MediaKitVideoPlayer> {
  late final _player = Player();
  late final _controller = VideoController(_player);
  Object? _error;
  bool _isReady = false;

  @override
  int get pageIndex => widget.pageIndex;

  @override
  bool get autoplay => widget.autoplay;

  @override
  bool get isPlayerReady => _isReady;

  @override
  bool get isPlaying => _player.state.playing;

  @override
  void play() => _player.play();

  @override
  void pause() => _player.pause();

  // Keep the page mounted in the enclosing PageView once the controller is
  // ready, so swiping away and back doesn't re-initialise the player.
  @override
  bool get wantKeepAlive => _isReady;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final url = widget.attachment.assetUrl;
    if (url == null) {
      setState(() => _error = StateError(
            'No video source on attachment ${widget.attachment.id}',
          ));
      return;
    }

    try {
      await _player.open(Media(url), play: false);
      if (!mounted) return;
      setState(() => _isReady = true);
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

    if (_error != null) {
      return Center(
        child: Icon(
          Icons.error_outline_rounded,
          size: 48,
          color: StreamChatTheme.of(context).colorTheme.disabled,
        ),
      );
    }

    if (!_isReady) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return Video(controller: _controller);
  }
}
