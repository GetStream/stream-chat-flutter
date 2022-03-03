import 'dart:ui' show VoidCallback;

import 'package:native_context_menu/native_context_menu.dart';

/// Allows a user to edit a message via context menu click.
class EditMessageMenuItem extends MenuItem {
  /// Builds an [EditMessageMenuItem].
  EditMessageMenuItem({
    String title = 'Edit Message',
    required this.onClick,
  }) : super(title: title);

  /// The callback to perform when this menu item is clicked.
  final VoidCallback onClick;

  @override
  VoidCallback? get onSelected => onClick;
}
