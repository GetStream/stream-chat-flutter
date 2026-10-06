import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_core/stream_core.dart' show Filter, FilterField, Sort, SortField;

import 'user.dart';

part 'reaction.freezed.dart';

/// A reaction a user added to a message.
@Freezed(copyWith: false)
class Reaction with _$Reaction {
  /// Creates a new [Reaction].
  ///
  /// [userId] defaults to the id of [user], and [createdAt] and [updatedAt] default to now.
  Reaction({
    this.messageId,
    required this.type,
    this.user,
    String? userId,
    this.score = 1,
    this.emojiCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.extraData = const {},
  }) : userId = userId ?? user?.id,
       createdAt = createdAt ?? DateTime.timestamp(),
       updatedAt = updatedAt ?? DateTime.timestamp();

  /// The messageId to which the reaction belongs
  @override
  final String? messageId;

  /// The type of the reaction
  @override
  final String type;

  /// The score of the reaction (ie. number of reactions sent)
  @override
  final int score;

  /// The emoji code of the reaction (used for notifications)
  @override
  final String? emojiCode;

  /// The user that sent the reaction
  @override
  final User? user;

  /// The userId that sent the reaction
  @override
  final String? userId;

  /// The date of the reaction
  @override
  final DateTime createdAt;

  /// The date of the reaction update
  @override
  final DateTime updatedAt;

  /// Reaction custom extraData
  @override
  final Map<String, Object?> extraData;

  /// Map of custom user extraData
  static const topLevelFields = [
    'message_id',
    'type',
    'user',
    'user_id',
    'score',
    'emoji_code',
    'created_at',
    'updated_at',
  ];

  /// Creates a copy of [Reaction] with specified attributes overridden.
  Reaction copyWith({
    String? messageId,
    String? type,
    User? user,
    String? userId,
    int? score,
    String? emojiCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, Object?>? extraData,
  }) => Reaction(
    messageId: messageId ?? this.messageId,
    type: type ?? this.type,
    user: user ?? this.user,
    userId: userId ?? this.userId,
    score: score ?? this.score,
    emojiCode: emojiCode ?? this.emojiCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    extraData: extraData ?? this.extraData,
  );

  /// Returns a new [Reaction] that is a combination of this reaction and the
  /// given [other] reaction.
  Reaction merge(Reaction other) => copyWith(
    messageId: other.messageId,
    type: other.type,
    user: other.user,
    userId: other.userId,
    score: other.score,
    emojiCode: other.emojiCode,
    createdAt: other.createdAt,
    updatedAt: other.updatedAt,
    extraData: other.extraData,
  );
}

/// A filter for a reaction query.
///
/// See [ReactionFilterField] for the fields that can be filtered on.
///
/// ```dart
/// final filter = ReactionFilter.equal(ReactionFilterField.type, 'like');
/// ```
typedef ReactionFilter = Filter<Reaction>;

/// Represents a field that reaction queries can be filtered on.
class ReactionFilterField extends FilterField<Reaction> {
  /// Creates a reaction filter field named [remote] in queries, reading its
  /// value off an instance with [value].
  ReactionFilterField(super.remote, super.value);

  /// Filters reactions by their type.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final type = ReactionFilterField(
    'type',
    (it) => it.type,
  );

  /// Filters reactions by the id of the user who sent them.
  ///
  /// **Supported operators:** `$eq`, `$in`
  static final userId = ReactionFilterField(
    'user_id',
    (it) => it.userId,
  );

  /// Filters reactions by their creation date.
  ///
  /// **Supported operators:** `$eq`, `$in`, `$gt`, `$gte`, `$lt`, `$lte`,
  /// `$exists`
  static final createdAt = ReactionFilterField(
    'created_at',
    (it) => it.createdAt,
  );
}

/// Represents a sorting operation for reactions.
///
/// See [ReactionSortField] for the fields that can be sorted on.
///
/// ```dart
/// final sort = [ReactionSort.desc(ReactionSortField.createdAt)];
/// ```
class ReactionSort extends Sort<Reaction> {
  /// Sorts by [field], smallest first.
  const ReactionSort.asc(
    ReactionSortField super.field, {
    super.nullOrdering,
  }) : super.asc();

  /// Sorts by [field], largest first.
  const ReactionSort.desc(
    ReactionSortField super.field, {
    super.nullOrdering,
  }) : super.desc();

  /// An empty sort: the query carries no sort term, and a list keeps the
  /// order it arrived in.
  static const List<ReactionSort> empty = [];

  /// The ordering the API applies to a reaction query when none is given.
  ///
  /// Sorts by when the reaction was added, newest first.
  static final List<ReactionSort> defaultSort = [
    ReactionSort.desc(ReactionSortField.createdAt),
  ];
}

/// Represents a field that reaction queries can be sorted on.
class ReactionSortField extends SortField<Reaction> {
  /// Creates a field named [remote] in queries, reading its value off an
  /// instance with `localValue`.
  ///
  /// For a name the SDK has not modelled; prefer the fields declared here.
  ReactionSortField(super.remote, super.localValue);

  /// Sorts reactions by their creation date.
  ///
  /// This is the default sort field (in descending order).
  static final createdAt = ReactionSortField(
    'created_at',
    (it) => it.createdAt,
  );
}
