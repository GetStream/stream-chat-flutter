// ignore_for_file: avoid_redundant_argument_values, cascade_invocations

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_message_reminder_list_controller.dart';

import 'mocks.dart';

MessageReminder generateMessageReminder({
  String? channelCid,
  String? messageId,
  String? userId,
  DateTime? remindAt,
  DateTime? createdAt,
  String? text,
}) {
  return MessageReminder(
    channelCid: channelCid ?? 'messaging:123',
    messageId: messageId ?? 'message_123',
    userId: userId ?? 'user_123',
    remindAt: remindAt ?? DateTime.now().add(const Duration(hours: 1)),
    createdAt: createdAt ?? DateTime.now(),
    message: Message(
      id: messageId ?? 'message_123',
      text: text ?? 'Test reminder message',
      user: User(id: userId ?? 'user_123'),
      createdAt: createdAt ?? DateTime.now(),
    ),
  );
}

List<MessageReminder> generateMessageReminders({
  int count = 2,
  List<String>? texts,
  List<String>? channelCids,
  List<String>? messageIds,
  List<String>? userIds,
  int? startId,
}) {
  final now = DateTime.now();
  final baseId = startId ?? 123;

  return List.generate(count, (index) {
    final channelCid = channelCids != null && index < channelCids.length
        ? channelCids[index]
        : 'messaging:${baseId + index}';
    final messageId = messageIds != null && index < messageIds.length ? messageIds[index] : 'message_${baseId + index}';
    final userId = userIds != null && index < userIds.length ? userIds[index] : 'user_${baseId + index}';
    final text = texts != null && index < texts.length ? texts[index] : 'Reminder ${index + 1}';

    return generateMessageReminder(
      channelCid: channelCid,
      messageId: messageId,
      userId: userId,
      text: text,
      remindAt: now.add(Duration(hours: index + 1)),
      createdAt: now.subtract(Duration(minutes: index)),
    );
  });
}

