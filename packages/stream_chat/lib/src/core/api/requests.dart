import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'requests.g.dart';

/// Pagination options.
@JsonSerializable(includeIfNull: false)
class PaginationParams extends Equatable {
  /// Creates a new PaginationParams instance
  ///
  /// For example:
  /// ```dart
  /// // limit to 50
  /// final paginationParams = PaginationParams(limit: 50);
  ///
  /// // limit to 50 with offset
  /// final paginationParams = PaginationParams(limit: 50, offset: 50);
  /// ```
  const PaginationParams({
    this.limit = 10,
    this.offset,
    this.next,
    this.idAround,
    this.greaterThan,
    this.greaterThanOrEqual,
    this.lessThan,
    this.lessThanOrEqual,
    this.createdAtAfterOrEqual,
    this.createdAtAfter,
    this.createdAtBeforeOrEqual,
    this.createdAtBefore,
    this.createdAtAround,
  }) : assert(
          offset == null || offset == 0 || next == null,
          'Cannot specify non-zero `offset` with `next` parameter',
        );

  /// Create a new instance from a json
  factory PaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);

  /// The amount of items requested from the APIs.
  final int limit;

  /// The offset of requesting items.
  final int? offset;

  /// A key used to paginate.
  final String? next;

  /// Message ID to fetch messages around
  @JsonKey(name: 'id_around')
  final String? idAround;

  /// Filter on ids greater than the given value.
  @JsonKey(name: 'id_gt')
  final String? greaterThan;

  /// Filter on ids greater than or equal to the given value.
  @JsonKey(name: 'id_gte')
  final String? greaterThanOrEqual;

  /// Filter on ids smaller than the given value.
  @JsonKey(name: 'id_lt')
  final String? lessThan;

  /// Filter on ids smaller than or equal to the given value.
  @JsonKey(name: 'id_lte')
  final String? lessThanOrEqual;

  /// Filter on createdAt greater than or equal the given value.
  @JsonKey(name: 'created_at_after_or_equal')
  final DateTime? createdAtAfterOrEqual;

  /// Filter on createdAt greater than the given value.
  @JsonKey(name: 'created_at_after')
  final DateTime? createdAtAfter;

  /// Filter on createdAt smaller than or equal the given value.
  @JsonKey(name: 'created_at_before_or_equal')
  final DateTime? createdAtBeforeOrEqual;

  /// Filter on createdAt smaller than the given value.
  @JsonKey(name: 'created_at_before')
  final DateTime? createdAtBefore;

  /// Filter on createdAt around the given value.
  @JsonKey(name: 'created_at_around')
  final DateTime? createdAtAround;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);

  /// Creates a copy of [PaginationParams] with specified attributes overridden.
  PaginationParams copyWith({
    int? limit,
    int? before,
    int? after,
    int? offset,
    String? idAround,
    String? next,
    String? greaterThan,
    String? greaterThanOrEqual,
    String? lessThan,
    String? lessThanOrEqual,
    DateTime? createdAtAfterOrEqual,
    DateTime? createdAtAfter,
    DateTime? createdAtBeforeOrEqual,
    DateTime? createdAtBefore,
    DateTime? createdAtAround,
  }) =>
      PaginationParams(
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        idAround: idAround ?? this.idAround,
        next: next ?? this.next,
        greaterThan: greaterThan ?? this.greaterThan,
        greaterThanOrEqual: greaterThanOrEqual ?? this.greaterThanOrEqual,
        lessThan: lessThan ?? this.lessThan,
        lessThanOrEqual: lessThanOrEqual ?? this.lessThanOrEqual,
        createdAtAfterOrEqual:
            createdAtAfterOrEqual ?? this.createdAtAfterOrEqual,
        createdAtAfter: createdAtAfter ?? this.createdAtAfter,
        createdAtBeforeOrEqual:
            createdAtBeforeOrEqual ?? this.createdAtBeforeOrEqual,
        createdAtBefore: createdAtBefore ?? this.createdAtBefore,
        createdAtAround: createdAtAround ?? this.createdAtAround,
      );

  @override
  List<Object?> get props => [
        limit,
        offset,
        next,
        idAround,
        greaterThan,
        greaterThanOrEqual,
        lessThan,
        lessThanOrEqual,
      ];
}

/// Request model for the [client.partialUpdateUser] api call.
@JsonSerializable(createFactory: false)
class PartialUpdateUserRequest extends Equatable {
  /// Creates a new PartialUpdateUserRequest instance.
  const PartialUpdateUserRequest({
    required this.id,
    this.set,
    this.unset,
  });

  /// User ID.
  final String id;

  /// Fields to set.
  final Map<String, Object?>? set;

  /// Fields to unset.
  final List<String>? unset;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$PartialUpdateUserRequestToJson(this);

  @override
  List<Object?> get props => [id, set, unset];
}

/// {@template threadOptions}
/// Options for querying threads.
/// {@endtemplate}
@JsonSerializable(createFactory: false)
class ThreadOptions extends Equatable {
  /// {@macro threadOptions}
  const ThreadOptions({
    this.watch = true,
    this.replyLimit = 2,
    this.participantLimit = 100,
    this.memberLimit = 100,
  });

  /// If true, the client will watch for changes in the thread.
  ///
  /// Defaults to true.
  final bool watch;

  /// The number of most recent replies to return per thread.
  ///
  /// Defaults to 2.
  final int replyLimit;

  /// The number of thread participants to return per thread.
  ///
  /// Defaults to 100.
  final int participantLimit;

  /// The number of members to return per thread.
  ///
  /// Defaults to 100.
  final int memberLimit;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$ThreadOptionsToJson(this);

  @override
  List<Object?> get props => [watch, replyLimit, participantLimit, memberLimit];
}

/// Payload for updating a member.
@JsonSerializable(createFactory: false, includeIfNull: false)
class MemberUpdatePayload {
  /// Creates a new MemberUpdatePayload instance.
  const MemberUpdatePayload({
    this.archived,
    this.pinned,
  });

  /// Set to true to archive the channel for a user.
  final bool? archived;

  /// Set to true to pin the channel for a user.
  final bool? pinned;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$MemberUpdatePayloadToJson(this);
}

/// Type of member update to unset.
enum MemberUpdateType {
  /// Unset the archived flag.
  archived,

  /// Unset the pinned flag.
  pinned,
}
