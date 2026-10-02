import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../../stream_chat_flutter.dart';

/// Whether other members have read, or received, a message.
typedef MessageReadStatus = ({bool isMessageRead, bool isMessageDelivered});

/// Builds a widget from the [MessageReadStatus] of [message] in [channel],
/// rebuilding only when that status changes.
class MessageReadStatusBuilder extends StatefulWidget {
  /// Creates a builder for the read status of [message] in [channel].
  const MessageReadStatusBuilder({
    super.key,
    required this.channel,
    required this.message,
    required this.builder,
    this.noDataBuilder,
  });

  /// The channel whose read state is followed.
  final Channel? channel;

  /// The message whose read status is built.
  final Message message;

  /// Builds the widget for the current read status.
  final Widget Function(BuildContext context, MessageReadStatus status) builder;

  /// Builds the widget shown while [channel] has no state.
  ///
  /// Defaults to an empty widget.
  final WidgetBuilder? noDataBuilder;

  @override
  State<MessageReadStatusBuilder> createState() => _MessageReadStatusBuilderState();
}

class _MessageReadStatusBuilderState extends State<MessageReadStatusBuilder> {
  // Created once rather than on every build, so a rebuild keeps the
  // subscription, and re-created when the channel state stream or the parts of
  // the message the status depends on change, so it is always computed for the
  // message on screen.
  late Stream<ChannelState>? _source = _sourceOf(widget);
  late Stream<MessageReadStatus>? _status = _statusStream();

  @override
  void didUpdateWidget(MessageReadStatusBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    final source = _sourceOf(widget);
    if (source != _source || _statusInputsChanged(oldWidget.message, widget.message)) {
      _source = source;
      _status = _statusStream();
    }
  }

  Stream<ChannelState>? _sourceOf(MessageReadStatusBuilder widget) => widget.channel?.state?.channelStateStream;

  // The read and delivered checks compare only the sender and the creation
  // time, so an edit or a reaction keeps the current stream.
  bool _statusInputsChanged(Message previous, Message next) {
    return previous.user?.id != next.user?.id || previous.createdAt != next.createdAt;
  }

  // The read list is compared before the status is computed, the way
  // [ChannelClientState.readStream] does, so an update that leaves the reads
  // as they are costs no more than a list comparison.
  Stream<MessageReadStatus>? _statusStream() => _source
      ?.map((it) => it.read ?? const <Read>[])
      .distinct(const ListEquality<Read>().equals)
      .map(_statusOf)
      .distinct();

  // A channel with read events disabled has no read state, which counts as no
  // one having read or received the message.
  MessageReadStatus _statusOf(List<Read>? read) {
    final reads = read ?? const <Read>[];
    return (
      isMessageRead: reads.readsOf(message: widget.message).isNotEmpty,
      isMessageDelivered: reads.deliveriesOf(message: widget.message).isNotEmpty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.channel?.state;

    return BetterStreamBuilder<MessageReadStatus>(
      stream: _status,
      initialData: state == null ? null : _statusOf(state.channelState.read),
      builder: widget.builder,
      noDataBuilder: widget.noDataBuilder,
    );
  }
}
