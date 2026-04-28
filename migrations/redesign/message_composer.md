# Message Composer Migration Guide

This guide covers the migration for the message composer components in the Stream Chat Flutter SDK design refresh.

---

## Table of Contents

- [Overview](#overview)
- [StreamMessageInput](#streammessageinput)
- [StreamMessageComposer (new)](#streamchatmessagecomposer-new)
- [Attachment Customization](#attachment-customization)
- [Migration Checklist](#migration-checklist)

---

## Overview

There are two distinct composer components with different responsibilities:

| Component | Responsibility |
|-----------|---------------|
| `StreamMessageInput` | Full-featured widget: handles sending, editing, attachments, autocomplete, mentions, commands, OG previews, voice recording flow, etc. |
| `StreamMessageComposer` | UI-only component: renders the composer layout using design system primitives. No business logic. |

`StreamMessageInput` wraps `StreamMessageComposer` for its visual layer. If you are using `StreamMessageInput` today, it remains the right choice — it is not deprecated. `StreamMessageComposer` exists for cases where you want to build your own message-sending logic and use the new design system UI.

---

## StreamMessageInput

`StreamMessageInput` handles all message composition logic. This section documents all breaking changes.

### Breaking Change: `hideSendAsDm` renamed to `canAlsoSendToChannelFromThread` (logic inverted)

| Old | New |
|-----|-----|
| `hideSendAsDm: true` | `canAlsoSendToChannelFromThread: false` |
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
StreamMessageInput(
  canAlsoSendToChannelFromThread: false,  // hide the checkbox
)
```

> **Note:** `canAlsoSendToChannelFromThread` defaults to `true`, matching the old default of showing the checkbox when inside a thread.

### Breaking Change: `attachmentLimit` is now optional

`attachmentLimit` changed from a required `int` (default `10`) to an optional `int?`. When `null` (the new default), no attachment count limit is enforced.

**Before:**
```dart
StreamMessageInput(
  attachmentLimit: 5,
)
```

**After (with limit):**
```dart
StreamMessageInput(
  attachmentLimit: 5,
)
```

**After (no limit — new default behaviour):**
```dart
StreamMessageInput(
  // attachmentLimit not set — no limit applied
)
```

### Removed parameters

Many parameters that existed in older versions of `StreamMessageInput` have been removed. The table below lists each removed parameter and the recommended migration path.

#### Layout and visual parameters

These parameters have been removed. The composer layout is now fully owned by `StreamMessageComposer` and its sub-components, customizable via `StreamComponentFactory`.

| Removed parameter | Migration path |
|-------------------|---------------|
| `maxHeight` | No direct replacement. The text field grows to fit its content without a height cap. |
| `maxLines` | No direct replacement. |
| `minLines` | No direct replacement. |
| `padding` | No direct replacement. Layout is controlled by the design system. |
| `textInputMargin` | No direct replacement. |
| `elevation` | No direct replacement. Visual styling is controlled by the design system theme. |
| `shadow` | No direct replacement. |
| `enableActionAnimation` | Removed. Actions no longer animate in/out. |
| `contentInsertionConfiguration` | Removed. |
| `sendButtonLocation` | Removed. The send button is always placed in the trailing position by the design system layout. |

#### Action and button parameters

These parameters have been removed. To customize buttons and actions in the composer, override the relevant sub-component via `StreamComponentFactory`.

| Removed parameter | Migration path |
|-------------------|---------------|
| `actionsBuilder` | Override `messageComposerLeading` or `messageComposerTrailing` in `StreamComponentFactory`. |
| `spaceBetweenActions` | No direct replacement. |
| `actionsLocation` | Removed. The design system defines a fixed layout. |
| `attachmentButtonBuilder` | Override `messageComposerLeading` in `StreamComponentFactory`. |
| `commandButtonBuilder` | Override `messageComposerInputTrailing` in `StreamComponentFactory`. |
| `sendButtonBuilder` | Override `messageComposerTrailing` in `StreamComponentFactory`. |
| `idleSendIcon` | Override `messageComposerTrailing` in `StreamComponentFactory`. |
| `activeSendIcon` | Override `messageComposerTrailing` in `StreamComponentFactory`. |
| `showCommandsButton` | Override `messageComposerInputTrailing` in `StreamComponentFactory`. |

#### Attachment builder parameters

These parameters have been removed. Attachment rendering in the composer input header is now customizable via `StreamComponentFactory` — see [Attachment Customization](#attachment-customization).

| Removed parameter | Migration path |
|-------------------|---------------|
| `attachmentListBuilder` | Override `messageComposerAttachmentList` in `StreamComponentFactory`. |
| `fileAttachmentListBuilder` | Override `messageComposerAttachmentList` in `StreamComponentFactory`. |
| `mediaAttachmentListBuilder` | Override `messageComposerAttachmentList` in `StreamComponentFactory`. |
| `voiceRecordingAttachmentListBuilder` | Override `messageComposerAttachmentList` in `StreamComponentFactory`. |
| `fileAttachmentBuilder` | Override `messageComposerAttachment` in `StreamComponentFactory`. |
| `mediaAttachmentBuilder` | Override `messageComposerAttachment` in `StreamComponentFactory`. |
| `voiceRecordingAttachmentBuilder` | Override `messageComposerAttachment` in `StreamComponentFactory`. |
| `quotedMessageBuilder` | Override `messageComposerInputHeader` in `StreamComponentFactory`. |
| `quotedMessageAttachmentThumbnailBuilders` | Override `messageComposerInputHeader` or `messageComposerAttachment` in `StreamComponentFactory`. |

### Attachment button visibility

Previously, the attachment button was always rendered (though inactive) when `disableAttachments: true` was set. The button is now fully hidden (removed from the layout) when no attachment callback is wired up. When you pass `disableAttachments: true` to `StreamMessageInput`, the attachment button no longer appears at all.

If you are using `StreamMessageComposer` directly, the button hides when `onAttachmentButtonPressed` is `null`.

---

## StreamMessageComposer (new)

`StreamMessageComposer` is a pure UI component from the new design system. It renders the composer layout but contains no message-sending logic — your code is responsible for wiring up the controller and callbacks.

Use this when you want the new design system visuals with custom business logic. If you want the full out-of-the-box experience (send, edit, attachments, mentions, commands, etc.), use `StreamMessageInput` instead.

### Constructor Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onSendPressed` | `VoidCallback` | **required** | Called when the send button is pressed |
| `controller` | `StreamMessageInputController?` | `null` | Controller for the input; created internally if not provided |
| `onAttachmentButtonPressed` | `VoidCallback?` | `null` | Called when the attachment button is pressed. When `null`, the attachment button is hidden. |
| `isPickerOpen` | `bool` | `false` | Whether the inline attachment picker is currently open |
| `focusNode` | `FocusNode?` | `null` | Focus node for the text field |
| `currentUserId` | `String?` | `null` | Current user's ID |
| `placeholder` | `String` | `''` | Placeholder text for the input field |
| `audioRecorderController` | `StreamAudioRecorderController?` | `null` | Enables the voice recording UI when provided |
| `sendVoiceRecordingAutomatically` | `bool` | `false` | Sends the voice recording immediately on finish |
| `feedback` | `AudioRecorderFeedback` | `const AudioRecorderFeedback()` | Haptic/audio feedback callbacks for the recording flow |
| `canAlsoSendToChannel` | `bool` | `false` | Shows the "also send to channel" checkbox (used in threads) |
| `onQuotedMessageCleared` | `VoidCallback?` | `null` | Called when the user removes the quoted message in the input header |
| `textInputAction` | `TextInputAction?` | `null` | The keyboard action button type |
| `keyboardType` | `TextInputType?` | `null` | The keyboard type for the text field |
| `textCapitalization` | `TextCapitalization` | `sentences` | Text capitalization behaviour for the text field |
| `autofocus` | `bool` | `false` | Whether the text field should autofocus when built |
| `autocorrect` | `bool` | `true` | Whether autocorrect is enabled |

### Sub-components

The layout is composed of named default sub-widgets that can be replaced via the `StreamComponentFactory`:

| Sub-component | Description |
|---------------|-------------|
| `DefaultMessageComposerLeading` | Left side of the composer row (e.g., attachment button) |
| `DefaultMessageComposerTrailing` | Right side of the composer row (e.g., send/mic button) |
| `DefaultMessageComposerInputLeading` | Left side inside the input area |
| `DefaultMessageComposerInputTrailing` | Right side inside the input area |
| `DefaultMessageComposerInputHeader` | Header above the input (e.g., reply/edit preview, attachment thumbnails) |

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

## Attachment Customization

The attachment thumbnails shown in the composer input header are now rendered by two new customizable widgets. Both integrate with `StreamComponentFactory`.

### `StreamMessageComposerAttachmentList`

Renders the full list of attachment thumbnails in the composer. The old `StreamMessageInputAttachmentList` class has been **deleted** — any direct reference to it will cause a compile error. Use `StreamMessageComposerAttachmentList` instead.

**Props class:** `StreamMessageComposerAttachmentListProps`

| Property | Type | Description |
|----------|------|-------------|
| `attachments` | `Iterable<Attachment>` | The attachments to display (OG link previews are filtered out before this widget receives them) |
| `onRemovePressed` | `ValueSetter<Attachment>?` | Called when the user removes an attachment |

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

| Property | Type | Description |
|----------|------|-------------|
| `attachment` | `Attachment` | The attachment to render |
| `onRemovePressed` | `ValueSetter<Attachment>?` | Called when the user taps the remove button |
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

The following public widgets are provided as building blocks for custom attachment renderers:

| Widget | Description |
|--------|-------------|
| `StreamAudioAttachmentBuilder` | Renders an audio or voice-recording attachment with playback controls |
| `StreamFileAttachmentBuilder` | Renders a generic file attachment with file type icon, name, and size |
| `StreamMediaAttachmentBuilder` | Renders an image, video, or GIF attachment thumbnail with an optional media badge |
| `RemoveAttachmentButton` | The standard filled icon button used to dismiss an attachment |

---

## Migration Checklist

- [ ] Rename `hideSendAsDm` to `canAlsoSendToChannelFromThread` in all `StreamMessageInput` usages and invert the value
- [ ] Review usages of `attachmentLimit` — it is now `int?` and defaults to no limit; set an explicit value if you relied on the old default of `10`
- [ ] Remove any usage of `maxHeight`, `maxLines`, `minLines`, `padding`, `textInputMargin`, `elevation`, `shadow`, `enableActionAnimation`, `contentInsertionConfiguration`, `sendButtonLocation`
- [ ] Replace `actionsBuilder` / `actionsLocation` / button builder params (`attachmentButtonBuilder`, `commandButtonBuilder`, `sendButtonBuilder`, `idleSendIcon`, `activeSendIcon`, `showCommandsButton`) with sub-component overrides via `StreamComponentFactory`
- [ ] Replace attachment list builder params (`attachmentListBuilder`, `fileAttachmentListBuilder`, `mediaAttachmentListBuilder`, `voiceRecordingAttachmentListBuilder`) with the `messageComposerAttachmentList` builder in `StreamComponentFactory`
- [ ] Replace attachment item builder params (`fileAttachmentBuilder`, `mediaAttachmentBuilder`, `voiceRecordingAttachmentBuilder`) with the `messageComposerAttachment` builder in `StreamComponentFactory`
- [ ] Replace `quotedMessageBuilder` / `quotedMessageAttachmentThumbnailBuilders` with `messageComposerInputHeader` or `messageComposerAttachment` overrides in `StreamComponentFactory`
- [ ] If adopting `StreamMessageComposer` directly, wire up your own send/attachment logic via `onSendPressed` and `onAttachmentButtonPressed`
- [ ] Move any composer UI customizations to `StreamComponentFactory`
