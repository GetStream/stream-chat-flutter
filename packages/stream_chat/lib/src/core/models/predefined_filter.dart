import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/filter.dart';

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
  /// Wrapped in [Filter.raw] — the SDK does not evaluate filters locally.
  /// Access the underlying map via [Filter.value] or [Filter.toJson].
  @JsonKey(fromJson: _filterFromJson)
  final Filter filter;

  /// Sort specification as resolved by the server.
  final SortOrder<ChannelState>? sort;

  static Filter _filterFromJson(Map<String, dynamic> json) =>
      Filter.raw(value: json);
}
