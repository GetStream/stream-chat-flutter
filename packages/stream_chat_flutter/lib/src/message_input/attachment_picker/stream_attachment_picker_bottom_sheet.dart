import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_gallery_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Shows a modal bottom sheet with the Stream attachment picker.
///
/// The picker supports two modes:
///
/// - **Tabbed interface**: Typically used on mobile platforms. Provide
///   [TabbedAttachmentPickerOption] values in [customOptions]. This mode is
///   active when [useSystemAttachmentPicker] is false (default).
///
/// - **System integration**: Used on web, desktop, or when
///   [useSystemAttachmentPicker] is true. Provide
///   [SystemAttachmentPickerOption] values in [customOptions].
///
/// When using the system picker, all [customOptions] must be
/// [SystemAttachmentPickerOption] instances. If any other type is included,
/// an [ArgumentError] is thrown.
///
/// Example using the tabbed interface:
/// ```dart
/// showStreamAttachmentPickerModalBottomSheet(
///   context: context,
///   customOptions: [
///     TabbedAttachmentPickerOption(
///       key: 'gallery',
///       icon: Icon(Icons.photo),
///       supportedTypes: [AttachmentPickerType.images],
///       optionViewBuilder: (context, controller) {
///         return CustomGalleryWidget();
///       },
///     ),
///   ],
/// );
/// ```
///
/// Example using the system picker:
/// ```dart
/// showStreamAttachmentPickerModalBottomSheet(
///   context: context,
///   useSystemAttachmentPicker: true,
///   customOptions: [
///     SystemAttachmentPickerOption(
///       key: 'upload',
///       type: AttachmentPickerType.files,
///       icon: Icon(Icons.upload_file),
///       title: 'Upload File',
///       onTap: (context, controller) async {
///         // Handle file picker
///       },
///     ),
///   ],
/// );
/// ```
///
/// Returns a [Future] that completes with the value passed to [Navigator.pop],
/// or `null` if the sheet was dismissed.
Future<T?> showStreamAttachmentPickerModalBottomSheet<T>({
  required BuildContext context,
  Iterable<AttachmentPickerOption>? customOptions,
  List<AttachmentPickerType> allowedTypes = AttachmentPickerType.values,
  Poll? initialPoll,
  PollConfig? pollConfig,
  GalleryPickerConfig? galleryPickerConfig,
  List<Attachment>? initialAttachments,
  Map<String, Object?>? initialExtraData,
  StreamAttachmentPickerController? controller,
  Color? backgroundColor,
  double? elevation,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useSystemAttachmentPicker = false,
  @Deprecated("Use 'useSystemAttachmentPicker' instead.")
  bool useNativeAttachmentPickerOnMobile = false,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Clip? clipBehavior = Clip.hardEdge,
  ShapeBorder? shape,
}) {
  final colorTheme = StreamChatTheme.of(context).colorTheme;
  final color = backgroundColor ?? colorTheme.inputBg;

  return showModalBottomSheet(
    context: context,
    backgroundColor: color,
    elevation: elevation,
    shape: shape,
    clipBehavior: clipBehavior,
    constraints: constraints,
    barrierColor: barrierColor,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    routeSettings: routeSettings,
    transitionAnimationController: transitionAnimationController,
    builder: (BuildContext context) {
      return StreamAttachmentPickerBottomSheetBuilder(
        controller: controller,
        initialPoll: initialPoll,
        initialAttachments: initialAttachments,
        initialExtraData: initialExtraData,
        builder: (context, controller, child) {
          final isWebOrDesktop = switch (CurrentPlatform.type) {
            PlatformType.android || PlatformType.ios => false,
            _ => true,
          };

          final useSystemPicker = useSystemAttachmentPicker || isWebOrDesktop;

          if (useSystemPicker) {
            final invalidOptions = <AttachmentPickerOption>[];
            final customSystemOptions = <SystemAttachmentPickerOption>[];

            for (final option in customOptions ?? <AttachmentPickerOption>[]) {
              if (option is SystemAttachmentPickerOption) {
                customSystemOptions.add(option);
              } else {
                invalidOptions.add(option);
              }
            }

            if (invalidOptions.isNotEmpty) {
              throw ArgumentError(
                'customOptions must be SystemAttachmentPickerOption when using '
                'the attachment picker (enabled explicitly or on web/desktop).',
              );
            }

            return systemAttachmentPickerBuilder.call(
              context: context,
              controller: controller,
              allowedTypes: allowedTypes,
              customOptions: customSystemOptions,
              pollConfig: pollConfig,
              galleryPickerConfig: galleryPickerConfig,
            );
          }

          final invalidOptions = <AttachmentPickerOption>[];
          final customTabbedOptions = <TabbedAttachmentPickerOption>[];

          for (final option in customOptions ?? <AttachmentPickerOption>[]) {
            if (option is TabbedAttachmentPickerOption) {
              customTabbedOptions.add(option);
            } else {
              invalidOptions.add(option);
            }
          }

          if (invalidOptions.isNotEmpty == true) {
            throw ArgumentError(
              'customOptions must be TabbedAttachmentPickerOption when using '
              'the tabbed picker (default on mobile).',
            );
          }

          return tabbedAttachmentPickerBuilder.call(
            context: context,
            controller: controller,
            allowedTypes: allowedTypes,
            customOptions: customTabbedOptions,
            pollConfig: pollConfig,
            galleryPickerConfig: galleryPickerConfig,
          );
        },
      );
    },
  );
}

