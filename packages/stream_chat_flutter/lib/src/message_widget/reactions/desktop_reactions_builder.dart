// ignore_for_file: cascade_invocations

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reactions_card.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template desktopReactionsBuilder}
/// Builds a list of reactions to a message on desktop & web.
///
/// Not intended for use outside of [MessageWidgetContent].
/// {@endtemplate}
class DesktopReactionsBuilder extends StatefulWidget {
  /// {@macro desktopReactionsBuilder}
  const DesktopReactionsBuilder({
    super.key,
    required this.message,
    required this.messageTheme,
    this.onHover,
    this.borderSide,
    required this.reverse,
  });

  /// The message to show reactions for.
  final Message message;

  /// The theme to use for the reactions.
  ///
  /// [StreamMessageThemeData] is used because the design spec for desktop
  /// reactions matches the design spec for messages.
  final StreamMessageThemeData messageTheme;

  /// Callback to run when the mouse enters or exits the reactions.
  final OnReactionsHover? onHover;

  /// {@macro borderSide}
  final BorderSide? borderSide;

  /// {@macro reverse}
  final bool reverse;

  @override
  State<DesktopReactionsBuilder> createState() =>
      _DesktopReactionsBuilderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Message>('message', message),
    );
    properties.add(
      DiagnosticsProperty<StreamMessageThemeData>(
        'messageTheme',
        messageTheme,
      ),
    );
    properties.add(
      DiagnosticsProperty<BorderSide?>('borderSide', borderSide),
    );
    properties.add(DiagnosticsProperty<bool>('reverse', reverse));
  }
}

class _DesktopReactionsBuilderState extends State<DesktopReactionsBuilder> {
  bool _showReactionsPopup = false;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    final currentUser = streamChat.currentUser!;
    final reactionIcons = StreamChatConfiguration.of(context).reactionIcons;
    final streamChatTheme = StreamChatTheme.of(context);

    final reactionsMap = <String, Reaction>{};
    widget.message.latestReactions?.forEach((element) {
      if (!reactionsMap.containsKey(element.type) ||
          element.user!.id == currentUser.id) {
        reactionsMap[element.type] = element;
      }
    });

    final reactionsList = reactionsMap.values.toList()
      ..sort((a, b) => a.user!.id == currentUser.id ? 1 : -1);

    return PortalTarget(
      visible: _showReactionsPopup,
      portalCandidateLabels: const [kPortalMessageListViewLabel],
      anchor: Aligned(
        target: widget.reverse ? Alignment.topRight : Alignment.topLeft,
        follower: widget.reverse ? Alignment.bottomRight : Alignment.bottomLeft,
        shiftToWithinBound: const AxisFlag(y: true),
      ),
      portalFollower: MouseRegion(
        onEnter: (_) => _onReactionsHover(true),
        onExit: (_) => _onReactionsHover(false),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 336,
            maxHeight: 342,
          ),
          child: ReactionsCard(
            currentUser: currentUser,
            message: widget.message,
            messageTheme: widget.messageTheme,
          ),
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _onReactionsHover(true),
        onExit: (_) => _onReactionsHover(false),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 2,
            horizontal: widget.reverse ? 0 : 4,
          ),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ...reactionsList.map((reaction) {
                final reactionIcon = reactionIcons.firstWhereOrNull(
                  (r) => r.type == reaction.type,
                );

                return _BottomReaction(
                  currentUser: currentUser,
                  reaction: reaction,
                  message: widget.message,
                  borderSide: widget.borderSide,
                  messageTheme: widget.messageTheme,
                  reactionIcon: reactionIcon,
                  streamChatTheme: streamChatTheme,
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _onReactionsHover(bool isHovering) {
    if (widget.onHover != null) {
      return widget.onHover!(isHovering);
    }

    setState(() => _showReactionsPopup = isHovering);
  }
}

class _BottomReaction extends StatelessWidget {
  const _BottomReaction({
    required this.currentUser,
    required this.reaction,
    required this.message,
    required this.borderSide,
    required this.messageTheme,
    required this.reactionIcon,
    required this.streamChatTheme,
  });

  final User currentUser;
  final Reaction reaction;
  final Message message;
  final BorderSide? borderSide;
  final StreamMessageThemeData? messageTheme;
  final StreamReactionIcon? reactionIcon;
  final StreamChatThemeData streamChatTheme;

  @override
  Widget build(BuildContext context) {
    final userId = currentUser.id;

    final backgroundColor = messageTheme?.reactionsBackgroundColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (reaction.userId == userId) {
          StreamChannel.of(context).channel.deleteReaction(
                message,
                reaction,
              );
        } else if (reactionIcon != null) {
          StreamChannel.of(context).channel.sendReaction(
                message,
                reactionIcon!.type,
                score: reaction.score + 1,
                enforceUnique:
                    StreamChatConfiguration.of(context).enforceUniqueReactions,
              );
        }
      },
      child: Card(
        margin: EdgeInsets.zero,
        // Setting elevation as null when background color is transparent.
        // This is done to avoid shadow when background color is transparent.
        elevation: backgroundColor == Colors.transparent ? 0 : null,
        shape: RoundedRectangleBorder(
          side: borderSide ??
              BorderSide(
                color: messageTheme?.reactionsBorderColor ?? Colors.transparent,
              ),
          borderRadius: BorderRadius.circular(10),
        ),
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.tight(
                  const Size.square(14),
                ),
                child: reactionIcon?.builder(
                      context,
                      reaction.user?.id == userId,
                      14,
                    ) ??
                    Icon(
                      Icons.help_outline_rounded,
                      size: 14,
                      color: reaction.user?.id == userId
                          ? streamChatTheme.colorTheme.accentPrimary
                          : streamChatTheme.colorTheme.textLowEmphasis,
                    ),
              ),
              const SizedBox(width: 4),
              Text(
                '${reaction.score}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Reaction>('reaction', reaction));
    properties.add(DiagnosticsProperty<Message>('message', message));
  }
}
