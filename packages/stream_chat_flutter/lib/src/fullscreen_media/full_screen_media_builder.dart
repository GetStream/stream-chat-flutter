import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A full screen media widget
@Deprecated('Use StreamFullScreenMedia instead.')
class StreamFullScreenMediaBuilder extends StatelessWidget {
  /// Instantiate a new StreamFullScreenMediaBuilder
  const StreamFullScreenMediaBuilder({
    super.key,
    required this.mediaAttachmentPackages,
    required this.startIndex,
    required this.userName,
    this.onShowMessage,
    this.onReplyMessage,
    this.attachmentActionsModalBuilder,
    this.autoplayVideos = false,
  });

  /// The url of the image
  final List<StreamAttachmentPackage> mediaAttachmentPackages;

  /// First index of media shown
  final int startIndex;

  /// Username of sender
  final String userName;

  /// Callback for when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// Callback for when reply message is tapped
  final ReplyMessageCallback? onReplyMessage;

  /// Widget builder for attachment actions modal
  /// [defaultActionsModal] is the default [AttachmentActionsModal] config
  /// Use [defaultActionsModal.copyWith] to easily customize it
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// Auto-play videos when page is opened
  final bool autoplayVideos;

  @override
  Widget build(BuildContext context) {
    return StreamFullScreenMedia(
      mediaAttachmentPackages: mediaAttachmentPackages,
      startIndex: startIndex,
      userName: userName,
      onShowMessage: onShowMessage,
      onReplyMessage: onReplyMessage,
      attachmentActionsModalBuilder: attachmentActionsModalBuilder,
      autoplayVideos: autoplayVideos,
    );
  }
}
