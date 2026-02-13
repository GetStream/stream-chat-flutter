import 'dart:async';

import 'package:file_picker/file_picker.dart' show FileType;
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/options.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Bottom sheet widget for the system attachment picker interface.
/// This is used when the attachment picker uses system integration,
/// typically on web/desktop or when useSystemAttachmentPicker is true.
class StreamSystemAttachmentPickerBottomSheet extends StatelessWidget {
  /// Creates a new instance of [StreamSystemAttachmentPickerBottomSheet].
  const StreamSystemAttachmentPickerBottomSheet({
    super.key,
    required this.options,
    required this.controller,
  });

  /// The list of options.
  final Set<SystemAttachmentPickerOption> options;

  /// The controller of the attachment picker.
  final StreamAttachmentPickerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        final enabledTypes = value.filterEnabledTypes(options: options);

        return ListView(
          shrinkWrap: true,
          children: [
            ...options.map(
              (option) {
                final supported = option.supportedTypes;
                final isEnabled = enabledTypes.any(supported.contains);

                return ListTile(
                  enabled: isEnabled,
                  leading: option.icon,
                  title: Text(option.title),
                  onTap: () => option.onTap(context, controller),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

/// Bottom sheet widget for the tabbed attachment picker interface.
/// This is used when the attachment picker displays a tabbed interface,
/// typically on mobile when useSystemAttachmentPicker is false.
class StreamTabbedAttachmentPickerBottomSheet extends StatefulWidget {
  /// Creates a new instance of [StreamTabbedAttachmentPickerBottomSheet].
  const StreamTabbedAttachmentPickerBottomSheet({
    super.key,
    required this.options,
    required this.controller,
    this.initialOption,
    this.onSendValue,
  });

  /// The list of options.
  final Set<TabbedAttachmentPickerOption> options;

  /// The initial option to be selected.
  final TabbedAttachmentPickerOption? initialOption;

  /// The controller of the attachment picker.
  final StreamAttachmentPickerController controller;

  /// The callback when the send button gets tapped.
  final ValueSetter<StreamAttachmentPickerResult>? onSendValue;

  @override
  State<StreamTabbedAttachmentPickerBottomSheet> createState() => _StreamTabbedAttachmentPickerBottomSheetState();
}

class _StreamTabbedAttachmentPickerBottomSheetState extends State<StreamTabbedAttachmentPickerBottomSheet> {
  // The current option selected in the tabbed attachment picker.
  late var _currentOption = _calculateInitialOption();
  TabbedAttachmentPickerOption _calculateInitialOption() {
    if (widget.initialOption case final option?) return option;

    final options = widget.options;
    final currentValue = widget.controller.value;
    final enabledTypes = currentValue.filterEnabledTypes(options: options);

    if (enabledTypes.isEmpty) return options.first;

    return options.firstWhere(
      (it) => enabledTypes.any(it.supportedTypes.contains),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AttachmentPickerValue>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _TabbedAttachmentPickerOptions(
              controller: widget.controller,
              options: widget.options,
              currentOption: _currentOption,
              onSendValue: widget.onSendValue,
              onOptionSelected: (option) async {
                setState(() => _currentOption = option);
              },
            ),
            Expanded(
              child: _currentOption.optionViewBuilder(
                context,
                widget.controller,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TabbedAttachmentPickerOptions extends StatelessWidget {
  const _TabbedAttachmentPickerOptions({
    required this.options,
    required this.currentOption,
    required this.controller,
    this.onOptionSelected,
    this.onSendValue,
  });

  final Iterable<TabbedAttachmentPickerOption> options;
  final TabbedAttachmentPickerOption currentOption;
  final StreamAttachmentPickerController controller;
  final ValueSetter<TabbedAttachmentPickerOption>? onOptionSelected;
  final ValueSetter<StreamAttachmentPickerResult>? onSendValue;

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    return ValueListenableBuilder<AttachmentPickerValue>(
      valueListenable: controller,
      builder: (context, value, __) {
        final enabledTypes = value.filterEnabledTypes(options: options);

        return Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...options.map(
                      (option) {
                        final supported = option.supportedTypes;
                        final isEnabled = enabledTypes.any(supported.contains);
                        final isSelected = option == currentOption;

                        final color = switch (isSelected) {
                          true => colorTheme.accentPrimary,
                          _ => colorTheme.textLowEmphasis,
                        };

                        final onPressed = switch (isEnabled) {
                          true => () => onOptionSelected?.call(option),
                          _ => null,
                        };

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
                final initialValue = controller.initialValue;
                final isValueChanged = value != initialValue;

                final onPressed = switch (onSendValue) {
                  final onSendValue? when isValueChanged => () {
                    final result = AttachmentsPicked(
                      attachments: value.attachments,
                    );
                    return onSendValue(result);
                  },
                  _ => null,
                };

                return IconButton(
                  color: colorTheme.accentPrimary,
                  disabledColor: colorTheme.disabled,
                  icon: const StreamSvgIcon(
                    icon: StreamSvgIcons.emptyCircleRight,
                  ),
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
typedef EndOfFrameCallbackErrorWidgetBuilder =
    Widget Function(
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
  State<EndOfFrameCallbackWidget> createState() => _EndOfFrameCallbackWidgetState();
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

    return widget.child ?? const Empty();
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

    final leading = title ?? const Empty();

    Widget trailing;
    if (actions.isNotEmpty) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: actions,
      );
    } else {
      trailing = const Empty();
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

/// Builds a tabbed attachment picker with custom interfaces for different
/// attachment types.
///
/// Shows horizontal tabs for gallery, files, camera, video, and polls. Each
/// tab displays a specialized interface for selecting that type of
/// attachment. Tabs get enabled or disabled based on what you've already
/// selected.
///
/// This is the default interface for mobile platforms. Configure with
/// [customOptions], [galleryPickerConfig], [pollConfig], and
/// [allowedTypes].
Widget tabbedAttachmentPickerBuilder({
  required BuildContext context,
  required StreamAttachmentPickerController controller,
  PollConfig? pollConfig,
  GalleryPickerConfig? galleryPickerConfig,
  List<AttachmentPickerType> allowedTypes = AttachmentPickerType.values,
  AttachmentPickerOptionsBuilder? optionsBuilder,
}) {
  Future<StreamAttachmentPickerResult> _handleSingePick(
    StreamAttachmentPickerController controller,
    Attachment? attachment,
  ) async {
    try {
      if (attachment != null) await controller.addAttachment(attachment);
      return AttachmentsPicked(attachments: controller.value.attachments);
    } catch (error, stk) {
      return AttachmentPickerError(error: error, stackTrace: stk);
    }
  }

  final defaultOptions = <TabbedAttachmentPickerOption>[
    TabbedAttachmentPickerOption(
      key: 'gallery-picker',
      icon: const StreamSvgIcon(icon: StreamSvgIcons.pictures),
      supportedTypes: [
        AttachmentPickerType.images,
        AttachmentPickerType.videos,
      ],
      isEnabled: (value) => true,
      optionViewBuilder: (context, controller) {
        final attachment = controller.value.attachments;
        final selectedIds = attachment.map((it) => it.id);
        return StreamGalleryPicker(
          config: galleryPickerConfig,
          selectedMediaItems: selectedIds,
          onMediaItemSelected: (media) async {
            try {
              if (selectedIds.contains(media.id)) {
                return await controller.removeAssetAttachment(media);
              }
              return await controller.addAssetAttachment(media);
            } catch (e, stk) {
              final err = AttachmentPickerError(error: e, stackTrace: stk);
              return Navigator.pop(context, err);
            }
          },
        );
      },
    ),
    TabbedAttachmentPickerOption(
      key: 'file-picker',
      icon: const StreamSvgIcon(icon: StreamSvgIcons.files),
      supportedTypes: [AttachmentPickerType.files],
      optionViewBuilder: (context, controller) => StreamFilePicker(
        onFilePicked: (file) async {
          final result = await _handleSingePick(controller, file);
          return Navigator.pop(context, result);
        },
      ),
    ),
    TabbedAttachmentPickerOption(
      key: 'image-picker',
      icon: const StreamSvgIcon(icon: StreamSvgIcons.camera),
      supportedTypes: [AttachmentPickerType.images],
      optionViewBuilder: (context, controller) => StreamImagePicker(
        onImagePicked: (image) async {
          final result = await _handleSingePick(controller, image);
          return Navigator.pop(context, result);
        },
      ),
    ),
    TabbedAttachmentPickerOption(
      key: 'video-picker',
      icon: const StreamSvgIcon(icon: StreamSvgIcons.record),
      supportedTypes: [AttachmentPickerType.videos],
      optionViewBuilder: (context, controller) => StreamVideoPicker(
        onVideoPicked: (video) async {
          final result = await _handleSingePick(controller, video);
          return Navigator.pop(context, result);
        },
      ),
    ),
    TabbedAttachmentPickerOption(
      key: 'poll-creator',
      icon: const StreamSvgIcon(icon: StreamSvgIcons.polls),
      supportedTypes: [AttachmentPickerType.poll],
      optionViewBuilder: (context, controller) {
        final initialPoll = controller.value.poll;
        return StreamPollCreator(
          poll: initialPoll,
          config: pollConfig,
          onPollCreated: (poll) {
            if (poll == null) return Navigator.pop(context);
            controller.poll = poll;

            final result = PollCreated(poll: poll);
            return Navigator.pop(context, result);
          },
        );
      },
    ),
  ];

  final allOptions = switch (optionsBuilder) {
    final builder? => builder(context, defaultOptions),
    _ => defaultOptions,
  };

  final validOptions = allOptions.whereType<TabbedAttachmentPickerOption>();

  if (validOptions.length < allOptions.length) {
    throw ArgumentError(
      'custom options must be of type TabbedAttachmentPickerOption when using '
      'the tabbed attachment picker (default on mobile).',
    );
  }

  return StreamTabbedAttachmentPickerBottomSheet(
    controller: controller,
    onSendValue: Navigator.of(context).pop,
    options: {
      ...validOptions.where(
        (option) => option.supportedTypes.every(allowedTypes.contains),
      ),
    },
  );
}

/// Builds a system attachment picker that opens native platform dialogs.
///
/// Shows a simple list of options that immediately launch your device's
/// built-in file browser, camera app, or other native tools instead of
/// custom interfaces.
///
/// This is the default for web and desktop platforms, and can be enabled on
/// mobile with `useSystemAttachmentPicker`. Configure with [customOptions],
/// [pollConfig], and [allowedTypes].
Widget systemAttachmentPickerBuilder({
  required BuildContext context,
  required StreamAttachmentPickerController controller,
  PollConfig? pollConfig = const PollConfig(),
  GalleryPickerConfig? galleryPickerConfig = const GalleryPickerConfig(),
  List<AttachmentPickerType> allowedTypes = AttachmentPickerType.values,
  AttachmentPickerOptionsBuilder? optionsBuilder,
}) {
  Future<StreamAttachmentPickerResult> _pickSystemFile(
    StreamAttachmentPickerController controller,
    FileType type,
  ) async {
    try {
      final file = await StreamAttachmentHandler.instance.pickFile(type: type);
      if (file != null) await controller.addAttachment(file);

      return AttachmentsPicked(attachments: controller.value.attachments);
    } catch (error, stk) {
      return AttachmentPickerError(error: error, stackTrace: stk);
    }
  }

  final defaultOptions = <SystemAttachmentPickerOption>[
    SystemAttachmentPickerOption(
      key: 'image-picker',
      supportedTypes: [AttachmentPickerType.images],
      icon: const StreamSvgIcon(icon: StreamSvgIcons.pictures),
      title: context.translations.uploadAPhotoLabel,
      onTap: (context, controller) async {
        final result = await _pickSystemFile(controller, FileType.image);
        return Navigator.pop(context, result);
      },
    ),
    SystemAttachmentPickerOption(
      key: 'video-picker',
      supportedTypes: [AttachmentPickerType.videos],
      icon: const StreamSvgIcon(icon: StreamSvgIcons.record),
      title: context.translations.uploadAVideoLabel,
      onTap: (context, controller) async {
        final result = await _pickSystemFile(controller, FileType.video);
        return Navigator.pop(context, result);
      },
    ),
    SystemAttachmentPickerOption(
      key: 'file-picker',
      supportedTypes: [AttachmentPickerType.files],
      icon: const StreamSvgIcon(icon: StreamSvgIcons.files),
      title: context.translations.uploadAFileLabel,
      onTap: (context, controller) async {
        final result = await _pickSystemFile(controller, FileType.any);
        return Navigator.pop(context, result);
      },
    ),
    SystemAttachmentPickerOption(
      key: 'poll-creator',
      supportedTypes: [AttachmentPickerType.poll],
      icon: const StreamSvgIcon(icon: StreamSvgIcons.polls),
      title: context.translations.createPollLabel(isNew: true),
      onTap: (context, controller) async {
        final initialPoll = controller.value.poll;
        final poll = await showStreamPollCreatorDialog(
          context: context,
          poll: initialPoll,
          config: pollConfig,
        );

        if (poll == null) return Navigator.pop(context);
        controller.poll = poll;

        final result = PollCreated(poll: poll);
        return Navigator.pop(context, result);
      },
    ),
  ];

  final allOptions = switch (optionsBuilder) {
    final builder? => builder(context, defaultOptions),
    _ => defaultOptions,
  };

  final validOptions = allOptions.whereType<SystemAttachmentPickerOption>();

  if (validOptions.length < allOptions.length) {
    throw ArgumentError(
      'custom options must be of type SystemAttachmentPickerOption when using '
      'the system attachment picker (enabled explicitly or on web/desktop).',
    );
  }

  return StreamSystemAttachmentPickerBottomSheet(
    controller: controller,
    options: {
      ...validOptions.where(
        (option) => option.supportedTypes.every(allowedTypes.contains),
      ),
    },
  );
}
