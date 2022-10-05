import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/options.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The default maximum size for media attachments.
const kDefaultMaxAttachmentSize = 100 * 1024 * 1024; // 100MB in Bytes

/// The default maximum number of media attachments.
const kDefaultMaxAttachmentCount = 10;

/// Controller class for [StreamAttachmentPicker].
class StreamAttachmentPickerController extends ValueNotifier<List<Attachment>> {
  /// Creates a new instance of [StreamAttachmentPickerController].
  StreamAttachmentPickerController({
    this.initialAttachments,
    this.maxAttachmentSize = kDefaultMaxAttachmentSize,
    this.maxAttachmentCount = kDefaultMaxAttachmentCount,
  })  : assert(
          (initialAttachments?.length ?? 0) <= maxAttachmentCount,
          '''The initial attachments count must be less than or equal to maxAttachmentCount''',
        ),
        super(initialAttachments ?? const []);

  /// The max attachment size allowed in bytes.
  final int maxAttachmentSize;

  /// The max attachment count allowed.
  final int maxAttachmentCount;

  /// The initial attachments.
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

/// Function signature for building the attachment picker option view.
typedef AttachmentPickerOptionViewBuilder = Widget Function(
  BuildContext context,
  StreamAttachmentPickerController controller,
);

/// Model class for the attachment picker options.
class AttachmentPickerOption {
  /// Creates a new instance of [AttachmentPickerOption].
  const AttachmentPickerOption({
    this.key,
    required this.supportedTypes,
    required this.icon,
    this.title,
    this.optionViewBuilder,
  });

  /// A key to identify the option.
  final String? key;

  /// The icon of the option.
  final Widget icon;

  /// The title of the option.
  final String? title;

  /// The supported types of the option.
  final Iterable<AttachmentPickerType> supportedTypes;

  /// The option view builder.
  final AttachmentPickerOptionViewBuilder? optionViewBuilder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentPickerOption &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          const IterableEquality().equals(supportedTypes, other.supportedTypes);

  @override
  int get hashCode =>
      key.hashCode ^ const IterableEquality().hash(supportedTypes);
}

/// The attachment picker option for the web or desktop platforms.
class WebOrDesktopAttachmentPickerOption extends AttachmentPickerOption {
  /// Creates a new instance of [WebOrDesktopAttachmentPickerOption].
  WebOrDesktopAttachmentPickerOption({
    super.key,
    required AttachmentPickerType type,
    required super.icon,
    required super.title,
  }) : super(supportedTypes: [type]);

  /// Creates a new instance of [WebOrDesktopAttachmentPickerOption] from
  /// [option].
  factory WebOrDesktopAttachmentPickerOption.fromAttachmentPickerOption(
    AttachmentPickerOption option,
  ) {
    return WebOrDesktopAttachmentPickerOption(
      key: option.key,
      type: option.supportedTypes.first,
      icon: option.icon,
      title: option.title,
    );
  }

  @override
  String get title => super.title!;

  /// Type of the option.
  AttachmentPickerType get type => supportedTypes.first;
}

/// Helpful extensions for [StreamAttachmentPickerController].
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

  /// Returns the list of enabled picker types.
  Set<AttachmentPickerType> filterEnabledTypes({
    required Iterable<AttachmentPickerOption> options,
  }) {
    final availableTypes = currentAttachmentPickerTypes;
    final enabledTypes = <AttachmentPickerType>{};
    for (final option in options) {
      final supportedTypes = option.supportedTypes;
      if (availableTypes.any(supportedTypes.contains)) {
        enabledTypes.addAll(supportedTypes);
      }
    }
    return enabledTypes;
  }

  /// Returns true if the [initialAttachments] are changed.
  bool get isValueChanged {
    final isEqual = UnorderedIterableEquality(
      EqualityBy((Attachment attachment) => attachment.id),
    ).equals(value, initialAttachments);

    return !isEqual;
  }
}

/// Function signature for the callback when the web or desktop attachment
/// picker option gets tapped.
typedef OnWebOrDesktopAttachmentPickerOptionTap = void Function(
  BuildContext context,
  StreamAttachmentPickerController controller,
  WebOrDesktopAttachmentPickerOption option,
);

/// Bottom sheet widget for the web or desktop version of the attachment picker.
class StreamWebOrDesktopAttachmentPickerBottomSheet extends StatelessWidget {
  /// Creates a new instance of [StreamWebOrDesktopAttachmentPickerBottomSheet].
  const StreamWebOrDesktopAttachmentPickerBottomSheet({
    super.key,
    required this.options,
    required this.controller,
    this.onOptionTap,
  });

  /// The list of options.
  final Set<WebOrDesktopAttachmentPickerOption> options;

  /// The controller of the attachment picker.
  final StreamAttachmentPickerController controller;

  /// The callback when the option gets tapped.
  final OnWebOrDesktopAttachmentPickerOptionTap? onOptionTap;

