import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/media_gallery_preview/video_player/default_stream_video_player.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Plays a chat video attachment inside a [StreamMediaGalleryPreview].
///
/// Hosts a platform-appropriate playback backend behind a single widget;
/// the player pauses itself when its page is no longer the active one in
/// the enclosing preview, and resumes if the user had it playing before
/// (or on first activation when [autoplay] is true).
///
/// Must be hosted inside a [StreamMediaGalleryPreview] — playback relies
/// on the preview to know which page is currently visible.
///
/// {@tool snippet}
///
/// Wire from a custom preview item builder:
///
/// ```dart
/// StreamVideoPlayer(
///   attachment: attachment,
///   pageIndex: index,
///   autoplay: true,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamVideoPlayerProps], which configures this widget.
///  * [DefaultStreamVideoPlayer], the default implementation.
///  * [StreamMediaGalleryPreview], the host viewer this widget plays into.
///  * [StreamMediaGalleryPreviewItem], which routes video attachments here.
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
    final builder = context.chatComponentBuilder<StreamVideoPlayerProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamVideoPlayer(props: props);
  }
}

/// Properties for configuring a [StreamVideoPlayer].
///
/// This class holds all the configuration options for a video player,
/// allowing them to be passed through the [StreamComponentFactory].
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
  /// [StreamMediaGalleryPreview].
  ///
  /// Forwarded to the backend so it can compare against the gallery's
  /// active index and pause when off-screen.
  final int pageIndex;

  /// Whether playback should auto-start the first time this page becomes
  /// active. Already-paused-by-user state is preserved on re-activation.
  final bool autoplay;
}
