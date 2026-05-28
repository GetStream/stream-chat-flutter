# Media Viewer Migration Guide

The full-screen media viewer and its thumbnail companion have been redesigned and split into two widgets — both built on the design system's `StreamMediaViewer`, `StreamAppBar`, and `StreamBottomAppBar` chrome. The legacy `StreamFullScreenMedia` (and its desktop/builder/stub variants) and the related `StreamMediaListView` / `StreamImageGallery` flow have all been replaced.

This guide also covers the related theme cleanups (`StreamGalleryFooterThemeData`, `StreamChatThemeData.galleryHeaderTheme`, `StreamChatThemeData.galleryFooterTheme`) and the removal of the `onShowMessage` / `attachmentActionsModalBuilder` callbacks from the message widget and message list view. It also notes that `StreamAvatarThemeData` has moved to `stream_core_flutter` (it was not removed).

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [Architecture: Props + Component Factory](#architecture-props--component-factory)
- [StreamFullScreenMedia → StreamMediaGalleryPreview](#streamfullscreenmedia--streammediagallerypreview)
- [StreamAttachmentPackage → StreamMediaGalleryAttachment](#streamattachmentpackage--streammediagalleryattachment)
- [StreamGalleryHeader → StreamMediaGalleryPreviewHeader](#streamgalleryheader--streammediagallerypreviewheader)
- [StreamGalleryFooter → StreamMediaGalleryPreviewFooter](#streamgalleryfooter--streammediagallerypreviewfooter)
- [New StreamMediaGallery (Thumbnail Grid)](#new-streammediagallery-thumbnail-grid)
- [Removed message-widget callbacks](#removed-message-widget-callbacks)
- [Removed themes](#removed-themes)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Old                                                                                                                  | New                                                                                          |
| -------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `StreamFullScreenMedia` / `StreamFullScreenMediaBuilder` / `FullScreenMediaWidget` / `FullScreenMediaDesktop`        | `StreamMediaGalleryPreview` (single widget, all platforms)                                   |
| `StreamAttachmentPackage`                                                                                            | `StreamMediaGalleryAttachment`                                                               |
| `StreamGalleryHeader`                                                                                                | `StreamMediaGalleryPreviewHeader`                                                            |
| `StreamGalleryFooter`                                                                                                | `StreamMediaGalleryPreviewFooter`                                                            |
| `VideoPackage` / `DesktopVideoPackage` / `GalleryNavigationItem`                                                     | **Removed from the public API** — each preview page now owns its own player state internally |
| *(none)*                                                                                                             | `StreamMediaGallery` — **new** thumbnail-grid companion                                      |
| `StreamMessageItem.onShowMessage` / `attachmentActionsModalBuilder`                                                  | **Removed**                                                                                  |
| `StreamMessageListView.onShowMessage` / `attachmentActionsModalBuilder`                                              | **Removed**                                                                                  |
| `StreamGalleryFooterThemeData`, `StreamChatThemeData.imageFooterTheme` / `galleryFooterTheme` / `galleryHeaderTheme` | **Removed**                                                                                  |
| `StreamAvatarThemeData`                                                                                              | **Moved** — now lives in `stream_core_flutter`; import directly from `package:stream_core_flutter/stream_core_flutter.dart` |
| `Translations.photosAndVideosLabel`                                                                                  | **New** — used by the footer's thumbnail-grid sheet header                                   |

---

## Architecture: Props + Component Factory

`StreamMediaGalleryPreview` and `StreamMediaGallery` follow the same **Props + Component Factory** pattern used by other redesigned components:

1. **Public widget** (e.g. `StreamMediaGalleryPreview`) — thin wrapper that reads from `StreamComponentFactory` or falls back to a default implementation.
2. **Props class** (e.g. `StreamMediaGalleryPreviewProps`) — holds all configuration.
3. **Default implementation** (e.g. `DefaultStreamMediaGalleryPreview`) — the built-in rendering.

Replace either widget globally via `StreamComponentFactory`:

```dart
StreamComponentFactory(
  builders: StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      mediaGallery: (context, props) => MyCustomMediaGallery(props: props),
      mediaGalleryPreview: (context, props) => MyCustomMediaGalleryPreview(props: props),
    ),
  ),
  child: ...,
)
```

---

## StreamFullScreenMedia → StreamMediaGalleryPreview

### Breaking Changes

- **Renamed** to `StreamMediaGalleryPreview`. There is one widget across mobile, desktop and web — the platform-specific subclasses (`FullScreenMediaDesktop`), the abstract `FullScreenMediaWidget`, and the conditional-import builder `StreamFullScreenMediaBuilder` / `fsm_stub.dart` have all been removed.
- The constructor surface shrunk to the minimum the gallery actually owns. The following parameters are **gone**:
  - `userName` — sender metadata is now read from `attachment.message.user` inside the header.
  - `sentAt` — read from `attachment.message.createdAt`.
  - `onReplyMessage` — no longer surfaced as a header action.
  - `onShowMessage` — no longer surfaced as a header action.
  - `attachmentActionsModalBuilder` — the more-actions overflow has been removed from the header.
- `mediaAttachmentPackages` → `attachments` (renamed and the element type changed — see [StreamAttachmentPackage → StreamMediaGalleryAttachment](#streamattachmentpackage--streammediagalleryattachment)).
- `startIndex` → `initialIndex` (semantics unchanged).
- `autoplayVideos` is retained.

### Behaviour built in

- Tapping the media area toggles the chrome (slides off the top/bottom edges with a fade).
- Keyboard shortcuts: `← / →` advance pages, `esc` pops the route.
- The footer's gallery-grid button now opens a `StreamMediaGallery` inside `showStreamSheet`; tapping a thumbnail pops the sheet and animates the page view to that index.
- The footer's share button downloads the active attachment's bytes via `Dio` and hands them to the system share sheet via `share_plus` (no more platform-specific `dart:io` paths — works on web too).
- Video attachments are played by `StreamVideoPlayer`, which pauses itself when its page is no longer active (see `StreamMediaGalleryPreviewScope`).

### Migration

**Before:**
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => StreamChannel(
      channel: channel,
      child: StreamFullScreenMedia(
        mediaAttachmentPackages: [
          for (final a in message.attachments)
            StreamAttachmentPackage(attachment: a, message: message),
        ],
        startIndex: 3,
        userName: message.user!.name,
        autoplayVideos: false,
        onReplyMessage: handleReply,
        onShowMessage: handleShowInChat,
        attachmentActionsModalBuilder: buildActions,
      ),
    ),
  ),
);
```

**After:**
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => StreamChannel(
      channel: channel,
      child: StreamMediaGalleryPreview(
        attachments: message.toMediaGalleryAttachments(
          filter: (a) =>
              a.type == AttachmentType.image ||
              a.type == AttachmentType.video ||
              a.type == AttachmentType.giphy,
        ),
        initialIndex: 3,
        autoplayVideos: false,
      ),
    ),
  ),
);
```

If you depended on `onReplyMessage`, `onShowMessage`, or `attachmentActionsModalBuilder`, replace the preview via the component factory (`mediaGalleryPreview: ...`) and surface those actions in your own chrome.

### Active-page scope

Per-page widgets (video players, custom items) that need to react when their page goes off-screen read from `StreamMediaGalleryPreviewScope`:

```dart
final scope = StreamMediaGalleryPreviewScope.of(context);
final isActive = scope.activeIndex.value == myPageIndex;
```

The bundled `StreamVideoPlayer` already uses this — it pauses when inactive and resumes when the user swipes back, preserving prior playing/paused state.

---

## StreamAttachmentPackage → StreamMediaGalleryAttachment

### Breaking Changes

`StreamAttachmentPackage` has been renamed to `StreamMediaGalleryAttachment` and moved into `media_gallery/`. The shape (an `Attachment` + its parent `Message`) is unchanged.

A new convenience extension `MessageMediaGalleryX.toMediaGalleryAttachments({filter})` produces a `List<StreamMediaGalleryAttachment>` from a `Message`:

```dart
final attachments = message.toMediaGalleryAttachments(
  filter: (a) =>
      a.type == AttachmentType.image ||
      a.type == AttachmentType.video ||
      a.type == AttachmentType.giphy,
);
```

---

## StreamGalleryHeader → StreamMediaGalleryPreviewHeader

### Breaking Changes

- **Renamed** to `StreamMediaGalleryPreviewHeader`.
- Rebuilt on top of `StreamAppBar`; the back affordance is auto-implied from the route.
- The constructor surface shrunk to a `title` and `subtitle` widget pair. The following parameters are **gone**:
  - `userName`, `sentAt` — render whatever you want in the `title` / `subtitle` slots.
  - `message`, `attachment` — the header no longer reads from the active package; the parent passes presentation-ready widgets in.
  - `onShowMessage`, `onBackPressed` — the more-actions overflow has been removed; back is handled by `StreamAppBar`.

### Migration

**Before:**
```dart
StreamGalleryHeader(
  userName: message.user!.name,
  sentAt: 'Sent ${formatted}',
  message: message,
  attachment: attachment,
  onShowMessage: handleShowInChat,
  onBackPressed: () => Navigator.of(context).pop(),
)
```

**After:**
```dart
StreamMediaGalleryPreviewHeader(
  title: Text(message.user?.name ?? ''),
  subtitle: Text(
    context.translations.sentAtText(
      date: message.createdAt,
      time: message.createdAt,
    ),
  ),
)
```

---

## StreamGalleryFooter → StreamMediaGalleryPreviewFooter

### Breaking Changes

- **Renamed** to `StreamMediaGalleryPreviewFooter`.
- Rebuilt on top of `StreamBottomAppBar` — the underlying chrome and theming flow through `StreamBottomAppBarThemeData`.
- The constructor surface shrunk to `title` + two callbacks. The following parameters are **gone**:
  - `currentPage`, `totalPages` — render the page counter as a `Text` in the `title` slot using `Translations.galleryPaginationText`.
  - `mediaSelectedCallBack` — the gallery-grid action no longer hands a tile index back through a callback. The parent owns the bottom-sheet flow and decides what to do when a tile is tapped.
  - `userName`, `sentAt`, `message`, `mediaAttachmentPackages` — not needed; the parent passes presentation-ready widgets and intent callbacks.

### Migration

**Before:**
```dart
StreamGalleryFooter(
  currentPage: currentPage,
  totalPages: totalPages,
  mediaAttachmentPackages: packages,
  mediaSelectedCallBack: (index, _) {
    Navigator.pop(context);
    _pageController.jumpToPage(index);
  },
)
```

**After:**
```dart
StreamMediaGalleryPreviewFooter(
  title: Text(
    context.translations.galleryPaginationText(
      currentPage: currentPage,
      totalPages: totalPages,
    ),
  ),
  onSharePressed: shareCurrentAttachment,
  onGalleryPressed: openThumbnailSheet,
)
```

> **Note:** The footer is wired up automatically when you use `StreamMediaGalleryPreview`. It's only relevant if you compose your own chrome on top of the design-system primitives.

---

## New StreamMediaGallery (Thumbnail Grid)

`StreamMediaGallery` is a **new** widget — a 3-up grid of `StreamMediaGalleryItem` tiles, designed to be the thumbnail companion to `StreamMediaGalleryPreview`. The footer's gallery-grid button now opens this widget in a `showStreamSheet`.

Each tile renders the sender's avatar plus a media badge for videos (`StreamMediaBadge`). Inter-cell gutters and the outer padding default to `spacing.xxxs` (2 logical pixels) for a uniform mosaic.

```dart
StreamMediaGallery(
  attachments: message.toMediaGalleryAttachments(filter: isMedia),
  onItemTap: (index) => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => StreamMediaGalleryPreview(
        attachments: attachments,
        initialIndex: index,
      ),
    ),
  ),
)
```

Replace globally via `mediaGallery: ...` on `streamChatComponentBuilders`.

---

## Removed message-widget callbacks

`onShowMessage` and `attachmentActionsModalBuilder` have been removed from both `StreamMessageItem` (and its props) and `StreamMessageListView`. They were forwarded into the now-removed gallery overflow header, so they no longer have a destination.

If you relied on either callback, replace the gallery preview via the component factory (`mediaGalleryPreview: ...`) and surface those actions in your own chrome.

`StreamMessageItem.onReplyTap` and `StreamMessageListView.onReplyTap` are unchanged.

---

## Removed themes

The following theme types and `StreamChatThemeData` fields have been removed:

| Removed                                                                     | Notes                                                                                                                       |
| --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `StreamGalleryFooterThemeData`                                              | The new footer is themed via `StreamBottomAppBarThemeData` from the design system.                                          |
| `StreamChatThemeData.galleryFooterTheme` / `imageFooterTheme` (named param) | Footer themeing now flows through `StreamBottomAppBarThemeData`.                                                            |
| `StreamChatThemeData.galleryHeaderTheme`                                    | Header themeing now flows through `StreamAppBarThemeData`.                                                                  |
| `StreamAvatarThemeData`                                                     | The type itself was **not** removed. It moved to `stream_core_flutter` and remains in active use. Import it directly from `package:stream_core_flutter/stream_core_flutter.dart`; it is not re-exported by `stream_chat_flutter`. |

The full-screen page background and chrome bands themselves are themed via `StreamMediaViewerThemeData` (from `stream_core_flutter`, re-exported here).

---

## Migration Checklist

- [ ] Replace `StreamFullScreenMedia` / `StreamFullScreenMediaBuilder` with `StreamMediaGalleryPreview`.
- [ ] Replace `StreamAttachmentPackage` with `StreamMediaGalleryAttachment` (or `Message.toMediaGalleryAttachments(...)`).
- [ ] Rename `startIndex` → `initialIndex`, `mediaAttachmentPackages` → `attachments`.
- [ ] Drop `userName`, `sentAt`, `onReplyMessage`, `onShowMessage`, `attachmentActionsModalBuilder` from preview usage.
- [ ] Replace `StreamGalleryHeader` with `StreamMediaGalleryPreviewHeader`; render sender / timestamp in the `title` / `subtitle` slots.
- [ ] Replace `StreamGalleryFooter` with `StreamMediaGalleryPreviewFooter`; render the page counter via `Translations.galleryPaginationText` in the `title` slot.
- [ ] Drop usages of `VideoPackage`, `DesktopVideoPackage`, `GalleryNavigationItem`, `FullScreenMediaWidget`, `FullScreenMediaDesktop`.
- [ ] Drop `StreamMessageItem.onShowMessage` / `attachmentActionsModalBuilder`, `StreamMessageListView.onShowMessage` / `attachmentActionsModalBuilder` from any constructors.
- [ ] Drop `StreamChatThemeData.galleryHeaderTheme`, `galleryFooterTheme` and `imageFooterTheme:` named-parameter usages.
- [ ] If you import `StreamAvatarThemeData` from `stream_chat_flutter`, update the import to `package:stream_core_flutter/stream_core_flutter.dart` — the type moved to `stream_core_flutter` and is no longer re-exported by this package.
- [ ] Optionally adopt `StreamMediaGallery` as a thumbnail grid for channel-level media listings.
