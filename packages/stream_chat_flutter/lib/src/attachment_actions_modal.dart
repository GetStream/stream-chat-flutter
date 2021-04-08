import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import '../stream_chat_flutter.dart';
import 'extension.dart';

/// Callback to download an attachment asset
typedef AttachmentDownloader = Future<String> Function(
  Attachment attachment, {
  ProgressCallback progressCallback,
});

/// Widget that shows the options in the gallery view
class AttachmentActionsModal extends StatelessWidget {
  /// The message containing the attachments
  final Message message;

  /// Current page index
  final currentIndex;

  /// Callback to show the message
  final VoidCallback onShowMessage;

  /// Callback to download images
  final AttachmentDownloader imageDownloader;

  /// Callback to provide download files
  final AttachmentDownloader fileDownloader;

  /// Returns a new [AttachmentActionsModal]
  const AttachmentActionsModal({
    @required this.currentIndex,
    this.message,
    this.onShowMessage,
    this.imageDownloader,
    this.fileDownloader,
  }) : assert(currentIndex != null, 'currentIndex cannot be null');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.maybePop(context),
      child: _buildPage(context),
    );
  }

  Widget _buildPage(context) {
    final theme = StreamChatTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: kToolbarHeight),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildButton(
                    context,
                    'Reply',
                    StreamSvgIcon.iconCurveLineLeftUp(
                      size: 24.0,
                      color: theme.colorTheme.grey,
                    ),
                    () {
                      Navigator.pop(context, ReturnActionType.reply);
                    },
                  ),
                  _buildButton(
                    context,
                    'Show in Chat',
                    StreamSvgIcon.eye(
                      size: 24.0,
                      color: theme.colorTheme.black,
                    ),
                    onShowMessage,
                  ),
                  _buildButton(
                    context,
                    'Save ${message.attachments[currentIndex].type == 'video' ? 'Video' : 'Image'}',
                    StreamSvgIcon.iconSave(
                      size: 24.0,
                      color: theme.colorTheme.grey,
                    ),
                    () {
                      final attachment = message.attachments[currentIndex];
                      final isImage = attachment.type == 'image';
                      final saveFile = fileDownloader ?? _downloadAttachment;
                      final saveImage = imageDownloader ?? _downloadAttachment;
                      final downloader = isImage ? saveImage : saveFile;

                      final progressNotifier = ValueNotifier<_DownloadProgress>(
                        _DownloadProgress.initial(),
                      );

                      downloader(
                        attachment,
                        progressCallback: (received, total) {
                          progressNotifier.value = _DownloadProgress(
                            total,
                            received,
                          );
                        },
                      ).catchError((_) {
                        progressNotifier.value = null;
                      });

                      // Closing attachment actions modal before opening
                      // attachment download dialog
                      Navigator.pop(context);

                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        barrierColor: theme.colorTheme.overlay,
                        builder: (context) => _buildDownloadProgressDialog(
                          context,
                          progressNotifier,
                        ),
                      );
                    },
                  ),
                  if (StreamChat.of(context).user.id == message.user.id)
                    _buildButton(
                      context,
                      'Delete',
                      StreamSvgIcon.delete(
                        size: 24.0,
                        color: theme.colorTheme.accentRed,
                      ),
                      () {
                        final channel = StreamChannel.of(context).channel;
                        if (message.attachments.length > 1 ||
                            message.text?.isNotEmpty == true) {
                          final remainingAttachments = [...message.attachments]
                            ..removeAt(currentIndex);
                          channel.updateMessage(message.copyWith(
                            attachments: remainingAttachments,
                          ));
                          Navigator.of(context)
                            ..pop()
                            ..maybePop();
                        } else {
                          channel.deleteMessage(message);
                          Navigator.of(context)
                            ..pop()
                            ..maybePop();
                        }
                      },
                      color: theme.colorTheme.accentRed,
                    ),
                ]
                    .map<Widget>((e) =>
                        Align(alignment: Alignment.centerRight, child: e))
                    .insertBetween(
                      Container(
                        height: 1,
                        color: theme.colorTheme.greyWhisper,
                      ),
                    ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildButton(
    context,
    String title,
    StreamSvgIcon icon,
    VoidCallback onTap, {
    Color color,
    Key key,
  }) {
    return Material(
      key: key,
      color: StreamChatTheme.of(context).colorTheme.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              icon,
              SizedBox(width: 16),
              Text(
                title,
                style: StreamChatTheme.of(context)
                    .textTheme
                    .body
                    .copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadProgressDialog(
    BuildContext context,
    ValueNotifier<_DownloadProgress> progressNotifier,
  ) {
    final theme = StreamChatTheme.of(context);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ValueListenableBuilder(
        valueListenable: progressNotifier,
        builder: (_, _DownloadProgress progress, __) {
          // Pop the dialog in case the progress is null or it's completed.
          if (progress == null || progress?.toProgressIndicatorValue == 1.0) {
            Future.delayed(
              const Duration(milliseconds: 500),
              Navigator.of(context).maybePop,
            );
          }
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                height: 182,
                width: 182,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorTheme.white,
                ),
                child: Center(
                  child: progress == null
                      ? Container(
                          height: 100,
                          width: 100,
                          child: StreamSvgIcon.error(
                            color: theme.colorTheme.greyGainsboro,
                          ),
                        )
                      : progress.toProgressIndicatorValue == 1.0
                          ? Container(
                              key: Key('completedIcon'),
                              height: 160,
                              width: 160,
                              child: StreamSvgIcon.check(
                                color: theme.colorTheme.greyGainsboro,
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CircularProgressIndicator(
                                    value: progress.toProgressIndicatorValue,
                                    strokeWidth: 8.0,
                                    valueColor: AlwaysStoppedAnimation(
                                      theme.colorTheme.accentBlue,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '${progress.toPercentage}%',
                                      style: theme.textTheme.headline.copyWith(
                                        color: theme.colorTheme.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String> _downloadAttachment(
    Attachment attachment, {
    ProgressCallback progressCallback,
  }) async {
    String filePath;
    final appDocDir = await getTemporaryDirectory();
    await Dio().download(
      attachment.assetUrl ?? attachment.imageUrl ?? attachment.thumbUrl,
      (Headers responseHeaders) {
        final contentType = responseHeaders[Headers.contentTypeHeader];
        final mimeType = contentType.first?.split('/')?.last;
        filePath ??= '${appDocDir.path}/${attachment.id}.$mimeType';
        return filePath;
      },
      onReceiveProgress: progressCallback,
    );
    final result = await ImageGallerySaver.saveFile(filePath);
    return (result as Map)['filePath'];
  }
}

class _DownloadProgress {
  final int total;
  final int received;

  const _DownloadProgress(this.total, this.received);

  factory _DownloadProgress.initial() {
    return _DownloadProgress(double.maxFinite.toInt(), 0);
  }

  double get toProgressIndicatorValue => received / total;

  int get toPercentage => (received * 100) ~/ total;
}
