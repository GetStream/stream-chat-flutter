import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/avatar/stream_user_avatar.dart';
import 'package:stream_chat_flutter/src/message_action/message_action.dart';
import 'package:stream_chat_flutter/src/scroll_view/reaction_scroll_view/stream_reaction_list_view.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A bottom sheet that displays detailed reaction information for a message.
///
/// Shows the total reaction count, emoji filter chips for each reaction type,
/// and a paginated scrollable list of users who reacted.
///
/// Reactions are fetched from the server using [StreamReactionListController],
/// supporting cursor-based pagination for large reaction lists.
///
/// Use [ReactionDetailSheet.show] to display the sheet.
class ReactionDetailSheet extends StatefulWidget {
  /// Creates a reaction detail sheet.
  ///
  /// This constructor is private. Use [ReactionDetailSheet.show] to display
  /// the sheet as a modal bottom sheet.
  const ReactionDetailSheet._({
    required this.scrollController,
    required this.message,
    this.initialReactionType,
  });

  /// The message whose reactions are displayed.
  final Message message;

  /// Scroll controller provided by [DraggableScrollableSheet].
  final ScrollController scrollController;

  /// The reaction type to pre-select when the sheet opens.
  ///
  /// When non-null, the sheet opens with this reaction type already filtered
  /// and the corresponding chip scrolled into view.
  final String? initialReactionType;

  /// Shows the reaction detail sheet as a modal bottom sheet.
  ///
  /// Returns a [SelectReaction] if the user selects a reaction, or `null`
  /// if the sheet is dismissed without any selection.
  static Future<MessageAction?> show({
    required BuildContext context,
    required Message message,
    String? initialReactionType,
  }) {
    final radius = context.streamRadius;
    final colorScheme = context.streamColorScheme;

    return showModalBottomSheet<MessageAction>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: colorScheme.backgroundElevation1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: radius.xxxxl,
          topEnd: radius.xxxxl,
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        snap: true,
        expand: false,
        minChildSize: 0.5,
        snapSizes: const [0.5, 1],
        builder: (_, scrollController) => ReactionDetailSheet._(
          scrollController: scrollController,
          message: message,
          initialReactionType: initialReactionType,
        ),
      ),
    );
  }

  @override
  State<ReactionDetailSheet> createState() => _ReactionDetailSheetState();
}

class _ReactionDetailSheetState extends State<ReactionDetailSheet> {
  late StreamReactionListController _controller;
  late String? _currentReactionType = widget.initialReactionType;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant ReactionDetailSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.id != widget.message.id) {
      _controller.dispose(); // Dispose the old controller.
      _initializeController(); // Initialize a new controller.
    }
  }

  void _initializeController() {
    _controller = .new(
      client: StreamChat.of(context).client,
      messageId: widget.message.id,
      sort: const [.desc(ReactionSortKey.createdAt)],
      filter: switch (_currentReactionType) {
        final type? => .equal('type', type),
        _ => null,
      },
    );
  }

  void _onReactionTypeSelected(String? type) {
    if (type == _currentReactionType) return;
    setState(() => _currentReactionType = type);

    final updatedFilter = switch (type) {
      final type? => Filter.equal('type', type),
      _ => null,
    };

    _controller.filter = updatedFilter;
    _controller.doInitialLoad();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;

    final config = StreamChatConfiguration.of(context);
    final resolver = config.reactionIconResolver;

    final ownReactions = [...?widget.message.ownReactions];
    final ownReactionsMap = {for (final it in ownReactions) it.type: it};
    final reactionGroups = widget.message.reactionGroups ?? {};

    final currentUserId = StreamChatCore.of(context).currentUser?.id;

    final visibleCount = switch (_currentReactionType) {
      final type? => reactionGroups[type]?.count ?? 0,
      _ => reactionGroups.values.fold(0, (sum, g) => sum + g.count),
    };

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: .symmetric(horizontal: spacing.sm),
          child: Text(
            context.translations.reactionsCountText(visibleCount),
            textAlign: .center,
            style: textTheme.headingSm,
          ),
        ),
        SizedBox(height: spacing.sm),
        StreamEmojiChipBar(
          selected: _currentReactionType,
          onSelected: _onReactionTypeSelected,
          items: [
            for (final MapEntry(:key, :value) in reactionGroups.entries)
              StreamEmojiChipItem(
                value: key,
                emoji: resolver.resolve(key),
                count: value.count,
              ),
          ],
          leading: StreamEmojiChip.addEmoji(
            onPressed: () async {
              final selectedReactions = ownReactionsMap.keys.toSet();
              final emoji = await StreamEmojiPickerSheet.show(
                context: context,
                selectedReactions: selectedReactions,
              );

              if (!context.mounted) return;
              if (emoji == null) return Navigator.of(context).pop();

              final reaction = Reaction(type: emoji.shortName, emojiCode: emoji.emoji);
              return Navigator.of(context).pop(SelectReaction(message: widget.message, reaction: reaction));
            },
          ),
        ),
        SizedBox(height: spacing.md),
        Expanded(
          child: StreamReactionListView(
            controller: _controller,
            scrollController: widget.scrollController,
            padding: .symmetric(horizontal: spacing.xxs),
            itemBuilder: (context, reactions, index) {
              final reaction = reactions[index];
              final user = reaction.user;
              if (user == null) return const SizedBox.shrink();

              final isOwnReaction = currentUserId != null && reaction.userId == currentUserId;

              return StreamListTile(
                leading: StreamUserAvatar(size: .md, user: user, showOnlineIndicator: false),
                title: Text(user.name),
                subtitle: isOwnReaction ? Text(context.translations.tapToRemoveReactionLabel) : null,
                trailing: StreamEmoji(size: .md, emoji: resolver.resolve(reaction.type)),
                onTap: switch (isOwnReaction) {
                  true => () {
                    final action = SelectReaction(message: widget.message, reaction: reaction);
                    return Navigator.of(context).pop(action);
                  },
                  _ => null,
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
