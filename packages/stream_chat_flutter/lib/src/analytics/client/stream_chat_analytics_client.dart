import 'dart:async';

import 'package:stream_chat_flutter/src/analytics/models/stream_chat_analytics_event.dart';

/// The StreamChatAnalyticsClient helps track the different events that are
/// triggered by the SDK based on interactions with the UI
class StreamChatAnalyticsClient {
  ///
  StreamChatAnalyticsClient() {
    _analyticsEventStreamController =
        StreamController<StreamChatAnalyticsEvent>.broadcast();
    analyticsEventStream = _analyticsEventStreamController.stream;
  }
  late StreamController<StreamChatAnalyticsEvent>
      _analyticsEventStreamController;

  /// Subscribe to this stream to get the events and data, as and when
  /// the UI interactions take place
  late Stream<StreamChatAnalyticsEvent> analyticsEventStream;

  /// Clean up the members of the client
  void dispose() {
    _analyticsEventStreamController.close();
  }

  /// Capture an interaction and fire an event
  void captureInteraction(StreamChatAnalyticsEvent event) {
    _analyticsEventStreamController.add(event);
  }
}
