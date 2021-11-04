import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/media_list_view.dart';
import 'package:stream_chat_flutter/src/video_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_compress/video_compress.dart';

typedef FilePickerCallback = void Function(
  DefaultAttachmentTypes fileType, {
  bool camera,
});

typedef CustomAttachmentIconBuilder = Widget Function(
  BuildContext context,
  bool active,
);

class StreamAttachmentPicker extends StatefulWidget {
  final bool isOpen;
  final double pickerSize;
  final MessageInputController messageInputController;
  final int attachmentLimit;
  final AttachmentLimitExceedListener? onAttachmentLimitExceeded;
  final ValueChanged<bool>? onChangeInputState;
  final ValueChanged<String>? onError;
  final FilePickerCallback onFilePicked;

  /// Video quality to use when compressing the videos
  final VideoQuality compressedVideoQuality;

  /// Frame rate to use when compressing the videos
  final int compressedVideoFrameRate;

  /// Max attachment size in bytes
  /// Defaults to 20 MB
  /// do not set it if you're using our default CDN
  final int maxAttachmentSize;

  final List<DefaultAttachmentTypes> allowedAttachmentTypes;

  final List<CustomAttachmentType> customAttachmentTypes;

  const StreamAttachmentPicker({
    Key? key,
    required this.messageInputController,
    required this.onFilePicked,
    this.isOpen = false,
    this.pickerSize = 360.0,
    this.attachmentLimit = 10,
    this.onAttachmentLimitExceeded,
    this.maxAttachmentSize = 20971520,
    this.compressedVideoQuality = VideoQuality.DefaultQuality,
    this.compressedVideoFrameRate = 30,
    this.onChangeInputState,
    this.onError,
    this.allowedAttachmentTypes = const [
      DefaultAttachmentTypes.image,
      DefaultAttachmentTypes.file,
      DefaultAttachmentTypes.video,
    ],
    this.customAttachmentTypes = const [],
  }) : super(key: key);

  @override
  State<StreamAttachmentPicker> createState() => _StreamAttachmentPickerState();
}

class _StreamAttachmentPickerState extends State<StreamAttachmentPicker> {
  int _filePickerIndex = 0;

