import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class MockClient extends Mock implements StreamChatClient {}

class MockClientState extends Mock implements ClientState {}

class MockChannel extends Mock implements Channel {}

class MockChannelState extends Mock implements ChannelClientState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockVoidCallback extends Mock {
  void call();
}
