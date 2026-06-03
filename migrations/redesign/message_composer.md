# Message Composer Migration Guide

This guide covers the migration for the message composer components in the Stream Chat Flutter SDK design refresh.

---

## Table of Contents

- [Overview](#overview)
- [StreamMessageComposer](#streammessagecomposer)
- [StreamChatMessageInput (new)](#streamchatmessageinput-new)
- [StreamMessageComposerController Rename](#streammessagecomposercontroller-rename)
- [StreamMessageComposerInput Split](#streammessagecomposerinput-split)
- [Message Input Placeholder API](#message-input-placeholder-api)
- [Attachment Customization](#attachment-customization)
- [Removed Widgets](#removed-widgets)
- [Theme Removal: StreamMessageInputThemeData](#theme-removal-streammessageinputthemedata)
- [Migration Checklist](#migration-checklist)

---

## Overview

There are two distinct composer components with different responsibilities:

| Component                | Responsibility                                                                                                                         |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| `StreamMessageComposer`  | Full-featured widget: handles sending, editing, attachments, autocomplete, mentions, commands, OG previews, voice recording flow, etc. |
| `StreamChatMessageInput` | UI-only component: renders the composer layout using design system primitives. No business logic.                                      |

`StreamMessageComposer` wraps `StreamChatMessageInput` for its visual layer. If you are using `StreamMessageComposer` today, it remains the right choice — it is not deprecated. `StreamChatMessageInput` exists for cases where you want to build your own message-sending logic and use the new design system UI.

---

## StreamMessageComposer

`StreamMessageComposer` handles all message composition logic. This section documents all breaking changes.

### Breaking Change: `hideSendAsDm` renamed to `canAlsoSendToChannelFromThread` (logic inverted)

| Old                                 | New                                                  |
| ----------------------------------- | ---------------------------------------------------- |
| `hideSendAsDm: true`                | `canAlsoSendToChannelFromThread: false`              |
| `hideSendAsDm: false` (old default) | `canAlsoSendToChannelFromThread: true` (new default) |

The logic is **inverted**: the old parameter hid the "also send to channel" checkbox when `true`; the new parameter **shows** it when `true`.

**Before:**
```dart
StreamMessageInput(
  hideSendAsDm: true,  // hide the "also send to channel" checkbox
)
```

**After:**
```dart
StreamMessageComposer(
  canAlsoSendToChannelFromThread: false,  // hide the checkbox
)
```

> **Note:** `canAlsoSendToChannelFromThread` defaults to `true`, matching the old default of showing the checkbox when inside a thread.

### Breaking Change: `attachmentLimit` default is the backend cap

`attachmentLimit` is a non-nullable `int` defaulting to `StreamAttachmentValidator.defaultMaxAttachmentCount` (`30`) — the backend's `MaxNumberOfMessageAttachments` cap. Previously it defaulted to `10` (`StreamMessageInput`), and during the v10 beta it was briefly `int?` defaulting to `null` ("no limit"). The new default is now both lower-friction (matches the server cap) and safer (prevents silent backend rejections when a higher value is set client-side).

**Before:**
```dart
StreamMessageInput(
  attachmentLimit: 5,
)
```

**After (custom limit):**
```dart
StreamMessageComposer(
  attachmentLimit: 5,
)
```

**After (default — matches the backend cap of 30):**
```dart
StreamMessageComposer(
  // attachmentLimit defaults to StreamAttachmentValidator.defaultMaxAttachmentCount
)
```

### AppSettings-driven attachment validation

`StreamMessageComposer` now validates every picked, pasted, and dropped attachment against `StreamChatClient.appSettings` — enforcing per-type size limits, allowed/blocked extensions, allowed/blocked MIME types, and the total attachment count. The validator runs synchronously off the cached `AppSettings` (auto-loaded on connect, refreshed via `client.getAppSettings()`); validation failures surface as a localized error sheet.

The previous `maxAttachmentSize` (UI-side fallback) and `onAttachmentLimitExceed` (custom error callback) parameters have been **removed**.

| Removed                                          | Replacement                                                                                                                                                                                                            |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `StreamMessageComposer.maxAttachmentSize` (`int?`) and the `kDefaultMaxAttachmentSize` constant | Size limits are read from `StreamChatClient.appSettings.fileUploadConfig.sizeLimit` / `imageUploadConfig.sizeLimit`. When the backend value is `0`, the SDK falls back to `UploadConfig.defaultSizeLimit` (100 MB).    |
| `StreamMessageComposer.onAttachmentLimitExceed` and the `AttachmentLimitExceedListener` typedef | The default error sheet handles all validator failures. To surface a custom UI, pass `onError` to `StreamMessageComposer` — when set, it short-circuits the default sheet and receives the typed `AttachmentLimitReachedError` / `AttachmentTooLargeError` / `AttachmentBlockedError`. |

**Before:**
```dart
StreamMessageInput(
  maxAttachmentSize: 5 * 1024 * 1024, // 5 MB UI-side cap
  onAttachmentLimitExceed: (limit, error) {
    showSnackBar('Too many attachments ($limit max)');
  },
)
```

**After:**
```dart
// No UI-side knobs. Size + extension + MIME rules come from the backend
// (AppSettings); the count limit comes from `attachmentLimit` (defaulting to 30).
StreamMessageComposer()
```

For a custom error UI, supply an `onError` callback to `StreamMessageComposer`. When provided, it short-circuits the default error sheet and receives the typed validator errors:

```dart
StreamMessageComposer(
  onError: (error, stackTrace) {
    final message = switch (error) {
      AttachmentLimitReachedError(:final maxCount) =>
        'Too many attachments ($maxCount max)',
      AttachmentTooLargeError(:final maxSize) =>
        'Attachment exceeds $maxSize bytes',
      AttachmentBlockedError(:final fileExtension, :final mimeType) =>
        'Attachment type not allowed (${fileExtension ?? mimeType})',
      _ => null,
    };
    if (message != null) showSnackBar(message);
  },
)
```

### Removed parameters

Many parameters that existed in `StreamMessageInput` have been removed from `StreamMessageComposer`. The table below lists each removed parameter and the recommended migration path.

#### Layout and visual parameters

These parameters have been removed. The composer layout is now fully owned by `StreamChatMessageInput` and its sub-components, customizable via `StreamComponentFactory`.

| Removed parameter               | Migration path                                                                                  |
| ------------------------------- | ----------------------------------------------------------------------------------------------- |
| `maxHeight`                     | No direct replacement. The text field grows to fit its content without a height cap.            |
| `maxLines`                      | No direct replacement.                                                                          |
| `minLines`                      | No direct replacement.                                                                          |
| `padding`                       | No direct replacement. Layout is controlled by the design system.                               |
| `textInputMargin`               | No direct replacement.                                                                          |
| `elevation`                     | No direct replacement. Visual styling is controlled by the design system theme.                 |
| `shadow`                        | No direct replacement.                                                                          |
| `enableActionAnimation`         | Removed. Actions no longer animate in/out.                                                      |
| `contentInsertionConfiguration` | Removed.                                                                                        |
| `sendButtonLocation`            | Removed. The send button is always placed in the trailing position by the design system layout. |

#### Action and button parameters

These parameters have been removed. To customize buttons and actions in the composer, override the relevant sub-component via `StreamComponentFactory`.

| Removed parameter         | Migration path                                                                              |
| ------------------------- | ------------------------------------------------------------------------------------------- |
| `actionsBuilder`          | Override `messageComposerLeading` or `messageComposerTrailing` in `StreamComponentFactory`. |
| `spaceBetweenActions`     | No direct replacement.                                                                      |
| `actionsLocation`         | Removed. The design system defines a fixed layout.                                          |
| `attachmentButtonBuilder` | Override `messageComposerLeading` in `StreamComponentFactory`.                              |
| `commandButtonBuilder`    | Override `messageComposerInputTrailing` in `StreamComponentFactory`.                        |
| `sendButtonBuilder`       | Override `messageComposerTrailing` in `StreamComponentFactory`.                             |
| `idleSendIcon`            | Override `messageComposerTrailing` in `StreamComponentFactory`.                             |
| `activeSendIcon`          | Override `messageComposerTrailing` in `StreamComponentFactory`.                             |
| `showCommandsButton`      | Override `messageComposerInputTrailing` in `StreamComponentFactory`.                        |

#### Attachment builder parameters

These parameters have been removed. Attachment rendering in the composer input header is now customizable via `StreamComponentFactory` — see [Attachment Customization](#attachment-customization).

| Removed parameter                          | Migration path                                                                                                             |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `attachmentListBuilder`                    | Override `messageComposerAttachmentList` in `StreamComponentFactory`.                                                      |
| `fileAttachmentListBuilder`                | Override `messageComposerAttachmentList` in `StreamComponentFactory`.                                                      |
| `mediaAttachmentListBuilder`               | Override `messageComposerAttachmentList` in `StreamComponentFactory`.                                                      |
| `voiceRecordingAttachmentListBuilder`      | Override `messageComposerAttachmentList` in `StreamComponentFactory`.                                                      |
| `fileAttachmentBuilder`                    | Override `messageComposerAttachment` in `StreamComponentFactory`.                                                          |
| `mediaAttachmentBuilder`                   | Override `messageComposerAttachment` in `StreamComponentFactory`.                                                          |
| `voiceRecordingAttachmentBuilder`          | Override `messageComposerAttachment` in `StreamComponentFactory`.                                                          |
| `quotedMessageBuilder`                     | Override `messageComposerInputHeader` or `messageComposerInput` in `StreamComponentFactory`.                               |
| `quotedMessageAttachmentThumbnailBuilders` | Override `messageComposerInputHeader`, `messageComposerInput`, or `messageComposerAttachment` in `StreamComponentFactory`. |

### Attachment button visibility

Previously, the attachment button was always rendered (though inactive) when `disableAttachments: true` was set. The button is now fully hidden (removed from the layout) when no attachment callback is wired up. When you pass `disableAttachments: true` to `StreamMessageComposer`, the attachment button no longer appears at all.

If you are using `StreamChatMessageInput` directly, the button hides when `onAttachmentButtonPressed` is `null`.

---

## StreamChatMessageInput (new)

`StreamChatMessageInput` is a pure UI component from the new design system. It renders the composer layout but contains no message-sending logic — your code is responsible for wiring up the controller and callbacks.

Use this when you want the new design system visuals with custom business logic. If you want the full out-of-the-box experience (send, edit, attachments, mentions, commands, etc.), use `StreamMessageComposer` instead.

### Constructor Parameters

| Parameter                         | Type                               | Default                         | Description                                                                                                                                                                                                                                                                                                                                                                                                                          |
| --------------------------------- | ---------------------------------- | ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `onSendPressed`                   | `VoidCallback`                     | **required**                    | Called when the send button is pressed                                                                                                                                                                                                                                                                                                                                                                                               |
| `controller`                      | `StreamMessageComposerController?` | `null`                          | Controller for the input; created internally if not provided                                                                                                                                                                                                                                                                                                                                                                         |
| `onAttachmentButtonPressed`       | `VoidCallback?`                    | `null`                          | Called when the attachment button is pressed. When `null`, the attachment button is hidden.                                                                                                                                                                                                                                                                                                                                          |
| `isPickerOpen`                    | `bool`                             | `false`                         | Whether the inline attachment picker is currently open                                                                                                                                                                                                                                                                                                                                                                               |
| `focusNode`                       | `FocusNode?`                       | `null`                          | Focus node for the text field                                                                                                                                                                                                                                                                                                                                                                                                        |
| `currentUserId`                   | `String?`                          | `null`                          | Current user's ID                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `placeholder`                     | `String?`                          | `null`                          | Placeholder text for the input field. `StreamChatMessageInput` is a pure UI component — when wiring it up directly, compute this string yourself (use `MessageInputPlaceholder.resolve(controller)` from the [Message Input Placeholder API](#message-input-placeholder-api) if you want the built-in state machine), or pass `null` for no placeholder. `StreamMessageComposer` resolves it for you reactively from its controller. |
| `audioRecorderController`         | `StreamAudioRecorderController?`   | `null`                          | Enables the voice recording UI when provided                                                                                                                                                                                                                                                                                                                                                                                         |
| `sendVoiceRecordingAutomatically` | `bool`                             | `false`                         | Sends the voice recording immediately on finish                                                                                                                                                                                                                                                                                                                                                                                      |
| `feedback`                        | `AudioRecorderFeedback`            | `const AudioRecorderFeedback()` | Haptic/audio feedback callbacks for the recording flow                                                                                                                                                                                                                                                                                                                                                                               |
| `canAlsoSendToChannel`            | `bool`                             | `false`                         | Shows the "also send to channel" checkbox (used in threads)                                                                                                                                                                                                                                                                                                                                                                          |
| `onQuotedMessageCleared`          | `VoidCallback?`                    | `null`                          | Called when the user removes the quoted message in the input header                                                                                                                                                                                                                                                                                                                                                                  |
| `textInputAction`                 | `TextInputAction?`                 | `null`                          | The keyboard action button type                                                                                                                                                                                                                                                                                                                                                                                                      |
| `keyboardType`                    | `TextInputType?`                   | `null`                          | The keyboard type for the text field                                                                                                                                                                                                                                                                                                                                                                                                 |
| `textCapitalization`              | `TextCapitalization`               | `sentences`                     | Text capitalization behaviour for the text field                                                                                                                                                                                                                                                                                                                                                                                     |
| `autofocus`                       | `bool`                             | `false`                         | Whether the text field should autofocus when built                                                                                                                                                                                                                                                                                                                                                                                   |
| `autocorrect`                     | `bool`                             | `true`                          | Whether autocorrect is enabled                                                                                                                                                                                                                                                                                                                                                                                                       |
| `isFloating`                      | `bool`                             | `false`                         | Whether the composer renders in a floating style (affects layout, shadow, and decoration)                                                                                                                                                                                                                                                                                                                                            |

### Sub-components

The layout is composed of named default sub-widgets that can be replaced via the `StreamComponentFactory`. Use the factory builder keys below to override any slot; the public default class (where one exists) can be referenced when you want to call the built-in implementation from inside a custom override.

| Factory builder key            | Description                                                                                         | Public default class                        |
| ------------------------------ | --------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `messageComposerLeading`       | Left side of the composer row (e.g., attachment button)                                             | `DefaultStreamMessageComposerLeading`       |
| `messageComposerTrailing`      | Right side of the composer row (empty by default; add a custom widget here to extend the outer row) | —                                           |
| `messageComposerInput`         | The whole input container (assembles header, leading, center, and trailing)                         | `DefaultStreamMessageComposerInput`         |
| `messageComposerInputLeading`  | Left side inside the input area (empty by default)                                                  | —                                           |
| `messageComposerInputCenter`   | The actual text field area (text input or audio recording UI)                                       | `DefaultStreamMessageComposerInputCenter`   |
| `messageComposerInputTrailing` | Right side inside the input area (send/mic button)                                                  | `DefaultStreamMessageComposerInputTrailing` |
| `messageComposerInputHeader`   | Header above the input (reply/edit preview, attachment thumbnails)                                  | —                                           |

### Customization via Component Factory

To replace the entire composer UI, provide a builder for `MessageComposerProps` in your `StreamComponentFactory`:

```dart
StreamComponentFactory(
  builders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      messageComposer: (context, props) => MyCustomComposer(props: props),
    ),
  ),
  child: ...,
)
```

---

## StreamMessageComposerController Rename

The composer controller has been renamed from `StreamMessageInputController` to `StreamMessageComposerController` to match the widget it drives. The constructor no longer accepts a `message:` argument for entering edit mode — edit mode is now explicit.

### Renamed symbols

| Old                                                            | New                                                  |
| -------------------------------------------------------------- | ---------------------------------------------------- |
| `StreamMessageInputController`                                 | `StreamMessageComposerController`                    |
| `StreamRestorableMessageInputController`                       | `StreamRestorableMessageComposerController`          |
| `StreamMessageInputController.editingOriginalMessage`          | `StreamMessageComposerController.messageBeingEdited` |
| `StreamMessageComposer.messageInputController` constructor arg | `messageComposerController`                          |

### Edit-mode semantics

The controller no longer accepts a pre-edit message via the constructor. Use `editMessage(message)` to enter edit mode and `cancelEditMessage()` to exit. Calling `clear()` no longer exits edit mode — it only clears the composer content.

**Before:**

```dart
final controller = StreamMessageInputController(message: existingMessage);
// ...
controller.clear(); // also exited edit mode
```

**After:**

```dart
final controller = StreamMessageComposerController();
controller.editMessage(existingMessage);
// ...
controller.cancelEditMessage(); // explicit exit; restores prior content
```

`isEditing` (a new convenience getter) returns `true` while a message is being edited; `messageBeingEdited` exposes the original `Message`.

---

## StreamMessageComposerInput Split

The composer input has been split into two distinct layers to make the **outer container** vs the **text-field center** unambiguous. The old `StreamMessageComposerInput` (text-field widget) has been replaced by `StreamMessageComposerInputCenter`, and a new `StreamMessageComposerInput` outer container now wraps the header, leading, center, and trailing slots. Both `MessageComposerInputProps` (outer container) and `MessageComposerInputCenterProps` (text-field center) exist as distinct classes with different field sets — this is a split, not a straight rename.

| Old                                                     | New                                                                                          |
| ------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `StreamMessageComposerInput` (text-field widget)        | `StreamMessageComposerInputCenter`                                                           |
| `DefaultStreamMessageComposerInput`                     | `DefaultStreamMessageComposerInputCenter`                                                    |
| `MessageComposerInputProps`                             | `MessageComposerInputCenterProps` (text-field center); `MessageComposerInputProps` now refers to the outer container |
| Factory builder key `messageComposerInput` (text field) | `messageComposerInputCenter`                                                                 |

> **Important:** The factory builder key `messageComposerInput` still exists, but **now overrides the outer input container** (header + leading + center + trailing) instead of just the text field. If you previously used `messageComposerInput` to swap the text field, switch to `messageComposerInputCenter` to preserve the old behaviour.

**Before:**

```dart
streamChatComponentBuilders(
  messageComposerInput: (context, props) => MyCustomTextField(props: props),
)
```

**After:**

```dart
streamChatComponentBuilders(
  messageComposerInputCenter: (context, props) => MyCustomTextField(props: props),
)
```

The sub-component table in [StreamChatMessageInput (new)](#streamchatmessageinput-new) reflects the new names.

---

## Message Input Placeholder API

The input placeholder text (the dimmed text shown inside the input field when it is empty) is now driven by a sealed-class hierarchy that adapts to the current input state. The previous `HintType` enum and `HintGetter` typedef have been removed, and the customization hook on `StreamMessageComposer` is now called `placeholderBuilder`.

The new placeholder types live in `lib/src/message_input/message_input_placeholder.dart` and are re-exported from `package:stream_chat_flutter/stream_chat_flutter.dart`.

> **Layered model.** The placeholder *resolution* (state machine that turns controller state into a string) lives on `StreamMessageComposer`, the higher-level full-featured widget. The lower-level `StreamChatMessageInput` design-system component stays a pure UI primitive and accepts a plain `String placeholder` — see [StreamChatMessageInput (new)](#streamchatmessageinput-new). If you build directly on `StreamChatMessageInput`, call `MessageInputPlaceholder.resolve(controller)` and your own builder yourself, then pass the resulting string in.

### What was removed

| Removed                                                                                      | Replacement                                                                                                                                                                                                                                                              |
| -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `enum HintType` (`searchGif`, `addACommentOrSend`, `slowModeOn`, `command`, `writeAMessage`) | `sealed class MessageInputPlaceholder` with `final` cases `WriteMessagePlaceholder`, `SlowModePlaceholder`, `CommandPlaceholder`, `AttachmentsPlaceholder` (each carries the contextual data for that state — see [Sealed-class state shape](#sealed-class-state-shape)) |
| `typedef HintGetter = String? Function(BuildContext, HintType, Command?)`                    | `typedef MessageInputPlaceholderBuilder = String? Function(BuildContext, MessageInputPlaceholder)`                                                                                                                                                                       |
| `HintType resolveMessageInputHintType(controller)`                                           | `MessageInputPlaceholder.resolve(controller)` factory                                                                                                                                                                                                                    |
| `Command? resolveActiveMessageInputCommand(context, controller)`                             | Removed. Use `controller.message.command` (a `String?`) directly. The SDK no longer looks up the full `Command` object from the channel config when resolving the placeholder.                                                                                           |
| `String? defaultMessageInputHintGetter(...)`                                                 | Removed from the public API. The default behaviour is now baked into `StreamMessageComposer.placeholderBuilder`'s default value. To customize, supply your own builder with an exhaustive `switch` over [`MessageInputPlaceholder`](#sealed-class-state-shape).          |
| `StreamMessageInput.hintGetter`                                                              | `StreamMessageComposer.placeholderBuilder`                                                                                                                                                                                                                               |

### Behavior change: precedence

The order in which input states are evaluated to pick a placeholder has changed:

|     | Old order      | New order      |
| --- | -------------- | -------------- |
| 1   | `command`      | `slowMode`     |
| 2   | `attachments`  | `command`      |
| 3   | `slowMode`     | `attachments`  |
| 4   | `writeMessage` | `writeMessage` |

When slow mode is active and a command is also active (or attachments are present), the slow-mode placeholder now wins. This matches the iOS SDK. To restore the old order, override `placeholderBuilder` and short-circuit on `CommandPlaceholder` / `AttachmentsPlaceholder` before falling back to the default.

### Behavior change: default placeholders for built-in commands

The default builder now renders dedicated placeholders for Stream's built-in user-target commands, matching the redesigned Figma:

| Command                              | Placeholder (English) | Localization key             |
| ------------------------------------ | --------------------- | ---------------------------- |
| `/giphy`                             | `Search GIFs`         | `searchGifLabel`             |
| `/mute`, `/unmute`, `/ban`, `/unban` | `@username`           | `commandUsernameLabel` (new) |
| Any other backend command            | `Send a message`      | `writeAMessageLabel`         |

`commandUsernameLabel` is a new translation key — see the [Localizations migration guide](localizations.md) if you have a custom `Translations` subclass.

> **Note:** The previous default fell back to `Command.args` (the server-provided argument template, e.g. `[@username] [text]`) for unknown commands. The new default uses `writeAMessageLabel`. If you want command-aware placeholders for backend-defined custom commands, override `placeholderBuilder` and pattern-match on `CommandPlaceholder.command`.

### Behavior change: default placeholder for pending attachments

The default builder no longer uses `addACommentOrSendLabel` ("Add a comment or send") when the input only has attachments and no text — it now falls back to `writeAMessageLabel` ("Send a message"), matching the empty/idle state. The `addACommentOrSendLabel` translation key is still part of the public `Translations` interface, so to restore the old behaviour override `placeholderBuilder` and map `AttachmentsPlaceholder()` to `translations.addACommentOrSendLabel` yourself.

### Behavior change: slow mode

While slow mode is active for the current user, the composer is now visibly locked instead of just guarding the send call:

- The text input is disabled (`enabled: false`) so the user cannot edit the field.
- The trailing send button is replaced by a disabled countdown button showing the remaining seconds (e.g. `9`).
- The placeholder shows a live countdown such as `Slow mode, wait 9s…` (English default), driven by `Translations.slowModeOnLabel(int cooldownTimeOut)`. The translation key changed signature — see the [Localizations migration guide](localizations.md).

Once the cooldown reaches zero the input is automatically re-enabled and the regular send / microphone button returns. To restore the previous behaviour (editable input + normal send button while slow mode is active), supply your own `placeholderBuilder` and a custom trailing component via `streamChatComponentBuilders(messageComposerInputTrailing: ...)`.

### Sealed-class state shape

Each case carries the contextual data relevant to that input state. Pattern-match on these fields in your `placeholderBuilder` to render rich, state-aware placeholders.

| Case                      | Field             | Type               | Description                                                                                                                                        |
| ------------------------- | ----------------- | ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `WriteMessagePlaceholder` | `isEditing`       | `bool`             | `true` when the input is editing an existing message instead of composing a new one. Useful for swapping the placeholder while editing.            |
| `SlowModePlaceholder`     | `cooldownTimeOut` | `int`              | Remaining slow-mode cooldown in seconds. Mirrors `StreamMessageComposerController.cooldownTimeOut`.                                                |
| `SlowModePlaceholder`     | `cooldown`        | `Duration`         | Convenience getter wrapping `cooldownTimeOut` for formatting timer strings.                                                                        |
| `CommandPlaceholder`      | `command`         | `String`           | Active command name (e.g. `'giphy'`, `'mute'`, `'ban'`, or any backend-defined command).                                                           |
| `AttachmentsPlaceholder`  | `attachments`     | `List<Attachment>` | Pending attachments held by the input. OG link previews are still included — filter via `Attachment.ogScrapeUrl` if you only want user-added ones. |

Example using the new fields (note that the sealed type forces an exhaustive switch — every case must be handled):

```dart
StreamMessageComposer(
  placeholderBuilder: (context, placeholder) {
    final translations = context.translations;
    return switch (placeholder) {
      SlowModePlaceholder(:final cooldownTimeOut) =>
        translations.slowModeOnLabel(cooldownTimeOut),
      CommandPlaceholder(command: 'giphy') => translations.searchGifLabel,
      CommandPlaceholder(command: 'mute' || 'unmute' || 'ban' || 'unban') =>
        translations.commandUsernameLabel,
      CommandPlaceholder() => translations.writeAMessageLabel,
      AttachmentsPlaceholder(:final attachments)
          when attachments.every((a) => a.type == AttachmentType.image) =>
        'Add a comment to your photo',
      AttachmentsPlaceholder(:final attachments)
          when attachments.every((a) => a.type == AttachmentType.video) =>
        'Add a comment to your video',
      AttachmentsPlaceholder() => translations.addACommentOrSendLabel,
      WriteMessagePlaceholder(isEditing: true) => 'Edit your message…',
      WriteMessagePlaceholder() => translations.writeAMessageLabel,
    };
  },
)
```

### Migration

**Before:**

```dart
StreamMessageInput(
  hintGetter: (context, type, command) {
    return switch (type) {
      HintType.searchGif => 'Search a GIF',
      HintType.slowModeOn => 'Slow mode is on',
      HintType.addACommentOrSend => 'Add a comment...',
      HintType.command => command?.args ?? 'Type a message',
      HintType.writeAMessage => 'Write a message',
    };
  },
)
```

**After:**

```dart
StreamMessageComposer(
  placeholderBuilder: (context, placeholder) {
    return switch (placeholder) {
      SlowModePlaceholder() => 'Slow mode is on',
      CommandPlaceholder(command: 'giphy') => 'Search a GIF',
      CommandPlaceholder(command: 'mute' || 'ban') => '@username',
      CommandPlaceholder() => 'Type a message',
      AttachmentsPlaceholder() => 'Add a comment...',
      WriteMessagePlaceholder() => 'Write a message',
    };
  },
)
```

For backend-defined custom commands, pattern-match the relevant `CommandPlaceholder.command` values and use the SDK's localized labels for everything else:

```dart
StreamMessageComposer(
  placeholderBuilder: (context, placeholder) {
    final translations = context.translations;
    return switch (placeholder) {
      SlowModePlaceholder(:final cooldownTimeOut) =>
        translations.slowModeOnLabel(cooldownTimeOut),
      CommandPlaceholder(command: 'weather') => 'Type a city name',
      CommandPlaceholder(command: 'tip') => 'Type @user amount',
      CommandPlaceholder(command: 'poll') => 'Type your question',
      CommandPlaceholder(command: 'giphy') => translations.searchGifLabel,
      CommandPlaceholder(command: 'mute' || 'unmute' || 'ban' || 'unban') =>
        translations.commandUsernameLabel,
      CommandPlaceholder() => translations.writeAMessageLabel,
      AttachmentsPlaceholder() => translations.addACommentOrSendLabel,
      WriteMessagePlaceholder() => translations.writeAMessageLabel,
    };
  },
)
```

The exhaustive `switch` over `MessageInputPlaceholder` means adding a new case in a future SDK release will be a compile error rather than a silent fallthrough — your override stays explicit about which states it handles.

---

## Attachment Customization

The attachment thumbnails shown in the composer input header are now rendered by two new customizable widgets. Both integrate with `StreamComponentFactory`.

### `StreamMessageComposerAttachmentList`

Renders the full list of attachment thumbnails in the composer. The old `StreamMessageInputAttachmentList` class has been **deleted** — any direct reference to it will cause a compile error. Use `StreamMessageComposerAttachmentList` instead.

**Props class:** `StreamMessageComposerAttachmentListProps`

| Property          | Type                       | Description                                                                                     |
| ----------------- | -------------------------- | ----------------------------------------------------------------------------------------------- |
| `attachments`     | `Iterable<Attachment>`     | The attachments to display (OG link previews are filtered out before this widget receives them) |
| `onRemovePressed` | `ValueSetter<Attachment>?` | Called when the user removes an attachment                                                      |

Override the whole list using the `messageComposerAttachmentList` builder key:

```dart
streamChatComponentBuilders(
  messageComposerAttachmentList: (context, props) {
    return MyCustomAttachmentList(
      attachments: props.attachments,
      onRemovePressed: props.onRemovePressed,
    );
  },
)
```

### `StreamMessageComposerAttachment`

Renders a single attachment thumbnail inside the list. Use this to customise how individual attachment types are displayed without replacing the whole list.

**Props class:** `StreamMessageComposerAttachmentProps`

| Property                  | Type                             | Description                                                      |
| ------------------------- | -------------------------------- | ---------------------------------------------------------------- |
| `attachment`              | `Attachment`                     | The attachment to render                                         |
| `onRemovePressed`         | `ValueSetter<Attachment>?`       | Called when the user taps the remove button                      |
| `audioPlaylistController` | `StreamAudioPlaylistController?` | Shared playlist controller for audio/voice-recording attachments |

Override individual attachment items using the `messageComposerAttachment` builder key:

```dart
streamChatComponentBuilders(
  messageComposerAttachment: (context, props) {
    // Render video attachments differently; fall back to default for everything else.
    if (props.attachment.type == AttachmentType.video) {
      return MyVideoAttachmentThumbnail(
        attachment: props.attachment,
        onRemovePressed: props.onRemovePressed,
      );
    }
    return DefaultMessageComposerAttachment(props: props);
  },
)
```

### Built-in attachment builder helpers

The following public widget is provided as a building block for custom attachment renderers:

| Widget                         | Description                                                                       |
| ------------------------------ | --------------------------------------------------------------------------------- |
| `StreamMediaAttachmentBuilder` | Renders an image, video, or GIF attachment thumbnail with an optional media badge |

---

## Removed Widgets

The following composer-adjacent widgets have been removed. Replace any direct references with the listed alternatives.

| Removed Widget              | Replacement                                                                                                                                                                                                     |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `AttachmentButton`          | Built into `StreamMessageComposer` / `StreamChatMessageInput`; override `messageComposerLeading` via `StreamComponentFactory` to customize                                                                      |
| `StreamQuotedMessageWidget` | Use `StreamQuotedMessage`                                                                                                                                                                                       |
| `EditMessageSheet`          | Editing is handled inline by the composer via `controller.editMessage(message)` — see [StreamMessageComposerController Rename](#streammessagecomposercontroller-rename)                                         |
| `StreamMessageSendButton`   | Part of the composer internals; override `messageComposerInputTrailing` via `StreamComponentFactory` to customize the send button                                                                               |
| `ErrorAlertSheet`           | No longer publicly exported (still used internally by `StreamMessageComposer`) — surface attachment/composer errors via your own UI (e.g. a `SnackBar` or `AlertDialog`) using the typed errors documented in [v10-migration.md](../v10-migration.md#streamattachmentpickercontroller) |

`AttachmentButton` example:

**Before:**

```dart
AttachmentButton(
  color: Colors.blue,
  onPressed: () => openCustomPicker(),
)
```

**After:** override the leading slot via the component factory.

```dart
streamChatComponentBuilders(
  messageComposerLeading: (context, props) => IconButton(
    icon: Icon(context.streamIcons.attachment, color: Colors.blue),
    onPressed: () => openCustomPicker(),
  ),
)
```

`StreamQuotedMessageWidget` example:

**Before:**

```dart
StreamQuotedMessageWidget(message: quotedMessage)
```

**After:**

```dart
StreamQuotedMessage(message: quotedMessage)
```

---

## Theme Removal: StreamMessageInputThemeData

`StreamMessageInputThemeData` and the `StreamChatThemeData.messageInputTheme` accessor have been **removed**. The composer is now styled via the design-system primitives — `context.streamColorScheme` for colors and `context.streamRadius` for corner radii — read directly by the sub-components. `StreamMessageComposer` has no `backgroundColor` or `border` constructor parameters; use `StreamComponentFactory` builder overrides to customize the appearance of individual sub-components.

| Removed                                 | Replacement                                                                                          |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `StreamMessageInputThemeData`           | Design-system primitives on `StreamTheme` + per-sub-component overrides via `StreamComponentFactory` |
| `StreamChatThemeData.messageInputTheme` | Removed                                                                                              |

There is no one-to-one replacement — most fields on the old `StreamMessageInputThemeData` mapped to the legacy composer layout, which is now owned by `StreamChatMessageInput` and customized via slot overrides. See [StreamChatMessageInput (new)](#streamchatmessageinput-new) and the sub-component factory keys for the supported customization surface.

---

## Migration Checklist

- [ ] Rename `StreamMessageInput` to `StreamMessageComposer` in all usages
- [ ] Rename `StreamMessageInputController` to `StreamMessageComposerController` (and `StreamRestorableMessageInputController` to `StreamRestorableMessageComposerController`)
- [ ] Rename `StreamMessageComposer.messageInputController` constructor argument to `messageComposerController`
- [ ] Replace `StreamMessageComposerController(message: existingMessage)` with `controller.editMessage(existingMessage)` to enter edit mode
- [ ] Replace `controller.clear()` (used to exit edit mode) with `controller.cancelEditMessage()` — `clear()` no longer exits edit mode
- [ ] Rename `editingOriginalMessage` reads to `messageBeingEdited`
- [ ] Replace the old `StreamMessageComposerInput` text-field widget with `StreamMessageComposerInputCenter` (and `DefaultStreamMessageComposerInput` → `DefaultStreamMessageComposerInputCenter`); note that `MessageComposerInputProps` and `MessageComposerInputCenterProps` are now distinct classes — update props usage to the center variant for text-field customization
- [ ] Switch any factory override that previously used the `messageComposerInput` key to render a custom text field over to `messageComposerInputCenter` — the old key now overrides the outer input container
- [ ] Rename `hideSendAsDm` to `canAlsoSendToChannelFromThread` in all `StreamMessageComposer` usages and invert the value
- [ ] Review usages of `attachmentLimit` — it is now a non-nullable `int` defaulting to `StreamAttachmentValidator.defaultMaxAttachmentCount` (`30`, the backend cap); set an explicit smaller value to tighten the limit
- [ ] Remove `maxAttachmentSize` from any `StreamMessageComposer` call — size limits now come from `StreamChatClient.appSettings`; the SDK falls back to `UploadConfig.defaultSizeLimit` (100 MB) when the backend value is `0`
- [ ] Remove `onAttachmentLimitExceed` from any `StreamMessageComposer` call — the default error sheet now handles all validator failures, or pass `onError: (error, stackTrace) { … }` to render a custom UI (the callback short-circuits the default sheet and receives the typed `AttachmentLimitReachedError` / `AttachmentTooLargeError` / `AttachmentBlockedError`)
- [ ] Remove any usage of `maxHeight`, `maxLines`, `minLines`, `padding`, `textInputMargin`, `elevation`, `shadow`, `enableActionAnimation`, `contentInsertionConfiguration`, `sendButtonLocation`
- [ ] Replace `actionsBuilder` / `actionsLocation` / button builder params (`attachmentButtonBuilder`, `commandButtonBuilder`, `sendButtonBuilder`, `idleSendIcon`, `activeSendIcon`, `showCommandsButton`) with sub-component overrides via `StreamComponentFactory`
- [ ] Replace attachment list builder params (`attachmentListBuilder`, `fileAttachmentListBuilder`, `mediaAttachmentListBuilder`, `voiceRecordingAttachmentListBuilder`) with the `messageComposerAttachmentList` builder in `StreamComponentFactory`
- [ ] Replace attachment item builder params (`fileAttachmentBuilder`, `mediaAttachmentBuilder`, `voiceRecordingAttachmentBuilder`) with the `messageComposerAttachment` builder in `StreamComponentFactory`
- [ ] Replace `quotedMessageBuilder` / `quotedMessageAttachmentThumbnailBuilders` with `messageComposerInputHeader` or `messageComposerAttachment` overrides in `StreamComponentFactory`
- [ ] If adopting `StreamChatMessageInput` directly, wire up your own send/attachment logic via `onSendPressed` and `onAttachmentButtonPressed`
- [ ] Move any composer UI customizations to `StreamComponentFactory`
- [ ] Remove any direct references to `AttachmentButton`, `StreamQuotedMessageWidget`, `EditMessageSheet`, `StreamMessageSendButton`, and `ErrorAlertSheet` — see [Removed Widgets](#removed-widgets)
- [ ] Replace `StreamQuotedMessageWidget` with `StreamQuotedMessage`
- [ ] Remove any `StreamMessageInputThemeData` / `StreamChatThemeData.messageInputTheme` usage — style via `StreamTheme` design-system primitives and `StreamComponentFactory` slot overrides
- [ ] Rename `StreamMessageInput.hintGetter` to `placeholderBuilder` and rewrite the callback to switch over `MessageInputPlaceholder` cases (`SlowModePlaceholder`, `CommandPlaceholder`, `AttachmentsPlaceholder`, `WriteMessagePlaceholder`) instead of the removed `HintType` enum. If you build directly on `StreamChatMessageInput`, compute the placeholder string yourself via `MessageInputPlaceholder.resolve(controller)` and pass it via the `placeholder: String` parameter.
- [ ] Review the new placeholder precedence (`slowMode > command > attachments > writeMessage`) and override `placeholderBuilder` if you need to preserve the old order
- [ ] Add command-specific placeholders for any backend-defined commands you ship by pattern-matching on `CommandPlaceholder.command` in your `placeholderBuilder`
