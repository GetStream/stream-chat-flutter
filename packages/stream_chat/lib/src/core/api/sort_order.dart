// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';

part 'sort_order.g.dart';

/// A list of [SortOption]s that define a sorting order for elements of type [T]
///
/// When multiple sort options are provided, they are applied in sequence
/// until a non-equal comparison is found.
///
/// Example: `Sort<ChannelState>([pinnedAtSort, lastMessageAtSort])`
typedef SortOrder<T extends ComparableFieldProvider> = List<SortOption<T>>;

/// Defines how null values should be ordered in a sort operation.
enum NullOrdering {
  /// Null values are treated as less than any non-null value.
  nullsFirst,

  /// Null values are treated as greater than any non-null value.
  nullsLast,
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
    this.nullOrdering = NullOrdering.nullsFirst,
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
        nullOrdering = NullOrdering.nullsFirst,
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
        nullOrdering = NullOrdering.nullsLast,
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

  /// The null ordering strategy to use when comparing null values.
  ///
  /// Defaults to `NullOrdering.nullsFirst`, which treats null values as less
  /// than any non-null value.
  @JsonKey(includeToJson: false)
  final NullOrdering nullOrdering;

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

      return _compareNullableFields(aValue, bValue);
    };
  }

  final Comparator<T>? _comparator;

  int _compareNullableFields(ComparableField? a, ComparableField? b) {
    if (a == null && b == null) return 0;
    if (a == null) return nullOrdering == NullOrdering.nullsFirst ? -1 : 1;
    if (b == null) return nullOrdering == NullOrdering.nullsFirst ? 1 : -1;

    return a.compareTo(b);
  }

  /// Converts this option to JSON.
  Map<String, dynamic> toJson() => _$SortOptionToJson(this);
}

/// Extension that allows a [SortOrder] to be used as a comparator function.
extension CompositeComparator<T extends ComparableFieldProvider>
    on SortOrder<T> {
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
