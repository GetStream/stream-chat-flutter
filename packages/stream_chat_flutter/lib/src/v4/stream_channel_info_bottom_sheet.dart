import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/channel_info.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/option_list_tile.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';
import 'package:stream_chat_flutter/src/v4/stream_channel_name.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// A [BottomSheet] that shows information about a [Channel].
class StreamChannelInfoBottomSheet extends StatelessWidget {
  /// Creates a new instance [StreamChannelInfoBottomSheet] widget.
  StreamChannelInfoBottomSheet({
    Key? key,
    required this.channel,
    this.onMemberTap,
    this.onViewInfoTap,
    this.onLeaveChannelTap,
    this.onDeleteConversationTap,
    this.onCancelTap,
  })  : assert(
          channel.state != null,
          'Channel ${channel.id} is not initialized',
        ),
        super(key: key);

  /// The [Channel] to show information about.
  final Channel channel;

  /// A callback that is called when a member is tapped.
  final void Function(Member)? onMemberTap;

  /// A callback that is called when the "View Info" button is tapped.
  final VoidCallback? onViewInfoTap;

  /// A callback that is called when the "Leave Channel" button is tapped.
  ///
  /// Only shown when the channel is a group channel.
  final VoidCallback? onLeaveChannelTap;

  /// A callback that is called when the "Delete Conversation" button is tapped.
  ///
  /// Only shown when you are the `owner` of the channel.
  final VoidCallback? onDeleteConversationTap;

  /// A callback that is called when the "Cancel" button is tapped.
  final VoidCallback? onCancelTap;

  @override
  Widget build(BuildContext context) {
    final themeData = StreamChatTheme.of(context);
    final colorTheme = themeData.colorTheme;
    final channelPreviewTheme = StreamChannelPreviewTheme.of(context);

    final currentUser = channel.client.state.currentUser;
    final isOneToOneChannel = channel.isDistinct && channel.memberCount == 2;

    final members = channel.state?.members ?? [];

    // remove current user in case it's 1-1 conversation
    if (isOneToOneChannel) {
      members.removeWhere((it) => it.user?.id == currentUser?.id);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 24),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StreamChannelName(
              channel: channel,
              textStyle: themeData.textTheme.headlineBold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Center(
          // TODO: Refactor ChannelInfo
          child: StreamChannelInfo(
            showTypingIndicator: false,
            channel: channel,
            textStyle: channelPreviewTheme.subtitleStyle,
          ),
        ),
        const SizedBox(height: 17),
        Container(
          height: 94,
          alignment: Alignment.center,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: members.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final member = members[index];
              final user = member.user!;
              return Column(
                children: [
                  StreamUserAvatar(
                    user: user,
                    constraints: const BoxConstraints(
                      maxHeight: 64,
                      maxWidth: 64,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    onlineIndicatorConstraints: BoxConstraints.tight(
                      const Size(12, 12),
                    ),
                    onTap: onMemberTap != null
                        ? (_) => onMemberTap!(member)
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.name,
                    style: themeData.textTheme.footnoteBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        StreamOptionListTile(
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StreamSvgIcon.user(
              color: colorTheme.textLowEmphasis,
            ),
          ),
          title: context.translations.viewInfoLabel,
          onTap: onViewInfoTap,
        ),
        if (!isOneToOneChannel)
          StreamOptionListTile(
            title: context.translations.leaveGroupLabel,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamSvgIcon.userRemove(
                color: colorTheme.textLowEmphasis,
              ),
            ),
            onTap: onLeaveChannelTap,
          ),
        if (channel.ownCapabilities.contains(PermissionType.deleteChannel))
          StreamOptionListTile(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamSvgIcon.delete(
                color: colorTheme.accentError,
              ),
            ),
            title: context.translations.deleteConversationLabel,
            titleColor: colorTheme.accentError,
            onTap: onDeleteConversationTap,
          ),
        StreamOptionListTile(
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StreamSvgIcon.closeSmall(
              color: colorTheme.textLowEmphasis,
            ),
          ),
          title: context.translations.cancelLabel,
          onTap: onCancelTap ?? Navigator.of(context).pop,
        ),
      ],
    );
  }
}

const _kDefaultChannelInfoBottomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(32),
    topRight: Radius.circular(32),
  ),
);

