import 'dart:async';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart' show FileType;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/options.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamAttachmentPickerOptionsBuilder}
/// Signature for a function that creates a list of [AttachmentPickerOption]s
/// to be used in the attachment picker.
///
/// The function receives the [BuildContext] and a list of [defaultOptions]
/// that can be modified or extended.
/// {@endtemplate}
typedef AttachmentPickerOptionsBuilder<T extends AttachmentPickerOption> =
    List<T> Function(BuildContext context, List<T> defaultOptions);

/// Inline widget for the system attachment picker interface.
///
/// Shows a list of options that launch native platform dialogs.
/// Selections are applied in real-time via the [controller].
class StreamSystemAttachmentPicker extends StatelessWidget {
  /// Creates a new instance of [StreamSystemAttachmentPicker].
  const StreamSystemAttachmentPicker({
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
        final spacing = context.streamSpacing;
        final enabledTypes = value.filterEnabledTypes(options: options);

        final firstEnabledOption = options.firstWhereOrNull(
          (option) => enabledTypes.any(option.supportedTypes.contains),
        );

        return ListView(
          shrinkWrap: true,
          padding: .symmetric(vertical: spacing.sm, horizontal: spacing.xxs),
          children: [
            ...options.map(
              (option) {
                final supported = option.supportedTypes;
                final isEnabled = enabledTypes.any(supported.contains);

                return StreamListTile(
                  enabled: isEnabled,
                  autofocus: option == firstEnabledOption,
                  leading: Icon(option.icon),
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

// The height of the attachment picker when using the tabbed interface.
const _kTabbedAttachmentPickerHeight = 260.0;

/// Inline widget for the tabbed attachment picker interface.
///
/// Displays a tabbed interface with horizontal tabs for different attachment
/// types (gallery, camera, files, etc.). Each tab shows a specialized
/// interface for selecting that type of attachment.
///
/// Selections are applied in real-time via the [controller] rather than
/// through a modal result pattern.
class StreamTabbedAttachmentPicker extends StatefulWidget {
  /// Creates a new instance of [StreamTabbedAttachmentPicker].
  const StreamTabbedAttachmentPicker({
    super.key,
    required this.options,
    required this.controller,
    this.initialOption,
  });

  /// The list of options.
  final Set<TabbedAttachmentPickerOption> options;

  /// The initial option to be selected.
  final TabbedAttachmentPickerOption? initialOption;

  /// The controller of the attachment picker.
  final StreamAttachmentPickerController controller;

  @override
  State<StreamTabbedAttachmentPicker> createState() => _StreamTabbedAttachmentPickerState();
}

class _StreamTabbedAttachmentPickerState extends State<StreamTabbedAttachmentPicker> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _TabbedAttachmentPickerOptions(
              controller: widget.controller,
              options: widget.options,
              currentOption: _currentOption,
              onOptionSelected: (option) async {
                setState(() => _currentOption = option);
              },
            ),
            Semantics(
              role: SemanticsRole.tabPanel,
              child: SizedBox(
                height: _kTabbedAttachmentPickerHeight,
                child: _currentOption.optionViewBuilder(
                  context,
                  widget.controller,
                ),
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
  });

  final Iterable<TabbedAttachmentPickerOption> options;
  final TabbedAttachmentPickerOption currentOption;
  final StreamAttachmentPickerController controller;
  final ValueSetter<TabbedAttachmentPickerOption>? onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final localizations = MaterialLocalizations.of(context);
    final optionsList = options.toList();

    return ValueListenableBuilder<AttachmentPickerValue>(
      valueListenable: controller,
      builder: (context, value, __) {
        final enabledTypes = value.filterEnabledTypes(options: optionsList);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            role: SemanticsRole.tabBar,
            child: Row(
              spacing: spacing.xxxs,
              children: [
                ...options.mapIndexed(
                  (index, option) {
                    final supported = option.supportedTypes;
                    // An option with no supportedTypes is always enabled.
                    final isEnabled = supported.isEmpty || enabledTypes.any(supported.contains);
                    final isSelected = option == currentOption;

                    final onPressed = switch (isEnabled) {
                      true => () => onOptionSelected?.call(option),
                      _ => null,
                    };

                    return MergeSemantics(
                      child: Semantics(
                        label: option.title,
                        selected: isSelected,
                        role: SemanticsRole.tab,
                        child: Stack(
                          children: [
                            Tooltip(
                              message: option.title,
                              excludeFromSemantics: true,
                              child: StreamButton.icon(
                                style: StreamButtonStyle.secondary,
                                type: StreamButtonType.ghost,
                                size: StreamButtonSize.large,
                                onPressed: onPressed,
                                isSelected: isSelected,
                                autofocus: isSelected,
                                icon: Icon(option.icon),
                              ),
                            ),
                            Semantics(
                              label: localizations.tabLabel(
                                tabIndex: index + 1,
                                tabCount: optionsList.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Signature used by [EndOfFrameCallbackWidget.errorBuilder] to build a
/// replacement widget when [EndOfFrameCallbackWidget.onEndOfFrame] throws.
typedef EndOfFrameCallbackErrorWidgetBuilder =
    Widget Function(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    );

/// Signature for callbacks invoked by [EndOfFrameCallbackWidget] once the
/// first frame has been rendered.
typedef EndOfFrameCallback = FutureOr<void> Function(BuildContext context);

/// A widget that invokes [onEndOfFrame] once after the first frame has been
/// rendered.
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

  /// Called once after the first frame has been rendered.
  final EndOfFrameCallback onEndOfFrame;

  /// Called to build a replacement widget when [onEndOfFrame] throws.
  ///
  /// If null, [child] is shown when [onEndOfFrame] throws and the error is
  /// forwarded to [FlutterError.reportError] so it remains visible in the
  /// console and to any error handlers registered by the host app (e.g.
  /// Crashlytics, Sentry).
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
      if (!mounted) return;
      try {
        await widget.onEndOfFrame(context);
      } catch (error, stackTrace) {
        if (!mounted) return;
        // When no errorBuilder is provided we fall back to [child], so the
        // error is otherwise invisible. Forward it through Flutter's error
        // plumbing once so host apps (Crashlytics / Sentry / console) still
        // see it. When an errorBuilder is provided, caller owns presentation.
        if (widget.errorBuilder == null) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: stackTrace,
              library: 'stream_chat_flutter',
              context: ErrorDescription('EndOfFrameCallbackWidget.onEndOfFrame threw; falling back to child'),
            ),
          );
        }
        setState(() {
          _error = error;
          _stackTrace = stackTrace;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error case final error?) {
      if (widget.errorBuilder case final errorBuilder?) {
        return errorBuilder(context, error, _stackTrace);
      }
    }
    return widget.child ?? const Empty();
  }
}

/// A widget that will be shown in the attachment picker.
/// It can be used to show a custom view for each attachment picker option.
class OptionDrawer extends StatelessWidget {
  /// Creates a widget that will be shown in the attachment picker.
  const OptionDrawer({
    super.key,
    required this.child,
    this.margin,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The margin of the options card.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final effectiveMargin = margin ?? .symmetric(horizontal: spacing.md, vertical: spacing.xxxl);

    return Container(
      margin: effectiveMargin,
      child: child,
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
/// Selections are applied in real-time via the [controller].
///
/// The [onError] callback is invoked when an error occurs during attachment
/// selection (e.g., file too large or attachment limit reached).
///
/// The [onPollCreated] callback is invoked when a poll is created, allowing
/// the caller to handle poll-specific logic.
Widget tabbedAttachmentPickerBuilder({
  required BuildContext context,
  required StreamAttachmentPickerController controller,
  PollConfig? pollConfig,
  GalleryPickerConfig? galleryPickerConfig,
  List<AttachmentPickerType> allowedTypes = AttachmentPickerType.values,
  AttachmentPickerOptionsBuilder? optionsBuilder,
  ValueSetter<AttachmentPickerError>? onError,
  ValueSetter<Poll>? onPollCreated,
  CommandValidator? commandValidator,
  ValueSetter<Command>? onCommandSelected,
}) {
  final defaultOptions = <TabbedAttachmentPickerOption>[
    TabbedAttachmentPickerOption(
      key: 'gallery-picker',
      icon: context.streamIcons.image,
      title: context.translations.photosAndVideosLabel,
      supportedTypes: [
        AttachmentPickerType.images,
        AttachmentPickerType.videos,
      ],
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
              onError?.call(
                AttachmentPickerError(error: e, stackTrace: stk),
              );
            }
          },
        );
      },
    ),
    TabbedAttachmentPickerOption(
      key: 'image-picker',
      icon: context.streamIcons.camera,
      title: context.translations.photoFromCameraLabel,
      supportedTypes: [AttachmentPickerType.images],
      optionViewBuilder: (context, controller) => StreamImagePicker(
        onImagePicked: (image) async {
          try {
            if (image != null) await controller.addAttachment(image);
          } catch (e, stk) {
            onError?.call(
              AttachmentPickerError(error: e, stackTrace: stk),
            );
          }
        },
      ),
    ),
    TabbedAttachmentPickerOption(
      key: 'video-picker',
      icon: context.streamIcons.video,
      title: context.translations.videoFromCameraLabel,
      supportedTypes: [AttachmentPickerType.videos],
      optionViewBuilder: (context, controller) => StreamVideoPicker(
        onVideoPicked: (video) async {
          try {
            if (video != null) await controller.addAttachment(video);
          } catch (e, stk) {
            onError?.call(
              AttachmentPickerError(error: e, stackTrace: stk),
            );
          }
        },
      ),
    ),
    TabbedAttachmentPickerOption(
      key: 'file-picker',
      icon: context.streamIcons.file,
      title: context.translations.uploadAFileLabel,
      supportedTypes: [AttachmentPickerType.files],
      optionViewBuilder: (context, controller) => StreamFilePicker(
        onFilePicked: (file) async {
          try {
            if (file != null) await controller.addAttachment(file);
          } catch (e, stk) {
            onError?.call(
              AttachmentPickerError(error: e, stackTrace: stk),
            );
          }
        },
      ),
    ),
    TabbedAttachmentPickerOption(
      key: 'poll-creator',
      icon: context.streamIcons.poll,
      title: context.translations.createPollLabel(isNew: true),
      supportedTypes: [AttachmentPickerType.poll],
      optionViewBuilder: (context, controller) {
        final initialPoll = controller.value.poll;
        return StreamPollCreator(
          poll: initialPoll,
          config: pollConfig,
          onPollCreated: (poll) {
            if (poll == null) return;
            controller.poll = poll;
            onPollCreated?.call(poll);
          },
        );
      },
    ),
    TabbedAttachmentPickerOption(
      key: 'command-picker',
      icon: context.streamIcons.command,
      title: context.translations.instantCommandsLabel,
      supportedTypes: [AttachmentPickerType.command],
      optionViewBuilder: (context, controller) => StreamCommandPicker(
        commandValidator: commandValidator,
        onCommandSelected: onCommandSelected,
      ),
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

  return StreamTabbedAttachmentPicker(
    controller: controller,
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
/// Selections are applied in real-time via the [controller].
///
/// The [onError] callback is invoked when an error occurs during attachment
/// selection.
///
/// The [onPollCreated] callback is invoked when a poll is created.
Widget systemAttachmentPickerBuilder({
  required BuildContext context,
  required StreamAttachmentPickerController controller,
  PollConfig? pollConfig = const PollConfig(),
  GalleryPickerConfig? galleryPickerConfig = const GalleryPickerConfig(),
  List<AttachmentPickerType> allowedTypes = AttachmentPickerType.values,
  AttachmentPickerOptionsBuilder? optionsBuilder,
  ValueSetter<AttachmentPickerError>? onError,
  ValueSetter<Poll>? onPollCreated,
}) {
  Future<void> pickSystemFile(
    StreamAttachmentPickerController controller,
    FileType type,
  ) async {
    try {
      final file = await StreamAttachmentHandler.instance.pickFile(type: type);
      if (file != null) await controller.addAttachment(file);
    } catch (e, stk) {
      onError?.call(AttachmentPickerError(error: e, stackTrace: stk));
    }
  }

  final defaultOptions = <SystemAttachmentPickerOption>[
    SystemAttachmentPickerOption(
      key: 'image-picker',
      supportedTypes: [AttachmentPickerType.images],
      icon: context.streamIcons.image,
      title: context.translations.uploadAPhotoLabel,
      onTap: (context, controller) async {
        await pickSystemFile(controller, FileType.image);
      },
    ),
    SystemAttachmentPickerOption(
      key: 'video-picker',
      supportedTypes: [AttachmentPickerType.videos],
      icon: context.streamIcons.video,
      title: context.translations.uploadAVideoLabel,
      onTap: (context, controller) async {
        await pickSystemFile(controller, FileType.video);
      },
    ),
    SystemAttachmentPickerOption(
      key: 'file-picker',
      supportedTypes: [AttachmentPickerType.files],
      icon: context.streamIcons.file,
      title: context.translations.uploadAFileLabel,
      onTap: (context, controller) async {
        await pickSystemFile(controller, FileType.any);
      },
    ),
    SystemAttachmentPickerOption(
      key: 'poll-creator',
      supportedTypes: [AttachmentPickerType.poll],
      icon: context.streamIcons.poll,
      title: context.translations.createPollLabel(isNew: true),
      onTap: (context, controller) async {
        final initialPoll = controller.value.poll;
        final poll = await showStreamPollCreatorSheet(
          context: context,
          poll: initialPoll,
          config: pollConfig,
        );

        if (poll == null) return;
        controller.poll = poll;
        onPollCreated?.call(poll);
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

  return StreamSystemAttachmentPicker(
    controller: controller,
    options: {
      ...validOptions.where(
        (option) => option.supportedTypes.every(allowedTypes.contains),
      ),
    },
  );
}
