import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget builder for title
typedef TitleBuilder = Widget Function(
  BuildContext context,
  ConnectionStatus status,
  StreamChatClient client,
);

/// {@macro channel_list_header}
@Deprecated("Use 'StreamChannelListHeader' instead")
typedef ChannelListHeader = StreamChannelListHeader;

/// {@template channel_list_header}
/// It shows the current [StreamChatClient] status.
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final StreamChatClient client;
///
///   MyApp(this.client);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: StreamChat(
///         client: client,
///         child: Scaffold(
///             appBar: ChannelListHeader(),
///           ),
///         ),
///     );
///   }
/// }
/// ```
///
/// Usually you would use this widget as an [AppBar] inside a [Scaffold].
/// However you can also use it as a normal widget.
///
/// The widget by default uses the inherited [StreamChatClient]
/// to fetch information about the status.
/// However you can also pass your own [StreamChatClient]
/// if you don't have it in the widget tree.
///
/// The widget components render the ui based on the first ancestor of type
/// [StreamChatTheme] and on its [StreamChannelListHeaderThemeData] property.
/// Modify it to change the widget appearance.
/// {@endtemplate}
class StreamChannelListHeader extends StatelessWidget
    implements PreferredSizeWidget {
  /// Instantiates a ChannelListHeader
  const StreamChannelListHeader({
    Key? key,
    this.client,
    this.titleBuilder,
    this.onUserAvatarTap,
    this.onNewChatButtonTap,
    this.showConnectionStateTile = false,
    this.preNavigationCallback,
    this.subtitle,
    this.centerTitle,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.elevation = 1,
  }) : super(key: key);

  /// Pass this if you don't have a [StreamChatClient] in your widget tree.
  final StreamChatClient? client;

  /// Use this to build your own title as per different [ConnectionStatus]
  final TitleBuilder? titleBuilder;

  /// Callback to call when pressing the user avatar button.
  /// By default it calls Scaffold.of(context).openDrawer()
  final Function(User)? onUserAvatarTap;

  /// Callback to call when pressing the new chat button.
  final VoidCallback? onNewChatButtonTap;

  /// Show connection state tile
  final bool showConnectionStateTile;

  /// Callback before navigation is performed
  final VoidCallback? preNavigationCallback;

  /// Subtitle widget
  final Widget? subtitle;

  /// Whether the title should be centered
  final bool? centerTitle;

  /// Leading widget
  /// By default it shows the logged in user avatar
  final Widget? leading;

  /// AppBar actions
  /// By default it shows the new chat button
  final List<Widget>? actions;

  /// The background color for this [StreamChannelListHeader].
  final Color? backgroundColor;

  /// The elevation for this [StreamChannelListHeader].
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final _client = client ?? StreamChat.of(context).client;
    final user = _client.state.currentUser;
    return StreamConnectionStatusBuilder(
      statusBuilder: (context, status) {
        var statusString = '';
        var showStatus = true;

        switch (status) {
          case ConnectionStatus.connected:
            statusString = context.translations.connectedLabel;
            showStatus = false;
            break;
          case ConnectionStatus.connecting:
            statusString = context.translations.reconnectingLabel;
            break;
          case ConnectionStatus.disconnected:
            statusString = context.translations.disconnectedLabel;
            break;
        }

        final chatThemeData = StreamChatTheme.of(context);
        final channelListHeaderThemeData =
            StreamChannelListHeaderTheme.of(context);
        final theme = Theme.of(context);
        return StreamInfoTile(
          showMessage: showConnectionStateTile && showStatus,
          message: statusString,
          child: AppBar(
            toolbarTextStyle: theme.textTheme.bodyText2,
            titleTextStyle: theme.textTheme.headline6,
            systemOverlayStyle: theme.brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            elevation: elevation,
            backgroundColor:
                backgroundColor ?? channelListHeaderThemeData.color,
            centerTitle: centerTitle,
            leading: leading ??
                Center(
                  child: user != null
                      ? StreamUserAvatar(
                          user: user,
                          showOnlineStatus: false,
                          onTap: onUserAvatarTap ??
                              (_) {
                                if (preNavigationCallback != null) {
                                  preNavigationCallback!();
                                }
                                Scaffold.of(context).openDrawer();
                              },
                          borderRadius: channelListHeaderThemeData
                              .avatarTheme?.borderRadius,
                          constraints: channelListHeaderThemeData
                              .avatarTheme?.constraints,
                        )
                      : const Offstage(),
                ),
            actions: actions ??
                [
                  StreamNeumorphicButton(
                    child: IconButton(
                      icon: StreamConnectionStatusBuilder(
                        statusBuilder: (context, status) {
                          Color? color;
                          switch (status) {
                            case ConnectionStatus.connected:
                              color = chatThemeData.colorTheme.accentPrimary;
                              break;
                            case ConnectionStatus.connecting:
                              color = Colors.grey;
                              break;
                            case ConnectionStatus.disconnected:
                              color = Colors.grey;
                              break;
                          }
                          return SvgPicture.asset(
                            'svgs/icon_pen_write.svg',
                            package: 'stream_chat_flutter',
                            width: 24,
                            height: 24,
                            color: color,
                          );
                        },
                      ),
                      onPressed: onNewChatButtonTap,
                    ),
                  ),
                ],
            title: Column(
              children: [
                Builder(
                  builder: (context) {
                    if (titleBuilder != null) {
                      return titleBuilder!(context, status, _client);
                    }
                    switch (status) {
                      case ConnectionStatus.connected:
                        return _buildConnectedTitleState(context);
                      case ConnectionStatus.connecting:
                        return _buildConnectingTitleState(context);
                      case ConnectionStatus.disconnected:
                        return _buildDisconnectedTitleState(context, _client);
                      default:
                        return const Offstage();
                    }
                  },
                ),
                subtitle ?? const Offstage(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectedTitleState(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return Text(
      context.translations.streamChatLabel,
      style: chatThemeData.textTheme.headlineBold.copyWith(
        color: chatThemeData.colorTheme.textHighEmphasis,
      ),
    );
  }

  Widget _buildConnectingTitleState(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
            width: 16,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            context.translations.searchingForNetworkText,
            style:
                StreamChannelListHeaderTheme.of(context).titleStyle?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
          ),
        ],
      );

  Widget _buildDisconnectedTitleState(
    BuildContext context,
    StreamChatClient client,
  ) {
    final chatThemeData = StreamChatTheme.of(context);
    final channelListHeaderTheme = StreamChannelListHeaderTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.translations.offlineLabel,
          style: channelListHeaderTheme.titleStyle?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () => client
            ..closeConnection()
            ..openConnection(),
          child: Text(
            context.translations.tryAgainLabel,
            style: channelListHeaderTheme.titleStyle?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: chatThemeData.colorTheme.accentPrimary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
