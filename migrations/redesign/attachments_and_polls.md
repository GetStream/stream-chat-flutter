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
- [Removed Attachment Widgets](#removed-attachment-widgets)
- [StreamPollInteractorThemeData](#streampollinteractorthemedata)
- [Poll Dialogs → Poll Sheets](#poll-dialogs--poll-sheets)
- [Poll Creator Dialog → Sheet](#poll-creator-dialog--sheet)
- [StreamVoiceRecordingAttachmentThemeData](#streamvoicerecordingattachmentthemedata)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Symbol                                                                                                                                                 | Change                                                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ |
| All attachment widgets                                                                                                                                 | Adopt **Props + Component Factory** pattern (see below)                                                      |
| `StreamUrlAttachment`                                                                                                                                  | **Renamed** to `StreamLinkPreviewAttachment`                                                                 |
| `UrlAttachmentBuilder`                                                                                                                                 | **Renamed** to `LinkPreviewAttachmentBuilder`                                                                |
| `shape` parameter                                                                                                                                      | **Removed** from all attachment widgets                                                                      |
| `constraints` parameter                                                                                                                                | Changed from required to optional on most attachments                                                        |
| `StreamImageAttachment` thumbnail params                                                                                                               | `imageThumbnailSize`, `imageThumbnailResizeType`, `imageThumbnailCropType` replaced by `ImageResize? resize` |
| `StreamFileAttachment.backgroundColor`                                                                                                                 | **Removed**                                                                                                  |
| `StreamPollInteractorThemeData`                                                                                                                        | Fully redesigned — old properties removed, new structured theme                                              |
| `StreamPollOptionsDialog` / `StreamPollResultsDialog` / `StreamPollOptionVotesDialog` / `StreamPollCommentsDialog`                                     | **Renamed** to `...Sheet` and now presented as modal bottom sheets                                           |
| `StreamPollOptionsDialogThemeData` / `StreamPollResultsDialogThemeData` / `StreamPollOptionVotesDialogThemeData` / `StreamPollCommentsDialogThemeData` | **Renamed** to `...SheetThemeData` and fully redesigned                                                      |
| `StreamPollCreatorDialog` / `StreamPollCreatorFullScreenDialog`                                                                                        | **Replaced** by `StreamPollCreatorSheet` — see [Poll Creator Dialog → Sheet](#poll-creator-dialog--sheet)    |
| `StreamVoiceRecordingAttachmentThemeData`                                                                                                              | Fully redesigned — old properties removed, new design-token-based theme                                      |

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

| Old Builder            | New Builder                               |
| ---------------------- | ----------------------------------------- |
| `UrlAttachmentBuilder` | `LinkPreviewAttachmentBuilder`            |
| All others             | Same name, updated constructor signatures |

All builders have had their `shape` and `padding` parameters removed. If you subclass any attachment builder, update to use the new Props-based attachment constructors.

---

## Removed Attachment Widgets

The following attachment-related widgets have been removed. Replace any direct references with the listed alternatives.

| Removed Widget                                      | Replacement                                                                                                                                                                                            |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `StreamFileAttachmentThumbnail`                     | Use `StreamImageAttachmentThumbnail` for images, `StreamVideoAttachmentThumbnail` for videos, or `StreamFileTypeIcon.fromMimeType(...)` for generic file icons                                         |
| `StreamAttachmentUploadStateBuilder.successBuilder` | Removed — was unreachable in practice (the success state immediately transitions to the rendered attachment)                                                                                           |
| `AttachmentModalSheet`                              | Use the redesigned attachment picker — see [v10-migration.md](../v10-migration.md#streamattachmentpickeroption) for the new sealed-class option types and `showStreamAttachmentPickerModalBottomSheet` |

**`StreamFileAttachmentThumbnail` migration:**

**Before:**

```dart
StreamFileAttachmentThumbnail(
  file: attachment.file,
  fit: BoxFit.cover,
)
```

**After:**

```dart
// Pick the right thumbnail based on the attachment type
if (attachment.type == AttachmentType.image) {
  StreamImageAttachmentThumbnail(image: attachment, fit: BoxFit.cover);
} else if (attachment.type == AttachmentType.video) {
  StreamVideoAttachmentThumbnail(video: attachment, fit: BoxFit.cover);
} else {
  StreamFileTypeIcon.fromMimeType(attachment.mimeType);
}
```

**`StreamAttachmentUploadStateBuilder.successBuilder` migration:**

**Before:**

```dart
StreamAttachmentUploadStateBuilder(
  message: message,
  attachment: attachment,
  failedBuilder: (context, errorMessage) => MyFailedWidget(),
  preparingBuilder: (context) => MyPreparingWidget(),
  inProgressBuilder: (context, sent, total) => MyProgressWidget(),
  successBuilder: (context) => MySuccessWidget(), // removed
)
```

**After:**

```dart
StreamAttachmentUploadStateBuilder(
  message: message,
  attachment: attachment,
  failedBuilder: (context, errorMessage) => MyFailedWidget(),
  preparingBuilder: (context) => MyPreparingWidget(),
  inProgressBuilder: (context, sent, total) => MyProgressWidget(),
  // successBuilder removed — the attachment renders directly once uploaded
)
```

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

## Poll Dialogs → Poll Sheets

### Breaking Changes:

The four poll dialogs — `StreamPollOptionsDialog`, `StreamPollResultsDialog`, `StreamPollOptionVotesDialog`, and `StreamPollCommentsDialog` — have been renamed to `...Sheet` and now present as modal bottom sheets via the new `showStreamSheet` helper from `stream_core_flutter` (a Stream-styled sheet route with scroll-aware drag-to-dismiss) instead of full-screen page routes. The previous `Scaffold` + `StreamAppBar` chrome has been replaced by a `StreamSheetHeader` at the top of each sheet.

Each sheet is now full-size with a small fixed peek from the screen top, and the previous snap-to-half affordance from `DraggableScrollableSheet` is gone — dragging down on the body's scroll view past its top now dismisses the sheet directly.

**Renamed symbols:**

| Old                                                                         | New                                                                       |
| --------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `StreamPollOptionsDialog`                                                   | `StreamPollOptionsSheet`                                                  |
| `StreamPollResultsDialog`                                                   | `StreamPollResultsSheet`                                                  |
| `StreamPollOptionVotesDialog`                                               | `StreamPollOptionVotesSheet`                                              |
| `StreamPollCommentsDialog`                                                  | `StreamPollCommentsSheet`                                                 |
| `showStreamPollOptionsDialog`                                               | `showStreamPollOptionsSheet`                                              |
| `showStreamPollResultsDialog`                                               | `showStreamPollResultsSheet`                                              |
| `showStreamPollOptionVotesDialog`                                           | `showStreamPollOptionVotesSheet`                                          |
| `showStreamPollCommentsDialog`                                              | `showStreamPollCommentsSheet`                                             |
| `StreamPollOptionsDialogTheme` / `StreamPollOptionsDialogThemeData`         | `StreamPollOptionsSheetTheme` / `StreamPollOptionsSheetThemeData`         |
| `StreamPollResultsDialogTheme` / `StreamPollResultsDialogThemeData`         | `StreamPollResultsSheetTheme` / `StreamPollResultsSheetThemeData`         |
| `StreamPollOptionVotesDialogTheme` / `StreamPollOptionVotesDialogThemeData` | `StreamPollOptionVotesSheetTheme` / `StreamPollOptionVotesSheetThemeData` |
| `StreamPollCommentsDialogTheme` / `StreamPollCommentsDialogThemeData`       | `StreamPollCommentsSheetTheme` / `StreamPollCommentsSheetThemeData`       |
| `StreamChatThemeData.pollOptionsDialogTheme`                                | `StreamChatThemeData.pollOptionsSheetTheme`                               |
| `StreamChatThemeData.pollResultsDialogTheme`                                | `StreamChatThemeData.pollResultsSheetTheme`                               |
| `StreamChatThemeData.pollOptionVotesDialogTheme`                            | `StreamChatThemeData.pollOptionVotesSheetTheme`                           |
| `StreamChatThemeData.pollCommentsDialogTheme`                               | `StreamChatThemeData.pollCommentsSheetTheme`                              |

Each `...Sheet` widget also exposes a new optional `scrollController` parameter which `show*Sheet` wires to the enclosing `DraggableScrollableSheet`.

### Theme Data: Removed / Replaced Properties

All four theme data classes dropped their app-bar styling slots (`appBarElevation`, `appBarBackgroundColor`, `appBarForegroundColor`, `appBarTitleTextStyle`). The old app-bar chrome is replaced by a `StreamSheetHeader` at the top of each sheet — use the new per-sheet `sheetHeaderStyle` field to scope a `StreamSheetHeaderStyle` override.

**`StreamPollOptionsSheetThemeData`**

| Removed                                     | Replacement                                                                                                                |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `pollTitleTextStyle`, `pollTitleDecoration` | `questionStyle` (`StreamPollQuestionStyle`)                                                                                |
| `pollOptionsListViewDecoration`             | `optionsCardStyle` (`StreamPollCardStyle`)                                                                                 |
| —                                           | New: `contentPadding`, `sectionSpacing`, `optionsItemSpacing`, `optionStyle` (`StreamPollOptionStyle`), `sheetHeaderStyle` |

**`StreamPollResultsSheetThemeData`**

| Removed                                                                                                                                                                                                                    | Replacement                                                                                                                                                                        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `pollTitleTextStyle`, `pollTitleDecoration`                                                                                                                                                                                | `questionStyle` (`StreamPollQuestionStyle`)                                                                                                                                        |
| `pollOptionsDecoration`, `pollOptionsWinnerDecoration`, `pollOptionsTextStyle`, `pollOptionsWinnerTextStyle`, `pollOptionsVoteCountTextStyle`, `pollOptionsWinnerVoteCountTextStyle`, `pollOptionsShowAllVotesButtonStyle` | `optionStyle` (`StreamPollOptionVotesStyle`) — bundles card chrome, text styles, `winnerIconColor`/`winnerIconSize`, `footerDividerColor`, and `footerButtonStyle` for the "View all" action |
| —                                                                                                                                                                                                                          | New: `contentPadding`, `sectionSpacing`, `optionsItemSpacing`, `totalVoteCountTextStyle` (for the new total-vote-count footer), `sheetHeaderStyle`                                 |

**`StreamPollOptionVotesSheetThemeData`**

| Removed                                                                                                                                     | Replacement                                                                |
| ------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| `pollOptionVoteCountTextStyle`, `pollOptionWinnerVoteCountTextStyle`, `pollOptionVoteItemBackgroundColor`, `pollOptionVoteItemBorderRadius` | `optionStyle` (reuses `StreamPollOptionVotesStyle` from the results sheet) |
| —                                                                                                                                           | New: `contentPadding`, `sheetHeaderStyle`                                  |

Per-vote tile styling will ship later under a dedicated `StreamPollVoteListTile` theme.

**`StreamPollCommentsSheetThemeData`**

| Removed                                                                                                         | Replacement                                                                                                                            |
| --------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `pollCommentItemBackgroundColor`, `pollCommentItemBorderRadius`, `updateYourCommentButtonStyle` (`ButtonStyle`) | `commentStyle` (reuses `StreamPollOptionVotesStyle`) — only its `cardStyle`, `footerDividerColor` and `footerButtonStyle` are consumed |
| —                                                                                                               | New: `contentPadding`, `itemSpacing`, `sheetHeaderStyle`                                                                               |

### Migration:

**Before:**
```dart
showStreamPollOptionsDialog(
  context: context,
  messageNotifier: messageNotifier,
);

StreamChatThemeData(
  pollOptionsDialogTheme: StreamPollOptionsDialogThemeData(
    appBarBackgroundColor: Colors.white,
    pollTitleTextStyle: TextStyle(fontWeight: FontWeight.w700),
    pollOptionsListViewDecoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
```

**After:**
```dart
showStreamPollOptionsSheet(
  context: context,
  messageNotifier: messageNotifier,
);

StreamChatThemeData(
  pollOptionsSheetTheme: StreamPollOptionsSheetThemeData(
    sheetHeaderStyle: StreamSheetHeaderStyle(backgroundColor: Colors.white),
    questionStyle: StreamPollQuestionStyle(
      headerTextStyle: TextStyle(fontWeight: FontWeight.w700),
    ),
    optionsCardStyle: StreamPollCardStyle(
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
```

---

## Poll Creator Dialog → Sheet

### Breaking Changes:

The poll creator UI has been unified into a single bottom-sheet surface. The previous responsive split between a desktop `AlertDialog` (`StreamPollCreatorDialog`) and a mobile full-screen page (`StreamPollCreatorFullScreenDialog`) has been replaced by a single `StreamPollCreatorSheet` that renders as a modal bottom sheet via the new `showStreamSheet` helper from `stream_core_flutter`, matching the other poll sheets.

**Renamed / removed symbols:**

| Old                                 | New                          |
| ----------------------------------- | ---------------------------- |
| `showStreamPollCreatorDialog`       | `showStreamPollCreatorSheet` |
| `StreamPollCreatorDialog`           | `StreamPollCreatorSheet`     |
| `StreamPollCreatorFullScreenDialog` | `StreamPollCreatorSheet`     |

`showStreamPollCreatorSheet` keeps the `poll`, `config`, and `padding` parameters from the old dialog helper; the dialog-specific parameters (`barrierDismissible`, `barrierColor`, `barrierLabel`, `useSafeArea`, `useRootNavigator`, `routeSettings`, `anchorPoint`, `traversalEdgeBehavior`) are no longer accepted — the sheet always presents as a modal bottom sheet over a safe area.

`StreamPollCreatorWidget` also gained an optional `scrollController` parameter so it can be embedded inside a `DraggableScrollableSheet`.

### Migration:

**Before:**
```dart
final poll = await showStreamPollCreatorDialog(
  context: context,
  poll: initialPoll,
  config: pollConfig,
);
```

**After:**
```dart
final poll = await showStreamPollCreatorSheet(
  context: context,
  poll: initialPoll,
  config: pollConfig,
);
```

If you were directly instantiating either of the legacy widgets, replace them with `StreamPollCreatorSheet`:

**Before:**
```dart
StreamPollCreatorDialog(poll: poll, config: config);
StreamPollCreatorFullScreenDialog(poll: poll, config: config);
```

**After:**
```dart
StreamPollCreatorSheet(poll: poll, config: config);
```

#### Theme changes

`StreamPollCreatorThemeData` now exposes a `sheetHeaderStyle` (`StreamSheetHeaderStyle`) that styles the sheet's `StreamSheetHeader` — matching the other poll sheet theme datas. The previous `primaryActionStyle` and `secondaryActionStyle` fields have been removed; style the sheet's leading/trailing action buttons through `sheetHeaderStyle.leadingStyle` / `sheetHeaderStyle.trailingStyle` instead.

**Before:**
```dart
StreamPollCreatorThemeData(
  primaryActionStyle: StreamButtonThemeStyle.from(...),
  secondaryActionStyle: StreamButtonThemeStyle.from(...),
)
```

**After:**
```dart
StreamPollCreatorThemeData(
  sheetHeaderStyle: StreamSheetHeaderStyle(
    trailingStyle: StreamButtonThemeStyle.from(...),
    leadingStyle: StreamButtonThemeStyle.from(...),
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
- [ ] Rename `StreamPoll*Dialog` widgets, `show*Dialog` helpers, and their theme types to the `...Sheet` variants
- [ ] Replace `StreamPollCreatorDialog` / `StreamPollCreatorFullScreenDialog` (and `showStreamPollCreatorDialog`) with `StreamPollCreatorSheet` / `showStreamPollCreatorSheet`
- [ ] Update `StreamPoll*SheetThemeData` entries on `StreamChatThemeData` — see property mapping above
- [ ] Update `StreamVoiceRecordingAttachmentThemeData` — see property mapping above
- [ ] If using custom attachment builders, update to new Props-based constructors
- [ ] If using component factory, register custom builders via `streamChatComponentBuilders`
- [ ] Replace `StreamFileAttachmentThumbnail` with `StreamImageAttachmentThumbnail` / `StreamVideoAttachmentThumbnail` or `StreamFileTypeIcon.fromMimeType(...)`
- [ ] Remove the `successBuilder` argument from `StreamAttachmentUploadStateBuilder` usages
- [ ] Replace any `AttachmentModalSheet` usage with the redesigned attachment picker (see [v10-migration.md](../v10-migration.md#attachment-picker))
