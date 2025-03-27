import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template deleteMessageButton}
/// A button that allows a user to delete the selected message.
///
/// Used by [MessageActionsModal]. Should not be used by itself.
/// {@endtemplate}
class DeleteMessageButton extends StatelessWidget {
  /// {@macro deleteMessageButton}
  const DeleteMessageButton({
    super.key,
    required this.isDeleteFailed,
    required this.onTap,
  });

  /// Indicates whether the deletion has failed or not.
  final bool isDeleteFailed;

  /// The action (deleting the message) to be performed on tap.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Row(
          children: [
            StreamSvgIcon(
              icon: StreamSvgIcons.delete,
              color: theme.colorTheme.accentError,
            ),
            const SizedBox(width: 16),
            Text(
              context.translations.toggleDeleteRetryDeleteMessageText(
                isDeleteFailed: isDeleteFailed,
              ),
              style: theme.textTheme.body.copyWith(
                color: theme.colorTheme.accentError,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
