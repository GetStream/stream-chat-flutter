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
  factory PredefinedFilter.fromJson(Map<String, dynamic> json) => _$PredefinedFilterFromJson(json);

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

  /// Sort to apply locally, matching what the server applies for this
  /// predefined filter — the echoed [sort], or a default derived from
  /// [filter] when [sort] is null.
  SortOrder<ChannelState> get effectiveSort => sort ?? _defaultSortFor(filter);

  static Filter _filterFromJson(Map<String, dynamic> json) => Filter.raw(value: json);
}

SortOrder<ChannelState> _defaultSortFor(Filter filter) {
  if (_touchesField(filter, ChannelSortKey.lastMessageAt)) {
    return const [SortOption<ChannelState>.desc(ChannelSortKey.lastMessageAt)];
  }
  return const [SortOption<ChannelState>.desc(ChannelSortKey.lastUpdated)];
}

bool _touchesField(Filter filter, String field) {
  if (filter.key == field) return true;
  final value = filter.value;
  if (value is List<Filter>) {
    return value.any((sub) => _touchesField(sub, field));
  }
  if (value is Map<String, Object?>) {
    return _mapTouchesField(value, field);
  }
  return false;
}

bool _mapTouchesField(Map<String, Object?> map, String field) {
  for (final entry in map.entries) {
    final key = entry.key;
    if (!key.startsWith(r'$')) {
      if (key == field) return true;
      continue;
    }
    // Group operator like $or / $and / $nor — recurse into list items.
    final value = entry.value;
    if (value is List) {
      for (final item in value) {
        if (item is Map<String, Object?> && _mapTouchesField(item, field)) {
          return true;
        }
      }
    }
  }
  return false;
}
