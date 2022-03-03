import 'dart:ui' show VoidCallback;

import 'package:native_context_menu/native_context_menu.dart';

/// A [MenuItem] that will allow a user to delete a message.
///
/// Used only for desktop and web platforms.
class DeleteMessageMenuItem extends MenuItem {
  /// Builds a [DeleteMessageMenuItem].
  DeleteMessageMenuItem({
    String title = 'Delete Message',
    required this.onClick,
  }) : super(title: title);

  /// The action to perform when the menu item is clicked.
  ///
  /// This is used to keep Flutter-specific code out of the API for
  /// this class. Subject to change.
  final VoidCallback onClick;

  @override
  VoidCallback? get onSelected => onClick.call;
}