  @override
  Widget build(BuildContext context) {
    final enabledTypes = controller.filterEnabledTypes(options: options);
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

          final enabled = enabledTypes.isEmpty ||
              enabledTypes.any((it) => it == option.type);

          return ListTile(
            enabled: enabled,
            leading: option.icon,
            title: Text(option.title),
            onTap: onOptionTap,
          );
        }),
      ],
    );
  }
}

/// Bottom sheet widget for the mobile version of the  attachment picker.
class StreamMobileAttachmentPickerBottomSheet extends StatefulWidget {
  /// Creates a new instance of [StreamMobileAttachmentPickerBottomSheet].
  const StreamMobileAttachmentPickerBottomSheet({
    super.key,
    required this.options,
    required this.controller,
    this.initialOption,
    this.onSendAttachments,
  });

  /// The list of options.
  final Set<AttachmentPickerOption> options;

  /// The initial option to be selected.
  final AttachmentPickerOption? initialOption;

  /// The controller of the attachment picker.
  final StreamAttachmentPickerController controller;

  /// The callback when the send button gets tapped.
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
    if (widget.initialOption == null) {
      final enabledTypes = widget.controller.filterEnabledTypes(
        options: widget.options,
      );
      if (enabledTypes.isNotEmpty) {
        _currentOption = widget.options.firstWhere((it) {
          return it.supportedTypes.contains(enabledTypes.first);
        });
      } else {
        _currentOption = widget.options.first;
      }
    } else {
      _currentOption = widget.initialOption!;
    }
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

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    return ValueListenableBuilder<List<Attachment>>(
      valueListenable: controller,
      builder: (context, attachments, __) {
        final enabledTypes = controller.filterEnabledTypes(options: options);
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
                    onSendAttachment != null && controller.isValueChanged;

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

/// Function signature for a callback that is called when the end of the frame
/// is reached.
typedef EndOfFrameCallback = FutureOr<void> Function(BuildContext context);

/// A widget that calls the given [callback] when the end of the frame is
/// reached.
class EndOfFrameCallbackWidget extends StatefulWidget {
  /// Creates a new instance of [EndOfFrameCallbackWidget].
  const EndOfFrameCallbackWidget({
    super.key,
    required this.onEndOfFrame,
    this.child,
    this.errorBuilder,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The callback that is called when the end of the frame is reached.x
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

/// Returns the mobile version of the attachment picker.
Widget mobileAttachmentPickerBuilder({
  required BuildContext context,
  required StreamAttachmentPickerController controller,
  Iterable<AttachmentPickerOption>? customOptions,
  ThumbnailSize attachmentThumbnailSize = const ThumbnailSize(400, 400),
  ThumbnailFormat attachmentThumbnailFormat = ThumbnailFormat.jpeg,
  int attachmentThumbnailQuality = 100,
  double attachmentThumbnailScale = 1,
}) {
  return StreamMobileAttachmentPickerBottomSheet(
    controller: controller,
    onSendAttachments: Navigator.of(context).pop,
    options: {
      if (customOptions != null) ...customOptions,
      AttachmentPickerOption(
        key: 'gallery-picker',
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
        key: 'file-picker',
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
        key: 'image-picker',
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
        key: 'video-picker',
        icon: StreamSvgIcon.record(size: 36).toIconThemeSvgIcon(),
        supportedTypes: [AttachmentPickerType.videos],
        optionViewBuilder: (context, controller) {
          return StreamVideoPicker(
            onVideoPicked: (video) async {
              if (video != null) {
                await controller.addAttachment(video);
              }
              return Navigator.pop(context, controller.value);
            },
          );
        },
      ),
    },
  );
}

/// Returns the web or desktop version of the attachment picker.
Widget webOrDesktopAttachmentPickerBuilder({
  required BuildContext context,
  required StreamAttachmentPickerController controller,
  Iterable<WebOrDesktopAttachmentPickerOption>? customOptions,
  ThumbnailSize attachmentThumbnailSize = const ThumbnailSize(400, 400),
  ThumbnailFormat attachmentThumbnailFormat = ThumbnailFormat.jpeg,
  int attachmentThumbnailQuality = 100,
  double attachmentThumbnailScale = 1,
}) {
  return StreamWebOrDesktopAttachmentPickerBottomSheet(
    controller: controller,
    options: {
      if (customOptions != null) ...customOptions,
      WebOrDesktopAttachmentPickerOption(
        key: 'image-picker',
        type: AttachmentPickerType.images,
        icon: StreamSvgIcon.pictures(size: 36).toIconThemeSvgIcon(),
        title: 'Upload a photo',
      ),
      WebOrDesktopAttachmentPickerOption(
        key: 'video-picker',
        type: AttachmentPickerType.videos,
        icon: StreamSvgIcon.record(size: 36).toIconThemeSvgIcon(),
        title: 'Upload a video',
      ),
      WebOrDesktopAttachmentPickerOption(
        key: 'file-picker',
        type: AttachmentPickerType.files,
        icon: StreamSvgIcon.files(size: 36).toIconThemeSvgIcon(),
        title: 'Upload a file',
      ),
    },
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
