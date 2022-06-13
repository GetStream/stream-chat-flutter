import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [ChannelEntity]
extension ChannelEntityX on ChannelEntity {
  /// Maps a [ChannelEntity] into [ChannelModel]
  ChannelModel toChannelModel({User? createdBy}) {
    final config = ChannelConfig.fromJson(this.config);
    return ChannelModel(
      id: id,
      ownCapabilities: ownCapabilities,
      config: config,
      type: type,
      frozen: frozen,
      createdAt: createdAt,
      updatedAt: updatedAt,
      memberCount: memberCount,
      cid: cid,
      lastMessageAt: lastMessageAt,
      deletedAt: deletedAt,
      extraData: extraData ?? {},
      createdBy: createdBy,
    );
  }

  /// Maps a [ChannelEntity] into [ChannelState]
  ChannelState toChannelState({
    User? createdBy,
    List<Member> members = const [],
    List<Read> reads = const [],
    List<Message> messages = const [],
    List<Message> pinnedMessages = const [],
  }) =>
      ChannelState(
        members: members,
        read: reads,
        messages: messages,
        pinnedMessages: pinnedMessages,
        channel: toChannelModel(createdBy: createdBy),
      );
}

/// Useful mapping functions for [ChannelModel]
extension ChannelModelX on ChannelModel {
  /// Maps a [ChannelModel] into [ChannelEntity]
  ChannelEntity toEntity() => ChannelEntity(
        id: id,
        type: type,
        cid: cid,
        ownCapabilities: ownCapabilities,
        config: config.toJson(),
        frozen: frozen,
        lastMessageAt: lastMessageAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
        memberCount: memberCount,
        createdById: createdBy?.id,
        extraData: extraData,
      );
}
