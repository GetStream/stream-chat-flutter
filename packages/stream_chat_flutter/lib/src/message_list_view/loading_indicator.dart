import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template loadingIndicatorMLV}
/// A loading indicator for pagination in [StreamMessageListView].
///
/// Displays the in-flight spinner while older or newer messages are loading,
/// and a tappable retry tile when pagination fails. Driven by the
/// [QueryDirection]-specific pagination stream from the surrounding
/// [StreamChannel].
///
/// Not intended for use outside of [StreamMessageListView].
/// {@endtemplate}
class LoadingIndicator extends StatefulWidget {
  /// {@macro loadingIndicatorMLV}
  const LoadingIndicator({
    super.key,
    required this.direction,
    required this.onRetryPressed,
    this.indicatorBuilder,
  });

  /// Which pagination edge — top for older, bottom for newer.
  final QueryDirection direction;

  /// Called when the user taps the retry tile after a pagination failure.
  final VoidCallback onRetryPressed;

  /// Optional override for the in-flight spinner.
  final WidgetBuilder? indicatorBuilder;

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  // Cached to avoid resubscribing on every parent rebuild.
  Stream<bool>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveStream(context);
  }

  @override
  void didUpdateWidget(covariant LoadingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.direction != oldWidget.direction) _resolveStream(context);
  }

  void _resolveStream(BuildContext context) {
    final channel = StreamChannel.of(context);
    _stream = switch (widget.direction) {
      .top => channel.queryTopMessages,
      .bottom => channel.queryBottomMessages,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BetterStreamBuilder<bool>(
      key: Key('LOADING-INDICATOR ${widget.direction}'),
      stream: _stream,
      initialData: false,
      errorBuilder: (context, error) => StreamScrollViewLoadMoreError.list(
        onTap: widget.onRetryPressed,
        error: Text(context.translations.loadingMessagesError),
      ),
      builder: (context, data) {
        if (!data) return const Empty();
        if (widget.indicatorBuilder case final builder?) return builder(context);

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StreamLoadingSpinner(),
          ),
        );
      },
    );
  }
}
