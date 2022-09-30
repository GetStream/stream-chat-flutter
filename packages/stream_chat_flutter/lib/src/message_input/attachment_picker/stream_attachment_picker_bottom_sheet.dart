import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/platform_widget_builder/src/platform_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Shows a modal material design bottom sheet.
///
/// A modal bottom sheet is an alternative to a menu or a dialog and prevents
/// the user from interacting with the rest of the app.
///
/// A closely related widget is a persistent bottom sheet, which shows
/// information that supplements the primary content of the app without
/// preventing the use from interacting with the app. Persistent bottom sheets
/// can be created and displayed with the [showBottomSheet] function or the
/// [ScaffoldState.showBottomSheet] method.
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the bottom sheet. It is only used when the method is called. Its
/// corresponding widget can be safely removed from the tree before the bottom
/// sheet is closed.
///
/// The `isScrollControlled` parameter specifies whether this is a route for
/// a bottom sheet that will utilize [DraggableScrollableSheet]. If you wish
/// to have a bottom sheet that has a scrollable child such as a [ListView] or
/// a [GridView] and have the bottom sheet be draggable, you should set this
/// parameter to true.
///
/// The `useRootNavigator` parameter ensures that the root navigator is used to
/// display the [BottomSheet] when set to `true`. This is useful in the case
/// that a modal [BottomSheet] needs to be displayed above all other content
/// but the caller is inside another [Navigator].
///
/// The [isDismissible] parameter specifies whether the bottom sheet will be
/// dismissed when user taps on the scrim.
///
/// The [enableDrag] parameter specifies whether the bottom sheet can be
/// dragged up and down and dismissed by swiping downwards.
///
/// The optional [backgroundColor], [elevation], [shape], [clipBehavior],
/// [constraints] and [transitionAnimationController]
/// parameters can be passed in to customize the appearance and behavior of
/// modal bottom sheets (see the documentation for these on [BottomSheet]
/// for more details).
///
/// The [transitionAnimationController] controls the bottom sheet's entrance and
/// exit animations if provided.
///
/// The optional `routeSettings` parameter sets the [RouteSettings]
/// of the modal bottom sheet sheet.
/// This is particularly useful in the case that a user wants to observe
/// [PopupRoute]s within a [NavigatorObserver].
///
/// Returns a `Future` that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the modal bottom sheet was closed.
///
/// See also:
///
///  * [BottomSheet], which becomes the parent of the widget returned by the
///    function passed as the `builder` argument to [showModalBottomSheet].
///  * [showBottomSheet] and [ScaffoldState.showBottomSheet], for showing
///    non-modal bottom sheets.
///  * [DraggableScrollableSheet], which allows you to create a bottom sheet
///    that grows and then becomes scrollable once it reaches its maximum size.
///  * <https://material.io/design/components/sheets-bottom.html#modal-bottom-sheet>
Future<T?> showStreamAttachmentPickerModalBottomSheet<T>({
  required BuildContext context,
  Iterable<AttachmentPickerOption>? customOptions,
  List<Attachment>? initialAttachments,
  StreamAttachmentPickerController? controller,
  Color? backgroundColor,
  double? elevation,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Clip? clipBehavior = Clip.hardEdge,
  ShapeBorder? shape,
  ThumbnailSize attachmentThumbnailSize = const ThumbnailSize(400, 400),
  ThumbnailFormat attachmentThumbnailFormat = ThumbnailFormat.jpeg,
  int attachmentThumbnailQuality = 100,
  double attachmentThumbnailScale = 1,
}) {
  final colorTheme = StreamChatTheme.of(context).colorTheme;
  final color = backgroundColor ?? colorTheme.inputBg;

  return showModalBottomSheet<T>(
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
      return StreamPlatformAttachmentPickerBottomSheetBuilder(
        controller: controller,
        initialAttachments: initialAttachments,
        builder: (context, controller, child) {
          return PlatformWidget(
            web: (context) {
              return webOrDesktopAttachmentPickerBuilder.call(
                context: context,
                controller: controller,
                customOptions: customOptions?.map(
                  WebOrDesktopAttachmentPickerOption.fromAttachmentPickerOption,
                ),
                attachmentThumbnailSize: attachmentThumbnailSize,
                attachmentThumbnailFormat: attachmentThumbnailFormat,
                attachmentThumbnailQuality: attachmentThumbnailQuality,
                attachmentThumbnailScale: attachmentThumbnailScale,
              );
            },
            mobile: (context) {
              return mobileAttachmentPickerBuilder.call(
                context: context,
                controller: controller,
                customOptions: customOptions,
                attachmentThumbnailSize: attachmentThumbnailSize,
                attachmentThumbnailFormat: attachmentThumbnailFormat,
                attachmentThumbnailQuality: attachmentThumbnailQuality,
                attachmentThumbnailScale: attachmentThumbnailScale,
              );
            },
            desktop: (context) {
              return webOrDesktopAttachmentPickerBuilder.call(
                context: context,
                controller: controller,
                customOptions: customOptions?.map(
                  WebOrDesktopAttachmentPickerOption.fromAttachmentPickerOption,
                ),
                attachmentThumbnailSize: attachmentThumbnailSize,
                attachmentThumbnailFormat: attachmentThumbnailFormat,
                attachmentThumbnailQuality: attachmentThumbnailQuality,
                attachmentThumbnailScale: attachmentThumbnailScale,
              );
            },
          );
        },
      );
    },
  );
}

/// Builds the attachment picker bottom sheet.
class StreamPlatformAttachmentPickerBottomSheetBuilder extends StatefulWidget {
  /// Creates a new instance of the widget.
  const StreamPlatformAttachmentPickerBottomSheetBuilder({
    super.key,
    this.customOptions,
    this.initialAttachments,
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

  /// The custom options to be displayed in the attachment picker.
  final List<AttachmentPickerOption>? customOptions;

  /// The initial attachments.
  final List<Attachment>? initialAttachments;

  /// The controller.
  final StreamAttachmentPickerController? controller;

  @override
  State<StreamPlatformAttachmentPickerBottomSheetBuilder> createState() =>
      _StreamPlatformAttachmentPickerBottomSheetBuilderState();
}

class _StreamPlatformAttachmentPickerBottomSheetBuilderState
    extends State<StreamPlatformAttachmentPickerBottomSheetBuilder> {
  late StreamAttachmentPickerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        StreamAttachmentPickerController(
          initialAttachments: widget.initialAttachments,
        );
  }

  // Handle a potential change in StreamAttachmentPickerController by properly
  // disposing of the old one and setting up the new one, if needed.
  void _updateTextEditingController(
    StreamAttachmentPickerController? old,
    StreamAttachmentPickerController? current,
  ) {
    if ((old == null && current == null) || old == current) return;
    if (old == null) {
      _controller.dispose();
      _controller = current!;
    } else if (current == null) {
      _controller = StreamAttachmentPickerController();
    } else {
      _controller = current;
    }
  }

  @override
  void didUpdateWidget(
    StreamPlatformAttachmentPickerBottomSheetBuilder oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    _updateTextEditingController(
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
