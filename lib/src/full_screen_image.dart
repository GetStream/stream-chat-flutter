import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_chat_flutter/src/image_footer.dart';
import 'package:stream_chat_flutter/src/image_header.dart';

import '../stream_chat_flutter.dart';

/// A full screen image widget
class FullScreenImage extends StatefulWidget {
  /// The url of the image
  final List<String> urls;
  final Message message;

  final int startIndex;
  final String userName;
  final DateTime sentAt;

  /// Instantiate a new FullScreenImage
  const FullScreenImage({
    Key key,
    @required this.urls,
    this.message,
    this.startIndex = 0,
    this.userName = '',
    this.sentAt,
  }) : super(key: key);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage>
    with SingleTickerProviderStateMixin {
  bool _optionsShown = true;

  AnimationController _controller;
  PageController _pageController;

  int _currentPage;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _pageController = PageController(initialPage: widget.startIndex);
    _currentPage = widget.startIndex;
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
                  itemBuilder: (context, position) {
                    return PhotoView(
                      imageProvider:
                          CachedNetworkImageProvider(widget.urls[position]),
                      maxScale: PhotoViewComputedScale.covered,
                      minScale: PhotoViewComputedScale.contained,
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: widget.urls,
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
                  },
                  itemCount: widget.urls.length,
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
                  sentAt:
                      'Sent at${Jiffy(widget.sentAt.toLocal()).format('  HH:mm')}',
                  onBackPressed: () {
                    Navigator.of(context).pop();
                  },
                  message: widget.message,
                ),
                ImageFooter(
                  currentPage: _currentPage,
                  totalPages: widget.urls.length,
                  urls: widget.urls,
                  message: widget.message,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
