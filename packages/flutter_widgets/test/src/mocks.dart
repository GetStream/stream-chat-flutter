import 'package:mockito/mockito.dart';
import 'package:stream_chat/stream_chat.dart';

class MockClient extends Mock implements Client {}

class MockClientState extends Mock implements ClientState {}

class MockChannel extends Mock implements Channel {}

class MockChannelState extends Mock implements ChannelClientState {}
