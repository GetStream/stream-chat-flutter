import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Properties for configuring a [StreamVideoPlayer].
///
/// This class holds all the configuration options for a video player,
/// allowing them to be passed through
/// [StreamChatConfigurationData.videoPlayer].
///
/// See also:
///
///  * [StreamVideoPlayer], which uses these properties.
///  * [DefaultStreamVideoPlayer], the default implementation.
@immutable
class StreamVideoPlayerProps {
  /// Creates properties for a video player.
  const StreamVideoPlayerProps({
    required this.attachment,
    required this.pageIndex,
    this.autoplay = false,
  });

  /// The video attachment to play.
  final Attachment attachment;

  /// The 0-based index of this page in the enclosing
  /// [StreamFullScreenMedia].
  final int pageIndex;

  /// Whether playback should auto-start the first time this page becomes
  /// active. Already-paused-by-user state is preserved on re-activation.
  final bool autoplay;
}

/// Builds a custom video player for a video [Attachment].
///
/// Return `null` to fall back to the default video player
/// ([DefaultStreamVideoPlayer]).
///
/// Set via [StreamChatConfigurationData.videoPlayer] to override the video
/// player used inside [StreamFullScreenMedia], e.g. to plug in a
/// `media_kit`-based player on desktop platforms that `chewie` doesn't
/// support:
///
/// ```dart
/// StreamChatConfigurationData(
///   videoPlayer: (context, props) {
///     if (kIsWeb || !isDesktopVideoPlayerSupported) return null;
///     return MyMediaKitVideoPlayer(props: props);
///   },
/// )
/// ```
typedef StreamVideoPlayerBuilder = Widget? Function(
  BuildContext context,
  StreamVideoPlayerProps props,
);
