import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_sending_status.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/chat.dart' as core;

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
  StreamMessageFooter({super.key, required Message message}) : props = .new(message: message);

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
  const StreamMessageFooterProps({required this.message});

  /// The message whose metadata to display.
  final Message message;

  /// Returns a copy of this [StreamMessageFooterProps] with the given fields
  /// replaced with new values.
  StreamMessageFooterProps copyWith({Message? message}) {
    return StreamMessageFooterProps(message: message ?? this.message);
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

    Widget? usernameWidget;
    if (message.user case final user? when channelKind == .group && user.id != currentUser?.id) {
      usernameWidget = Text(user.name, maxLines: 1, overflow: .ellipsis);
    }

    Widget? statusWidget;
    if (message.user case final user? when user.id == currentUser?.id) {
      statusWidget = StreamMessageSendingStatus(message: message);
    }

    final Widget timestampWidget;
    if (message.createdAt case final createdAt) {
      timestampWidget = StreamTimestamp(
        date: createdAt.toLocal(),
        formatter: (context, date) => Jiffy.parseFromDateTime(date).jm,
      );
    }

    Widget? editedWidget;
    if (message.messageTextUpdatedAt != null) {
      editedWidget = Text(context.translations.editedMessageLabel);
    }

    return core.StreamMessageMetadata(
      username: usernameWidget,
      status: statusWidget,
      timestamp: timestampWidget,
      edited: editedWidget,
    );
  }
}
