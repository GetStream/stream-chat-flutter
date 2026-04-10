import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/stream_chat_component_builders.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// Function signature for handling the dismiss action on the unread indicator.
typedef OnUnreadIndicatorDismissTap = Future<void> Function();

/// Function signature for handling taps on the unread indicator.
/// [lastReadMessageId] is the ID of the last read message.
typedef OnUnreadIndicatorTap = Future<void> Function(String? lastReadMessageId);

/// Function signature for building a custom unread indicator.
///
/// [unreadCount] is the number of unread messages.
/// [onTap] is called when the indicator is tapped.
/// [onDismissTap] is called when the dismiss action is triggered.
typedef UnreadIndicatorBuilder =
    Widget Function(
      int unreadCount,
      OnUnreadIndicatorTap onTap,
      OnUnreadIndicatorDismissTap onDismissTap,
    );

/// Properties for configuring an [UnreadIndicatorButton].
///
/// This class holds all the configuration options for an unread indicator,
/// allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [UnreadIndicatorButton], which uses these properties.
class UnreadIndicatorProps {
  /// Creates properties for an unread indicator.
  const UnreadIndicatorProps({
    required this.unreadCount,
    required this.onTap,
    required this.onDismissTap,
  });

  /// The number of unread messages.
  final int unreadCount;

  /// Callback triggered when the indicator is tapped.
  final OnUnreadIndicatorTap onTap;

  /// Callback triggered when the dismiss button is tapped.
  final OnUnreadIndicatorDismissTap onDismissTap;
}

/// {@template unreadIndicatorButton}
/// A button that displays the number of unread messages in a channel.
///
/// This widget listens to the current user's read state and shows
/// an indicator when there are unread messages. Users can tap on the
/// indicator to navigate to the oldest unread message or dismiss it.
/// {@endtemplate}
class UnreadIndicatorButton extends StatelessWidget {
  /// {@macro unreadIndicatorButton}
  const UnreadIndicatorButton({
    super.key,
    required this.onTap,
    required this.onDismissTap,
    this.unreadIndicatorBuilder,
  });

  /// Callback triggered when the indicator is tapped.
  ///
  /// This is typically used to navigate to the oldest unread message.
  final OnUnreadIndicatorTap onTap;

  /// Callback triggered when the dismiss button is tapped.
  ///
  /// This is typically used to mark all messages as read.
  final OnUnreadIndicatorDismissTap onDismissTap;

  /// Optional builder for customizing the appearance of the unread indicator.
  ///
  /// If not provided, falls back to [StreamComponentFactory], then to the
  /// default indicator.
  final UnreadIndicatorBuilder? unreadIndicatorBuilder;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    if (channel.state == null) return const Empty();

    return BetterStreamBuilder(
      initialData: channel.state!.currentUserRead,
      stream: channel.state!.currentUserReadStream,
      builder: (context, currentUserRead) {
        final unreadCount = currentUserRead.unreadMessages;
        if (unreadCount <= 0) return const Empty();

        final props = UnreadIndicatorProps(
          unreadCount: unreadCount,
          onTap: onTap,
          onDismissTap: onDismissTap,
        );

        if (unreadIndicatorBuilder case final builder?) {
          return builder(unreadCount, onTap, onDismissTap);
        }

        final factoryBuilder = context.chatComponentBuilder<UnreadIndicatorProps>();
        if (factoryBuilder != null) return factoryBuilder(context, props);

        final colorTheme = context.streamColorScheme;
        final textTheme = context.streamTextTheme;

        return Material(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          color: colorTheme.backgroundElevation1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(context.streamRadius.max),
          ),
          child: SizedBox(
            height: 40,
            child: InkWell(
              onTap: () => onTap(currentUserRead.lastReadMessageId),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 8, 2),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Icon(
                        context.streamIcons.arrowUp20,
                        size: 20,
                      ),
                      SizedBox(width: context.streamSpacing.xs),
                      Text(
                        context.translations.unreadCountIndicatorLabel(
                          unreadCount: unreadCount,
                        ),
                        style: textTheme.bodyEmphasis.copyWith(color: colorTheme.textSecondary),
                      ),
                      SizedBox(width: context.streamSpacing.md),
                      VerticalDivider(
                        color: colorTheme.borderDefault,
                        thickness: 1,
                      ),
                      IconButton(
                        iconSize: 20,
                        icon: Icon(context.streamIcons.xmark20),
                        padding: const EdgeInsets.all(5),
                        style: IconButton.styleFrom(
                          foregroundColor: colorTheme.textSecondary,
                          minimumSize: const Size.square(20),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: onDismissTap,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
