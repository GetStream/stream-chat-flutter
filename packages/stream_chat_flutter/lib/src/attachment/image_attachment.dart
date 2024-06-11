import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamImageAttachment}
/// Shows an image attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamImageAttachment extends StatelessWidget {
  /// {@macro streamImageAttachment}
  const StreamImageAttachment({
    super.key,
    required this.message,
    required this.image,
    this.shape,
    this.constraints = const BoxConstraints(),
    this.imageThumbnailSize = const Size(400, 400),
    this.imageThumbnailResizeType = 'clip',
    this.imageThumbnailCropType = 'center',
  });

  /// The [Message] that the image is attached to.
  final Message message;

  /// The [Attachment] object containing the image information.
  final Attachment image;

  /// The shape of the attachment.
  ///
  /// Defaults to [RoundedRectangleBorder] with a radius of 14.
  final ShapeBorder? shape;

  /// The constraints to use when displaying the image.
  final BoxConstraints constraints;

  /// Size of the attachment image thumbnail.
  final Size imageThumbnailSize;

  /// Resize type of the image attachment thumbnail.
  ///
  /// Defaults to [crop]
  final String /*clip|crop|scale|fill*/ imageThumbnailResizeType;

  /// Crop type of the image attachment thumbnail.
  ///
  /// Defaults to [center]
  final String /*center|top|bottom|left|right*/ imageThumbnailCropType;

  @override
  Widget build(BuildContext context) {
    BoxFit? fit;
    final imageSize = image.originalSize;

    // If attachment size is available, we will tighten the constraints max
    // size to the attachment size.
    var constraints = this.constraints;
    if (imageSize != null) {
      constraints = constraints.tightenMaxSize(imageSize);
    } else {
      // For backward compatibility, we will fill the available space if the
      // attachment size is not available.
      fit = BoxFit.cover;
    }

    final chatTheme = StreamChatTheme.of(context);
    final colorTheme = chatTheme.colorTheme;
    final shape = this.shape ??
        RoundedRectangleBorder(
          side: BorderSide(
            color: colorTheme.borders,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(14),
        );

    return Container(
      constraints: constraints,
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(shape: shape),
      child: AspectRatio(
        aspectRatio: imageSize?.aspectRatio ?? 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            StreamImageAttachmentThumbnail(
              image: image,
              fit: fit,
              width: double.infinity,
              height: double.infinity,
              thumbnailSize: imageThumbnailSize,
              thumbnailResizeType: imageThumbnailResizeType,
              thumbnailCropType: imageThumbnailCropType,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: StreamAttachmentUploadStateBuilder(
                message: message,
                attachment: image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
