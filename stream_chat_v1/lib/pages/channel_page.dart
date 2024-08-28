import 'package:collection/collection.dart';
import 'package:example/pages/thread_page.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatefulWidget {
  final int? initialScrollIndex;
  final double? initialAlignment;
  final bool highlightInitialMessage;

  const ChannelPage({
    Key? key,
    this.initialScrollIndex,
    this.initialAlignment,
    this.highlightInitialMessage = false,
  }) : super(key: key);

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
            onQuotedMessageCleared: () {
              _messageInputController.clearQuotedMessage();
            },
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