void main() {
  final client = MockClient();

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  setUp(() {
    when(client.on).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(client);
  });

  group('Initialization', () {
    test('should start in loading state when created with client', () {
      final controller = StreamMessageReminderListController(client: client);
      expect(controller.value, isA<Loading>());
    });

    test('should preserve provided value when created with fromValue', () {
      final reminders = generateMessageReminders();
      final value = PagedValue<String, MessageReminder>(items: reminders);
      final controller = StreamMessageReminderListController.fromValue(
        value,
        client: client,
      );

      expect(controller.value, same(value));
      expect(controller.value.asSuccess.items, equals(reminders));
    });
  });

  group('Initial loading', () {
    test('successfully loads message reminders from API', () async {
      final reminders = generateMessageReminders();
      final response = QueryRemindersResponse()
        ..reminders = reminders
        ..next = null;

      when(
        () => client.queryReminders(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => response);

      final controller = StreamMessageReminderListController(client: client);

      await controller.doInitialLoad();
      await pumpEventQueue();

      verify(
        () => client.queryReminders(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).called(1);

      expect(controller.value, isA<Success<String, MessageReminder>>());
      expect(controller.value.asSuccess.items, equals(reminders));
    });

    test('handles StreamChatError exceptions properly', () async {
      const chatError = StreamChatError('Network error');
      when(
        () => client.queryReminders(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenThrow(chatError);

      final controller = StreamMessageReminderListController(client: client);

      await controller.doInitialLoad();
      await pumpEventQueue();

      expect(controller.value, isA<Error>());
      expect((controller.value as Error).error, equals(chatError));
    });
  });

  group('Pagination', () {
    test('loadMore appends new reminders to existing items', () async {
      const nextKey = 'next_page_token';
      final existingReminders = generateMessageReminders();
      final additionalReminders = generateMessageReminders(
        count: 1,
        startId: 789,
        texts: ['Reminder 3'],
        channelCids: ['messaging:789'],
        messageIds: ['message_789'],
        userIds: ['user_789'],
      );

      final response = QueryRemindersResponse()
        ..reminders = additionalReminders
        ..next = null;

      when(
        () => client.queryReminders(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => response);

      final controller = StreamMessageReminderListController.fromValue(
        PagedValue<String, MessageReminder>(
          items: existingReminders,
          nextPageKey: nextKey,
        ),
        client: client,
      );

      await controller.loadMore(nextKey);
      await pumpEventQueue();

      final mergedReminders = [...existingReminders, ...additionalReminders];

      expect(
        controller.value.asSuccess.items.length,
        equals(mergedReminders.length),
      );

      expect(controller.value.asSuccess.nextPageKey, isNull);
    });

    test('loadMore handles StreamChatError exceptions properly', () async {
      const nextKey = 'next_page_token';
      final existingReminders = generateMessageReminders();
      const chatError = StreamChatError('Network error');

      when(
        () => client.queryReminders(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenThrow(chatError);

      final controller = StreamMessageReminderListController.fromValue(
        PagedValue<String, MessageReminder>(
          items: existingReminders,
          nextPageKey: nextKey,
        ),
        client: client,
      );

      await controller.loadMore(nextKey);
      await pumpEventQueue();

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(existingReminders));
      expect(controller.value.asSuccess.error, equals(chatError));
    });
  });

  group('Message Reminder CRUD operations', () {
    test('updateReminder replaces existing reminder with same predicate', () {
      final reminders = generateMessageReminders(
        texts: ['Reminder 1', 'Reminder 2'],
      );
      final controller = StreamMessageReminderListController.fromValue(
        PagedValue<String, MessageReminder>(items: reminders),
        client: client,
      );

      final newRemindAt = DateTime.now().add(const Duration(hours: 2));
      final updatedReminder = reminders[0].copyWith(
        remindAt: newRemindAt,
      );

      final result = controller.updateReminder(updatedReminder);

      expect(result, isTrue);
      expect(
        controller.value.asSuccess.items.any((r) => r.remindAt == newRemindAt),
        isTrue,
      );
      expect(controller.value.asSuccess.items.length, equals(reminders.length));
    });

    test('updateReminder adds reminder when no matching reminder exists', () {
      final reminders = generateMessageReminders();
      final controller = StreamMessageReminderListController.fromValue(
        PagedValue<String, MessageReminder>(items: reminders),
        client: client,
      );

      final newReminder = generateMessageReminder(
        channelCid: 'messaging:789',
        messageId: 'message_789',
        userId: 'user_789',
        text: 'New Reminder',
      );

      final result = controller.updateReminder(newReminder);

      expect(result, isTrue);
      expect(
        controller.value.asSuccess.items.length,
        equals(reminders.length + 1),
      );
      expect(
        controller.value.asSuccess.items.any(
          (r) => r.message?.text == newReminder.message?.text,
        ),
        isTrue,
      );
    });

    test('deleteReminder removes reminder and returns true when reminder exists', () {
      final reminders = generateMessageReminders();
      final controller = StreamMessageReminderListController.fromValue(
        PagedValue<String, MessageReminder>(items: reminders),
        client: client,
      );

      final result = controller.deleteReminder(reminders[0]);

      expect(result, isTrue);
      expect(
        controller.value.asSuccess.items.length,
        equals(reminders.length - 1),
      );
      expect(
        controller.value.asSuccess.items.any(
          (r) => r.messageId == reminders[0].messageId && r.userId == reminders[0].userId,
        ),
        isFalse,
      );
    });

    test('deleteReminder returns false when reminder does not exist', () {
      final reminders = generateMessageReminders();
      final controller = StreamMessageReminderListController.fromValue(
        PagedValue<String, MessageReminder>(items: reminders),
        client: client,
      );

      final nonExistentReminder = generateMessageReminder(
        channelCid: 'messaging:999',
        messageId: 'message_999',
        userId: 'user_999',
        text: 'Non-existent Reminder',
      );

      final result = controller.deleteReminder(nonExistentReminder);

      expect(result, isFalse);
      expect(controller.value.asSuccess.items.length, equals(reminders.length));
    });
  });

  group('Event handling', () {
    late StreamController<Event> eventController;
    final initialReminders = generateMessageReminders();

    setUp(() {
      eventController = StreamController<Event>.broadcast();
      when(client.on).thenAnswer((_) => eventController.stream);

      when(
        () => client.queryReminders(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer(
        (_) async => QueryRemindersResponse()
          ..reminders = initialReminders
          ..next = null,
      );
    });

    tearDown(() {
      eventController.close();
    });

    test('reminder_created event triggers reminder addition', () async {
      final controller = StreamMessageReminderListController(client: client);

      await controller.doInitialLoad();
      await pumpEventQueue();

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(initialReminders));

      final newReminder = generateMessageReminder(
        channelCid: 'messaging:new',
        messageId: 'message_new',
        userId: 'user_new',
        text: 'Created via event',
      );

      final event = Event(
        type: EventType.reminderCreated,
        reminder: newReminder,
      );

      eventController.add(event);
      await pumpEventQueue();

      final hasNewReminder = controller.value.asSuccess.items.any(
        (reminder) => reminder.message?.text == 'Created via event',
      );

      expect(hasNewReminder, isTrue);
      expect(
        controller.value.asSuccess.items.length,
        equals(initialReminders.length + 1),
      );
    });

    test('reminder_updated event triggers reminder update', () async {
      final controller = StreamMessageReminderListController(client: client);

      await controller.doInitialLoad();
      await pumpEventQueue();

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(initialReminders));

      final updatedReminder = initialReminders[0].copyWith(
        remindAt: DateTime.now().add(const Duration(hours: 5)),
      );

      final event = Event(
        type: EventType.reminderUpdated,
        reminder: updatedReminder,
      );

      eventController.add(event);
      await pumpEventQueue();

      final hasUpdatedReminder = controller.value.asSuccess.items.any(
        (reminder) => reminder.remindAt == updatedReminder.remindAt,
      );

      expect(hasUpdatedReminder, isTrue);
      expect(
        controller.value.asSuccess.items.length,
        equals(initialReminders.length),
      );
    });

    test('reminder_deleted event triggers reminder removal', () async {
      final controller = StreamMessageReminderListController(client: client);

      await controller.doInitialLoad();
      await pumpEventQueue();

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(initialReminders));

      final initialItemCount = controller.value.asSuccess.items.length;

      final event = Event(
        type: EventType.reminderDeleted,
        reminder: initialReminders[0],
      );

      eventController.add(event);
      await pumpEventQueue();

      expect(
        controller.value.asSuccess.items.length,
        equals(initialItemCount - 1),
      );

      expect(
        controller.value.asSuccess.items.any(
          (r) => r.messageId == initialReminders[0].messageId && r.userId == initialReminders[0].userId,
        ),
        isFalse,
      );
    });

    test('custom event listener can prevent default handling', () async {
      final controller = StreamMessageReminderListController(client: client);

      await controller.doInitialLoad();
      await pumpEventQueue();

      expect(controller.value.isSuccess, isTrue);
      expect(controller.value.asSuccess.items, equals(initialReminders));

      final initialItems = List.of(controller.value.asSuccess.items);

      var listenerCalled = false;
      controller.eventListener = (event) {
        listenerCalled = true;
        return true;
      };

      final updatedReminder = initialReminders[0].copyWith(
        remindAt: DateTime.now().add(const Duration(hours: 10)),
      );

      final event = Event(
        type: EventType.reminderUpdated,
        reminder: updatedReminder,
      );

      eventController.add(event);
      await pumpEventQueue();

      expect(listenerCalled, isTrue);
      expect(controller.value.asSuccess.items, equals(initialItems));
      expect(
        controller.value.asSuccess.items.any(
          (r) => r.remindAt == updatedReminder.remindAt,
        ),
        isFalse,
      );
    });

    test('ignores events when value is not in success state', () async {
      final controller = StreamMessageReminderListController(client: client);

      // Controller starts in loading state
      expect(controller.value.isNotSuccess, isTrue);

      var eventHandled = false;
      controller.eventListener = (event) {
        eventHandled = true;
        return false;
      };

      final reminder = generateMessageReminder();
      final event = Event(
        type: EventType.reminderCreated,
        reminder: reminder,
      );

      eventController.add(event);
      await pumpEventQueue();

      expect(eventHandled, isFalse);
    });
  });
}
