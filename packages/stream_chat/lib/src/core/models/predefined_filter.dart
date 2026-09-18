import 'package:json_annotation/json_annotation.dart';
import 'channel_state.dart';

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
  /// Wrapped in [ChannelFilter.raw], since the server authors it and may use an
  /// operator this package does not model. Read it with [ChannelFilter.toJson];
  /// [ChannelFilter.matches] throws for it.
  @JsonKey(fromJson: _filterFromJson)
  final ChannelFilter filter;

  /// Sort specification as resolved by the server.
  final List<ChannelSort>? sort;

  /// Sort to apply locally, matching what the server applies for this
  /// predefined filter — the echoed [sort], or a default derived from
  /// [filter] when [sort] is null.
  List<ChannelSort> get effectiveSort => sort ?? _defaultSortFor(filter);

  static ChannelFilter _filterFromJson(Map<String, dynamic> json) => ChannelFilter.raw(json);
}

// Mirrors the server's fallback for a channel query that carries no sort, so
// the field is written out rather than taken from [ChannelSort.defaultSort]:
// the two agree today, but one is the ordering this SDK picks and the other is
// the ordering the server falls back to, and either may change alone.
List<ChannelSort> _defaultSortFor(ChannelFilter filter) {
  final lastMessageAt = ChannelSortField.lastMessageAt;
  if (_mapTouchesField(filter.toJson(), lastMessageAt.remote)) {
    return [ChannelSort.desc(lastMessageAt)];
  }
  return [ChannelSort.desc(ChannelSortField.lastUpdated)];
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
