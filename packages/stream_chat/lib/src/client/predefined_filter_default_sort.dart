import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/filter.dart';

/// Fallback sort applied when the server doesn't echo back a sort spec for a
/// predefined-filter query, so the persisted spec is never null.
///
/// Picks the sort field that matches the filter's time predicate (if any),
/// falling back to `last_updated` otherwise — this mirrors the server's
/// default sort for channel queries.
SortOrder<ChannelState> defaultChannelStateSortFor(Filter filter) {
  if (_filterTouchesField(filter, 'last_message_at')) {
    return const [SortOption<ChannelState>.desc(ChannelSortKey.lastMessageAt)];
  }
  return const [SortOption<ChannelState>.desc(ChannelSortKey.lastUpdated)];
}

bool _filterTouchesField(Filter filter, String field) {
  if (filter.key == field) return true;
  final value = filter.value;
  if (value is List<Filter>) {
    return value.any((sub) => _filterTouchesField(sub, field));
  }
  if (value is Map<String, Object?>) {
    return _filterMapTouchesField(value, field);
  }
  return false;
}

bool _filterMapTouchesField(Map<String, Object?> map, String field) {
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
        if (item is Map<String, Object?> && _filterMapTouchesField(item, field)) {
          return true;
        }
      }
    }
  }
  return false;
}
