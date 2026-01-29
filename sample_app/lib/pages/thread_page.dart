import 'package:flutter/material.dart';
import 'package:sample_app/widgets/location/location_attachment.dart';
import 'package:sample_app/widgets/location/location_detail_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({
    super.key,
    required this.parent,
    this.initialScrollIndex,
    this.initialAlignment,
  });
  final Message parent;
  final int? initialScrollIndex;
  final double? initialAlignment;

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final FocusNode _focusNode = FocusNode();
  late StreamMessageInputController _messageInputController;

  @override
  void initState() {
    super.initState();
    _messageInputController = StreamMessageInputController(
      message: Message(parentId: widget.parent.id),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationAttachmentBuilder = LocationAttachmentBuilder(
      onAttachmentTap: (location) => showLocationDetailDialog(
        context: context,
        location: location,
      ),
    );

    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: StreamThreadHeader(
        parent: widget.parent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              parentMessage: widget.parent,
              initialScrollIndex: widget.initialScrollIndex,
              initialAlignment: widget.initialAlignment,
              //onMessageSwiped: _reply,
              messageFilter: defaultFilter,
              showScrollToBottom: false,
              highlightInitialMessage: true,
              parentMessageBuilder: (context, message, defaultMessage) {
                return defaultMessage.copyWith(
                  attachmentBuilders: [locationAttachmentBuilder],
                );
              },
              messageBuilder: (context, details, messages, defaultMessage) {
                final message = details.message;

                return defaultMessage.copyWith(
                  onReplyTap: _reply,
                  showEditMessage: message.sharedLocation == null,
                  attachmentBuilders: [locationAttachmentBuilder],
                  bottomRowBuilderWithDefaultWidget:
                      (
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
            ),
          ),
          if (widget.parent.type != 'deleted')
            StreamMessageInput(
              focusNode: _focusNode,
              messageInputController: _messageInputController,
              enableVoiceRecording: true,
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
