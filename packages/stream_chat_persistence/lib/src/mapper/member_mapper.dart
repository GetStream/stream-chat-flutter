import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'user_mapper.dart';

///
extension MemberEntityX on MemberEntity {
  ///
  Member toMember({User user}) {
    return Member(
      user: user,
      userId: userId,
      banned: banned,
      shadowBanned: shadowBanned,
      updatedAt: updatedAt,
      createdAt: createdAt,
      role: role,
      inviteAcceptedAt: inviteAcceptedAt,
      invited: invited,
      inviteRejectedAt: inviteRejectedAt,
      isModerator: isModerator,
    );
  }
}

///
extension MemberX on Member {
  ///
  MemberEntity toEntity({String cid}) {
    return MemberEntity(
      userId: user?.id,
      banned: banned,
      shadowBanned: shadowBanned,
      channelCid: cid,
      createdAt: createdAt,
      isModerator: isModerator,
      inviteRejectedAt: inviteRejectedAt,
      invited: invited,
      inviteAcceptedAt: inviteAcceptedAt,
      role: role,
      updatedAt: updatedAt,
    );
  }
}
