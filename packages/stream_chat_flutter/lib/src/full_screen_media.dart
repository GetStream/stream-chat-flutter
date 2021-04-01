import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_chat_flutter/src/image_footer.dart';
import 'package:stream_chat_flutter/src/image_header.dart';
import 'package:video_player/video_player.dart';

import '../stream_chat_flutter.dart';

enum ReturnActionType { none, reply }

typedef ShowMessageCallback = void Function(Message message, Channel channel);

/// A full screen image widget
class FullScreenMedia extends StatefulWidget {
  /// The url of the image
  final List<Attachment> mediaAttachments;
  final Message message;

  final int startIndex;
  final String userName;
  final DateTime sentAt;
  final ShowMessageCallback onShowMessage;

  /// Instantiate a new FullScreenImage
  const FullScreenMedia({
    Key key,
    @required this.mediaAttachments,
    this.message,
    this.startIndex = 0,
    this.userName = '',
    this.sentAt,
    this.onShowMessage,
  }) : super(key: key);

  @override
  _FullScreenMediaState createState() => _FullScreenMediaState();
}

class _FullScreenMediaState extends State<FullScreenMedia>
    with SingleTickerProviderStateMixin {
  bool _optionsShown = true;

  AnimationController _controller;
  PageController _pageController;

  int _currentPage;

  final videoPackages = <String, VideoPackage>{};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AnimatedBuilder(
              animation: _controller,
              builder: (context, snapshot) {
                return PageView.builder(
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
                        imageProvider:
                            imageUrl == null && attachment.localUri != null
                                ? Image.memory(attachment.file.bytes).image
                                : CachedNetworkImageProvider(imageUrl),
                        maxScale: PhotoViewComputedScale.covered,
                        minScale: PhotoViewComputedScale.contained,
                        heroAttributes: PhotoViewHeroAttributes(
                          tag: widget.mediaAttachments,
                        ),
                        backgroundDecoration: BoxDecoration(
                          color: ColorTween(
                                  begin: StreamChatTheme.of(context)
                                      .channelTheme
                                      .channelHeaderTheme
                                      .color,
                                  end: Colors.black)
                              .lerp(_controller.value),
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
                      final controller = videoPackages[attachment.id];
                      if (!controller.initialized) {
                        return Center(
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
                            vertical: 50.0,
                          ),
                          child: Chewie(
                            controller: controller.chewieController,
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                  itemCount: widget.mediaAttachments.length,
                );
              }),
          AnimatedOpacity(
            opacity: _optionsShown ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageHeader(
                  userName: widget.userName,
                  sentAt: widget.message.createdAt == null
                      ? ''
                      : 'Sent ${getDay(widget.message.createdAt)} at ${Jiffy(widget.sentAt.toLocal()).format('HH:mm')}',
                  onBackPressed: () {
                    Navigator.of(context).pop();
                  },
                  message: widget.message,
                  urls: widget.mediaAttachments,
                  currentIndex: _currentPage,
                  onShowMessage: () {
                    widget.onShowMessage(
                        widget.message, StreamChannel.of(context).channel);
                  },
                ),
                if (widget.message.type != 'ephemeral')
                  ImageFooter(
                    currentPage: _currentPage,
                    totalPages: widget.mediaAttachments.length,
                    mediaAttachments: widget.mediaAttachments,
                    message: widget.message,
                    mediaSelectedCallBack: (val) {
                      setState(() {
                        _currentPage = val;
                        _pageController.animateToPage(val,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
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
  }

  String getDay(DateTime dateTime) {
    var now = DateTime.now();

    if (DateTime(dateTime.year, dateTime.month, dateTime.day) ==
        DateTime(now.year, now.month, now.day)) {
      return 'today';
    } else if (DateTime(now.year, now.month, now.day)
            .difference(dateTime)
            .inHours <
        24) {
      return 'yesterday';
    } else {
      return 'on ${Jiffy(dateTime).MMMd}';
    }
  }

  @override
  void dispose() async {
    for (final package in videoPackages.values) {
      await package.dispose();
    }
    super.dispose();
  }
}

class VideoPackage {
  final bool _showControls;
  final bool _autoInitialize;
  final VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  VideoPlayerController get videoPlayer => _videoPlayerController;

  ChewieController get chewieController => _chewieController;

  bool get initialized => _videoPlayerController.value.isInitialized;

  VideoPackage(
    Attachment attachment, {
    bool showControls = false,
    bool autoInitialize = true,
  })  : assert(attachment != null),
        _showControls = showControls,
        _autoInitialize = autoInitialize,
        _videoPlayerController = attachment.localUri != null
            ? VideoPlayerController.file(File.fromUri(attachment.localUri))
            : VideoPlayerController.network(attachment.assetUrl);

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

  void addListener(VoidCallback listener) {
    return _videoPlayerController.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    return _videoPlayerController.removeListener(listener);
  }

  Future<void> dispose() {
    _chewieController?.dispose();
    return _videoPlayerController?.dispose();
  }
}
