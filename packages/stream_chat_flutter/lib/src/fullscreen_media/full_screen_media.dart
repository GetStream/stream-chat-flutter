import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_chat_flutter/platform_widget_builder/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/context_menu_items/download_menu_item.dart';
import 'package:stream_chat_flutter/src/fullscreen_media/full_screen_media_widget.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

/// A full screen image widget
class StreamFullScreenMedia extends FullScreenMediaWidget {
  /// Instantiate a new FullScreenImage
  const StreamFullScreenMedia({
    super.key,
    required this.mediaAttachmentPackages,
    this.startIndex = 0,
    String? userName,
    this.onShowMessage,
    this.attachmentActionsModalBuilder,
    this.autoplayVideos = false,
  }) : userName = userName ?? '';

  /// The url of the image
  final List<StreamAttachmentPackage> mediaAttachmentPackages;

  /// First index of media shown
  final int startIndex;

  /// Username of sender
  final String userName;

  /// Callback for when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// Widget builder for attachment actions modal
  /// [defaultActionsModal] is the default [AttachmentActionsModal] config
  /// Use [defaultActionsModal.copyWith] to easily customize it
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// Auto-play videos when page is opened
  final bool autoplayVideos;

  @override
  _FullScreenMediaState createState() => _FullScreenMediaState();
}

class _FullScreenMediaState extends State<StreamFullScreenMedia>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final PageController _pageController;

  late final _curvedAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  final _opacityTween = Tween<double>(begin: 1, end: 0);
  late final _opacityAnimation = _opacityTween.animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 0.6, curve: Curves.easeOut),
    ),
  );

  late final ValueNotifier<int> _currentPage = ValueNotifier(widget.startIndex);

  final videoPackages = <String, VideoPackage>{};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
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
    _animationController.dispose();
    _pageController.dispose();
    for (final package in videoPackages.values) {
      package.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (val) {
              _currentPage.value = val;

              if (videoPackages.isEmpty) {
                return;
              }

              final currentAttachment =
                  widget.mediaAttachmentPackages[val].attachment;

              for (final e in videoPackages.values) {
                if (e._attachment != currentAttachment) {
                  e._chewieController?.pause();
                }
              }

              if (widget.autoplayVideos && currentAttachment.type == 'video') {
                final controller = videoPackages[currentAttachment.id]!;
                controller._chewieController?.play();
              }
            },
            itemBuilder: (context, index) {
              final attachment =
                  widget.mediaAttachmentPackages[index].attachment;
              if (attachment.type == 'image' || attachment.type == 'giphy') {
                final imageUrl = attachment.imageUrl ??
                    attachment.assetUrl ??
                    attachment.thumbUrl;
                return AnimatedBuilder(
                  animation: _curvedAnimation,
                  builder: (context, child) => ContextMenuArea(
                    verticalPadding: 0,
                    builder: (_) => [
                      DownloadMenuItem(
                        attachment: attachment,
                      ),
                    ],
                    child: PhotoView(
                      loadingBuilder: (context, image) => const Offstage(),
                      imageProvider: (imageUrl == null &&
                              attachment.localUri != null &&
                              attachment.file?.bytes != null)
                          ? Image.memory(attachment.file!.bytes!).image
                          : CachedNetworkImageProvider(imageUrl!),
                      maxScale: PhotoViewComputedScale.covered,
                      minScale: PhotoViewComputedScale.contained,
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: widget.mediaAttachmentPackages,
                      ),
                      backgroundDecoration: BoxDecoration(
                        color: ColorTween(
                          begin: StreamChannelHeaderTheme.of(context).color,
                          end: Colors.black,
                        ).lerp(_curvedAnimation.value),
                      ),
                      onTapUp: (a, b, c) {
                        if (_animationController.isCompleted) {
                          _animationController.reverse();
                        } else {
                          _animationController.forward();
                        }
                      },
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
                  onTap: () {
                    if (_animationController.isCompleted) {
                      _animationController.reverse();
                    } else {
                      _animationController.forward();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 50,
                    ),
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
            itemCount: widget.mediaAttachmentPackages.length,
          ),
          FadeTransition(
            opacity: _opacityAnimation,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, value, child) {
                final _currentAttachmentPackage =
                    widget.mediaAttachmentPackages[value];
                final _currentMessage = _currentAttachmentPackage.message;
                final _currentAttachment = _currentAttachmentPackage.attachment;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamGalleryHeader(
                      userName: widget.userName,
                      sentAt: context.translations.sentAtText(
                        date: widget.mediaAttachmentPackages[_currentPage.value]
                            .message.createdAt,
                        time: widget.mediaAttachmentPackages[_currentPage.value]
                            .message.createdAt,
                      ),
                      onBackPressed: () {
                        Navigator.of(context).pop();
                      },
                      message: _currentMessage,
                      attachment: _currentAttachment,
                      onShowMessage: () {
                        widget.onShowMessage?.call(
                          _currentMessage,
                          StreamChannel.of(context).channel,
                        );
                      },
                      attachmentActionsModalBuilder:
                          widget.attachmentActionsModalBuilder,
                    ),
                    if (!_currentMessage.isEphemeral)
                      StreamGalleryFooter(
                        currentPage: value,
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
                  ],
                );
              },
            ),
          ),
          if (widget.mediaAttachmentPackages.length > 1) ...[
            if (_currentPage.value !=
                widget.mediaAttachmentPackages.length - 1) ...[
              GalleryNavigationItem(
                icon: Icons.chevron_right,
                right: 0,
                opacityAnimation: _opacityAnimation,
                currentPage: _currentPage,
                onClick: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeIn,
                  );
                  setState(() => _currentPage.value++);
                },
              ),
            ],
            if (_currentPage.value != 0) ...[
              GalleryNavigationItem(
                icon: Icons.chevron_left,
                left: 0,
                opacityAnimation: _opacityAnimation,
                currentPage: _currentPage,
                onClick: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                  );
                  setState(() => _currentPage.value--);
                },
              ),
            ],
          ],
        ],
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
    required this.onClick,
    required this.opacityAnimation,
    required this.currentPage,
    this.left,
    this.right,
  });

  /// The icon to display.
  final IconData icon;

  /// The callback to perform when the button is clicked.
  final VoidCallback onClick;

  /// The animation for showing & hiding this widget.
  final Animation<double> opacityAnimation;

  /// The value to use for .
  final ValueNotifier<int> currentPage;

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
        child: FadeTransition(
          opacity: opacityAnimation,
          child: ValueListenableBuilder<int>(
            valueListenable: currentPage,
            builder: (context, value, child) => GestureDetector(
              onTap: onClick,
              child: Icon(
                icon,
                size: 50,
              ),
            ),
            child: GestureDetector(
              onTap: onClick,
              child: Icon(
                icon,
                size: 50,
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
