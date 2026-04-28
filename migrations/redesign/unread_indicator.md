# Unread Indicator Migration Guide

This guide covers the migration for `StreamUnreadIndicator` — the small badge
that shows an unread count.

For the floating jump-to-unread button shown inside `StreamMessageListView`,
see [unread_indicator_button.md](unread_indicator_button.md).

---

## StreamUnreadIndicator

`StreamUnreadIndicator` shows a small badge with an unread count. It now wraps
`StreamBadgeNotification` (from `stream_core_flutter`) and the custom styling
parameters have been removed.

### Breaking Changes

- `backgroundColor`, `textColor`, and `textStyle` constructor parameters
  removed — styling is now controlled via `StreamTheme`.
- The widget is now wrapped in `IgnorePointer`; it does not respond to taps
  itself.
- Now supports named constructors for different unread count types.

### Named Constructors

| Constructor | Description |
|-------------|-------------|
| `StreamUnreadIndicator()` | Shows total unread message count |
| `StreamUnreadIndicator.channels({String? cid})` | Shows unread channel count; optionally filtered to a specific channel by `cid` |
| `StreamUnreadIndicator.threads({String? id})` | Shows unread thread count |

### Overlay Mode

`StreamUnreadIndicator` can now be overlaid on top of another widget by
passing a `child`. When `child` is non-null, the badge is positioned over the
child using `alignment` and `offset`.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget?` | `null` | Widget to overlay the badge on. When `null`, only the badge is rendered. |
| `alignment` | `AlignmentGeometry?` | `AlignmentDirectional.topEnd` | Alignment of the badge relative to `child`. |
| `offset` | `Offset?` | `Offset(8, -6)` (mirrored in RTL) | Pixel offset applied after `alignment`. |

```dart
// Standalone badge (no child).
const StreamUnreadIndicator()

// Badge overlaid on an icon.
StreamUnreadIndicator(child: Icon(Icons.chat_bubble_outline))
```

### Migration

**Before:**
```dart
StreamUnreadIndicator(
  backgroundColor: Colors.red,
  textColor: Colors.white,
  textStyle: TextStyle(fontSize: 12),
)
```

**After:**
```dart
// Styling via StreamTheme — see README.md for theming setup.
StreamUnreadIndicator()
```

> **Note:** The badge automatically displays `99+` for counts above 99.

---

## Migration Checklist

- [ ] Remove `backgroundColor`, `textColor`, `textStyle` from
      `StreamUnreadIndicator` usages.
- [ ] Use the appropriate named constructor (`StreamUnreadIndicator()`,
      `.channels()`, `.threads()`).
- [ ] If overlaying the badge on an icon or button, pass it as `child` instead
      of wrapping `StreamUnreadIndicator` in a `Stack`.
- [ ] For the floating jump-to-unread button inside `StreamMessageListView`,
      follow [unread_indicator_button.md](unread_indicator_button.md).
