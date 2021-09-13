import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';
import 'package:stream_chat_flutter/src/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Footer widget for media display
class GalleryFooter extends StatefulWidget implements PreferredSizeWidget {
  /// Creates a channel header
  const GalleryFooter({
    Key? key,
    required this.message,
    this.onBackPressed,
    this.onTitleTap,
    this.onImageTap,
    this.currentPage = 0,
    this.totalPages = 0,
    this.mediaAttachments = const [],
    this.mediaSelectedCallBack,
    this.backgroundColor,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  /// Callback to call when pressing the back button.
  /// By default it calls [Navigator.pop]
  final VoidCallback? onBackPressed;

  /// Callback to call when the header is tapped.
  final VoidCallback? onTitleTap;

  /// Callback to call when the image is tapped.
  final VoidCallback? onImageTap;

  /// Stores the current index of media shown
  final int currentPage;

  /// Total number of pages of media
  final int totalPages;

  /// All attachments to show
  final List<Attachment> mediaAttachments;

  /// Message which attachments are attached to
  final Message message;

  /// Callback when media is selected
  final ValueChanged<int>? mediaSelectedCallBack;

  /// The background color of this [GalleryFooter].
  final Color? backgroundColor;

  @override
  _GalleryFooterState createState() => _GalleryFooterState();

  @override
  final Size preferredSize;
}

class _GalleryFooterState extends State<GalleryFooter> {
  @override
  Widget build(BuildContext context) {
    const showShareButton = !kIsWeb;
    final mediaQueryData = MediaQuery.of(context);
    final galleryFooterThemeData = GalleryFooterTheme.of(context);
    return SizedBox.fromSize(
      size: Size(
        mediaQueryData.size.width,
        mediaQueryData.padding.bottom + widget.preferredSize.height,
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BottomAppBar(
          color:
              widget.backgroundColor ?? galleryFooterThemeData.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!showShareButton)
                Container(
                  width: 48,
                )
              else
                IconButton(
                  icon: StreamSvgIcon.iconShare(
                    size: 24,
                    color: galleryFooterThemeData.shareIconColor,
                  ),
                  onPressed: () async {
                    final attachment =
                        widget.mediaAttachments[widget.currentPage];
                    final url = attachment.imageUrl ??
                        attachment.assetUrl ??
                        attachment.thumbUrl!;
                    final type = attachment.type == 'image'
                        ? 'jpg'
                        : url.split('?').first.split('.').last;
                    final request = await HttpClient().getUrl(Uri.parse(url));
                    final response = await request.close();
                    final bytes =
                        await consolidateHttpClientResponseBytes(response);
                    final tmpPath = await getTemporaryDirectory();
                    final filePath = '${tmpPath.path}/${attachment.id}.$type';
                    final file = File(filePath);
                    await file.writeAsBytes(bytes);
                    await Share.shareFiles(
                      [filePath],
                      mimeTypes: [
                        'image/$type',
                      ],
                    );
                  },
                ),
              InkWell(
                onTap: widget.onTitleTap,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        context.translations.galleryPaginationText(
                          currentPage: widget.currentPage,
                          totalPages: widget.totalPages,
                        ),
                        style: galleryFooterThemeData.titleTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: StreamSvgIcon.iconGrid(
                  color: galleryFooterThemeData.gridIconButtonColor,
                ),
                onPressed: () => _showPhotosModal(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotosModal(context) {
    final chatThemeData = StreamChatTheme.of(context);
    final galleryFooterThemeData = GalleryFooterTheme.of(context);
    showModalBottomSheet(
      context: context,
      barrierColor: galleryFooterThemeData.bottomSheetBarrierColor,
      backgroundColor: galleryFooterThemeData.bottomSheetBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        const crossAxisCount = 3;
        final noOfRowToShowInitially =
            widget.mediaAttachments.length > crossAxisCount ? 2 : 1;
        final size = MediaQuery.of(context).size;
        final initialChildSize =
            48 + (size.width * noOfRowToShowInitially) / crossAxisCount;
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: initialChildSize / size.height,
          minChildSize: initialChildSize / size.height,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          context.translations.photosLabel,
                          style:
                              galleryFooterThemeData.bottomSheetPhotosTextStyle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: StreamSvgIcon.close(
                          color:
                              galleryFooterThemeData.bottomSheetCloseIconColor,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.mediaAttachments.length,
                    padding: const EdgeInsets.all(1),
                    // ignore: lines_longer_than_80_chars
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      Widget media;
                      final attachment = widget.mediaAttachments[index];
                      if (attachment.type == 'video') {
                        media = InkWell(
                          onTap: () => widget.mediaSelectedCallBack!(index),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: VideoThumbnailImage(
                              video: (attachment.file?.path ??
                                  attachment.assetUrl)!,
                            ),
                          ),
                        );
                      } else {
                        media = InkWell(
                          onTap: () => widget.mediaSelectedCallBack!(index),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: attachment.imageUrl ??
                                  attachment.assetUrl ??
                                  attachment.thumbUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }

                      return Stack(
                        children: [
                          media,
                          if (widget.message.user != null)
                            Container(
                              padding: const EdgeInsets.all(10),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.6),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: chatThemeData
                                        .colorTheme.textHighEmphasis
                                        .withOpacity(0.3),
                                  ),
                                ],
                              ),
                              child: UserAvatar(
                                user: widget.message.user!,
                                constraints:
                                    BoxConstraints.tight(const Size(24, 24)),
                                showOnlineStatus: false,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
