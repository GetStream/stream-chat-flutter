import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/draft_message.dart';
import 'package:stream_chat/src/core/models/message.dart';

part 'draft.g.dart';

/// A model class representing a draft message.
///
/// This class is used to store the draft message and its metadata.
@JsonSerializable(includeIfNull: false)
class Draft extends Equatable implements ComparableFieldProvider {
  /// Creates a new instance of [Draft].
  const Draft({
    required this.channelCid,
    required this.createdAt,
    required this.message,
    this.channel,
    this.parentId,
    this.parentMessage,
    this.quotedMessage,
  });

  /// Create a new instance from a json
  factory Draft.fromJson(Map<String, dynamic> json) => _$DraftFromJson(json);

  /// The channel cid this draft belongs to.
  final String channelCid;

  /// The date at which the draft was created.
  final DateTime createdAt;

  /// The draft message.
  final DraftMessage message;

  /// The channel this draft belongs to.
  final ChannelModel? channel;

  /// The ID of the parent message, if the message is a thread reply.
  final String? parentId;

  /// The parent message, if the message is a thread reply.
  final Message? parentMessage;

  /// The quoted message, if the message is a quoted reply.
  final Message? quotedMessage;

  /// Convert the object to JSON
  Map<String, dynamic> toJson() => _$DraftToJson(this);

  /// Creates a copy of this [Draft] with specified attributes overridden.
  Draft copyWith({
    String? channelCid,
    DateTime? createdAt,
    DraftMessage? message,
    ChannelModel? channel,
    String? parentId,
    Message? parentMessage,
    Message? quotedMessage,
  }) {
    return Draft(
      channelCid: channelCid ?? this.channelCid,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
      channel: channel ?? this.channel,
      parentId: parentId ?? this.parentId,
      parentMessage: parentMessage ?? this.parentMessage,
      quotedMessage: quotedMessage ?? this.quotedMessage,
    );
  }

  @override
  List<Object?> get props => [
        channelCid,
        createdAt,
        message,
        channel,
        parentId,
        parentMessage,
        quotedMessage,
      ];

  @override
  ComparableField? getComparableField(String sortKey) {
    final value = switch (sortKey) {
      DraftSortKey.createdAt => createdAt,
      _ => message.extraData[sortKey],
    };

    return ComparableField.fromValue(value);
  }
}

/// Extension type representing sortable fields for [Draft].
///
/// This type provides type-safe keys that can be used for sorting drafts
/// in queries. Each constant represents a field that can be sorted on.
extension type const DraftSortKey(String key) implements String {
  /// Sort drafts by their creation date.
  ///
  /// This is the default sort field (in descending order).
  static const createdAt = DraftSortKey('created_at');
}