/// Shows a modal material design bottom sheet.
///
/// A modal bottom sheet is an alternative to a menu or a dialog and prevents
/// the user from interacting with the rest of the app.
///
/// A closely related widget is a persistent bottom sheet, which shows
/// information that supplements the primary content of the app without
/// preventing the use from interacting with the app. Persistent bottom sheets
/// can be created and displayed with the [showBottomSheet] function or the
/// [ScaffoldState.showBottomSheet] method.
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the bottom sheet. It is only used when the method is called. Its
/// corresponding widget can be safely removed from the tree before the bottom
/// sheet is closed.
///
/// The `isScrollControlled` parameter specifies whether this is a route for
/// a bottom sheet that will utilize [DraggableScrollableSheet]. If you wish
/// to have a bottom sheet that has a scrollable child such as a [ListView] or
/// a [GridView] and have the bottom sheet be draggable, you should set this
/// parameter to true.
///
/// The `useRootNavigator` parameter ensures that the root navigator is used to
/// display the [BottomSheet] when set to `true`. This is useful in the case
/// that a modal [BottomSheet] needs to be displayed above all other content
/// but the caller is inside another [Navigator].
///
/// The [isDismissible] parameter specifies whether the bottom sheet will be
/// dismissed when user taps on the scrim.
///
/// The [enableDrag] parameter specifies whether the bottom sheet can be
/// dragged up and down and dismissed by swiping downwards.
///
/// The optional [backgroundColor], [elevation], [shape], [clipBehavior],
/// [constraints] and [transitionAnimationController]
/// parameters can be passed in to customize the appearance and behavior of
/// modal bottom sheets (see the documentation for these on [BottomSheet]
/// for more details).
///
/// The [transitionAnimationController] controls the bottom sheet's entrance and
/// exit animations if provided.
///
/// The optional `routeSettings` parameter sets the [RouteSettings]
/// of the modal bottom sheet sheet.
/// This is particularly useful in the case that a user wants to observe
/// [PopupRoute]s within a [NavigatorObserver].
///
/// Returns a `Future` that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the modal bottom sheet was closed.
///
/// See also:
///
///  * [BottomSheet], which becomes the parent of the widget returned by the
///    function passed as the `builder` argument to [showModalBottomSheet].
///  * [showBottomSheet] and [ScaffoldState.showBottomSheet], for showing
///    non-modal bottom sheets.
///  * [DraggableScrollableSheet], which allows you to create a bottom sheet
///    that grows and then becomes scrollable once it reaches its maximum size.
///  * <https://material.io/design/components/sheets-bottom.html#modal-bottom-sheet>
Future<T?> showChannelInfoModalBottomSheet<T>({
  required BuildContext context,
  required Channel channel,
  Color? backgroundColor,
  double? elevation,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = true,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Clip? clipBehavior = Clip.hardEdge,
  ShapeBorder? shape = _kDefaultChannelInfoBottomSheetShape,
  void Function(Member)? onMemberTap,
  VoidCallback? onViewInfoTap,
  VoidCallback? onLeaveChannelTap,
  VoidCallback? onDeleteConversationTap,
  VoidCallback? onCancelTap,
}) =>
    showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      builder: (BuildContext context) => StreamChannelInfoBottomSheet(
        channel: channel,
        onMemberTap: onMemberTap,
        onViewInfoTap: onViewInfoTap,
        onLeaveChannelTap: onLeaveChannelTap,
        onDeleteConversationTap: onDeleteConversationTap,
        onCancelTap: onCancelTap,
      ),
    );

/// Shows a material design bottom sheet in the nearest [Scaffold] ancestor. If
/// you wish to show a persistent bottom sheet, use [Scaffold.bottomSheet].
///
/// Returns a controller that can be used to close and otherwise manipulate the
/// bottom sheet.
///
/// The optional [backgroundColor], [elevation], [shape], [clipBehavior],
/// [constraints] and [transitionAnimationController]
/// parameters can be passed in to customize the appearance and behavior of
/// persistent bottom sheets (see the documentation for these on [BottomSheet]
/// for more details).
///
/// To rebuild the bottom sheet (e.g. if it is stateful), call
/// [PersistentBottomSheetController.setState] on the controller returned by
/// this method.
///
/// The new bottom sheet becomes a [LocalHistoryEntry] for the enclosing
/// [ModalRoute] and a back button is added to the app bar of the [Scaffold]
/// that closes the bottom sheet.
///
/// To create a persistent bottom sheet that is not a [LocalHistoryEntry] and
/// does not add a back button to the enclosing Scaffold's app bar, use the
/// [Scaffold.bottomSheet] constructor parameter.
///
/// A closely related widget is a modal bottom sheet, which is an alternative
/// to a menu or a dialog and prevents the user from interacting with the rest
/// of the app. Modal bottom sheets can be created and displayed with the
/// [showModalBottomSheet] function.
///
/// The `context` argument is used to look up the [Scaffold] for the bottom
/// sheet. It is only used when the method is called. Its corresponding widget
/// can be safely removed from the tree before the bottom sheet is closed.
///
/// See also:
///
///  * [BottomSheet], which becomes the parent of the widget returned by the
///    `builder`.
///  * [showModalBottomSheet], which can be used to display a modal bottom
///    sheet.
///  * [Scaffold.of], for information about how to obtain the [BuildContext].
///  * <https://material.io/design/components/sheets-bottom.html#standard-bottom-sheet>
PersistentBottomSheetController<T> showChannelInfoBottomSheet<T>({
  required BuildContext context,
  required Channel channel,
  Color? backgroundColor,
  double? elevation,
  BoxConstraints? constraints,
  AnimationController? transitionAnimationController,
  Clip? clipBehavior = Clip.hardEdge,
  ShapeBorder? shape = _kDefaultChannelInfoBottomSheetShape,
  void Function(Member)? onMemberTap,
  VoidCallback? onViewInfoTap,
  VoidCallback? onLeaveChannelTap,
  VoidCallback? onDeleteConversationTap,
  VoidCallback? onCancelTap,
}) =>
    showBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      transitionAnimationController: transitionAnimationController,
      builder: (BuildContext context) => StreamChannelInfoBottomSheet(
        channel: channel,
        onMemberTap: onMemberTap,
        onViewInfoTap: onViewInfoTap,
        onLeaveChannelTap: onLeaveChannelTap,
        onDeleteConversationTap: onDeleteConversationTap,
        onCancelTap: onCancelTap,
      ),
    );
