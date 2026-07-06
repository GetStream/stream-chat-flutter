import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_input.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_leading.dart';
import 'package:stream_chat_flutter/src/components/message_composer/message_composer_trailing.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that shows the message composer.
/// Uses the factory to show custom components or the default implementation.
class StreamChatMessageInput extends StatefulWidget {
  /// Creates a new instance of [StreamChatMessageInput].
  /// [controller] is the controller for the message composer.
  /// [onSendPressed] is the callback for when the send button is pressed.
  /// [onAttachmentButtonPressed] is the callback for when the attachment button is pressed.
  /// [focusNode] is the focus node for the message composer.
  /// [currentUserId] is the current user id.
  /// [placeholder] is the placeholder text of the message composer.
  const StreamChatMessageInput({
    super.key,
    this.controller,
    required this.onSendPressed,
    this.onAttachmentButtonPressed,
    this.isPickerOpen = false,
    this.focusNode,
    this.currentUserId,
    this.placeholder,
    this.audioRecorderController,
    this.sendVoiceRecordingAutomatically = false,
    this.feedback = const AudioRecorderFeedback(),
    this.canAlsoSendToChannel = false,
    this.onQuotedMessageCleared,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.autofocus = false,
    this.autocorrect = true,
    this.isFloating = false,
  });

  /// The controller for the message composer.
  final StreamMessageComposerController? controller;

  /// The callback for when the send button is pressed.
  final VoidCallback onSendPressed;

  /// The callback for when the attachment button is pressed.
  final VoidCallback? onAttachmentButtonPressed;

  /// Whether the inline attachment picker is currently open.
  final bool isPickerOpen;

  /// The focus node for the message composer.
  final FocusNode? focusNode;

  /// The current user id.
  final String? currentUserId;

  /// The placeholder text of the message composer.
  ///
  /// May be `null` to render the input with no placeholder. The wrapping
  /// [StreamMessageComposer] resolves this string reactively from its
  /// [StreamMessageComposerController] via [MessageInputPlaceholder.resolve] and
  /// [StreamMessageComposer.placeholderBuilder]; when using
  /// [StreamChatMessageInput] directly, supply the string yourself.
  final String? placeholder;

  /// The audio recorder controller.
  final StreamAudioRecorderController? audioRecorderController;

  /// Whether the voice recording should be sent automatically when recording stops.
  final bool sendVoiceRecordingAutomatically;

  /// The feedback handler for voice recording interactions.
  final AudioRecorderFeedback feedback;

  /// Whether to show the "also send to channel" checkbox.
  /// Usually used in threads.
  final bool canAlsoSendToChannel;

  /// Callback for when the quoted message is cleared.
  final VoidCallback? onQuotedMessageCleared;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// Whether the text field should be focused initially.
  final bool autofocus;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether the message composer is floating.
  final bool isFloating;

  @override
  State<StreamChatMessageInput> createState() => _StreamChatMessageInputState();
}

