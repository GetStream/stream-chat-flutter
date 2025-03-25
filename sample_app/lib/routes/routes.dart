// ignore_for_file: constant_identifier_names

import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Application routes
abstract class Routes {
  static const RouteConfig CHOOSE_USER =
      RouteConfig(name: 'choose_user', path: '/users');
  static const RouteConfig ADVANCED_OPTIONS =
      RouteConfig(name: 'advanced_options', path: '/options');
  static const ChannelRouteConfig CHANNEL_PAGE =
      ChannelRouteConfig(name: 'channel_page', path: 'channel/:cid');
  static const RouteConfig NEW_CHAT =
      RouteConfig(name: 'new_chat', path: '/new_chat');
  static const RouteConfig NEW_GROUP_CHAT =
      RouteConfig(name: 'new_group_chat', path: '/new_group_chat');
  static const RouteConfig NEW_GROUP_CHAT_DETAILS = RouteConfig(
      name: 'new_group_chat_details', path: '/new_group_chat_details');
  static const ChannelRouteConfig CHAT_INFO_SCREEN =
      ChannelRouteConfig(name: 'chat_info_screen', path: 'chat_info_screen');
  static const ChannelRouteConfig GROUP_INFO_SCREEN =
      ChannelRouteConfig(name: 'group_info_screen', path: 'group_info_screen');
  static const RouteConfig CHANNEL_LIST_PAGE =
      RouteConfig(name: 'channel_list_page', path: '/channels');
}

class RouteConfig {
  const RouteConfig({required this.name, required this.path});
  final String name;
  final String path;
}

class ChannelRouteConfig extends RouteConfig {
  const ChannelRouteConfig({required super.name, required super.path});

  Map<String, String> params(Channel channel) => {'cid': channel.cid!};

  Map<String, String> queryParams(Message message) => {
        'mid': message.id,
        if (message.parentId != null) 'pid': message.parentId!
      };
}
