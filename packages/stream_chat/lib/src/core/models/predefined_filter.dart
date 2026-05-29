import 'package:json_annotation/json_annotation.dart';

part 'predefined_filter.g.dart';

/// The resolved predefined filter spec returned by the server.
///
/// When `predefined_filter` is provided on a `queryChannels` request, the
/// server resolves the template (interpolating any `filter_values` and
/// `sort_values`) and echoes the materialized `filter` and `sort` on the
/// response under this key.
@JsonSerializable(createToJson: false)
class PredefinedFilter {
  /// Creates a new instance.
  const PredefinedFilter({
    required this.name,
    required this.filter,
    this.sort,
  });

  /// Create a new instance from a json.
  factory PredefinedFilter.fromJson(Map<String, dynamic> json) =>
      _$PredefinedFilterFromJson(json);

  /// Identifier of the predefined filter on the server.
  final String name;

  /// Filter conditions as resolved by the server.
  ///
  /// Kept as a raw map; the SDK does not evaluate filters locally, so no
  /// [Filter] parser is required.
  final Map<String, dynamic> filter;

  /// Sort specification as resolved by the server.
  ///
  /// Each entry is a `{field, direction}` map that can be parsed via
  /// [SortOption.fromJson].
  final List<Map<String, dynamic>>? sort;
}
