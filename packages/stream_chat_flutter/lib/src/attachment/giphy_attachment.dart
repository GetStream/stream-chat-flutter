import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/giphy_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/misc/giphy_chip.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamGiphyAttachment}
/// Shows a GIF attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamGiphyAttachment extends StatelessWidget {
  /// {@macro streamGiphyAttachment}
  const StreamGiphyAttachment({
    super.key,
    required this.message,
    required this.giphy,
    this.type = GiphyInfoType.original,
    this.shape,
    this.constraints = const BoxConstraints(),
  });

  /// The [Message] that the giphy is attached to.
  final Message message;

  /// The [Attachment] object containing the giphy information.
  final Attachment giphy;

  /// The type of giphy to display.
  ///
  /// Defaults to [GiphyInfoType.fixedHeight].
  final GiphyInfoType type;

  /// The shape of the attachment.
  ///
  /// Defaults to [RoundedRectangleBorder] with a radius of 14.
  final ShapeBorder? shape;

  /// The constraints to use when displaying the giphy.
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    BoxFit? fit;
    final giphyInfo = giphy.giphyInfo(type);

    Size? giphySize;
    if (giphyInfo != null) {
      giphySize = Size(giphyInfo.width, giphyInfo.height);
    }

    // If attachment size is available, we will tighten the constraints max
    // size to the attachment size.
    var constraints = this.constraints;
    if (giphySize != null) {
      constraints = constraints.tightenMaxSize(giphySize);
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
        aspectRatio: giphySize?.aspectRatio ?? 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            StreamGiphyAttachmentThumbnail(
              type: type,
              giphy: giphy,
              fit: fit,
              width: double.infinity,
              height: double.infinity,
            ),
            if (giphy.uploadState.isSuccess)
              const Positioned(
                bottom: 8,
                left: 8,
                child: GiphyChip(),
              )
            else
              Padding(
                padding: const EdgeInsets.all(8),
                child: StreamAttachmentUploadStateBuilder(
                  message: message,
                  attachment: giphy,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
