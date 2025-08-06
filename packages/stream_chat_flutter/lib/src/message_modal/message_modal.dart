import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/flexible_fractionally_sized_box.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// {@template streamMessageModal}
/// A customizable modal widget for displaying message-related content.
///
/// This widget provides a consistent container for message actions and other
/// message-related modal content. It handles layout, animation, and keyboard
/// adjustments automatically.
///
/// The modal can contain a header (optional) and content section (required),
/// and will adjust its position when the keyboard appears.
/// {@endtemplate}
class StreamMessageModal extends StatelessWidget {
  /// Creates a Stream message modal.
  ///
  /// The [contentBuilder] parameter is required to build the main content
  /// of the modal. The [headerBuilder] is optional and can be used to add
  /// a header above the main content.
  const StreamMessageModal({
    super.key,
    this.spacing = 8.0,
    this.headerBuilder,
    required this.contentBuilder,
    this.useSafeArea = true,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.insetPadding = const EdgeInsets.all(8),
    this.alignment = Alignment.center,
  });

  /// Vertical spacing between header and content sections.
  final double spacing;

  /// Optional builder for the header section of the modal.
  final WidgetBuilder? headerBuilder;

  /// Required builder for the main content of the modal.
  final WidgetBuilder contentBuilder;

  /// Whether to use a [SafeArea] to avoid system UI intrusions.
  ///
  /// Defaults to `true`.
  final bool useSafeArea;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the modal is placed in.
  ///
  /// Defaults to 100 milliseconds.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the modal is placed in.
  ///
  /// Defaults to [Curves.decelerate].
  final Curve insetAnimationCurve;

  /// The amount of padding added to [MediaQueryData.viewInsets] on the outside
  /// of the modal. This defines the minimum space between the screen's edges
  /// and the modal.
  ///
  /// Defaults to `EdgeInsets.zero`.
  final EdgeInsets insetPadding;

  /// How to align the [StreamMessageModal].
  ///
  /// Defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = MediaQuery.viewInsetsOf(context) + insetPadding;

    final modalChild = Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            spacing: spacing,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: alignment.toColumnCrossAxisAlignment(),
            children: [
              if (headerBuilder case final builder?) builder(context),
              Flexible(child: contentBuilder(context)),
            ],
          ),
        ),
      ),
    );

    Widget modal = AnimatedPadding(
      padding: effectivePadding,
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: modalChild,
      ),
    );

    if (useSafeArea) {
      modal = Align(
        alignment: alignment,
        child: SingleChildScrollView(
          hitTestBehavior: HitTestBehavior.translucent,
          child: SafeArea(child: modal),
        ),
      );
    }

    return modal;
  }
}
