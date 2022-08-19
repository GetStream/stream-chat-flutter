import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

/// Return action for coming back from pages
enum ReturnActionType {
  /// No return action
  none,

  /// Go to reply message action
  reply,
}

/// Callback when show message is tapped
typedef ShowMessageCallback = void Function(Message message, Channel channel);

/// {@macro full_screen_media}
@Deprecated("Use 'StreamFullScreenMedia' instead")
typedef FullScreenMedia = StreamFullScreenMedia;

/// {@template full_screen_media}
/// A full screen image widget
/// {@endtemplate}
class StreamFullScreenMedia extends StatefulWidget {
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
  _StreamFullScreenMediaState createState() => _StreamFullScreenMediaState();
}

class _StreamFullScreenMediaState extends State<StreamFullScreenMedia> {
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
  Widget build(BuildContext context) => Scaffold(
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
                Positioned.fill(child: child!),
                ValueListenableBuilder<bool>(
                  valueListenable: _isDisplayingDetail,
                  builder: (context, isDisplayingDetail, child) {
                    final mediaQuery = MediaQuery.of(context);
                    final topPadding = mediaQuery.padding.top;
                    return AnimatedPositionedDirectional(
                      duration: kThemeAnimationDuration,
                      curve: Curves.easeInOut,
                      top: isDisplayingDetail
                          ? 0
                          : -(topPadding + kToolbarHeight),
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
                        onShowMessage: () {
                          widget.onShowMessage?.call(
                            _currentMessage,
                            StreamChannel.of(context).channel,
                          );
                        },
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
                          mediaAttachmentPackages:
                              widget.mediaAttachmentPackages,
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
              ],
            );
          },
          child: InkWell(
            onTap: switchDisplayingDetail,
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
                      child: Chewie(
                        controller: controller.chewieController!,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      );

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
  Future<void> initialize() => _videoPlayerController.initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoInitialize: _autoInitialize,
          showControls: _showControls,
          aspectRatio: _videoPlayerController.value.aspectRatio,
        );
      });

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
