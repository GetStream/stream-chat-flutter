import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// ignore_for_file: cascade_invocations

/// {@template desktopReactionsBuilder}
/// Builds a list of reactions to a message on desktop & web.
///
/// Not intended for use outside of [MessageWidgetContent].
/// {@endtemplate}
class DesktopReactionsBuilder extends StatefulWidget {
  /// {@macro desktopReactionsBuilder}
  const DesktopReactionsBuilder({
    super.key,
    required this.shouldShowReactions,
    required this.message,
    required this.messageTheme,
    this.borderSide,
    required this.reverse,
  });

  /// Whether reactions should be shown.
  final bool shouldShowReactions;

  /// The message to show reactions for.
  final Message message;

  /// The theme to use for the reactions.
  ///
  /// [StreamMessageThemeData] is used because the design spec for desktop
  /// reactions matches the design spec for messages.
  final StreamMessageThemeData messageTheme;

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
      DiagnosticsProperty<bool>(
        'shouldShowReactions',
        shouldShowReactions,
      ),
    );
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
    final reactionIcons = StreamChatConfiguration.of(context).reactionIcons;
    final streamChatTheme = StreamChatTheme.of(context);

    final reactionsMap = <String, Reaction>{};
    var reactionsList = <Reaction>[];
    if (widget.shouldShowReactions) {
      widget.message.latestReactions?.forEach((element) {
        if (!reactionsMap.containsKey(element.type) ||
            element.user!.id == streamChat.currentUser?.id) {
          reactionsMap[element.type] = element;
        }
      });

      reactionsList = reactionsMap.values.toList()
        ..sort((a, b) => a.user!.id == streamChat.currentUser?.id ? 1 : -1);
    }

    return PortalTarget(
      visible: _showReactionsPopup,
      portalCandidateLabels: const [kPortalMessageListViewLabel],
      anchor: Aligned(
        target: widget.reverse ? Alignment.topRight : Alignment.topLeft,
        follower: widget.reverse ? Alignment.bottomRight : Alignment.bottomLeft,
        shiftToWithinBound: const AxisFlag(
          y: true,
        ),
      ),
      portalFollower: MouseRegion(
        onEnter: (event) async {
          setState(() => _showReactionsPopup = !_showReactionsPopup);
        },
        onExit: (event) {
          setState(() => _showReactionsPopup = !_showReactionsPopup);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 336,
            maxHeight: 342,
          ),
          child: Card(
            color: streamChatTheme.colorTheme.barsBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '''${widget.message.latestReactions!.length} ${context.translations.messageReactionsLabel}''',
                    style: streamChatTheme.textTheme.headlineBold,
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        ...widget.message.latestReactions!.map((reaction) {
                          final reactionIcon = reactionIcons.firstWhereOrNull(
                            (r) => r.type == reaction.type,
                          );
                          return _StackedReaction(
                            reaction: reaction,
                            streamChatTheme: streamChatTheme,
                            reactionIcon: reactionIcon,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) async {
          setState(() => _showReactionsPopup = !_showReactionsPopup);
        },
        onExit: (event) {
          setState(() => _showReactionsPopup = !_showReactionsPopup);
        },
        child: Wrap(
          children: [
            ...reactionsList.map((reaction) {
              final reactionIcon = reactionIcons.firstWhereOrNull(
                (r) => r.type == reaction.type,
              );

              return _BottomReaction(
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
    );
  }
}

class _BottomReaction extends StatelessWidget {
  const _BottomReaction({
    required this.reaction,
    required this.message,
    required this.borderSide,
    required this.messageTheme,
    required this.reactionIcon,
    required this.streamChatTheme,
  });

  final Reaction reaction;
  final Message message;
  final BorderSide? borderSide;
  final StreamMessageThemeData? messageTheme;
  final StreamReactionIcon? reactionIcon;
  final StreamChatThemeData streamChatTheme;

  @override
  Widget build(BuildContext context) {
    final userId = StreamChat.of(context).currentUser?.id;
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
        shape: StadiumBorder(
          side: borderSide ??
              BorderSide(
                color: messageTheme?.messageBorderColor ?? Colors.grey,
              ),
        ),
        color: messageTheme?.messageBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.tight(
                  const Size.square(16),
                ),
                child: reactionIcon?.builder(
                      context,
                      reaction.user?.id == userId,
                      16,
                    ) ??
                    Icon(
                      Icons.help_outline_rounded,
                      size: 16,
                      color: reaction.user?.id == userId
                          ? streamChatTheme.colorTheme.accentPrimary
                          : streamChatTheme.colorTheme.textHighEmphasis
                              .withOpacity(0.5),
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

class _StackedReaction extends StatelessWidget {
  const _StackedReaction({
    required this.reaction,
    required this.streamChatTheme,
    required this.reactionIcon,
  });

  final Reaction reaction;
  final StreamChatThemeData streamChatTheme;
  final StreamReactionIcon? reactionIcon;

  @override
  Widget build(BuildContext context) {
    final userId = StreamChat.of(context).currentUser?.id;
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Stack(
            children: [
              StreamUserAvatar(
                user: reaction.user!,
                constraints: const BoxConstraints.tightFor(
                  height: 64,
                  width: 64,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: streamChatTheme.colorTheme.inputBg,
                    border: Border.all(
                      color: streamChatTheme.colorTheme.barsBg,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: reactionIcon?.builder(
                          context,
                          reaction.userId == userId,
                          16,
                        ) ??
                        Icon(
                          Icons.help_outline_rounded,
                          size: 16,
                          color: reaction.user?.id == userId
                              ? streamChatTheme.colorTheme.accentPrimary
                              : streamChatTheme.colorTheme.textHighEmphasis
                                  .withOpacity(0.5),
                        ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            userId == reaction.user!.name ? 'You' : reaction.user!.name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Reaction>('reaction', reaction),
    );
    properties.add(
      DiagnosticsProperty<StreamReactionIcon?>(
        'reactionIcon',
        reactionIcon,
      ),
    );
  }
}