  @override
  Widget build(BuildContext context) {
    var _streamChatTheme = StreamChatTheme.of(context);
    var messageInputController = widget.messageInputController;

    final _attachmentContainsImage =
        messageInputController.attachments.any((it) => it.type == 'image');

    final _attachmentContainsFile =
        messageInputController.attachments.any((it) => it.type == 'file');

    final _attachmentContainsVideo =
        messageInputController.attachments.any((it) => it.type == 'video');

    final attachmentLimitCrossed =
        messageInputController.attachments.length >= widget.attachmentLimit;

    Color _getIconColor(int index) {
      final streamChatThemeData = _streamChatTheme;
      switch (index) {
        case 0:
          return _filePickerIndex == 0 || _attachmentContainsImage
              ? streamChatThemeData.colorTheme.accentPrimary
              : (_attachmentContainsImage
                  ? streamChatThemeData.colorTheme.accentPrimary
                  : streamChatThemeData.colorTheme.textHighEmphasis.withOpacity(
                      messageInputController.attachments.isEmpty ? 0.5 : 0.2,
                    ));
        case 1:
          return _attachmentContainsFile
              ? streamChatThemeData.colorTheme.accentPrimary
              : (messageInputController.attachments.isEmpty
                  ? streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.5)
                  : streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.2));
        case 2:
          return widget.messageInputController.attachments.isNotEmpty &&
                  (!_attachmentContainsImage || attachmentLimitCrossed)
              ? streamChatThemeData.colorTheme.textHighEmphasis.withOpacity(0.2)
              : _attachmentContainsFile &&
                      messageInputController.attachments.isNotEmpty
                  ? streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.2)
                  : streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.5);
        case 3:
          return widget.messageInputController.attachments.isNotEmpty &&
                  (!_attachmentContainsVideo || attachmentLimitCrossed)
              ? streamChatThemeData.colorTheme.textHighEmphasis.withOpacity(0.2)
              : _attachmentContainsFile &&
                      messageInputController.attachments.isNotEmpty
                  ? streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.2)
                  : streamChatThemeData.colorTheme.textHighEmphasis
                      .withOpacity(0.5);
        default:
          return Colors.black;
      }
    }

    return AnimatedContainer(
      duration:
          widget.isOpen ? const Duration(milliseconds: 300) : const Duration(),
      curve: Curves.easeOut,
      height: widget.isOpen ? widget.pickerSize : 0,
      child: SingleChildScrollView(
        child: SizedBox(
          height: widget.pickerSize,
          child: Material(
            color: _streamChatTheme.colorTheme.inputBg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (widget.allowedAttachmentTypes
                        .contains(DefaultAttachmentTypes.image))
                      IconButton(
                        icon: StreamSvgIcon.pictures(
                          color: _getIconColor(0),
                        ),
                        onPressed:
                            messageInputController.attachments.isNotEmpty &&
                                    !_attachmentContainsImage
                                ? null
                                : () {
                                    setState(() {
                                      _filePickerIndex = 0;
                                    });
                                  },
                      ),
                    if (widget.allowedAttachmentTypes
                        .contains(DefaultAttachmentTypes.file))
                      IconButton(
                        iconSize: 32,
                        icon: StreamSvgIcon.files(
                          color: _getIconColor(1),
                        ),
                        onPressed: messageInputController
                                    .attachments.isNotEmpty &&
                                !_attachmentContainsFile
                            ? null
                            : () {
                                widget
                                    .onFilePicked(DefaultAttachmentTypes.file);
                              },
                      ),
                    if (widget.allowedAttachmentTypes
                        .contains(DefaultAttachmentTypes.image))
                      IconButton(
                        icon: StreamSvgIcon.camera(
                          color: _getIconColor(2),
                        ),
                        onPressed: attachmentLimitCrossed ||
                                (messageInputController
                                        .attachments.isNotEmpty &&
                                    !_attachmentContainsVideo)
                            ? null
                            : () {
                                widget.onFilePicked(
                                  DefaultAttachmentTypes.image,
                                  camera: true,
                                );
                              },
                      ),
                    if (widget.allowedAttachmentTypes
                        .contains(DefaultAttachmentTypes.video))
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: StreamSvgIcon.record(
                          color: _getIconColor(3),
                        ),
                        onPressed: attachmentLimitCrossed ||
                                (messageInputController
                                        .attachments.isNotEmpty &&
                                    !_attachmentContainsVideo)
                            ? null
                            : () {
                                widget.onFilePicked(
                                  DefaultAttachmentTypes.video,
                                  camera: true,
                                );
                              },
                      ),
                    for (int i = 0;
                        i < widget.customAttachmentTypes.length;
                        i++)
                      IconButton(
                        onPressed: () {
                          if (messageInputController.attachments.isNotEmpty) {
                            if (!messageInputController.attachments.any((e) =>
                                e.type ==
                                widget.customAttachmentTypes[i].type)) {
                              return;
                            }
                          }

                          setState(() {
                            _filePickerIndex = i + 1;
                          });
                        },
                        icon: widget.customAttachmentTypes[i]
                            .iconBuilder(context, _filePickerIndex == i + 1),
                      ),
                  ],
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: _streamChatTheme.colorTheme.barsBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _streamChatTheme.colorTheme.inputBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.isOpen &&
                    (widget.allowedAttachmentTypes
                            .contains(DefaultAttachmentTypes.image) ||
                        (widget.allowedAttachmentTypes
                            .contains(DefaultAttachmentTypes.file))))
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _streamChatTheme.colorTheme.barsBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _PickerWidget(
                        filePickerIndex: _filePickerIndex,
                        streamChatTheme: _streamChatTheme,
                        containsFile: _attachmentContainsFile,
                        selectedMedias: messageInputController.attachments
                            .map((e) => e.id)
                            .toList(),
                        onAddMoreFilesClick: widget.onFilePicked,
                        onMediaSelected: (media) {
                          if (messageInputController.attachments
                              .any((e) => e.id == media.id)) {
                            setState(() => messageInputController.attachments
                                .removeWhere((e) => e.id == media.id));
                          } else {
                            _addAssetAttachment(media);
                          }
                        },
                        allowedAttachmentTypes: widget.allowedAttachmentTypes,
                        customAttachmentTypes: widget.customAttachmentTypes,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addAssetAttachment(AssetEntity medium) async {
    final mediaFile = await medium.originFile.timeout(
      const Duration(seconds: 5),
      onTimeout: () => medium.originFile,
    );

    if (mediaFile == null) return;

    var file = AttachmentFile(
      path: mediaFile.path,
      size: await mediaFile.length(),
      bytes: mediaFile.readAsBytesSync(),
    );

    if (file.size! > widget.maxAttachmentSize) {
      if (medium.type == AssetType.video && file.path != null) {
        final mediaInfo = await (VideoService.compressVideo(
          file.path!,
          frameRate: widget.compressedVideoFrameRate,
          quality: widget.compressedVideoQuality,
        ) as FutureOr<MediaInfo>);

        if (mediaInfo.filesize! > widget.maxAttachmentSize) {
          widget.onError?.call(
            context.translations.fileTooLargeAfterCompressionError(
              widget.maxAttachmentSize / (1024 * 1024),
            ),
          );
          return;
        }
        file = AttachmentFile(
          name: file.name,
          size: mediaInfo.filesize,
          bytes: await mediaInfo.file?.readAsBytes(),
          path: mediaInfo.path,
        );
      } else {
        widget.onError?.call(context.translations.fileTooLargeError(
          widget.maxAttachmentSize / (1024 * 1024),
        ));
        return;
      }
    }

    setState(() {
      final attachment = Attachment(
        id: medium.id,
        file: file,
        type: medium.type == AssetType.image ? 'image' : 'video',
      );
      _addAttachments([attachment]);
    });
  }

  /// Adds an attachment to the [messageInputController.attachments] map
  void _addAttachments(Iterable<Attachment> attachments) {
    final limit = widget.attachmentLimit;
    final length =
        widget.messageInputController.attachments.length + attachments.length;
    if (length > limit) {
      final onAttachmentLimitExceed = widget.onAttachmentLimitExceeded;
      if (onAttachmentLimitExceed != null) {
        return onAttachmentLimitExceed(
          widget.attachmentLimit,
          context.translations.attachmentLimitExceedError(limit),
        );
      }
      return widget.onError?.call(
        context.translations.attachmentLimitExceedError(limit),
      );
    }
    for (final attachment in attachments) {
      widget.messageInputController.addAttachment(attachment);
    }
  }
}

class _PickerWidget extends StatefulWidget {
  const _PickerWidget({
    Key? key,
    required this.filePickerIndex,
    required this.containsFile,
    required this.selectedMedias,
    required this.onAddMoreFilesClick,
    required this.onMediaSelected,
    required this.streamChatTheme,
    required this.allowedAttachmentTypes,
    required this.customAttachmentTypes,
  }) : super(key: key);

  final int filePickerIndex;
  final bool containsFile;
  final List<String> selectedMedias;
  final void Function(DefaultAttachmentTypes) onAddMoreFilesClick;
  final void Function(AssetEntity) onMediaSelected;
  final StreamChatThemeData streamChatTheme;
  final List<DefaultAttachmentTypes> allowedAttachmentTypes;
  final List<CustomAttachmentType> customAttachmentTypes;

  @override
  _PickerWidgetState createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<_PickerWidget> {
  Future<bool>? requestPermission;

  @override
  void initState() {
    super.initState();
    requestPermission = PhotoManager.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filePickerIndex != 0) {
      return widget.customAttachmentTypes[widget.filePickerIndex - 1]
          .pickerBuilder(context);
    }
    return FutureBuilder<bool>(
      future: requestPermission,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Offstage();
        }

        if (snapshot.data!) {
          if (widget.containsFile ||
              !widget.allowedAttachmentTypes
                  .contains(DefaultAttachmentTypes.image)) {
            return GestureDetector(
              onTap: () {
                widget.onAddMoreFilesClick(DefaultAttachmentTypes.file);
              },
              child: Container(
                constraints: const BoxConstraints.expand(),
                color: widget.streamChatTheme.colorTheme.inputBg,
                alignment: Alignment.center,
                child: Text(
                  context.translations.addMoreFilesLabel,
                  style: TextStyle(
                    color: widget.streamChatTheme.colorTheme.accentPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          return MediaListView(
            selectedIds: widget.selectedMedias,
            onSelect: widget.onMediaSelected,
          );
        }

        return InkWell(
          onTap: () async {
            PhotoManager.openSetting();
          },
          child: Container(
            color: widget.streamChatTheme.colorTheme.inputBg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  'svgs/icon_picture_empty_state.svg',
                  package: 'stream_chat_flutter',
                  height: 140,
                  color: widget.streamChatTheme.colorTheme.disabled,
                ),
                Text(
                  context.translations.enablePhotoAndVideoAccessMessage,
                  style: widget.streamChatTheme.textTheme.body.copyWith(
                    color: widget.streamChatTheme.colorTheme.textLowEmphasis,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    context.translations.allowGalleryAccessMessage,
                    style: widget.streamChatTheme.textTheme.bodyBold.copyWith(
                      color: widget.streamChatTheme.colorTheme.accentPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomAttachmentType {
  String type;
  CustomAttachmentIconBuilder iconBuilder;
  WidgetBuilder pickerBuilder;

  CustomAttachmentType({
    required this.type,
    required this.iconBuilder,
    required this.pickerBuilder,
  });
}
