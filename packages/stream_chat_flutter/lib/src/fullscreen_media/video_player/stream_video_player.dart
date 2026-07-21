import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Plays a chat video attachment inside a `StreamFullScreenMedia` gallery.
///
/// Renders whatever [StreamChatConfigurationData.videoPlayer] returns for
/// [props], falling back to [DefaultStreamVideoPlayer] (`chewie` /
/// `video_player`) when no override is configured or the override returns
/// `null`.
///
/// `video_player` doesn't support Windows or Linux, so apps that need
/// video playback on those platforms should override
/// [StreamChatConfigurationData.videoPlayer], e.g. with a `media_kit`-based
/// player:
///
/// ```dart
/// StreamChat(
///   client: client,
///   streamChatConfigData: StreamChatConfigurationData(
///     videoPlayer: (context, props) {
///       if (kIsWeb || !isDesktopVideoPlayerSupported) return null;
///       return MyMediaKitVideoPlayer(props: props);
///     },
///   ),
///   child: ...,
/// )
/// ```
///
/// See also:
///
///  * [StreamVideoPlayerProps], which configures this widget.
///  * [DefaultStreamVideoPlayer], the default implementation.
///  * [StreamFullScreenMedia], the host viewer this widget plays into.
class StreamVideoPlayer extends StatelessWidget {
  /// Creates a [StreamVideoPlayer].
  StreamVideoPlayer({
    super.key,
    required Attachment attachment,
    required int pageIndex,
    bool autoplay = false,
  }) : props = StreamVideoPlayerProps(
          attachment: attachment,
          pageIndex: pageIndex,
          autoplay: autoplay,
        );

  /// The properties that configure this video player.
  final StreamVideoPlayerProps props;

  @override
  Widget build(BuildContext context) {
    final builder = StreamChatConfiguration.of(context).videoPlayer;
    final override = builder?.call(context, props);
    if (override != null) return override;
    return DefaultStreamVideoPlayer(props: props);
  }
}
