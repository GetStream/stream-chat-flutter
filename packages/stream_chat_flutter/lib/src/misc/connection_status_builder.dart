import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';
import 'empty_widget.dart';

/// {@template streamConnectionStateBuilder}
/// A widget that builds itself from the state of the connection the client works over.
///
/// Uses the connection of the closest [StreamChatClient] when no stream is given.
/// {@endtemplate}
class StreamConnectionStatusBuilder extends StatelessWidget {
  /// {@macro streamConnectionStateBuilder}
  const StreamConnectionStatusBuilder({
    super.key,
    required this.stateBuilder,
    this.connectionStateStream,
    this.errorBuilder,
    this.loadingBuilder,
  });

  /// The asynchronous computation to which this builder is currently connected.
  final Stream<WebSocketConnectionState>? connectionStateStream;

  /// The builder that will be used in case of error
  final Widget Function(BuildContext context, Object? error)? errorBuilder;

  /// The builder that will be used in case of loading
  final WidgetBuilder? loadingBuilder;

  /// The builder that will be used in case of data
  final Widget Function(BuildContext context, WebSocketConnectionState state) stateBuilder;

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    final stream = connectionStateStream ?? client.connectionState;
    return BetterStreamBuilder<WebSocketConnectionState>(
      initialData: client.connectionState.value,
      stream: stream,
      noDataBuilder: loadingBuilder,
      errorBuilder: (context, error) {
        if (errorBuilder != null) {
          return errorBuilder!(context, error);
        }
        return const Empty();
      },
      builder: stateBuilder,
    );
  }
}
