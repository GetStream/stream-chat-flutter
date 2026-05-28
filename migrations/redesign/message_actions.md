# Message Actions Migration Guide

This guide covers the migration for the redesigned message action components in Stream Chat Flutter SDK.

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [StreamMessageAction → StreamContextMenuAction](#streammessageaction--streamcontextmenuaction)
- [StreamMessageActionItem](#streammessageactionitem)
- [StreamMessageActionsModal](#streammessageactionsmodal)
- [StreamMessageReactionsModal](#streammessagereactionsmodal)
- [ModeratedMessageActionsModal](#moderatedmessageactionsmodal)
- [StreamMessageItem.customActions → actionsBuilder](#streammessageitemcustomactions)
- [StreamMessageActionsBuilder](#streammessageactionsbuilder)
- [New Components](#new-components)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Symbol                                                 | Change                                                                                      |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------- |
| `StreamMessageAction`                                  | **Removed** — replaced by `StreamContextMenuAction<T>`                                      |
| `StreamMessageActionItem`                              | **Removed** — rendering built into `StreamContextMenuAction`                                |
| `StreamMessageActionsModal.onActionTap`                | **Removed** — use `onTap` per-action or await the dialog return value                       |
| `StreamMessageActionsModal.messageActions`             | **Type changed**: `List<StreamMessageAction>` → `List<Widget>`                              |
| `StreamMessageActionsModal.reverse`                    | **Removed** — use `alignment: AlignmentGeometry?`                                           |
| `StreamMessageActionsModal.reactionPickerBuilder`      | **Removed** — use `showReactionPicker: bool`                                                |
| `StreamMessageReactionsModal`                          | **Deleted** — use `ReactionDetailSheet` (see [reaction_list.md](reaction_list.md))          |
| `StreamMessageReactionsModal.onReactionPicked`         | **Removed** — await the dialog return value (`SelectReaction`)                              |
| `ModeratedMessageActionsModal.onActionTap`             | **Removed** — await the dialog return value (`MessageAction?`)                              |
| `ModeratedMessageActionsModal.messageActions`          | **Type changed**: `List<StreamMessageAction>` → `List<StreamContextMenuAction>`             |
| `StreamMessageItem.customActions`                      | **Removed** — replaced by `actionsBuilder` (`MessageActionsBuilder?`)                       |
| `StreamMessageItem.onCustomActionTap`                  | **Removed** — use `onTap` directly on each `StreamContextMenuAction` in `actionsBuilder`    |
| `CustomMessageAction`                                  | **Removed** — no longer needed; custom actions use `onTap` directly                         |
| `OnMessageActionTap`                                   | **Removed** — no longer needed                                                              |
| `StreamMessageItem.actionsBuilder`                     | **New** — `MessageActionsBuilder?` for the normal long-press menu                           |
| `StreamMessageActionsBuilder.buildActions`             | **Changed**: return type `List<StreamContextMenuAction>`, `customActions` param **removed** |
| `StreamMessageActionsBuilder.buildBouncedErrorActions` | **Return type changed**: `List<StreamMessageAction>` → `List<StreamContextMenuAction>`      |
| `MessageActionsBuilder<T>`                             | **New typedef** — `List<Widget> Function(BuildContext, List<StreamContextMenuAction<T>>)`   |
| `StreamContextMenu`                                    | **New** — exported from `stream_core_flutter`                                               |
| `StreamContextMenuAction`                              | **New** — exported from `stream_core_flutter`                                               |
| `StreamContextMenuSeparator`                           | **New** — exported from `stream_core_flutter`                                               |

> **Note:** `MessageAction` and all its built-in subclasses (`SelectReaction`, `CopyMessage`, `DeleteMessage`, etc.) are **unchanged**. `CustomMessageAction` (the escape-hatch subclass) has been **removed** — it was only needed for the old `onCustomActionTap` dispatch pattern.

---

## StreamMessageAction → StreamContextMenuAction

The `StreamMessageAction` data class has been removed. It was a pure data object that described how an action should look and which `MessageAction` it represents. It is replaced by `StreamContextMenuAction<T>`, which is a self-rendering widget that carries a typed `value` and handles dispatch automatically.

### Breaking Change

`StreamMessageAction` no longer exists. Replace every usage with `StreamContextMenuAction`.

### Tap dispatch behaviour

`StreamContextMenuAction` has two complementary dispatch mechanisms:

- **`value`** — when the action is tapped inside a popup route (dialog, bottom sheet, etc.) it calls `Navigator.pop(value)` first, then calls `onTap` if provided. The route is already closed when `onTap` runs.
- **`onTap`** — an optional `VoidCallback?`. When the action is used *inline* (outside any popup route) this is the only callback that fires.

You can use `value`, `onTap`, or both together.

### Migration

**Before:**
```dart
StreamMessageAction(
  action: QuotedReply(message: message),
  leading: const StreamSvgIcon(icon: StreamSvgIcons.reply),
  title: Text(context.translations.replyLabel),
)
```

**After (value-based — recommended for modals):**
```dart
StreamContextMenuAction<MessageAction>(
  value: QuotedReply(message: message),
  leading: Icon(context.streamIcons.reply),
  label: Text(context.translations.replyLabel),
)
// The caller receives QuotedReply via the Future returned by showStreamDialog.
```

**After (onTap-based — for inline usage or when you prefer callbacks):**
```dart
StreamContextMenuAction<MessageAction>(
  value: QuotedReply(message: message),
  leading: Icon(context.streamIcons.reply),
  label: Text(context.translations.replyLabel),
  onTap: () => onReply(message), // called after the route is dismissed
)
```

### Property mapping

| `StreamMessageAction`        | `StreamContextMenuAction`                                 |
| ---------------------------- | --------------------------------------------------------- |
| `action: T`                  | `value: T?`                                               |
| `title: Widget?`             | `label: Widget` (required)                                |
| `leading: Widget?`           | `leading: Widget?`                                        |
| `isDestructive: bool`        | `isDestructive: bool` (or use `.destructive` constructor) |
| `iconColor: Color?`          | Controlled via `StreamContextMenuActionTheme`             |
| `titleTextColor: Color?`     | Controlled via `StreamContextMenuActionTheme`             |
| `titleTextStyle: TextStyle?` | Controlled via `StreamContextMenuActionTheme`             |
| `backgroundColor: Color?`    | Controlled via `StreamContextMenuActionTheme`             |
| —                            | `onTap: VoidCallback?` (new)                              |
| —                            | `trailing: Widget?` (new)                                 |
| —                            | `enabled: bool` (new)                                     |

> **Important:**
> - **`label` is now required** — `title: Widget?` was optional in `StreamMessageAction`; `label: Widget` is a required, non-nullable parameter in `StreamContextMenuAction`. Any call site that omitted `title` will fail to compile; you must supply a non-null `label` widget (typically a `Text`).
> - `onTap` signature changed from `void Function(MessageAction)` to `VoidCallback?` — capture data in a closure instead
> - Per-item colours and text styles are now unified via `StreamContextMenuActionTheme` rather than individual properties

---

## StreamMessageActionItem

The `StreamMessageActionItem` widget has been removed. `StreamContextMenuAction` is now a full self-rendering widget — no separate "item" wrapper is needed.

### Breaking Change

`StreamMessageActionItem` no longer exists. Remove all direct usages.

### Migration

**Before:**
```dart
StreamMessageActionItem(
  action: StreamMessageAction(
    action: CopyMessage(message: message),
    leading: const StreamSvgIcon(icon: StreamSvgIcons.copy),
    title: Text('Copy'),
  ),
  onTap: (action) => _handle(action),
)
```

**After:**
```dart
StreamContextMenuAction<MessageAction>(
  value: CopyMessage(message: message),
  leading: Icon(context.streamIcons.copy),
  label: Text('Copy'),
  onTap: () => _handle(message),
)
```

---

## StreamMessageActionsModal

### Breaking Changes

- `onActionTap: OnMessageActionTap?` parameter **removed** — the modal no longer holds a top-level callback; use `onTap` on individual actions or await the dialog's return value
- `messageActions` parameter type changed from `List<StreamMessageAction>` to `List<Widget>`
- `reverse: bool` parameter **removed** — use `alignment: AlignmentGeometry?` instead
- `reactionPickerBuilder: ReactionPickerBuilder` parameter **removed** — use `showReactionPicker: bool` instead
- New `leadingInset: double` parameter added (default `0`)

### Migration

**Before:**
```dart
StreamMessageActionsModal(
  message: message,
  messageWidget: messageWidget,
  messageActions: [
    StreamMessageAction(
      action: CopyMessage(message: message),
      leading: const StreamSvgIcon(icon: StreamSvgIcons.copy),
      title: Text(context.translations.copyMessageLabel),
    ),
  ],
  onActionTap: (action) {
    if (action is CopyMessage) _copyMessage(action.message);
  },
)
```

**After (onTap per-action):**
```dart
StreamMessageActionsModal(
  message: message,
  messageWidget: messageWidget,
  messageActions: [
    StreamContextMenuAction<MessageAction>(
      value: CopyMessage(message: message),
      leading: Icon(context.streamIcons.copy),
      label: Text(context.translations.copyMessageLabel),
      onTap: () => _copyMessage(message), // called after route dismissal
    ),
  ],
)
```

**After (await return value):**

> `showStreamDialog<T>` is a Stream-themed wrapper around `showGeneralDialog` — see [New Components](#showstreamdialogt) for details.

```dart
final action = await showStreamDialog<MessageAction>(
  context: context,
  builder: (_) => StreamMessageActionsModal(
    message: message,
    messageWidget: messageWidget,
    messageActions: [
      StreamContextMenuAction<MessageAction>(
        value: CopyMessage(message: message),
        leading: Icon(context.streamIcons.copy),
        label: Text(context.translations.copyMessageLabel),
      ),
    ],
  ),
);

if (action is CopyMessage) _copyMessage(action.message);
```

> **Important:**
> - `onActionTap` on the modal is gone — move handling to `onTap` on each item or await the `Future`
> - Replace `StreamMessageAction` entries with `StreamContextMenuAction<MessageAction>`

---

## StreamMessageReactionsModal

### Breaking Changes

- `StreamMessageReactionsModal` class has been **deleted**. Any direct reference to the class will cause a compile error. Use `ReactionDetailSheet` instead — see [Reaction List & Detail Sheet](reaction_list.md).
- `onReactionPicked: OnMessageActionTap<SelectReaction>?` parameter **removed** — the modal now pops the route with a `SelectReaction`; await the dialog return value to handle it

### Migration

**Before:**
```dart
StreamMessageReactionsModal(
  message: message,
  messageWidget: messageWidget,
  onReactionPicked: (SelectReaction action) {
    _addReaction(action.reaction);
  },
)
```

**After:**
```dart
final action = await ReactionDetailSheet.show(
  context: context,
  message: message,
);

if (action is SelectReaction) {
  _addReaction(action.reaction);
}
```

> **Important:**
> - The old `onReactionPicked` already received a `SelectReaction`, not a raw `Reaction` — the migration only changes *where* you handle it (caller vs callback)

---

## ModeratedMessageActionsModal

### Breaking Changes

- `onActionTap: OnMessageActionTap?` parameter **removed** — move handling to awaiting the dialog return value
- `messageActions` parameter type changed from `List<StreamMessageAction>` to `List<StreamContextMenuAction>`

### Migration

**Before:**
```dart
ModeratedMessageActionsModal(
  message: message,
  messageActions: [
    StreamMessageAction(
      action: ResendMessage(message: message),
      title: Text(context.translations.sendAnywayLabel),
    ),
    StreamMessageAction(
      action: EditMessage(message: message),
      title: Text(context.translations.editMessageLabel),
    ),
    StreamMessageAction(
      isDestructive: true,
      action: HardDeleteMessage(message: message),
      title: Text(context.translations.deleteMessageLabel),
    ),
  ],
  onActionTap: (action) {
    if (action is ResendMessage) _resend(action.message);
  },
)
```

**After (await return value):**

> **Important:** `ModeratedMessageActionsModal` renders actions as `AdaptiveDialogAction` buttons — it calls `Navigator.pop(context, action.props.value)` when an item is tapped and does **not** invoke `action.props.onTap`. Dispatch must be handled by awaiting the `Future` returned by `showStreamDialog`.

```dart
final action = await showStreamDialog<MessageAction>(
  context: context,
  builder: (_) => ModeratedMessageActionsModal(
    message: message,
    messageActions: [
      StreamContextMenuAction<MessageAction>(
        value: ResendMessage(message: message),
        label: Text(context.translations.sendAnywayLabel),
      ),
      // ...
    ],
  ),
);

if (action is ResendMessage) _resend(action.message);
```

---

## StreamMessageItem.customActions

### Breaking Change

`customActions: List<StreamMessageAction>` has been **removed**. It is replaced by `actionsBuilder`:

```dart
typedef MessageActionsBuilder<T extends MessageAction> =
    List<Widget> Function(
      BuildContext context,
      List<StreamContextMenuAction<T>> defaultActions,
    );
```

`StreamMessageItem.actionsBuilder` is declared as `MessageActionsBuilder?` (i.e. `MessageActionsBuilder<MessageAction>?`), so `defaultActions` is typed as `List<StreamContextMenuAction<MessageAction>>` — each item's `.props.value` is a `MessageAction?`.

The `defaultActions` list passed into the builder is already filtered by the widget's `show*` flags, so callers always start from a clean, ready-to-render baseline.

`actionsBuilder` returns `List<Widget>` — any widget can be mixed in alongside the default `StreamContextMenuAction` items (e.g. `StreamContextMenuSeparator`).

### Migration

**Before (append a custom action):**
```dart
StreamMessageItem(
  message: message,
  messageTheme: messageTheme,
  customActions: [
    StreamMessageAction(
      action: CustomMessageAction(
        message: message,
        extraData: const {'type': 'favourite'},
      ),
      leading: const Icon(Icons.star),
      title: Text('Favourite'),
    ),
  ],
  onCustomActionTap: (CustomMessageAction action) {
    _favourite(action.message);
  },
)
```

**After:**
```dart
StreamMessageItem(
  message: message,
  messageTheme: messageTheme,
  actionsBuilder: (context, defaultActions) => [
    ...defaultActions,
    StreamContextMenuAction(
      leading: const Icon(Icons.star),
      label: Text('Favourite'),
      onTap: () => _favourite(message),
    ),
  ],
)
```

**After (remove an existing action and add a custom one):**
```dart
StreamMessageItem(
  message: message,
  messageTheme: messageTheme,
  actionsBuilder: (context, defaultActions) => [
    ...defaultActions.where((a) => a.props.value is! DeleteMessage),
    StreamContextMenuSeparator(),
    StreamContextMenuAction(
      leading: const Icon(Icons.star),
      label: Text('Favourite'),
      onTap: () => _favourite(message),
    ),
  ],
)
```

> **Important:**
> - `onCustomActionTap` is **removed** — put dispatch logic directly in `onTap` on each action
> - `actionsBuilder` receives the defaults **already** filtered by `show*` flags (e.g. `showDeleteMessage`)
> - When `actionsBuilder` is not provided, the default list is wrapped in `StreamContextMenuAction.partitioned` automatically

---

## StreamMessageActionsBuilder

### Breaking Changes

Both static methods now return `List<StreamContextMenuAction>` instead of `List<StreamMessageAction>`. Additionally, the `customActions` parameter of `buildActions` has been **removed** — appending custom actions is now handled by `StreamMessageItem.actionsBuilder`.

| Method / Parameter                | Old type                         | New type                        |
| --------------------------------- | -------------------------------- | ------------------------------- |
| `buildActions` return             | `List<StreamMessageAction>`      | `List<StreamContextMenuAction>` |
| `buildBouncedErrorActions` return | `List<StreamMessageAction>`      | `List<StreamContextMenuAction>` |
| `buildActions(customActions:)`    | `Iterable<StreamMessageAction>?` | **Removed**                     |

### Migration

**Before:**
```dart
final List<StreamMessageAction> actions =
    StreamMessageActionsBuilder.buildActions(
  context: context,
  message: message,
  channel: channel,
  currentUser: currentUser,
  customActions: myCustomStreamMessageActions,
);
```

**After:**
```dart
// buildActions no longer accepts customActions — add extras via actionsBuilder
final List<StreamContextMenuAction<MessageAction>> actions =
    StreamMessageActionsBuilder.buildActions(
  context: context,
  message: message,
  channel: channel,
  currentUser: currentUser,
);
```

---

## New Components

### showStreamDialog\<T\>

A top-level function from `package:stream_chat_flutter/stream_chat_flutter.dart` that replaces direct calls to `showDialog` when presenting Stream modals. It wraps `showGeneralDialog` and:

- **Re-wraps `StreamChatTheme`** across the route boundary so the theme is available inside the dialog even when `useRootNavigator: true`
- **Applies a blur + scale transition** for a consistent Stream look
- **Returns `Future<T?>`** — the value passed to `Navigator.pop` inside the dialog, which is how `StreamMessageActionsModal`, `StreamMessageReactionsModal`, and `ModeratedMessageActionsModal` deliver the selected action back to the caller

```dart
// Replace showDialog with showStreamDialog when presenting Stream modals:
final action = await showStreamDialog<MessageAction>(
  context: context,
  builder: (_) => StreamMessageActionsModal(/* … */),
);
```

> **Note:** If you were calling `showDialog` directly and passing Stream modals to it, switch to `showStreamDialog` to ensure theming works correctly across the route boundary.

### StreamContextMenuAction

A self-contained menu action widget from `stream_core_flutter` that replaces `StreamMessageAction` + `StreamMessageActionItem`. It renders itself and supports two dispatch mechanisms:

- **Inside a popup route** (dialog/bottom sheet): pops `value` via `Navigator.pop` first, then calls `onTap` if provided.
- **Inline** (outside any popup route): only `onTap` fires.

```dart
// Standard action — value-based (recommended for modals)
StreamContextMenuAction<MessageAction>(
  value: CopyMessage(message: message),
  leading: Icon(context.streamIcons.copy),
  label: Text('Copy'),
)

// With optional onTap callback (called after route dismissal)
StreamContextMenuAction<MessageAction>(
  value: CopyMessage(message: message),
  leading: Icon(context.streamIcons.copy),
  label: Text('Copy'),
  onTap: () => _copyMessage(message),
)

// Destructive action
StreamContextMenuAction<MessageAction>.destructive(
  value: DeleteMessage(message: message),
  leading: Icon(context.streamIcons.delete),
  label: Text('Delete'),
)
```

#### Helper methods for grouping

```dart
// Insert a separator between every item
StreamContextMenuAction.separated(items: actions)

// Insert separators between logical groups (provide groups as separate lists)
StreamContextMenuAction.sectioned(sections: [normalActions, destructiveActions])

// Automatically partition into normal / destructive groups with a separator between them
StreamContextMenuAction.partitioned(items: actions)
```

All three methods return `List<Widget>` because they interleave `StreamContextMenuSeparator` widgets.

### StreamContextMenu

A themed container that wraps a list of `StreamContextMenuAction` and `StreamContextMenuSeparator` widgets.

```dart
StreamContextMenu(
  children: StreamContextMenuAction.partitioned(items: actions),
)
```

### StreamContextMenuSeparator

A thin horizontal divider for use inside `StreamContextMenu`.

```dart
StreamContextMenu(
  children: [
    StreamContextMenuAction(value: reply, label: Text('Reply')),
    const StreamContextMenuSeparator(),
    StreamContextMenuAction.destructive(value: delete, label: Text('Delete')),
  ],
)
```

---

## Migration Checklist

- [ ] Replace all `StreamMessageAction(action: ..., title: ..., leading: ...)` with `StreamContextMenuAction(value: ..., label: ..., leading: ...)`
- [ ] Add a non-null `label` widget wherever `title` was previously omitted — `label` is now a required parameter and code that relied on a null/omitted `title` will not compile
- [ ] Update `onTap` callsites: old type was `void Function(MessageAction)`, new type is `VoidCallback?` — capture needed data in a closure
- [ ] Remove all `StreamMessageActionItem` usages
- [ ] Remove `onActionTap` from `StreamMessageActionsModal`; handle via per-action `onTap` or await the dialog return value
- [ ] Remove `onReactionPicked` from `StreamMessageReactionsModal`; await a `SelectReaction` return value
- [ ] Remove `onActionTap` from `ModeratedMessageActionsModal`; await the `MessageAction?` return value of `showStreamDialog` instead
- [ ] Replace `StreamMessageItem.customActions` with `actionsBuilder`
- [ ] Update `StreamMessageActionsBuilder.buildActions` call sites — return type is now `List<StreamContextMenuAction>` and `customActions` parameter no longer exists
- [ ] Update `StreamMessageActionsBuilder.buildBouncedErrorActions` call sites — return type is now `List<StreamContextMenuAction>`
- [ ] Replace `StreamSvgIcon` leading widgets in custom actions with `Icon(context.streamIcons.*)`
- [ ] Replace per-action color/style properties (`iconColor`, `titleTextColor`, etc.) with `StreamContextMenuActionTheme`
