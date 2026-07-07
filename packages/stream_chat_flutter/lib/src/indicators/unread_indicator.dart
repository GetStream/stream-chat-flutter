import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamUnreadIndicator}
/// Shows different unread counts of the user.
///
/// When [child] is provided, the badge is overlaid on top of the child widget.
///
/// ```dart
/// // Standalone badge (no child).
/// const StreamUnreadIndicator()
///
/// // Badge overlaid on an icon.
/// StreamUnreadIndicator(child: Icon(Icons.chat_bubble_outline))
/// ```
/// {@endtemplate}
class StreamUnreadIndicator extends StatelessWidget {
  /// Displays the total unread count.
  const StreamUnreadIndicator({
    super.key,
    this.child,
    this.alignment,
    this.offset,
    this.semanticLabel,
  }) : _unreadType = const _TotalUnreadCount();

  /// Displays the unreadChannel count.
  ///
  /// Optionally, provide a [cid] to filter count for a specific channel.
  StreamUnreadIndicator.channels({
    super.key,
    String? cid,
    this.child,
    this.alignment,
    this.offset,
    this.semanticLabel,
  }) : _unreadType = _UnreadChannels(cid: cid);

  /// Displays the unreadThreads count.
  ///
  /// Optionally, provide a [id] to filter count for a specific thread.
  StreamUnreadIndicator.threads({
    super.key,
    String? id,
    this.child,
    this.alignment,
    this.offset,
    this.semanticLabel,
  }) : _unreadType = _UnreadThreads(id: id);

  final _UnreadTypes _unreadType;

  /// Optional child widget to overlay the badge on.
  ///
  /// When non-null, the badge is positioned on top of this widget.
  /// When null, only the badge itself is rendered (or nothing when
  /// the count is zero).
  final Widget? child;

  /// The alignment of the badge relative to the [child].
  ///
  /// Only used when [child] is non-null.
  ///
  /// Defaults to [AlignmentDirectional.topEnd].
  final AlignmentGeometry? alignment;

  /// Additional pixel offset applied after [alignment].
  ///
  /// Only used when [child] is non-null.
  ///
  /// Defaults to `Offset(8, -6)` for [TextDirection.ltr] or
  /// `Offset(-8, -6)` for [TextDirection.rtl].
  final Offset? offset;

  /// An alternative label spoken by screen readers in place of the count.
  ///
  /// When null (the default), the visible count ("5", "99+") is announced
  /// as-is. Provide a descriptive string (e.g. `"5 unread messages"`) when
  /// the bare count would be ambiguous without surrounding context.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
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
      },
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
      },
    };

    return BetterStreamBuilder<int>(
      stream: stream,
      initialData: initialData,
      builder: (context, unreadCount) {
        if (child == null && unreadCount == 0) return const Empty();
        if (child case final child? when unreadCount == 0) return child;

        final textDirection = Directionality.maybeOf(context);

        final effectiveAlignment = alignment ?? AlignmentDirectional.topEnd;
        final effectiveOffset = offset ?? const Offset(8, -6).directional(textDirection);

        return StreamBadgeNotification(
          label: switch (unreadCount) {
            > 99 => '99+',
            _ => '$unreadCount',
          },
          semanticLabel: semanticLabel,
          alignment: effectiveAlignment,
          offset: effectiveOffset,
          child: child,
        );
      },
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
