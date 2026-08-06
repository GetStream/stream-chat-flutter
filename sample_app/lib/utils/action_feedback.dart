import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Runs [action] and shows a success or error snackbar on [messenger] with the
// given messages. Does nothing if [messenger] is null.
Future<void> runWithFeedback(
  StreamSnackbarMessenger? messenger,
  Future<void> Function() action, {
  required String errorMessage,
  String? successMessage,
}) async {
  try {
    await action();
    if (successMessage == null) return;
    messenger?.show(
      StreamSnackbar(message: Text(successMessage), variant: .success),
      replace: true,
    );
  } catch (_) {
    messenger?.show(
      StreamSnackbar(message: Text(errorMessage), variant: .error),
      replace: true,
    );
  }
}
