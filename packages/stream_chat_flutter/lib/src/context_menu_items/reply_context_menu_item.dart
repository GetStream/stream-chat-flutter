import 'dart:ui' show VoidCallback;

import 'package:native_context_menu/native_context_menu.dart';

/// Enables users to reply to messages via context menu.
class ReplyContextMenuItem extends MenuItem {
  /// Builds a [ReplyContextMenuItem].
  ReplyContextMenuItem({
    String title = 'Reply',
    required this.onClick,
  }) : super(title: title);

  /// The callback to perform when the menu item is clicked.
  final VoidCallback onClick;

  @override
  VoidCallback? get onSelected => onClick;
}
