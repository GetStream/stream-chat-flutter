library conditional_parent_builder;

import 'package:flutter/material.dart';

/// {@template parentBuilder}
/// A function that provides the [BuildContext] and the [child] widget.
/// {@endtemplate}
typedef ParentBuilder = Widget Function(
  BuildContext context,
  Widget child,
);

/// {@template conditionalParentBuilder}
/// A widget that allows developers to conditionally wrap the [child] widget
/// with a parent widget.
///
/// In the following real-world example, we conditionally wrap the child widget
/// tree with a context menu if the message is not deleted:
/// ```dart
/// ConditionalParentBuilder(
///   builder: (context, child) {
///     if (!widget.message.isDeleted) {
///       return ContextMenuArea(
///         builder: (context) => buildContextMenu(),
///         child: child,
///       );
///     } else {
///       return child;
///     }
///   },
///   child: Material(...),
/// ),
/// ```
/// This example can be found in the `stream_chat_flutter` source code under
/// `src/message_widget/message_widget.dart`.
/// {@endtemplate}
class ConditionalParentBuilder extends StatelessWidget {
  /// {@macro conditionalParentBuilder}
  const ConditionalParentBuilder({
    super.key,
    required this.builder,
    required this.child,
  });

  /// {@macro parentBuilder}
  final ParentBuilder builder;

  /// The child widget to build.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return builder.call(context, child);
  }
}
