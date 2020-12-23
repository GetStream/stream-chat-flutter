import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/lazy_load_scroll_view.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'dart:ui' as ui;

extension on Duration {
  String format() {
    final s = '$this'.split('.')[0].padLeft(8, '0');
    if (s.startsWith('00:')) {
      return s.replaceFirst('00:', '');
    }

    return s;
  }
}

class MediaListView extends StatefulWidget {
  final List<String> selectedIds;
  final void Function(AssetEntity media) onSelect;

  const MediaListView({
    Key key,
    this.selectedIds = const [],
    this.onSelect,
  }) : super(key: key);
  @override
  _MediaListViewState createState() => _MediaListViewState();
}

class _MediaListViewState extends State<MediaListView> {
  final _media = <AssetEntity>[];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _endPagination = false;

  @override
  Widget build(BuildContext context) {
    return LazyLoadScrollView(
      onEndOfPage: () {
        _getMedia();
      },
      child: GridView.builder(
        itemCount: _media.length,
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (
          context,
          position,
        ) {
          final media = _media.elementAt(position);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
            child: InkWell(
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: FadeInImage(
                      fadeInDuration: Duration(milliseconds: 300),
                      placeholder: AssetImage(
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
                        duration: Duration(milliseconds: 300),
                        opacity: widget.selectedIds.any((id) => id == media.id)
                            ? 1.0
                            : 0.0,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(
                            top: 8,
                            right: 8,
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: StreamSvgIcon.check(
                              size: 24,
                              color: Colors.black,
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              onTap: () {
                if (widget.onSelect != null) {
                  widget.onSelect(media);
                }
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getMedia();
  }

  void _getMedia() async {
    final assetList = await PhotoManager.getAssetPathList(
      hasAll: true,
    ).then((value) => value.singleWhere((element) => element.isAll));

    final media = await assetList.getAssetListPaged(_currentPage, 50);

    if (media.isEmpty) {
      setState(() {
        _endPagination = true;
      });
    } else {
      setState(() {
        _media.addAll(media);
      });
    }
    ++_currentPage;
  }
}

class MediaThumbnailProvider extends ImageProvider<MediaThumbnailProvider> {
  const MediaThumbnailProvider({
    @required this.media,
  }) : assert(media != null);

  final AssetEntity media;

  @override
  ImageStreamCompleter load(key, decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      informationCollector: () sync* {
        yield ErrorDescription('Id: ${media?.id}');
      },
    );
  }

  Future<ui.Codec> _loadAsync(
      MediaThumbnailProvider key, DecoderCallback decode) async {
    assert(key == this);
    final bytes = await media.thumbData;
    if (bytes?.isNotEmpty != true) return null;

    return await decode(bytes);
  }

  @override
  Future<MediaThumbnailProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MediaThumbnailProvider>(this);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final MediaThumbnailProvider typedOther = other;
    return media?.id == typedOther.media?.id;
  }

  @override
  int get hashCode => media?.id?.hashCode ?? 0;

  @override
  String toString() => '$runtimeType("${media?.id}")';
}
