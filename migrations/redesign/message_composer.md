# Message Composer Migration Guide

This guide covers the migration for the message composer components in the Stream Chat Flutter SDK design refresh.

---

## Table of Contents

- [Overview](#overview)
- [StreamMessageInput](#streammessageinput)
- [StreamChatMessageComposer (new)](#streamchatmessagecomposer-new)
- [Migration Checklist](#migration-checklist)

---

## Overview

There are two distinct composer components with different responsibilities:

| Component | Responsibility |
|-----------|---------------|
| `StreamMessageInput` | Full-featured widget: handles sending, editing, attachments, autocomplete, mentions, commands, OG previews, voice recording flow, etc. |
| `StreamChatMessageComposer` | UI-only component: renders the composer layout using design system primitives. No business logic. |

`StreamMessageInput` wraps `StreamChatMessageComposer` for its visual layer. If you are using `StreamMessageInput` today, it remains the right choice — it is not deprecated. `StreamChatMessageComposer` exists for cases where you want to build your own message-sending logic and use the new design system UI.

---

## StreamMessageInput

`StreamMessageInput` handles all message composition logic. The only breaking change in this redesign is a parameter rename.

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

---

## StreamChatMessageComposer (new)

`StreamChatMessageComposer` is a pure UI component from the new design system. It renders the composer layout but contains no message-sending logic — your code is responsible for wiring up the controller and callbacks.

Use this when you want the new design system visuals with custom business logic. If you want the full out-of-the-box experience (send, edit, attachments, mentions, commands, etc.), use `StreamMessageInput` instead.

### Constructor Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onSendPressed` | `VoidCallback` | **required** | Called when the send button is pressed |
| `controller` | `StreamMessageInputController?` | `null` | Controller for the input; created internally if not provided |
| `onAttachmentButtonPressed` | `VoidCallback?` | `null` | Called when the attachment button is pressed |
| `isPickerOpen` | `bool` | `false` | Whether the inline attachment picker is currently open |
| `focusNode` | `FocusNode?` | `null` | Focus node for the text field |
| `currentUserId` | `String?` | `null` | Current user's ID |
| `placeholder` | `String` | `''` | Placeholder text for the input field |
| `audioRecorderController` | `StreamAudioRecorderController?` | `null` | Enables the voice recording UI when provided |
| `sendVoiceRecordingAutomatically` | `bool` | `false` | Sends the voice recording immediately on finish |
| `feedback` | `AudioRecorderFeedback` | `const AudioRecorderFeedback()` | Haptic/audio feedback callbacks for the recording flow |
| `canAlsoSendToChannel` | `bool` | `false` | Shows the "also send to channel" checkbox (used in threads) |

### Sub-components

The layout is composed of named default sub-widgets that can be replaced via the `StreamComponentFactory`:

| Sub-component | Description |
|---------------|-------------|
| `DefaultMessageComposerLeading` | Left side of the composer row (e.g., attachment button) |
| `DefaultMessageComposerTrailing` | Right side of the composer row (e.g., send/mic button) |
| `DefaultMessageComposerInputLeading` | Left side inside the input area |
| `DefaultMessageComposerInputTrailing` | Right side inside the input area |
| `DefaultMessageComposerInputHeader` | Header above the input (e.g., reply/edit preview) |

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

## Migration Checklist

- [ ] Rename `hideSendAsDm` to `canAlsoSendToChannelFromThread` in all `StreamMessageInput` usages and invert the value
- [ ] If adopting `StreamChatMessageComposer` directly, wire up your own send/attachment logic via `onSendPressed` and `onAttachmentButtonPressed`
- [ ] Move any composer UI customizations to `StreamComponentFactory`
