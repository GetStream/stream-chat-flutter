import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/stream_chat_message_composer.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' show StreamComponentBuilder;

class StreamMessageComposerFactory {
  StreamMessageComposerFactory({
    this.messageComposer,
    this.leading,
    this.trailing,
    this.input,
    this.inputLeading,
    this.inputHeader,
    this.inputTrailing,
  });

  final StreamComponentBuilder<MessageComposerProps>? messageComposer;
  final StreamComponentBuilder<MessageComposerComponentProps>? leading;
  final StreamComponentBuilder<MessageComposerComponentProps>? trailing;
  final StreamComponentBuilder<MessageComposerComponentProps>? input;
  final StreamComponentBuilder<MessageComposerComponentProps>? inputLeading;
  final StreamComponentBuilder<MessageComposerComponentProps>? inputHeader;
  final StreamComponentBuilder<MessageComposerComponentProps>? inputTrailing;

  // placeholder for real implementation
  static StreamMessageComposerFactory? maybeOf(BuildContext context) {
    return StreamMessageComposerFactory();
  }
}
