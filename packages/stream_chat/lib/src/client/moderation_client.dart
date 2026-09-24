import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart' show Result;

import '../../open_api/models.dart' show BanRequestDeleteMessages;
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
  /// Initialize a new moderation client.
  @internal
  const ModerationClient(this._repository);

  final ModerationRepository _repository;

  /// Mutes [userId] for the current user.
  ///
  /// The mute lasts until it is removed. A [timeout] expires it after that
  /// long, rounded down to whole minutes, so a shorter one never expires it.
  Future<Result<void>> muteUser(
    String userId, {
    Duration? timeout,
  }) => _repository.muteUser(userId, timeout: timeout);

  /// Removes the current user's mute on [userId].
  Future<Result<void>> unmuteUser(
    String userId,
  ) => _repository.unmuteUser(userId);

  /// Mutes the channel [channelCid] for the current user.
  ///
  /// The mute lasts until it is removed. An [expiration] expires it after
  /// that long.
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
  /// rounded down to whole minutes, so a shorter one never expires it.
  ///
  /// If [shadow] is true, their messages stop reaching anyone else and they
  /// are not told.
  ///
  /// If [ipBan] is true, the address they connected from is banned as well.
  ///
  /// [deleteMessages] decides what happens to the messages they already
  /// sent, and [reason] is recorded with the ban.
  Future<Result<void>> banUser(
    String targetUserId, {
    String? channelCid,
    Duration? timeout,
    String? reason,
    bool? shadow,
    bool? ipBan,
    BanRequestDeleteMessages? deleteMessages,
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
  }) => _repository.unbanUser(targetUserId, channelCid: channelCid);

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
    BanRequestDeleteMessages? deleteMessages,
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
  Future<Result<void>> flagMessage(
    String messageId, {
    String? reason,
    Map<String, Object?>? custom,
  }) => _repository.flagMessage(messageId, reason: reason, custom: custom);

  /// Flags [userId] for moderator review.
  ///
  /// [reason] and [custom] are recorded with the flag.
  Future<Result<void>> flagUser(
    String userId, {
    String? reason,
    Map<String, Object?>? custom,
  }) => _repository.flagUser(userId, reason: reason, custom: custom);
}