class _StreamChatMessageInputState extends State<StreamChatMessageInput> {
  late StreamMessageComposerController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
    widget.audioRecorderController?.addListener(_onAudioRecorderChanged);
    // Update the snackbar based on the initial state of the audio recorder controller
    // after the first frame is rendered, to ensure that the BuildContext is fully available for showing the snackbar.
    WidgetsBinding.instance.addPostFrameCallback((_) => _onAudioRecorderChanged());
  }

  @override
  void didUpdateWidget(StreamChatMessageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) _controller.dispose();
      _initController();
    }
    if (widget.audioRecorderController != oldWidget.audioRecorderController) {
      oldWidget.audioRecorderController?.removeListener(_onAudioRecorderChanged);
      widget.audioRecorderController?.addListener(_onAudioRecorderChanged);
      _onAudioRecorderChanged(); // Update the snackbar based on the new controller's state immediately.
    }
  }

  @override
  void dispose() {
    widget.audioRecorderController?.removeListener(_onAudioRecorderChanged);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _initController() {
    _controller = widget.controller ?? StreamMessageComposerController();
  }

  // Listens to changes in the audio recorder controller and shows/hides a snackbar
  // with the current message, if any.
  void _onAudioRecorderChanged() {
    if (!mounted) return;

    final state = widget.audioRecorderController?.value;
    final message = state is RecordStateIdle ? state.message : null;
    final messenger = StreamSnackbarMessenger.maybeOf(context);

    if (message == null || message.isEmpty) return messenger?.removeCurrent();

    final controller = messenger?.show(
      replace: true,
      StreamSnackbar(
        message: Text(message),
        onVisible: () => StreamSemanticsAnnouncer.announce(context, message),
      ),
    );
    if (controller == null) return;

    // Notify the recorder controller when the snackbar is closed, so it can clear
    // the message and avoid showing stale messages if the user triggers the recorder again.
    controller.closed.then((_) {
      if (!mounted) return;
      return widget.audioRecorderController?.hideInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioRecorderController = widget.audioRecorderController;
    if (audioRecorderController == null) {
      return _StreamChatMessageInputContent(
        widget: widget,
        inputController: _controller,
      );
    }

    return ValueListenableBuilder(
      valueListenable: audioRecorderController,
      builder: (context, state, _) {
        final streamSpacing = context.streamSpacing;
        final textDirection = Directionality.maybeOf(context);

        const targetAlignment = AlignmentDirectional.topEnd;
        const followerAlignment = AlignmentDirectional.bottomEnd;

        return PortalTarget(
          anchor: Aligned(
            target: targetAlignment.resolve(textDirection),
            follower: followerAlignment.resolve(textDirection),
            offset: Offset(-streamSpacing.md, -streamSpacing.md).directional(textDirection),
          ),
          visible: state is RecordStateRecording,
          portalFollower: SwipeToLockButton(isLocked: state is RecordStateRecordingLocked),
          child: _StreamChatMessageInputContent(
            widget: widget,
            inputController: _controller,
            audioRecorderState: state,
          ),
        );
      },
    );
  }
}

extension on StreamAudioRecorderController {
  bool get isRecording => value is RecordStateRecording;
  bool get isLocked => isRecording && value is! RecordStateRecordingHold;
}

// The actual UI content of the message composer.
class _StreamChatMessageInputContent extends StatelessWidget {
  const _StreamChatMessageInputContent({
    required this.widget,
    required this.inputController,
    this.audioRecorderState = const RecordStateIdle(),
  });

  final StreamChatMessageInput widget;
  final StreamMessageComposerController inputController;
  final AudioRecorderState audioRecorderState;

  static const double _lockRecordThreshold = 50;
  static const double _cancelRecordThreshold = 75;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return ValueListenableBuilder(
      valueListenable: inputController,
      builder: (context, value, child) {
        final cooldownTimeOut = inputController.isSlowModeActive ? inputController.cooldownTimeOut : null;

        final componentProps = MessageComposerComponentProps(
          controller: inputController,
          isFloating: widget.isFloating,
          currentUserId: widget.currentUserId,
          onSendPressed: widget.onSendPressed,
          voiceRecordingCallback: _createVoiceRecordingCallback(context),
          onAttachmentButtonPressed: widget.onAttachmentButtonPressed,
          isPickerOpen: widget.isPickerOpen,
          audioRecorderState: audioRecorderState,
          focusNode: widget.focusNode,
          onQuotedMessageCleared: widget.onQuotedMessageCleared,
          cooldownTimeOut: cooldownTimeOut,
        );

        final inputProps = MessageComposerInputProps.from(
          componentProps,
          placeholder: widget.placeholder,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          autofocus: widget.autofocus,
          autocorrect: widget.autocorrect,
          canAlsoSendToChannel: widget.canAlsoSendToChannel,
          audioRecorderController: widget.audioRecorderController,
          feedback: widget.feedback,
          sendVoiceRecordingAutomatically: widget.sendVoiceRecordingAutomatically,
        );

        return Container(
          padding: EdgeInsets.only(top: spacing.md, right: spacing.md, left: spacing.md),
          decoration: widget.isFloating
              ? null
              : BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.streamColorScheme.borderDefault),
                  ),
                ),
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StreamMessageComposerLeading(props: componentProps),
                Expanded(
                  child: StreamMessageComposerInput(props: inputProps),
                ),
                StreamMessageComposerTrailing(props: componentProps),
              ],
            ),
          ),
        );
      },
    );
  }

  VoiceRecordingCallback? _createVoiceRecordingCallback(BuildContext context) {
    if (widget.audioRecorderController case final audioRecorderController?) {
      return VoiceRecordingCallback(
        onLongPressStart: () async {
          // Return if the recording is already started.
          if (audioRecorderController.isRecording) return;

          await widget.feedback.onRecordStart(context);
          return audioRecorderController.startRecord();
        },
        onLongPressEnd: (_) async {
          // Return if the recording not yet started or already locked.
          if (!audioRecorderController.isRecording || audioRecorderController.isLocked) return;

          await widget.feedback.onRecordFinish(context);
          final audio = await audioRecorderController.finishRecord();
          if (audio != null) {
            inputController.addAttachment(audio);
          }

          // Once the recording is finished, cancel the recorder.
          audioRecorderController.cancelRecord(discardTrack: false);

          // Send the message if the user has enabled the option to
          // send the voice recording automatically.
          if (widget.sendVoiceRecordingAutomatically) {
            return widget.onSendPressed.call();
          }
        },
        onLongPressCancel: () async {
          // Return if the recording is already started.
          if (audioRecorderController.isRecording) return;

          // Capture the label before the async gap to avoid using a potentially
          // unmounted BuildContext after awaiting.
          final holdLabel = context.translations.holdToRecordLabel;

          // Notify the parent that the recorder is canceled before it starts.
          await widget.feedback.onRecordStartCancel(context);
          // Show a message to the user to hold to record.
          audioRecorderController.showInfo(holdLabel);
        },
        onLongPressMoveUpdate: (details) async {
          // Return if the recording not yet started or already locked.
          if (!audioRecorderController.isRecording || audioRecorderController.isLocked) return;
          final dragOffset = details.offsetFromOrigin;

          // Lock recording if the drag offset is greater than the threshold.
          if (dragOffset.dy <= -_lockRecordThreshold) {
            await widget.feedback.onRecordLock(context);
            return audioRecorderController.lockRecord();
          }
          // Cancel recording if the drag offset is greater than the threshold.
          if (dragOffset.dx <= -_cancelRecordThreshold) {
            await widget.feedback.onRecordCancel(context);
            return audioRecorderController.cancelRecord();
          }

          // Update the drag offset.
          return audioRecorderController.dragRecord(dragOffset);
        },
      );
    }
    return null;
  }
}
