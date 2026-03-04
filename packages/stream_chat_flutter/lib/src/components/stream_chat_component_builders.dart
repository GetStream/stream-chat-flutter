import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Builds the list of component builders for the stream chat components.
Iterable<StreamComponentBuilderExtension<Object>> streamChatComponentBuilders({
  StreamComponentBuilderExtension<MessageComposerProps>? messageComposer,
  StreamComponentBuilderExtension<MessageComposerLeadingProps>? messageComposerLeading,
  StreamComponentBuilderExtension<MessageComposerTrailingProps>? messageComposerTrailing,
  StreamComponentBuilderExtension<MessageComposerInputProps>? messageComposerInput,
  StreamComponentBuilderExtension<MessageComposerInputLeadingProps>? messageComposerInputLeading,
  StreamComponentBuilderExtension<MessageComposerInputHeaderProps>? messageComposerInputHeader,
  StreamComponentBuilderExtension<MessageComposerInputTrailingProps>? messageComposerInputTrailing,
}) {
  return [
    messageComposer,
    messageComposerLeading,
    messageComposerTrailing,
    messageComposerInput,
    messageComposerInputLeading,
    messageComposerInputHeader,
    messageComposerInputTrailing,
  ].nonNulls;
}
