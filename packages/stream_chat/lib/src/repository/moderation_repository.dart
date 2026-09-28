import 'dart:math' as math;

import 'package:stream_core/stream_core.dart' show Result;

import '../../open_api/api.dart' as api;

int? _inMinutesAtLeastOne(Duration? timeout) =>
    timeout == null ? null : math.max(timeout.inMinutes, 1);

/// Repository dedicated to moderation operations.
class ModerationRepository {
  /// Initialize a new moderation repository.
  const ModerationRepository(this._api);

  final api.DefaultApi _api;

  /// Mutes [userId] for the current user.
  ///
  /// The mute lasts until it is removed. A [timeout] expires it after that
  /// long, applied in whole minutes and never less than one.
  Future<Result<void>> muteUser(
    String userId, {
    Duration? timeout,
  }) => _api.mute(
    muteRequest: api.MuteRequest(
      targetIds: [userId],
      timeout: _inMinutesAtLeastOne(timeout),
    ),
  );

  /// Removes the current user's mute on [userId].
  Future<Result<void>> unmuteUser(
    String userId,
  ) => _api.unmute(
    unmuteRequest: api.UnmuteRequest(
      targetIds: [userId],
    ),
  );

  /// Mutes the channel [channelCid] for the current user.
  ///
  /// The mute lasts until it is removed. An [expiration] expires it after
  /// that long.
  Future<Result<void>> muteChannel(
    String channelCid, {
    Duration? expiration,
  }) => _api.muteChannel(
    muteChannelRequest: api.MuteChannelRequest(
      channelCids: [channelCid],
      expiration: expiration?.inMilliseconds,
    ),
  );

  /// Removes the current user's mute on the channel [channelCid].
  Future<Result<void>> unmuteChannel(
    String channelCid,
  ) => _api.unmuteChannel(
    unmuteChannelRequest: api.UnmuteChannelRequest(
      channelCids: [channelCid],
    ),
  );

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
  /// sent, and [reason] is recorded with the ban.
  Future<Result<void>> banUser(
    String targetUserId, {
    String? channelCid,
    Duration? timeout,
    String? reason,
    bool? shadow,
    bool? ipBan,
    api.BanRequestDeleteMessages? deleteMessages,
  }) => _api.ban(
    banRequest: api.BanRequest(
      targetUserId: targetUserId,
      channelCid: channelCid,
      timeout: _inMinutesAtLeastOne(timeout),
      reason: reason,
      shadow: shadow,
      ipBan: ipBan,
      deleteMessages: deleteMessages,
    ),
  );

  /// Removes the ban on [targetUserId].
  ///
  /// Lifts the app-wide ban, or the ban on [channelCid] if one is given.
  ///
  /// A shadow ban lifts the same way as any other.
  Future<Result<void>> unbanUser(
    String targetUserId, {
    String? channelCid,
  }) => _api.unban(
    targetUserId: targetUserId,
    channelCid: channelCid,
  );

  /// Flags [messageId] for moderator review.
  ///
  /// [reason] and [custom] are recorded with the flag.
  Future<Result<void>> flagMessage(
    String messageId, {
    String? reason,
    Map<String, Object?>? custom,
  }) => _api.flag(
    flagRequest: api.FlagRequest(
      entityType: 'stream:chat:v1:message',
      entityId: messageId,
      reason: reason,
      custom: custom,
    ),
  );

  /// Flags [userId] for moderator review.
  ///
  /// [reason] and [custom] are recorded with the flag.
  Future<Result<void>> flagUser(
    String userId, {
    String? reason,
    Map<String, Object?>? custom,
  }) => _api.flag(
    flagRequest: api.FlagRequest(
      entityType: 'stream:user',
      entityId: userId,
      reason: reason,
      custom: custom,
    ),
  );
}
