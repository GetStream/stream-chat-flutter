import 'package:flutter/material.dart' hide Action;
import 'package:stream_chat_flutter/src/attachment/giphy_attachment.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_metadata.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Signature for the action callback passed to [GiphyEphemeralMessage].
///
/// Used by [GiphyEphemeralMessage.onActionPressed].
typedef GiffyAction = void Function(String name, String value);

const _kDefaultConstraints = BoxConstraints(maxWidth: 282);
const _kDefaultGiphyConstraints = BoxConstraints(minWidth: 128, maxWidth: 282, maxHeight: 282);

/// {@template giphyEphemeralMessage}
/// Shows an ephemeral message of type giphy in a [MessageWidget].
/// {@endtemplate}
class GiphyEphemeralMessage extends StatelessWidget {
  /// {@macro giphyEphemeralMessage}
  const GiphyEphemeralMessage({
    super.key,
    required this.message,
    this.constraints,
    this.onActionPressed,
  });

  /// The underlying [Message] object which this widget represents.
  final Message message;

  /// The constraints to apply to the overall widget layout.
  final BoxConstraints? constraints;

  /// Callback called when an action is pressed.
  final GiffyAction? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final giphy = message.attachments.first;

    final actions = giphy.actions;
    assert(actions != null && actions.isNotEmpty, 'actions cannot be null');

    final spacing = context.streamSpacing;

    final effectiveConstraints = constraints ?? _kDefaultConstraints;

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
            child: ConstrainedBox(
              constraints: effectiveConstraints,
              child: core.StreamMessageContent(
                footer: StreamMessageMetadata(message: message),
                child: core.StreamMessageBubble(
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .stretch,
                    children: [
                      GiphyHeader(title: context.translations.onlyVisibleToYouText),
                      Center(
                        child: StreamGiphyAttachment(
                          message: message,
                          giphy: giphy,
                          constraints: _kDefaultGiphyConstraints,
                        ),
                      ),
                      GiphyActions(actions: actions!, onActionPressed: onActionPressed),
                    ],
                  ),
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
      padding: .symmetric(horizontal: spacing.xxs),
      child: Row(
        mainAxisSize: .min,
        spacing: spacing.xs,
        mainAxisAlignment: .spaceEvenly,
        children: [
          ...actions.map(
            (action) {
              final style = switch (action.style) {
                'primary' => core.StreamButtonStyle.primary,
                _ => core.StreamButtonStyle.secondary,
              };

              return core.StreamButton(
                label: action.text,
                style: style,
                type: .ghost,
                size: .small,
                onTap: switch (onActionPressed) {
                  final onPressed? => () => onPressed(
                    action.name.toLowerCase(),
                    action.text.toLowerCase(),
                  ),
                  _ => null,
                },
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
          Icon(icons.eyeFill16, size: 16, color: colorScheme.brand.shade900),
          Text(title, style: textTheme.captionEmphasis.copyWith(color: colorScheme.brand.shade900)),
        ],
      ),
    );
  }
}
