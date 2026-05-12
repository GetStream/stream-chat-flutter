import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_center.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_header.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input_trailing.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that shows the input container of the message composer.
/// Uses the factory to show a fully custom container or the default
/// implementation that assembles the header, leading, center, and trailing
/// sub-components.
class StreamMessageComposerInput extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerInput].
  /// [props] contains the properties for the message composer input container.
  /// [inputCenterProps] contains the extra properties needed to build the
  /// center content (text-field configuration, audio recording settings, etc.).
  const StreamMessageComposerInput({
    super.key,
    required this.props,
    required this.inputCenterProps,
  });

  /// The properties for the message composer input container.
  final MessageComposerInputProps props;

  /// The properties for the center content of the input.
  final MessageComposerInputCenterProps inputCenterProps;

  @override
  Widget build(BuildContext context) {
    return context.chatComponentBuilder<MessageComposerInputProps>()?.call(context, props) ??
        DefaultStreamMessageComposerInput(
          props: props,
          inputCenterProps: inputCenterProps,
        );
  }
}

/// Default implementation of the message composer input container.
///
/// Renders the rounded input surface (background, border, optional shadow) and
/// assembles the header, leading, center and trailing sub-components into a
/// [Column] / [Row] layout identical to the former core widget.
class DefaultStreamMessageComposerInput extends StatelessWidget {
  /// Creates a new instance of [DefaultStreamMessageComposerInput].
  const DefaultStreamMessageComposerInput({
    super.key,
    required this.props,
    required this.inputCenterProps,
  });

  /// The properties for the message composer input container.
  final MessageComposerInputProps props;

  /// The properties for the center content of the input.
  final MessageComposerInputCenterProps inputCenterProps;

  @override
  Widget build(BuildContext context) {
    final isFloating = props.isFloating;

    return Container(
      clipBehavior: Clip.antiAlias,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(context.streamRadius.xxxl),
        border: Border.all(
          color: context.streamColorScheme.borderDefault,
        ),
      ),
      decoration: BoxDecoration(
        color: context.streamColorScheme.backgroundElevation1,
        borderRadius: BorderRadius.all(context.streamRadius.xxxl),
        boxShadow: isFloating ? context.streamBoxShadow.elevation3 : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamMessageComposerInputHeader(props: props),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StreamMessageComposerInputLeading(props: props),
              Expanded(
                child: StreamMessageComposerInputCenter(props: inputCenterProps),
              ),
              StreamMessageComposerInputTrailing(props: props),
            ],
          ),
        ],
      ),
    );
  }
}
