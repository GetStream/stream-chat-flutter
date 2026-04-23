import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return context.chatComponentBuilder<MessageComposerInputHeaderProps>()?.call(
          context,
          MessageComposerInputHeaderProps.from(props),
        ) ??
        _DefaultStreamMessageComposerInputHeader(props: props);
  }
}

class _DefaultStreamMessageComposerInputHeader extends StatelessWidget {
  const _DefaultStreamMessageComposerInputHeader({required this.props});

  final MessageComposerComponentProps props;
  StreamMessageInputController get controller => props.controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: props.controller,
      builder: (context, _, __) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isEditing = controller.isEditing;
    final quotedMessage = !isEditing ? controller.message.quotedMessage : null;
    final ogAttachment = controller.ogAttachment;
    final nonOGAttachments = controller.attachments
        .where((it) {
          return it.titleLink == null && it.type != AttachmentType.voiceRecording;
        })
        .toList(growable: false);
    final voiceRecordings = controller.attachments
        .where((it) {
          return it.type == AttachmentType.voiceRecording;
        })
        .toList(growable: false);

    final hasAttachments = nonOGAttachments.isNotEmpty;
    final hasContent =
        isEditing || quotedMessage != null || hasAttachments || ogAttachment != null || voiceRecordings.isNotEmpty;

    final spacing = context.streamSpacing;
    final contentPadding = EdgeInsets.only(
      left: spacing.xs,
      right: spacing.xs,
    );

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: hasContent ? spacing.xs : 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEditing)
              Padding(
                padding: contentPadding,
                child: _EditMessageInHeader(
                  message: controller.messageBeingEdited ?? controller.message,
                  onRemovePressed: controller.cancelEditMessage,
                ),
              )
            else if (quotedMessage != null)
              Padding(
                padding: contentPadding,
                child: _QuotedMessageInHeader(
                  quotedMessage: quotedMessage,
                  onRemovePressed: () {
                    controller.clearQuotedMessage();
                    props.onQuotedMessageCleared?.call();
                  },
                  currentUserId: props.currentUserId,
                ),
              ),
            if (voiceRecordings.isNotEmpty)
              Padding(
                padding: contentPadding,
                child: StreamVoiceRecordingAttachmentPlaylist(
                  voiceRecordings: voiceRecordings,
                  voiceRecordingTitle: context.translations.voiceRecordingText,
                  message: props.controller.message,
                  itemDecorator: (context, index, child) {
                    final attachment = voiceRecordings.elementAtOrNull(index);
                    if (attachment == null) return child;

                    return StreamMessageComposerAttachmentContainer(
                      onRemovePressed: () => _onAttachmentRemovePressed(attachment),
                      child: child,
                    );
                  },
                ),
              ),
            if (hasAttachments)
              StreamMessageComposerAttachmentList(
                attachments: nonOGAttachments,
                onRemovePressed: _onAttachmentRemovePressed,
              ),
            if (ogAttachment != null)
              Padding(
                padding: contentPadding,
                child: MessageComposerLinkPreviewAttachment(
                  title: ogAttachment.title,
                  subtitle: ogAttachment.text,
                  image: ogAttachment.imageUrl != null ? CachedNetworkImageProvider(ogAttachment.imageUrl!) : null,
                  url: ogAttachment.titleLink,
                  onRemovePressed: () {
                    controller.clearOGAttachment();
                    props.focusNode?.unfocus();
                  },
                ),
              ),
          ],
        ),
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

class _EditMessageInHeader extends StatelessWidget {
  const _EditMessageInHeader({
    required this.message,
    required this.onRemovePressed,
  });

  final Message message;
  final VoidCallback onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return MessageComposerReplyAttachment(
      title: Text(context.translations.editMessageLabel),
      subtitle: StreamMessagePreviewText(message: message),
      onRemovePressed: onRemovePressed,
      style: ReplyStyle.outgoing,
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

  ImageProvider<Object>? _imageProvider(Message message) {
    final attachments = message.attachments;
    if (attachments.isEmpty || attachments.length > 1) return null;

    final attachment = attachments.first;
    if (attachment.type == AttachmentType.file) return null;
    final imageUrl = attachment.imageUrl ?? attachment.thumbUrl ?? attachment.assetUrl;

    if (imageUrl == null) return null;
    return CachedNetworkImageProvider(imageUrl);
  }

  String? _mimeTypeAttachment(Message message) {
    final attachments = message.attachments;
    if (attachments.isEmpty) return null;
    final attachment = attachments.first;

    if (attachment.type != AttachmentType.file) return null;
    if (attachments.any((it) => it.mimeType != attachment.mimeType)) return null;

    return attachment.mimeType;
  }

  @override
  Widget build(BuildContext context) {
    final isIncoming = currentUserId != quotedMessage.user?.id;

    final image = _imageProvider(quotedMessage);
    final mimeType = _mimeTypeAttachment(quotedMessage);

    Widget? trailing;
    if (image != null) {
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(context.streamRadius.md),
          image: DecorationImage(image: image, fit: BoxFit.cover),
        ),
      );
    } else if (mimeType != null) {
      trailing = StreamFileTypeIcon.fromMimeType(mimeType: mimeType);
    } else {
      trailing = null;
    }

    final translations = context.translations;
    final title = switch (isIncoming) {
      true => translations.replyToUserLabel(quotedMessage.user?.name ?? ''),
      false => translations.youText,
    };

    return MessageComposerReplyAttachment(
      title: Text(title),
      subtitle: StreamMessagePreviewText(message: quotedMessage),
      onRemovePressed: onRemovePressed,
      trailing: trailing,
      style: isIncoming ? .incoming : .outgoing,
    );
  }
}
