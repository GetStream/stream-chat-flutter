import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A Giphy GIF attachment component with automatic sizing.
///
/// [StreamGiphyAttachment] displays a Giphy GIF attachment, automatically
/// sized based on the GIF's metadata dimensions.
///
/// {@tool snippet}
///
/// Basic usage:
///
/// ```dart
/// StreamGiphyAttachment(
///   message: message,
///   giphy: giphyAttachment,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamGiphyAttachmentProps], which configures this widget.
///  * [DefaultStreamGiphyAttachment], the default implementation.
class StreamGiphyAttachment extends StatelessWidget {
  /// Creates a [StreamGiphyAttachment].
  StreamGiphyAttachment({
    super.key,
    required Message message,
    required Attachment giphy,
    GiphyInfoType type = GiphyInfoType.original,
    BoxConstraints? constraints,
  }) : props = .new(
         message: message,
         giphy: giphy,
         type: type,
         constraints: constraints,
       );

  /// The properties that configure this attachment.
  final StreamGiphyAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamGiphyAttachmentProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamGiphyAttachment(props: props);
  }
}

/// Properties for configuring a [StreamGiphyAttachment].
///
/// This class holds all the configuration options for a giphy attachment,
/// allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamGiphyAttachment], which uses these properties.
///  * [DefaultStreamGiphyAttachment], the default implementation.
class StreamGiphyAttachmentProps {
  /// Creates properties for a giphy attachment.
  const StreamGiphyAttachmentProps({
    required this.message,
    required this.giphy,
    this.type = GiphyInfoType.original,
    this.constraints,
  });

  /// The [Message] that the giphy is attached to.
  final Message message;

  /// The [Attachment] object containing the giphy information.
  final Attachment giphy;

  /// The type of giphy to display.
  ///
  /// Defaults to [GiphyInfoType.original].
  final GiphyInfoType type;

  /// The constraints to use when displaying the giphy.
  final BoxConstraints? constraints;
}

const _kDefaultConstraints = BoxConstraints(
  minWidth: 170,
  maxWidth: 256,
  minHeight: 100,
  maxHeight: 300,
);

/// The default implementation of [StreamGiphyAttachment].
///
/// Renders the GIF thumbnail with upload progress indication.
///
/// See also:
///
///  * [StreamGiphyAttachment], the public API widget.
///  * [StreamGiphyAttachmentProps], which configures this widget.
class DefaultStreamGiphyAttachment extends StatelessWidget {
  /// Creates a default Stream giphy attachment.
  const DefaultStreamGiphyAttachment({
    super.key,
    required this.props,
  });

  /// The properties that configure this attachment.
  final StreamGiphyAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    BoxFit? fit;
    final giphyInfo = props.giphy.giphyInfo(props.type);

    Size? giphySize;
    if (giphyInfo != null) {
      giphySize = Size(giphyInfo.width, giphyInfo.height);
    }

    // If attachment size is available, we will tighten the constraints max
    // size to the attachment size.
    var constraints = props.constraints ?? _kDefaultConstraints;
    if (giphySize != null) {
      constraints = constraints.tightenMaxSize(giphySize);
    } else {
      // For backward compatibility, we will fill the available space if the
      // attachment size is not available.
      fit = BoxFit.cover;
    }

    return ConstrainedBox(
      constraints: constraints,
      child: AspectRatio(
        aspectRatio: giphySize?.aspectRatio ?? 1,
        child: Stack(
          fit: .expand,
          alignment: .center,
          children: [
            StreamGiphyAttachmentThumbnail(
              type: props.type,
              giphy: props.giphy,
              fit: fit,
            ),
            PositionedDirectional(
              bottom: 8,
              start: 8,
              child: StreamImageSourceBadge.giphy,
            ),
          ],
        ),
      ),
    );
  }
}
