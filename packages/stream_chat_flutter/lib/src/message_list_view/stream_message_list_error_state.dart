import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';
import '../utils/network_error_text.dart';

/// A widget that is used to display the error state of the message list.
///
/// Scrolls instead of overflowing when it has less room than it needs.
class StreamMessageListErrorState extends StatelessWidget {
  /// Creates a new instance of the [StreamMessageListErrorState].
  const StreamMessageListErrorState({
    super.key,
    required this.error,
    required this.onRetryPressed,
  });

  /// The error that stopped the messages from loading.
  final Object error;

  /// Called when the retry button is pressed.
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final text = resolveNetworkErrorText(context, error, fallbackTitle: translations.loadingMessagesError);

    final content = Center(
      child: StreamScrollViewErrorWidget(
        errorTitle: Text(text.title),
        errorSubtitle: Text(text.description),
        retryButtonText: Text(translations.tryAgainLabel),
        onRetryPressed: onRetryPressed,
      ),
    );

    return CustomScrollView(
      slivers: [SliverFillRemaining(hasScrollBody: false, child: content)],
    );
  }
}
