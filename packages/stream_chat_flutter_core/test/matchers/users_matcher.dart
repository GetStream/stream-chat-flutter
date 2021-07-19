import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

Matcher isSameUserAs(User targetUser) => _IsSameUserAs(targetUser: targetUser);

class _IsSameUserAs extends Matcher {
  const _IsSameUserAs({
    required this.targetUser,
  });

  final User targetUser;

  @override
  bool matches(covariant User user, Map matchState) => user.id == targetUser.id;

  @override
  Description describe(Description description) =>
      description.add('is same user as $targetUser');
}

Matcher isSameUserListAs(List<User> targetUserList) =>
    _IsSameUserListAs(targetUserList: targetUserList);

class _IsSameUserListAs extends Matcher {
  const _IsSameUserListAs({
    required this.targetUserList,
  });

  final List<User> targetUserList;

  @override
  bool matches(covariant List<User> userList, Map matchState) {
    var matches = true;
    for (var i = 0; i < userList.length; i++) {
      final user = userList[i];
      final targetUser = targetUserList[i];
      matches = isSameUserAs(targetUser).matches(user, matchState);
      if (!matches) break;
    }
    return matches;
  }

  @override
  Description describe(Description description) =>
      description.add('is same userList as $targetUserList');
}
