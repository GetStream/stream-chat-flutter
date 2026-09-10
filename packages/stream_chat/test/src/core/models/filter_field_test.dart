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
import 'package:stream_core/stream_core.dart' show FilterField;
import 'package:test/test.dart';

/// Asserts [declared] and [omitted] together account for every field the spec
/// publishes, and that neither names something twice.
///
/// The point is [omitted]. A test that only pins what we declare agrees with
/// itself, so it stays green while the SDK quietly lacks a field the API
/// filters on. Requiring the two to sum to the published set turns each gap
/// into a decision someone wrote down.
void expectAccountsForSpec({
  required List<FilterField<Object>> declared,
  required Set<String> omitted,
  required Set<String> published,
}) {
  final remotes = declared.map((it) => it.remote).toSet();

  expect(
    remotes.intersection(omitted),
    isEmpty,
    reason: 'a field cannot be both declared and omitted',
  );
  expect(
    remotes.difference(published),
    isEmpty,
    reason: 'declared a field the spec does not publish',
  );
  expect(
    published.difference(remotes).difference(omitted),
    isEmpty,
    reason: 'the spec publishes a field that is neither declared nor omitted',
  );
}

void main() {
  test('ChannelFilterField accounts for every field the spec publishes', () {
    // QueryChannelsRequest.filter_conditions, from `x-stream-filter-fields` in
    // protocol's `openapi/chat-openapi-clientside.yaml` at openapi-v238.0.2.
    // Refresh from the protocol repo rather than from the backend Go source:
    // a resource's `mq.TableConfig.Columns` is one of several inputs the spec
    // merges, and it has not had the publication rules applied.
    const published = {
      'app_banned',
      'archived',
      'blocked',
      'channel_role',
      'cid',
      'created_at',
      'created_by_id',
      'custom',
      'disabled',
      'distinct',
      'filter_tags',
      'frozen',
      'has_unread',
      'hidden',
      'id',
      'invite',
      'joined',
      'last_message_at',
      'last_updated',
      'member.user.name',
      'member_count',
      'members',
      'message_count',
      'muted',
      'name',
      'pinned',
      'team',
      'type',
      'updated_at',
    };
    expectAccountsForSpec(
      published: published,
      declared: [
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
        ChannelFilterField.filterTags,
        ChannelFilterField.members,
        ChannelFilterField.memberUserName,
        ChannelFilterField.channelRole,
        ChannelFilterField.pinned,
        ChannelFilterField.archived,
        ChannelFilterField.hidden,
        ChannelFilterField.muted,
        ChannelFilterField.blocked,
        ChannelFilterField.disabled,
      ],
      omitted: {
        // Reachable through `ChannelFilterField.custom`, which reads
        // `ChannelModel.extraData`.
        'custom',

        // No local value. `app_banned` and `joined` are the only two the
        // channel response does not carry: the rest of this group
        // (`hidden`, `muted`, `blocked`, `disabled`) arrive as extra data
        // and are declared above.
        'app_banned',
        'joined',

        // Derived server-side from the query itself, not stored on the
        // channel: `distinct` from the cid shape, `has_unread` from the
        // caller's read state, `invite` from the membership lifecycle.
        'distinct',
        'has_unread',
        'invite',
      },
    );
  });

  test('DraftFilterField accounts for every field the spec publishes', () {
    expectAccountsForSpec(
      published: {'channel_cid', 'created_at', 'parent_id'},
      declared: [
        DraftFilterField.channelCid,
        DraftFilterField.createdAt,
        DraftFilterField.parentId,
      ],
      omitted: {},
    );
  });

  test('ReactionFilterField accounts for every field the spec publishes', () {
    expectAccountsForSpec(
      published: {'created_at', 'type', 'user_id'},
      declared: [
        ReactionFilterField.type,
        ReactionFilterField.userId,
        ReactionFilterField.createdAt,
      ],
      omitted: {},
    );
  });

  test('MessageReminderFilterField accounts for every field the spec publishes', () {
    expectAccountsForSpec(
      published: {'channel_cid', 'created_at', 'message_id', 'remind_at'},
      declared: [
        MessageReminderFilterField.channelCid,
        MessageReminderFilterField.messageId,
        MessageReminderFilterField.remindAt,
        MessageReminderFilterField.createdAt,
      ],
      omitted: {},
    );
  });

  test('BannedUserFilterField accounts for every field the spec publishes', () {
    expectAccountsForSpec(
      published: {
        'banned_by_id',
        'channel_cid',
        'created_at',
        'reason',
        'user_id',
      },
      declared: [
        BannedUserFilterField.userId,
        BannedUserFilterField.bannedById,
        BannedUserFilterField.channelCid,
        BannedUserFilterField.reason,
        BannedUserFilterField.createdAt,
      ],
      omitted: {},
    );
  });

  test('PollVoteFilterField accounts for every field the spec publishes', () {
    expectAccountsForSpec(
      published: {
        'created_at',
        'id',
        'is_answer',
        'option_id',
        'poll_id',
        'updated_at',
        'user_id',
      },
      declared: [
        PollVoteFilterField.id,
        PollVoteFilterField.pollId,
        PollVoteFilterField.optionId,
        PollVoteFilterField.userId,
        PollVoteFilterField.isAnswer,
        PollVoteFilterField.createdAt,
        PollVoteFilterField.updatedAt,
      ],
      omitted: {},
    );
  });

  test('PollFilterField accounts for every field the spec publishes', () {
    expectAccountsForSpec(
      published: {
        'allow_answers',
        'allow_user_suggested_options',
        'created_at',
        'created_by_id',
        'custom',
        'id',
        'is_closed',
        'max_votes_allowed',
        'name',
        'updated_at',
        'voting_visibility',
      },
      declared: [
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
      omitted: {
        // Reachable through `PollFilterField.custom`, which reads
        // `Poll.extraData`.
        'custom',
      },
    );
  });

  test('ThreadFilterField accounts for every field the spec publishes', () {
    expectAccountsForSpec(
      published: {
        'active_participant_count',
        'channel.disabled',
        'channel.team',
        'channel_cid',
        'created_at',
        'created_by_user_id',
        'custom',
        'has_unread',
        'last_message_at',
        'parent_message_id',
        'participant_count',
        'reply_count',
        'updated_at',
      },
      declared: [
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
      omitted: {
        // Reachable through `ThreadFilterField.custom`, which reads
        // `Thread.extraData`.
        'custom',

        // Derived server-side from the caller's read state, the same way a
        // channel's `has_unread` is.
        'has_unread',
      },
    );
  });

  test('UserFilterField accounts for every field the spec publishes', () {
    expectAccountsForSpec(
      published: {
        'banned',
        'bypass_moderation',
        'created_at',
        'custom',
        'email',
        'id',
        'language',
        'last_active',
        'name',
        'role',
        'shadow_banned',
        'teams',
        'updated_at',
        'username',
      },
      declared: [
        UserFilterField.id,
        UserFilterField.name,
        UserFilterField.username,
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
      omitted: {
        // Reachable through `UserFilterField.custom`, which reads
        // `User.extraData`. `email` is custom data the API names, rather
        // than a field of its own, so it is reached the same way.
        'custom',
        'email',
      },
    );
  });

  test('MemberFilterField accounts for every field the spec publishes', () {
    expectAccountsForSpec(
      published: {
        'banned',
        'channel_role',
        'cid',
        'created_at',
        'custom',
        'id',
        'invite',
        'is_moderator',
        'joined',
        'last_active',
        'name',
        'notifications_muted',
        'updated_at',
        'user.email',
        'user.nd_deactivated',
        'user_id',
      },
      declared: [
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
        MemberFilterField.createdAt,
        MemberFilterField.updatedAt,
      ],
      omitted: {
        // Reachable through `MemberFilterField.custom`, which reads
        // `Member.extraData`.
        'custom',

        // An alias the API resolves to the same column as `user_id`, which
        // is declared above.
        'id',

        // No local value: a member does not carry the cid of the channel
        // it belongs to.
        'cid',

        // Held on the channel mute rather than the membership, so a member
        // on its own cannot answer it.
        'notifications_muted',
      },
    );
  });

  test('MessageSearchFilterField accounts for every field the spec publishes', () {
    expectAccountsForSpec(
      published: {
        'attachments',
        'attachments.type',
        'cid',
        'created_at',
        'custom',
        'id',
        'mentioned_users.id',
        'parent_id',
        'pinned',
        'reply_count',
        'text',
        'type',
        'updated_at',
        'user.id',
        'user_id',
      },
      declared: [
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
      omitted: {
        // Reachable through `MessageSearchFilterField.custom`, which reads
        // `Message.extraData`.
        'custom',

        // An alias the API resolves to the same column as `user_id`, which
        // is declared above.
        'user.id',

        // No local value: a message does not carry the cid of the channel
        // it belongs to.
        'cid',
      },
    );
  });
}
