import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that shows the leading of the message composer.
/// Uses the factory to show custom components or the default implementation.
/// By default this contains a button to add attachments.
class StreamMessageComposerLeading extends StatelessWidget {
  /// Creates a new instance of [StreamMessageComposerLeading].
  /// [props] contains the properties for the message composer component.
  const StreamMessageComposerLeading({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    final leadingProps = MessageComposerLeadingProps.from(props);

    return context.chatComponentBuilder<MessageComposerLeadingProps>()?.call(context, leadingProps) ??
        DefaultStreamMessageComposerLeading(props: leadingProps);
  }
}

/// Default implementation of the leading of the message composer.
/// Shows the attachment button when the message composer is not in audio recording flow and no command is selected.
class DefaultStreamMessageComposerLeading extends StatelessWidget {
  /// Creates a new instance of [DefaultStreamMessageComposerLeading].
  /// [props] contains the properties for the message composer component.
  const DefaultStreamMessageComposerLeading({super.key, required this.props});

  /// The properties for the message composer component.
  final MessageComposerComponentProps props;

  @override
  Widget build(BuildContext context) {
    // 45 degrees = 0.125 turns
    const closedRotation = 0.125;
    final showButton =
        props.onAttachmentButtonPressed != null &&
        !props.isAudioRecordingFlowActive &&
        props.controller.message.command == null;

    final localizations = MaterialLocalizations.of(context);

    return AnimatedOpacity(
      opacity: showButton ? 1.0 : 0.0,
      duration: showButton ? const Duration(milliseconds: 200) : Duration.zero,
      curve: Curves.easeInQuint,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            if (showButton) ...[
              MergeSemantics(
                // Hint overrides is only supported on Android, so we use the
                // hint for iOS and macOS and the onTapHint for Android.
                child: Semantics(
                  hint: switch ((Theme.of(context).platform, props.isPickerOpen)) {
                    (.iOS || .macOS, true) => localizations.expansionTileExpandedHint,
                    (.iOS || .macOS, false) => localizations.expansionTileCollapsedHint,
                    _ => null,
                  },
                  onTapHint: switch (props.isPickerOpen) {
                    true => localizations.expandedIconTapHint,
                    false => localizations.collapsedIconTapHint,
                  },
                  child: StreamButton.icon(
                    icon: AnimatedRotation(
                      turns: props.isPickerOpen ? closedRotation : 0,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      child: Icon(context.streamIcons.plus),
                    ),
                    style: StreamButtonStyle.secondary,
                    type: StreamButtonType.outline,
                    size: StreamButtonSize.large,
                    isFloating: props.isFloating,
                    tooltip: context.translations.accessibility.attachmentPickerTooltip,
                    onPressed: props.isSlowModeActive ? null : props.onAttachmentButtonPressed,
                  ),
                ),
              ),
              SizedBox(width: context.streamSpacing.xs),
            ],
          ],
        ),
      ),
    );
  }
}
