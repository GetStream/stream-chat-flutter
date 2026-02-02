import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamUnreadIndicator}
/// Shows different unread counts of the user.
/// {@endtemplate}
class StreamUnreadIndicator extends StatelessWidget {
  /// Displays the total unread count.
  StreamUnreadIndicator({
    super.key,
    @Deprecated('Use StreamUnreadIndicator.channels instead') String? cid,
  }) : _unreadType = switch (cid) {
          final cid? => _UnreadChannels(cid: cid),
          _ => const _TotalUnreadCount(),
        };

  /// Displays the unreadChannel count.
  ///
  /// Optionally, provide a [cid] to filter count for a specific channel.
  StreamUnreadIndicator.channels({
    super.key,
    String? cid,
  }) : _unreadType = _UnreadChannels(cid: cid);

  /// Displays the unreadThreads count.
  ///
  /// Optionally, provide a [id] to filter count for a specific thread.
  StreamUnreadIndicator.threads({
    super.key,
    String? id,
  }) : _unreadType = _UnreadThreads(id: id);

  final _UnreadTypes _unreadType;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final client = StreamChat.of(context).client;

    final stream = switch (_unreadType) {
      _TotalUnreadCount() => client.state.totalUnreadCountStream,
      _UnreadChannels(cid: final cid) => switch (cid) {
          final cid? => client.state.channels[cid]?.state?.unreadCountStream,
          _ => client.state.unreadChannelsStream,
        },
      _UnreadThreads(id: final id) => switch (id) {
          // TODO: Handle id once it's supported
          _ => client.state.unreadThreadsStream,
        }
    };

    final initialData = switch (_unreadType) {
      _TotalUnreadCount() => client.state.totalUnreadCount,
      _UnreadChannels(cid: final cid) => switch (cid) {
          final cid? => client.state.channels[cid]?.state?.unreadCount,
          _ => client.state.unreadChannels,
        },
      _UnreadThreads(id: final id) => switch (id) {
          // TODO: Handle id once it's supported
          _ => client.state.unreadThreads,
        }
    };

    return IgnorePointer(
      child: BetterStreamBuilder<int>(
        stream: stream,
        initialData: initialData,
        builder: (context, unreadCount) {
          if (unreadCount == 0) return const Empty();

          return Badge(
            textColor: Colors.white,
            textStyle: theme.textTheme.footnoteBold,
            backgroundColor: theme.channelPreviewTheme.unreadCounterColor,
            label: Text(
              switch (unreadCount) {
                > 99 => '99+',
                _ => '$unreadCount',
              },
            ),
          );
        },
      ),
    );
  }
}

sealed class _UnreadTypes {
  const _UnreadTypes._();
}

final class _TotalUnreadCount extends _UnreadTypes {
  const _TotalUnreadCount() : super._();
}

final class _UnreadChannels extends _UnreadTypes {
  const _UnreadChannels({this.cid}) : super._();

  /// Optional channel cid to filter unread count.
  final String? cid;
}

final class _UnreadThreads extends _UnreadTypes {
  const _UnreadThreads({this.id}) : super._();

  /// Optional parent message id to filter unread count.
  final String? id;
}
