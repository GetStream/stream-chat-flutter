import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'requests.g.dart';

/// Sorting options
@JsonSerializable(includeIfNull: false)
class SortOption<T> {
  /// Creates a new SortOption instance
  ///
  /// For example:
  /// ```dart
  /// // Sort channels by the last message date:
  /// final sorting = SortOption("last_message_at")
  /// ```
  const SortOption(
    this.field, {
    this.direction = SortOption.DESC,
    this.comparator,
  });

  /// Create a new instance from a json
  factory SortOption.fromJson(Map<String, dynamic> json) =>
      _$SortOptionFromJson(json);

  /// Ascending order
  // ignore: constant_identifier_names
  static const ASC = 1;

  /// Descending order
  // ignore: constant_identifier_names
  static const DESC = -1;

  /// A sorting field name
  final String field;

  /// A sorting direction
  final int direction;

  /// Sorting field Comparator required for offline sorting
  @JsonKey(ignore: true)
  final Comparator<T>? comparator;

  /// Serialize model to json
  Map<String, dynamic> toJson() => _$SortOptionToJson(this);
}

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
    this.before = 10,
    this.after = 10,
    this.offset,
    this.next,
    this.idAround,
    this.greaterThan,
    this.greaterThanOrEqual,
    this.lessThan,
    this.lessThanOrEqual,
  }) : assert(
          offset == null || offset == 0 || next == null,
          'Cannot specify non-zero `offset` with `next` parameter',
        );

  /// Create a new instance from a json
  factory PaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);

  /// The amount of items requested from the APIs.
  final int limit;

  /// The amount of items requested before message ID from the APIs.
  final int before;

  /// The amount of items requested after message ID from the APIs.
  final int after;

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
  }) =>
      PaginationParams(
        limit: limit ?? this.limit,
        before: before ?? this.before,
        after: limit ?? this.after,
        offset: offset ?? this.offset,
        idAround: idAround ?? this.idAround,
        next: next ?? this.next,
        greaterThan: greaterThan ?? this.greaterThan,
        greaterThanOrEqual: greaterThanOrEqual ?? this.greaterThanOrEqual,
        lessThan: lessThan ?? this.lessThan,
        lessThanOrEqual: lessThanOrEqual ?? this.lessThanOrEqual,
      );

  @override
  List<Object?> get props => [
        limit,
        before,
        after,
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
