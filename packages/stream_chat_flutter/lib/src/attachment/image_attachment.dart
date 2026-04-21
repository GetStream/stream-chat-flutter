import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// An image attachment component with automatic sizing.
///
/// [StreamImageAttachment] displays an image attachment, automatically
/// sized based on the image's original dimensions.
///
/// {@tool snippet}
///
/// Basic usage:
///
/// ```dart
/// StreamImageAttachment(
///   message: message,
///   image: imageAttachment,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamImageAttachmentProps], which configures this widget.
///  * [DefaultStreamImageAttachment], the default implementation.
class StreamImageAttachment extends StatelessWidget {
  /// Creates a [StreamImageAttachment].
  StreamImageAttachment({
    super.key,
    required Message message,
    required Attachment image,
    BoxConstraints? constraints,
    ImageResize? resize,
  }) : props = .new(
         message: message,
         image: image,
         constraints: constraints,
         resize: resize,
       );

  /// The properties that configure this attachment.
  final StreamImageAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamImageAttachmentProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamImageAttachment(props: props);
  }
}

/// Properties for configuring a [StreamImageAttachment].
///
/// This class holds all the configuration options for an image attachment,
/// allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamImageAttachment], which uses these properties.
///  * [DefaultStreamImageAttachment], the default implementation.
class StreamImageAttachmentProps {
  /// Creates properties for an image attachment.
  const StreamImageAttachmentProps({
    required this.message,
    required this.image,
    this.constraints,
    this.resize,
  });

  /// The [Message] that the image is attached to.
  final Message message;

  /// The [Attachment] object containing the image information.
  final Attachment image;

  /// The constraints to use when displaying the image.
  final BoxConstraints? constraints;

  /// The resize configuration for the image attachment thumbnail.
  ///
  /// When provided, its [ImageResize.width] and [ImageResize.height] are used
  /// directly as the CDN resize dimensions.
  ///
  /// When null, the size is auto-calculated from the layout constraints
  /// and defaults to [ResizeMode.clip] and [CropMode.center].
  final ImageResize? resize;
}

const _kDefaultConstraints = BoxConstraints(
  minWidth: 170,
  maxWidth: 256,
  minHeight: 100,
  maxHeight: 300,
);

/// The default implementation of [StreamImageAttachment].
///
/// Renders the image thumbnail with upload progress indication.
///
/// See also:
///
///  * [StreamImageAttachment], the public API widget.
///  * [StreamImageAttachmentProps], which configures this widget.
class DefaultStreamImageAttachment extends StatelessWidget {
  /// Creates a default Stream image attachment.
  const DefaultStreamImageAttachment({
    super.key,
    required this.props,
  });

  /// The properties that configure this attachment.
  final StreamImageAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    BoxFit? fit;
    final imageSize = props.image.originalSize;

    // If attachment size is available, we will tighten the constraints max
    // size to the attachment size.
    var constraints = props.constraints ?? _kDefaultConstraints;
    if (imageSize != null) {
      constraints = constraints.tightenMaxSize(imageSize);
    } else {
      // For backward compatibility, we will fill the available space if the
      // attachment size is not available.
      fit = BoxFit.cover;
    }

    return ConstrainedBox(
      constraints: constraints,
      child: AspectRatio(
        aspectRatio: imageSize?.aspectRatio ?? 1,
        child: Stack(
          fit: .expand,
          alignment: .center,
          children: [
            StreamImageAttachmentThumbnail(
              image: props.image,
              fit: fit,
              resize: props.resize,
            ),
            Positioned.fill(
              child: StreamAttachmentUploadStateBuilder(
                message: props.message,
                attachment: props.image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
