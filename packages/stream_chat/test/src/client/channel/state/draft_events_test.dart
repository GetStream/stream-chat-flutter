import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

final _draftCreatedAt = DateTime.utc(2021, 3);

ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
  channel: createDefaultChannelModel(cid: _channelCid),
);

void main() {
  group('Draft events', () {
    channelTest(
      'should handle draft.updated event for channel drafts',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Verify initial state
        expect(tester.channelState?.draft, isNull);

        // Create Draft
        final draft = Draft(
          channelCid: tester.channel.cid!,
          createdAt: _draftCreatedAt,
          message: DraftMessage(text: 'test message'),
        );

        // Create and dispatch draft.updated event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.draftUpdated,
            draft: draft,
          ),
        );

        // Verify channel draft was updated
        expect(tester.channelState?.draft, isNotNull);
        expect(tester.channelState?.draft?.message.text, 'test message');
      },
    );

    channelTest(
      'should handle draft.updated event for thread drafts',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const threadParentMessageId = 'thread-parent-id';

        // Setup initial state with a regular message
        tester.channelState?.updateMessage(
          Message(
            id: threadParentMessageId,
            user: tester.currentUser,
          ),
        );

        // Verify initial state
        expect(tester.channelState?.threadDraft(threadParentMessageId), isNull);

        // Create thread Draft
        final draft = Draft(
          channelCid: tester.channel.cid!,
          createdAt: _draftCreatedAt,
          parentId: threadParentMessageId,
          message: DraftMessage(text: 'thread reply'),
        );

        // Create and dispatch draft.updated event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.draftUpdated,
            draft: draft,
          ),
        );

        // Verify thread draft was updated
        final threadDraft = tester.channelState?.threadDraft(threadParentMessageId);
        expect(threadDraft, isNotNull);
        expect(threadDraft?.message.text, 'thread reply');
      },
    );

    channelTest(
      'should handle draft.deleted event for channel drafts',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Setup initial state with a draft
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            draft: Draft(
              channelCid: tester.channel.cid!,
              createdAt: _draftCreatedAt,
              message: DraftMessage(text: 'test message'),
            ),
          ),
        );

        // Verify initial state
        final draft = tester.channelState?.draft;
        expect(draft, isNotNull);
        expect(draft?.message.text, 'test message');

        // Create and dispatch draft.deleted event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.draftDeleted,
            draft: draft,
          ),
        );

        // Verify channel draft was updated
        expect(tester.channelState?.draft, isNull);
      },
    );

    channelTest(
      'should handle draft.deleted event for thread drafts',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const threadParentMessageId = 'thread-parent-id';

        // Setup initial state with a thread draft
        tester.channelState?.updateMessage(
          Message(
            id: threadParentMessageId,
            user: tester.currentUser,
            draft: Draft(
              channelCid: tester.channel.cid!,
              createdAt: _draftCreatedAt,
              parentId: threadParentMessageId,
              message: DraftMessage(text: 'thread reply'),
            ),
          ),
        );

        // Verify initial state
        final threadDraft = tester.channelState?.threadDraft(threadParentMessageId);
        expect(threadDraft, isNotNull);
        expect(threadDraft?.message.text, 'thread reply');

        // Create and dispatch draft.deleted event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.draftDeleted,
            draft: threadDraft,
          ),
        );

        // Verify thread draft was removed
        expect(tester.channelState?.threadDraft(threadParentMessageId), isNull);
      },
    );

    channelTest(
      'should update current channel draft if draft.updated event is emitted',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Setup initial state with a draft
        final initialDraft = Draft(
          channelCid: tester.channel.cid!,
          createdAt: _draftCreatedAt,
          message: DraftMessage(text: 'test message'),
        );

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            draft: initialDraft,
          ),
        );

        // Verify initial state
        expect(tester.channelState?.draft, isNotNull);
        expect(tester.channelState?.draft?.message.text, 'test message');

        // Create Draft
        final updatedDraft = initialDraft.copyWith(
          message: DraftMessage(text: 'updated message'),
        );

        // Create and dispatch draft.updated event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.draftUpdated,
            draft: updatedDraft,
          ),
        );

        // Verify channel draft was updated
        expect(tester.channelState?.draft, isNotNull);
        expect(tester.channelState?.draft?.message.text, 'updated message');
      },
    );

    channelTest(
      'should update current thread draft if draft.updated event is emitted',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const threadParentMessageId = 'thread-parent-id';

        // Setup initial state with a thread draft
        final initialDraft = Draft(
          channelCid: tester.channel.cid!,
          createdAt: _draftCreatedAt,
          parentId: threadParentMessageId,
          message: DraftMessage(text: 'thread reply'),
        );

        tester.channelState?.updateMessage(
          Message(
            id: threadParentMessageId,
            user: tester.currentUser,
            draft: initialDraft,
          ),
        );

        // Verify initial state
        final draft = tester.channelState?.threadDraft(threadParentMessageId);
        expect(draft, isNotNull);
        expect(draft?.message.text, 'thread reply');

        // Create Draft
        final updatedDraft = initialDraft.copyWith(
          message: DraftMessage(text: 'updated thread reply'),
        );

        // Create and dispatch draft.updated event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.draftUpdated,
            draft: updatedDraft,
          ),
        );

        // Verify thread draft was updated
        final threadDraft = tester.channelState?.threadDraft(threadParentMessageId);
        expect(threadDraft, isNotNull);
        expect(threadDraft?.message.text, 'updated thread reply');
      },
    );

    channelTest(
      'an event without a draft is ignored',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        await tester.emitEvent(createDefaultEvent(cid: tester.channel.cid, type: EventType.draftUpdated));

        expect(tester.channelState?.draft, isNull);
      },
    );
  });
}
