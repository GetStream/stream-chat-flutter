import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

class StreamMessageComposerInputHeader extends StatelessWidget {
  const StreamMessageComposerInputHeader({super.key, required this.props});

  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposerFactory.maybeOf(context)?.inputHeader?.call(context, props) ??
        DefaultStreamMessageComposerInputHeader(props: props);
  }
}

class DefaultStreamMessageComposerInputHeader extends StatelessWidget {
  const DefaultStreamMessageComposerInputHeader({super.key, required this.props});

  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    // TODO: improve getter for currentUserId

    final currentUserId = StreamChat.of(context).currentUser?.id;
    final quotedMessage = props.controller.message.quotedMessage;

    final hasAttachments = props.controller.message.attachments.isNotEmpty;
    final hasContent = quotedMessage != null || hasAttachments;

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
              onRemovePressed: props.controller.clearQuotedMessage,
              currentUserId: currentUserId,
            ),
          if (hasAttachments)
            SizedBox(
              height: 80,
              child: _AttachmentsInHeader(
                attachments: props.controller.message.attachments,
                onRemovePressed: props.controller.clearAttachments,
              ),
            ),
        ],
      ),
    );
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

class _AttachmentsInHeader extends StatelessWidget {
  const _AttachmentsInHeader({
    required this.attachments,
    required this.onRemovePressed,
  });

  final List<Attachment> attachments;
  final VoidCallback onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final attachment in attachments)
            SizedBox(
              width: 80,
              height: 80,
              child: StreamFileAttachmentThumbnail(
                file: attachment,
              ),
            ),
        ],
      ),
    );
  }
}
