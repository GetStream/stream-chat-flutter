import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Stream] of type [ConnectionStatus].
///
/// The widget will use the closest [StreamChatClient.wsConnectionStatusStream]
/// in case no stream is provided.
class ConnectionStatusBuilder extends StatefulWidget {
  /// Creates a new ConnectionStatusBuilder
  const ConnectionStatusBuilder({
    Key? key,
    required this.statusBuilder,
    this.initialStatus,
    this.connectionStatusStream,
    this.errorBuilder,
    this.loadingBuilder,
  }) : super(key: key);

  /// The connection status that will be used to create the initial snapshot.
  final ConnectionStatus? initialStatus;

  /// The asynchronous computation to which this builder is currently connected.
  final Stream<ConnectionStatus>? connectionStatusStream;

  /// The builder that will be used in case of error
  final Widget Function(BuildContext context, Object? error)? errorBuilder;

  /// The builder that will be used in case of loading
  final WidgetBuilder? loadingBuilder;

  /// The builder that will be used in case of data
  final Widget Function(BuildContext context, ConnectionStatus status)
      statusBuilder;

  @override
  _ConnectionStatusBuilderState createState() =>
      _ConnectionStatusBuilderState();
}

class _ConnectionStatusBuilderState extends State<ConnectionStatusBuilder> {
  late StreamChatClient client;
  late Stream<ConnectionStatus> stream;

  @override
  Widget build(BuildContext context) => BetterStreamBuilder<ConnectionStatus>(
        initialData: widget.initialStatus ?? client.wsConnectionStatus,
        stream: stream,
        loadingBuilder: widget.loadingBuilder,
        errorBuilder: (context, error) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!(context, error);
          }
          return const Offstage();
        },
        builder: widget.statusBuilder,
      );

  @override
  void didChangeDependencies() {
    client = StreamChat.of(context).client;
    stream = widget.connectionStatusStream ?? client.wsConnectionStatusStream;
    super.didChangeDependencies();
  }
}
