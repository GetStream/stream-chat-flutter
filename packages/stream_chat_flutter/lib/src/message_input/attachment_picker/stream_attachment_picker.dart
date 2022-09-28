import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/options.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The default maximum size for media attachments.
const kDefaultMaxAttachmentSize = 100 * 1024 * 1024; // 100MB in Bytes

/// The default maximum number of media attachments.
const kDefaultMaxAttachmentCount = 10;

class StreamAttachmentPickerController extends ValueNotifier<List<Attachment>> {
  ///
  StreamAttachmentPickerController({
    this.initialAttachments,
    this.maxAttachmentSize = kDefaultMaxAttachmentSize,
    this.maxAttachmentCount = kDefaultMaxAttachmentCount,
  })  : assert(
          (initialAttachments?.length ?? 0) <= maxAttachmentCount,
          '''The initial attachments count must be less than or equal to maxAttachmentCount''',
        ),
        super(initialAttachments ?? const []);

  final int maxAttachmentSize;
  final int maxAttachmentCount;
  final List<Attachment>? initialAttachments;

  @override
  set value(List<Attachment> newValue) {
    if (newValue.length > maxAttachmentCount) {
      throw ArgumentError(
        'The maximum number of attachments is $maxAttachmentCount.',
      );
    }
    super.value = newValue;
  }

  Future<String> _saveToCache(AttachmentFile file) async {
    // Cache the attachment in a temporary file.
    return StreamAttachmentHandler.instance.saveAttachmentFile(
      attachmentFile: file,
    );
  }

  Future<void> _removeFromCache(AttachmentFile file) {
    // Remove the cached attachment file.
    return StreamAttachmentHandler.instance.deleteAttachmentFile(
      attachmentFile: file,
    );
  }

  /// Adds a new attachment to the message.
  Future<void> addAttachment(Attachment attachment) async {
    assert(attachment.fileSize != null, '');
    if (attachment.fileSize! > maxAttachmentSize) {
      throw ArgumentError(
        'The size of the attachment is ${attachment.fileSize} bytes, '
        'but the maximum size allowed is $maxAttachmentSize bytes.',
      );
    }

    final file = attachment.file;
    final uploadState = attachment.uploadState;

    // No need to cache the attachment if it's already uploaded
    // or we are on web.
    if (file == null || uploadState.isSuccess || isWeb) {
      value = [...value, attachment];
      return;
    }

    // Cache the attachment in a temporary file.
    final tempFilePath = await _saveToCache(file);

    value = [
      ...value,
      attachment.copyWith(
        file: file.copyWith(
          path: tempFilePath,
        ),
      ),
    ];
  }

  /// Removes the specified [attachment] from the message.
  Future<void> removeAttachment(Attachment attachment) async {
    final file = attachment.file;
    final uploadState = attachment.uploadState;

    if (file == null || uploadState.isSuccess || isWeb) {
      value = [...value]..remove(attachment);
      return;
    }

    // Remove the cached attachment file.
    await _removeFromCache(file);

    value = [...value]..remove(attachment);
  }

  /// Remove the attachment with the given [attachmentId].
  void removeAttachmentById(String attachmentId) {
    final attachment = value.firstWhereOrNull(
      (attachment) => attachment.id == attachmentId,
    );

    if (attachment == null) return;

    removeAttachment(attachment);
  }

  /// Clears all the attachments.
  Future<void> clear() async {
    final attachments = [...value];
    for (final attachment in attachments) {
      final file = attachment.file;
      final uploadState = attachment.uploadState;

      if (file == null || uploadState.isSuccess || isWeb) continue;

      await _removeFromCache(file);
    }
    value = const [];
  }

  /// Resets the controller to its initial state.
  Future<void> reset() async {
    final attachments = [...value];
    for (final attachment in attachments) {
      final file = attachment.file;
      final uploadState = attachment.uploadState;

      if (file == null || uploadState.isSuccess || isWeb) continue;

      await _removeFromCache(file);
    }
    value = initialAttachments ?? const [];
  }
}

/// The possible picker types of the attachment picker.
enum AttachmentPickerType {
  /// The attachment picker will only allow to pick images.
  images,

  /// The attachment picker will only allow to pick videos.
  videos,

  /// The attachment picker will only allow to pick audios.
  audios,

  /// The attachment picker will only allow to pick files or documents.
  files,
}

typedef AttachmentPickerOptionViewBuilder = Widget Function(
  BuildContext context,
  StreamAttachmentPickerController controller,
);

class AttachmentPickerOption {
  const AttachmentPickerOption({
    required this.supportedTypes,
    required this.icon,
    this.title,
    this.optionViewBuilder,
  });

