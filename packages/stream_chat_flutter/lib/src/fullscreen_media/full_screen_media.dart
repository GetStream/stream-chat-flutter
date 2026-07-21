import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_chat_flutter/src/fullscreen_media/gallery_navigation_item.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

/// A full screen image widget
class StreamFullScreenMedia extends StatefulWidget {
  /// Instantiate a new FullScreenImage
  const StreamFullScreenMedia({
    super.key,
    required this.mediaAttachmentPackages,
    this.startIndex = 0,
    this.userName = '',
    this.onShowMessage,
    this.onReplyMessage,
    this.attachmentActionsModalBuilder,
    this.autoplayVideos = false,
  }) : assert(startIndex >= 0, 'startIndex cannot be negative');

  /// The url of the image
  final List<StreamAttachmentPackage> mediaAttachmentPackages;

  /// First index of media shown
  final int startIndex;

  /// Username of sender
  final String userName;

  /// Callback for when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// Callback for when reply message is tapped
  final ReplyMessageCallback? onReplyMessage;

  /// Widget builder for attachment actions modal
  /// [defaultActionsModal] is the default [AttachmentActionsModal] config
  /// Use [defaultActionsModal.copyWith] to easily customize it
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// Auto-play videos when page is opened
  final bool autoplayVideos;

  @override
  _FullScreenMediaState createState() => _FullScreenMediaState();
}

class _FullScreenMediaState extends State<StreamFullScreenMedia> {
  late final PageController _pageController;

  late final _currentPage = ValueNotifier(widget.startIndex);
  late final _isDisplayingDetail = ValueNotifier<bool>(true);

