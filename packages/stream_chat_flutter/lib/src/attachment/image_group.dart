import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamImageGroup}
/// Constructs a group of image attachments in a [StreamMessageWidget].
/// {@endtemplate}
class StreamImageGroup extends StatelessWidget {
  /// {@macro streamImageGroup}
  const StreamImageGroup({
    super.key,
    required this.images,
    required this.message,
    required this.messageTheme,
    required this.constraints,
    this.onShowMessage,
    this.onReplyMessage,
    this.onAttachmentTap,
    this.imageThumbnailSize = const Size(400, 400),
    this.imageThumbnailResizeType = 'clip',
    this.imageThumbnailCropType = 'center',
    this.attachmentActionsModalBuilder,
  });

  /// List of attachments to show
  final List<Attachment> images;

  /// {@macro onImageGroupAttachmentTap}
  final OnImageGroupAttachmentTap? onAttachmentTap;

  /// The [Message] that the images are attached to
  final Message message;

  /// The [StreamMessageThemeData] to apply to this [message]
  final StreamMessageThemeData messageTheme;

  /// The constraints of the [images]
  final BoxConstraints constraints;

  /// {@macro showMessageCallback}
  final ShowMessageCallback? onShowMessage;

  /// {@macro replyMessageCallback}
  final ReplyMessageCallback? onReplyMessage;

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

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              direction: Axis.horizontal,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: _buildImage(context, 0),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: _buildImage(context, 1),
                  ),
                ),
              ],
            ),
          ),
          if (images.length >= 3)
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: _buildImage(context, 2),
                    ),
                    if (images.length >= 4)
                      Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              _buildImage(context, 3),
                              if (images.length > 4)
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () => _onTap(context, 3),
                                    child: Material(
                                      color: Colors.black38,
                                      child: Center(
                                        child: Text(
                                          '+ ${images.length - 4}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onTap(
    BuildContext context,
    int index,
  ) async {
    if (onAttachmentTap != null) {
      return onAttachmentTap!(message, images[index]);
    }

    final channel = StreamChannel.of(context).channel;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StreamChannel(
          channel: channel,
          child: StreamFullScreenMediaBuilder(
            mediaAttachmentPackages: message.getAttachmentPackageList(),
            startIndex: index,
            userName: message.user!.name,
            onShowMessage: onShowMessage,
            onReplyMessage: onReplyMessage,
            attachmentActionsModalBuilder: attachmentActionsModalBuilder,
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, int index) {
    return StreamImageAttachment(
      attachment: images[index],
      constraints: constraints,
      message: message,
      messageTheme: messageTheme,
      onAttachmentTap: () => _onTap(context, index),
      imageThumbnailSize: imageThumbnailSize,
      imageThumbnailResizeType: imageThumbnailResizeType,
      imageThumbnailCropType: imageThumbnailCropType,
      attachmentActionsModalBuilder: attachmentActionsModalBuilder,
    );
  }
}
