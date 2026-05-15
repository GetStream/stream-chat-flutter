import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Builds the list of component builders for the stream chat components.
Iterable<StreamComponentBuilderExtension<Object>> streamChatComponentBuilders({
  // ── Channel / thread list ────────────────────────────────────────────────
  StreamComponentBuilder<StreamChannelListItemProps>? channelListItem,
  StreamComponentBuilder<StreamThreadListTileProps>? threadListItem,

  // ── Message composer ─────────────────────────────────────────────────────
  StreamComponentBuilder<MessageComposerProps>? messageComposer,
  StreamComponentBuilder<MessageComposerLeadingProps>? messageComposerLeading,
  StreamComponentBuilder<MessageComposerTrailingProps>? messageComposerTrailing,
  StreamComponentBuilder<MessageComposerInputProps>? messageComposerInput,
  StreamComponentBuilder<MessageComposerInputCenterProps>? messageComposerInputCenter,
  StreamComponentBuilder<MessageComposerInputLeadingProps>? messageComposerInputLeading,
  StreamComponentBuilder<MessageComposerInputHeaderProps>? messageComposerInputHeader,
  StreamComponentBuilder<MessageComposerInputTrailingProps>? messageComposerInputTrailing,
  StreamComponentBuilder<StreamMessageItemProps>? messageItem,
  StreamComponentBuilder<StreamMessageComposerAttachmentListProps>? messageComposerAttachmentList,
  StreamComponentBuilder<StreamMessageComposerAttachmentProps>? messageComposerAttachment,

  // ── Attachments ──────────────────────────────────────────────────────────
  StreamComponentBuilder<StreamImageAttachmentProps>? imageAttachment,
  StreamComponentBuilder<StreamVideoAttachmentProps>? videoAttachment,
  StreamComponentBuilder<StreamGiphyAttachmentProps>? giphyAttachment,
  StreamComponentBuilder<StreamGalleryAttachmentProps>? galleryAttachment,
  StreamComponentBuilder<StreamFileAttachmentProps>? fileAttachment,
  StreamComponentBuilder<StreamLinkPreviewAttachmentProps>? linkPreviewAttachment,
  StreamComponentBuilder<StreamVoiceRecordingAttachmentProps>? voiceRecordingAttachment,
  StreamComponentBuilder<StreamPollAttachmentProps>? pollAttachment,
  StreamComponentBuilder<StreamQuotedMessageProps>? quotedMessage,
  StreamComponentBuilder<StreamUnsupportedAttachmentProps>? unsupportedAttachment,
  StreamComponentBuilder<StreamMediaGalleryProps>? mediaGallery,
  StreamComponentBuilder<StreamMediaGalleryPreviewProps>? mediaGalleryPreview,
}) {
  final builders = [
    if (channelListItem != null) StreamComponentBuilderExtension(builder: channelListItem),
    if (threadListItem != null) StreamComponentBuilderExtension(builder: threadListItem),
    if (messageComposer != null) StreamComponentBuilderExtension(builder: messageComposer),
    if (messageComposerLeading != null) StreamComponentBuilderExtension(builder: messageComposerLeading),
    if (messageComposerTrailing != null) StreamComponentBuilderExtension(builder: messageComposerTrailing),
    if (messageComposerInput != null) StreamComponentBuilderExtension(builder: messageComposerInput),
    if (messageComposerInputCenter != null) StreamComponentBuilderExtension(builder: messageComposerInputCenter),
    if (messageComposerInputLeading != null) StreamComponentBuilderExtension(builder: messageComposerInputLeading),
    if (messageComposerInputHeader != null) StreamComponentBuilderExtension(builder: messageComposerInputHeader),
    if (messageComposerInputTrailing != null) StreamComponentBuilderExtension(builder: messageComposerInputTrailing),
    if (messageItem != null) StreamComponentBuilderExtension(builder: messageItem),
    if (messageComposerAttachmentList != null) StreamComponentBuilderExtension(builder: messageComposerAttachmentList),
    if (messageComposerAttachment != null) StreamComponentBuilderExtension(builder: messageComposerAttachment),
    if (imageAttachment != null) StreamComponentBuilderExtension(builder: imageAttachment),
    if (videoAttachment != null) StreamComponentBuilderExtension(builder: videoAttachment),
    if (giphyAttachment != null) StreamComponentBuilderExtension(builder: giphyAttachment),
    if (galleryAttachment != null) StreamComponentBuilderExtension(builder: galleryAttachment),
    if (fileAttachment != null) StreamComponentBuilderExtension(builder: fileAttachment),
    if (linkPreviewAttachment != null) StreamComponentBuilderExtension(builder: linkPreviewAttachment),
    if (voiceRecordingAttachment != null) StreamComponentBuilderExtension(builder: voiceRecordingAttachment),
    if (pollAttachment != null) StreamComponentBuilderExtension(builder: pollAttachment),
    if (quotedMessage != null) StreamComponentBuilderExtension(builder: quotedMessage),
    if (unsupportedAttachment != null) StreamComponentBuilderExtension(builder: unsupportedAttachment),
    if (mediaGallery != null) StreamComponentBuilderExtension(builder: mediaGallery),
    if (mediaGalleryPreview != null) StreamComponentBuilderExtension(builder: mediaGalleryPreview),
  ];

  return builders;
}

/// Helper extensions for the factory builders.
extension StreamChatComponentBuildersExtension on BuildContext {
  /// The builder for the given component type.
  StreamComponentBuilder<T>? chatComponentBuilder<T>() => StreamComponentFactory.of(this).extension<T>();
}
