import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Helper extensions for internal use only.
extension MessageComposerBuilderExtensions on BuildContext {
  StreamComponentBuilders get _factory => StreamComponentFactory.of(
    this,
  );

  /// The builder for the message composer component.
  StreamComponentBuilder<MessageComposerProps>? get messageComposerBuilder =>
      _factory.extension<MessageComposerProps>();

  /// The builder for the message composer leading component.
  StreamComponentBuilder<MessageComposerLeadingProps>? get messageComposerLeadingBuilder =>
      _factory.extension<MessageComposerLeadingProps>();

  /// The builder for the message composer trailing component.
  StreamComponentBuilder<MessageComposerTrailingProps>? get messageComposerTrailingBuilder =>
      _factory.extension<MessageComposerTrailingProps>();

  /// The builder for the message composer input component.
  StreamComponentBuilder<MessageComposerInputProps>? get messageComposerInputBuilder =>
      _factory.extension<MessageComposerInputProps>();

  /// The builder for the message composer input leading component.
  StreamComponentBuilder<MessageComposerInputLeadingProps>? get messageComposerInputLeadingBuilder =>
      _factory.extension<MessageComposerInputLeadingProps>();

  /// The builder for the message composer input header component.
  StreamComponentBuilder<MessageComposerInputHeaderProps>? get messageComposerInputHeaderBuilder =>
      _factory.extension<MessageComposerInputHeaderProps>();

  /// The builder for the message composer input trailing component.
  StreamComponentBuilder<MessageComposerInputTrailingProps>? get messageComposerInputTrailingBuilder =>
      _factory.extension<MessageComposerInputTrailingProps>();
}
