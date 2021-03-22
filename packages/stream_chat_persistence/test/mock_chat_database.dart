import 'package:mockito/mockito.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

class MockChatDatabase extends Mock implements MoorChatDatabase {
  UserDao _userDao;

  @override
  UserDao get userDao => _userDao ??= MockUserDao();

  ChannelDao _channelDao;

  @override
  ChannelDao get channelDao => _channelDao ??= MockChannelDao();

  MessageDao _messageDao;

  @override
  MessageDao get messageDao => _messageDao ??= MockMessageDao();

  PinnedMessageDao _pinnedMessageDao;

  @override
  PinnedMessageDao get pinnedMessageDao =>
      _pinnedMessageDao ??= MockPinnedMessageDao();

  MemberDao _memberDao;

  @override
  MemberDao get memberDao => _memberDao ??= MockMemberDao();

  ReactionDao _reactionDao;

  @override
  ReactionDao get reactionDao => _reactionDao ??= MockReactionDao();

  ReadDao _readDao;

  @override
  ReadDao get readDao => _readDao ??= MockReadDao();

  ChannelQueryDao _channelQueryDao;

  @override
  ChannelQueryDao get channelQueryDao =>
      _channelQueryDao ??= MockChannelQueryDao();

  ConnectionEventDao _connectionEventDao;

  @override
  ConnectionEventDao get connectionEventDao =>
      _connectionEventDao ??= MockConnectionEventDao();
}

class MockUserDao extends Mock implements UserDao {}

class MockChannelDao extends Mock implements ChannelDao {}

class MockMessageDao extends Mock implements MessageDao {}

class MockPinnedMessageDao extends Mock implements PinnedMessageDao {}

class MockMemberDao extends Mock implements MemberDao {}

class MockReactionDao extends Mock implements ReactionDao {}

class MockReadDao extends Mock implements ReadDao {}

class MockChannelQueryDao extends Mock implements ChannelQueryDao {}

class MockConnectionEventDao extends Mock implements ConnectionEventDao {}
