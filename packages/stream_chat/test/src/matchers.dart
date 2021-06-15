import 'package:collection/collection.dart';
import 'package:dio/dio.dart' show MultipartFile;
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/message.dart';
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
  bool matchSendingStatus = false,
}) =>
    _IsSameMessageAs(
      targetMessage: targetMessage,
      matchText: matchText,
      matchReactions: matchReactions,
      matchSendingStatus: matchSendingStatus,
    );

class _IsSameMessageAs extends Matcher {
  const _IsSameMessageAs({
    required this.targetMessage,
    this.matchText = false,
    this.matchReactions = false,
    this.matchSendingStatus = false,
  });

  final Message targetMessage;
  final bool matchText;
  final bool matchReactions;
  final bool matchSendingStatus;

  @override
  Description describe(Description description) =>
      description.add('is same message as $targetMessage');

  @override
  bool matches(covariant Message message, Map matchState) {
    var matches = message.id == targetMessage.id;
    if (matchText) {
      matches &= message.text == targetMessage.text;
    }
    if (matchSendingStatus) {
      matches &= message.status == targetMessage.status;
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
    return matches;
  }
}
