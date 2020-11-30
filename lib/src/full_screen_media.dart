import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_chat_flutter/src/image_footer.dart';
import 'package:stream_chat_flutter/src/image_header.dart';
import 'package:video_player/video_player.dart';

import '../stream_chat_flutter.dart';

/// A full screen image widget
class FullScreenMedia extends StatefulWidget {
  /// The url of the image
  final List<Attachment> mediaAttachments;
  final Message message;

  final int startIndex;
  final String userName;
  final DateTime sentAt;

  /// Instantiate a new FullScreenImage
  const FullScreenMedia({
    Key key,
    @required this.mediaAttachments,
    this.message,
    this.startIndex = 0,
    this.userName = '',
    this.sentAt,
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

  List<VideoPackage> videoPackages = [];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _pageController = PageController(initialPage: widget.startIndex);
    _currentPage = widget.startIndex;
    widget.mediaAttachments
        .where((element) => element.type == 'video')
        .toList()
        .forEach((element) {
      videoPackages.add(VideoPackage(context, element, () {
        setState(() {});
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    var videoAttachments = widget.mediaAttachments
        .where((element) => element.type == 'video')
        .toList();

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
                  itemBuilder: (context, position) {
                    if (widget.mediaAttachments[position].type == 'image' ||
                        widget.mediaAttachments[position].type == 'giphy') {
                      return PhotoView(
                        imageProvider: CachedNetworkImageProvider(
                            widget.mediaAttachments[position].imageUrl ??
                                widget.mediaAttachments[position].assetUrl ??
                                widget.mediaAttachments[position].thumbUrl),
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
                    } else if (widget.mediaAttachments[position].type ==
                        'video') {
                      var controllerPackage = videoPackages[videoAttachments
                          .indexOf(widget.mediaAttachments[position])];

                      if (!controllerPackage.initialised) {
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
                        child: Chewie(
                          controller: controllerPackage.chewieController,
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
                ),
                ImageFooter(
                  currentPage: _currentPage,
                  totalPages: widget.mediaAttachments.length,
                  mediaAttachments: widget.mediaAttachments,
                  message: widget.message,
                  videoPackages: videoPackages,
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
      return 'on ${Jiffy(dateTime).format("MMM do")}';
    }
  }

  @override
  void dispose() {
    videoPackages.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }
}

class VideoPackage {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool initialised = false;
  VoidCallback onInit;
  BuildContext context;

  ///
  VideoPackage(this.context, Attachment attachment, this.onInit) {
    _videoPlayerController = VideoPlayerController.network(attachment.assetUrl);
    _videoPlayerController.initialize().whenComplete(() {
      initialised = true;
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
      );
      onInit();
    });

    VoidCallback errorListener;
    errorListener = () {
      if (_videoPlayerController.value.hasError) {
        Navigator.pop(context);
        launchURL(context, attachment.titleLink);
      }
      _videoPlayerController.removeListener(errorListener);
    };
    _videoPlayerController.addListener(errorListener);
  }

  get videoPlayer => _videoPlayerController;

  get chewieController => _chewieController;

  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
