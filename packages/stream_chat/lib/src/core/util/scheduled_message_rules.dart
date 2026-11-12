import '../../client/channel/channel.dart';
import '../models/message.dart';

/// Provides the rules for scheduling a message.
///
/// Determines whether a message can be scheduled in a channel, as far as the
/// channel's loaded state tells.
class ScheduledMessageRules {
  const ScheduledMessageRules._();

  /// Whether the text of [message] is a command in [channel].
  ///
  /// It is when the text starts with `/` and the channel has commands. A
  /// channel that isn't loaded never counts it as one.
  static bool isCommand(Message message, Channel? channel) {
    // A command runs when it is sent, so it can't be scheduled in a channel
    // that has commands. Elsewhere the text is sent as it is.
    final text = message.text;
    if (text == null || !text.startsWith('/')) return false;

    final commands = channel?.state?.channelState.channel?.config.commands;
    return commands != null && commands.isNotEmpty;
  }

  /// Whether [message] quotes a message known to be deleted.
  ///
  /// The quoted message is looked up among the messages [channel] has loaded,
  /// then taken from [message] itself.
  static bool quotesDeletedMessage(Message message, Channel? channel) {
    final quotedMessageId = message.quotedMessageId ?? message.quotedMessage?.id;
    if (quotedMessageId == null) return false;

    // The channel's own copy is the latest one known.
    final state = channel?.state;
    final loaded = switch (state) {
      final state? => [...state.messages, ...state.threads.values.expand((it) => it)],
      null => const <Message>[],
    };
    final quoted = loaded.where((it) => it.id == quotedMessageId).firstOrNull ?? message.quotedMessage;
    if (quoted == null) return false;

    return quoted.isDeleted || quoted.deletedAt != null;
  }
}
