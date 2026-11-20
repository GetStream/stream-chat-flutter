import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart' show Result;

import '../core/models/delete_type.dart';
import '../core/models/response/flag_response.dart';
import '../core/models/response/mute_users_response.dart';
import '../core/models/response/unmute_users_response.dart';
import '../repository/mapper/result_mapper.dart';
import '../repository/moderation_repository.dart';

/// Muting, banning and flagging, for the connected user.
///
/// Obtained via [StreamChatClient.moderation]. Not intended to be constructed
/// directly.
///
/// See also:
///
///  * [Channel.banMember], which bans someone from one channel.
///  * [StreamChatClient.queryBannedUsers], which lists who is banned.
class ModerationClient {
  /// Creates a new moderation client.
  @internal
  const ModerationClient(this._repository);

  final ModerationRepository _repository;

  /// Mutes [userId] for the current user.
  ///
  /// The mute lasts until it is removed. A [timeout] expires it after that
  /// long, applied in whole minutes and never less than one.
  Future<Result<void>> muteUser(
    String userId, {
    Duration? timeout,
  }) async {
    final result = await muteUsers([userId], timeout: timeout);
    return result.ignoreValue();
  }

  /// Mutes every id in [userIds] for the current user.
  ///
  /// The mute lasts until it is removed. A [timeout] expires it after that
  /// long, applied in whole minutes and never less than one.
  ///
  /// At least one id is required.
  ///
  /// Returns the ids among [userIds] that matched no user.
  Future<Result<MuteUsersResponse>> muteUsers(
    List<String> userIds, {
    Duration? timeout,
  }) => _repository.muteUsers(userIds, timeout: timeout);

  /// Removes the current user's mute on [userId].
  Future<Result<void>> unmuteUser(
    String userId,
  ) async {
    final result = await unmuteUsers([userId]);
    return result.ignoreValue();
  }

  /// Removes the current user's mute on every id in [userIds].
  ///
  /// At least one id is required.
  ///
  /// Returns the ids among [userIds] that matched no user.
  Future<Result<UnmuteUsersResponse>> unmuteUsers(
    List<String> userIds,
  ) => _repository.unmuteUsers(userIds);

  /// Mutes the channel [channelCid] for the current user.
  ///
  /// The mute lasts until it is removed. An [expiration] expires it after
  /// that long, and a zero one removes it straight away.
  Future<Result<void>> muteChannel(
    String channelCid, {
    Duration? expiration,
  }) => _repository.muteChannel(channelCid, expiration: expiration);

  /// Removes the current user's mute on the channel [channelCid].
  Future<Result<void>> unmuteChannel(
    String channelCid,
  ) => _repository.unmuteChannel(channelCid);

  /// Bans [targetUserId].
  ///
  /// The ban covers the whole app, or only [channelCid] if one is given.
  ///
  /// It lasts until it is removed. A [timeout] expires it after that long,
  /// applied in whole minutes and never less than one.
  ///
  /// If [shadow] is true, their messages stop reaching anyone else and they
  /// are not told.
  ///
  /// If [ipBan] is true, the address they connected from is banned as well.
  ///
  /// [deleteMessages] decides what happens to the messages they already
  /// sent, which are left alone when it is omitted. [reason] is recorded
  /// with the ban.
  Future<Result<void>> banUser(
    String targetUserId, {
    String? channelCid,
    Duration? timeout,
    String? reason,
    bool? shadow,
    bool? ipBan,
    DeleteType? deleteMessages,
  }) => _repository.banUser(
    targetUserId,
    channelCid: channelCid,
    timeout: timeout,
    reason: reason,
    shadow: shadow,
    ipBan: ipBan,
    deleteMessages: deleteMessages,
  );

  /// Removes the ban on [targetUserId].
  ///
  /// Lifts the app-wide ban, or the ban on [channelCid] if one is given.
  ///
  /// A shadow ban lifts the same way as any other.
  Future<Result<void>> unbanUser(
    String targetUserId, {
    String? channelCid,
  }) => _repository.unbanUser(
    targetUserId,
    channelCid: channelCid,
  );

  /// Bans [targetUserId] without telling them, hiding their messages.
  ///
  /// The same as [banUser] with `shadow` set, and the other arguments behave
  /// the same way.
  ///
  /// Remove it with [unbanUser].
  Future<Result<void>> shadowBan(
    String targetUserId, {
    String? channelCid,
    Duration? timeout,
    String? reason,
    bool? ipBan,
    DeleteType? deleteMessages,
  }) => banUser(
    targetUserId,
    channelCid: channelCid,
    timeout: timeout,
    reason: reason,
    shadow: true,
    ipBan: ipBan,
    deleteMessages: deleteMessages,
  );

  /// Flags [messageId] for moderator review.
  ///
  /// [reason] and [custom] are recorded with the flag.
  ///
  /// Returns the id of the flagged item in the review queue.
  Future<Result<FlagResponse>> flagMessage(
    String messageId, {
    String? reason,
    Map<String, Object?>? custom,
  }) => _repository.flagMessage(messageId, reason: reason, custom: custom);

  /// Flags [userId] for moderator review.
  ///
  /// [reason] and [custom] are recorded with the flag.
  ///
  /// Returns the id of the flagged item in the review queue.
  Future<Result<FlagResponse>> flagUser(
    String userId, {
    String? reason,
    Map<String, Object?>? custom,
  }) => _repository.flagUser(userId, reason: reason, custom: custom);
}
