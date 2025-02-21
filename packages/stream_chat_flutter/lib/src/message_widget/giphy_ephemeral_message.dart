import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/giphy_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/misc/visible_footnote.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Signature for the action callback passed to [GiphyEphemeralMessage].
///
/// Used by [GiphyEphemeralMessage.onActionPressed].
typedef GiffyAction = void Function(String name, String value);

/// {@template giphyEphemeralMessage}
/// Shows an ephemeral message of type giphy in a [MessageWidget].
/// {@endtemplate}
class GiphyEphemeralMessage extends StatelessWidget {
  /// {@macro giphyEphemeralMessage}
  const GiphyEphemeralMessage({
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

    final chatTheme = StreamChatTheme.of(context);
    final textTheme = chatTheme.textTheme;
    final colorTheme = chatTheme.colorTheme;

    final divider = Divider(thickness: 1, height: 0, color: colorTheme.borders);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 304,
          height: 343,
          child: Column(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  color: colorTheme.barsBg,
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: GiphyHeader(title: giphy.title),
                      ),
                      divider,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: StreamGiphyAttachmentThumbnail(
                              giphy: giphy,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      divider,
                      SizedBox(
                        height: 48,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: GiphyActions(
                            giphy: giphy,
                            onActionPressed: onActionPressed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const StreamVisibleFootnote(),
                  const SizedBox(width: 4),
                  Text(
                    Jiffy.parseFromDateTime(message.createdAt.toLocal()).jm,
                    style: textTheme.footnote.copyWith(
                      color: colorTheme.textLowEmphasis,
                    ),
                  ),
                ],
              ),
            ],
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
    required this.giphy,
    required this.onActionPressed,
  });

  /// The underlying [Attachment] object which this widget represents.
  final Attachment giphy;

  /// Callback called when an action is pressed.
  final GiffyAction? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              onActionPressed?.call('image_action', 'cancel');
            },
            child: Text(
              context.translations.cancelLabel.capitalize(),
              style: textTheme.bodyBold.copyWith(
                color: colorTheme.textLowEmphasis,
              ),
            ),
          ),
        ),
        VerticalDivider(thickness: 1, width: 4, color: colorTheme.borders),
        Expanded(
          child: TextButton(
            onPressed: () {
              onActionPressed?.call('image_action', 'shuffle');
            },
            child: Text(
              context.translations.shuffleLabel.capitalize(),
              style: textTheme.bodyBold.copyWith(
                color: colorTheme.textLowEmphasis,
              ),
            ),
          ),
        ),
        VerticalDivider(thickness: 1, width: 4, color: colorTheme.borders),
        Expanded(
          child: TextButton(
            onPressed: () {
              onActionPressed?.call('image_action', 'send');
            },
            child: Text(
              context.translations.sendLabel.capitalize(),
              style: textTheme.bodyBold.copyWith(
                color: colorTheme.accentPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// {@template giphyHeader}
/// Shows the header for a giphy ephemeral message.
/// {@endtemplate}
class GiphyHeader extends StatelessWidget {
  /// {@macro giphyHeader}
  const GiphyHeader({super.key, this.title});

  /// The title of the giphy.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    return Row(
      children: [
        const StreamSvgIcon(icon: StreamSvgIcons.giphy),
        const SizedBox(width: 8),
        Text(
          context.translations.giphyLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        if (title != null)
          Expanded(
            child: Text(
              title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                // ignore: deprecated_member_use
                color: colorTheme.textHighEmphasis.withOpacity(0.5),
              ),
            ),
          ),
      ],
    );
  }
}
