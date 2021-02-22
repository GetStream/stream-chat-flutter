import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// Useful mapping functions for [ChannelEntity]
extension ChannelEntityX on ChannelEntity {
  /// Maps a [ChannelEntity] into [ChannelModel]
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

  /// Maps a [ChannelEntity] into [ChannelState]
  ChannelState toChannelState({
    User createdBy,
    List<Member> members,
    List<Read> reads,
    List<Message> messages,
    List<Message> pinnedMessages,
  }) {
    return ChannelState(
      members: members,
      read: reads,
      messages: messages,
      pinnedMessages: pinnedMessages,
      channel: toChannelModel(createdBy: createdBy),
    );
  }
}

/// Useful mapping functions for [ChannelModel]
extension ChannelModelX on ChannelModel {
  /// Maps a [ChannelModel] into [ChannelEntity]
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
