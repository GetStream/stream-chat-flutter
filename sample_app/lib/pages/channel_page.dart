// ignore_for_file: deprecated_member_use

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/pages/thread_page.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({
    super.key,
    this.initialScrollIndex,
    this.initialAlignment,
    this.highlightInitialMessage = false,
  });
  final int? initialScrollIndex;
  final double? initialAlignment;
  final bool highlightInitialMessage;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  FocusNode? _focusNode;
  final StreamMessageInputController _messageInputController =
      StreamMessageInputController();

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: StreamChannelHeader(
        showTypingIndicator: false,
        onBackPressed: () => GoRouter.of(context).pop(),
        onImageTap: () async {
          final channel = StreamChannel.of(context).channel;
          final router = GoRouter.of(context);

          if (channel.memberCount == 2 && channel.isDistinct) {
            final currentUser = StreamChat.of(context).currentUser;
            final otherUser = channel.state!.members.firstWhereOrNull(
              (element) => element.user!.id != currentUser!.id,
            );
            if (otherUser != null) {
              router.pushNamed(
                Routes.CHAT_INFO_SCREEN.name,
                pathParameters: Routes.CHAT_INFO_SCREEN.params(channel),
                extra: otherUser.user,
              );
            }
          } else {
            GoRouter.of(context).pushNamed(
              Routes.GROUP_INFO_SCREEN.name,
              pathParameters: Routes.GROUP_INFO_SCREEN.params(channel),
            );
          }
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                StreamMessageListView(
                  initialScrollIndex: widget.initialScrollIndex,
                  initialAlignment: widget.initialAlignment,
                  highlightInitialMessage: widget.highlightInitialMessage,
                  //onMessageSwiped: _reply,
                  messageFilter: defaultFilter,
                  messageBuilder: (context, details, messages, defaultMessage) {
                    final router = GoRouter.of(context);
                    return defaultMessage.copyWith(
                      onReplyTap: _reply,
                      // reactionPickerBuilder: (
                      //   context,
                      //   message,
                      //   onReactionPicked,
                      // ) {
                      //   final reactions =
                      //       StreamChatConfiguration.of(context).reactionIcons;
                      //
                      //   return CustomReactionPicker(
                      //     message: message,
                      //     reactions: reactions,
                      //     onReactionPicked: onReactionPicked,
                      //   );
                      //
                      //   return StreamReactionPicker(
                      //     message: message,
                      //     reactionIcons: reactions,
                      //     onReactionPicked: onReactionPicked,
                      //   );
                      // },
                      onShowMessage: (m, c) async {
                        final client = StreamChat.of(context).client;
                        final message = m;
                        final channel = client.channel(
                          c.type,
                          id: c.id,
                        );
                        if (channel.state == null) {
                          await channel.watch();
                        }
                        router.goNamed(
                          Routes.CHANNEL_PAGE.name,
                          pathParameters: Routes.CHANNEL_PAGE.params(channel),
                          queryParameters:
                              Routes.CHANNEL_PAGE.queryParams(message),
                        );
                      },
                      bottomRowBuilderWithDefaultWidget: (
                        context,
                        message,
                        defaultWidget,
                      ) {
                        return defaultWidget.copyWith(
                          deletedBottomRowBuilder: (context, message) {
                            return const StreamVisibleFootnote();
                          },
                        );
                      },
                    );
                  },
                  threadBuilder: (_, parentMessage) {
                    return ThreadPage(parent: parentMessage!);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .appBg
                        .withOpacity(.9),
                    child: StreamTypingIndicator(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      style: StreamChatTheme.of(context)
                          .textTheme
                          .footnote
                          .copyWith(
                              color: StreamChatTheme.of(context)
                                  .colorTheme
                                  .textLowEmphasis),
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamMessageInput(
            focusNode: _focusNode,
            messageInputController: _messageInputController,
            onQuotedMessageCleared: _messageInputController.clearQuotedMessage,
          ),
        ],
      ),
    );
  }

  bool defaultFilter(Message m) {
    final currentUser = StreamChat.of(context).currentUser;
    final isMyMessage = m.user?.id == currentUser?.id;
    final isDeletedOrShadowed = m.isDeleted == true || m.shadowed == true;
    if (isDeletedOrShadowed && !isMyMessage) return false;
    return true;
  }
}

/// A custom reaction picker widget that demonstrates how to create your own
/// reaction UI.
///
/// This example shows emoji buttons in a row with custom styling.
class CustomReactionPicker extends StatelessWidget {
  /// Creates a new instance of [CustomReactionPicker].
  const CustomReactionPicker({
    super.key,
    required this.message,
    required this.reactions,
    this.onReactionPicked,
  });

  /// The message to add reactions to.
  final Message message;

  final List<StreamReactionIcon> reactions;

  /// Callback for when a reaction is selected.
  final void Function(Reaction)? onReactionPicked;

  @override
  Widget build(BuildContext context) {
    // Get the current user to check which reactions are already added
    final currentUser = StreamChat.of(context).currentUser;
    if (currentUser == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: reactions.map((reaction) {
          final type = reaction.type;
          final emoji = reaction.builder;

          // Check if current user has already added this reaction
          final hasReacted = message.ownReactions?.any(
                (r) => r.type == type && r.userId == currentUser.id,
              ) ??
              false;

          return IconButton(
            iconSize: 24,
            icon: emoji.call(context, hasReacted, 24),
            padding: const EdgeInsets.all(4),
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: const Size.square(24),
            ),
            onPressed: () => onReactionPicked?.call(
              Reaction(
                type: type,
                messageId: message.id,
                userId: currentUser.id,
              ),
            ),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () {
                // Call the onReactionPicked callback with the selected reaction
                onReactionPicked?.call(
                  Reaction(
                    type: type,
                    messageId: message.id,
                    userId: currentUser.id,
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasReacted ? Colors.blue.withOpacity(0.2) : null,
                  shape: BoxShape.circle,
                ),
                child: emoji.call(context, false, 24),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
