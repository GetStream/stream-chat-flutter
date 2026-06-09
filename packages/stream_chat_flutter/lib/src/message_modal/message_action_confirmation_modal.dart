import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// {@template streamMessageActionConfirmationModal}
/// A confirmation modal dialog for message actions in Stream Chat.
///
/// This widget creates a platform-adaptive confirmation dialog that can be used
/// when a user attempts to perform an action on a message that requires
/// confirmation (like delete, flag, etc).
///
/// The dialog presents two options: cancel and confirm, with customizable text
/// for both actions. The confirm action can be styled as destructive for
/// actions like deletion.
///
/// Example usage:
///
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => StreamMessageActionConfirmationModal(
///     title: Text('Delete Message'),
///     content: Text('Are you sure you want to delete this message?'),
///     confirmActionTitle: Text('Delete'),
///     isDestructiveAction: true,
///   ),
/// ).then((confirmed) {
///   if (confirmed == true) {
///     // Perform the action
///   }
/// });
/// ```
/// {@endtemplate}
class StreamMessageActionConfirmationModal extends StatelessWidget {
  /// Creates a message action confirmation modal.
  ///
  /// [cancelActionTitle] defaults to a [Text] with the localized
  /// [Translations.cancelLabel].
  /// [confirmActionTitle] defaults to a [Text] with the localized
  /// [Translations.confirmLabel].
  /// Set [isDestructiveAction] to true for actions like deletion that should
  /// be highlighted as destructive.
  const StreamMessageActionConfirmationModal({
    super.key,
    this.title,
    this.content,
    this.cancelActionTitle,
    this.confirmActionTitle,
    this.isDestructiveAction = false,
  });

  /// The title of the dialog.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// The content of the dialog, displayed below the title.
  ///
  /// Typically a [Text] widget that provides more details about the action.
  final Widget? content;

  /// The widget to display as the cancel action button.
  ///
  /// When null, falls back to a [Text] with the localized
  /// [Translations.cancelLabel]. When pressed, this action dismisses the
  /// dialog and returns false.
  final Widget? cancelActionTitle;

  /// The widget to display as the confirm action button.
  ///
  /// When null, falls back to a [Text] with the localized
  /// [Translations.confirmLabel]. When pressed, this action dismisses the
  /// dialog and returns true.
  final Widget? confirmActionTitle;

  /// Whether the confirm action is destructive (like deletion).
  ///
  /// When true, the confirm action will be styled accordingly
  /// (e.g., in red on iOS/macOS).
  final bool isDestructiveAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    final translations = context.translations;

    final actions = [
      StreamButton(
        type: .ghost,
        style: .secondary,
        size: .small,
        onPressed: () => Navigator.of(context).maybePop(false),
        child: cancelActionTitle ?? Text(translations.cancelLabel),
      ),
      StreamButton(
        type: .solid,
        style: isDestructiveAction ? .destructive : .primary,
        size: .small,
        onPressed: () => Navigator.of(context).maybePop(true),
        child: confirmActionTitle ?? Text(translations.confirmLabel),
      ),
    ];

    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
      backgroundColor: colorScheme.backgroundElevation1,
    );
  }
}
