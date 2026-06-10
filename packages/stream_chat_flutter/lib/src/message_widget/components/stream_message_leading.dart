import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Displays the leading slot of a message item — by default the author's
/// avatar shown to the side of the message bubble.
///
/// This widget delegates rendering to either a custom builder registered via
/// [StreamComponentFactory], or [DefaultStreamMessageLeading] when no custom
/// builder is provided. Register a custom builder through
/// `streamChatComponentBuilders(messageLeading: ...)` to fully replace the
/// default leading rendering while still receiving the same
/// [StreamMessageLeadingProps].
///
/// See also:
///
///  * [StreamMessageLeadingProps], which holds every configurable property.
///  * [DefaultStreamMessageLeading], the default implementation used when no
///    custom builder is registered.
///  * [StreamMessageHeader], the annotation slot above the bubble.
///  * [StreamMessageFooter], the metadata slot below the bubble.
class StreamMessageLeading extends core.NullableStatelessWidget {
  /// Creates a message leading slot for the given [message].
  StreamMessageLeading({
    super.key,
    required Message message,
    VoidCallback? onTap,
  }) : props = .new(message: message, onTap: onTap);

  /// Creates a message leading slot from pre-built [props].
  const StreamMessageLeading.fromProps({super.key, required this.props});

  /// The properties that configure this leading slot.
  final StreamMessageLeadingProps props;

  @override
  Widget? nullableBuild(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamMessageLeadingProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamMessageLeading(props: props);
  }
}

/// Properties for configuring a [StreamMessageLeading].
///
/// See also:
///
///  * [StreamMessageLeading], which uses these properties.
///  * [DefaultStreamMessageLeading], the default implementation.
class StreamMessageLeadingProps {
  /// Creates properties for a message leading slot.
  const StreamMessageLeadingProps({required this.message, this.onTap});

  /// The message whose author avatar to display.
  final Message message;

  /// Called when the leading avatar is tapped.
  ///
  /// If null, the avatar is not tappable.
  final VoidCallback? onTap;

  /// Returns a copy of this [StreamMessageLeadingProps] with the given fields
  /// replaced with new values.
  StreamMessageLeadingProps copyWith({
    Message? message,
    VoidCallback? onTap,
  }) {
    return StreamMessageLeadingProps(
      message: message ?? this.message,
      onTap: onTap ?? this.onTap,
    );
  }
}

/// The default implementation of [StreamMessageLeading].
///
/// Renders the author's avatar at the size configured by
/// [core.StreamMessageItemTheme.avatarSize], falling back to
/// [StreamAvatarSize.md]. Returns `null` when [Message.user] is null,
/// allowing the parent layout to collapse the slot and skip spacing
/// automatically.
class DefaultStreamMessageLeading extends core.NullableStatelessWidget {
  /// Creates a default message leading slot with the given [props].
  const DefaultStreamMessageLeading({super.key, required this.props});

  /// The properties that configure this widget.
  final StreamMessageLeadingProps props;

  @override
  Widget? nullableBuild(BuildContext context) {
    final user = props.message.user;
    if (user == null) return null;

    final theme = core.StreamMessageItemTheme.of(context);
    final avatarSize = theme.avatarSize ?? StreamAvatarSize.md;

    Widget avatar = StreamUserAvatar(user: user, showOnlineIndicator: false);
    if (props.onTap case final onTap?) {
      avatar = GestureDetector(behavior: .opaque, onTap: onTap, child: avatar);
    }

    return core.StreamAvatarTheme(
      data: .new(size: avatarSize),
      child: avatar,
    );
  }
}
