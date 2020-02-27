import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

class StreamChat extends StatefulWidget {
  final Client client;
  final Widget child;
  final StreamChatThemeData streamChatThemeData;

  StreamChat({
    Key key,
    @required this.client,
    @required this.child,
    this.streamChatThemeData,
  }) : super(
          key: key,
        );

  @override
  StreamChatState createState() => StreamChatState();

  static StreamChatState of(BuildContext context) {
    StreamChatState streamChatState;

    streamChatState = context.findAncestorStateOfType<StreamChatState>();

    if (streamChatState == null) {
      throw Exception(
          'You must have a StreamChat widget at the top of your widget tree');
    }

    return streamChatState;
  }
}

class StreamChatState extends State<StreamChat> {
  final List<StreamSubscription> _subscriptions = [];
  Client get client => widget.client;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final theme = _computeTheme(context);
    return StreamChatTheme(
      data: theme,
      child: Builder(
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(
            accentColor: StreamChatTheme.of(context).accentColor,
          ),
          child: WillPopScope(
            onWillPop: () async {
              if (_navigatorKey.currentState.canPop()) {
                _navigatorKey.currentState.pop();
                return false;
              } else {
                return true;
              }
            },
            child: Navigator(
              initialRoute: '/',
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => widget.child,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  StreamChatThemeData _computeTheme(BuildContext context) {
    final defaultTheme = _getDefaultTheme(context);
    final theme = defaultTheme.copyWith(
      primaryColor: widget.streamChatThemeData?.primaryColor,
      channelTheme: defaultTheme.channelTheme.copyWith(
        channelHeaderTheme:
            widget.streamChatThemeData?.channelTheme?.channelHeaderTheme,
        inputBackground:
            widget.streamChatThemeData?.channelTheme?.inputBackground,
        messageInputButtonIconTheme: widget
            .streamChatThemeData?.channelTheme?.messageInputButtonIconTheme,
        inputGradient: widget.streamChatThemeData?.channelTheme?.inputGradient,
        messageInputButtonTheme:
            widget.streamChatThemeData?.channelTheme?.messageInputButtonTheme,
      ),
      messageTheme: defaultTheme.messageTheme.copyWith(
        createdAt: widget.streamChatThemeData?.messageTheme?.createdAt,
        messageText: widget.streamChatThemeData?.messageTheme?.messageText,
        otherMessageBackgroundColor: widget
            .streamChatThemeData?.messageTheme?.otherMessageBackgroundColor,
        ownMessageBackgroundColor:
            widget.streamChatThemeData?.messageTheme?.ownMessageBackgroundColor,
        fontFamily: widget.streamChatThemeData?.messageTheme?.fontFamily,
        messageAuthor: widget.streamChatThemeData?.messageTheme?.messageAuthor,
        messageMention:
            widget.streamChatThemeData?.messageTheme?.messageMention,
        avatarTheme: defaultTheme.messageTheme.avatarTheme.copyWith(
          constraints: widget
              .streamChatThemeData?.messageTheme?.avatarTheme?.constraints,
          borderRadius: widget
              .streamChatThemeData?.messageTheme?.avatarTheme?.borderRadius,
        ),
      ),
      accentColor: widget.streamChatThemeData?.accentColor,
      secondaryColor: widget.streamChatThemeData?.secondaryColor,
      channelPreviewTheme: defaultTheme.channelPreviewTheme.copyWith(
        avatarTheme: defaultTheme.channelPreviewTheme.avatarTheme.copyWith(
          constraints: widget.streamChatThemeData?.channelPreviewTheme
              ?.avatarTheme?.constraints,
          borderRadius: widget.streamChatThemeData?.channelPreviewTheme
              ?.avatarTheme?.borderRadius,
        ),
        title: widget.streamChatThemeData?.channelPreviewTheme?.title,
        lastMessageAt:
            widget.streamChatThemeData?.channelPreviewTheme?.lastMessageAt,
        subtitle: widget.streamChatThemeData?.channelPreviewTheme?.subtitle,
      ),
    );
    return theme;
  }

  StreamChatThemeData _getDefaultTheme(BuildContext context) {
    final accentColor = Color(0xff006cff);
    return StreamChatThemeData(
      accentColor: accentColor,
      primaryColor: Colors.white,
      channelPreviewTheme: ChannelPreviewTheme(
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: BoxConstraints.tightFor(
            height: 40,
            width: 40,
          ),
        ),
        title: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        subtitle: TextStyle(
          fontSize: 13,
          color: Colors.black,
        ),
        lastMessageAt: TextStyle(
          fontSize: 11,
          color: Colors.black.withOpacity(.5),
        ),
      ),
      channelTheme: ChannelTheme(
        messageInputButtonIconTheme: Theme.of(context).iconTheme.copyWith(
              color: accentColor,
            ),
        channelHeaderTheme: ChannelHeaderTheme(
          avatarTheme: AvatarTheme(
            borderRadius: BorderRadius.circular(20),
            constraints: BoxConstraints.tightFor(
              height: 40,
              width: 40,
            ),
          ),
          color: Colors.white,
          title: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          lastMessageAt: TextStyle(
            fontSize: 11,
            color: Colors.black.withOpacity(.5),
          ),
        ),
        inputBackground: Colors.black.withAlpha(12),
        inputGradient: LinearGradient(colors: [
          Color(0xFF00AEFF),
          Color(0xFF0076FF),
        ]),
      ),
      messageTheme: MessageTheme(
        messageText: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        createdAt: TextStyle(
          color: Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
        ownMessageBackgroundColor: Color(0xffebebeb),
        otherMessageBackgroundColor: Colors.white,
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(20),
          constraints: BoxConstraints.tightFor(
            height: 32,
            width: 32,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _subscriptions.add(widget.client.on('message.new').listen((Event e) {
      final index = channels.indexWhere((c) => c.cid == e.cid);
      if (index > 0) {
        final channel = channels.removeAt(index);
        channels.insert(0, channel);
        _channelsController.add(channels);
      }
    }));
  }

  User get user => widget.client.state.user;

  Stream<User> get userStream => widget.client.state.userStream;

  Stream<List<Channel>> get channelsStream => _channelsController.stream;

  final BehaviorSubject<List<Channel>> _channelsController = BehaviorSubject();

  final List<Channel> channels = [];

  final BehaviorSubject<bool> _queryChannelsLoadingController =
      BehaviorSubject.seeded(false);

  Stream<bool> get queryChannelsLoading =>
      _queryChannelsLoadingController.stream;

  Future<void> queryChannels({
    Map<String, dynamic> filter,
    List<SortOption> sortOptions,
    PaginationParams paginationParams,
    Map<String, dynamic> options,
  }) async {
    if (_queryChannelsLoadingController.value) {
      return;
    }
    _queryChannelsLoadingController.sink.add(true);

    try {
      final res = await widget.client.queryChannels(
        filter: filter,
        sort: sortOptions,
        options: options,
        paginationParams: paginationParams,
      );
      channels.addAll(res);
      _channelsController.sink.add(channels);
      _queryChannelsLoadingController.sink.add(false);
    } catch (e) {
      _channelsController.sink.addError(e);
    }
  }

  void clearChannels() {
    channels.clear();
  }

  @override
  void dispose() {
    widget.client.dispose();
    _subscriptions.forEach((s) => s.cancel());
    _queryChannelsLoadingController.close();
    _channelsController.close();
    super.dispose();
  }
}
