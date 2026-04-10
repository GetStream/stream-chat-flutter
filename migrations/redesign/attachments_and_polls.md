# Attachments & Polls Migration Guide

This guide covers the migration for the redesigned attachment components, voice recording player, and poll interactor theming in Stream Chat Flutter SDK.

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [Architecture: Props + Component Factory](#architecture-props--component-factory)
- [StreamImageAttachment](#streamimageattachment)
- [StreamGalleryAttachment](#streamgalleryattachment)
- [StreamFileAttachment](#streamfileattachment)
- [StreamVideoAttachment](#streamvideoattachment)
- [StreamGiphyAttachment](#streamgiphyattachment)
- [StreamUrlAttachment → StreamLinkPreviewAttachment](#streamurlattachment--streamlinkpreviewattachment)
- [StreamVoiceRecordingAttachmentPlaylist](#streamvoicerecordingattachmentplaylist)
- [Attachment Builders](#attachment-builders)
- [StreamPollInteractorThemeData](#streampollinteractorthemedata)
- [StreamVoiceRecordingAttachmentThemeData](#streamvoicerecordingattachmentthemedata)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Symbol | Change |
|--------|--------|
| All attachment widgets | Adopt **Props + Component Factory** pattern (see below) |
| `StreamUrlAttachment` | **Renamed** to `StreamLinkPreviewAttachment` |
| `UrlAttachmentBuilder` | **Renamed** to `LinkPreviewAttachmentBuilder` |
| `shape` parameter | **Removed** from all attachment widgets |
| `constraints` parameter | Changed from required to optional on most attachments |
| `StreamImageAttachment` thumbnail params | `imageThumbnailSize`, `imageThumbnailResizeType`, `imageThumbnailCropType` replaced by `ImageResize? resize` |
| `StreamFileAttachment.backgroundColor` | **Removed** |
| `StreamPollInteractorThemeData` | Fully redesigned — old properties removed, new structured theme |
| `StreamVoiceRecordingAttachmentThemeData` | Fully redesigned — old properties removed, new design-token-based theme |

---

## Architecture: Props + Component Factory

All attachment widgets now follow a consistent **Props + Component Factory** pattern:

1. **Public widget** (e.g. `StreamImageAttachment`) — thin wrapper that reads from `StreamComponentFactory` or falls back to a default implementation.
2. **Props class** (e.g. `StreamImageAttachmentProps`) — holds all configuration. Properties that were previously direct constructor parameters now live here.
3. **Default implementation** (e.g. `DefaultStreamImageAttachment`) — the built-in rendering.

This means you can replace any attachment's rendering globally via `StreamComponentFactory`:

```dart
StreamComponentFactory(
  builders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      imageAttachment: (context, props) => MyCustomImageAttachment(props: props),
      fileAttachment: (context, props) => MyCustomFileAttachment(props: props),
    ),
  ),
  child: ...
)
```

For widget users, the public constructor API is largely unchanged — you still pass `message`, `image`, `constraints`, etc. directly. They are forwarded into the `props` object internally.

---

## StreamImageAttachment

### Breaking Changes:

- `shape` parameter removed
- `constraints` changed from `BoxConstraints` (required) to `BoxConstraints?` (optional, auto-sized)
- `imageThumbnailSize`, `imageThumbnailResizeType`, and `imageThumbnailCropType` replaced by a single `ImageResize? resize` parameter

### Migration:

**Before:**
```dart
StreamImageAttachment(
  message: message,
  image: attachment,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  constraints: BoxConstraints.tight(const Size(300, 300)),
  imageThumbnailSize: const Size(300, 300),
  imageThumbnailResizeType: 'crop',
  imageThumbnailCropType: 'center',
)
```

**After:**
```dart
StreamImageAttachment(
  message: message,
  image: attachment,
  constraints: BoxConstraints.tight(const Size(300, 300)),
  resize: ImageResize(
    width: 300,
    height: 300,
    mode: ResizeMode.crop,
    crop: CropMode.center,
  ),
)
```

> **Note:** Shape customization is now handled via theming or the component factory pattern. When `resize` is null, the size is auto-calculated from layout constraints.

---

## StreamGalleryAttachment

### Breaking Changes:

- `shape` parameter removed
- `constraints` is now optional

### Migration:

**Before:**
```dart
StreamGalleryAttachment(
  message: message,
  attachments: attachments,
  shape: const RoundedRectangleBorder(...),
  constraints: BoxConstraints(...),
  itemBuilder: itemBuilder,
)
```

**After:**
```dart
StreamGalleryAttachment(
  message: message,
  attachments: attachments,
  itemBuilder: itemBuilder,
)
```

---

## StreamFileAttachment

### Breaking Changes:

- `shape` parameter removed
- `backgroundColor` parameter removed
- `constraints` is now optional

### Migration:

**Before:**
```dart
StreamFileAttachment(
  message: message,
  file: attachment,
  shape: const RoundedRectangleBorder(...),
  backgroundColor: Colors.grey,
  constraints: BoxConstraints(...),
)
```

**After:**
```dart
StreamFileAttachment(
  message: message,
  file: attachment,
)
```

---

## StreamVideoAttachment

### Breaking Changes:

- `shape` parameter removed
- `constraints` is now optional

### Migration:

**Before:**
```dart
StreamVideoAttachment(
  message: message,
  video: attachment,
  shape: const RoundedRectangleBorder(...),
  constraints: BoxConstraints.tight(const Size(300, 300)),
)
```

**After:**
```dart
StreamVideoAttachment(
  message: message,
  video: attachment,
  constraints: BoxConstraints.tight(const Size(300, 300)),
)
```

---

## StreamGiphyAttachment

### Breaking Changes:

- `shape` parameter removed
- `constraints` is now optional

---

## StreamUrlAttachment → StreamLinkPreviewAttachment

### Breaking Changes:

- **Renamed** from `StreamUrlAttachment` to `StreamLinkPreviewAttachment`
- `messageTheme` parameter removed
- `hostDisplayName` parameter removed
- `shape` parameter removed
- `constraints` is now optional

### Migration:

**Before:**
```dart
StreamUrlAttachment(
  message: message,
  urlAttachment: attachment,
  messageTheme: theme.ownMessageTheme,
  hostDisplayName: 'GitHub',
)
```

**After:**
```dart
StreamLinkPreviewAttachment(
  message: message,
  urlAttachment: attachment,
)
```

> **Note:** The corresponding builder was also renamed from `UrlAttachmentBuilder` to `LinkPreviewAttachmentBuilder`.

---

## StreamVoiceRecordingAttachmentPlaylist

### Breaking Changes:

- `shape` parameter removed
- `constraints` is now optional
- New `itemDecorator` parameter for wrapping individual voice recording items
- New `voiceRecordingTitle` parameter

### Migration:

**Before:**
```dart
StreamVoiceRecordingAttachmentPlaylist(
  message: message,
  voiceRecordings: attachments,
  shape: const RoundedRectangleBorder(...),
  constraints: BoxConstraints(...),
)
```

**After:**
```dart
StreamVoiceRecordingAttachmentPlaylist(
  message: message,
  voiceRecordings: attachments,
)
```

---

## Attachment Builders

| Old Builder | New Builder |
|------------|------------|
| `UrlAttachmentBuilder` | `LinkPreviewAttachmentBuilder` |
| All others | Same name, updated constructor signatures |

All builders have had their `shape` and `padding` parameters removed. If you subclass any attachment builder, update to use the new Props-based attachment constructors.

---

## StreamPollInteractorThemeData

### Breaking Changes:

The theme has been fully redesigned. All previous properties have been removed and replaced with a structured theme using design system tokens.

**Removed properties:**
- `pollTitleStyle` → replaced by `titleTextStyle`
- `pollSubtitleStyle` → replaced by `subtitleTextStyle`
- `pollOptionTextStyle`, `pollOptionVoteCountTextStyle` → moved to `optionStyle` (`StreamPollOptionStyle`)
- `pollOptionCheckboxShape`, `pollOptionCheckboxCheckColor`, `pollOptionCheckboxActiveColor`, `pollOptionCheckboxBorderSide` → moved to `optionStyle.checkboxStyle` (`StreamCheckboxStyle`)
- `pollOptionVotesProgressBarMinHeight`, `pollOptionVotesProgressBarTrackColor`, `pollOptionVotesProgressBarValueColor`, `pollOptionVotesProgressBarWinnerColor`, `pollOptionVotesProgressBarBorderRadius` → moved to `optionStyle.progressBarStyle` (`StreamProgressBarStyle`)
- `pollActionButtonStyle` → replaced by `primaryActionStyle` and `secondaryActionStyle` (`StreamButtonThemeStyle`)
- `pollActionDialogTitleStyle`, `pollActionDialogTextFieldStyle`, `pollActionDialogTextFieldFillColor`, `pollActionDialogTextFieldBorderRadius` → removed

### Migration:

**Before:**
```dart
StreamPollInteractorThemeData(
  pollTitleStyle: TextStyle(fontWeight: FontWeight.bold),
  pollActionButtonStyle: ButtonStyle(...),
  pollOptionVotesProgressBarValueColor: Colors.blue,
)
```

**After:**
```dart
StreamPollInteractorThemeData(
  titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
  primaryActionStyle: StreamButtonThemeStyle.from(
    borderColor: Colors.blue,
  ),
  optionStyle: StreamPollOptionStyle(
    progressBarStyle: StreamProgressBarStyle(
      fillColor: Colors.blue,
    ),
  ),
)
```

---

## StreamVoiceRecordingAttachmentThemeData

### Breaking Changes:

The theme has been fully redesigned using `theme_extensions_builder` code generation.

**Removed properties:**
- `backgroundColor` → removed (handled by attachment container styling)
- `playIcon`, `pauseIcon`, `loadingIndicator` → removed (handled by `controlButtonStyle`)
- `audioControlButtonStyle` → replaced by `controlButtonStyle` (`StreamButtonThemeStyle`)
- `speedControlButtonStyle` → replaced by `speedToggleStyle` (`StreamPlaybackSpeedToggleStyle`)
- `audioWaveformSliderTheme` → replaced by `waveformStyle` (`StreamAudioWaveformThemeData`)

**Retained (renamed):**
- `titleTextStyle` → `titleTextStyle` (unchanged)
- `durationTextStyle` → `durationTextStyle` (unchanged)

**New properties:**
- `activeDurationTextStyle` — text style for duration while playing

### Migration:

**Before:**
```dart
StreamVoiceRecordingAttachmentThemeData(
  backgroundColor: Colors.grey,
  audioControlButtonStyle: ButtonStyle(...),
  speedControlButtonStyle: ButtonStyle(...),
  durationTextStyle: TextStyle(...),
)
```

**After:**
```dart
StreamVoiceRecordingAttachmentThemeData(
  controlButtonStyle: StreamButtonThemeStyle.from(...),
  speedToggleStyle: StreamPlaybackSpeedToggleStyle(...),
  durationTextStyle: TextStyle(...),
  activeDurationTextStyle: TextStyle(...),
)
```

---

## Migration Checklist

- [ ] Remove `shape` parameter from all attachment widget usages
- [ ] Replace `StreamUrlAttachment` with `StreamLinkPreviewAttachment`
- [ ] Replace `UrlAttachmentBuilder` with `LinkPreviewAttachmentBuilder`
- [ ] Remove `messageTheme` and `hostDisplayName` from link preview usage
- [ ] Replace `imageThumbnailSize` / `imageThumbnailResizeType` / `imageThumbnailCropType` with `ImageResize? resize` on `StreamImageAttachment`
- [ ] Remove `backgroundColor` from `StreamFileAttachment` usage
- [ ] Remove `shape` and `padding` from attachment builder usages
- [ ] Update `StreamPollInteractorThemeData` — see property mapping above
- [ ] Update `StreamVoiceRecordingAttachmentThemeData` — see property mapping above
- [ ] If using custom attachment builders, update to new Props-based constructors
- [ ] If using component factory, register custom builders via `streamChatComponentBuilders`
