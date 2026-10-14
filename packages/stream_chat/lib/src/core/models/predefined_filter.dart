import 'package:json_annotation/json_annotation.dart';
import 'channel_state.dart';

part 'predefined_filter.g.dart';

/// A predefined filter, resolved for one channel query.
///
/// When a channel query names a predefined filter, its template is filled in
/// with the filter and sort values the query supplies, and the filter and sort
/// it resolves to come back with the channels.
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

  /// The name of the predefined filter.
  final String name;

  /// The filter conditions the predefined filter resolved to.
  ///
  /// Wrapped in [ChannelFilter.raw], since it is not authored here and may use an
  /// operator this package does not model. Read it with [ChannelFilter.toJson];
  /// [ChannelFilter.matches] throws for it.
  @JsonKey(fromJson: _filterFromJson)
  final ChannelFilter filter;

  /// The sort the predefined filter resolved to, if it names one.
  final List<ChannelSort>? sort;

  /// The sort that reproduces this predefined filter's ordering locally.
  ///
  /// This is [sort], or a default derived from [filter] when [sort] is null.
  List<ChannelSort> get effectiveSort => sort ?? _defaultSortFor(filter);

  static ChannelFilter _filterFromJson(Map<String, dynamic> json) => ChannelFilter.raw(json);
}

// Mirrors the ordering a channel query with no sort falls back to, so the field
// is written out rather than taken from [ChannelSort.defaultSort]: the two agree
// today, but one is the ordering this SDK picks and the other is the query's
// fallback, and either may change alone.
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
