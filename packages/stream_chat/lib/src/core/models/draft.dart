import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_core/stream_core.dart' show Sort, SortField;

import 'channel_model.dart';
import 'draft_message.dart';
import 'message.dart';

part 'draft.g.dart';

/// A model class representing a draft message.
///
/// This class is used to store the draft message and its metadata.
@JsonSerializable(includeIfNull: false)
class Draft extends Equatable {
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
}

/// Represents a sorting operation for drafts.
///
/// The API sorts drafts by `createdAt` only. Anything else is rejected.
///
/// See [DraftSortField] for the fields that can be sorted on.
class DraftSort extends Sort<Draft> {
  /// Sorts by [field], smallest first.
  const DraftSort.asc(
    DraftSortField super.field, {
    super.nullOrdering,
  }) : super.asc();

  /// Sorts by [field], largest first.
  const DraftSort.desc(
    DraftSortField super.field, {
    super.nullOrdering,
  }) : super.desc();

  /// The ordering the API applies to a draft query when none is given.
  ///
  /// Sorts by when the draft was created, newest first.
  static final List<DraftSort> defaultSort = List.unmodifiable([
    DraftSort.desc(DraftSortField.createdAt),
  ]);
}

/// Represents a field that draft queries can be sorted on.
class DraftSortField extends SortField<Draft> {
  /// Creates a draft sort field named [remote] on the wire, reading its
  /// value off an instance with `localValue`.
  ///
  /// Prefer the fields this class declares — they are the ones the API accepts.
  /// This is for a field the SDK has not modelled yet.
  DraftSortField(super.remote, super.localValue);

  /// Sorts drafts by their creation date.
  ///
  /// This is the default sort field (in descending order).
  static final createdAt = DraftSortField(
    'created_at',
    (it) => it.createdAt,
  );
}
