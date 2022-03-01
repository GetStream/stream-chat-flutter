import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A button that allows a user to delete the selected message.
///
/// As of Feb 24, 2022, this button appears on all platforms. It really should
/// only be shown on mobile platforms, with a different UI paradigm being
/// preferred for desktop and web.
class DeleteMessageButton extends StatelessWidget {
  /// Builds a [DeleteMessageButton].
  const DeleteMessageButton({
    Key? key,
    required this.isDeleteFailed,
    required this.onTap,
  }) : super(key: key);

  /// Indicates whether the deletion has failed or not.
  final bool isDeleteFailed;

  /// The action (deleting the message) to be performed on tap.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Row(
          children: [
            StreamSvgIcon.delete(
              color: Colors.red,
            ),
            const SizedBox(width: 16),
            Text(
              context.translations.toggleDeleteRetryDeleteMessageText(
                isDeleteFailed: isDeleteFailed,
              ),
              style: StreamChatTheme.of(context)
                  .textTheme
                  .body
                  .copyWith(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
