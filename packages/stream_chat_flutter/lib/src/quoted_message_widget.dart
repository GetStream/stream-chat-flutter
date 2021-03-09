import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:video_player/video_player.dart';

import 'attachment/attachment.dart';
import 'extension.dart';
import 'message_text.dart';
import 'stream_chat_theme.dart';
import 'user_avatar.dart';
import 'utils.dart';

typedef QuotedMessageAttachmentThumbnailBuilder = Widget Function(
  BuildContext,
  Attachment,
);

class _VideoAttachmentThumbnail extends StatefulWidget {
  final Size size;
  final Attachment attachment;

  const _VideoAttachmentThumbnail({
    Key key,
    @required this.attachment,
    this.size = const Size(32, 32),
  }) : super(key: key);

  @override
  _VideoAttachmentThumbnailState createState() =>
      _VideoAttachmentThumbnailState();
}

class _VideoAttachmentThumbnailState extends State<_VideoAttachmentThumbnail> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.attachment.assetUrl)
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.size.height,
        width: widget.size.width,
        child: _controller.value.isInitialized
            ? VideoPlayer(_controller)
            : CircularProgressIndicator());
  }
}

///
class QuotedMessageWidget extends StatelessWidget {
  /// The message
  final Message message;

  /// The message theme
  final MessageTheme messageTheme;

  /// If true the widget will be mirrored
  final bool reverse;

  /// If true the message will show a grey border
  final bool showBorder;

  /// limit of the text message shown
  final int textLimit;

  /// Map that defines a thumbnail builder for an attachment type
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>
      attachmentThumbnailBuilders;

  final EdgeInsetsGeometry padding;

  final GestureTapCallback onTap;

  ///
  QuotedMessageWidget({
    Key key,
    @required this.message,
    @required this.messageTheme,
    this.reverse = false,
    this.showBorder = false,
    this.textLimit = 170,
    this.attachmentThumbnailBuilders,
    this.padding = const EdgeInsets.all(8),
    this.onTap,
  }) : super(key: key);

  bool get _hasAttachments => message.attachments?.isNotEmpty == true;

  bool get _containsScrapeUrl =>
      message.attachments?.any((element) => element.ogScrapeUrl != null) ==
      true;

  bool get _containsText => message?.text?.isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: _buildMessage(context)),
            SizedBox(width: 8),
            _buildUserAvatar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    final isOnlyEmoji = message.text.isOnlyEmoji;
    var msg = _hasAttachments && !_containsText
        ? message.copyWith(text: message.attachments.last?.title ?? '')
        : message;
    if (msg.text.length > textLimit) {
      msg = msg.copyWith(text: '${msg.text.substring(0, textLimit - 3)}...');
    }

    final children = [
      if (_hasAttachments) _parseAttachments(context),
      if (msg.text.isNotEmpty)
        Flexible(
          child: Transform(
            transform: Matrix4.rotationY(reverse ? pi : 0),
            alignment: Alignment.center,
            child: MessageText(
              message: msg,
              messageTheme: isOnlyEmoji && _containsText
                  ? messageTheme.copyWith(
                      messageText: messageTheme.messageText.copyWith(
                      fontSize: 32,
                    ))
                  : messageTheme.copyWith(
                      messageText: messageTheme.messageText.copyWith(
                      fontSize: 12,
                    )),
            ),
          ),
        ),
    ].insertBetween(const SizedBox(width: 8));

    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        border: showBorder
            ? Border.all(
                color: StreamChatTheme.of(context).colorTheme.greyGainsboro,
              )
            : null,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            reverse ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: reverse ? children.reversed.toList() : children,
      ),
    );
  }

  Widget _buildUrlAttachment(Attachment attachment) {
    final size = Size(32, 32);
    if (attachment.thumbUrl != null) {
      return Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              attachment.imageUrl,
            ),
          ),
        ),
      );
    }
    return AttachmentError(size: size);
  }

  Widget _parseAttachments(BuildContext context) {
    Widget child;
    Attachment attachment;
    if (_containsScrapeUrl) {
      attachment = message.attachments.firstWhere(
        (element) => element.ogScrapeUrl != null,
      );
      child = _buildUrlAttachment(attachment);
    } else {
      QuotedMessageAttachmentThumbnailBuilder attachmentBuilder;
      attachment = message.attachments.last;
      if (attachmentThumbnailBuilders?.containsKey(attachment?.type) == true) {
        attachmentBuilder = attachmentThumbnailBuilders[attachment?.type];
      }
      attachmentBuilder = _defaultAttachmentBuilder[attachment?.type];
      if (attachmentBuilder == null) {
        child = Offstage();
      }
      child = attachmentBuilder(context, attachment);
    }
    child = AbsorbPointer(child: child);
    return Transform(
      transform: Matrix4.rotationY(reverse ? pi : 0),
      alignment: Alignment.center,
      child: Material(
        clipBehavior: Clip.antiAlias,
        type: MaterialType.transparency,
        shape: attachment.type == 'file' ? null : _getDefaultShape(context),
        child: child,
      ),
    );
  }

  ShapeBorder _getDefaultShape(BuildContext context) {
    return RoundedRectangleBorder(
      side: BorderSide(width: 0.0, color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildUserAvatar() {
    return Transform(
      transform: Matrix4.rotationY(reverse ? pi : 0),
      alignment: Alignment.center,
      child: UserAvatar(
        user: message.user,
        constraints: BoxConstraints.tightFor(
          height: 24,
          width: 24,
        ),
        showOnlineStatus: false,
      ),
    );
  }

  Map<String, QuotedMessageAttachmentThumbnailBuilder>
      get _defaultAttachmentBuilder {
    return {
      'image': (_, attachment) {
        return ImageAttachment(
          attachment: attachment,
          message: message,
          messageTheme: messageTheme,
          size: Size(32, 32),
        );
      },
      'video': (_, attachment) {
        return _VideoAttachmentThumbnail(
          key: ValueKey(attachment.assetUrl),
          attachment: attachment,
        );
      },
      'giphy': (_, attachment) {
        final size = Size(32, 32);
        return CachedNetworkImage(
          height: size?.height,
          width: size?.width,
          placeholder: (_, __) {
            return Container(
              width: size?.width,
              height: size?.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          imageUrl:
              attachment.thumbUrl ?? attachment.imageUrl ?? attachment.assetUrl,
          errorWidget: (context, url, error) {
            return AttachmentError(size: size);
          },
          fit: BoxFit.cover,
        );
      },
      'file': (_, attachment) {
        return Container(
          height: 32,
          width: 32,
          child: getFileTypeImage(attachment.extraData['mime_type']),
        );
      },
    };
  }

  Color _getBackgroundColor(BuildContext context) {
    if (_containsScrapeUrl) {
      return StreamChatTheme.of(context).colorTheme.blueAlice;
    }
    return messageTheme.messageBackgroundColor;
  }
}
