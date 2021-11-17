import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Callback to download an attachment asset
typedef AttachmentDownloader = Future<String> Function(
  Attachment attachment, {
  ProgressCallback? progressCallback,
});

/// Widget that shows the options in the gallery view
class AttachmentActionsModal extends StatelessWidget {
  /// Returns a new [AttachmentActionsModal]
  const AttachmentActionsModal({
    Key? key,
    required this.currentIndex,
    required this.message,
    this.onShowMessage,
    this.imageDownloader,
    this.fileDownloader,
    this.showReply = true,
    this.showShowInChat = true,
    this.showSave = true,
    this.showDelete = true,
    this.customActions = const [],
  }) : super(key: key);

  /// The message containing the attachments
  final Message message;

  /// Current page index
  final int currentIndex;

  /// Callback to show the message
  final VoidCallback? onShowMessage;

  /// Callback to download images
  final AttachmentDownloader? imageDownloader;

  /// Callback to provide download files
  final AttachmentDownloader? fileDownloader;

  /// Show reply option
  final bool showReply;

  /// Show show in chat option
  final bool showShowInChat;

  /// Show save option
  final bool showSave;

  /// Show delete option
  final bool showDelete;

  /// List of custom actions
  final List<AttachmentAction> customActions;

  /// Creates a copy of [MessageWidget] with specified attributes overridden.
  AttachmentActionsModal copyWith({
    Key? key,
    int? currentIndex,
    Message? message,
    VoidCallback? onShowMessage,
    AttachmentDownloader? imageDownloader,
    AttachmentDownloader? fileDownloader,
    bool? showReply,
    bool? showShowInChat,
    bool? showSave,
    bool? showDelete,
    List<AttachmentAction>? customActions,
  }) =>
      AttachmentActionsModal(
        key: key ?? this.key,
        currentIndex: currentIndex ?? this.currentIndex,
        message: message ?? this.message,
        onShowMessage: onShowMessage ?? this.onShowMessage,
        imageDownloader: imageDownloader ?? this.imageDownloader,
        fileDownloader: fileDownloader ?? this.fileDownloader,
        showReply: showReply ?? this.showReply,
        showShowInChat: showShowInChat ?? this.showShowInChat,
        showSave: showSave ?? this.showSave,
        showDelete: showDelete ?? this.showDelete,
        customActions: customActions ?? this.customActions,
      );

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.maybePop(context),
        child: _buildPage(context),
      );

  Widget _buildPage(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: kToolbarHeight),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showReply)
                    _buildButton(
                      context,
                      context.translations.replyLabel,
                      StreamSvgIcon.iconCurveLineLeftUp(
                        size: 24,
                        color: theme.colorTheme.textLowEmphasis,
                      ),
                      () {
                        Navigator.pop(context, ReturnActionType.reply);
                      },
                    ),
                  if (showShowInChat)
                    _buildButton(
                      context,
                      context.translations.showInChatLabel,
                      StreamSvgIcon.eye(
                        size: 24,
                        color: theme.colorTheme.textHighEmphasis,
                      ),
                      onShowMessage,
                    ),
                  if (showSave)
                    _buildButton(
                      context,
                      message.attachments[currentIndex].type == 'video'
                          ? context.translations.saveVideoLabel
                          : context.translations.saveImageLabel,
                      StreamSvgIcon.iconSave(
                        size: 24,
                        color: theme.colorTheme.textLowEmphasis,
                      ),
                      () {
                        final attachment = message.attachments[currentIndex];
                        final isImage = attachment.type == 'image';
                        final Future<String?> Function(
                          Attachment, {
                          void Function(int, int) progressCallback,
                        }) saveFile = fileDownloader ?? _downloadAttachment;
                        final Future<String?> Function(
                          Attachment, {
                          void Function(int, int) progressCallback,
                        }) saveImage = imageDownloader ?? _downloadAttachment;
                        final downloader = isImage ? saveImage : saveFile;

                        final progressNotifier =
                            ValueNotifier<_DownloadProgress?>(
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
                        ).catchError((e, stk) {
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
                  if (StreamChat.of(context).currentUser?.id ==
                          message.user?.id &&
                      showDelete)
                    _buildButton(
                      context,
                      context.translations.deleteLabel.capitalize(),
                      StreamSvgIcon.delete(
                        size: 24,
                        color: theme.colorTheme.accentError,
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
                      color: theme.colorTheme.accentError,
                    ),
                  ...customActions
                      .map(
                        (e) => _buildButton(
                          context,
                          e.actionTitle,
                          e.icon,
                          e.onTap,
                        ),
                      )
                      .toList(),
                ]
                    .map<Widget>((e) => Align(
                          alignment: Alignment.centerRight,
                          child: e,
                        ))
                    .insertBetween(
                      Container(
                        height: 1,
                        color: theme.colorTheme.borders,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    context,
    String title,
    Widget icon,
    VoidCallback? onTap, {
    Color? color,
    Key? key,
  }) =>
      Material(
        key: key,
        color: StreamChatTheme.of(context).colorTheme.barsBg,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 16),
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

  Widget _buildDownloadProgressDialog(
    BuildContext context,
    ValueNotifier<_DownloadProgress?> progressNotifier,
  ) {
    final theme = StreamChatTheme.of(context);
    return ValueListenableBuilder(
      valueListenable: progressNotifier,
      builder: (_, _DownloadProgress? progress, __) {
        // Pop the dialog in case the progress is null or it's completed.
        if (progress == null || progress.toProgressIndicatorValue == 1.0) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () => Navigator.of(context).maybePop(),
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
                color: theme.colorTheme.barsBg,
              ),
              child: Center(
                child: progress == null
                    ? SizedBox(
                        height: 100,
                        width: 100,
                        child: StreamSvgIcon.error(
                          color: theme.colorTheme.disabled,
                        ),
                      )
                    : progress.toProgressIndicatorValue == 1.0
                        ? SizedBox(
                            key: const Key('completedIcon'),
                            height: 160,
                            width: 160,
                            child: StreamSvgIcon.check(
                              color: theme.colorTheme.disabled,
                            ),
                          )
                        : SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CircularProgressIndicator(
                                  value: progress.toProgressIndicatorValue,
                                  strokeWidth: 8,
                                  valueColor: AlwaysStoppedAnimation(
                                    theme.colorTheme.accentPrimary,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${progress.toPercentage}%',
                                    style: theme.textTheme.headline.copyWith(
                                      color: theme.colorTheme.textLowEmphasis,
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
    );
  }

  Future<String?> _downloadAttachment(
    Attachment attachment, {
    ProgressCallback? progressCallback,
  }) async {
    String? filePath;
    final appDocDir = await getTemporaryDirectory();
    await Dio().download(
      attachment.assetUrl ?? attachment.imageUrl ?? attachment.thumbUrl!,
      (Headers responseHeaders) {
        final contentType = responseHeaders[Headers.contentTypeHeader]!;
        final mimeType = contentType.first.split('/').last;
        filePath ??= '${appDocDir.path}/${attachment.id}.$mimeType';
        return filePath!;
      },
      onReceiveProgress: progressCallback,
    );
    final result = await ImageGallerySaver.saveFile(filePath!);
    return (result as Map)['filePath'];
  }
}

class _DownloadProgress {
  const _DownloadProgress(this.total, this.received);

  factory _DownloadProgress.initial() =>
      _DownloadProgress(double.maxFinite.toInt(), 0);

  final int total;
  final int received;

  double get toProgressIndicatorValue => received / total;

  int get toPercentage => (received * 100) ~/ total;
}

class AttachmentAction {
  String actionTitle;
  Widget icon;
  VoidCallback onTap;

  AttachmentAction({
    required this.actionTitle,
    required this.icon,
    required this.onTap,
  });
}
