// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_example/debug/channel_page.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Create a new instance of [StreamChatClient] passing the apikey obtained
  /// from your project dashboard.
  final client = StreamChatClient(
    's2dxdhpxd94g',
    logLevel: Level.OFF,
  );

  /// Set the current user and connect the websocket. In a production
  /// scenario, this should be done using a backend to generate a user token
  /// using our server SDK.
  ///
  /// Please see the following for more information:
  /// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
  await client.connectUser(
    User(id: 'super-band-9'),
    '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A''',
  );

  runApp(
    MyApp(client: client),
  );
}

/// Example application using Stream Chat Flutter widgets.
///
/// Stream Chat Flutter is a set of Flutter widgets which provide full chat
/// functionalities for building Flutter applications using Stream. If you'd
/// prefer using minimal wrapper widgets for your app, please see our other
/// package, `stream_chat_flutter_core`.
class MyApp extends StatelessWidget {
  /// Example using Stream's Flutter package.
  ///
  /// If you'd prefer using minimal wrapper widgets for your app, please see
  /// our other package, `stream_chat_flutter_core`.
  const MyApp({
    super.key,
    required this.client,
  });

  /// Instance of Stream Client.
  ///
  /// Stream's [StreamChatClient] can be used to connect to our servers and
  /// set the default user for the application. Performing these actions
  /// trigger a websocket connection allowing for real-time updates.
  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.dark,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('fr'),
        Locale('it'),
        Locale('es'),
      ],
      localizationsDelegates: GlobalStreamChatLocalizations.delegates,
      builder: (context, widget) => StreamChat(
        client: client,
        child: widget,
      ),
      home: const ResponsiveChat(),
    );
  }
}

class ResponsiveChat extends StatelessWidget {
  const ResponsiveChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isDesktop || sizingInformation.isTablet) {
          return const SplitView();
        }

        return ChannelListPage(
          onTap: (c) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamChannel(
                channel: c,
                child: ChannelPage(
                  onBackPressed: (context) {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SplitView extends StatefulWidget {
  const SplitView({
    super.key,
  });

  @override
  _SplitViewState createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  Channel? selectedChannel;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Flexible(
          child: ChannelListPage(
            onTap: (channel) {
              setState(() {
                selectedChannel = channel;
              });
            },
            selectedChannel: selectedChannel,
          ),
        ),
        Flexible(
          flex: 2,
          child: ClipPath(
            child: Scaffold(
              body: selectedChannel != null
                  ? StreamChannel(
                      key: ValueKey(selectedChannel!.cid),
                      channel: selectedChannel!,
                      child: const ChannelPage(showBackButton: false),
                    )
                  : Center(
                      child: Text(
                        'Pick a channel to show the messages 💬',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    super.key,
    this.onTap,
    this.selectedChannel,
  });

  final void Function(Channel)? onTap;
  final Channel? selectedChannel;

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    channelStateSort: const [SortOption.desc('last_message_at')],
    limit: 20,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamChannelListView(
      onChannelTap: widget.onTap,
      controller: _listController,
      itemBuilder: (context, channels, index, defaultWidget) {
        return defaultWidget.copyWith(
          selected: channels[index] == widget.selectedChannel,
        );
      },
    ),
  );
}

class ChannelPage extends StatefulWidget {
  const ChannelPage({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
  });

  final bool showBackButton;
  final void Function(BuildContext)? onBackPressed;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late final messageInputController = StreamMessageInputController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamChannelHeader(
        onBackPressed: widget.onBackPressed != null
            ? () {
                widget.onBackPressed!(context);
              }
            : null,
        onImageTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return StreamChannel(
                  channel: StreamChannel.of(context).channel,
                  child: const DebugChannelPage(),
                );
              },
            ),
          );
        },
        showBackButton: widget.showBackButton,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              threadBuilder: (_, parent) => ThreadPage(parent: parent!),
              messageBuilder:
                  (
                    context,
                    messageDetails,
                    messages,
                    defaultWidget,
                  ) {
                    // The threshold after which the message is considered
                    // swiped.
                    const threshold = 0.2;

                    final isMyMessage = messageDetails.isMyMessage;

                    // The direction in which the message can be swiped.
                    final swipeDirection = isMyMessage
                        ? SwipeDirection
                              .endToStart //
                        : SwipeDirection.startToEnd;

                    return Swipeable(
                      key: ValueKey(messageDetails.message.id),
                      direction: swipeDirection,
                      swipeThreshold: threshold,
                      onSwiped: (details) => reply(messageDetails.message),
                      backgroundBuilder: (context, details) {
                        // The alignment of the swipe action.
                        final alignment = isMyMessage
                            ? Alignment
                                  .centerRight //
                            : Alignment.centerLeft;

                        // The progress of the swipe action.
                        final progress = math.min(details.progress, threshold) / threshold;

                        // The offset for the reply icon.
                        var offset = Offset.lerp(
                          const Offset(-24, 0),
                          const Offset(12, 0),
                          progress,
                        )!;

                        // If the message is mine, we need to flip the offset.
                        if (isMyMessage) {
                          offset = Offset(-offset.dx, -offset.dy);
                        }

                        final _streamTheme = StreamChatTheme.of(context);

                        return Align(
                          alignment: alignment,
                          child: Transform.translate(
                            offset: offset,
                            child: Opacity(
                              opacity: progress,
                              child: SizedBox.square(
                                dimension: 30,
                                child: CustomPaint(
                                  painter: AnimatedCircleBorderPainter(
                                    progress: progress,
                                    color: _streamTheme.colorTheme.borders,
                                  ),
                                  child: Center(
                                    child: StreamSvgIcon(
                                      icon: StreamSvgIcons.reply,
                                      size: lerpDouble(0, 18, progress),
                                      color: _streamTheme.colorTheme.accentPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: defaultWidget.copyWith(onReplyTap: reply),
                    );
                  },
            ),
          ),
          StreamMessageInput(
            enableVoiceRecording: true,
            onQuotedMessageCleared: messageInputController.clearQuotedMessage,
            focusNode: focusNode,
            messageInputController: messageInputController,
          ),
        ],
      ),
    );
  }

  void reply(Message message) {
    messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    messageInputController.dispose();
    super.dispose();
  }
}

class ThreadPage extends StatelessWidget {
  const ThreadPage({
    super.key,
    required this.parent,
  });

  final Message parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamThreadHeader(
        parent: parent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              parentMessage: parent,
            ),
          ),
          StreamMessageInput(
            enableVoiceRecording: true,
            messageInputController: StreamMessageInputController(
              message: Message(parentId: parent.id),
            ),
          ),
        ],
      ),
    );
  }
}
