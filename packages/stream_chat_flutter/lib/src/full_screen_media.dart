import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/gallery_footer.dart';
import 'package:stream_chat_flutter/src/gallery_header.dart';
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

/// A full screen image widget
class FullScreenMedia extends StatefulWidget {
  /// Instantiate a new FullScreenImage
  const FullScreenMedia({
    Key? key,
    required this.mediaAttachments,
    required this.message,
    this.startIndex = 0,
    String? userName,
    this.onShowMessage,
    this.attachmentActionsModalBuilder,
  })  : userName = userName ?? '',
        super(key: key);

  /// The url of the image
  final List<Attachment> mediaAttachments;

  /// Message where attachments are attached
  final Message message;

  /// First index of media shown
  final int startIndex;

  /// Username of sender
  final String userName;

  /// Callback for when show message is tapped
  final ShowMessageCallback? onShowMessage;

  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  @override
  _FullScreenMediaState createState() => _FullScreenMediaState();
}

class _FullScreenMediaState extends State<FullScreenMedia>
    with SingleTickerProviderStateMixin {
  bool _optionsShown = true;

  late final AnimationController _controller;
  late final PageController _pageController;

  late int _currentPage;

  final videoPackages = <String, VideoPackage>{};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pageController = PageController(initialPage: widget.startIndex);
    _currentPage = widget.startIndex;
    for (final attachment in widget.mediaAttachments) {
      if (attachment.type != 'video') continue;
      final package = VideoPackage(attachment, showControls: true);
      videoPackages[attachment.id] = package;
    }
    initializePlayers();
  }

  Future<void> initializePlayers() async {
    await Future.wait(videoPackages.values.map(
      (it) => it.initialize(),
    ));
    setState(() {}); // ignore: no-empty-block
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, snapshot) => PageView.builder(
                controller: _pageController,
                onPageChanged: (val) {
                  setState(() {
                    _currentPage = val;
                  });
                },
                itemBuilder: (context, index) {
                  final attachment = widget.mediaAttachments[index];
                  if (attachment.type == 'image' ||
                      attachment.type == 'giphy') {
                    final imageUrl = attachment.imageUrl ??
                        attachment.assetUrl ??
                        attachment.thumbUrl;
                    return PhotoView(
                      loadingBuilder: (context, image) => const Offstage(),
                      imageProvider: (imageUrl == null &&
                              attachment.localUri != null &&
                              attachment.file?.bytes != null)
                          ? Image.memory(attachment.file!.bytes!).image
                          : CachedNetworkImageProvider(imageUrl!),
                      maxScale: PhotoViewComputedScale.covered,
                      minScale: PhotoViewComputedScale.contained,
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: widget.mediaAttachments,
                      ),
                      backgroundDecoration: BoxDecoration(
                        color: ColorTween(
                          begin: ChannelHeaderTheme.of(context).color,
                          end: Colors.black,
                        ).lerp(_controller.value),
                      ),
                      onTapUp: (a, b, c) {
                        setState(() {
                          _optionsShown = !_optionsShown;
                        });
                        if (_controller.isCompleted) {
                          _controller.reverse();
                        } else {
                          _controller.forward();
                        }
                      },
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
                        setState(() {
                          _optionsShown = !_optionsShown;
                        });
                        if (_controller.isCompleted) {
                          _controller.reverse();
                        } else {
                          _controller.forward();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 50,
                        ),
                        child: Chewie(
                          controller: controller.chewieController!,
                        ),
                      ),
                    );
                  }
                  return Container();
                },
                itemCount: widget.mediaAttachments.length,
              ),
            ),
            AnimatedOpacity(
              opacity: _optionsShown ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GalleryHeader(
                    userName: widget.userName,
                    sentAt: context.translations.sentAtText(
                      date: widget.message.createdAt,
                      time: widget.message.createdAt,
                    ),
                    onBackPressed: () {
                      Navigator.of(context).pop();
                    },
                    message: widget.message,
                    currentIndex: _currentPage,
                    onShowMessage: () {
                      widget.onShowMessage?.call(
                        widget.message,
                        StreamChannel.of(context).channel,
                      );
                    },
                    attachmentActionsModalBuilder:
                        widget.attachmentActionsModalBuilder,
                  ),
                  if (!widget.message.isEphemeral)
                    GalleryFooter(
                      currentPage: _currentPage,
                      totalPages: widget.mediaAttachments.length,
                      mediaAttachments: widget.mediaAttachments,
                      message: widget.message,
                      mediaSelectedCallBack: (val) {
                        setState(() {
                          _currentPage = val;
                          _pageController.animateToPage(
                            val,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          Navigator.pop(context);
                        });
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() async {
    for (final package in videoPackages.values) {
      await package.dispose();
    }
    super.dispose();
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
            ? VideoPlayerController.file(File.fromUri(attachment.localUri!))
            : VideoPlayerController.network(attachment.assetUrl!);

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
