import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class MockClient extends Mock implements StreamChatClient {}

class MockClientState extends Mock implements ClientState {}

class MockChannel extends Mock implements Channel {
  @override
  Future<bool> get initialized async => true;

  @override
  // ignore: prefer_expression_function_bodies
  Future<void> keyStroke([String? parentId]) async {
    return;
  }
}

class MockChannelState extends Mock implements ChannelClientState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockVoidCallback extends Mock {
  void call();
}
