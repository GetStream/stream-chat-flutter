import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_draft_list_controller.dart';
import 'package:stream_chat_flutter_core/src/stream_draft_list_event_handler.dart';

class MockStreamDraftListController extends Mock
    implements StreamDraftListController {}

class FakeDraft extends Fake implements Draft {}

void main() {
  group('StreamDraftListEventHandler', () {
    late StreamDraftListEventHandler eventHandler;
    late MockStreamDraftListController controller;

    setUp(() {
      eventHandler = StreamDraftListEventHandler();
      controller = MockStreamDraftListController();
    });

    setUpAll(() {
      registerFallbackValue(FakeDraft());
    });

    tearDown(() {
      reset(controller);
    });

    group('onConnectionRecovered', () {
      test('should refresh the controller', () {
        final event = Event(type: EventType.connectionRecovered);
        when(() => controller.refresh()).thenAnswer((_) async {});
        eventHandler.onConnectionRecovered(event, controller);
        verify(() => controller.refresh()).called(1);
      });
    });

    group('onDraftUpdated', () {
      test('should update draft in controller when draft is provided', () {
        final draft = Draft(
          channelCid: 'messaging:123',
          createdAt: DateTime.now(),
          message: DraftMessage(text: 'Test draft message'),
        );

        final event = Event(
          type: EventType.draftUpdated,
          draft: draft,
        );

        when(() => controller.updateDraft(draft)).thenReturn(true);
        eventHandler.onDraftUpdated(event, controller);
        verify(() => controller.updateDraft(draft)).called(1);
      });

      test('should do nothing when draft is not provided', () {
        final event = Event(type: EventType.draftUpdated);
        eventHandler.onDraftUpdated(event, controller);
        verifyNever(() => controller.updateDraft(any()));
      });
    });

    group('onDraftDeleted', () {
      test('should delete draft from controller when draft is provided', () {
        final draft = Draft(
          channelCid: 'messaging:123',
          createdAt: DateTime.now(),
          message: DraftMessage(text: 'Test draft message'),
        );

        final event = Event(
          type: EventType.draftDeleted,
          draft: draft,
        );

        when(() => controller.deleteDraft(draft)).thenReturn(true);
        eventHandler.onDraftDeleted(event, controller);
        verify(() => controller.deleteDraft(draft)).called(1);
      });

      test('should do nothing when draft is not provided', () {
        final event = Event(type: EventType.draftDeleted);
        eventHandler.onDraftDeleted(event, controller);
        verifyNever(() => controller.deleteDraft(any()));
      });
    });
  });
}
