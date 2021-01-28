import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class MockClient extends Mock implements Client {}

class MockClientState extends Mock implements ClientState {}

class MockChannel extends Mock implements Channel {}

class MockChannelState extends Mock implements ChannelClientState {}
