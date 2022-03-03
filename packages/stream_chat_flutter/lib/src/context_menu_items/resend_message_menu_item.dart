import 'dart:ui';

import 'package:native_context_menu/native_context_menu.dart';

/// Enables users to thread reply to messages via context menu.
class ResendMessageMenuItem extends MenuItem {
  /// Builds a [ThreadReplyMenuItem].
  ResendMessageMenuItem({
    String title = 'Resend Message',
    required this.onClick,
  }) : super(title: title);

  /// The callback to perform when the menu item is clicked.
  final VoidCallback onClick;

  @override
  VoidCallback? get onSelected => onClick;
}
