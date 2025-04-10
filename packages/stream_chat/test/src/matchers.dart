import 'package:collection/collection.dart';
import 'package:dio/dio.dart' show MultipartFile;
import 'package:stream_chat/src/client/channel.dart';
import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/draft_message.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

Matcher isSameMultipartFileAs(MultipartFile targetFile) =>
    _IsSameMultipartFileAs(targetFile: targetFile);

class _IsSameMultipartFileAs extends Matcher {
  const _IsSameMultipartFileAs({required this.targetFile});

  final MultipartFile targetFile;

  @override
  Description describe(Description description) =>
      description.add('is same multipartFile as $targetFile');

  @override
  bool matches(covariant MultipartFile file, Map matchState) =>
      file.length == targetFile.length;
}

Matcher isSameEventAs(Event targetEvent) =>
    _IsSameEventAs(targetEvent: targetEvent);

class _IsSameEventAs extends Matcher {
  const _IsSameEventAs({required this.targetEvent});

  final Event targetEvent;

  @override
  Description describe(Description description) =>
      description.add('is same event as $targetEvent');

  @override
  bool matches(covariant Event event, Map matchState) =>
      event.type == targetEvent.type;
}

Matcher isSameMessageAs(
  Message targetMessage, {
  bool matchText = false,
  bool matchReactions = false,
  bool matchMessageState = false,
  bool matchAttachments = false,
  bool matchAttachmentsUploadState = false,
  bool matchParentId = false,
}) =>
    _IsSameMessageAs(
      targetMessage: targetMessage,
      matchText: matchText,
      matchReactions: matchReactions,
      matchMessageState: matchMessageState,
      matchAttachments: matchAttachments,
      matchAttachmentsUploadState: matchAttachmentsUploadState,
      matchParentId: matchParentId,
    );

class _IsSameMessageAs extends Matcher {
  const _IsSameMessageAs({
    required this.targetMessage,
    this.matchText = false,
    this.matchReactions = false,
    this.matchMessageState = false,
    this.matchAttachments = false,
    this.matchAttachmentsUploadState = false,
    this.matchParentId = false,
  });

  final Message targetMessage;
  final bool matchText;
  final bool matchReactions;
  final bool matchMessageState;
  final bool matchAttachments;
  final bool matchAttachmentsUploadState;
  final bool matchParentId;

  @override
  Description describe(Description description) =>
      description.add('is same message as $targetMessage');

  @override
  bool matches(covariant Message message, Map matchState) {
    var matches = message.id == targetMessage.id;
    if (matchText) {
      matches &= message.text == targetMessage.text;
    }
    if (matchMessageState) {
      matches &= message.state == targetMessage.state;
    }
    if (matchReactions) {
      matches &= const ListEquality().equals(
          message.ownReactions
              ?.map((it) => '${it.type}-${it.messageId}')
              .toList(),
          targetMessage.ownReactions
              ?.map((it) => '${it.type}-${it.messageId}')
              .toList());
      matches &= const ListEquality().equals(
          message.latestReactions
              ?.map((it) => '${it.type}-${it.messageId}')
              .toList(),
          targetMessage.latestReactions
              ?.map((it) => '${it.type}-${it.messageId}')
              .toList());
    }
    if (matchAttachments) {
      bool matchAttachments() {
        final attachments = message.attachments;
        final targetAttachments = targetMessage.attachments;
        if (identical(attachments, targetAttachments)) return true;
        final length = attachments.length;
        if (length != targetAttachments.length) return false;
        for (var i = 0; i < length; i++) {
          if (!isSameAttachmentAs(
            attachments[i],
            matchUploadState: matchAttachmentsUploadState,
          ).matches(targetAttachments[i], matchState)) {
            return false;
          }
        }
        return true;
      }

      matches &= matchAttachments();
    }
    if (matchParentId) {
      matches &= message.parentId == targetMessage.parentId;
    }
    return matches;
  }
}

Matcher isSameDraftMessageAs(
  DraftMessage targetMessage, {
  bool matchText = false,
  bool matchAttachments = false,
  bool matchParentId = false,
}) =>
    _IsSameDraftMessageAs(
      targetMessage: targetMessage,
      matchText: matchText,
      matchAttachments: matchAttachments,
      matchParentId: matchParentId,
    );

class _IsSameDraftMessageAs extends Matcher {
  const _IsSameDraftMessageAs({
    required this.targetMessage,
    this.matchText = false,
    this.matchAttachments = false,
    this.matchParentId = false,
  });

  final DraftMessage targetMessage;
  final bool matchText;
  final bool matchAttachments;
  final bool matchParentId;

  @override
  Description describe(Description description) =>
      description.add('is same draft message as $targetMessage');

  @override
  bool matches(covariant DraftMessage message, Map matchState) {
    var matches = message.id == targetMessage.id;
    if (matchText) matches &= message.text == targetMessage.text;
    if (matchParentId) matches &= message.parentId == targetMessage.parentId;
    if (matchAttachments) {
      bool matchAttachments() {
        final attachments = message.attachments;
        final targetAttachments = targetMessage.attachments;
        if (identical(attachments, targetAttachments)) return true;
        final length = attachments.length;
        if (length != targetAttachments.length) return false;
        for (var i = 0; i < length; i++) {
          if (!isSameAttachmentAs(
            attachments[i],
          ).matches(targetAttachments[i], matchState)) {
            return false;
          }
        }
        return true;
      }

      matches &= matchAttachments();
    }

    return matches;
  }
}

Matcher isSameAttachmentAs(
  Attachment targetAttachment, {
  bool matchUploadState = false,
}) =>
    _IsSameAttachmentAs(
      targetAttachment: targetAttachment,
      matchUploadState: matchUploadState,
    );

class _IsSameAttachmentAs extends Matcher {
  const _IsSameAttachmentAs({
    required this.targetAttachment,
    this.matchUploadState = false,
  });

  final Attachment targetAttachment;
  final bool matchUploadState;

  @override
  Description describe(Description description) =>
      description.add('is same attachment as $targetAttachment');

  @override
  bool matches(covariant Attachment attachment, Map matchState) {
    var matches = attachment.id == targetAttachment.id;
    if (matchUploadState) {
      matches &= attachment.uploadState == targetAttachment.uploadState;
    }
    return matches;
  }
}

Matcher isSameUserAs(User targetUser) => _IsSameUserAs(targetUser: targetUser);

class _IsSameUserAs extends Matcher {
  const _IsSameUserAs({required this.targetUser});

  final User targetUser;

  @override
  Description describe(Description description) =>
      description.add('is same user as $targetUser');

  @override
  bool matches(covariant User user, Map matchState) => user.id == targetUser.id;
}

Matcher isCorrectChannelFor(ChannelState channelState) =>
    _IsCorrectChannelFor(channelState: channelState);

class _IsCorrectChannelFor extends Matcher {
  const _IsCorrectChannelFor({required this.channelState});

  final ChannelState channelState;

  @override
  Description describe(Description description) =>
      description.add('is correct channel for $channelState');

  @override
  bool matches(covariant Channel channel, Map matchState) =>
      channel.cid == channelState.channel?.cid;
}
