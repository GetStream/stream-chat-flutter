import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

extension on Duration {
  String format() {
    final s = '$this'.split('.')[0].padLeft(8, '0');
    if (s.startsWith('00:')) {
      return s.replaceFirst('00:', '');
    }

    return s;
  }
}

/// Constructs a list of media
class MediaListView extends StatefulWidget {
  /// Constructor for creating a [MediaListView] widget
  const MediaListView({
    Key? key,
    this.selectedIds = const [],
    this.onSelect,
  }) : super(key: key);

  /// Stores the media selected
  final List<String> selectedIds;

  /// Callback for on media selected
  final void Function(AssetEntity media)? onSelect;

  @override
  _MediaListViewState createState() => _MediaListViewState();
}

class _MediaListViewState extends State<MediaListView> {
  final _media = <AssetEntity>[];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) => LazyLoadScrollView(
        onEndOfPage: () async => _getMedia(),
        child: GridView.builder(
          itemCount: _media.length,
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (
            context,
            position,
          ) {
            final media = _media.elementAt(position);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: InkWell(
                onTap: () {
                  if (widget.onSelect != null) {
                    widget.onSelect!(media);
                  }
                },
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: FadeInImage(
                        fadeInDuration: const Duration(milliseconds: 300),
                        placeholder: const AssetImage(
                          'images/placeholder.png',
                          package: 'stream_chat_flutter',
                        ),
                        image: MediaThumbnailProvider(
                          media: media,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity:
                              widget.selectedIds.any((id) => id == media.id)
                                  ? 1.0
                                  : 0.0,
                          child: Container(
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .black
                                .withOpacity(0.5),
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.only(
                              top: 8,
                              right: 8,
                            ),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor:
                                  StreamChatTheme.of(context).colorTheme.white,
                              child: StreamSvgIcon.check(
                                size: 24,
                                color: StreamChatTheme.of(context)
                                    .colorTheme
                                    .black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (media.type == AssetType.video) ...[
                      Positioned(
                        left: 8,
                        bottom: 10,
                        child: SvgPicture.asset(
                          'svgs/video_call_icon.svg',
                          package: 'stream_chat_flutter',
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 10,
                        child: Text(
                          media.videoDuration.format(),
                          style: TextStyle(
                            color: StreamChatTheme.of(context).colorTheme.white,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            );
          },
        ),
      );

  @override
  void initState() {
    super.initState();
    _getMedia();
  }

  void _getMedia() async {
    final assetList = await PhotoManager.getAssetPathList().then((value) {
      if (value.isNotEmpty == true) {
        return value.singleWhere((element) => element.isAll);
      }
    });

    if (assetList == null) {
      return;
    }

    final media = await assetList.getAssetListPaged(_currentPage, 50);

    if (media.isNotEmpty) {
      setState(() {
        _media.addAll(media);
      });
    }
    ++_currentPage;
  }
}

/// ImageProvider implementation
class MediaThumbnailProvider extends ImageProvider<MediaThumbnailProvider> {
  /// Constructor for creating a [MediaThumbnailProvider]
  const MediaThumbnailProvider({
    required this.media,
  });

  /// Media to load
  final AssetEntity media;

  @override
  ImageStreamCompleter load(
          MediaThumbnailProvider key, DecoderCallback decode) =>
      MultiFrameImageStreamCompleter(
        codec: _loadAsync(key, decode),
        scale: 1,
        informationCollector: () sync* {
          yield ErrorDescription('Id: ${media.id}');
        },
      );

  Future<ui.Codec> _loadAsync(
      MediaThumbnailProvider key, DecoderCallback decode) async {
    assert(key == this, 'Checks MediaThumbnailProvider');
    final bytes = await media.thumbData;

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
