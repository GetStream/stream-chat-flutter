import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_example/debug/actions/remove_shadow_ban.dart';
import 'package:stream_chat_flutter_example/debug/actions/shadow_ban.dart';

import 'actions/ban_user.dart';
import 'actions/mute_user.dart';
import 'actions/unban_user.dart';
import 'actions/unmute_user.dart';
import 'members.dart';
import 'mutes.dart';

class DebugChannelPage extends StatefulWidget {
  const DebugChannelPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DebugChannelPageState();
  }
}

class _DebugChannelPageState extends State<DebugChannelPage> {
  late final Channel _channel = StreamChannel.of(context).channel;

  StreamSubscription<ChannelState>? _channelSubscription;
  StreamSubscription<OwnUser?>? _ownUserSubscription;

  ChannelState? _channelState;
  OwnUser? _ownUser;

  @override
  void initState() {
    super.initState();
    _channelSubscription = _channel.state!.channelStateStream.listen((state) {
      _channelState = state;
      setState(() {});
    });
    _ownUserSubscription =
        _channel.client.state.currentUserStream.listen((ownUser) {
      _ownUser = ownUser;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _channelSubscription?.cancel();
    _ownUserSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final members =
        _channelState?.members ?? _channel.state?.members ?? const [];
    final mutes =
        _ownUser?.mutes ?? _channel.client.state.currentUser?.mutes ?? const [];
    //SingleChildScrollView
    return Scaffold(
      appBar: AppBar(
        title: Text(_channel.name ?? _channel.cid ?? '?'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DebugMe(client: _channel.client),
            DebugMembers(members: members),
            const SizedBox(height: 8),
            DebugMutes(mutes: mutes),
            const SizedBox(height: 16),
            DebugMuteUser(client: _channel.client),
            const SizedBox(height: 8),
            DebugUnmuteUser(client: _channel.client),
            const SizedBox(height: 8),
            DebugBanUser(client: _channel.client),
            const SizedBox(height: 8),
            DebugUnbanUser(client: _channel.client),
            const SizedBox(height: 8),
            DebugShadowBan(client: _channel.client),
            const SizedBox(height: 8),
            DebugRemoveShadowBan(client: _channel.client),
          ],
        ),
      ),
    );
  }
}

class DebugMe extends StatelessWidget {
  const DebugMe({
    super.key,
    required this.client,
  });

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Me: ',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            client.state.currentUser?.id ?? '?',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