/// Builds the attachment picker bottom sheet.
class StreamAttachmentPickerBottomSheetBuilder extends StatefulWidget {
  /// Creates a new instance of the widget.
  const StreamAttachmentPickerBottomSheetBuilder({
    super.key,
    this.initialPoll,
    this.initialAttachments,
    this.initialExtraData,
    this.child,
    this.controller,
    required this.builder,
  });

  /// The child widget.
  final Widget? child;

  /// Builder for the attachment picker bottom sheet.
  final Widget Function(
    BuildContext context,
    StreamAttachmentPickerController controller,
    Widget? child,
  ) builder;

  /// The initial poll.
  final Poll? initialPoll;

  /// The initial attachments.
  final List<Attachment>? initialAttachments;

  /// The initial extra data for the attachment picker.
  final Map<String, Object?>? initialExtraData;

  /// The controller.
  final StreamAttachmentPickerController? controller;

  @override
  State<StreamAttachmentPickerBottomSheetBuilder> createState() =>
      _StreamAttachmentPickerBottomSheetBuilderState();
}

class _StreamAttachmentPickerBottomSheetBuilderState
    extends State<StreamAttachmentPickerBottomSheetBuilder> {
  late StreamAttachmentPickerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        StreamAttachmentPickerController(
          initialPoll: widget.initialPoll,
          initialAttachments: widget.initialAttachments,
          initialExtraData: widget.initialExtraData,
        );
  }

  // Handle a potential change in StreamAttachmentPickerController by properly
  // disposing of the old one and setting up the new one, if needed.
  void _updateAttachmentPickerController(
    StreamAttachmentPickerController? old,
    StreamAttachmentPickerController? current,
  ) {
    if ((old == null && current == null) || old == current) return;
    if (old == null) {
      _controller.dispose();
      _controller = current!;
    } else if (current == null) {
      _controller = StreamAttachmentPickerController(
        initialPoll: widget.initialPoll,
        initialAttachments: widget.initialAttachments,
        initialExtraData: widget.initialExtraData,
      );
    } else {
      _controller = current;
    }
  }

  @override
  void didUpdateWidget(
    StreamAttachmentPickerBottomSheetBuilder oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    _updateAttachmentPickerController(
      oldWidget.controller,
      widget.controller,
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _controller, widget.child);
  }
}
