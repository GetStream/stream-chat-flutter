import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/filter.dart';

/// Defaults used in the predefined-filter query flow.
extension PredefinedFilterDefaults on Filter {
  /// Fallback sort applied when the server doesn't echo back a sort spec
  /// for a predefined-filter query, so the persisted spec is never null.
  ///
  /// Picks the sort field that matches the filter's time predicate (if any),
  /// falling back to `last_updated` otherwise — this mirrors the server's
  /// default sort for channel queries.
  SortOrder<ChannelState> get predefinedFilterFallbackSort {
    if (_touchesField('last_message_at')) {
      return const [
        SortOption<ChannelState>.desc(ChannelSortKey.lastMessageAt)
      ];
    }
    return const [SortOption<ChannelState>.desc(ChannelSortKey.lastUpdated)];
  }

  bool _touchesField(String field) {
    if (key == field) return true;
    final v = value;
    if (v is List<Filter>) {
      return v.any((sub) => sub._touchesField(field));
    }
    if (v is Map<String, Object?>) {
      return _mapTouchesField(v, field);
    }
    return false;
  }
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
