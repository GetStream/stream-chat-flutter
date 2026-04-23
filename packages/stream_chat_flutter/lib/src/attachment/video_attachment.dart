import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A video attachment component with a play indicator.
///
/// [StreamVideoAttachment] displays a video attachment with a visual
/// indicator that it can be played.
///
/// {@tool snippet}
///
/// Basic usage:
///
/// ```dart
/// StreamVideoAttachment(
///   message: message,
///   video: videoAttachment,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamVideoAttachmentProps], which configures this widget.
///  * [DefaultStreamVideoAttachment], the default implementation.
class StreamVideoAttachment extends StatelessWidget {
  /// Creates a [StreamVideoAttachment].
  StreamVideoAttachment({
    super.key,
    required Message message,
    required Attachment video,
    BoxConstraints? constraints,
  }) : props = StreamVideoAttachmentProps(
         message: message,
         video: video,
         constraints: constraints,
       );

  /// The properties that configure this attachment.
  final StreamVideoAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamVideoAttachmentProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamVideoAttachment(props: props);
  }
}

/// Properties for configuring a [StreamVideoAttachment].
///
/// This class holds all the configuration options for a video attachment,
/// allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamVideoAttachment], which uses these properties.
///  * [DefaultStreamVideoAttachment], the default implementation.
class StreamVideoAttachmentProps {
  /// Creates properties for a video attachment.
  const StreamVideoAttachmentProps({
    required this.message,
    required this.video,
    this.constraints,
  });

  /// The [Message] that the video is attached to.
  final Message message;

  /// The [Attachment] object containing the video information.
  final Attachment video;

  /// The constraints to use when displaying the video.
  final BoxConstraints? constraints;
}

const _kDefaultConstraints = BoxConstraints.tightFor(
  width: 256,
  height: 195,
);

/// The default implementation of [StreamVideoAttachment].
///
/// Renders the video thumbnail with upload progress indication.
///
/// See also:
///
///  * [StreamVideoAttachment], the public API widget.
///  * [StreamVideoAttachmentProps], which configures this widget.
class DefaultStreamVideoAttachment extends StatelessWidget {
  /// Creates a default Stream video attachment.
  const DefaultStreamVideoAttachment({
    super.key,
    required this.props,
  });

  /// The properties that configure this attachment.
  final StreamVideoAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final constraints = props.constraints ?? _kDefaultConstraints;

    return ConstrainedBox(
      constraints: constraints,
      child: Stack(
        fit: .expand,
        alignment: .center,
        children: [
          StreamVideoAttachmentThumbnail(
            video: props.video,
            fit: BoxFit.cover,
          ),
          if (props.video.uploadState.isSuccess) ...[
            const Center(child: StreamVideoPlayIndicator(size: .lg)),
          ] else ...[
            Positioned.fill(
              child: StreamAttachmentUploadStateBuilder(
                message: props.message,
                attachment: props.video,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
