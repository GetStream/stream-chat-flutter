import 'dart:ui' show VoidCallback;

import 'package:native_context_menu/native_context_menu.dart';

/// Enables users to thread reply to messages via context menu.
class ThreadReplyMenuItem extends MenuItem {
  /// Builds a [ThreadReplyMenuItem].
  ThreadReplyMenuItem({
    String title = 'Reply in Thread',
    required this.onClick,
  }) : super(title: title);

  /// The callback to perform when the menu item is clicked.
  final VoidCallback onClick;

  @override
  VoidCallback? get onSelected => onClick;
}
