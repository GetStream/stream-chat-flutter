import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/fullscreen_media/full_screen_media_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Stub function for returning an instance of either [FullScreenMedia] or
/// [FullScreenMediaDesktop].
///
/// This should ONLY be used in [FullScreenMediaBuilder].
FullScreenMediaWidget getFsm({
  Key? key,
  required List<StreamAttachmentPackage> mediaAttachmentPackages,
  required int startIndex,
  required String userName,
  ShowMessageCallback? onShowMessage,
  ReplyMessageCallback? onReplyMessage,
  AttachmentActionsBuilder? attachmentActionsModalBuilder,
  bool? autoplayVideos,
}) =>
    throw UnsupportedError('Cannot create FullScreenMedia');
