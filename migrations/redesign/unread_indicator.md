# Unread Indicator Migration Guide

This guide covers the migration for the unread indicator components in the Stream Chat Flutter SDK design refresh.

---

## Table of Contents

- [StreamUnreadIndicator](#streamunreadindicator)
- [UnreadIndicatorButton](#unreadindicatorbutton)
- [Migration Checklist](#migration-checklist)

---

## StreamUnreadIndicator

`StreamUnreadIndicator` shows a small badge with an unread count. It now wraps `StreamBadgeNotification` (from `stream_core_flutter`) and the custom styling parameters have been removed.

### Breaking Changes

- `backgroundColor`, `textColor`, and `textStyle` constructor parameters removed — styling is now controlled via `StreamTheme`
- The widget is now wrapped in `IgnorePointer`; it does not respond to taps itself
- Now supports named constructors for different unread count types

### Named Constructors

| Constructor | Description |
|-------------|-------------|
| `StreamUnreadIndicator()` | Shows total unread message count |
| `StreamUnreadIndicator.channels({String? cid})` | Shows unread channel count; optionally filtered to a specific channel by `cid` |
| `StreamUnreadIndicator.threads({String? id})` | Shows unread thread count |

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
// Styling via StreamTheme — see README.md for theming setup
StreamUnreadIndicator()
```

> **Note:** The badge automatically displays `99+` for counts above 99.

---

## UnreadIndicatorButton

`UnreadIndicatorButton` is the floating button shown inside `StreamMessageListView` to indicate unread messages below. It has been completely redesigned.

### Breaking Changes

#### New layout (40px height Material container):
- Arrow-up icon → unread count label → vertical divider → dismiss (×) icon
- Replaces the old simple badge button

#### New callback types

| Type | Signature | Description |
|------|-----------|-------------|
| `OnUnreadIndicatorTap` | `Future<void> Function(String? lastReadMessageId)` | Called when the main area is tapped; receives the last-read message ID |
| `OnUnreadIndicatorDismissTap` | `Future<void> Function()` | Called when the dismiss (×) button is tapped |

Both callbacks are `Future<void>` — ensure your implementations are async-compatible.

#### New `UnreadIndicatorProps` class

A new `UnreadIndicatorProps` class carries configuration through the component factory:

```dart
class UnreadIndicatorProps {
  final int unreadCount;
  final OnUnreadIndicatorTap onTap;
  final OnUnreadIndicatorDismissTap onDismissTap;
}
```

### Constructor Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `onTap` | `OnUnreadIndicatorTap` | yes | Called when indicator is tapped; receives `lastReadMessageId` |
| `onDismissTap` | `OnUnreadIndicatorDismissTap` | yes | Called when dismiss button is tapped |
| `unreadIndicatorBuilder` | `UnreadIndicatorBuilder?` | no | Optional inline builder; takes priority over component factory |

### Migration

**Before:**
```dart
UnreadIndicatorButton(
  onTap: () => _scrollToUnread(),
  onDismiss: () => _markAllRead(),
)
```

**After:**
```dart
UnreadIndicatorButton(
  onTap: (lastReadMessageId) async => _scrollToUnread(lastReadMessageId),
  onDismissTap: () async => _markAllRead(),
)
```

### Customization via Component Factory

To fully replace the unread indicator button, provide a builder for `UnreadIndicatorProps`:

```dart
StreamComponentFactory(
  builders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      unreadIndicator: (context, props) => MyCustomUnreadButton(
        count: props.unreadCount,
        onTap: props.onTap,
        onDismiss: props.onDismissTap,
      ),
    ),
  ),
  child: ...,
)
```

Alternatively, pass `unreadIndicatorBuilder` directly to `UnreadIndicatorButton` for one-off overrides.

---

## Migration Checklist

- [ ] Remove `backgroundColor`, `textColor`, `textStyle` from `StreamUnreadIndicator` usages
- [ ] Use the appropriate named constructor (`StreamUnreadIndicator()`, `.channels()`, `.threads()`)
- [ ] Update `UnreadIndicatorButton` callbacks: `onDismiss` → `onDismissTap`, `onTap` now receives `String? lastReadMessageId`
- [ ] Make callback implementations `async` (return `Future<void>`)
- [ ] Move custom indicator layouts to `StreamComponentFactory` or `unreadIndicatorBuilder`
