# Message Widget Migration Guide

This guide covers migrating the message widget (individual message item) from the old design (`feat/design-refresh`) to the new redesigned API.

For changes to `StreamMessageListView`, see [message_list.md](message_list.md).

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [Architecture Changes](#architecture-changes)
- [StreamMessageItem](#streammessageitem)
  - [Removed Parameters](#removed-parameters)
  - [New Parameters](#new-parameters)
  - [Changed Signatures](#changed-signatures)
- [Custom Actions Migration](#custom-actions-migration)
- [Theme Migration](#theme-migration)
- [Removed Widgets](#removed-widgets)
- [Swipeable Message Example](#swipeable-message-example)
- [Deleted Classes & Files](#deleted-classes--files)
- [Typedef Changes](#typedef-changes)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Old                                                                | New                                                         |
| ------------------------------------------------------------------ | ----------------------------------------------------------- |
| `StreamMessageItem` (50+ params)                                   | `StreamMessageItem` (thin shell) + `StreamMessageItemProps` |
| `MessageWidgetContent`                                             | `DefaultStreamMessageItem` + `StreamMessageContent`         |
| `BottomRow`                                                        | `StreamMessageFooter`                                       |
| `StreamMessageText` (message_text.dart)                            | `StreamMessageText` (components/stream_message_text.dart)   |
| `StreamMarkdownMessage`                                            | `StreamMessageText`                                         |
| `StreamDeletedMessage`                                             | `StreamMessageDeleted`                                      |
| `MessageCard`                                                      | `core.StreamMessageBubble`                                  |
| `TextBubble`                                                       | `core.StreamMessageBubble`                                  |
| `PinnedMessage`                                                    | `StreamMessageHeader` widget                                |
| `QuotedMessage`                                                    | Inline in `StreamMessageContent`                            |
| `Username`                                                         | Inline in `StreamMessageFooter`                             |
| `SendingIndicatorBuilder`                                          | `StreamMessageSendingStatus`                                |
| `ThreadReplyPainter`                                               | `core.StreamMessageReplies`                                 |
| `ThreadParticipants`                                               | Inline in `core.StreamMessageReplies`                       |
| `UserAvatarTransform`                                              | `StreamUserAvatar` (inline in `DefaultStreamMessageItem`)   |
| `DisplayWidget` enum                                               | `StreamVisibility` (from theme)                             |
| `StreamMessageItem.customActions`                                  | `StreamMessageItemProps.actionsBuilder`                     |
| `StreamMessageItem.onCustomActionTap`                              | Use `onTap` per `StreamContextMenuAction`                   |
| `CustomMessageAction`                                              | Removed — use `StreamContextMenuAction` with `onTap`        |
| `StreamMessageItem.copyWith()`                                     | `StreamMessageItemProps.copyWith()`                         |
| `StreamMessageThemeData` / `ownMessageTheme` / `otherMessageTheme` | `StreamMessageItemThemeData` (placement-aware)              |

---

## Architecture Changes

The old design used a single monolithic `StreamMessageItem` with 50+ parameters controlling every aspect of rendering. The new design splits responsibilities:

- **`StreamMessageItem`** — thin shell that resolves the `StreamComponentFactory` and delegates to the factory builder or `DefaultStreamMessageItem`.
- **`StreamMessageItemProps`** — plain data class holding all configuration. Supports `copyWith()`.
- **`DefaultStreamMessageItem`** — the default rendering implementation. Composes the sub-components below.
- **`StreamMessageContent`** — bubble, attachments, text, reactions. Thread replies are passed in as a pre-built widget from `DefaultStreamMessageItem`.
- **`StreamMessageFooter`** — username, timestamp, sending status, edited indicator.
- **`StreamMessageHeader`** — pinned, saved-for-later, show-in-channel annotations.
- **`StreamUserAvatar`** — author avatar (inline in `DefaultStreamMessageItem`).
- **`StreamMessageReactions`** — clustered reaction chips around the bubble.
- **`StreamMessageText`** — markdown-rendered message text.
- **`StreamMessageDeleted`** — deleted message placeholder.
- **`StreamMessageSendingStatus`** — delivery status icon.

### Component Factory Pattern

The new design adds a **component factory** layer for app-wide customization. The `messageBuilder` / `parentMessageBuilder` callbacks on `StreamMessageListView` are still supported for per-list customization.

**App-wide customization via component factory:**
```dart
StreamChat(
  client: client,
  componentBuilders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      messageItem: (context, props) {
        return DefaultStreamMessageItem(
          props: props.copyWith(
            actionsBuilder: (context, defaultActions) {
              return [...defaultActions, myCustomAction];
            },
          ),
        );
      },
    ),
  ),
  child: ...,
)
```

**Per-list customization via `messageBuilder` (still supported):**
```dart
StreamMessageListView(
  messageBuilder: (context, message, defaultProps) {
    return StreamMessageItem.fromProps(props: defaultProps);
  },
)
```

Both can be combined — the component factory applies first, then the per-list `messageBuilder` can further customize or wrap the result. See [message_list.md](message_list.md) for details on the `messageBuilder` signature and the new `config` / `builders` split on `StreamMessageListView`.

---

## StreamMessageItem

### Removed Parameters

These parameters have been removed entirely. See the **Migration Path** column for how to achieve the same result.

#### Visibility Booleans

| Old Parameter                      | Migration Path                                                                    |
| ---------------------------------- | --------------------------------------------------------------------------------- |
| `showReactions`                    | Controlled via `StreamMessageItemThemeData` visibility                            |
| `showDeleteMessage`                | Controlled via channel permissions (`canDeleteOwnMessage`, `canDeleteAnyMessage`) |
| `showEditMessage`                  | Controlled via channel permissions (`canUpdateOwnMessage`, `canUpdateAnyMessage`) |
| `showReplyMessage`                 | Controlled via channel permissions (`canSendReply`)                               |
| `showThreadReplyMessage`           | Controlled via channel permissions (`canSendReply`)                               |
| `showMarkUnreadMessage`            | Shown automatically when applicable                                               |
| `showResendMessage`                | Shown automatically for failed messages                                           |
| `showCopyMessage`                  | Shown automatically when message has text                                         |
| `showFlagButton`                   | Controlled via channel permissions (`canFlagMessage`)                             |
| `showPinButton`                    | Controlled via channel permissions (`canPinMessage`)                              |
| `showPinHighlight`                 | Controlled via `StreamMessageItemThemeData` background color                      |
| `showReactionPicker`               | Removed                                                                           |
| `showUsername`                     | Controlled via `StreamMessageItemThemeData.metadataVisibility`                    |
| `showTimestamp`                    | Controlled via `StreamMessageItemThemeData.metadataVisibility`                    |
| `showEditedLabel`                  | Controlled via `StreamMessageItemThemeData.metadataVisibility`                    |
| `showSendingIndicator`             | Controlled via `StreamMessageItemThemeData.metadataVisibility`                    |
| `showThreadReplyIndicator`         | Controlled via `StreamMessageItemThemeData.repliesVisibility`                     |
| `showInChannelIndicator`           | Shown automatically via `StreamMessageHeader`                                     |
| `showUserAvatar` (`DisplayWidget`) | Controlled via `StreamMessageItemThemeData.avatarVisibility`                      |

#### Builder Callbacks

| Old Parameter                       | Migration Path                                                             |
| ----------------------------------- | -------------------------------------------------------------------------- |
| `userAvatarBuilder`                 | Use component factory to replace `DefaultStreamMessageItem`                |
| `textBuilder`                       | Use component factory to replace `StreamMessageContent`                    |
| `quotedMessageBuilder`              | Use component factory to replace `StreamMessageContent`                    |
| `deletedMessageBuilder`             | Use component factory to replace `StreamMessageContent`                    |
| `editMessageInputBuilder`           | Removed; use `onEditMessageTap` callback instead                           |
| `bottomRowBuilderWithDefaultWidget` | Use component factory; `StreamMessageFooter` is the new equivalent         |
| `reactionPickerBuilder`             | Configured globally via `StreamChatConfigurationData.reactionIconResolver` |
| `reactionIndicatorBuilder`          | Replaced by `StreamMessageReactions` component                             |

#### Shape & Style

| Old Parameter          | Migration Path                                                        |
| ---------------------- | --------------------------------------------------------------------- |
| `shape`                | Controlled via `StreamMessageBubble` theming in `stream_core_flutter` |
| `borderSide`           | Controlled via `StreamMessageBubble` theming                          |
| `borderRadiusGeometry` | Controlled via `StreamMessageBubble` theming                          |
| `attachmentShape`      | Controlled via attachment builder theming                             |
| `textPadding`          | Controlled via `StreamMessageBubble` content padding theming          |
| `attachmentPadding`    | Configured internally by `StreamMessageAttachments`                   |
| `messageTheme`         | Resolved from context via `StreamMessageItemTheme.of(context)`        |

#### Other Removed Parameters

| Old Parameter                        | Migration Path                                                                                                                            |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `reverse`                            | Determined by `StreamMessageLayout` context (set by list view)                                                                            |
| `translateUserAvatar`                | Removed; avatar positioning is theme-driven                                                                                               |
| `onConfirmDeleteTap`                 | Handled internally by `StreamMessageActionsBuilder`                                                                                       |
| `onShowMessage`                      | Removed                                                                                                                                   |
| `onReactionsHover`                   | Removed                                                                                                                                   |
| `customActions`                      | Use `actionsBuilder` on `StreamMessageItemProps`                                                                                          |
| `onCustomActionTap`                  | Use `actionsBuilder` on `StreamMessageItemProps`                                                                                          |
| `onAttachmentTap`                    | Handle in custom attachment builders                                                                                                      |
| `imageAttachmentThumbnailSize`       | Configured in attachment builders                                                                                                         |
| `imageAttachmentThumbnailResizeType` | Configured in attachment builders                                                                                                         |
| `imageAttachmentThumbnailCropType`   | Configured in attachment builders                                                                                                         |
| `attachmentActionsModalBuilder`      | Configured in attachment builders                                                                                                         |
| `attachmentBuilders`                 | Moved to `StreamChatConfigurationData.attachmentBuilders` (still overridable per-message via `StreamMessageItemProps.attachmentBuilders`) |
| `copyWith()` on `StreamMessageItem`  | Use `StreamMessageItemProps.copyWith()` instead                                                                                           |

### New Parameters

| New Parameter                  | Description                                                        |
| ------------------------------ | ------------------------------------------------------------------ |
| `padding`                      | Outer padding around the message item (overrides theme)            |
| `spacing`                      | Horizontal spacing between avatar and content (overrides theme)    |
| `backgroundColor`              | Background color for the message row (overrides theme)             |
| `maxWidth`                     | Max content width in logical pixels (default: `264` on `StreamMessageItem`, `272` on `StreamMessageItemProps`) |
| `onMessageLinkTap`             | `void Function(Message, String)` — receives message and URL        |
| `onUserMentionTap`             | `void Function(User)` — receives the mentioned user                |
| `onQuotedMessageTap`           | `void Function(Message)` — receives the quoted message object      |
| `onReactionsTap`               | `void Function(Message)` — overrides default reaction detail sheet |
| `reactionSorting`              | `Comparator<ReactionGroup>` for reaction display order             |
| `actionsBuilder`               | `MessageActionsBuilder` for customizing the actions list           |
| `onMessageActions`             | Override the default long-press modal entirely                     |
| `onBouncedErrorMessageActions` | Override the bounced-error modal entirely                          |
| `onEditMessageTap`             | Called when edit action is selected                                |

### Changed Signatures

| Callback           | Old Signature                            | New Signature                                                                  |
| ------------------ | ---------------------------------------- | ------------------------------------------------------------------------------ |
| Link tap           | `void Function(String url)`              | `void Function(Message message, String url)`                                   |
| Mention tap        | `void Function(User user)`               | `void Function(User user)` (renamed: `onMentionTap` → `onUserMentionTap`)      |
| Quoted message tap | `void Function(String? quotedMessageId)` | `void Function(Message quotedMessage)`                                         |
| Thread tap         | `void Function(Message message)`         | `void Function(Message parentMessage, Message? threadMessage)` (renamed: `onThreadTap`) |
| Reply tap          | `void Function(Message message)`         | `void Function(Message message)` (new: `onReplyTap`)                           |

---

## Custom Actions Migration

**Before (using `customActions` + `onCustomActionTap`):**
```dart
StreamMessageItem(
  message: message,
  messageTheme: theme,
  customActions: [
    StreamMessageAction(
      leading: Icon(Icons.info),
      title: Text('Info'),
      onTap: (message) => showInfo(message),
    ),
  ],
  onCustomActionTap: (action) {
    // handle CustomMessageAction
  },
)
```

**After (using `actionsBuilder` via component factory):**
```dart
StreamChat(
  client: client,
  componentBuilders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      messageItem: (context, props) {
        return DefaultStreamMessageItem(
          props: props.copyWith(
            actionsBuilder: (context, defaultActions) {
              return StreamContextMenuAction.partitioned(
                items: [
                  ...defaultActions,
                  StreamContextMenuAction(
                    leading: Icon(context.streamIcons.informationCircle),
                    label: Text('Info'),
                    onTap: () => showInfo(props.message),
                  ),
                ],
              );
            },
          ),
        );
      },
    ),
  ),
  child: ...,
)
```

**After (removing a default action):**
```dart
actionsBuilder: (context, defaultActions) {
  return StreamContextMenuAction.partitioned(
    items: defaultActions.where(
      (a) => a.props.value is! DeleteMessage,
    ).toList(),
  );
},
```

> **Important:**
> - `customActions` and `onCustomActionTap` are removed
> - `CustomMessageAction` class is removed — use `StreamContextMenuAction` with `onTap`
> - `actionsBuilder` receives defaults already filtered by channel permissions
> - Return `List<Widget>` — you can mix `StreamContextMenuAction` and `StreamContextMenuSeparator`

---

## Theme Migration

`StreamMessageThemeData` and the paired `ownMessageTheme` / `otherMessageTheme` accessors on `StreamChatThemeData` have been **removed**. Use `StreamMessageItemThemeData` instead — it is placement-aware and exposes the new structured visibility system.

| Removed                                    | Replacement                                                                |
| ------------------------------------------ | -------------------------------------------------------------------------- |
| `StreamMessageThemeData`                   | `StreamMessageItemThemeData`                                               |
| `StreamChatThemeData.ownMessageTheme`      | Placement-aware styling via `StreamMessageLayoutProperty.resolveWith` on individual style fields (e.g. `bubble`, `metadata`) |
| `StreamChatThemeData.otherMessageTheme`    | Placement-aware styling via `StreamMessageLayoutProperty.resolveWith` on individual style fields (e.g. `bubble`, `metadata`) |
| `StreamMessageItem.messageTheme` parameter | Resolved from context via `StreamMessageItemTheme.of(context)`             |

**Before (explicit `messageTheme` parameter):**
```dart
StreamMessageItem(
  message: message,
  messageTheme: isMyMessage
      ? streamTheme.ownMessageTheme
      : streamTheme.otherMessageTheme,
)
```

**After (theme resolved automatically from context):**
```dart
StreamMessageItem(message: message)
```

`StreamMessageItemTheme` is provided by `StreamChatTheme` and resolved based on `StreamMessageLayout` (alignment, stack position, etc.).

### StreamMessageItemThemeData

The old per-property visibility booleans are replaced by a structured visibility system:

```dart
StreamMessageItemThemeData(
  // Visibility fields take a StreamMessageLayoutVisibility resolved per layout.
  avatarVisibility: StreamMessageLayoutVisibility.resolveWith((layout) {
    // Hide avatar for end-aligned (outgoing) messages.
    return layout.alignment == StreamMessageAlignment.end
        ? StreamVisibility.gone
        : StreamVisibility.visible;
  }),
  metadataVisibility: StreamMessageLayoutVisibility.resolveWith((layout) {
    return switch (layout.stackPosition) {
      StreamMessageStackPosition.bottom ||
      StreamMessageStackPosition.single => StreamVisibility.visible,
      _ => StreamVisibility.gone,
    };
  }),

  // Placement-aware bubble color lives on the bubble style field.
  bubble: StreamMessageBubbleStyle(
    backgroundColor: StreamMessageLayoutProperty.resolveWith((layout) {
      return layout.alignment == StreamMessageAlignment.end
          ? Colors.blue.shade50
          : Colors.white;
    }),
  ),
)
```

---

## Removed Widgets

The following widgets have been removed from the SDK. Replace any direct references with the listed alternatives.

| Removed Widget                                                         | Notes                                                                      |
| ---------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| `StreamMarkdownMessage`                                                | Use `StreamMessageText`                                                    |
| `StreamMessageThemeData` (and `ownMessageTheme` / `otherMessageTheme`) | Use `StreamMessageItemThemeData` — see [Theme Migration](#theme-migration) |

For attachment-related removals (`StreamFileAttachmentThumbnail`, `StreamAttachmentUploadStateBuilder.successBuilder`, etc.), see [attachments_and_polls.md](attachments_and_polls.md).

For composer-related removals (`AttachmentButton`, `StreamQuotedMessageWidget`, `EditMessageSheet`, `StreamMessageSendButton`, etc.), see [message_composer.md](message_composer.md).

For reactions-related removals (`DesktopReactionsBuilder`, `StreamMessageReactionsModal`), see [reaction_list.md](reaction_list.md) and [message_actions.md](message_actions.md).

---

## Swipeable Message Example

```dart
StreamMessageListView(
  messageBuilder: (context, message, defaultProps) {
    final defaultWidget = StreamMessageItem.fromProps(props: defaultProps);

    if (message.isDeleted || message.state.isFailed) return defaultWidget;

    final alignment = StreamMessageLayout.alignmentDirectionalOf(context);
    final isEnd = alignment == AlignmentDirectional.centerEnd;

    return Swipeable(
      key: ValueKey(message.id),
      direction: isEnd ? SwipeDirection.endToStart : SwipeDirection.startToEnd,
      swipeThreshold: 0.2,
      onSwiped: (_) => onReply(message),
      child: defaultWidget,
    );
  },
)
```

---

## Deleted Classes & Files

| Old File                                 | Old Class                 | Replacement                                               |
| ---------------------------------------- | ------------------------- | --------------------------------------------------------- |
| `message_widget_content.dart`            | `MessageWidgetContent`    | `DefaultStreamMessageItem` + `StreamMessageContent`       |
| `message_widget_content_components.dart` | Various internal helpers  | Merged into `components/` sub-widgets                     |
| `bottom_row.dart`                        | `BottomRow`               | `StreamMessageFooter`                                     |
| `message_text.dart`                      | `StreamMessageText`       | `components/stream_message_text.dart`                     |
| `deleted_message.dart`                   | `StreamDeletedMessage`    | `StreamMessageDeleted`                                    |
| `message_card.dart`                      | `MessageCard`             | `core.StreamMessageBubble`                                |
| `text_bubble.dart`                       | `TextBubble`              | `core.StreamMessageBubble`                                |
| `pinned_message.dart`                    | `PinnedMessage`           | `StreamMessageHeader` widget                              |
| `quoted_message.dart`                    | `QuotedMessage`           | Inline in `StreamMessageContent`                          |
| `thread_painter.dart`                    | `ThreadReplyPainter`      | `core.StreamMessageReplies`                               |
| `thread_participants.dart`               | `ThreadParticipants`      | Inline in `core.StreamMessageReplies`                     |
| `user_avatar_transform.dart`             | `UserAvatarTransform`     | `StreamUserAvatar` (inline in `DefaultStreamMessageItem`) |
| `username.dart`                          | `Username`                | Inline in `StreamMessageFooter`                           |
| `sending_indicator_builder.dart`         | `SendingIndicatorBuilder` | `StreamMessageSendingStatus`                              |

---

## Typedef Changes

| Old Typedef | New Typedef                                                                                              |
| ----------- | -------------------------------------------------------------------------------------------------------- |
| —           | `MessageActionsBuilder<T extends MessageAction> = List<Widget> Function(BuildContext, List<StreamContextMenuAction<T>>)` (new) |

For the `MessageBuilder` / `ParentMessageBuilder` typedef changes and the new `StreamMessageItemBuilder`, see [message_list.md](message_list.md#builder-signature-changes).

---

## Migration Checklist

- [ ] Replace `StreamMessageItem(message:, messageTheme:, ...)` with `StreamMessageItem(message:)` — theme is now resolved from context
- [ ] Remove all `show*` boolean parameters — visibility is now controlled via `StreamMessageItemThemeData` and channel permissions
- [ ] Remove `customActions` and `onCustomActionTap` — use `actionsBuilder` via component factory or `StreamMessageItemProps.copyWith()`
- [ ] Remove all per-widget builder callbacks (`userAvatarBuilder`, `textBuilder`, `quotedMessageBuilder`, `deletedMessageBuilder`, `bottomRowBuilderWithDefaultWidget`, `reactionPickerBuilder`, `reactionIndicatorBuilder`) — use component factory instead
- [ ] Remove `shape`, `borderSide`, `borderRadiusGeometry`, `attachmentShape`, `textPadding`, `attachmentPadding` — controlled via `StreamMessageBubble` theming
- [ ] Remove `reverse` — determined by `StreamMessageLayout` context
- [ ] Remove `translateUserAvatar` — avatar positioning is theme-driven
- [ ] Replace `StreamMessageThemeData` / `ownMessageTheme` / `otherMessageTheme` with `StreamMessageItemThemeData`
- [ ] Update `onLinkTap` to `onMessageLinkTap` with new signature `void Function(Message, String)`
- [ ] Update `onMentionTap` to `onUserMentionTap`
- [ ] Update `onQuotedMessageTap` from `void Function(String?)` to `void Function(Message)`
- [ ] Replace `StreamDeletedMessage` with `StreamMessageDeleted`
- [ ] Replace `StreamMarkdownMessage` with `StreamMessageText`
- [ ] Replace `StreamMessageAction` with `StreamContextMenuAction` (see [message_actions.md](message_actions.md))
- [ ] Replace `StreamSvgIcon(icon: StreamSvgIcons.*)` with `Icon(context.streamIcons.*)`
- [ ] Remove `StreamMessageItem.copyWith()` usage — use `StreamMessageItemProps.copyWith()` instead
- [ ] For `StreamMessageListView` migration (config / builders split, `messageBuilder` signature changes, etc.), see [message_list.md](message_list.md)
