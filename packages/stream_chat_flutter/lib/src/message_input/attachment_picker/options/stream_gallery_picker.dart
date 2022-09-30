import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/scroll_view/photo_gallery/stream_photo_gallery.dart';
import 'package:stream_chat_flutter/src/scroll_view/photo_gallery/stream_photo_gallery_controller.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Max image resolution which can be resized by the CDN.
// Taken from https://getstream.io/chat/docs/flutter-dart/file_uploads/?language=dart#image-resizing
const maxCDNImageResolution = 16800000;

/// Widget used to pick media from the device gallery.
class StreamGalleryPicker extends StatefulWidget {
  /// Creates a [StreamGalleryPicker] widget.
  const StreamGalleryPicker({
    super.key,
    this.limit = 50,
    required this.selectedMediaItems,
    required this.onMediaItemSelected,
    this.mediaThumbnailSize = const ThumbnailSize(400, 400),
    this.mediaThumbnailFormat = ThumbnailFormat.jpeg,
    this.mediaThumbnailQuality = 100,
    this.mediaThumbnailScale = 1,
  });

  /// Maximum number of media items that can be selected.
  final int limit;

  /// List of selected media items.
  final Iterable<String> selectedMediaItems;

  /// Callback called when an media item is selected.
  final ValueSetter<AssetEntity> onMediaItemSelected;

  /// Size of the attachment thumbnails.
  ///
  /// Defaults to (400, 400).
  final ThumbnailSize mediaThumbnailSize;

  /// Format of the attachment thumbnails.
  ///
  /// Defaults to [ThumbnailFormat.jpeg].
  final ThumbnailFormat mediaThumbnailFormat;

  /// The quality value for the attachment thumbnails.
  ///
  /// Valid from 1 to 100.
  /// Defaults to 100.
  final int mediaThumbnailQuality;

  /// The scale to apply on the [attachmentThumbnailSize].
  final double mediaThumbnailScale;

  @override
  State<StreamGalleryPicker> createState() => _StreamGalleryPickerState();
}

class _StreamGalleryPickerState extends State<StreamGalleryPicker> {
  Future<PermissionState>? requestPermission;
  late StreamPhotoGalleryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StreamPhotoGalleryController(limit: widget.limit);
    requestPermission = runInPermissionRequestLock(
      PhotoManager.requestPermissionExtend,
    );
  }

  @override
  void didUpdateWidget(StreamGalleryPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.limit != oldWidget.limit) {
      _controller.dispose();
      _controller = StreamPhotoGalleryController(limit: widget.limit);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionState>(
      future: requestPermission,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final theme = StreamChatTheme.of(context);
        final textTheme = theme.textTheme;
        final colorTheme = theme.colorTheme;

        // Available on both Android and iOS.
        final isAuthorized = snapshot.data == PermissionState.authorized;
        // Only available on iOS.
        final isLimited = snapshot.data == PermissionState.limited;

        final isPermissionGranted = isAuthorized || isLimited;

        return OptionDrawer(
          actions: [
            if (isLimited)
              IconButton(
                color: colorTheme.accentPrimary,
                icon: const Icon(Icons.add_circle_outline_rounded),
                onPressed: () async {
                  await PhotoManager.presentLimited();
                  _controller.doInitialLoad();
                },
              ),
          ],
          child: Builder(
            builder: (context) {
              if (!isPermissionGranted) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamSvgIcon.pictures(
                      size: 240,
                      color: colorTheme.disabled,
                    ),
                    Text(
                      context.translations.enablePhotoAndVideoAccessMessage,
                      style: textTheme.body.copyWith(
                        color: colorTheme.textLowEmphasis,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: PhotoManager.openSetting,
                      child: Text(
                        context.translations.allowGalleryAccessMessage,
                        style: textTheme.bodyBold.copyWith(
                          color: colorTheme.accentPrimary,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return StreamPhotoGallery(
                shrinkWrap: true,
                controller: _controller,
                onMediaTap: widget.onMediaItemSelected,
                loadMoreTriggerIndex: 10,
                padding: const EdgeInsets.all(2),
                thumbnailSize: widget.mediaThumbnailSize,
                thumbnailFormat: widget.mediaThumbnailFormat,
                thumbnailQuality: widget.mediaThumbnailQuality,
                thumbnailScale: widget.mediaThumbnailScale,
                itemBuilder: (context, mediaItems, index, defaultWidget) {
                  final media = mediaItems[index];
                  return defaultWidget.copyWith(
                    selected: widget.selectedMediaItems.contains(media.id),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

///
extension StreamImagePickerX on StreamAttachmentPickerController {
  ///
  Future<void> addAssetAttachment(AssetEntity asset) async {
    final mediaFile = await asset.originFile;

    if (mediaFile == null) return;

    var cachedFile = mediaFile;

    final type = asset.type;
    if (type == AssetType.image) {
      // Resize image if it's resolution is greater than the
      // [maxCDNImageResolution].
      final imageResolution = asset.width * asset.height;
      if (imageResolution > maxCDNImageResolution) {
        final aspect = imageResolution / maxCDNImageResolution;
        final updatedSize = asset.size / (math.sqrt(aspect));
        final resizedImage = await asset.thumbnailDataWithSize(
          ThumbnailSize(
            updatedSize.width.floor(),
            updatedSize.height.floor(),
          ),
          quality: 70,
        );

        final tempDir = await getTemporaryDirectory();
        cachedFile = await File(
          '${tempDir.path}/${mediaFile.path.split('/').last}',
        ).create().then((it) => it.writeAsBytes(resizedImage!));
      }
    }

    final file = AttachmentFile(
      path: cachedFile.path,
      size: await cachedFile.length(),
      bytes: cachedFile.readAsBytesSync(),
    );

    final extraDataMap = <String, Object>{};

    final mimeType = file.mimeType?.mimeType;

    if (mimeType != null) {
      extraDataMap['mime_type'] = mimeType;
    }

    extraDataMap['file_size'] = file.size!;

    final attachment = Attachment(
      id: asset.id,
      file: file,
      type: asset.type.toAttachmentType(),
      extraData: extraDataMap,
    );

    return addAttachment(attachment);
  }

  ///
  Future<void> removeAssetAttachment(AssetEntity asset) async {
    if (asset.type == AssetType.image) {
      final image = await asset.originFile;
      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        final cachedFile =
            File('${tempDir.path}/${image.path.split('/').last}');
        if (cachedFile.existsSync()) {
          cachedFile.deleteSync();
        }
      }
    }
    return removeAttachmentById(asset.id);
  }
}

///
extension AssetTypeX on AssetType {
  ///
  String toAttachmentType() {
    switch (this) {
      case AssetType.image:
        return 'image';
      case AssetType.video:
        return 'video';
      case AssetType.audio:
        return 'audio';
      case AssetType.other:
        return 'file';
    }
  }
}
