# Image CDN & Thumbnails Migration Guide

This guide covers the migration for the redesigned image CDN handling and thumbnail resize parameters in Stream Chat Flutter SDK.

---

## Table of Contents

- [Quick Reference](#quick-reference)
- [StreamImageCDN](#streamimagecdn)
- [StreamImageAttachmentThumbnail](#streamimageattachmentthumbnail)
- [StreamMediaAttachmentThumbnail](#streammediaattachmentthumbnail)
- [StreamImageAttachment](#streamimageattachment)
- [Migration Checklist](#migration-checklist)

---

## Quick Reference

| Component | Key Changes |
|-----------|-------------|
| [**StreamImageCDN**](#streamimagecdn) | New class replacing `getResizedImageUrl` String extension (stable cache keys now via `StreamImageCDN.cacheKey()`) |
| [**StreamImageAttachmentThumbnail**](#streamimageattachmentthumbnail) | `thumbnailSize`, `thumbnailResizeType`, `thumbnailCropType` → single `resize` parameter |
| [**StreamMediaAttachmentThumbnail**](#streammediaattachmentthumbnail) | `thumbnailSize`, `thumbnailResizeType`, `thumbnailCropType` → single `resize` parameter |
| [**StreamImageAttachment**](#streamimageattachment) | `imageThumbnailSize`, `imageThumbnailResizeType`, `imageThumbnailCropType` → single `resize` parameter |

---

## StreamImageCDN

### What Changed:

The `getResizedImageUrl` String extension has been replaced with a dedicated `StreamImageCDN` class. This class handles CDN URL resolution and stable cache key generation, preventing image reloads caused by expiring signed URL tokens.

### Key Changes:

- `getResizedImageUrl` String extension removed — use `StreamImageCDN.resolveUrl` instead
- New `StreamImageCDN.cacheKey` method generates stable cache keys that strip volatile signed URL tokens
- Raw `String` resize/crop type parameters replaced with `ResizeMode` and `CropMode` enums
- `StreamImageCDN` is injectable via `StreamChatConfigurationData` for custom CDN support

### Migration:

**Before:**
```dart
final resizedUrl = imageUrl.getResizedImageUrl(
  width: 200,
  height: 300,
  resize: 'clip',
  crop: 'center',
);
```

**After:**
```dart
const imageCDN = StreamImageCDN();

final resizedUrl = imageCDN.resolveUrl(
  imageUrl,
  resize: ImageResize(width: 200, height: 300),
);

final cacheKey = imageCDN.cacheKey(resizedUrl);
```

### Custom CDN Support:

Extend `StreamImageCDN` and inject it via configuration:

```dart
class MyImageCDN extends StreamImageCDN {
  @override
  String cacheKey(String imageUrl) {
    return Uri.parse(imageUrl).path;
  }
}

StreamChat(
  client: client,
  config: StreamChatConfigurationData(
    imageCDN: MyImageCDN(),
  ),
  child: ...,
)
```

---

## StreamImageAttachmentThumbnail

### Breaking Changes:

- `thumbnailSize` parameter removed
- `thumbnailResizeType` parameter removed
- `thumbnailCropType` parameter removed
- New `resize` parameter (`ImageResize?`) replaces all three

### Migration:

**Before:**
```dart
StreamImageAttachmentThumbnail(
  image: attachment,
  thumbnailSize: const Size(200, 300),
  thumbnailResizeType: 'clip',
  thumbnailCropType: 'center',
)
```

**After:**
```dart
StreamImageAttachmentThumbnail(
  image: attachment,
  resize: ImageResize(
    width: 200,
    height: 300,
    mode: ResizeMode.clip,
    crop: CropMode.center,
  ),
)
```

> **Note:** When `resize` is null, the size is auto-calculated from layout constraints and defaults to `ResizeMode.clip` and `CropMode.center`.

---

## StreamMediaAttachmentThumbnail

### Breaking Changes:

- `thumbnailSize` parameter removed
- `thumbnailResizeType` parameter removed
- `thumbnailCropType` parameter removed
- New `resize` parameter (`ImageResize?`) replaces all three

### Migration:

**Before:**
```dart
StreamMediaAttachmentThumbnail(
  media: attachment,
  thumbnailSize: const Size(200, 300),
  thumbnailResizeType: 'clip',
  thumbnailCropType: 'center',
)
```

**After:**
```dart
StreamMediaAttachmentThumbnail(
  media: attachment,
  resize: ImageResize(
    width: 200,
    height: 300,
    mode: ResizeMode.clip,
    crop: CropMode.center,
  ),
)
```

---

## StreamImageAttachment

### Breaking Changes:

- `imageThumbnailSize` parameter removed
- `imageThumbnailResizeType` parameter removed
- `imageThumbnailCropType` parameter removed
- New `resize` parameter (`ImageResize?`) replaces all three

### Migration:

**Before:**
```dart
StreamImageAttachment(
  message: message,
  image: attachment,
  imageThumbnailSize: const Size(400, 600),
  imageThumbnailResizeType: 'crop',
  imageThumbnailCropType: 'center',
)
```

**After:**
```dart
StreamImageAttachment(
  message: message,
  image: attachment,
  resize: ImageResize(
    width: 400,
    height: 600,
    mode: ResizeMode.crop,
    crop: CropMode.center,
  ),
)
```

---

## Migration Checklist

- [ ] Replace `getResizedImageUrl` String extension calls with `StreamImageCDN.resolveUrl`
- [ ] Use `StreamImageCDN.cacheKey` to generate stable cache keys for `CachedNetworkImage`
- [ ] Replace raw `String` resize/crop values (`'clip'`, `'crop'`, etc.) with `ResizeMode` and `CropMode` enums
- [ ] Update `StreamImageAttachmentThumbnail` to use `resize` parameter instead of `thumbnailSize`, `thumbnailResizeType`, `thumbnailCropType`
- [ ] Update `StreamMediaAttachmentThumbnail` to use `resize` parameter instead of `thumbnailSize`, `thumbnailResizeType`, `thumbnailCropType`
- [ ] Update `StreamImageAttachment` to use `resize` parameter instead of `imageThumbnailSize`, `imageThumbnailResizeType`, `imageThumbnailCropType`
- [ ] If using a custom CDN, extend `StreamImageCDN` and inject via `StreamChatConfigurationData`
