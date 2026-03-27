// ignore_for_file: deprecated_member_use, avoid_redundant_argument_values

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/pages/thread_page.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/widgets/location/location_picker_dialog.dart';
import 'package:sample_app/widgets/location/location_picker_option.dart';
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
  final _messageInputController = StreamMessageInputController();

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

  void _editMessage(Message message) {
    _messageInputController.editMessage(message);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    final channel = StreamChannel.of(context).channel;
    final config = channel.config;

    return Scaffold(
      backgroundColor: colorTheme.appBg,
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
                  onEditMessageTap: _editMessage,
                  onReplyTap: _reply,
                  swipeToReply: true,
                  messageFilter: defaultFilter,
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
                    color: colorTheme.appBg.withOpacity(.9),
                    child: StreamTypingIndicator(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      style: textTheme.footnote.copyWith(
                        color: colorTheme.textLowEmphasis,
                      ),
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
            enableVoiceRecording: true,
            allowedAttachmentPickerTypes: [
              ...AttachmentPickerType.values,
              if (config?.sharedLocations == true && channel.canShareLocation) const LocationPickerType(),
            ],
            onAttachmentPickerResult: (result) {
              return _onCustomAttachmentPickerResult(channel, result);
            },
            attachmentPickerOptionsBuilder: (context, defaultOptions) => [
              ...defaultOptions,
              TabbedAttachmentPickerOption(
                key: 'location-picker',
                icon: Icons.near_me_rounded,
                supportedTypes: [const LocationPickerType()],
                isEnabled: (value) {
                  // Enable if nothing has been selected yet.
                  if (value.isEmpty) return true;

                  // Otherwise, enable only if there is a location.
                  return value.extraData['location'] != null;
                },
                optionViewBuilder: (context, controller) => LocationPicker(
                  onLocationPicked: (locationResult) {
                    if (locationResult == null) return;

                    controller.notifyCustomResult(
                      LocationPicked(location: locationResult),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _onCustomAttachmentPickerResult(
    Channel channel,
    StreamAttachmentPickerResult result,
  ) {
    if (result is LocationPicked) {
      _onShareLocationPicked(channel, result.location).ignore();
      return true; // Notify that the result was handled.
    }

    return false; // Notify that the result was not handled.
  }

  Future<SendMessageResponse> _onShareLocationPicked(
    Channel channel,
    LocationPickerResult result,
  ) async {
    if (result.endSharingAt case final endSharingAt?) {
      return channel.startLiveLocationSharing(
        endSharingAt: endSharingAt,
        location: result.coordinates,
      );
    }

    return channel.sendStaticLocation(location: result.coordinates);
  }

  bool defaultFilter(Message m) {
    final currentUser = StreamChat.of(context).currentUser;
    final isMyMessage = m.user?.id == currentUser?.id;
    final isDeletedOrShadowed = m.isDeleted == true || m.shadowed == true;
    if (isDeletedOrShadowed && !isMyMessage) return false;
    return true;
  }
}
