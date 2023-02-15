// ignore_for_file: deprecated_member_use_from_same_package

import 'package:collection/collection.dart'
    show IterableExtension, ListEquality;
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/context_menu_items/stream_chat_context_menu_item.dart';
import 'package:stream_chat_flutter/src/dialogs/dialogs.dart';
import 'package:stream_chat_flutter/src/message_widget/sending_indicator_wrapper.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template channelPreview}
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/channel_preview.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/channel_preview_paint.png)
///
/// Shows a preview for the current [Channel].
///
/// Uses a [StreamBuilder] to render the channel information image as soon as
/// it updates.
///
/// It is not recommended to use this widget directly as it is the
/// default channel preview widget used by [ChannelListView].
///
/// The UI is rendered based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget's appearance.
/// {@endtemplate}
class ChannelPreview extends StatelessWidget {
  /// {@macro channelPreview}
  const ChannelPreview({
    required this.channel,
    super.key,
    this.onTap,
    this.onLongPress,
    this.onViewInfoTap,
    this.onImageTap,
    this.title,
    this.subtitle,
    this.leading,
    this.sendingIndicator,
    this.trailing,
  });

  /// The action to perform when this widget is tapped or clicked.
  final void Function(Channel)? onTap;

  /// The action to perform when this widget is long pressed.
  final void Function(Channel)? onLongPress;

  /// The action to perform when 'View Info' is tapped or clicked.
  final ViewInfoCallback? onViewInfoTap;

  /// The [Channel] being previewed.
  final Channel channel;

  /// The action to perform when the image is tapped
  final VoidCallback? onImageTap;

  /// Widget rendering the title
  final Widget? title;

  /// Widget rendering the subtitle
  final Widget? subtitle;

  /// Widget rendering the leading element. By default it shows the
  /// [StreamChannelAvatar].
  final Widget? leading;

  /// Widget rendering the trailing element. By default it shows the date of
  /// the last message.
  final Widget? trailing;

  /// Widget rendering the sending indicator. By default it uses the
  /// [StreamSendingIndicator] widget.
  final Widget? sendingIndicator;

