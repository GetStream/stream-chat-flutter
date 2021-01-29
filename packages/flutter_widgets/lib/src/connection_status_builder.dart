import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'stream_chat.dart';

class ConnectionStatusBuilder extends StatelessWidget {
  /// Creates a new ConnectionStatusBuilder
  const ConnectionStatusBuilder({
    Key key,
    @required this.statusBuilder,
    this.initialStatus = ConnectionStatus.disconnected,
    this.connectionStatusStream,
    this.errorBuilder,
    this.loadingBuilder,
  })  : assert(statusBuilder != null),
        super(key: key);

  /// The connection status that will be used to create the initial snapshot.
  final ConnectionStatus initialStatus;

  /// The asynchronous computation to which this builder is currently connected.
  final Stream<ConnectionStatus> connectionStatusStream;

  /// The builder that will be used in case of error
  final Widget Function(BuildContext context, Object error) errorBuilder;

  /// The builder that will be used in case of loading
  final WidgetBuilder loadingBuilder;

  /// The builder that will be used in case of data
  final Widget Function(BuildContext context, ConnectionStatus status)
      statusBuilder;

  @override
  Widget build(BuildContext context) {
    final stream = connectionStatusStream ??
        StreamChat.of(context).client.wsConnectionStatusStream;
    return StreamBuilder<ConnectionStatus>(
      initialData: initialStatus,
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (errorBuilder != null) {
            return errorBuilder(context, snapshot.error);
          }
          return Offstage();
        }
        if (!snapshot.hasData) {
          if (loadingBuilder != null) return loadingBuilder(context);
          return Offstage();
        }
        return statusBuilder(context, snapshot.data);
      },
    );
  }
}
