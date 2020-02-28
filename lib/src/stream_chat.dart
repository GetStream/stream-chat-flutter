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
    final theme = _getTheme(context, widget.streamChatThemeData);
    return StreamChatTheme(
      data: theme,
      child: Builder(
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(
            accentColor: StreamChatTheme.of(context).accentColor,
            scaffoldBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
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

  StreamChatThemeData _getTheme(
    BuildContext context,
    StreamChatThemeData themeData,
  ) {
    final defaultTheme = StreamChatThemeData.getDefaultTheme(Theme.of(context));
    final theme = defaultTheme.copyWith(
      primaryColor: themeData?.primaryColor,
      channelTheme: defaultTheme.channelTheme.copyWith(
        channelHeaderTheme:
            defaultTheme.channelTheme.channelHeaderTheme.copyWith(
          color: themeData?.channelTheme?.channelHeaderTheme?.color,
          lastMessageAt:
              themeData?.channelTheme?.channelHeaderTheme?.lastMessageAt,
          title: themeData?.channelTheme?.channelHeaderTheme?.title,
          avatarTheme: defaultTheme.channelPreviewTheme.avatarTheme.copyWith(
            constraints: themeData
                ?.channelTheme?.channelHeaderTheme?.avatarTheme?.constraints,
            borderRadius: themeData
                ?.channelTheme?.channelHeaderTheme?.avatarTheme?.borderRadius,
          ),
        ),
        inputBackground: themeData?.channelTheme?.inputBackground,
        messageInputButtonIconTheme:
            themeData?.channelTheme?.messageInputButtonIconTheme,
        inputGradient: themeData?.channelTheme?.inputGradient,
        messageInputButtonTheme:
            themeData?.channelTheme?.messageInputButtonTheme,
      ),
      messageTheme: defaultTheme.messageTheme.copyWith(
        replies: themeData?.messageTheme?.replies,
        createdAt: themeData?.messageTheme?.createdAt,
        messageText: themeData?.messageTheme?.messageText,
        otherMessageBackgroundColor:
            themeData?.messageTheme?.otherMessageBackgroundColor,
        ownMessageBackgroundColor:
            themeData?.messageTheme?.ownMessageBackgroundColor,
        fontFamily: themeData?.messageTheme?.fontFamily,
        messageAuthor: themeData?.messageTheme?.messageAuthor,
        messageMention: themeData?.messageTheme?.messageMention,
        avatarTheme: defaultTheme.messageTheme.avatarTheme.copyWith(
          constraints: themeData?.messageTheme?.avatarTheme?.constraints,
          borderRadius: themeData?.messageTheme?.avatarTheme?.borderRadius,
        ),
      ),
      accentColor: themeData?.accentColor,
      secondaryColor: themeData?.secondaryColor,
      channelPreviewTheme: defaultTheme.channelPreviewTheme.copyWith(
        avatarTheme: defaultTheme.channelPreviewTheme.avatarTheme.copyWith(
          constraints: themeData?.channelPreviewTheme?.avatarTheme?.constraints,
          borderRadius:
              themeData?.channelPreviewTheme?.avatarTheme?.borderRadius,
        ),
        title: themeData?.channelPreviewTheme?.title,
        lastMessageAt: themeData?.channelPreviewTheme?.lastMessageAt,
        subtitle: themeData?.channelPreviewTheme?.subtitle,
      ),
    );
    return theme;
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
