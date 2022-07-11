import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

/// {@template mediaThumbnailProvider}
/// Builds a thumbnail using [ImageProvider].
/// {@endtemplate}
class MediaThumbnailProvider extends ImageProvider<MediaThumbnailProvider> {
  /// {@macro mediaThumbnailProvider}
  const MediaThumbnailProvider({
    required this.media,
  });

  /// Media to load
  final AssetEntity media;

  @override
  ImageStreamCompleter load(
    MediaThumbnailProvider key,
    DecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1,
      informationCollector: () sync* {
        yield ErrorDescription('Id: ${media.id}');
      },
    );
  }

  Future<ui.Codec> _loadAsync(
    MediaThumbnailProvider key,
    DecoderCallback decode,
  ) async {
    assert(key == this, 'Checks MediaThumbnailProvider');
    final bytes = await media.thumbnailData;

    return decode(bytes!);
  }

  @override
  Future<MediaThumbnailProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<MediaThumbnailProvider>(this);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final MediaThumbnailProvider typedOther = other;
    return media.id == typedOther.media.id;
  }

  @override
  int get hashCode => media.id.hashCode;

  @override
  String toString() => '$runtimeType("${media.id}")';
}
