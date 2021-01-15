import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ImageFooter extends StatefulWidget implements PreferredSizeWidget {
  /// Callback to call when pressing the back button.
  /// By default it calls [Navigator.pop]
  final VoidCallback onBackPressed;

  /// Callback to call when the header is tapped.
  final VoidCallback onTitleTap;

  /// Callback to call when the image is tapped.
  final VoidCallback onImageTap;

  final int currentPage;
  final int totalPages;

  final List<Attachment> mediaAttachments;
  final Message message;

  final List<VideoPackage> videoPackages;
  final ValueChanged<int> mediaSelectedCallBack;

  /// Creates a channel header
  ImageFooter({
    Key key,
    this.onBackPressed,
    this.onTitleTap,
    this.onImageTap,
    this.currentPage = 0,
    this.totalPages = 0,
    this.mediaAttachments,
    this.message,
    this.videoPackages,
    this.mediaSelectedCallBack,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  _ImageFooterState createState() => _ImageFooterState();

  @override
  final Size preferredSize;
}

class _ImageFooterState extends State<ImageFooter> {
  //ignore:unused_field
  bool _userSearchMode = false;
  TextEditingController _searchController;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  //ignore:unused_field
  String _channelNameQuery;

  final List<Channel> _selectedChannels = [];

  Timer _debounce;

  Function modalSetStateCallback;

  void _userNameListener() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted && modalSetStateCallback != null) {
        modalSetStateCallback(() {
          _channelNameQuery = _searchController.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_userNameListener);
    _messageFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController?.clear();
    _searchController?.removeListener(_userNameListener);
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).padding.bottom + widget.preferredSize.height,
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BottomAppBar(
          color: StreamChatTheme.of(context).colorTheme.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: StreamSvgIcon.Icon_SHARE(
                  size: 24.0,
                  color: StreamChatTheme.of(context).colorTheme.black,
                ),
                onPressed: () async {
                  final attachment =
                      widget.mediaAttachments[widget.currentPage];
                  var url = attachment.imageUrl ??
                      attachment.assetUrl ??
                      attachment.thumbUrl;
                  var type = attachment.type == 'image'
                      ? 'jpg'
                      : url?.split('?')?.first?.split('.')?.last ?? 'jpg';
                  var request = await HttpClient().getUrl(Uri.parse(url));
                  var response = await request.close();
                  var bytes =
                      await consolidateHttpClientResponseBytes(response);
                  await Share.file('File', 'image.$type', bytes, 'image/$type');
                },
              ),
              InkWell(
                onTap: widget.onTitleTap,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${widget.currentPage + 1} of ${widget.totalPages}',
                        style:
                            StreamChatTheme.of(context).textTheme.headlineBold,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: StreamSvgIcon.Icon_grid(
                  color: StreamChatTheme.of(context).colorTheme.black,
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
    var videoAttachments = widget.mediaAttachments
        .where((element) => element.type == 'video')
        .toList();

    showModalBottomSheet(
      context: context,
      barrierColor: StreamChatTheme.of(context).colorTheme.overlay,
      backgroundColor: StreamChatTheme.of(context).colorTheme.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: const Radius.circular(16.0),
          topRight: const Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        final crossAxisCount = 3;
        final noOfRowToShowInitially =
            widget.mediaAttachments.length > crossAxisCount ? 2 : 1;
        final size = MediaQuery.of(context).size;
        final initialChildSize =
            48 + (size.width * noOfRowToShowInitially) / crossAxisCount;
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: initialChildSize / size.height,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Photos',
                            style: StreamChatTheme.of(context)
                                .textTheme
                                .headlineBold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: StreamSvgIcon.close(
                            color: StreamChatTheme.of(context).colorTheme.black,
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                      itemBuilder: (context, index) {
                        Widget media;
                        final attachment = widget.mediaAttachments[index];

                        if (attachment.type == 'video') {
                          var controllerPackage = widget.videoPackages[
                              videoAttachments.indexOf(attachment)];

                          media = InkWell(
                            onTap: () => widget.mediaSelectedCallBack(index),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Chewie(
                                controller: controllerPackage.chewieController,
                              ),
                            ),
                          );
                        } else {
                          media = InkWell(
                            onTap: () => widget.mediaSelectedCallBack(index),
                            child: AspectRatio(
                              child: CachedNetworkImage(
                                imageUrl: attachment.imageUrl ??
                                    attachment.assetUrl ??
                                    attachment.thumbUrl,
                                fit: BoxFit.cover,
                              ),
                              aspectRatio: 1.0,
                            ),
                          );
                        }

                        return Stack(
                          children: [
                            media,
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .white
                                      .withOpacity(0.6),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 8.0,
                                      color: StreamChatTheme.of(context)
                                          .colorTheme
                                          .black
                                          .withOpacity(0.3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(1),
                                child: UserAvatar(
                                  user: widget.message.user,
                                  constraints:
                                      BoxConstraints.tight(Size(24, 24)),
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
            );
          },
        );
      },
    );
  }

  /// Sends the current message
  Future sendMessage() async {
    var text = _messageController.text.trim();

    final attachments = widget.message.attachments;

    _messageController.clear();

    for (var channel in _selectedChannels) {
      final message = Message(
        text: text,
        attachments: [attachments[widget.currentPage]],
      );

      await channel.sendMessage(message);
    }

    _selectedChannels.clear();
    Navigator.pop(context);
  }
}

/// Used for clipping textfield prefix icon
class IconClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var leftX = size.width / 5;
    var rightX = 4 * size.width / 5;
    var topY = size.height / 5;
    var bottomY = 4 * size.height / 5;

    final path = Path();
    path.moveTo(leftX, topY);
    path.lineTo(leftX, bottomY);
    path.lineTo(rightX, bottomY);
    path.lineTo(rightX, topY);
    path.lineTo(leftX, topY);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