  void switchDisplayingDetail() {
    _isDisplayingDetail.value = !_isDisplayingDetail.value;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.startIndex);
  }

  @override
  void dispose() {
    _currentPage.dispose();
    _pageController.dispose();
    _isDisplayingDetail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ValueListenableBuilder<int>(
        valueListenable: _currentPage,
        builder: (context, currentPage, child) {
          final _currentAttachmentPackage =
              widget.mediaAttachmentPackages[currentPage];
          final _currentMessage = _currentAttachmentPackage.message;
          final _currentAttachment = _currentAttachmentPackage.attachment;
          return Stack(
            children: [
              child!,
              ValueListenableBuilder<bool>(
                valueListenable: _isDisplayingDetail,
                builder: (context, isDisplayingDetail, child) {
                  final mediaQuery = MediaQuery.of(context);
                  final topPadding = mediaQuery.padding.top;
                  return AnimatedPositionedDirectional(
                    duration: kThemeAnimationDuration,
                    curve: Curves.easeInOut,
                    top:
                        isDisplayingDetail ? 0 : -(topPadding + kToolbarHeight),
                    start: 0,
                    end: 0,
                    height: topPadding + kToolbarHeight,
                    child: StreamGalleryHeader(
                      userName: widget.userName,
                      sentAt: context.translations.sentAtText(
                        date: _currentAttachmentPackage.message.createdAt,
                        time: _currentAttachmentPackage.message.createdAt,
                      ),
                      onBackPressed: Navigator.of(context).pop,
                      message: _currentMessage,
                      attachment: _currentAttachment,
                      onShowMessage: widget.onShowMessage != null
                          ? () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              widget.onShowMessage?.call(
                                _currentMessage,
                                StreamChannel.of(context).channel,
                              );
                            }
                          : null,
                      onReplyMessage: widget.onReplyMessage != null
                          ? () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              widget.onReplyMessage?.call(
                                _currentMessage,
                              );
                            }
                          : null,
                      attachmentActionsModalBuilder:
                          widget.attachmentActionsModalBuilder,
                    ),
                  );
                },
              ),
              if (!_currentMessage.isEphemeral)
                ValueListenableBuilder<bool>(
                  valueListenable: _isDisplayingDetail,
                  builder: (context, isDisplayingDetail, child) {
                    final mediaQuery = MediaQuery.of(context);
                    final bottomPadding = mediaQuery.padding.bottom;
                    return AnimatedPositionedDirectional(
                      duration: kThemeAnimationDuration,
                      curve: Curves.easeInOut,
                      bottom: isDisplayingDetail
                          ? 0
                          : -(bottomPadding + kToolbarHeight),
                      start: 0,
                      end: 0,
                      height: bottomPadding + kToolbarHeight,
                      child: StreamGalleryFooter(
                        currentPage: currentPage,
                        totalPages: widget.mediaAttachmentPackages.length,
                        mediaAttachmentPackages: widget.mediaAttachmentPackages,
                        mediaSelectedCallBack: (val) {
                          _currentPage.value = val;
                          _pageController.animateToPage(
                            val,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              if (widget.mediaAttachmentPackages.length > 1) ...[
                if (currentPage > 0)
                  GalleryNavigationItem(
                    left: 8,
                    opacityAnimation: _isDisplayingDetail,
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () {
                      _currentPage.value--;
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                if (currentPage < widget.mediaAttachmentPackages.length - 1)
                  GalleryNavigationItem(
                    right: 8,
                    opacityAnimation: _isDisplayingDetail,
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () {
                      _currentPage.value++;
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
              ],
            ],
          );
        },
        child: InkWell(
          onTap: switchDisplayingDetail,
          child: KeyboardShortcutRunner(
            onEscapeKeypress: Navigator.of(context).pop,
            onLeftArrowKeypress: () {
              if (_currentPage.value > 0) {
                _currentPage.value--;
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            onRightArrowKeypress: () {
              if (_currentPage.value <
                  widget.mediaAttachmentPackages.length - 1) {
                _currentPage.value++;
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: FullScreenMediaScope(
              activeIndex: _currentPage,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.mediaAttachmentPackages.length,
                onPageChanged: (val) => _currentPage.value = val,
                itemBuilder: (context, index) {
                  final currentAttachmentPackage =
                      widget.mediaAttachmentPackages[index];
                  final attachment = currentAttachmentPackage.attachment;
                  return ValueListenableBuilder(
                    valueListenable: _isDisplayingDetail,
                    builder: (context, isDisplayingDetail, child) {
                      final padding = MediaQuery.paddingOf(context);

                      return AnimatedContainer(
                        duration: kThemeChangeDuration,
                        color: switch (isDisplayingDetail) {
                          true => StreamChannelHeaderTheme.of(context).color,
                          false => Colors.black,
                        },
                        padding: EdgeInsetsDirectional.only(
                          top: padding.top + kToolbarHeight,
                          bottom: padding.bottom + kToolbarHeight,
                        ),
                        child: child,
                      );
                    },
                    child: Builder(
                      builder: (context) {
                        if (attachment.type == AttachmentType.image ||
                            attachment.type == AttachmentType.giphy) {
                          return PhotoView.customChild(
                            maxScale: PhotoViewComputedScale.covered,
                            minScale: PhotoViewComputedScale.contained,
                            backgroundDecoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: StreamMediaAttachmentThumbnail(
                              media: attachment,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          );
                        } else if (attachment.type == AttachmentType.video) {
                          return StreamVideoPlayer(
                            attachment: attachment,
                            pageIndex: index,
                            autoplay: widget.autoplayVideos,
                          );
                        }

                        return const Empty();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Class for packaging up things required for videos
class VideoPackage {
  /// Constructor for creating [VideoPackage]
  VideoPackage(
    Attachment attachment, {
    bool showControls = false,
    bool autoInitialize = true,
  })  : _showControls = showControls,
        _autoInitialize = autoInitialize,
        _videoPlayerController = attachment.localUri != null
            ? VideoPlayerController.file(
                File.fromUri(attachment.localUri!),
              )
            : VideoPlayerController.networkUrl(
                Uri.parse(attachment.assetUrl!),
              );

  final bool _showControls;
  final bool _autoInitialize;
  final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  /// Get video player for video
  VideoPlayerController get videoPlayer => _videoPlayerController;

  /// Get [ChewieController] for video
  ChewieController? get chewieController => _chewieController;

  /// Check if controller is initialised
  bool get initialized => _videoPlayerController.value.isInitialized;

  /// Initialize all things required for [VideoPackage]
  Future<void> initialize() {
    return _videoPlayerController.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: _autoInitialize,
        showControls: _showControls,
        showOptions: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
      );
    });
  }

  /// Add a listener to video player controller
  void addListener(VoidCallback listener) =>
      _videoPlayerController.addListener(listener);

  /// Remove a listener to video player controller
  void removeListener(VoidCallback listener) =>
      _videoPlayerController.removeListener(listener);

  /// Dispose controllers
  Future<void> dispose() {
    _chewieController?.dispose();
    return _videoPlayerController.dispose();
  }
}
