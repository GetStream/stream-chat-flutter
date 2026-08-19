import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';

import '../../mocks.dart';

/// Builds a minimal [ChannelState] for a channel of the given id/type.
ChannelState generateChannelState(
  String channelId,
  String channelType, {
  DateTime? lastMessageAt,
  List<ChannelCapability>? ownCapabilities,
  bool mockChannelConfig = false,
}) {
  ChannelConfig? config;
  if (mockChannelConfig) {
    config = MockChannelConfig();
    when(() => config!.readEvents).thenReturn(true);
    when(() => config!.typingEvents).thenReturn(true);
  }
  final channel = ChannelModel(
    id: channelId,
    type: channelType,
    config: config,
    ownCapabilities: ownCapabilities,
    lastMessageAt: lastMessageAt,
  );
  final state = ChannelState(channel: channel);
  return state;
}

/// Creates a detached [Logger] that prints all records.
Logger createLogger(String name) {
  final logger = Logger.detached(name)..level = Level.ALL;
  logger.onRecord.listen(print);
  return logger;
}
