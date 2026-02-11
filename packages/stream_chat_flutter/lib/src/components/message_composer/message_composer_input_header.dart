import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A widget that shows the input header of the message composer.
/// Uses the factory to show custom components or used the default implementation.
class StreamMessageComposerInputHeader extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerInputHeader].
  /// [props] contains the properties for the message composer component.
  const StreamMessageComposerInputHeader({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposerFactory.maybeOf(context)?.inputHeader?.call(context, props) ??
        _DefaultStreamMessageComposerInputHeader(props: props);
  }
}

class _DefaultStreamMessageComposerInputHeader extends StatelessWidget {
  const _DefaultStreamMessageComposerInputHeader({required this.props});

  final MessageComposerComponentProps props;
  StreamMessageInputController get controller => props.controller;

  @override
  Widget build(BuildContext context) {
    final quotedMessage = props.controller.message.quotedMessage;
    final ogAttachment = props.controller.ogAttachment;
    final nonOGAttachments = controller.attachments
        .where((it) {
          return it.titleLink == null;
        })
        .toList(growable: false);

    final hasAttachments = nonOGAttachments.isNotEmpty;
    final hasContent = quotedMessage != null || hasAttachments || ogAttachment != null;

    if (!hasContent) return const SizedBox.shrink();
    final spacing = context.streamSpacing;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.xs, spacing.xs, spacing.xs, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (quotedMessage != null)
            _QuotedMessageInHeader(
              quotedMessage: quotedMessage,
              onRemovePressed: controller.clearQuotedMessage,
              currentUserId: props.currentUserId,
            ),
          if (hasAttachments)
            StreamMessageInputAttachmentList(
              attachments: nonOGAttachments,
              onRemovePressed: _onAttachmentRemovePressed,
            ),
          if (ogAttachment != null)
            OGAttachmentPreview(
              attachment: ogAttachment,
              onDismissPreviewPressed: () {
                controller.clearOGAttachment();
                props.focusNode?.unfocus();
              },
            ),
        ],
      ),
    );
  }

  // Default callback for removing an attachment.
  Future<void> _onAttachmentRemovePressed(Attachment attachment) async {
    final file = attachment.file;
    final uploadState = attachment.uploadState;

    if (file != null && !uploadState.isSuccess && !isWeb) {
      await StreamAttachmentHandler.instance.deleteAttachmentFile(
        attachmentFile: file,
      );
    }

    controller.removeAttachmentById(attachment.id);
  }
}

class _QuotedMessageInHeader extends StatelessWidget {
  const _QuotedMessageInHeader({
    required this.quotedMessage,
    required this.onRemovePressed,
    required this.currentUserId,
  });

  final Message quotedMessage;
  final VoidCallback onRemovePressed;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final isIncoming = currentUserId != quotedMessage.user?.id;

    return
    // TODO: show image if available
    // TODO: localize strings
    MessageComposerAttachmentReply(
      title: isIncoming ? 'Reply to ${quotedMessage.user?.name}' : 'You',
      subtitle: quotedMessage.text ?? '',
      onRemovePressed: onRemovePressed,
      style: isIncoming ? .incoming : .outgoing,
    );
  }
}
