import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget_catalog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
/// StreamMessageWidget(
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
typedef OnAttachmentWidgetTap =
    FutureOr<bool> Function(
      BuildContext context,
      Message message,
      Attachment attachment,
    );

/// {@template parseAttachments}
/// Parses the attachments of a [StreamMessageWidget].
///
/// Used in [MessageCard]. Should not be used elsewhere.
/// {@endtemplate}
class ParseAttachments extends StatelessWidget {
  /// {@macro parseAttachments}
  const ParseAttachments({
    super.key,
    required this.message,
    required this.attachmentBuilders,
    required this.attachmentPadding,
    this.attachmentShape,
    this.onAttachmentTap,
    this.onShowMessage,
    this.onLinkTap,
    this.onReplyTap,
    this.attachmentActionsModalBuilder,
  });

  /// {@macro message}
  final Message message;

  /// {@macro attachmentBuilders}
  final List<StreamAttachmentWidgetBuilder>? attachmentBuilders;

  /// {@macro attachmentPadding}
  final EdgeInsetsGeometry attachmentPadding;

  /// {@macro attachmentShape}
  final ShapeBorder? attachmentShape;

  /// {@macro onAttachmentTap}
  final OnAttachmentWidgetTap? onAttachmentTap;

  /// {@macro onShowMessage}
  final ShowMessageCallback? onShowMessage;

  /// {@macro onLinkTap}
  final void Function(String)? onLinkTap;

  /// {@macro onReplyTap}
  final void Function(Message)? onReplyTap;

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  @override
  Widget build(BuildContext context) {
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

    // Create a default attachmentBuilders list if not provided.
    final builders = StreamAttachmentWidgetBuilder.defaultBuilders(
      message: message,
      shape: attachmentShape,
      padding: attachmentPadding,
      onAttachmentTap: effectiveOnAttachmentTap,
      customAttachmentBuilders: attachmentBuilders,
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
    final isUrlPreview = attachment.type == AttachmentType.urlPreview;
    if (isUrlPreview) {
      final url = attachment.ogScrapeUrl;
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
      final attachments = message.toAttachmentPackage(
        filter: (it) {
          final isImage = it.type == AttachmentType.image;
          final isVideo = it.type == AttachmentType.video;
          final isGiphy = it.type == AttachmentType.giphy;
          return isImage || isVideo || isGiphy;
        },
      );

      final navigator = Navigator.of(context);
      final channel = StreamChannel.of(context).channel;
      final startIndex = attachments.indexWhere(
        (it) => it.attachment.id == attachment.id,
      );

      return navigator.push<void>(
        MaterialPageRoute(
          builder: (_) => StreamChannel(
            channel: channel,
            child: StreamFullScreenMediaBuilder(
              userName: message.user!.name,
              mediaAttachmentPackages: attachments,
              startIndex: math.max(0, startIndex),
              onReplyMessage: onReplyTap,
              onShowMessage: onShowMessage,
              attachmentActionsModalBuilder: attachmentActionsModalBuilder,
            ),
          ),
        ),
      );
    }
  }
}

extension on Message {
  List<StreamAttachmentPackage> toAttachmentPackage({
    bool Function(Attachment)? filter,
  }) {
    // Create a copy of the attachments list.
    var attachments = [...this.attachments];
    if (filter != null) {
      attachments = [...attachments.where(filter)];
    }

    // Create a list of StreamAttachmentPackage from the attachments list.
    return [
      ...attachments.map((it) {
        return StreamAttachmentPackage(
          attachment: it,
          message: this,
        );
      }),
    ];
  }
}
