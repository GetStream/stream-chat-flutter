// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';

part 'requests.g.dart';

/// A list of [SortOption]s that define a sorting order for elements of type [T]
///
/// When multiple sort options are provided, they are applied in sequence
/// until a non-equal comparison is found.
///
/// Example: `Sort<ChannelState>([pinnedAtSort, lastMessageAtSort])`
typedef Sort<T extends ComparableFieldProvider> = List<SortOption<T>>;

/// Extension that allows a [Sort] to be used as a comparator function.
extension CompositeComparator<T extends ComparableFieldProvider> on Sort<T> {
  /// Compares two objects using all sort options in sequence.
  ///
  /// Returns the first non-zero comparison result, or 0 if all comparisons
  /// result in equality.
  ///
  /// ```dart
  /// channels.sort(mySort.compare);
  /// ```
  int compare(T a, T b) {
    for (final sortOption in this) {
      final comparison = sortOption.compare(a, b);
      if (comparison != 0) return comparison;
    }

    return 0; // All comparisons were equal
  }
}

/// A sort specification for objects that implement [ComparableFieldProvider].
///
/// Defines a field to sort by and a direction (ascending or descending).
/// Can use a custom comparator or create a default one based on the field name.
///
/// Example:
/// ```dart
/// // Sort channels by last message date in descending order
/// final sort = SortOption<ChannelState>("last_message_at");
/// ```
@JsonSerializable(includeIfNull: false)
class SortOption<T extends ComparableFieldProvider> {
  /// Creates a new SortOption instance with the specified field and direction.
  ///
  /// ```dart
  /// final sorting = SortOption("last_message_at") // Default: descending order
  /// ```
  const SortOption(
    this.field, {
    this.direction = SortOption.DESC,
    Comparator<T>? comparator,
  }) : _comparator = comparator;

  /// Creates a SortOption for descending order sorting by the specified field.
  ///
  /// Example:
  /// ```dart
  /// // Sort channels by last message date in descending order
  /// final sort = SortOption.desc("last_message_at");
  /// ```
  const SortOption.desc(
    this.field, {
    Comparator<T>? comparator,
  })  : direction = SortOption.DESC,
        _comparator = comparator;

  /// Creates a SortOption for ascending order sorting by the specified field.
  ///
  /// Example:
  /// ```dart
  /// // Sort channels by name in ascending order
  /// final sort = SortOption.asc("name");
  /// ```
  const SortOption.asc(
    this.field, {
    Comparator<T>? comparator,
  })  : direction = SortOption.ASC,
        _comparator = comparator;

  /// Create a new instance from JSON.
  factory SortOption.fromJson(Map<String, dynamic> json) =>
      _$SortOptionFromJson(json);

  /// Ascending order (1)
  static const ASC = 1;

  /// Descending order (-1)
  static const DESC = -1;

  /// The field name to sort by
  final String field;

  /// The sort direction (ASC or DESC)
  final int direction;

  /// Compares two objects of type T using the specified field and direction.
  ///
  /// Returns:
  /// - 0 if both objects are equal
  /// - 1 if the first object is greater than the second
  /// - -1 if the first object is less than the second
  ///
  /// Handles null values by treating null as less than any non-null value.
  ///
  /// ```dart
  /// final sortOption = SortOption<ChannelState>("last_message_at");
  /// final sortedChannels = channels.sort(sortOption.compare);
  /// ```
  int compare(T a, T b) => direction * comparator(a, b);

  /// Returns a comparator function for sorting objects of type T.
  @JsonKey(includeToJson: false, includeFromJson: false)
  Comparator<T> get comparator {
    if (_comparator case final comparator?) return comparator;

    return (T a, T b) {
      final aValue = a.getComparableField(field);
      final bValue = b.getComparableField(field);

      // Handle null values
      if (aValue == null && bValue == null) return 0;
      if (aValue == null) return -1;
      if (bValue == null) return 1;

      return aValue.compareTo(bValue);
    };
  }

  final Comparator<T>? _comparator;

  /// Converts this option to JSON.
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
