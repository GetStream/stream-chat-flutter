import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// Widget that displays a photo or video item from the gallery.
class StreamPhotoGalleryTile extends StatelessWidget {
  /// Creates a new instance of [StreamPhotoGalleryTile].
  const StreamPhotoGalleryTile({
    super.key,
    required this.media,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.thumbnailSize = const ThumbnailSize(400, 400),
    this.thumbnailFormat = ThumbnailFormat.jpeg,
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

  /// The thumbnail size.
  final ThumbnailSize thumbnailSize;

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
    thumbnailSize: thumbnailSize ?? this.thumbnailSize,
    thumbnailFormat: thumbnailFormat ?? this.thumbnailFormat,
    thumbnailQuality: thumbnailQuality ?? this.thumbnailQuality,
    thumbnailScale: thumbnailScale ?? this.thumbnailScale,
  );

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: FadeInImage(
            fadeInDuration: const Duration(milliseconds: 300),
            placeholder: const AssetImage(
              'lib/assets/images/placeholder.png',
              package: 'stream_chat_flutter',
            ),
            fit: BoxFit.cover,
            image: MediaThumbnailProvider(
              media: media,
              size: thumbnailSize,
              format: thumbnailFormat,
              quality: thumbnailQuality,
              scale: thumbnailScale,
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: selected ? 1.0 : 0.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: chatThemeData.colorTheme.textHighEmphasis.withOpacity(0.15),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IgnorePointer(
            child: _GallerySelectedIndicator(selected: selected),
          ),
        ),
        if (media.type == AssetType.video)
          Positioned(
            left: 8,
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
    );
  }
}

class _GallerySelectedIndicator extends StatelessWidget {
  const _GallerySelectedIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? const Color(0xFF005FFF) : Colors.transparent,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: selected
          ? Icon(
              context.streamIcons.checkmark1Small,
              fontWeight: FontWeight.w900,
              size: 12,
              color: Colors.white,
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
    // TODO: Are these sizes optimal? Consider web/desktop
    this.size = const ThumbnailSize(400, 400),
    this.format = ThumbnailFormat.jpeg,
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
