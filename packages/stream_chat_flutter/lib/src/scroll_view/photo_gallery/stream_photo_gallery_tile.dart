import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_size_calculator.dart';
import 'package:stream_core_flutter/chat.dart';

/// Widget that displays a photo or video item from the gallery.
class StreamPhotoGalleryTile extends StatelessWidget {
  /// Creates a new instance of [StreamPhotoGalleryTile].
  const StreamPhotoGalleryTile({
    super.key,
    required this.media,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.fit = .cover,
    this.thumbnailSize,
    this.thumbnailFormat = .jpeg,
    this.thumbnailQuality = 100,
    this.thumbnailScale = 1,
  });

  /// The media item to display.
  final AssetEntity media;

  /// Whether the media item is selected.
  final bool selected;

  /// Called when the user taps this grid tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this grid tile.
  final GestureLongPressCallback? onLongPress;

  /// Fit of the underlying thumbnail image. Defaults to [BoxFit.cover].
  final BoxFit fit;

  /// The thumbnail size in pixels to request from the platform.
  ///
  /// When null (the default), the size is auto-calculated from the tile's
  /// layout constraints and the device pixel ratio so we don't decode more
  /// pixels than the tile actually displays.
  final ThumbnailSize? thumbnailSize;

  /// {@macro photo_manager.ThumbnailFormat}
  final ThumbnailFormat thumbnailFormat;

  /// The quality value for the thumbnail.
  ///
  /// Valid from 1 to 100.
  /// Defaults to 100.
  final int thumbnailQuality;

  /// Scale of the image.
  final double thumbnailScale;

  /// Creates a copy of this tile but with the given fields replaced with
  /// the new values.
  StreamPhotoGalleryTile copyWith({
    Key? key,
    AssetEntity? media,
    bool? selected,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    BoxFit? fit,
    ThumbnailSize? thumbnailSize,
    ThumbnailFormat? thumbnailFormat,
    int? thumbnailQuality,
    double? thumbnailScale,
  }) => StreamPhotoGalleryTile(
    key: key ?? this.key,
    media: media ?? this.media,
    selected: selected ?? this.selected,
    onTap: onTap ?? this.onTap,
    onLongPress: onLongPress ?? this.onLongPress,
    fit: fit ?? this.fit,
    thumbnailSize: thumbnailSize ?? this.thumbnailSize,
    thumbnailFormat: thumbnailFormat ?? this.thumbnailFormat,
    thumbnailQuality: thumbnailQuality ?? this.thumbnailQuality,
    thumbnailScale: thumbnailScale ?? this.thumbnailScale,
  );

  @override
  Widget build(BuildContext context) {
    final radius = context.streamRadius;
    final colorScheme = context.streamColorScheme;

    return ClipRRect(
      clipBehavior: .hardEdge,
      borderRadius: .all(radius.xxs),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: _GalleryThumbnail(
              fit: fit,
              media: media,
              size: thumbnailSize,
              format: thumbnailFormat,
              quality: thumbnailQuality,
              scale: thumbnailScale,
            ),
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: ColoredBox(color: colorScheme.backgroundSelected),
            ),
          ),
          PositionedDirectional(
            top: 8,
            end: 8,
            child: _GallerySelectedIndicator(selected: selected),
          ),
          if (media.type == AssetType.video)
            PositionedDirectional(
              start: 8,
              bottom: 8,
              child: StreamMediaBadge(
                type: MediaBadgeType.video,
                duration: media.videoDuration,
                durationFormat: MediaBadgeDurationFormat.exact,
              ),
            ),
          // https://stackoverflow.com/a/59317162/10036882
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryThumbnail extends StatelessWidget {
  const _GalleryThumbnail({
    required this.media,
    required this.fit,
    required this.size,
    required this.format,
    required this.quality,
    required this.scale,
  });

  final AssetEntity media;
  final BoxFit fit;
  final ThumbnailSize? size;
  final ThumbnailFormat format;
  final int quality;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveSize = size ?? _autoSize(context, constraints);

        return Image(
          fit: fit,
          image: MediaThumbnailProvider(
            media: media,
            size: effectiveSize,
            format: format,
            quality: quality,
            scale: scale,
          ),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) return child;
            return const StreamImageLoadingPlaceholder();
          },
          errorBuilder: (context, error, stackTrace) {
            return const StreamImageErrorPlaceholder();
          },
        );
      },
    );
  }

  ThumbnailSize _autoSize(BuildContext context, BoxConstraints constraints) {
    // orientatedSize accounts for EXIF rotation so portrait shots get the
    // right aspect ratio. It's (0, 0) when EXIF parsing fails — the
    // calculator returns null for that, and we fall back to the default
    // tile size from Figma. fit drives cover vs contain sizing so the
    // bitmap matches what the Image will actually paint, no upscale blur.
    final size = ThumbnailSizeCalculator.calculate(
      targetSize: constraints.biggest,
      originalSize: media.orientatedSize,
      pixelRatio: MediaQuery.devicePixelRatioOf(context),
      fit: fit,
    );

    if (size == null) return const .square(132);
    return .new(size.width.round(), size.height.round());
  }
}

class _GallerySelectedIndicator extends StatelessWidget {
  const _GallerySelectedIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final colorScheme = context.streamColorScheme;

    return AnimatedContainer(
      width: 24,
      height: 24,
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colorScheme.accentPrimary : Colors.transparent,
        border: .all(color: colorScheme.borderOnAccent, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
      ),
      child: selected
          ? Icon(
              size: 12,
              icons.checkmark,
              fontWeight: .w900,
              color: colorScheme.textOnAccent,
            )
          : null,
    );
  }
}

/// {@template mediaThumbnailProvider}
/// Builds a thumbnail using [ImageProvider].
/// {@endtemplate}
class MediaThumbnailProvider extends ImageProvider<MediaThumbnailProvider> {
  /// {@macro mediaThumbnailProvider}
  const MediaThumbnailProvider({
    required this.media,
    this.size = const .square(132),
    this.format = .jpeg,
    this.quality = 100,
    this.scale = 1,
  });

  /// Media to load
  final AssetEntity media;

  /// The thumbnail size.
  final ThumbnailSize size;

  /// {@macro photo_manager.ThumbnailFormat}
  final ThumbnailFormat format;

  /// The quality value for the thumbnail.
  ///
  /// Valid from 1 to 100.
  /// Defaults to 100.
  final int quality;

  /// Scale of the image.
  final double scale;

  @override
  Future<MediaThumbnailProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MediaThumbnailProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    MediaThumbnailProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>(
          'Thumbnail provider: $this \n Thumbnail key: $key',
          this,
          style: DiagnosticsTreeStyle.errorProperty,
        );
      },
    );
  }

  Future<ui.Codec> _loadAsync(
    MediaThumbnailProvider key,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this, '$key is not $this');
    final bytes = await media.thumbnailDataWithSize(
      size,
      format: format,
      quality: quality,
    );
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes!);
    return decode(buffer);
  }

  @override
  bool operator ==(Object other) {
    if (other is MediaThumbnailProvider) {
      return media == other.media &&
          size == other.size &&
          format == other.format &&
          quality == other.quality &&
          scale == other.scale;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(media, size, format, quality, scale);

  @override
  String toString() =>
      '$runtimeType('
      'media: $media, '
      'size: $size, '
      'format: $format, '
      'quality: $quality, '
      'scale: $scale'
      ')';
}
