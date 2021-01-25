import 'package:stream_chat/stream_chat.dart';
import 'user_mapper.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

///
extension ChannelEntityX on ChannelEntity {
  ///
  ChannelModel toChannelModel({User createdBy}) {
    final config = ChannelConfig.fromJson(this.config ?? {});
    return ChannelModel(
      id: id,
      config: config,
      type: type,
      frozen: frozen,
      createdAt: createdAt,
      updatedAt: updatedAt,
      memberCount: memberCount,
      cid: cid,
      lastMessageAt: lastMessageAt,
      deletedAt: deletedAt,
      extraData: extraData,
      createdBy: createdBy,
    );
  }

  ///
  ChannelState toChannelState({
    User createdBy,
    List<Member> members,
    List<Read> reads,
    List<Message> messages,
  }) {
    return ChannelState(
      members: members,
      read: reads,
      messages: messages,
      channel: toChannelModel(createdBy: createdBy),
    );
  }
}

///
extension ChannelModelX on ChannelModel {
  ///
  ChannelEntity toEntity() {
    return ChannelEntity(
      id: id,
      type: type,
      cid: cid,
      config: config.toJson(),
      frozen: frozen,
      lastMessageAt: lastMessageAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      memberCount: memberCount,
      createdById: createdBy.id,
      extraData: extraData,
    );
  }
}
