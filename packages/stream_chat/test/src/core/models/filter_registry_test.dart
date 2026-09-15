import 'package:stream_chat/src/core/models/banned_user.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/draft.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/message_reminder.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/thread.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_core/stream_core.dart' show CollectionEquality, FilterField;
import 'package:test/test.dart';

void main() {
  group('registry surface', () {
    // A wrong sort name fails the request. A wrong filter name does not:
    // where the resource declares a custom-data container — channel, user,
    // member, poll and thread all do — the server reads an unrecognised key
    // as custom data, so the term matches no row and the query returns an
    // empty page instead of an error. Nothing else catches that, so the sets
    // are pinned.
    void expectRemotes(List<FilterField<Object>> fields, Set<String> expected) {
      expect(fields.map((it) => it.remote).toSet(), expected);
    }

    test('banned user fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          BannedUserFilterField.userId,
          BannedUserFilterField.bannedById,
          BannedUserFilterField.channelCid,
          BannedUserFilterField.reason,
          BannedUserFilterField.createdAt,
        ],
        {'user_id', 'banned_by_id', 'channel_cid', 'reason', 'created_at'},
      );
    });

    test('channel fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          ChannelFilterField.id,
          ChannelFilterField.cid,
          ChannelFilterField.type,
          ChannelFilterField.name,
          ChannelFilterField.createdById,
          ChannelFilterField.team,
          ChannelFilterField.frozen,
          ChannelFilterField.createdAt,
          ChannelFilterField.updatedAt,
          ChannelFilterField.lastMessageAt,
          ChannelFilterField.lastUpdated,
          ChannelFilterField.memberCount,
          ChannelFilterField.messageCount,
          ChannelFilterField.members,
          ChannelFilterField.memberUserName,
          ChannelFilterField.channelRole,
          ChannelFilterField.pinned,
          ChannelFilterField.hidden,
          ChannelFilterField.muted,
          ChannelFilterField.blocked,
          ChannelFilterField.disabled,
          ChannelFilterField.archived,
        ],
        {
          'id',
          'cid',
          'type',
          'name',
          'created_by_id',
          'team',
          'frozen',
          'created_at',
          'updated_at',
          'last_message_at',
          'last_updated',
          'member_count',
          'message_count',
          'members',
          'member.user.name',
          'channel_role',
          'pinned',
          'hidden',
          'muted',
          'blocked',
          'disabled',
          'archived',
        },
      );
    });

    test('draft fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          DraftFilterField.channelCid,
          DraftFilterField.createdAt,
          DraftFilterField.parentId,
        ],
        {'channel_cid', 'created_at', 'parent_id'},
      );
    });

    test('member fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          MemberFilterField.userId,
          MemberFilterField.name,
          MemberFilterField.channelRole,
          MemberFilterField.isModerator,
          MemberFilterField.banned,
          MemberFilterField.invite,
          MemberFilterField.joined,
          MemberFilterField.lastActive,
          MemberFilterField.userEmail,
          MemberFilterField.userDeactivated,
          MemberFilterField.notificationsMuted,
          MemberFilterField.createdAt,
          MemberFilterField.updatedAt,
        ],
        {
          'user_id',
          'name',
          'channel_role',
          'is_moderator',
          'banned',
          'invite',
          'joined',
          'last_active',
          'user.email',
          'user.nd_deactivated',
          'notifications_muted',
          'created_at',
          'updated_at',
        },
      );
    });

    test('message reminder fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          MessageReminderFilterField.channelCid,
          MessageReminderFilterField.messageId,
          MessageReminderFilterField.remindAt,
          MessageReminderFilterField.createdAt,
        ],
        {'channel_cid', 'message_id', 'remind_at', 'created_at'},
      );
    });

    test('message search fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          MessageSearchFilterField.id,
          MessageSearchFilterField.text,
          MessageSearchFilterField.type,
          MessageSearchFilterField.userId,
          MessageSearchFilterField.parentId,
          MessageSearchFilterField.replyCount,
          MessageSearchFilterField.pinned,
          MessageSearchFilterField.attachments,
          MessageSearchFilterField.attachmentsType,
          MessageSearchFilterField.mentionedUsersId,
          MessageSearchFilterField.createdAt,
          MessageSearchFilterField.updatedAt,
        ],
        {
          'id',
          'text',
          'type',
          'user_id',
          'parent_id',
          'reply_count',
          'pinned',
          'attachments',
          'attachments.type',
          'mentioned_users.id',
          'created_at',
          'updated_at',
        },
      );
    });

    test('poll fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          PollFilterField.id,
          PollFilterField.name,
          PollFilterField.createdById,
          PollFilterField.isClosed,
          PollFilterField.maxVotesAllowed,
          PollFilterField.allowAnswers,
          PollFilterField.allowUserSuggestedOptions,
          PollFilterField.votingVisibility,
          PollFilterField.createdAt,
          PollFilterField.updatedAt,
        ],
        {
          'id',
          'name',
          'created_by_id',
          'is_closed',
          'max_votes_allowed',
          'allow_answers',
          'allow_user_suggested_options',
          'voting_visibility',
          'created_at',
          'updated_at',
        },
      );
    });

    test('poll vote fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          PollVoteFilterField.id,
          PollVoteFilterField.pollId,
          PollVoteFilterField.optionId,
          PollVoteFilterField.userId,
          PollVoteFilterField.isAnswer,
          PollVoteFilterField.createdAt,
          PollVoteFilterField.updatedAt,
        ],
        {'id', 'poll_id', 'option_id', 'user_id', 'is_answer', 'created_at', 'updated_at'},
      );
    });

    test('reaction fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          ReactionFilterField.type,
          ReactionFilterField.userId,
          ReactionFilterField.createdAt,
        ],
        {'type', 'user_id', 'created_at'},
      );
    });

    test('thread fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          ThreadFilterField.channelCid,
          ThreadFilterField.parentMessageId,
          ThreadFilterField.createdByUserId,
          ThreadFilterField.replyCount,
          ThreadFilterField.participantCount,
          ThreadFilterField.activeParticipantCount,
          ThreadFilterField.lastMessageAt,
          ThreadFilterField.createdAt,
          ThreadFilterField.updatedAt,
          ThreadFilterField.channelTeam,
          ThreadFilterField.channelDisabled,
        ],
        {
          'channel_cid',
          'parent_message_id',
          'created_by_user_id',
          'reply_count',
          'participant_count',
          'active_participant_count',
          'last_message_at',
          'created_at',
          'updated_at',
          'channel.team',
          'channel.disabled',
        },
      );
    });

    test('user fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          UserFilterField.id,
          UserFilterField.name,
          UserFilterField.username,
          UserFilterField.email,
          UserFilterField.role,
          UserFilterField.teams,
          UserFilterField.banned,
          UserFilterField.shadowBanned,
          UserFilterField.bypassModeration,
          UserFilterField.lastActive,
          UserFilterField.createdAt,
          UserFilterField.updatedAt,
          UserFilterField.language,
        ],
        {
          'id',
          'name',
          'username',
          'email',
          'role',
          'teams',
          'banned',
          'shadow_banned',
          'bypass_moderation',
          'last_active',
          'created_at',
          'updated_at',
          'language',
        },
      );
    });

    test('a custom field sends the name it was given', () {
      expect(ChannelFilterField.custom('has_unread').remote, 'has_unread');
      expect(MemberFilterField.custom('x').remote, 'x');
      expect(MessageSearchFilterField.custom('x').remote, 'x');
      expect(PollFilterField.custom('x').remote, 'x');
      expect(ThreadFilterField.custom('has_unread').remote, 'has_unread');
      expect(UserFilterField.custom('x').remote, 'x');
    });
  });

  group('collection equality', () {
    ChannelState channelOf(List<String> memberIds) => ChannelState(
      members: [for (final id in memberIds) Member(userId: id)],
    );

    test('`members` matches the channel holding exactly those users', () {
      final filter = ChannelFilter.equal(ChannelFilterField.members, const ['alice', 'bob']);

      expect(filter.matches(channelOf(['alice', 'bob'])), isTrue);
      // Membership is a set: the server looks a distinct channel up by a hash
      // of its sorted user ids, so the order they arrive in cannot matter.
      expect(filter.matches(channelOf(['bob', 'alice'])), isTrue);
      expect(filter.matches(channelOf(['alice', 'bob', 'carol'])), isFalse);
      expect(filter.matches(channelOf(['alice'])), isFalse);
    });

    test('a field describing a channel matches by containment', () {
      final filter = ChannelFilter.equal(ChannelFilterField.memberUserName, const ['Alice']);

      final channel = ChannelState(
        members: [
          Member(
            userId: 'alice',
            user: User(id: 'alice', name: 'Alice'),
          ),
          Member(
            userId: 'bob',
            user: User(id: 'bob', name: 'Bob'),
          ),
        ],
      );

      expect(filter.matches(channel), isTrue);
    });

    // Only a field that identifies its model by its elements asks for
    // exactness. A new collection field defaults to containment, so pin the
    // one exception rather than leave the choice implicit.
    test('`members` is the only field asking for exactness', () {
      final exact = <FilterField<Object>>[
        ChannelFilterField.members,
        ChannelFilterField.memberUserName,
        MessageSearchFilterField.attachmentsType,
        MessageSearchFilterField.mentionedUsersId,
        UserFilterField.teams,
      ].where((it) => it.collectionEquality == CollectionEquality.containsExactly);

      expect(exact, [same(ChannelFilterField.members)]);
    });
  });
}
