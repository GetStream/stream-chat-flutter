import 'package:flutter/material.dart' hide Action;
import 'package:stream_chat_flutter/src/attachment/giphy_attachment.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_footer.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart' as core;

/// Signature for the action callback passed to [StreamGiphyEphemeralMessage].
///
/// Used by [StreamGiphyEphemeralMessage.onActionPressed].
typedef GiffyAction = void Function(String name, String value);

const _kDefaultGiphyConstraints = BoxConstraints(minWidth: 128);

/// {@template streamGiphyEphemeralMessage}
/// Shows an ephemeral message of type giphy in a [MessageWidget].
/// {@endtemplate}
class StreamGiphyEphemeralMessage extends StatelessWidget {
  /// {@macro streamGiphyEphemeralMessage}
  const StreamGiphyEphemeralMessage({
    super.key,
    required this.message,
    this.onActionPressed,
  });

  /// The underlying [Message] object which this widget represents.
  final Message message;

  /// Callback called when an action is pressed.
  final GiffyAction? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final giphy = message.attachments.first;

    final actions = giphy.actions;
    assert(actions != null && actions.isNotEmpty, 'actions cannot be null');

    final spacing = context.streamSpacing;

    return core.StreamMessageLayout(
      data: const core.StreamMessageLayoutData(
        alignment: .end,
        stackPosition: .single,
        contentKind: .singleAttachment,
      ),
      child: Builder(
        builder: (context) => Align(
          alignment: core.StreamMessageLayout.alignmentDirectionalOf(context),
          child: Padding(
            padding: .symmetric(horizontal: spacing.md),
            child: core.StreamMessageContent(
              footer: StreamMessageFooter(message: message),
              child: core.StreamMessageBubble(
                child: core.StreamIntrinsicColumn(
                  crossAxisAlignment: .start,
                  children: [
                    GiphyHeader(title: context.translations.onlyVisibleToYouText),
                    Center(
                      child: StreamGiphyAttachment(
                        message: message,
                        giphy: giphy,
                        constraints: _kDefaultGiphyConstraints,
                      ),
                    ),
                    core.StreamIntrinsicSizeCandidate(
                      child: GiphyActions(actions: actions!, onActionPressed: onActionPressed),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template giphyActions}
/// Shows the actions for a giphy ephemeral message.
/// {@endtemplate}
class GiphyActions extends StatelessWidget {
  /// {@macro giphyActions}
  const GiphyActions({
    super.key,
    required this.actions,
    required this.onActionPressed,
  });

  /// The underlying [Attachment] object which this widget represents.
  final List<Action> actions;

  /// Callback called when an action is pressed.
  final GiffyAction? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Padding(
      padding: .symmetric(horizontal: spacing.xs),
      child: Wrap(
        alignment: .spaceEvenly,
        children: [
          ...actions.map(
            (action) {
              final style = switch (action.style) {
                'primary' => core.StreamButtonStyle.primary,
                _ => core.StreamButtonStyle.secondary,
              };

              return core.StreamButton(
                style: style,
                type: .ghost,
                size: .small,
                onPressed: switch (onActionPressed) {
                  final onPressed? => () => onPressed(
                    action.name.toLowerCase(),
                    action.text.toLowerCase(),
                  ),
                  _ => null,
                },
                child: Text(action.text),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// {@template giphyHeader}
/// Shows the header for a giphy ephemeral message.
/// {@endtemplate}
class GiphyHeader extends StatelessWidget {
  /// {@macro giphyHeader}
  const GiphyHeader({super.key, required this.title});

  /// The title of the giphy.
  final String title;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: spacing.xs,
        horizontal: spacing.sm,
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: spacing.xs,
        children: [
          Icon(icons.eyeFill, size: 16, color: colorScheme.brand.shade900),
          Text(title, style: textTheme.captionEmphasis.copyWith(color: colorScheme.brand.shade900)),
        ],
      ),
    );
  }
}
