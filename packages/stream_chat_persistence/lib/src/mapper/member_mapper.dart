import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [MemberEntity]
extension MemberEntityX on MemberEntity {
  /// Maps a [MemberEntity] into [Member]
  Member toMember({User? user}) => Member(
        user: user,
        userId: userId,
        banned: banned,
        shadowBanned: shadowBanned,
        updatedAt: updatedAt,
        createdAt: createdAt,
        role: role,
        channelRole: channelRole,
        inviteAcceptedAt: inviteAcceptedAt,
        invited: invited,
        inviteRejectedAt: inviteRejectedAt,
        isModerator: isModerator,
      );
}

/// Useful mapping functions for [Member]
extension MemberX on Member {
  /// Maps a [Member] into [MemberEntity]
  MemberEntity toEntity({required String cid}) => MemberEntity(
        userId: user!.id,
        banned: banned,
        shadowBanned: shadowBanned,
        channelCid: cid,
        createdAt: createdAt,
        isModerator: isModerator,
        inviteRejectedAt: inviteRejectedAt,
        invited: invited,
        inviteAcceptedAt: inviteAcceptedAt,
        role: role,
        channelRole: channelRole,
        updatedAt: updatedAt,
      );
}
