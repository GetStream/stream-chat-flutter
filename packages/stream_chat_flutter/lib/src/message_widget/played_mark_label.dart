import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../stream_chat_flutter.dart';

/// The played mark's text for [message], or null when none is shown.
///
/// Reads "Played" in a two-member channel and "Played by 2" elsewhere. Only
/// the current user's messages that someone played have one, in channels
/// whose [ChannelConfig.markTypes] include [MessageMarkType.played].
@internal
String? playedMarkLabel(BuildContext context, Message message) {
  final currentUserId = StreamChat.maybeOf(context)?.currentUser?.id;
  if (currentUserId == null || message.user?.id != currentUserId) return null;

  final channel = StreamChannel.maybeOf(context)?.channel;
  final markTypes = channel?.config?.markTypes ?? const [];
  if (!markTypes.contains(MessageMarkType.played)) return null;

  final count = message.markGroups?[MessageMarkType.played]?.count ?? 0;
  if (count <= 0) return null;

  final translations = context.translations;
  if (channel?.memberCount == 2) return translations.messagePlayedLabel;

  return translations.messagePlayedByLabel(count);
}
