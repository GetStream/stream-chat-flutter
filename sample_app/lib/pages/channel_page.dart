// ignore_for_file: deprecated_member_use, avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/config/sample_app_config.dart';
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
  final _messageComposerController = StreamMessageComposerController();

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    _messageComposerController.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageComposerController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  void _editMessage(Message message) {
    _messageComposerController.editMessage(message);
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
        onChannelAvatarPressed: (channel) {
          final isOneToOne = channel.isOneToOne;
          final currentUserId = StreamChat.of(context).currentUser?.id;

          final channelMembers = channel.state?.members ?? [];
          final otherUser = isOneToOne ? channelMembers.firstWhere((m) => m.userId != currentUserId).user : null;

          _pushChannelInfo(context, channel, otherUser);
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
          Builder(
            builder: (context) {
              final appConfig = context.sampleAppConfig;
              final locationEnabled =
                  appConfig.enableLocationSharing && config?.sharedLocations == true && channel.canShareLocation;

              return StreamMessageComposer(
                focusNode: _focusNode,
                messageComposerController: _messageComposerController,
                onQuotedMessageCleared: _messageComposerController.clearQuotedMessage,
                enableVoiceRecording: true,
                allowedAttachmentPickerTypes: [
                  ...AttachmentPickerType.values,
                  if (locationEnabled) const LocationPickerType(),
                ],
                onAttachmentPickerResult: (result) {
                  return _onCustomAttachmentPickerResult(channel, result);
                },
                attachmentPickerOptionsBuilder: (context, defaultOptions) => [
                  ...defaultOptions,
                  if (locationEnabled)
                    TabbedAttachmentPickerOption(
                      key: 'location-picker',
                      icon: context.streamIcons.location,
                      supportedTypes: [const LocationPickerType()],
                      isEnabled: (value) {
                        if (value.isEmpty) return true;
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
              );
            },
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
}

// Pushes the chat / group info screen depending on whether [user] was
// resolved. 1-1 channels pass the other member here (forwarded as `extra`
// to the chat-info route); group channels pass `null` and route to the
// group info screen.
Future<void> _pushChannelInfo(BuildContext context, Channel channel, User? user) {
  final router = GoRouter.of(context);

  if (user != null) {
    return router.pushNamed(
      Routes.CHAT_INFO_SCREEN.name,
      pathParameters: Routes.CHAT_INFO_SCREEN.params(channel),
      extra: user,
    );
  }

  return router.pushNamed(
    Routes.GROUP_INFO_SCREEN.name,
    pathParameters: Routes.GROUP_INFO_SCREEN.params(channel),
  );
}
