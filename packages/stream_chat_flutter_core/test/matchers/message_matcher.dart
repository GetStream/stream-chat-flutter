import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

Matcher isSameMessageAs(Message targetMessage) =>
    _IsSameMessageAs(targetMessage: targetMessage);

class _IsSameMessageAs extends Matcher {
  const _IsSameMessageAs({
    required this.targetMessage,
  });

  final Message targetMessage;

  @override
  bool matches(covariant Message message, Map matchState) =>
      message.id == targetMessage.id;

  @override
  Description describe(Description description) =>
      description.add('is same message as $targetMessage');
}

Matcher isSameMessageListAs(List<Message> targetMessageList) =>
    _IsSameMessageListAs(targetMessageList: targetMessageList);

class _IsSameMessageListAs extends Matcher {
  const _IsSameMessageListAs({
    required this.targetMessageList,
  });

  final List<Message> targetMessageList;

  @override
  bool matches(covariant List<Message> messageList, Map matchState) {
    var matches = true;
    for (var i = 0; i < messageList.length; i++) {
      final message = messageList[i];
      final targetMessage = targetMessageList[i];
      matches = isSameMessageAs(targetMessage).matches(message, matchState);
      if (!matches) break;
    }
    return matches;
  }

  @override
  Description describe(Description description) =>
      description.add('is same messageList as $targetMessageList');
}
