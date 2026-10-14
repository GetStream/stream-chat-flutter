import 'package:stream_chat/stream_chat.dart';
import '../db/drift_chat_database.dart';

/// Useful mapping functions for [ChannelEntity]
extension ChannelEntityX on ChannelEntity {
  /// Maps a [ChannelEntity] into [ChannelModel]
  ChannelModel toChannelModel({User? createdBy, User? truncatedBy}) {
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
      messageCount: messageCount,
      cid: cid,
      lastMessageAt: lastMessageAt,
      deletedAt: deletedAt,
      createdBy: createdBy,
      filterTags: filterTags,
      team: team,
      custom: custom ?? {},
      disabled: disabled,
      hidden: hidden,
      muted: muted,
      blocked: blocked,
      truncatedAt: truncatedAt,
      truncatedBy: truncatedBy,
      autoTranslationEnabled: autoTranslationEnabled,
      autoTranslationLanguage: autoTranslationLanguage,
    );
  }

  /// Maps a [ChannelEntity] into [ChannelState]
  ChannelState toChannelState({
    User? createdBy,
    User? truncatedBy,
    List<Member> members = const [],
    List<Read> reads = const [],
    List<Message> messages = const [],
    List<Message> pinnedMessages = const [],
  }) => ChannelState(
    members: members,
    read: reads,
    messages: messages,
    pinnedMessages: pinnedMessages,
    channel: toChannelModel(createdBy: createdBy, truncatedBy: truncatedBy),
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
    messageCount: messageCount,
    createdById: createdBy?.id,
    filterTags: filterTags,
    team: team,
    custom: custom,
    disabled: disabled,
    hidden: hidden,
    muted: muted,
    blocked: blocked,
    truncatedAt: truncatedAt,
    truncatedById: truncatedBy?.id,
    autoTranslationEnabled: autoTranslationEnabled,
    autoTranslationLanguage: autoTranslationLanguage,
  );
}
