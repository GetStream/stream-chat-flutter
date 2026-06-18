import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/stream_attachment_picker_controller.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/scroll_view/photo_gallery/stream_photo_gallery.dart';
import 'package:stream_chat_flutter/src/scroll_view/photo_gallery/stream_photo_gallery_controller.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// Max image resolution which can be resized by the CDN.
/// Taken from https://getstream.io/chat/docs/flutter-dart/file_uploads/?language=dart#image-resizing
const maxCDNImageResolution = 16800000;

/// Widget used to pick media from the device gallery.
class StreamGalleryPicker extends StatefulWidget {
  /// Creates a [StreamGalleryPicker] widget.
  const StreamGalleryPicker({
    super.key,
    this.limit = 50,
    GalleryPickerConfig? config,
    required this.selectedMediaItems,
    required this.onMediaItemSelected,
  }) : config = config ?? const GalleryPickerConfig();

  /// Maximum number of media items that can be selected.
  final int limit;

  /// Configuration for the gallery picker.
  final GalleryPickerConfig config;

  /// List of selected media items.
  final Iterable<String> selectedMediaItems;

  /// Callback called when an media item is selected.
  final ValueSetter<AssetEntity> onMediaItemSelected;

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
    requestPermission = runInPermissionRequestLock(PhotoManager.requestPermissionExtend);
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
        if (!snapshot.hasData) return const Empty();

        final spacing = context.streamSpacing;
        final textTheme = context.streamTextTheme;
        final colorScheme = context.streamColorScheme;

        // Available on both Android and iOS.
        final isAuthorized = snapshot.data == PermissionState.authorized;
        // Only available on iOS.
        final isLimited = snapshot.data == PermissionState.limited;

        final isPermissionGranted = isAuthorized || isLimited;

        return OptionDrawer(
          margin: .zero,
          child: Builder(
            builder: (context) {
              if (!isPermissionGranted) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        size: 32,
                        context.streamIcons.imageLarge,
                        color: colorScheme.textTertiary,
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        context.translations.enablePhotoAndVideoAccessMessage,
                        style: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing.md),
                      StreamButton(
                        size: .medium,
                        type: .outline,
                        style: .secondary,
                        onPressed: PhotoManager.openSetting,
                        child: Text(context.translations.allowGalleryAccessMessage),
                      ),
                    ],
                  ),
                );
              }

              return MediaQuery.removePadding(
                context: context,
                // Workaround for the bottom padding issue.
                // Link: https://github.com/flutter/flutter/issues/156149
                removeTop: true,
                removeBottom: true,
                child: StreamPhotoGallery(
                  shrinkWrap: true,
                  controller: _controller,
                  onMediaTap: widget.onMediaItemSelected,
                  loadMoreTriggerIndex: 10,
                  thumbnailSize: widget.config.mediaThumbnailSize,
                  thumbnailFormat: widget.config.mediaThumbnailFormat,
                  thumbnailQuality: widget.config.mediaThumbnailQuality,
                  thumbnailScale: widget.config.mediaThumbnailScale,
                  addMoreBuilder: switch (isLimited) {
                    true => (context) => _AddMoreTile(
                      onTap: () => PhotoManager.presentLimited().then((_) => _controller.doInitialLoad()).ignore(),
                    ),
                    _ => null,
                  },
                  itemBuilder: (context, mediaItems, index, defaultWidget) {
                    final media = mediaItems[index];
                    return defaultWidget.copyWith(
                      selected: widget.selectedMediaItems.contains(media.id),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _AddMoreTile extends StatelessWidget {
  const _AddMoreTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;

    return Material(
      color: colorScheme.backgroundSurfaceCard,
      child: InkWell(
        onTap: onTap,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return colorScheme.backgroundPressed;
          if (states.contains(WidgetState.hovered)) return colorScheme.backgroundHover;
          return StreamColors.transparent;
        }),
        child: Padding(
          padding: .all(spacing.xs),
          child: Column(
            spacing: spacing.xs,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 20,
                context.streamIcons.plus,
                color: colorScheme.textTertiary,
              ),
              Text(
                context.translations.addMoreFilesLabel,
                style: textTheme.captionEmphasis.copyWith(color: colorScheme.textTertiary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Configuration for the [StreamGalleryPicker].
class GalleryPickerConfig {
  /// Creates a [GalleryPickerConfig] instance.
  const GalleryPickerConfig({
    this.mediaThumbnailSize,
    this.mediaThumbnailFormat = ThumbnailFormat.jpeg,
    this.mediaThumbnailQuality = 100,
    this.mediaThumbnailScale = 1,
  });

  /// Size of the attachment thumbnails in pixels.
  ///
  /// When null (the default), each tile auto-calculates its size from its
  /// own layout constraints and the device pixel ratio.
  final ThumbnailSize? mediaThumbnailSize;

  /// Format of the attachment thumbnails.
  final ThumbnailFormat mediaThumbnailFormat;

  /// The quality value for the attachment thumbnails.
  final int mediaThumbnailQuality;

  /// The scale to apply on the [mediaThumbnailSize].
  final double mediaThumbnailScale;
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

    final mimeType = file.mediaType?.mimeType;

    if (mimeType != null) {
      extraDataMap['mime_type'] = mimeType;
    }

    extraDataMap['file_size'] = file.size!;

    if (type == AssetType.video) {
      extraDataMap['duration'] = asset.videoDuration.inSeconds;
    }

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
        final cachedFile = File('${tempDir.path}/${image.path.split('/').last}');
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
