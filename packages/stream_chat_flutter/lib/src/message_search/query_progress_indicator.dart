import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template queryProgressIndicator}
/// Shows the progress of a search query performed via [MessageSearchListView].
///
/// Not recommended for use outside [MessageSearchListView].
/// {@endtemplate}
class QueryProgressIndicator extends StatelessWidget {
  /// {@macro queryProgressIndicator}
  const QueryProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageSearchBloc = MessageSearchBloc.of(context);

    return StreamBuilder<bool>(
      stream: messageSearchBloc.queryMessagesLoading,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            color: StreamChatTheme.of(context)
                .colorTheme
                .accentError
                .withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(context.translations.loadingMessagesError),
              ),
            ),
          );
        }
        return Container(
          height: 100,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: snapshot.data!
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
