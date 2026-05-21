# Unread Indicator Button Migration

## Overview

The unread indicator in `StreamMessageListView` has been rebuilt on top of
`StreamJumpToUnreadButton` — a new design-system component in
`stream_core_flutter`. The old hand-rolled `Material` / `InkWell` / `Row`
implementation and its associated typedefs have been removed in favour of the
reusable, fully themeable component.

## Breaking Changes

### 1. `UnreadIndicatorBuilder` typedef — removed

The `UnreadIndicatorBuilder`, `OnUnreadIndicatorTap`, and
`OnUnreadIndicatorDismissTap` typedefs no longer exist.

### 2. `UnreadIndicatorProps` class — removed

The chat-level `UnreadIndicatorProps` class has been removed. Customisation now
goes through `StreamJumpToUnreadButtonProps` (from `stream_core_flutter`) via
the `StreamComponentFactory`.

### 3. `StreamMessageListView.unreadIndicatorBuilder` parameter — removed

The per-instance builder parameter on `StreamMessageListView` has been removed.
Use `StreamComponentFactory` instead for app-wide customisation.

### 4. `UnreadIndicatorButton` callback renames

| Before         | After          |
| -------------- | -------------- |
| `onTap`        | `onJumpTap`    |
| `onDismissTap` | `onDismissTap` |

### 5. `streamChatComponentBuilders` — `unreadIndicator` parameter removed

The `unreadIndicator` parameter has been removed from the
`streamChatComponentBuilders()` helper. Register a builder for
`StreamJumpToUnreadButtonProps` via `StreamComponentFactory` instead.

## Migration Guide

### Using `unreadIndicatorBuilder` on `StreamMessageListView`

**Before:**

```dart
StreamMessageListView(
  unreadIndicatorBuilder: (unreadCount, onTap, onDismissTap) {
    return MyCustomUnreadBanner(
      count: unreadCount,
      onTap: () => onTap(null),
      onDismiss: onDismissTap,
    );
  },
)
```

**After — use `StreamComponentFactory`:**

```dart
StreamChat(
  client: client,
  componentBuilders: StreamComponentBuilders(
    jumpToUnreadButton: (context, props) {
      return MyCustomUnreadBanner(
        label: props.label,
        onTap: props.onJumpPressed,
        onDismiss: props.onDismissPressed,
      );
    },
  ),
  child: // ...
)
```

The `StreamMessageListView` no longer needs any parameter — just remove
`unreadIndicatorBuilder`.

### Using `streamChatComponentBuilders` with `unreadIndicator`

**Before:**

```dart
streamChatComponentBuilders(
  unreadIndicator: (context, props) {
    return MyCustomWidget(
      count: props.unreadCount,
      onTap: () => props.onTap(null),
      onDismiss: props.onDismissTap,
    );
  },
)
```

**After — use the core factory's `jumpToUnreadButton`:**

```dart
StreamComponentBuilders(
  jumpToUnreadButton: (context, props) {
    return MyCustomWidget(
      label: props.label,
      onTap: props.onJumpPressed,
      onDismiss: props.onDismissPressed,
    );
  },
)
```

### Theming the default indicator

The new `StreamJumpToUnreadButton` is fully themeable without replacing the
widget. Wrap any ancestor with `StreamJumpToUnreadButtonTheme` or configure it
in your `StreamTheme`:

```dart
StreamJumpToUnreadButtonTheme(
  data: StreamJumpToUnreadButtonThemeData(
    backgroundColor: Colors.blue.shade50,
    elevation: 0,
    shape: const StadiumBorder(),
    side: const BorderSide(color: Colors.blue),
    leadingStyle: StreamButtonThemeStyle(
      foregroundColor: const WidgetStatePropertyAll(Colors.blue),
    ),
    trailingStyle: StreamButtonThemeStyle(
      foregroundColor: const WidgetStatePropertyAll(Colors.blue),
    ),
  ),
  child: // ...
)
```

### Direct `UnreadIndicatorButton` usage

If you were using `UnreadIndicatorButton` directly (rare), update the callback
names:

**Before:**

```dart
UnreadIndicatorButton(
  onTap: scrollToUnread,
  onDismissTap: markAsRead,
  unreadIndicatorBuilder: myBuilder,
)
```

**After:**

```dart
UnreadIndicatorButton(
  onJumpTap: scrollToUnread,
  onDismissTap: markAsRead,
)
```

## Props Mapping Reference

| Old (`UnreadIndicatorProps`) | New (`StreamJumpToUnreadButtonProps`) |
| ---------------------------- | ------------------------------------- |
| `unreadCount` (int)          | `label` (String) — pre-formatted      |
| `onTap` (callback)           | `onJumpPressed` (VoidCallback?)       |
| `onDismissTap` (callback)    | `onDismissPressed` (VoidCallback?)    |
| —                            | `leadingIcon` (IconData?)             |
| —                            | `trailingIcon` (IconData?)            |
