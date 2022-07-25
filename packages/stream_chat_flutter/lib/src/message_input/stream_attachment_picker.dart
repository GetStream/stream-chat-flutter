import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/media_list_view/media_list_view_controller.dart';
import 'package:stream_chat_flutter/src/message_input/picker_widget.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Callback for when a file has to be picked.
typedef FilePickerCallback = void Function(
  DefaultAttachmentTypes fileType, {
  bool camera,
});

/// Callback for building an icon for a custom attachment type.
typedef CustomAttachmentIconBuilder = Widget Function(
  BuildContext context,
  bool active,
);

/// A widget that allows to pick an attachment.
class StreamAttachmentPicker extends StatefulWidget {
  /// Default constructor for [StreamAttachmentPicker] which creates the Stream
  /// attachment picker widget.
  const StreamAttachmentPicker({
    super.key,
    required this.messageInputController,
    required this.onFilePicked,
    this.isOpen = false,
    this.pickerSize = 360.0,
    this.attachmentLimit = 10,
    this.onAttachmentLimitExceeded,
    this.maxAttachmentSize = kDefaultMaxAttachmentSize,
    this.onError,
    this.allowedAttachmentTypes = const [
      DefaultAttachmentTypes.image,
      DefaultAttachmentTypes.file,
      DefaultAttachmentTypes.video,
    ],
    this.customAttachmentTypes = const [],
    this.permissionState,
  });

  /// True if the picker is open.
  final bool isOpen;

  /// The permission state.
  final PermissionState? permissionState;

  /// The picker size in height.
  final double pickerSize;

  /// The [StreamMessageInputController] linked to this picker.
  final StreamMessageInputController messageInputController;

  /// The limit of attachments that can be picked.
  final int attachmentLimit;

  /// The callback for when the attachment limit is exceeded.
  final AttachmentLimitExceedListener? onAttachmentLimitExceeded;

  /// Callback for when an error occurs in the attachment picker.
  final ValueChanged<String>? onError;

  /// Callback for when file is picked.
  final FilePickerCallback onFilePicked;

  /// Max attachment size in bytes:
  /// - Defaults to 20 MB
  /// - Do not set it if you're using our default CDN
  final int maxAttachmentSize;

  /// The list of attachment types that can be picked.
  final List<DefaultAttachmentTypes> allowedAttachmentTypes;

  /// The list of custom attachment types that can be picked.
  final List<CustomAttachmentType> customAttachmentTypes;

  /// Used to create a new copy of [StreamAttachmentPicker] with modified
  /// properties.
  StreamAttachmentPicker copyWith({
    Key? key,
    StreamMessageInputController? messageInputController,
    FilePickerCallback? onFilePicked,
    bool? isOpen,
    double? pickerSize,
    int? attachmentLimit,
    AttachmentLimitExceedListener? onAttachmentLimitExceeded,
    int? maxAttachmentSize,
    ValueChanged<bool>? onChangeInputState,
    ValueChanged<String>? onError,
    List<DefaultAttachmentTypes>? allowedAttachmentTypes,
    List<CustomAttachmentType>? customAttachmentTypes = const [],
  }) =>
      StreamAttachmentPicker(
        key: key ?? this.key,
        messageInputController:
            messageInputController ?? this.messageInputController,
        onFilePicked: onFilePicked ?? this.onFilePicked,
        isOpen: isOpen ?? this.isOpen,
        pickerSize: pickerSize ?? this.pickerSize,
        attachmentLimit: attachmentLimit ?? this.attachmentLimit,
        onAttachmentLimitExceeded:
            onAttachmentLimitExceeded ?? this.onAttachmentLimitExceeded,
        maxAttachmentSize: maxAttachmentSize ?? this.maxAttachmentSize,
        onError: onError ?? this.onError,
        allowedAttachmentTypes:
            allowedAttachmentTypes ?? this.allowedAttachmentTypes,
        customAttachmentTypes:
            customAttachmentTypes ?? this.customAttachmentTypes,
      );

  @override
  State<StreamAttachmentPicker> createState() => _StreamAttachmentPickerState();
}

class _StreamAttachmentPickerState extends State<StreamAttachmentPicker> {
  int _filePickerIndex = 0;
  final _mediaListViewController = MediaListViewController();

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);
    final messageInputController = widget.messageInputController;

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
          widget.isOpen ? const Duration(milliseconds: 300) : Duration.zero,
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
                        padding: EdgeInsets.zero,
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
                    const Spacer(),
                    if (widget.isOpen &&
                        widget.permissionState == PermissionState.limited)
                      TextButton(
                        child: Text(context.translations.viewLibrary),
                        onPressed: () async {
                          await PhotoManager.presentLimited();
                          _mediaListViewController.updateMedia(
                            newValue: true,
                          );
                        },
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
                      child: PickerWidget(
                        mediaListViewController: _mediaListViewController,
                        filePickerIndex: _filePickerIndex,
                        streamChatTheme: _streamChatTheme,
                        containsFile: _attachmentContainsFile,
                        selectedMedias: messageInputController.attachments
                            .map((e) => e.id)
                            .toList(),
                        onAddMoreFilesClick: widget.onFilePicked,
                        permissionState: widget.permissionState,
                        onMediaSelected: (media) {
                          if (messageInputController.attachments
                              .any((e) => e.id == media.id)) {
                            messageInputController
                                .removeAttachmentById(media.id);
                          } else {
                            _addAssetAttachment(media);
                          }
                        },
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

    final file = AttachmentFile(
      path: mediaFile.path,
      size: await mediaFile.length(),
      bytes: mediaFile.readAsBytesSync(),
    );

    if (file.size! > widget.maxAttachmentSize) {
      return widget.onError?.call(
        context.translations.fileTooLargeError(
          widget.maxAttachmentSize / (1024 * 1024),
        ),
      );
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

/// Class which holds data for a custom attachment type in the attachment picker
class CustomAttachmentType {
  /// Default constructor for creating a custom attachment for the attachment
  /// picker.
  CustomAttachmentType({
    required this.type,
    required this.iconBuilder,
    required this.pickerBuilder,
  });

  /// Type name.
  String type;

  /// Builds the icon in the attachment picker top row.
  CustomAttachmentIconBuilder iconBuilder;

  /// Builds content in the attachment builder when icon is selected.
  WidgetBuilder pickerBuilder;
}
