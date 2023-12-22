import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget_catalog.dart';
import 'package:stream_chat_flutter/src/message_widget/message_widget_content_components.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  /// {@macro onShowMessage}
  final ShowMessageCallback? onShowMessage;

  /// {@macro onReplyTap}
  final void Function(Message)? onReplyTap;

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  @override
  Widget build(BuildContext context) {
    // Create a default onAttachmentTap callback if not provided.
    var onAttachmentTap = this.onAttachmentTap;
    onAttachmentTap ??= (message, attachment) {
      // If the current attachment is a url preview attachment, open the url
      // in the browser.
      final isUrlPreview = attachment.type == AttachmentType.urlPreview;
      if (isUrlPreview) {
        final url = attachment.ogScrapeUrl ?? '';
        launchURL(context, url);
        return;
      }

      final isImage = attachment.type == AttachmentType.image;
      final isVideo = attachment.type == AttachmentType.video;
      final isGiphy = attachment.type == AttachmentType.giphy;

      // If the current attachment is a media attachment, open the media
      // attachment in full screen.
      final isMedia = isImage || isVideo || isGiphy;
      if (isMedia) {
        final channel = StreamChannel.of(context).channel;

        final attachments = message.toAttachmentPackage(
          filter: (it) {
            final isImage = it.type == AttachmentType.image;
            final isVideo = it.type == AttachmentType.video;
            final isGiphy = it.type == AttachmentType.giphy;
            return isImage || isVideo || isGiphy;
          },
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return StreamChannel(
                channel: channel,
                child: StreamFullScreenMediaBuilder(
                  userName: message.user!.name,
                  mediaAttachmentPackages: attachments,
                  startIndex: attachments.indexWhere(
                    (it) => it.attachment.id == attachment.id,
                  ),
                  onReplyMessage: onReplyTap,
                  onShowMessage: onShowMessage,
                  attachmentActionsModalBuilder: attachmentActionsModalBuilder,
                ),
              );
            },
          ),
        );

        return;
      }
    };

    // Create a default attachmentBuilders list if not provided.
    final builders = StreamAttachmentWidgetBuilder.defaultBuilders(
        message: message,
        shape: attachmentShape,
        padding: attachmentPadding,
        onAttachmentTap: onAttachmentTap,
        customAttachmentBuilders: attachmentBuilders);

    final catalog = AttachmentWidgetCatalog(builders: builders);
    return catalog.build(context, message);
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
      })
    ];
  }
}
