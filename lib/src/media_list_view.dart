import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';

class MediaListView extends StatefulWidget {
  final List<String> selectedIds;
  final void Function(Media media) onSelect;

  const MediaListView({
    Key key,
    this.selectedIds = const [],
    this.onSelect,
  }) : super(key: key);
  @override
  _MediaListViewState createState() => _MediaListViewState();
}

class _MediaListViewState extends State<MediaListView> {
  final _media = <Media>[];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _media.length,
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      cacheExtent: 1000,
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
                      highQuality: true,
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
                if (media.mediaType == MediaType.video)
                  Positioned(
                    left: 8,
                    bottom: 10,
                    child: SvgPicture.asset(
                      'svgs/video_call_icon.svg',
                      package: 'stream_chat_flutter',
                    ),
                  ),
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
    );
  }

  @override
  void initState() {
    super.initState();
    _getMedia();
  }

  void _getMedia() async {
    final List<MediaCollection> collections =
        await MediaGallery.listMediaCollections(
      mediaTypes: [
        MediaType.video,
        MediaType.image,
      ],
    );

    if (collections.isEmpty) {
      return;
    }
    final collection = collections.firstWhere(
      (element) => element.isAllCollection,
      orElse: () => collections.first,
    );

    final videoPage = await collection.getMedias(
      mediaType: MediaType.video,
      take: 500,
    );
    final imagePage = await collection.getMedias(
      mediaType: MediaType.image,
      take: 500,
    );

    final allItems = [
      ...videoPage.items,
      ...imagePage.items,
    ]..sort((
        a,
        b,
      ) =>
          b.creationDate.compareTo(a.creationDate));

    setState(() {
      _media.addAll(allItems);
    });
  }
}
