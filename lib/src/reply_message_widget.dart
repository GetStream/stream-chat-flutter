import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import 'attachment_error.dart';
import 'image_attachment.dart';
import 'message_text.dart';
import 'stream_chat_theme.dart';
import 'user_avatar.dart';
import 'utils.dart';

///
class ReplyMessageWidget extends StatelessWidget {
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

  final Map<String, Widget Function(Attachment attachment)> _attachmentBuilders;

  ///
  ReplyMessageWidget({
    Key key,
    @required this.message,
    @required this.messageTheme,
    this.reverse = false,
    this.showBorder = false,
    this.textLimit = 170,
  })  : _attachmentBuilders = {
          'image': (attachment) {
            return ImageAttachment(
              attachment: attachment,
              message: message,
              messageTheme: messageTheme,
              size: Size(32, 32),
            );
          },
          'video': (attachment) {
            final size = Size(32, 32);
            if (attachment.thumbUrl != null) {
              return Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      attachment.thumbUrl,
                    ),
                  ),
                ),
              );
            }
            return AttachmentError(
              attachment: attachment,
              size: size,
            );
          },
          'giphy': (attachment) {
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
              imageUrl: attachment.thumbUrl ??
                  attachment.imageUrl ??
                  attachment.assetUrl,
              errorWidget: (context, url, error) => AttachmentError(
                attachment: attachment,
                size: size,
              ),
              fit: BoxFit.cover,
            );
          },
          'file': (attachment) {
            return Container(
              height: 32,
              width: 32,
              child: getFileTypeImage(attachment.extraData['mime_type']),
            );
          },
        },
        super(key: key);

  bool get _hasAttachments => message.attachments?.isNotEmpty == true;

  bool get _containsScrapeUrl =>
      message.attachments?.any((element) => element.ogScrapeUrl != null) ==
      true;

  bool get _containsText => message?.text?.isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6, right: 4, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: _buildMessage(context)),
          SizedBox(width: 4),
          _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    final children = [
      if (_hasAttachments) ...[
        _parseAttachments(context),
        SizedBox(width: 8),
      ],
      Flexible(child: _buildTextMessage()),
    ];
    return Container(
      constraints: BoxConstraints(
        minHeight: 48.0,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: showBorder
            ? Border.all(color: Colors.black.withOpacity(0.08))
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
        mainAxisAlignment:
            reverse ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: reverse ? children.reversed.toList() : children,
      ),
    );
  }

  Widget _buildTextMessage() {
    final isOnlyEmoji =
        message.text.characters.every((c) => Emoji.byChar(c) != null);
    var msg = _hasAttachments && !_containsText
        ? message.copyWith(text: message.attachments.last?.title ?? '')
        : message;
    if (msg.text.length > textLimit) {
      msg = msg.copyWith(text: '${msg.text.substring(0, textLimit - 3)}...');
    }
    return Transform(
      transform: Matrix4.rotationY(reverse ? pi : 0),
      alignment: Alignment.center,
      child: MessageText(
        message: msg,
        messageTheme: isOnlyEmoji && _containsText
            ? messageTheme.copyWith(
                messageText: messageTheme.messageText.copyWith(
                fontSize: 24,
              ))
            : messageTheme,
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
    return AttachmentError(
      attachment: attachment,
      size: size,
    );
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
      attachment = message.attachments.last;
      final attachmentBuilder = _attachmentBuilders[attachment.type];
      if (attachmentBuilder == null) {
        child = Offstage();
      }
      child = attachmentBuilder(attachment);
    }
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      shape: attachment.type == 'file' ? null : _getDefaultShape(context),
      child: child,
    );
  }

  ShapeBorder _getDefaultShape(BuildContext context) {
    return RoundedRectangleBorder(
      side: BorderSide(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withAlpha(24)
            : Colors.black.withAlpha(24),
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildUserAvatar() {
    return Transform(
      transform: Matrix4.rotationY(reverse ? pi : 0),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: UserAvatar(
          user: message.user,
          constraints: BoxConstraints.tightFor(
            height: 24,
            width: 24,
          ),
          showOnlineStatus: false,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (_containsScrapeUrl) {
      return Color(0xFFE9F2FF);
    }
    return messageTheme.messageBackgroundColor;
  }
}
