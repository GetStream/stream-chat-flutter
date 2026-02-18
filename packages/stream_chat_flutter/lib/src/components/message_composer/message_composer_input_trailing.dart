import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_factory.dart';
import 'package:stream_chat_flutter/src/components/message_composer/stream_chat_message_composer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A widget that shows the input trailing of the message composer.
/// Uses the factory to show custom components or the default implementation.
/// By default it shows the send button and the microphone button.
class StreamMessageComposerInputTrailing extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerInputTrailing].
  /// [props] contains the properties for the message composer component.
  const StreamMessageComposerInputTrailing({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    return StreamMessageComposerFactory.maybeOf(context)?.inputTrailing?.call(context, props) ??
        DefaultStreamMessageComposerInputTrailing(props: props);
  }
}

class DefaultStreamMessageComposerInputTrailing extends StatefulWidget {
  const DefaultStreamMessageComposerInputTrailing({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  State<DefaultStreamMessageComposerInputTrailing> createState() => _DefaultStreamMessageComposerInputTrailingState();
}

class _DefaultStreamMessageComposerInputTrailingState extends State<DefaultStreamMessageComposerInputTrailing> {
  var _hasText = false;
  StreamMessageInputController get controller => widget.props.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onInputTextChanged);
    _hasText = controller.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(DefaultStreamMessageComposerInputTrailing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller != oldWidget.props.controller) {
      oldWidget.props.controller.removeListener(_onInputTextChanged);
      controller.addListener(_onInputTextChanged);
    }
  }

  void _onInputTextChanged() {
    final hasText = controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onInputTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var buttonState = StreamMessageComposerInputTrailingState.microphone;
    if (widget.props.isAudioRecordingFlowActive) {
      buttonState = StreamMessageComposerInputTrailingState.voiceRecordingActive;
    }

    if (_hasText || widget.props.controller.attachments.isNotEmpty) {
      buttonState = StreamMessageComposerInputTrailingState.send;
    }

    return PortalTarget(
      anchor: const Aligned(
        offset: Offset(4, -16),
        target: Alignment.bottomRight,
        follower: Alignment.bottomRight,
      ),
      visible: false,
      portalFollower: SwipeToLockButton(isLocked: widget.props.audioRecorderState is RecordStateRecordingLocked),
      child: widget.props.isAudioRecordingFlowLocked || widget.props.isAudioRecordingFlowStopped
          ? const SizedBox.shrink()
          : StreamBaseMessageComposerInputTrailing(
              controller: widget.props.controller.textFieldController,
              onSendPressed: widget.props.onSendPressed,
              voiceRecordingCallback: widget.props.voiceRecordingCallback,
              buttonState: buttonState,
            ),
    );
  }
}
