import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'mocks.dart';

void main() {
  const cid = 'messaging:general';
  final user = User(id: 'testUserId');

  ScheduledMessage scheduledMessage(
    String id, {
    String cid = cid,
    DateTime? scheduledAt,
    DateTime? updatedAt,
    ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
  }) => ScheduledMessage(
    id: id,
    cid: cid,
    user: user,
    message: Message(id: id, text: 'Good morning', user: user),
    scheduledAt: scheduledAt ?? DateTime.utc(2026, 11, 2, 9),
    status: status,
    createdAt: DateTime.utc(2026, 10, 29),
    updatedAt: updatedAt ?? DateTime.utc(2026, 10, 29),
  );

  late MockClient client;
  late StreamController<Event> events;

  void stubQuery(List<ScheduledMessage> loaded, {List<ScheduledMessageStatus>? statuses}) {
    when(
      () => client.queryScheduledMessages(cid: cid, statuses: statuses, limit: defaultScheduledMessagePagedLimit),
    ).thenAnswer(
      (_) async => QueryScheduledMessagesResponse()
        ..scheduledMessages = loaded
        ..next = null,
    );
  }

  Future<StreamScheduledMessageListController> loadedController({
    List<ScheduledMessage> loaded = const [],
    List<ScheduledMessageStatus>? statuses,
    StreamScheduledMessageListEventHandler? eventHandler,
  }) async {
    stubQuery(loaded, statuses: statuses);
    final controller = StreamScheduledMessageListController(
      client: client,
      cid: cid,
      statuses: statuses,
      eventHandler: eventHandler,
    );
    addTearDown(controller.dispose);
    await controller.doInitialLoad();
    return controller;
  }

  Future<void> emit(String type, [ScheduledMessage? scheduledMessage]) async {
    events.add(Event(type: type, scheduledMessage: scheduledMessage));
    await pumpEventQueue();
  }

  List<String> ids(StreamScheduledMessageListController controller) {
    return [for (final it in controller.value.asSuccess.items) it.id];
  }

  setUp(() {
    client = MockClient();
    events = StreamController.broadcast();
    addTearDown(events.close);
    when(() => client.on()).thenAnswer((_) => events.stream);
  });

  test('lists the loaded scheduled messages earliest first', () async {
    final controller = await loadedController(
      loaded: [
        scheduledMessage('later', scheduledAt: DateTime.utc(2026, 11, 3)),
        scheduledMessage('sooner', scheduledAt: DateTime.utc(2026, 11, 1)),
      ],
    );

    expect(ids(controller), ['sooner', 'later']);
  });

  test('adds a message scheduled in its channel', () async {
    final controller = await loadedController();

    await emit(EventType.scheduledMessageCreated, scheduledMessage('new'));

    expect(ids(controller), ['new']);
  });

  test('ignores a message scheduled in another channel', () async {
    final controller = await loadedController();

    await emit(EventType.scheduledMessageCreated, scheduledMessage('other', cid: 'messaging:other'));

    expect(ids(controller), isEmpty);
  });

  test('removes a sent message', () async {
    final controller = await loadedController(loaded: [scheduledMessage('sent')]);

    await emit(EventType.scheduledMessageSent, scheduledMessage('sent'));

    expect(ids(controller), isEmpty);
  });

  test('keeps a newer copy when an older update arrives', () async {
    final edited = scheduledMessage('edited', updatedAt: DateTime.utc(2026, 10, 30));
    final controller = await loadedController(loaded: [edited]);

    await emit(EventType.scheduledMessageUpdated, scheduledMessage('edited'));

    expect(controller.value.asSuccess.items, [edited]);
  });

  test('removes a message whose status leaves the listed ones', () async {
    final controller = await loadedController(
      loaded: [scheduledMessage('failing')],
      statuses: [ScheduledMessageStatus.scheduled],
    );

    await emit(
      EventType.scheduledMessageFailed,
      scheduledMessage('failing', status: ScheduledMessageStatus.failed, updatedAt: DateTime.utc(2026, 10, 30)),
    );

    expect(ids(controller), isEmpty);
  });

  test('shows the error when loading fails', () async {
    when(
      () => client.queryScheduledMessages(cid: cid, limit: defaultScheduledMessagePagedLimit),
    ).thenThrow(const StreamChatError('offline'));
    final controller = StreamScheduledMessageListController(client: client, cid: cid);
    addTearDown(controller.dispose);

    await controller.doInitialLoad();

    final error = controller.value.whenOrNull(null, error: (error) => error);
    expect(error?.message, 'offline');
  });

  test('loads again when the connection recovers', () async {
    final controller = await loadedController(loaded: [scheduledMessage('first')]);

    stubQuery([scheduledMessage('missed')]);
    await emit(EventType.connectionRecovered);

    expect(ids(controller), ['missed']);
  });

  test('uses a custom event handler', () async {
    final handler = _IgnoreCreatedHandler();
    final controller = await loadedController(eventHandler: handler);

    await emit(EventType.scheduledMessageCreated, scheduledMessage('ignored'));

    expect(ids(controller), isEmpty);
    expect(handler.ignored, 1);
  });
}

class _IgnoreCreatedHandler extends StreamScheduledMessageListEventHandler {
  int ignored = 0;

  @override
  void onScheduledMessageCreated(Event event, StreamScheduledMessageListController controller) => ignored++;
}
