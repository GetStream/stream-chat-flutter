import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../../stream_chat_flutter.dart';
import 'stream_message_sending_status.dart';

/// Displays the row below the message bubble containing the author name,
/// sending status, creation timestamp, and an edited indicator.
///
/// This widget delegates rendering to either a custom builder registered via
/// [StreamComponentFactory], or [DefaultStreamMessageFooter] when no custom
/// builder is provided. Register a custom builder through
/// `streamChatComponentBuilders(messageFooter: ...)` to fully replace the
/// default footer rendering while still receiving the same
/// [StreamMessageFooterProps].
///
/// See also:
///
///  * [StreamMessageFooterProps], which holds every configurable property.
///  * [DefaultStreamMessageFooter], the default implementation used when no
///    custom builder is registered.
///  * [StreamMessageHeader], the symmetric slot above the message bubble.
class StreamMessageFooter extends StatelessWidget {
  /// Creates a message footer for the given [message].
  StreamMessageFooter({
    super.key,
    required Message message,
    bool excludeFromSemantics = false,
  }) : props = .new(message: message, excludeFromSemantics: excludeFromSemantics);

  /// Creates a message footer from pre-built [props].
  const StreamMessageFooter.fromProps({super.key, required this.props});

  /// The properties that configure this footer.
  final StreamMessageFooterProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamMessageFooterProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamMessageFooter(props: props);
  }
}

/// Properties for configuring a [StreamMessageFooter].
///
/// See also:
///
///  * [StreamMessageFooter], which uses these properties.
///  * [DefaultStreamMessageFooter], the default implementation.
class StreamMessageFooterProps {
  /// Creates properties for a message footer.
  const StreamMessageFooterProps({
    required this.message,
    this.excludeFromSemantics = false,
  });

  /// The message whose metadata to display.
  final Message message;

  /// Whether the footer stays out of the semantics tree.
  ///
  /// Set this when an enclosing row already announces the metadata as part of
  /// a composed phrase — [StreamMessageItem] passes `true` whenever it labels
  /// the row — so a screen reader is not offered the same words again, once
  /// per part. Left `false` (the default) each part announces itself, which is
  /// what a footer outside such a row needs.
  final bool excludeFromSemantics;

  /// Returns a copy of this [StreamMessageFooterProps] with the given fields
  /// replaced with new values.
  StreamMessageFooterProps copyWith({Message? message, bool? excludeFromSemantics}) {
    return StreamMessageFooterProps(
      message: message ?? this.message,
      excludeFromSemantics: excludeFromSemantics ?? this.excludeFromSemantics,
    );
  }
}

/// The default implementation of [StreamMessageFooter].
///
/// The footer can show up to four pieces depending on the message:
///
///  * **Username** — for messages from other users.
///  * **Sending status** — for the current user's own messages.
///  * **Timestamp** — always shown, formatted as a short time string.
///  * **Edited label** — when the message text has been updated.
///
/// With [StreamMessageFooterProps.excludeFromSemantics] set, none of the four
/// contributes to the semantics tree: the enclosing row speaks them all as part
/// of its composed label, so announcing them here as well would cost four extra
/// focus stops per message that repeat what the row already said. Left unset —
/// [StreamGiphyEphemeralMessage], or a custom layout that uses this footer
/// without a row-level label — they announce themselves, since nothing else
/// would.
class DefaultStreamMessageFooter extends StatelessWidget {
  /// Creates a default message footer with the given [props].
  const DefaultStreamMessageFooter({super.key, required this.props});

  /// The properties that configure this widget.
  final StreamMessageFooterProps props;

  @override
  Widget build(BuildContext context) {
    final message = props.message;
    final currentUser = StreamChat.of(context).currentUser;
    final channelKind = core.StreamMessageLayout.channelKindOf(context);

    // Inside a row that already speaks this metadata every part here would be
    // a focus stop repeating what the row just said; outside one, dropping
    // them would leave the metadata unannounced altogether.
    final excluding = props.excludeFromSemantics;

    Widget? usernameWidget;
    if (message.user case final user? when channelKind == .group && user.id != currentUser?.id) {
      usernameWidget = ExcludeSemantics(
        excluding: excluding,
        child: Text(user.name, maxLines: 1, overflow: .ellipsis),
      );
    }

    Widget? statusWidget;
    if (message.user case final user? when user.id == currentUser?.id) {
      statusWidget = ExcludeSemantics(
        excluding: excluding,
        child: StreamMessageSendingStatus(message: message),
      );
    }

    final timestampWidget = ExcludeSemantics(
      excluding: excluding,
      child: StreamTimestamp(
        date: message.createdAt.toLocal(),
        formatter: (context, date) => Jiffy.parseFromDateTime(date).jm,
      ),
    );

    Widget? editedWidget;
    // A deleted message has no text left to have been edited, so the marker
    // would describe history the reader can no longer see.
    if (message.messageTextUpdatedAt != null && !message.isDeleted) {
      editedWidget = ExcludeSemantics(
        excluding: excluding,
        child: Text(context.translations.editedMessageLabel),
      );
    }

    return core.StreamMessageMetadata(
      username: usernameWidget,
      status: statusWidget,
      timestamp: timestampWidget,
      edited: editedWidget,
    );
  }
}