  final Widget icon;
  final String? title;
  final Iterable<AttachmentPickerType> supportedTypes;
  final AttachmentPickerOptionViewBuilder? optionViewBuilder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentPickerOption &&
          runtimeType == other.runtimeType &&
          const IterableEquality().equals(supportedTypes, other.supportedTypes);

  @override
  int get hashCode => const IterableEquality().hash(supportedTypes);
}

///
extension AttachmentPickerOptionTypeX on StreamAttachmentPickerController {
  /// Returns the list of available attachment picker options.
  Set<AttachmentPickerType> get currentAttachmentPickerTypes {
    final containsImage = value.any((it) => it.type == 'image');
    final containsVideo = value.any((it) => it.type == 'video');
    final containsAudio = value.any((it) => it.type == 'audio');
    final containsFile = value.any((it) => it.type == 'file');

    return {
      if (containsImage) AttachmentPickerType.images,
      if (containsVideo) AttachmentPickerType.videos,
      if (containsAudio) AttachmentPickerType.audios,
      if (containsFile) AttachmentPickerType.files,
    };
  }
}

class WebOrDesktopAttachmentPickerOption extends AttachmentPickerOption {
  WebOrDesktopAttachmentPickerOption({
    required AttachmentPickerType type,
    required super.icon,
    required super.title,
  }) : super(supportedTypes: [type]);

  @override
  String get title => super.title!;

  AttachmentPickerType get type => supportedTypes.first;
}

typedef OnWebOrDesktopAttachmentPickerOptionTap = void Function(
  BuildContext context,
  StreamAttachmentPickerController controller,
  WebOrDesktopAttachmentPickerOption option,
);

class StreamWebOrDesktopAttachmentPickerBottomSheet extends StatelessWidget {
  const StreamWebOrDesktopAttachmentPickerBottomSheet({
    super.key,
    required this.options,
    required this.controller,
    this.onOptionTap,
  });

  final Iterable<WebOrDesktopAttachmentPickerOption> options;
  final StreamAttachmentPickerController controller;
  final OnWebOrDesktopAttachmentPickerOptionTap? onOptionTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ...options.map((option) {
          VoidCallback? onOptionTap;
          if (this.onOptionTap != null) {
            onOptionTap = () {
              this.onOptionTap?.call(context, controller, option);
            };
          }
          return ListTile(
            leading: option.icon,
            title: Text(option.title),
            onTap: onOptionTap,
          );
        }),
      ],
    );
  }
}

class StreamMobileAttachmentPickerBottomSheet extends StatefulWidget {
  const StreamMobileAttachmentPickerBottomSheet({
    super.key,
    required this.options,
    required this.controller,
    this.initialOption,
    this.onSendAttachments,
  });

  final List<AttachmentPickerOption> options;
  final AttachmentPickerOption? initialOption;
  final StreamAttachmentPickerController controller;
  final ValueSetter<List<Attachment>>? onSendAttachments;

  @override
  State<StreamMobileAttachmentPickerBottomSheet> createState() =>
      _StreamMobileAttachmentPickerBottomSheetState();
}

