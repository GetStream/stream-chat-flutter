import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

class MockChatDatabase extends Mock implements DriftChatDatabase {
  @override
  UserDao get userDao => _userDao ??= MockUserDao();
  UserDao? _userDao;

  @override
  ChannelDao get channelDao => _channelDao ??= MockChannelDao();
  ChannelDao? _channelDao;

  @override
  MessageDao get messageDao => _messageDao ??= MockMessageDao();
  MessageDao? _messageDao;

  @override
  PinnedMessageDao get pinnedMessageDao =>
      _pinnedMessageDao ??= MockPinnedMessageDao();
  PinnedMessageDao? _pinnedMessageDao;

  @override
  MemberDao get memberDao => _memberDao ??= MockMemberDao();
  MemberDao? _memberDao;

  @override
  ReactionDao get reactionDao => _reactionDao ??= MockReactionDao();
  ReactionDao? _reactionDao;

  @override
  PinnedMessageReactionDao get pinnedMessageReactionDao =>
      _pinnedMessageReactionDao ??= MockPinnedMessageReactionDao();
  PinnedMessageReactionDao? _pinnedMessageReactionDao;

  @override
  ReadDao get readDao => _readDao ??= MockReadDao();
  ReadDao? _readDao;

  @override
  ChannelQueryDao get channelQueryDao =>
      _channelQueryDao ??= MockChannelQueryDao();
  ChannelQueryDao? _channelQueryDao;

  @override
  ConnectionEventDao get connectionEventDao =>
      _connectionEventDao ??= MockConnectionEventDao();
  ConnectionEventDao? _connectionEventDao;

  @override
  PollDao get pollDao => _pollDao ??= MockPollDao();
  PollDao? _pollDao;

  @override
  PollVoteDao get pollVoteDao => _pollVoteDao ??= MockPollVoteDao();
  PollVoteDao? _pollVoteDao;

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

class MockPollDao extends Mock implements PollDao {}

class MockPollVoteDao extends Mock implements PollVoteDao {}
