import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
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
  bool _userSearchMode = false;
  TextEditingController _searchController;
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  String _channelNameQuery;

  final List<Channel> _selectedChannels = [];
  bool _loading = false;

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: StreamChatTheme.of(context).colorTheme.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0),
                  )),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Photos',
                        style:
                            StreamChatTheme.of(context).textTheme.headlineBold,
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
            ),
            Container(
              color: StreamChatTheme.of(context).colorTheme.white,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, position) {
                  Widget media;

                  if (widget.mediaAttachments[position].type == 'video') {
                    var controllerPackage = widget.videoPackages[
                        videoAttachments
                            .indexOf(widget.mediaAttachments[position])];

                    media = InkWell(
                      onTap: () {
                        widget.mediaSelectedCallBack(position);
                      },
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Chewie(
                          controller: controllerPackage.chewieController,
                        ),
                      ),
                    );
                  } else {
                    media = InkWell(
                      onTap: () {
                        widget.mediaSelectedCallBack(position);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: AspectRatio(
                          child: CachedNetworkImage(
                            imageUrl: widget
                                    .mediaAttachments[position].imageUrl ??
                                widget.mediaAttachments[position].assetUrl ??
                                widget.mediaAttachments[position].thumbUrl,
                            fit: BoxFit.cover,
                          ),
                          aspectRatio: 1.0,
                        ),
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      media,
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: UserAvatar(
                            user: widget.message.user,
                            constraints: BoxConstraints.tight(
                              Size(
                                24,
                                24,
                              ),
                            ),
                            showOnlineStatus: false,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: widget.mediaAttachments.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShareTextInputSection(modalSetState) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BottomAppBar(
        child: Container(
          height: 40.0,
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          child: _loading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        onChanged: (val) {
                          modalSetState(() {});
                        },
                        onTap: () {
                          modalSetState(() {});
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixText: '     ',
                          hintText: 'Add a comment',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide(
                              color: StreamChatTheme.of(context)
                                  .colorTheme
                                  .black
                                  .withOpacity(0.16),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                color: StreamChatTheme.of(context)
                                    .colorTheme
                                    .black
                                    .withOpacity(0.16),
                              )),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconTheme(
                      data: StreamChatTheme.of(context)
                          .channelTheme
                          .messageInputButtonIconTheme,
                      child: IconButton(
                        onPressed: () async {
                          modalSetState(() => _loading = true);
                          await sendMessage();
                          modalSetState(() => _loading = false);
                        },
                        splashRadius: 24,
                        visualDensity: VisualDensity.compact,
                        constraints: BoxConstraints.tightFor(
                          height: 24,
                          width: 24,
                        ),
                        padding: EdgeInsets.zero,
                        icon: Transform.rotate(
                          angle: -pi / 2,
                          child: StreamSvgIcon.Icon_send_message(
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .accentBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
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

  Future<void> _saveImage(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "${DateTime.now().millisecondsSinceEpoch}");
    return result;
  }

  Future<void> _saveVideo(String url) async {
    var appDocDir = await getTemporaryDirectory();
    var savePath =
        appDocDir.path + "/${DateTime.now().millisecondsSinceEpoch}.mp4";
    await Dio().download(url, savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);
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