  @override
  Widget build(BuildContext context) {
    final channelPreviewTheme = StreamChannelPreviewTheme.of(context);
    final streamChatState = StreamChat.of(context);
    final streamChatTheme = StreamChatTheme.of(context);
    return BetterStreamBuilder<bool>(
      stream: channel.isMutedStream,
      initialData: channel.isMuted,
      builder: (context, data) => AnimatedOpacity(
        opacity: data ? 0.5 : 1,
        duration: const Duration(milliseconds: 300),
        child: ContextMenuArea(
          verticalPadding: 0,
          builder: (context) => [
            StreamChatContextMenuItem(
              leading: StreamSvgIcon.user(
                color: Colors.grey,
              ),
              title: Text(context.translations.viewInfoLabel),
              onClick: () {
                Navigator.of(context, rootNavigator: true).pop();
                if (onViewInfoTap != null) {
                  onViewInfoTap?.call(channel);
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => ChannelInfoDialog(
                      channel: channel,
                    ),
                  );
                }
              },
            ),
            StreamChatContextMenuItem(
              leading: StreamSvgIcon.mute(
                color: Colors.grey,
              ),
              title: channel.isGroup
                  ? Text(
                      context.translations
                          .toggleMuteUnmuteGroupText(isMuted: channel.isMuted),
                    )
                  : Text(
                      context.translations
                          .toggleMuteUnmuteUserText(isMuted: channel.isMuted),
                    ),
              onClick: () async {
                Navigator.of(context, rootNavigator: true).pop();
                showDialog(
                  context: context,
                  builder: (_) => ConfirmationDialog(
                    titleText: channel.isGroup
                        ? context.translations
                            .toggleMuteUnmuteGroupText(isMuted: channel.isMuted)
                        : context.translations
                            .toggleMuteUnmuteUserText(isMuted: channel.isMuted),
                    promptText: channel.isGroup
                        ? context.translations.toggleMuteUnmuteGroupQuestion(
                            isMuted: channel.isMuted,
                          )
                        : context.translations.toggleMuteUnmuteUserQuestion(
                            isMuted: channel.isMuted,
                          ),
                    affirmativeText: context.translations
                        .toggleMuteUnmuteAction(isMuted: channel.isMuted),
                    onConfirmation: () async {
                      try {
                        if (channel.isMuted) {
                          await channel.unmute();
                        } else {
                          await channel.mute();
                        }
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (_) => MessageDialog(
                            messageText: e.toString(),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
            if (channel.isGroup)
              StreamChatContextMenuItem(
                leading: StreamSvgIcon.userRemove(
                  color: Colors.red,
                ),
                title: Text(
                  context.translations.leaveGroupLabel,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                onClick: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmationDialog(
                      titleText: context.translations.leaveGroupLabel,
                      promptText:
                          context.translations.leaveConversationQuestion,
                      affirmativeText: context.translations.leaveLabel,
                      onConfirmation: () async {
                        final userAsMember = channel.state?.members.firstWhere(
                          (e) =>
                              e.user?.id ==
                              StreamChat.of(context).currentUser?.id,
                        );
                        try {
                          await channel.removeMembers([userAsMember!.user!.id]);
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (_) => MessageDialog(
                              messageText: e.toString(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            if (!channel.isGroup)
              StreamChatContextMenuItem(
                leading: StreamSvgIcon.delete(
                  color: Colors.red,
                ),
                title: Text(
                  context.translations.deleteConversationLabel,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                onClick: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmationDialog(
                      titleText: context.translations.deleteConversationLabel,
                      promptText:
                          context.translations.deleteConversationQuestion,
                      affirmativeText: context.translations.deleteLabel,
                      onConfirmation: () async {
                        try {
                          await channel.delete();
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (_) => MessageDialog(
                              messageText: e.toString(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
          ],
          child: ListTile(
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            onTap: () => onTap?.call(channel),
            onLongPress: () => onLongPress?.call(channel),
            leading: leading ??
                StreamChannelAvatar(
                  onTap: onImageTap,
                  channel: channel,
                ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: title ??
                      ChannelName(
                        textStyle: channelPreviewTheme.titleStyle,
                      ),
                ),
                BetterStreamBuilder<List<Member>>(
                  stream: channel.state?.membersStream,
                  initialData: channel.state?.members,
                  comparator: const ListEquality().equals,
                  builder: (context, members) {
                    if (members.isEmpty ||
                        !members.any((Member e) =>
                            e.user!.id ==
                            channel.client.state.currentUser?.id)) {
                      return const SizedBox();
                    }
                    return StreamUnreadIndicator(
                      cid: channel.cid,
                    );
                  },
                ),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(child: subtitle ?? _Subtitle(channel: channel)),
                sendingIndicator ??
                    Builder(
                      builder: (context) {
                        final lastMessage =
                            channel.state?.messages.lastWhereOrNull(
                          (m) => !m.isDeleted && !m.shadowed,
                        );
                        if (lastMessage?.user?.id ==
                            streamChatState.currentUser?.id) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: BetterStreamBuilder<List<Read>>(
                              stream: channel.state?.readStream,
                              initialData: channel.state?.read,
                              builder: (context, data) {

                                final hasNonUrlAttachments = lastMessage!
                                    .attachments
                                    .where((it) =>
                                        it.titleLink == null ||
                                        it.type == 'giphy')
                                    .isNotEmpty;

                                return SendingIndicatorWrapper(
                                  messageTheme: streamChatTheme.ownMessageTheme,
                                  message: lastMessage,
                                  hasNonUrlAttachments: hasNonUrlAttachments,
                                  streamChat: streamChatState,
                                  streamChatTheme: streamChatTheme,
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                trailing ?? _Date(channel: channel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date({
    required this.channel,
  });

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return BetterStreamBuilder<DateTime>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, data) {
        final lastMessageAt = data.toLocal();

        String stringDate;
        final now = DateTime.now();

        final startOfDay = DateTime(now.year, now.month, now.day);

        if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay.millisecondsSinceEpoch) {
          stringDate = Jiffy(lastMessageAt.toLocal()).jm;
        } else if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch) {
          stringDate = context.translations.yesterdayLabel;
        } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
          stringDate = Jiffy(lastMessageAt.toLocal()).EEEE;
        } else {
          stringDate = Jiffy(lastMessageAt.toLocal()).yMd;
        }

        return Text(
          stringDate,
          style: StreamChannelPreviewTheme.of(context).lastMessageAtStyle,
        );
      },
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({
    required this.channel,
  });

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final channelPreviewTheme = StreamChannelPreviewTheme.of(context);
    if (channel.isMuted) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          StreamSvgIcon.mute(
            size: 16,
          ),
          Text(
            '  ${context.translations.channelIsMutedText}',
            style: channelPreviewTheme.subtitleStyle,
          ),
        ],
      );
    }
    return StreamTypingIndicator(
      channel: channel,
      alternativeWidget: _LastMessage(
        channel: channel,
      ),
      style: channelPreviewTheme.subtitleStyle,
    );
  }
}

class _LastMessage extends StatelessWidget {
  const _LastMessage({
    required this.channel,
  });

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: BetterStreamBuilder<List<Message>>(
        stream: channel.state!.messagesStream,
        initialData: channel.state!.messages,
        builder: (context, data) {
          final lastMessage =
              data.lastWhereOrNull((m) => !m.shadowed && !m.isDeleted);
          if (lastMessage == null) {
            return const SizedBox();
          }

          var text = lastMessage.text;
          final parts = <String>[
            ...lastMessage.attachments.map((e) {
              if (e.type == 'image') {
                return '📷';
              } else if (e.type == 'video') {
                return '🎬';
              } else if (e.type == 'giphy') {
                return '[GIF]';
              }
              return e == lastMessage.attachments.last
                  ? (e.title ?? 'File')
                  : '${e.title ?? 'File'} , ';
            }),
            lastMessage.text ?? '',
          ];

          text = parts.join(' ');

          final channelPreviewTheme = StreamChannelPreviewTheme.of(context);
          return Text.rich(
            _getDisplayText(
              text,
              lastMessage.mentionedUsers,
              lastMessage.attachments,
              channelPreviewTheme.subtitleStyle?.copyWith(
                color: channelPreviewTheme.subtitleStyle?.color,
                fontStyle: (lastMessage.isSystem || lastMessage.isDeleted)
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
              channelPreviewTheme.subtitleStyle?.copyWith(
                color: channelPreviewTheme.subtitleStyle?.color,
                fontStyle: (lastMessage.isSystem || lastMessage.isDeleted)
                    ? FontStyle.italic
                    : FontStyle.normal,
                fontWeight: FontWeight.bold,
              ),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          );
        },
      ),
    );
  }

  TextSpan _getDisplayText(
    String text,
    List<User> mentions,
    List<Attachment> attachments,
    TextStyle? normalTextStyle,
    TextStyle? mentionsTextStyle,
  ) {
    final textList = text.split(' ');
    final resList = <TextSpan>[];
    for (final e in textList) {
      if (mentions.isNotEmpty &&
          mentions.any((element) => '@${element.name}' == e)) {
        resList.add(TextSpan(
          text: '$e ',
          style: mentionsTextStyle,
        ));
      } else if (attachments.isNotEmpty &&
          attachments
              .where((e) => e.title != null)
              .any((element) => element.title == e)) {
        resList.add(TextSpan(
          text: '$e ',
          style: normalTextStyle?.copyWith(fontStyle: FontStyle.italic),
        ));
      } else {
        resList.add(TextSpan(
          text: e == textList.last ? e : '$e ',
          style: normalTextStyle,
        ));
      }
    }

    return TextSpan(children: resList);
  }
}
