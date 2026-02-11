import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/stream_chat_message_composer.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' show StreamComponentBuilder;

/// A factory for building the message composer components.
class StreamMessageComposerFactory {
  /// Creates a new instance of [StreamMessageComposerFactory].
  const StreamMessageComposerFactory({
    this.messageComposer,
    this.leading,
    this.trailing,
    this.input,
    this.inputLeading,
    this.inputHeader,
    this.inputTrailing,
  });

  /// The main message composer component. Provide a builder if you want full control over the message composer.
  final StreamComponentBuilder<MessageComposerProps>? messageComposer;

  /// The leading component of the message composer. This is shown before the text input.
  /// By default this contains a button to add attachments.
  final StreamComponentBuilder<MessageComposerComponentProps>? leading;

  /// The trailing component of the message composer. This is shown after the text input.
  /// By default this area is empty.
  final StreamComponentBuilder<MessageComposerComponentProps>? trailing;

  /// The input component of the message composer.
  final StreamComponentBuilder<MessageComposerComponentProps>? input;

  /// The leading component of the input area.
  /// This is shown before the text input, but inside of the input area.
  /// By default this area is empty.
  final StreamComponentBuilder<MessageComposerComponentProps>? inputLeading;

  /// The header component of the input area. This is shown above the text input.
  /// By default it shows the quoted message, attachments and OG attachment previews.
  final StreamComponentBuilder<MessageComposerComponentProps>? inputHeader;

  /// The trailing component of the input area. This is shown after the text input.
  /// By default it shows the send button and the microphone button.
  final StreamComponentBuilder<MessageComposerComponentProps>? inputTrailing;

  /// placeholder for real implementation
  static StreamMessageComposerFactory? maybeOf(BuildContext context) {
    return const StreamMessageComposerFactory();
  }
}