class _StreamMobileAttachmentPickerBottomSheetState
    extends State<StreamMobileAttachmentPickerBottomSheet> {
  late AttachmentPickerOption _currentOption;

  @override
  void initState() {
    super.initState();
    _currentOption = widget.initialOption ?? widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Attachment>>(
      valueListenable: widget.controller,
      builder: (context, attachments, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _AttachmentPickerOptions(
              controller: widget.controller,
              options: widget.options,
              currentOption: _currentOption,
              onSendAttachment: widget.onSendAttachments,
              onOptionSelected: (option) async {
                setState(() => _currentOption = option);
              },
            ),
            Expanded(
              child: _currentOption.optionViewBuilder
                      ?.call(context, widget.controller) ??
                  const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

class _AttachmentPickerOptions extends StatelessWidget {
  const _AttachmentPickerOptions({
    super.key,
    required this.options,
    required this.currentOption,
    required this.controller,
    this.onOptionSelected,
    this.onSendAttachment,
  });

  final Iterable<AttachmentPickerOption> options;
  final AttachmentPickerOption currentOption;
  final StreamAttachmentPickerController controller;
  final ValueSetter<AttachmentPickerOption>? onOptionSelected;
  final ValueSetter<List<Attachment>>? onSendAttachment;

  Set<AttachmentPickerType> _filterEnabledTypes() {
    final availableTypes = controller.currentAttachmentPickerTypes;
    final enabledTypes = <AttachmentPickerType>{};
    for (final option in options) {
      final supportedTypes = option.supportedTypes;
      if (availableTypes.any(supportedTypes.contains)) {
        enabledTypes.addAll(supportedTypes);
      }
    }
    return enabledTypes;
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    return ValueListenableBuilder<List<Attachment>>(
      valueListenable: controller,
      builder: (context, attachments, __) {
        final enabledTypes = _filterEnabledTypes();
        return Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...options.map(
                      (option) {
                        final supportedTypes = option.supportedTypes;

                        final isSelected = option == currentOption;
                        final isEnabled = enabledTypes.isEmpty ||
                            enabledTypes.any(supportedTypes.contains);

                        final color = isSelected
                            ? colorTheme.accentPrimary
                            : colorTheme.textLowEmphasis;

                        final onPressed =
                            isEnabled ? () => onOptionSelected!(option) : null;

                        return IconButton(
                          color: color,
                          disabledColor: colorTheme.disabled,
                          icon: option.icon,
                          onPressed: onPressed,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Builder(
              builder: (context) {
                final isEnabled =
                    attachments.isNotEmpty && onSendAttachment != null;

                final onPressed = isEnabled
                    ? () {
                        onSendAttachment!(attachments);
                      }
                    : null;

                return IconButton(
                  iconSize: 22,
                  color: colorTheme.accentPrimary,
                  disabledColor: colorTheme.disabled,
                  icon: StreamSvgIcon.emptyCircleLeft().toIconThemeSvgIcon(),
                  onPressed: onPressed,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

/// Signature used by [EndOfFrameCallbackWidget.errorBuilder] to create a
/// replacement widget to render.
typedef EndOfFrameCallbackErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);

typedef EndOfFrameCallback = FutureOr<void> Function(BuildContext context);

class EndOfFrameCallbackWidget extends StatefulWidget {
  const EndOfFrameCallbackWidget({
    super.key,
    required this.onEndOfFrame,
    this.child,
    this.errorBuilder,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The callback that will be called after the widget has been built.
  final EndOfFrameCallback onEndOfFrame;

  /// The callback that will be called if the [onEndOfFrame] callback throws an
  /// error.
  final EndOfFrameCallbackErrorWidgetBuilder? errorBuilder;

  @override
  State<EndOfFrameCallbackWidget> createState() =>
      _EndOfFrameCallbackWidgetState();
}

class _EndOfFrameCallbackWidgetState extends State<EndOfFrameCallbackWidget> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      print('End of frame');
      if (mounted) {
        try {
          await widget.onEndOfFrame(context);
        } catch (error, stackTrace) {
          setState(() {
            _error = error;
            _stackTrace = stackTrace;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final stackTrace = _stackTrace;

    if (error != null) {
      final errorBuilder = widget.errorBuilder;
      if (errorBuilder != null) {
        return errorBuilder(context, error, stackTrace);
      }
      return const Text('An error occurred');
    }

    // Reset the error and stack trace so that we don't keep showing the same
    // error over and over.
    _error = null;
    _stackTrace = null;

    return widget.child ?? const SizedBox.shrink();
  }
}

const _kDefaultOptionDrawerShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  ),
);

/// A widget that will be shown in the attachment picker.
/// It can be used to show a custom view for each attachment picker option.
class OptionDrawer extends StatelessWidget {
  /// Creates a widget that will be shown in the attachment picker.
  const OptionDrawer({
    super.key,
    required this.child,
    this.color,
    this.elevation = 2,
    this.margin = EdgeInsets.zero,
    this.clipBehavior = Clip.hardEdge,
    this.shape = _kDefaultOptionDrawerShape,
    this.title,
    this.actions = const [],
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The background color of the options card.
  ///
  /// Defaults to [StreamColorTheme.barsBg].
  final Color? color;

  /// The elevation of the options card.
  ///
  /// The default value is 2.
  final double elevation;

  /// The margin of the options card.
  ///
  /// The default value is [EdgeInsets.zero].
  final EdgeInsetsGeometry margin;

  /// The clip behavior of the options card.
  ///
  /// The default value is [Clip.hardEdge].
  final Clip clipBehavior;

  /// The shape of the options card.
  final ShapeBorder shape;

  /// The title of the options card.
  final Widget? title;

  /// The actions available for the options card.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;

    var height = 20.0;
    if (title != null || actions.isNotEmpty) {
      height = 40.0;
    }

    final leading = title ?? const SizedBox.shrink();

    Widget trailing;
    if (actions.isNotEmpty) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: actions,
      );
    } else {
      trailing = const SizedBox.shrink();
    }

    return Card(
      elevation: elevation,
      color: color ?? colorTheme.barsBg,
      margin: margin,
      shape: shape,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height,
            child: Row(
              children: [
                Expanded(child: leading),
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: colorTheme.disabled,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Expanded(child: trailing),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

Widget mobileAttachmentPickerBuilder({
  required BuildContext context,
  required StreamAttachmentPickerController controller,
  ThumbnailSize attachmentThumbnailSize = const ThumbnailSize(400, 400),
  ThumbnailFormat attachmentThumbnailFormat = ThumbnailFormat.jpeg,
  int attachmentThumbnailQuality = 100,
  double attachmentThumbnailScale = 1,
}) {
  return StreamMobileAttachmentPickerBottomSheet(
    controller: controller,
    onSendAttachments: Navigator.of(context).pop,
    options: [
      AttachmentPickerOption(
        icon: StreamSvgIcon.pictures(size: 36).toIconThemeSvgIcon(),
        supportedTypes: [
          AttachmentPickerType.images,
          AttachmentPickerType.videos,
        ],
        optionViewBuilder: (context, controller) {
          final selectedIds = controller.value.map((it) => it.id);
          return StreamGalleryPicker(
            selectedMediaItems: selectedIds,
            mediaThumbnailSize: attachmentThumbnailSize,
            mediaThumbnailFormat: attachmentThumbnailFormat,
            mediaThumbnailQuality: attachmentThumbnailQuality,
            mediaThumbnailScale: attachmentThumbnailScale,
            onMediaItemSelected: (media) async {
              if (selectedIds.contains(media.id)) {
                return controller.removeAssetAttachment(media);
              }
              return controller.addAssetAttachment(media);
            },
          );
        },
      ),
      AttachmentPickerOption(
        icon: StreamSvgIcon.files(size: 36).toIconThemeSvgIcon(),
        supportedTypes: [AttachmentPickerType.files],
        optionViewBuilder: (context, controller) {
          return StreamFilePicker(
            onFilePicked: (file) async {
              if (file != null) await controller.addAttachment(file);
              return Navigator.pop(context, controller.value);
            },
          );
        },
      ),
      AttachmentPickerOption(
        icon: StreamSvgIcon.camera(size: 36).toIconThemeSvgIcon(),
        supportedTypes: [AttachmentPickerType.images],
        optionViewBuilder: (context, controller) {
          return StreamImagePicker(
            onImagePicked: (image) async {
              if (image != null) {
                await controller.addAttachment(image);
              }
              return Navigator.pop(context, controller.value);
            },
          );
        },
      ),
      AttachmentPickerOption(
        icon: StreamSvgIcon.record(size: 36).toIconThemeSvgIcon(),
        supportedTypes: [AttachmentPickerType.videos],
        optionViewBuilder: (context, controller) {
          return StreamVideoCapture(
            onVideoCaptured: (video) async {
              if (video != null) {
                await controller.addAttachment(video);
              }
              return Navigator.pop(context, controller.value);
            },
          );
        },
      ),
    ],
  );
}

Widget webOrDesktopAttachmentPickerBuilder({
  required BuildContext context,
  required StreamAttachmentPickerController controller,
  ThumbnailSize attachmentThumbnailSize = const ThumbnailSize(400, 400),
  ThumbnailFormat attachmentThumbnailFormat = ThumbnailFormat.jpeg,
  int attachmentThumbnailQuality = 100,
  double attachmentThumbnailScale = 1,
}) {
  return StreamWebOrDesktopAttachmentPickerBottomSheet(
    controller: controller,
    options: [
      WebOrDesktopAttachmentPickerOption(
        type: AttachmentPickerType.images,
        icon: StreamSvgIcon.pictures(size: 36).toIconThemeSvgIcon(),
        title: 'Upload a photo',
      ),
      WebOrDesktopAttachmentPickerOption(
        type: AttachmentPickerType.videos,
        icon: StreamSvgIcon.videoCall(size: 36).toIconThemeSvgIcon(),
        title: 'Upload a video',
      ),
      WebOrDesktopAttachmentPickerOption(
        type: AttachmentPickerType.files,
        icon: StreamSvgIcon.files(size: 36).toIconThemeSvgIcon(),
        title: 'Upload a file',
      ),
    ],
    onOptionTap: (context, controller, option) async {
      final attachment = await StreamAttachmentHandler.instance.pickFile(
        type: option.type.fileType,
      );
      if (attachment != null) {
        await controller.addAttachment(attachment);
      }
      return Navigator.pop(context, controller.value);
    },
  );
}
