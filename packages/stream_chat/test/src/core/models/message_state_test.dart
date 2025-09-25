// ignore_for_file: use_named_constants, lines_longer_than_80_chars, avoid_redundant_argument_values

import 'package:stream_chat/src/core/models/message_delete_scope.dart';
import 'package:stream_chat/src/core/models/message_state.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Message State Extensions',
    () {
      test(
        'isInitial should return true if the message state is MessageInitial',
        () {
          const messageState = MessageState.initial();
          expect(messageState.isInitial, true);
        },
      );

      test(
        'isOutgoing should return true if the message state is MessageOutgoing',
        () {
          const messageState = MessageState.outgoing(
            state: OutgoingState.sending(),
          );
          expect(messageState.isOutgoing, true);
        },
      );

      test(
        'isCompleted should return true if the message state is MessageCompleted',
        () {
          const messageState = MessageState.completed(
            state: CompletedState.sent(),
          );
          expect(messageState.isCompleted, true);
        },
      );

      test(
        'isFailed should return true if the message state is MessageFailed',
        () {
          const messageState = MessageState.failed(
            state: FailedState.sendingFailed(),
          );
          expect(messageState.isFailed, true);
        },
      );

      test(
        'isSending should return true if the message state is MessageOutgoing with Sending state',
        () {
          const messageState = MessageState.outgoing(
            state: OutgoingState.sending(),
          );
          expect(messageState.isSending, true);
        },
      );

      test(
        'isUpdating should return true if the message state is MessageOutgoing with Updating state',
        () {
          const messageState = MessageState.outgoing(
            state: OutgoingState.updating(),
          );
          expect(messageState.isUpdating, true);
        },
      );

      test(
        'isDeleting should return true if the message state is either isSoftDeleting or isHardDeleting',
        () {
          const messageState = MessageState.softDeleting;
          expect(messageState.isDeleting, true);
        },
      );

      test(
        'isSoftDeleting should return true if the message state is MessageOutgoing with Deleting state and scope is softDeleteForAll',
        () {
          const messageState = MessageState.outgoing(
            state: OutgoingState.deleting(
              scope: MessageDeleteScope.softDeleteForAll,
            ),
          );
          expect(messageState.isSoftDeleting, true);
        },
      );

      test(
        'isHardDeleting should return true if the message state is MessageOutgoing with Deleting state and scope is HardDeleteForAll',
        () {
          const messageState = MessageState.outgoing(
            state: OutgoingState.deleting(
              scope: MessageDeleteScope.hardDeleteForAll,
            ),
          );
          expect(messageState.isHardDeleting, true);
        },
      );

      test(
        'isDeletingForMe should return true if the message state is MessageOutgoing with Deleting state and scope is DeleteForMe',
        () {
          const messageState = MessageState.outgoing(
            state: OutgoingState.deleting(
              scope: MessageDeleteScope.deleteForMe(),
            ),
          );
          expect(messageState.isDeletingForMe, true);
        },
      );

      test(
        'isSent should return true if the message state is MessageCompleted with Sent state',
        () {
          const messageState =
              MessageState.completed(state: CompletedState.sent());
          expect(messageState.isSent, true);
        },
      );

      test(
        'isUpdated should return true if the message state is MessageCompleted with Updated state',
        () {
          const messageState = MessageState.completed(
            state: CompletedState.updated(),
          );
          expect(messageState.isUpdated, true);
        },
      );

      test(
        'isDeleted should return true if the message state is either isSoftDeleted or isHardDeleted',
        () {
          const messageState = MessageState.softDeleted;
          expect(messageState.isDeleted, true);
        },
      );

      test(
        'isSoftDeleted should return true if the message state is MessageCompleted with Deleted state and scope is softDeleteForAll',
        () {
          const messageState = MessageState.completed(
            state: CompletedState.deleted(
              scope: MessageDeleteScope.softDeleteForAll,
            ),
          );
          expect(messageState.isSoftDeleted, true);
        },
      );

      test(
        'isHardDeleted should return true if the message state is MessageCompleted with Deleted state and scope is hardDeleteForAll',
        () {
          const messageState = MessageState.completed(
            state: CompletedState.deleted(
              scope: MessageDeleteScope.hardDeleteForAll,
            ),
          );
          expect(messageState.isHardDeleted, true);
        },
      );

      test(
        'isDeletedForMe should return true if the message state is MessageCompleted with Deleted state and scope is DeleteForMe',
        () {
          const messageState = MessageState.completed(
            state: CompletedState.deleted(
              scope: MessageDeleteScope.deleteForMe(),
            ),
          );
          expect(messageState.isDeletedForMe, true);
        },
      );

      test(
        'isSendingFailed should return true if the message state is MessageFailed with SendingFailed state',
        () {
          const messageState = MessageState.failed(
            state: FailedState.sendingFailed(),
          );
          expect(messageState.isSendingFailed, true);
        },
      );

      test(
        'isUpdatingFailed should return true if the message state is MessageFailed with UpdatingFailed state',
        () {
          const messageState = MessageState.failed(
            state: FailedState.updatingFailed(),
          );
          expect(messageState.isUpdatingFailed, true);
        },
      );

      test(
        'isDeletingFailed should return true if the message state is either isSoftDeletingFailed or isHardDeletingFailed',
        () {
          const messageState = MessageState.softDeletingFailed;
          expect(messageState.isDeletingFailed, true);
        },
      );

      test(
        'isSoftDeletingFailed should return true if the message state is MessageFailed with DeletingFailed state and scope is softDeleteForAll',
        () {
          const messageState = MessageState.failed(
            state: FailedState.deletingFailed(
              scope: MessageDeleteScope.softDeleteForAll,
            ),
          );
          expect(messageState.isSoftDeletingFailed, true);
        },
      );

      test(
        'isHardDeletingFailed should return true if the message state is MessageFailed with DeletingFailed state and scope is hardDeleteForAll',
        () {
          const messageState = MessageState.failed(
            state: FailedState.deletingFailed(
              scope: MessageDeleteScope.hardDeleteForAll,
            ),
          );
          expect(messageState.isHardDeletingFailed, true);
        },
      );

      test(
        'isDeletingForMeFailed should return true if the message state is MessageFailed with DeletingFailed state and scope is DeleteForMe',
        () {
          const messageState = MessageState.failed(
            state: FailedState.deletingFailed(
              scope: MessageDeleteScope.deleteForMe(),
            ),
          );
          expect(messageState.isDeletingForMeFailed, true);
        },
      );
    },
  );

  group('Message State Classes', () {
    test(
      'MessageState.sending should create a MessageOutgoing instance with Sending state',
      () {
        const messageState = MessageState.sending;
        expect(messageState, isA<MessageOutgoing>());
        expect((messageState as MessageOutgoing).state, isA<Sending>());
      },
    );

    test(
      'MessageState.updating should create a MessageOutgoing instance with Updating state',
      () {
        const messageState = MessageState.updating;
        expect(messageState, isA<MessageOutgoing>());
        expect((messageState as MessageOutgoing).state, isA<Updating>());
      },
    );

    test(
      'MessageState.softDeleting should create a MessageOutgoing instance with Deleting state and softDeleteForAll scope',
      () {
        const messageState = MessageState.softDeleting;
        expect(messageState, isA<MessageOutgoing>());
        expect((messageState as MessageOutgoing).state, isA<Deleting>());

        final deletingState = messageState.state as Deleting;
        expect(deletingState.scope, isA<DeleteForAll>());
        expect((deletingState.scope as DeleteForAll).hard, false);
      },
    );

    test(
      'MessageState.hardDeleting should create a MessageOutgoing instance with Deleting state and hardDeleteForAll scope',
      () {
        const messageState = MessageState.hardDeleting;
        expect(messageState, isA<MessageOutgoing>());
        expect((messageState as MessageOutgoing).state, isA<Deleting>());

        final deletingState = messageState.state as Deleting;
        expect(deletingState.scope, isA<DeleteForAll>());
        expect((deletingState.scope as DeleteForAll).hard, true);
      },
    );

    test(
      'MessageState.deletingForMe should create a MessageOutgoing instance with Deleting state and DeleteForMe scope',
      () {
        const messageState = MessageState.deletingForMe;
        expect(messageState, isA<MessageOutgoing>());
        expect((messageState as MessageOutgoing).state, isA<Deleting>());

        final deletingState = messageState.state as Deleting;
        expect(deletingState.scope, isA<DeleteForMe>());
        expect((deletingState.scope as DeleteForMe).hard, false);
      },
    );

    test(
      'MessageState.sent should create a MessageCompleted instance with Sent state',
      () {
        const messageState = MessageState.sent;
        expect(messageState, isA<MessageCompleted>());
        expect((messageState as MessageCompleted).state, isA<Sent>());
      },
    );

    test(
      'MessageState.updated should create a MessageCompleted instance with Updated state',
      () {
        const messageState = MessageState.updated;
        expect(messageState, isA<MessageCompleted>());
        expect((messageState as MessageCompleted).state, isA<Updated>());
      },
    );

    test(
      'MessageState.softDeleted should create a MessageCompleted instance with Deleted state and softDeleteForAll scope',
      () {
        const messageState = MessageState.softDeleted;
        expect(messageState, isA<MessageCompleted>());
        expect((messageState as MessageCompleted).state, isA<Deleted>());

        final deletedState = messageState.state as Deleted;
        expect(deletedState.scope, isA<DeleteForAll>());
        expect((deletedState.scope as DeleteForAll).hard, false);
      },
    );

    test(
      'MessageState.hardDeleted should create a MessageCompleted instance with Deleted state and hardDeleteForAll scope',
      () {
        const messageState = MessageState.hardDeleted;
        expect(messageState, isA<MessageCompleted>());
        expect((messageState as MessageCompleted).state, isA<Deleted>());

        final deletedState = messageState.state as Deleted;
        expect(deletedState.scope, isA<DeleteForAll>());
        expect((deletedState.scope as DeleteForAll).hard, true);
      },
    );

    test(
      'MessageState.deletedForMe should create a MessageCompleted instance with Deleted state and DeleteForMe scope',
      () {
        const messageState = MessageState.deletedForMe;
        expect(messageState, isA<MessageCompleted>());
        expect((messageState as MessageCompleted).state, isA<Deleted>());

        final deletedState = messageState.state as Deleted;
        expect(deletedState.scope, isA<DeleteForMe>());
        expect((deletedState.scope as DeleteForMe).hard, false);
      },
    );

    test(
      'MessageState.sendingFailed should create a MessageFailed instance with SendingFailed state',
      () {
        final messageState = MessageState.sendingFailed(
          skipPush: false,
          skipEnrichUrl: false,
        );
        expect(messageState, isA<MessageFailed>());
        expect((messageState as MessageFailed).state, isA<SendingFailed>());
      },
    );

    test(
      'MessageState.updatingFailed should create a MessageFailed instance with UpdatingFailed state',
      () {
        final messageState = MessageState.updatingFailed(
          skipPush: false,
          skipEnrichUrl: false,
        );
        expect(messageState, isA<MessageFailed>());
        expect((messageState as MessageFailed).state, isA<UpdatingFailed>());
      },
    );

    test(
      'MessageState.partialUpdatingFailed should create a MessageFailed instance with UpdatingFailed state',
      () {
        final messageState = MessageState.partialUpdatingFailed(
          skipEnrichUrl: false,
        );
        expect(messageState, isA<MessageFailed>());
        expect(
          (messageState as MessageFailed).state,
          isA<PartialUpdatingFailed>(),
        );
      },
    );

    test(
      'MessageState.softDeletingFailed should create a MessageFailed instance with DeletingFailed state and softDeleteForAll scope',
      () {
        const messageState = MessageState.softDeletingFailed;
        expect(messageState, isA<MessageFailed>());
        expect((messageState as MessageFailed).state, isA<DeletingFailed>());

        final failedState = messageState.state as DeletingFailed;
        expect(failedState.scope, isA<DeleteForAll>());
        expect((failedState.scope as DeleteForAll).hard, false);
      },
    );

    test(
      'MessageState.hardDeletingFailed should create a MessageFailed instance with DeletingFailed state and hardDeleteForAll scope',
      () {
        const messageState = MessageState.hardDeletingFailed;
        expect(messageState, isA<MessageFailed>());
        expect((messageState as MessageFailed).state, isA<DeletingFailed>());

        final failedState = messageState.state as DeletingFailed;
        expect(failedState.scope, isA<DeleteForAll>());
        expect((failedState.scope as DeleteForAll).hard, true);
      },
    );

    test(
      'MessageState.deletingForMeFailed should create a MessageFailed instance with DeletingFailed state and DeleteForMe scope',
      () {
        const messageState = MessageState.deletingForMeFailed;
        expect(messageState, isA<MessageFailed>());
        expect((messageState as MessageFailed).state, isA<DeletingFailed>());

        final failedState = messageState.state as DeletingFailed;
        expect(failedState.scope, isA<DeleteForMe>());
        expect((failedState.scope as DeleteForMe).hard, false);
      },
    );
  });
}
