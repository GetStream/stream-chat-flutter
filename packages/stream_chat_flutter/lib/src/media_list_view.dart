import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/media_list_view_controller.dart';
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
    this.controller,
  }) : super(key: key);

  /// Stores the media selected
  final List<String> selectedIds;

  /// Callback for on media selected
  final void Function(AssetEntity media)? onSelect;

  /// Controller that handles MediaListView
  final MediaListViewController? controller;

  @override
  _MediaListViewState createState() => _MediaListViewState();
}

class _MediaListViewState extends State<MediaListView> {
  var _media = <AssetEntity>[];
  var _currentPage = 0;
  final _scrollController = ScrollController();

  /// Controller necessary to verify limited access to photo gallery in iOS and
  /// update the media list when listerners are emitted
  late final controller = widget.controller ?? MediaListViewController();

  @override
  Widget build(BuildContext context) => LazyLoadScrollView(
        onEndOfPage: () async {
          await _getMedia();
          _updatePage();
        },
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
            final chatThemeData = StreamChatTheme.of(context);
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
                            color: chatThemeData.colorTheme.textHighEmphasis
                                .withOpacity(0.5),
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.only(
                              top: 8,
                              right: 8,
                            ),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: chatThemeData.colorTheme.barsBg,
                              child: StreamSvgIcon.check(
                                size: 24,
                                color:
                                    chatThemeData.colorTheme.textHighEmphasis,
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
                            color: chatThemeData.colorTheme.barsBg,
                          ),
                        ),
                      ),
                    ],
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
    controller.addListener(_updateMediaList);
    _getMedia();
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_updateMediaList);
    if (widget.controller == null) {
      controller.dispose();
    }
  }

  void _updateMediaList() {
    if (controller.shouldUpdateMedia) {
      _getMedia();
    }
  }

  void _updatePage() {
    ++_currentPage;
  }

  Future<void> _getMedia() async {
    final assetList = (await PhotoManager.getAssetPathList(
      filterOption: FilterOptionGroup(
        orders: [
          const OrderOption(
            // ignore: avoid_redundant_argument_values
            type: OrderOptionType.createDate,
          ),
        ],
      ),
      onlyAll: true,
    ))
        .firstOrNull;

    final media = await assetList?.getAssetListPaged(
      page: _currentPage,
      size: 50,
    );

    if (media?.isNotEmpty == true) {
      setState(() {
        _media = media!;
      });
    }
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
    MediaThumbnailProvider key,
    DecoderCallback decode,
  ) =>
      MultiFrameImageStreamCompleter(
        codec: _loadAsync(key, decode),
        scale: 1,
        informationCollector: () sync* {
          yield ErrorDescription('Id: ${media.id}');
        },
      );

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
