import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Callback to download an attachment asset
typedef AttachmentDownloader = Future<String> Function(
  Attachment attachment, {
  ProgressCallback? progressCallback,
  DownloadedPathCallback? downloadedPathCallback,
});

/// Callback to receive the path once the attachment asset is downloaded
typedef DownloadedPathCallback = void Function(String? path);

/// Widget that shows the options in the gallery view
class AttachmentActionsModal extends StatelessWidget {
  /// Returns a new [AttachmentActionsModal]
  const AttachmentActionsModal({
    Key? key,
    required this.attachment,
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

  /// The attachment object for which the actions are to be performed
  final Attachment attachment;

  /// The message containing the attachments
  final Message message;

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

  /// Creates a copy of [StreamMessageWidget] with
  /// specified attributes overridden.
  AttachmentActionsModal copyWith({
    Key? key,
    Attachment? attachment,
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
        attachment: attachment ?? this.attachment,
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
                      attachment.type == 'video'
                          ? context.translations.saveVideoLabel
                          : context.translations.saveImageLabel,
                      StreamSvgIcon.iconSave(
                        size: 24,
                        color: theme.colorTheme.textLowEmphasis,
                      ),
                      () {
                        final isImage = attachment.type == 'image';
                        final Future<String?> Function(
                          Attachment, {
                          void Function(int, int) progressCallback,
                          DownloadedPathCallback downloadedPathCallback,
                        }) saveFile = fileDownloader ?? _downloadAttachment;
                        final Future<String?> Function(
                          Attachment, {
                          void Function(int, int) progressCallback,
                          DownloadedPathCallback downloadedPathCallback,
                        }) saveImage = imageDownloader ?? _downloadAttachment;
                        final downloader = isImage ? saveImage : saveFile;

                        final progressNotifier =
                            ValueNotifier<_DownloadProgress?>(
                          _DownloadProgress.initial(),
                        );
                        final downloadedPathNotifier = ValueNotifier<String?>(
                          null,
                        );

                        downloader(
                          attachment,
                          progressCallback: (received, total) {
                            print('>>>>>>>>>>>>>>>');
                            print('>>r : $received');
                            print('>>t : $total');
                            print('>>>>>>>>>>>>>>>');
                            progressNotifier.value = _DownloadProgress(
                              total,
                              received,
                            );
                          },
                          downloadedPathCallback: (String? path) {
                            downloadedPathNotifier.value = path;
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
                            downloadedPathNotifier,
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
                          final currentAttachmentIndex =
                              message.attachments.indexWhere(
                            (element) => element.id == attachment.id,
                          );
                          final remainingAttachments = [...message.attachments]
                            ..removeAt(currentAttachmentIndex);
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
    ValueNotifier<String?> downloadedFilePathNotifier,
  ) {
    final theme = StreamChatTheme.of(context);
    return ValueListenableBuilder(
      valueListenable: downloadedFilePathNotifier,
      builder: (_, String? path, __) {
        final _downloadComplete = path != null && path.isNotEmpty;
        // Pop the dialog in case the download has completed
        if (_downloadComplete) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () => Navigator.of(context).maybePop(),
          );
        }
        return ValueListenableBuilder(
          valueListenable: progressNotifier,
          builder: (_, _DownloadProgress? progress, __) {
            // Pop the dialog in case the progress is null.
            if (progress == null) {
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
                        : _downloadComplete
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
                                      strokeWidth: 8,
                                      color: theme.colorTheme.accentPrimary,
                                    ),
                                    Center(
                                      child: Text(
                                        '${progress.receivedValueInMB} MB',
                                        style:
                                            theme.textTheme.headline.copyWith(
                                          color:
                                              theme.colorTheme.textLowEmphasis,
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
      },
    );
  }

  Future<String?> _downloadAttachment(
    Attachment attachment, {
    ProgressCallback? progressCallback,
    DownloadedPathCallback? downloadedPathCallback,
  }) async {
    String? filePath;
    final appDocDir = await getTemporaryDirectory();
    final url =
        attachment.assetUrl ?? attachment.imageUrl ?? attachment.thumbUrl!;
    await Dio().download(
      url,
      (Headers responseHeaders) {
        final ext = Uri.parse(url).pathSegments.last;
        filePath ??= '${appDocDir.path}/${attachment.id}.$ext';
        return filePath!;
      },
      onReceiveProgress: progressCallback,
    );
    final result = await ImageGallerySaver.saveFile(filePath!);
    downloadedPathCallback?.call((result as Map)['filePath']);
    return (result as Map)['filePath'];
  }
}

class _DownloadProgress {
  const _DownloadProgress(this.total, this.received);

  factory _DownloadProgress.initial() =>
      _DownloadProgress(double.maxFinite.toInt(), 0);

  final int total;
  final int received;

  String get receivedValueInMB => ((received / 1024) / 1024).toStringAsFixed(2);

  double get toProgressIndicatorValue => received / total;

  int get toPercentage => (received * 100) ~/ total;
}

/// Class for custom attachment action
class AttachmentAction {
  /// Constructor for custom attachment action
  AttachmentAction({
    required this.actionTitle,
    required this.icon,
    required this.onTap,
  });

  /// Title for the attachment action
  String actionTitle;

  /// Icon for the attachment action
  Widget icon;

  /// Callback for when the action is tapped
  VoidCallback onTap;
}
