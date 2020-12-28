import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ImageFooter extends StatefulWidget {
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
  TextEditingController _messageController = TextEditingController();
  FocusNode _messageFocusNode = FocusNode();

  String _channelNameQuery;

  List<Channel> _selectedChannels = [];
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
    return SafeArea(
      child: Container(
        color:
            StreamChatTheme.of(context).channelTheme.channelHeaderTheme.color,
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: StreamSvgIcon.icon_SHARE(
                size: 24.0,
                color: Colors.black,
              ),
              onPressed: () {
                _buildShareModal(context);
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
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: StreamSvgIcon.Icon_grid(
                color: Colors.black,
              ),
              onPressed: () {
                _buildPhotosModal(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosModal(context) {
    var videoAttachments = widget.mediaAttachments
        .where((element) => element.type == 'video')
        .toList();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
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
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: StreamSvgIcon.close(
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, position) {
                  if (widget.mediaAttachments[position].type == 'video') {
                    var controllerPackage = widget.videoPackages[
                        videoAttachments
                            .indexOf(widget.mediaAttachments[position])];

                    return InkWell(
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
                    return InkWell(
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

  void _buildShareModal(context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, modalSetState) {
          modalSetStateCallback = modalSetState;
          return Padding(
            padding: EdgeInsets.only(
                top: _userSearchMode || _messageFocusNode.hasFocus
                    ? 16.0
                    : MediaQuery.of(context).size.height / 2,
                left: 8.0,
                right: 8.0),
            child: Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Scaffold(
                body: UsersBloc(
                  child: Column(
                    children: [
                      _buildTextInputSection(modalSetState),
                      if (_userSearchMode)
                        SizedBox(
                          height: 22.0,
                        ),
                      Expanded(
                        child: ChannelsBloc(
                          child: ChannelListView(
                            selectedChannels: _selectedChannels,
                            onChannelTap: (channel, _) {
                              _searchController.clear();
                              if (!_selectedChannels.contains(channel)) {
                                modalSetState(() {
                                  _selectedChannels.add(channel);
                                });
                              } else {
                                modalSetState(() {
                                  _selectedChannels.remove(channel);
                                });
                              }
                            },
                            crossAxisCount: 4,
                            pagination: PaginationParams(
                              limit: 25,
                            ),
                            filter: {
                              if (_searchController.text.isNotEmpty)
                                'name': {
                                  r'$autocomplete': _channelNameQuery,
                                },
                              'id': {
                                r'$ne': StreamChat.of(context).user.id,
                              },
                            },
                            sort: [
                              SortOption(
                                'name',
                                direction: 1,
                              ),
                            ],
                            emptyBuilder: (_) {
                              return LayoutBuilder(
                                builder: (context, viewportConstraints) {
                                  return SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight:
                                            viewportConstraints.maxHeight,
                                      ),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(24),
                                              child: StreamSvgIcon.search(
                                                size: 96,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                                'No chat matches these keywords...'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      if (_selectedChannels.isNotEmpty)
                        _buildShareTextInputSection(modalSetState),
                      if (!_userSearchMode && _selectedChannels.isEmpty)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.white,
                            height: 48.0,
                            child: Material(
                              child: InkWell(
                                onTap: () async {
                                  var url = widget
                                          .mediaAttachments[widget.currentPage]
                                          .imageUrl ??
                                      widget
                                          .mediaAttachments[widget.currentPage]
                                          .assetUrl ??
                                      widget
                                          .mediaAttachments[widget.currentPage]
                                          .thumbUrl;

                                  if (widget
                                          .mediaAttachments[widget.currentPage]
                                          .type ==
                                      'video') {
                                    await _saveVideo(url);
                                    Navigator.pop(context);
                                  } else {
                                    await _saveImage(url);
                                    Navigator.pop(context);
                                  }
                                },
                                child: SizedBox.expand(
                                  child: Center(
                                    child: Text(
                                      'Save to Photos',
                                      style: TextStyle(
                                        color: StreamChatTheme.of(context)
                                            .accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildTextInputSection(modalSetState) {
    if (_userSearchMode) {
      return Column(
        children: [
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  cursorColor: Colors.black,
                  autofocus: true,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIconConstraints:
                        BoxConstraints.tight(Size(36.0, 44.0)),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 6.0),
                      child: StreamSvgIcon.search(
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.08)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.08)),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              IconButton(
                icon: StreamSvgIcon.close_small(
                  color: Colors.black.withOpacity(0.5),
                ),
                onPressed: () {
                  modalSetState(() {
                    _userSearchMode = false;
                  });
                  setState(() {});
                },
              )
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: IconButton(
              icon: StreamSvgIcon.search(
                color: Colors.black,
              ),
              iconSize: 24.0,
              onPressed: () {
                modalSetState(() {
                  _userSearchMode = true;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select a Chat to Share',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: IconButton(
              icon: StreamSvgIcon.share_arrow(
                color: Colors.black,
              ),
              onPressed: () async {
                var url =
                    widget.mediaAttachments[widget.currentPage].imageUrl ??
                        widget.mediaAttachments[widget.currentPage].assetUrl ??
                        widget.mediaAttachments[widget.currentPage].thumbUrl;
                var type =
                    widget.mediaAttachments[widget.currentPage].type == 'image'
                        ? 'jpg'
                        : url?.split('?')?.first?.split('.')?.last ?? 'jpg';
                var request = await HttpClient().getUrl(Uri.parse(url));
                var response = await request.close();
                var bytes = await consolidateHttpClientResponseBytes(response);
                await Share.file('File', 'image.$type', bytes, 'image/$type');
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildShareTextInputSection(modalSetState) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        height: 56.0,
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
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
                          isDense: true,
                          prefixText: '     ',
                          hintText: 'Add a comment',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.16),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.16),
                              )),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        ),
                      ),
                    ),
                  ),
                  IconTheme(
                    data: StreamChatTheme.of(context)
                        .channelTheme
                        .messageInputButtonIconTheme,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            modalSetState(() {
                              _loading = true;
                            });
                            await sendMessage();
                            modalSetState(() {
                              _loading = false;
                            });
                          },
                          child: Transform.rotate(
                            angle: -pi / 2,
                            child: StreamSvgIcon.Icon_send_message(
                              color: StreamChatTheme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
