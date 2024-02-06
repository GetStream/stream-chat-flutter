import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/video_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamVideoAttachment}
/// Shows a video attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamVideoAttachment extends StatelessWidget {
  /// {@macro streamVideoAttachment}
  const StreamVideoAttachment({
    super.key,
    required this.message,
    required this.video,
    this.shape,
    this.constraints = const BoxConstraints(),
  });

  /// The [Message] that the video is attached to.
  final Message message;

  /// The [Attachment] object containing the video information.
  final Attachment video;

  /// The shape of the attachment.
  ///
  /// Defaults to [RoundedRectangleBorder] with a radius of 14.
  final ShapeBorder? shape;

  /// The constraints to use when displaying the video.
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          StreamVideoAttachmentThumbnail(
            video: video,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          const Material(
            shape: CircleBorder(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.play_arrow),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: StreamAttachmentUploadStateBuilder(
              message: message,
              attachment: video,
            ),
          ),
        ],
      ),
    );
  }
}
