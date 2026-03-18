import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Builds the list of component builders for the stream chat components.
Iterable<StreamComponentBuilderExtension<Object>> streamChatComponentBuilders({
  StreamComponentBuilder<StreamChannelListItemProps>? channelListItem,
  StreamComponentBuilder<MessageComposerProps>? messageComposer,
  StreamComponentBuilder<MessageComposerLeadingProps>? messageComposerLeading,
  StreamComponentBuilder<MessageComposerTrailingProps>? messageComposerTrailing,
  StreamComponentBuilder<MessageComposerInputProps>? messageComposerInput,
  StreamComponentBuilder<MessageComposerInputLeadingProps>? messageComposerInputLeading,
  StreamComponentBuilder<MessageComposerInputHeaderProps>? messageComposerInputHeader,
  StreamComponentBuilder<MessageComposerInputTrailingProps>? messageComposerInputTrailing,
  StreamComponentBuilder<StreamMessageWidgetProps>? messageWidget,
}) {
  final builders = [
    if (channelListItem != null) StreamComponentBuilderExtension(builder: channelListItem),
    if (messageComposer != null) StreamComponentBuilderExtension(builder: messageComposer),
    if (messageComposerLeading != null) StreamComponentBuilderExtension(builder: messageComposerLeading),
    if (messageComposerTrailing != null) StreamComponentBuilderExtension(builder: messageComposerTrailing),
    if (messageComposerInput != null) StreamComponentBuilderExtension(builder: messageComposerInput),
    if (messageComposerInputLeading != null) StreamComponentBuilderExtension(builder: messageComposerInputLeading),
    if (messageComposerInputHeader != null) StreamComponentBuilderExtension(builder: messageComposerInputHeader),
    if (messageComposerInputTrailing != null) StreamComponentBuilderExtension(builder: messageComposerInputTrailing),
    if (messageWidget != null) StreamComponentBuilderExtension(builder: messageWidget),
  ];

  return builders;
}

/// Helper extensions for the factory builders.
extension StreamChatComponentBuildersExtension on BuildContext {
  /// The builder for the given component type.
  StreamComponentBuilder<T>? chatComponentBuilder<T>() => StreamComponentFactory.of(this).extension<T>();
}
