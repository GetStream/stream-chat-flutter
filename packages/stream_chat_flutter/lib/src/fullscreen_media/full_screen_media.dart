import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/platform_widget_builder/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/context_menu_items/download_menu_item.dart';
import 'package:stream_chat_flutter/src/fullscreen_media/full_screen_media_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

/// A full screen image widget
class StreamFullScreenMedia extends FullScreenMediaWidget {
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

  final videoPackages = <String, VideoPackage>{};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.startIndex);
    for (var i = 0; i < widget.mediaAttachmentPackages.length; i++) {
      final attachment = widget.mediaAttachmentPackages[i].attachment;
      if (attachment.type != 'video') continue;
      final package = VideoPackage(attachment, showControls: true);
      videoPackages[attachment.id] = package;
    }
    initializePlayers();
  }

  Future<void> initializePlayers() async {
    if (videoPackages.isEmpty) {
      return;
    }

    final currentAttachment =
        widget.mediaAttachmentPackages[widget.startIndex].attachment;

    await Future.wait(videoPackages.values.map(
      (it) => it.initialize(),
    ));

    if (widget.autoplayVideos && currentAttachment.type == 'video') {
      final package = videoPackages.values
          .firstWhere((e) => e._attachment == currentAttachment);
      package._chewieController?.play();
    }
    setState(() {}); // ignore: no-empty-block
  }

  @override
  void dispose() {
    _currentPage.dispose();
    _pageController.dispose();
    _isDisplayingDetail.dispose();
    for (final package in videoPackages.values) {
      package.dispose();
    }
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
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.mediaAttachmentPackages.length,
              onPageChanged: (val) {
                _currentPage.value = val;
                if (videoPackages.isEmpty) return;
                final currentAttachment =
                    widget.mediaAttachmentPackages[val].attachment;
                for (final e in videoPackages.values) {
                  if (e._attachment != currentAttachment) {
                    e._chewieController?.pause();
                  }
                }
                if (widget.autoplayVideos &&
                    currentAttachment.type == 'video') {
                  final controller = videoPackages[currentAttachment.id]!;
                  controller._chewieController?.play();
                }
              },
              itemBuilder: (context, index) {
                final currentAttachmentPackage =
                    widget.mediaAttachmentPackages[index];
                final attachment = currentAttachmentPackage.attachment;
                if (attachment.type == 'image' || attachment.type == 'giphy') {
                  final imageUrl = attachment.imageUrl ??
                      attachment.assetUrl ??
                      attachment.thumbUrl;
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isDisplayingDetail,
                    builder: (context, isDisplayingDetail, _) =>
                        AnimatedContainer(
                      color: isDisplayingDetail
                          ? StreamChannelHeaderTheme.of(context).color
                          : Colors.black,
                      duration: kThemeAnimationDuration,
                      child: ContextMenuArea(
                        verticalPadding: 0,
                        builder: (_) => [
                          DownloadMenuItem(
                            attachment: attachment,
                          ),
                        ],
                        child: PhotoView(
                          imageProvider: (imageUrl == null &&
                                  attachment.localUri != null &&
                                  attachment.file?.bytes != null)
                              ? Image.memory(attachment.file!.bytes!).image
                              : CachedNetworkImageProvider(imageUrl!),
                          errorBuilder: (_, __, ___) => const AttachmentError(),
                          loadingBuilder: (context, _) {
                            final image = Image.asset(
                              'images/placeholder.png',
                              fit: BoxFit.cover,
                              package: 'stream_chat_flutter',
                            );
                            final colorTheme =
                                StreamChatTheme.of(context).colorTheme;
                            return Shimmer.fromColors(
                              baseColor: colorTheme.disabled,
                              highlightColor: colorTheme.inputBg,
                              child: image,
                            );
                          },
                          maxScale: PhotoViewComputedScale.covered,
                          minScale: PhotoViewComputedScale.contained,
                          heroAttributes: PhotoViewHeroAttributes(
                            tag: widget.mediaAttachmentPackages,
                          ),
                          backgroundDecoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (attachment.type == 'video') {
                  final controller = videoPackages[attachment.id]!;
                  if (!controller.initialized) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return InkWell(
                    onTap: switchDisplayingDetail,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: ContextMenuArea(
                        verticalPadding: 0,
                        builder: (_) => [
                          DownloadMenuItem(
                            attachment: attachment,
                          ),
                        ],
                        child: Chewie(
                          controller: controller.chewieController!,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget for desktop and web users to be able to navigate left and right
/// through a gallery of images.
class GalleryNavigationItem extends StatelessWidget {
  /// Builds a [GalleryNavigationItem].
  const GalleryNavigationItem({
    super.key,
    required this.icon,
    this.iconSize = 48,
    required this.onPressed,
    required this.opacityAnimation,
    this.left,
    this.right,
  });

  /// The icon to display.
  final Widget icon;

  /// The size of the icon.
  ///
  /// Defaults to 48.
  final double iconSize;

  /// The callback to perform when the button is clicked.
  final VoidCallback onPressed;

  /// The animation for showing & hiding this widget.
  final ValueListenable<bool> opacityAnimation;

  /// The left-hand placement of the button.
  final double? left;

  /// The right-hand placement of the button.
  final double? right;

  @override
  Widget build(BuildContext context) {
    return PlatformWidgetBuilder(
      desktop: (_, child) => child,
      web: (_, child) => child,
      child: Positioned(
        left: left,
        right: right,
        top: MediaQuery.of(context).size.height / 2,
        child: ValueListenableBuilder<bool>(
          valueListenable: opacityAnimation,
          builder: (context, shouldShow, child) {
            return AnimatedOpacity(
              opacity: shouldShow ? 1 : 0,
              duration: kThemeAnimationDuration,
              child: child,
            );
          },
          child: Material(
            color: Colors.transparent,
            type: MaterialType.circle,
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              icon: icon,
              iconSize: iconSize,
              onPressed: onPressed,
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
    this._attachment, {
    bool showControls = false,
    bool autoInitialize = true,
  })  : _showControls = showControls,
        _autoInitialize = autoInitialize,
        _videoPlayerController = _attachment.localUri != null
            ? VideoPlayerController.file(File.fromUri(_attachment.localUri!))
            : VideoPlayerController.network(_attachment.assetUrl!);

  final Attachment _attachment;
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
