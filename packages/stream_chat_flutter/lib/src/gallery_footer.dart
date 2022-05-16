import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro gallery_footer}
@Deprecated("Use 'StreamGalleryFooter' instead")
typedef GalleryFooter = StreamGalleryFooter;

/// {@template gallery_footer}
/// Footer widget for media display
/// {@endtemplate}
class StreamGalleryFooter extends StatefulWidget
    implements PreferredSizeWidget {
  /// Creates a StreamGalleryFooter
  const StreamGalleryFooter({
    super.key,
    this.onBackPressed,
    this.onTitleTap,
    this.onImageTap,
    this.currentPage = 0,
    this.totalPages = 0,
    required this.mediaAttachmentPackages,
    this.mediaSelectedCallBack,
    this.backgroundColor,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

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
  final List<StreamAttachmentPackage> mediaAttachmentPackages;

  /// Callback when media is selected
  final ValueChanged<int>? mediaSelectedCallBack;

  /// The background color of this [StreamGalleryFooter].
  final Color? backgroundColor;

  @override
  _StreamGalleryFooterState createState() => _StreamGalleryFooterState();

  @override
  final Size preferredSize;
}

class _StreamGalleryFooterState extends State<StreamGalleryFooter> {
  @override
  Widget build(BuildContext context) {
    const showShareButton = !kIsWeb;
    final mediaQueryData = MediaQuery.of(context);
    final galleryFooterThemeData = StreamGalleryFooterTheme.of(context);
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
                    final attachment = widget
                        .mediaAttachmentPackages[widget.currentPage].attachment;
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
    final galleryFooterThemeData = StreamGalleryFooterTheme.of(context);
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
            widget.mediaAttachmentPackages.length > crossAxisCount ? 2 : 1;
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
                    itemCount: widget.mediaAttachmentPackages.length,
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
                      final attachmentPackage =
                          widget.mediaAttachmentPackages[index];
                      final attachment = attachmentPackage.attachment;
                      final message = attachmentPackage.message;
                      if (attachment.type == 'video') {
                        media = InkWell(
                          onTap: () => widget.mediaSelectedCallBack!(index),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: StreamVideoThumbnailImage(
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
                          if (message.user != null)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                padding: const EdgeInsets.all(2),
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
                                child: StreamUserAvatar(
                                  user: message.user!,
                                  constraints:
                                      BoxConstraints.tight(const Size(24, 24)),
                                  showOnlineStatus: false,
                                ),
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
