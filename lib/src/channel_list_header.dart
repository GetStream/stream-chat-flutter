import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_neumorphic_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'stream_chat.dart';

typedef _TitleBuilder = Widget Function(
  BuildContext context,
  ConnectionStatus status,
  Client client,
);

///
/// It shows the current [Client] status.
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final Client client;
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
/// The widget by default uses the inherited [Client] to fetch information about the status.
/// However you can also pass your own [Client] if you don't have it in the widget tree.
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme] and on its [ChannelTheme.channelHeaderTheme] property.
/// Modify it to change the widget appearance.
class ChannelListHeader extends StatefulWidget implements PreferredSizeWidget {
  /// Instantiates a ChannelListHeader
  const ChannelListHeader({
    Key key,
    this.client,
    this.titleBuilder,
    this.onUserAvatarTap,
    this.onNewChatButtonTap,
  }) : super(key: key);

  /// Pass this if you don't have a [Client] in your widget tree.
  final Client client;

  /// Use this to build your own title as per different [ConnectionStatus]
  final _TitleBuilder titleBuilder;

  /// Callback to call when pressing the user avatar button.
  /// By default it calls Scaffold.of(context).openDrawer()
  final Function(User) onUserAvatarTap;

  /// Callback to call when pressing the new chat button.
  final VoidCallback onNewChatButtonTap;

  @override
  _ChannelListHeaderState createState() => _ChannelListHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ChannelListHeaderState extends State<ChannelListHeader> {
  OverlayEntry _errorOverlay;

  OverlayEntry _createOverlayEntry(String text) {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          color: StreamChatTheme.of(context).colorTheme.grey.withOpacity(0.9),
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, val, wid) {
              return Container(
                alignment: Alignment.center,
                height: val * 25.0,
                child: Text(
                  text,
                  style: StreamChatTheme.of(context).textTheme.body.copyWith(
                        color: StreamChatTheme.of(context).colorTheme.white,
                      ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _client = widget.client ?? StreamChat.of(context).client;
    final user = _client.state.user;
    return ValueListenableBuilder<ConnectionStatus>(
        valueListenable: _client.wsConnectionStatus,
        builder: (context, status, child) {
          switch (status) {
            case ConnectionStatus.connected:
              if (_errorOverlay != null) {
                _errorOverlay.remove();
                _errorOverlay = null;
              }
              break;
            case ConnectionStatus.connecting:
              if (_errorOverlay != null) {
                _errorOverlay.remove();
                _errorOverlay = null;
              }
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                _errorOverlay = _createOverlayEntry('Reconnecting...');
                Overlay.of(context).insert(_errorOverlay);
              });
              break;
            case ConnectionStatus.disconnected:
              if (_errorOverlay != null) {
                _errorOverlay.remove();
                _errorOverlay = null;
              }
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                _errorOverlay = _createOverlayEntry('Disconnected');
                Overlay.of(context).insert(_errorOverlay);
              });
              break;
          }

          return AppBar(
            brightness: Theme.of(context).brightness,
            elevation: 1,
            backgroundColor: StreamChatTheme.of(context)
                .channelTheme
                .channelHeaderTheme
                .color,
            centerTitle: true,
            leading: Center(
              child: UserAvatar(
                user: user,
                showOnlineStatus: false,
                onTap: widget.onUserAvatarTap ??
                    (_) => Scaffold.of(context).openDrawer(),
                borderRadius: BorderRadius.circular(20),
                constraints: BoxConstraints.tightFor(
                  height: 40,
                  width: 40,
                ),
              ),
            ),
            actions: [
              StreamNeumorphicButton(
                child: IconButton(
                  icon: SvgPicture.asset(
                    'svgs/icon_pen_write.svg',
                    package: 'stream_chat_flutter',
                    width: 24.0,
                    height: 24.0,
                    color: StreamChatTheme.of(context).colorTheme.accentBlue,
                  ),
                  onPressed: status == ConnectionStatus.connected
                      ? widget.onNewChatButtonTap
                      : null,
                ),
              )
            ],
            title: Builder(
              builder: (context) {
                if (widget.titleBuilder != null) {
                  return widget.titleBuilder(context, status, _client);
                }

                return _buildConnectedTitleState(context);
              },
            ),
          );
        });
  }

  Widget _buildConnectedTitleState(BuildContext context) => Text(
        'Stream Chat',
        style: StreamChatTheme.of(context).textTheme.headlineBold.copyWith(
              color: StreamChatTheme.of(context).colorTheme.black,
            ),
      );
}
