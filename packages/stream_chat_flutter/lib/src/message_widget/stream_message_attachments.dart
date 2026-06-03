import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget_catalog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// {@template onAttachmentWidgetTap}
/// A callback that is called when an attachment widget is tapped.
///
/// Return `true` if the attachment was handled by your custom logic,
/// `false` to use the default handler which automatically:
/// - Opens URL previews in browser (or calls [onLinkTap] if provided)
/// - Opens images, videos, and giphys in full screen viewer
///
/// Supports both synchronous and asynchronous operations via [FutureOr].
///
/// Example with custom location attachments:
/// ```dart
/// StreamMessageItem(
///   message: message,
///   onAttachmentTap: (context, message, attachment) async {
///     if (attachment.type == 'location') {
///       await showLocationDialog(context, attachment);
///       return true; // Handled by custom logic
///     }
///     return false; // Use default behavior for other types
///   },
/// )
/// ```
/// {@endtemplate}
typedef OnAttachmentWidgetTap = FutureOr<bool> Function(BuildContext context, Message message, Attachment attachment);

/// {@template streamMessageAttachments}
/// Renders the attachments of a [StreamMessageItem].
///
/// Used inside [StreamMessageContent]. Should not be used elsewhere.
/// {@endtemplate}
class StreamMessageAttachments extends core.NullableStatelessWidget {
  /// {@macro streamMessageAttachments}
  const StreamMessageAttachments({
    super.key,
    required this.message,
    this.attachmentBuilders,
    this.onAttachmentTap,
    this.onLinkTap,
  });

  /// {@macro message}
  final Message message;

  /// {@macro attachmentBuilders}
  final List<StreamAttachmentWidgetBuilder>? attachmentBuilders;

  /// {@macro onAttachmentTap}
  final OnAttachmentWidgetTap? onAttachmentTap;

  /// {@macro onLinkTap}
  final void Function(String)? onLinkTap;

  @override
  Widget? nullableBuild(BuildContext context) {
    Future<void> effectiveOnAttachmentTap(
      Message message,
      Attachment attachment,
    ) async {
      // Try custom handler first. If it returns true, the attachment was
      // handled.
      final handled = await onAttachmentTap?.call(context, message, attachment);
      if (handled ?? false) return;

      // Otherwise, use the default handler for standard attachment types.
      return _defaultAttachmentTapHandler(context, message, attachment);
    }

    final config = StreamChatConfiguration.maybeOf(context);
    final effectiveAttachmentBuilder = attachmentBuilders ?? config?.attachmentBuilders;

    // Create a default attachmentBuilders list if not provided.
    final builders = StreamAttachmentWidgetBuilder.defaultBuilders(
      message: message,
      onAttachmentTap: effectiveOnAttachmentTap,
      customAttachmentBuilders: effectiveAttachmentBuilder,
    );

    final catalog = AttachmentWidgetCatalog(builders: builders);
    return catalog.build(context, message);
  }

  Future<void> _defaultAttachmentTapHandler(
    BuildContext context,
    Message message,
    Attachment attachment,
  ) async {
    // If the current attachment is a url preview attachment, open the url
    // in the browser.
    final isFile = attachment.type == AttachmentType.file;
    final isUrlPreview = attachment.type == AttachmentType.urlPreview;
    if (isFile || isUrlPreview) {
      final url = attachment.assetUrl ?? attachment.ogScrapeUrl;
      if (url == null) return;

      if (onLinkTap case final onTap?) return onTap(url);
      return launchURL(context, url);
    }

    final isImage = attachment.type == AttachmentType.image;
    final isVideo = attachment.type == AttachmentType.video;
    final isGiphy = attachment.type == AttachmentType.giphy;

    // If the current attachment is a media attachment, open the media
    // attachment in full screen.
    final isMedia = isImage || isVideo || isGiphy;
    if (isMedia) {
      final attachments = message.toMediaGalleryAttachments(
        filter: (it) {
          final isImage = it.type == AttachmentType.image;
          final isVideo = it.type == AttachmentType.video;
          final isGiphy = it.type == AttachmentType.giphy;
          return isImage || isVideo || isGiphy;
        },
      );

      final navigator = Navigator.of(context);
      final channel = StreamChannel.of(context).channel;
      final initialIndex = attachments.indexWhere(
        (it) => it.attachment.id == attachment.id,
      );

      return navigator.push<void>(
        MaterialPageRoute(
          builder: (_) => StreamChannel.value(
            channel: channel,
            child: StreamMediaGalleryPreview(
              attachments: attachments,
              initialIndex: math.max(0, initialIndex),
            ),
          ),
        ),
      );
    }
  }
}
