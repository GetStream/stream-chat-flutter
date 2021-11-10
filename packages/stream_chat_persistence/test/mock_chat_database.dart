import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

class MockChatDatabase extends Mock implements DriftChatDatabase {
  UserDao? _userDao;

  @override
  UserDao get userDao => _userDao ??= MockUserDao();

  ChannelDao? _channelDao;

  @override
  ChannelDao get channelDao => _channelDao ??= MockChannelDao();

  MessageDao? _messageDao;

  @override
  MessageDao get messageDao => _messageDao ??= MockMessageDao();

  PinnedMessageDao? _pinnedMessageDao;

  @override
  PinnedMessageDao get pinnedMessageDao =>
      _pinnedMessageDao ??= MockPinnedMessageDao();

  MemberDao? _memberDao;

  @override
  MemberDao get memberDao => _memberDao ??= MockMemberDao();

  ReactionDao? _reactionDao;

  @override
  ReactionDao get reactionDao => _reactionDao ??= MockReactionDao();

  PinnedMessageReactionDao? _pinnedMessageReactionDao;

  @override
  PinnedMessageReactionDao get pinnedMessageReactionDao =>
      _pinnedMessageReactionDao ??= MockPinnedMessageReactionDao();

  ReadDao? _readDao;

  @override
  ReadDao get readDao => _readDao ??= MockReadDao();

  ChannelQueryDao? _channelQueryDao;

  @override
  ChannelQueryDao get channelQueryDao =>
      _channelQueryDao ??= MockChannelQueryDao();

  ConnectionEventDao? _connectionEventDao;

  @override
  ConnectionEventDao get connectionEventDao =>
      _connectionEventDao ??= MockConnectionEventDao();

  @override
  Future<void> flush() => Future.value();

  @override
  Future<void> disconnect() => Future.value();
}

class MockUserDao extends Mock implements UserDao {}

class MockChannelDao extends Mock implements ChannelDao {}

class MockMessageDao extends Mock implements MessageDao {}

class MockPinnedMessageDao extends Mock implements PinnedMessageDao {}

class MockMemberDao extends Mock implements MemberDao {}

class MockReactionDao extends Mock implements ReactionDao {}

class MockPinnedMessageReactionDao extends Mock
    implements PinnedMessageReactionDao {}

class MockReadDao extends Mock implements ReadDao {}

class MockChannelQueryDao extends Mock implements ChannelQueryDao {}

class MockConnectionEventDao extends Mock implements ConnectionEventDao {}
