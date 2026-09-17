import 'dart:async';

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

// Builds the channel already initialized from state, so the state attaches
// while a persistence client is set.
Channel _buildInitializedChannel(StreamChatClient client) {
  return Channel.fromState(
    client,
    createDefaultChannelState(
      channel: createDefaultChannelModel(cid: _channelCid),
    ),
  );
}

// Stubs the persistence calls these tests drive (`getChannelThreads`,
// `getChannelStateByCid`, `updateMessages`) plus the ones the real client
// makes on its own: `updateConnectionInfo` on connect and the debounced
// channel state/thread writes.
MockPersistenceClient _createPersistenceClient() {
  registerFallbackValue(createDefaultEvent());
  registerFallbackValue(createDefaultChannelState());
  registerFallbackValue(<Message>[]);
  registerFallbackValue(<String, List<Message>>{});

  final persistenceClient = MockPersistenceClient();
  when(() => persistenceClient.updateConnectionInfo(any())).thenAnswer((_) async {});
  when(() => persistenceClient.getChannelThreads(_channelCid)).thenAnswer((_) async => {});
  when(() => persistenceClient.getChannelStateByCid(_channelCid)).thenAnswer(
    (_) async => createDefaultChannelState(
      channel: createDefaultChannelModel(cid: _channelCid),
    ),
  );
  when(() => persistenceClient.updateMessages(_channelCid, any())).thenAnswer((_) => Future.value());
  when(() => persistenceClient.updateChannelState(any())).thenAnswer((_) async {});
  when(() => persistenceClient.updateChannelThreads(_channelCid, any())).thenAnswer((_) async {});
  return persistenceClient;
}

final persistenceClient = _createPersistenceClient();

void main() {
  group('Non-Initialized Channel', () {
    channelTest(
      'should be able to set `extraData`',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final channel = tester.channel;

        expect(channel.extraData.isEmpty, isTrue);

        expect(
          () => channel.extraData = {'name': 'test-channel-name'},
          returnsNormally,
        );

        expect(channel.extraData.isEmpty, isFalse);
        expect(channel.extraData.containsKey('name'), isTrue);
        expect(channel.extraData['name'], 'test-channel-name');
      },
    );

    channelTest(
      'should be able to get and set `image`',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final channel = tester.channel;

        expect(channel.extraData.isEmpty, isTrue);

        const imageUrl = 'https://getstream.io/some-image';
        channel.image = imageUrl;

        expect(channel.image, imageUrl);
        expect(channel.extraData['image'], imageUrl);

        const newImage = 'https://getstream.io/new-image';
        final newChannelInstance = Channel(tester.client, _channelType, _channelId, image: newImage);

        expect(newChannelInstance.image, newImage);
        expect(newChannelInstance.extraData['image'], newImage);
      },
    );

    channelTest(
      'should be able to get and set `name`',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final channel = tester.channel;

        expect(channel.extraData.isEmpty, isTrue);

        const name = 'Channel name';
        channel.name = name;

        expect(channel.name, name);
        expect(channel.extraData['name'], name);

        const newName = 'New channel name';
        final newChannelInstance = Channel(tester.client, _channelType, _channelId, name: newName);

        expect(newChannelInstance.name, newName);
        expect(newChannelInstance.extraData['name'], newName);
      },
    );

    channelTest(
      'setters remain usable after a failed watch()',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final channel = tester.channel;

        // Make initialization fail.
        tester.mockApiFailure(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: channel.extraData,
            state: true,
            watch: true,
            presence: false,
          ),
          error: createDefaultNetworkError(code: StreamErrorCode.inputError, statusCode: 400),
        );

        // A failed watch() also completes `initialized` with the error. Attach
        // the expectation up-front so that error has a listener the moment it
        // occurs and isn't reported as an unhandled async error.
        final initializedFailure = expectLater(
          channel.initialized,
          throwsA(isA<StreamApiException>()),
        );

        await expectLater(
          channel.watch(),
          throwsA(isA<StreamApiException>()),
        );
        await initializedFailure;

        // Init never *succeeded*, so the raw setters must still work. Previously
        // they threw because the completer was merely `isCompleted` (it had
        // completed with an error).
        expect(() => channel.name = 'New name', returnsNormally);
        expect(channel.name, 'New name');
      },
    );
  });

  group('Initialized Channel with Persistence', () {
    channelTest(
      'initializes from state and loads channel threads from the persistence client',
      channelType: _channelType,
      channelId: _channelId,
      build: _buildInitializedChannel,
      chatPersistenceClient: persistenceClient,
      body: (tester) async {
        expect(tester.channel.cid, _channelCid);
        expect(tester.channelState, isNotNull);
        await expectLater(tester.channel.initialized, completion(isTrue));

        // Attaching the state loads the channel's threads from the offline
        // storage; the stubbed storage has none, so the state stays empty.
        verify(() => persistenceClient.getChannelThreads(_channelCid)).called(1);
        expect(tester.channelState!.threads, isEmpty);
        expect(tester.channelState!.messages, isEmpty);
      },
    );
  });

  group('Initialized Channel', () {
    ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
      channel: createDefaultChannelModel(
        cid: _channelCid,
        config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
        ownCapabilities: [ChannelCapability.readEvents],
      ),
    );

    ChannelState Function(ChannelState) _seedChannelLocationApi() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: const [ChannelCapability.readEvents],
        ),
      );
    }

    Future<ChannelState> _seedChannelDrafts(ChannelTester tester) => tester.watch(
      modifyResponse: (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: const [ChannelCapability.readEvents],
        ),
      ),
    );

    Future<ChannelState> _seedChannelReminders(ChannelTester tester) => tester.watch(
      modifyResponse: (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: const [ChannelCapability.readEvents],
        ),
      ),
    );

    ChannelState Function(ChannelState) _seedChannelUpdateMessage() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      );
    }

    ChannelState Function(ChannelState) _seedChannelDeleteMessage() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      );
    }

    ChannelState Function(ChannelState) _seedChannelPinMessage() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      );
    }

    ChannelState Function(ChannelState) _seedChannelMiscOperations() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      );
    }

    ChannelState Function(ChannelState) _seedChannelReactions() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: const [ChannelCapability.readEvents],
        ),
      );
    }

    Future<ChannelState> _seedChannelUpdateApi(ChannelTester tester) => tester.watch(
      modifyResponse: (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: const [ChannelCapability.readEvents],
        ),
      ),
    );

    Future<ChannelState> _seedChannelMemberApi(ChannelTester tester) => tester.watch(
      modifyResponse: (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: const [ChannelCapability.readEvents],
        ),
      ),
    );

    ChannelState Function(ChannelState) _seedChannelWatch() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      );
    }

    ChannelState Function(ChannelState) _seedChannelMessageQueries() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      );
    }

    // Builds the channel already initialized from state — the `.query` tests
    // exercise `queryChannel` themselves, so they cannot seed through
    // `tester.watch()` without polluting the call counts they verify.
    Channel _buildInitializedChannel(
      StreamChatClient client, {
      List<ChannelCapability> ownCapabilities = const [ChannelCapability.readEvents],
      List<Message> messages = const [],
    }) {
      return Channel.fromState(
        client,
        createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: ownCapabilities,
          ),
          messages: messages,
        ),
      );
    }

    ChannelState Function(ChannelState) _seedChannelModerationApi() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      );
    }

    ChannelState Function(ChannelState) _seedChannelDisplayApi() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      );
    }

    // A bare channel state (no config, no capabilities) used to seed messages
    // directly into the channel's client state.
    ChannelState _channelStateWith({
      List<Message> messages = const [],
      List<Message> pinnedMessages = const [],
    }) {
      return createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
        messages: messages,
        pinnedMessages: pinnedMessages,
      );
    }

    // testing archiving

    // testing pinning

    channelTest(
      'should throw if trying to set `extraData`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        try {
          tester.channel.extraData = {'name': 'test-channel-name'};
        } catch (e) {
          expect(e, isA<StateError>());
        }
      },
    );

    channelTest(
      'should throw if trying to set `image`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        try {
          tester.channel.image = 'https://stream.io/some-image';
        } catch (e) {
          expect(e, isA<StateError>());
        }
      },
    );

    channelTest(
      'should throw if trying to set `name`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        try {
          tester.channel.name = 'New name';
        } catch (e) {
          expect(e, isA<StateError>());
        }
      },
    );

    group('`.sendMessage`', () {
      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: const [ChannelCapability.readEvents],
          ),
        );
      }

      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello world!',
            user: tester.currentUser,
          );

          tester.mockApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sent),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.sendMessage(message);

          expect(res, isNotNull);
          expect(res.message.id, message.id);

          tester.verifyApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
          );

          await messagesEmission;
        },
      );

      channelTest(
        'queues a failed send for retry when the failure is retriable',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          // The enqueue gate used to test a type nothing throws any more, so a
          // failed send never reached the queue at all. The retry is observable
          // as a second attempt, since adding to the queue processes it.
          final message = Message(id: 'retriable-id', text: 'hi', user: tester.currentUser);

          tester.mockApiFailure(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            error: createDefaultNetworkError(statusCode: 500),
          );

          await expectLater(
            tester.channel.sendMessage(message),
            throwsA(isA<StreamChatException>()),
          );
          await tester.pumpEventQueue();

          tester.verifyApiCalled(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            times: 2,
          );
        },
      );

      channelTest(
        'does not queue a failed send when the failure is not retriable',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(id: 'refused-id', text: 'hi', user: tester.currentUser);

          tester.mockApiFailure(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            error: createDefaultNetworkError(code: StreamErrorCode.notAllowed, statusCode: 403),
          );

          await expectLater(
            tester.channel.sendMessage(message),
            throwsA(isA<StreamChatException>()),
          );
          await tester.pumpEventQueue();

          tester.verifyApiCalled(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            times: 1,
          );
        },
      );

      channelTest(
        'should re-send the message through the retry queue when the failure is retriable',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello world!',
            user: tester.currentUser,
          );

          tester.mockApiFailure(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            error: createDefaultNetworkError(code: StreamErrorCode.internalError, statusCode: 500),
          );

          await expectLater(
            tester.channel.sendMessage(message),
            throwsA(isA<StreamApiException>()),
          );
          await tester.pumpEventQueue();

          // Once for the original send, once for the queue's retry attempt.
          tester.verifyApiCalled(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            times: 2,
          );
        },
      );

      channelTest(
        'should not re-send the message when the failure is not retriable',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello world!',
            user: tester.currentUser,
          );

          tester.mockApiFailure(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            error: createDefaultNetworkError(code: StreamErrorCode.inputError, statusCode: 400),
          );

          await expectLater(
            tester.channel.sendMessage(message),
            throwsA(isA<StreamApiException>()),
          );
          await tester.pumpEventQueue();

          tester.verifyApiCalled(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            times: 1,
          );
        },
      );

      channelTest(
        'should report a superseded send as a cancelled request',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final attachment = Attachment(
            id: 'test-attachment-id',
            type: 'image',
            file: AttachmentFile(size: 100, path: 'test-file-path'),
          );

          final message = Message(id: 'test-message-id', attachments: [attachment]);

          // Holds the first send inside its attachment upload, so the second
          // one arrives while it is still in flight.
          tester.mockApi(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
            result: SendImageResponse()..file = 'url',
            delay: const Duration(seconds: 1),
          );

          final superseded = tester.channel.sendMessage(message);
          await tester.pumpEventQueue();
          unawaited(
            tester.channel.sendMessage(message).catchError((_) => SendMessageResponse()),
          );

          // The caller stopped it, so it is a cancelled request rather than an
          // SDK failure a crash tracker should hear about.
          await expectLater(
            superseded,
            throwsA(
              isA<StreamNetworkException>().having((it) => it.isCancelled, 'isCancelled', isTrue),
            ),
          );
        },
      );

      channelTest(
        'should mark a refused send as failed with skipPush: true, skipEnrichUrl: false',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello world!',
            user: tester.currentUser,
          );

          // A 403 is the server's verdict on the request, not a transient
          // failure, so the queue declines it and the send is simply refused.
          tester.mockApiFailure(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.notAllowed, statusCode: 403),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sendingFailed(
                      skipPush: true,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.sendMessage(
              message,
              skipPush: true,
            );
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.notAllowed));
          }

          await messagesEmission;

          // Sent once: a refused send is never handed to the retry queue.
          tester.verifyApiCalled(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
            ),
            times: 1,
          );
        },
      );

      channelTest(
        'should mark a refused send as failed with skipPush: true, skipEnrichUrl: true',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-2',
            text: 'Hello world!',
            user: tester.currentUser,
          );

          // A 403 is the server's verdict on the request, not a transient
          // failure, so the queue declines it and the send is simply refused.
          tester.mockApiFailure(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.notAllowed, statusCode: 403),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sendingFailed(
                      skipPush: true,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.sendMessage(
              message,
              skipPush: true,
              skipEnrichUrl: true,
            );
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.notAllowed));
          }

          await messagesEmission;

          // Sent once: a refused send is never handed to the retry queue.
          tester.verifyApiCalled(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
            times: 1,
          );
        },
      );

      channelTest(
        'should mark a refused send as failed with skipPush: false, skipEnrichUrl: true',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-3',
            text: 'Hello world!',
            user: tester.currentUser,
          );

          // A 403 is the server's verdict on the request, not a transient
          // failure, so the queue declines it and the send is simply refused.
          tester.mockApiFailure(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipEnrichUrl: true,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.notAllowed, statusCode: 403),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sendingFailed(
                      skipPush: false,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.sendMessage(
              message,
              skipEnrichUrl: true,
            );
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.notAllowed));
          }

          await messagesEmission;

          // Sent once: a refused send is never handed to the retry queue.
          tester.verifyApiCalled(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipEnrichUrl: true,
            ),
            times: 1,
          );
        },
      );

      channelTest(
        'should mark a refused send as failed with skipPush: false, skipEnrichUrl: false',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-4',
            text: 'Hello world!',
            user: tester.currentUser,
          );

          // A 403 is the server's verdict on the request, not a transient
          // failure, so the queue declines it and the send is simply refused.
          tester.mockApiFailure(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            error: createDefaultNetworkError(code: StreamErrorCode.notAllowed, statusCode: 403),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sendingFailed(
                      skipPush: false,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.sendMessage(
              message,
            );
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.notAllowed));
          }

          await messagesEmission;

          // Sent once: a refused send is never handed to the retry queue.
          tester.verifyApiCalled(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            times: 1,
          );
        },
      );

      channelTest(
        'should update message state even when non-retriable error occurs',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello world!',
            user: tester.currentUser,
          );

          tester.mockApiFailure(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            error: createDefaultNetworkError(code: StreamErrorCode.inputError, statusCode: 400),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sendingFailed(
                      skipPush: false,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.sendMessage(message);
          } catch (e) {
            expect(e, isA<StreamApiException>());
          }

          await messagesEmission;
        },
      );

      channelTest(
        'with attachments should work just fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final attachments = List.generate(
            3,
            (index) => Attachment(
              id: 'test-attachment-id-$index',
              type: index.isEven ? 'image' : 'file',
              file: AttachmentFile(size: index * 33, path: 'test-file-path'),
            ),
          );

          final message = Message(
            id: 'test-message-id',
            attachments: attachments,
          );

          tester
            ..mockApi(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
              result: SendImageResponse()..file = 'test-image-url',
            )
            ..mockApi(
              (api) => api.fileUploader.sendFile(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
              result: SendFileResponse()..file = 'test-file-url',
            )
            ..mockApi(
              (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
              result: createDefaultSendMessageResponse(
                message: message.copyWith(
                  attachments: attachments
                      .map((it) => it.copyWith(uploadState: const UploadState.success()))
                      .toList(growable: false),
                  state: MessageState.sent,
                ),
              ),
            );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder(
              [
                // preparing attachments to upload
                [
                  isSameMessageAs(
                    message.copyWith(
                      state: MessageState.sending,
                      attachments: [
                        ...attachments.map((it) => it.copyWith(uploadState: const UploadState.preparing())),
                      ],
                    ),
                    matchMessageState: true,
                    matchAttachments: true,
                    matchAttachmentsUploadState: true,
                  ),
                ],
                // 0th attachment is successfully uploaded
                [
                  isSameMessageAs(
                    message.copyWith(
                      state: MessageState.sending,
                      attachments: [...attachments]
                        ..[0] = attachments[0].copyWith(
                          uploadState: const UploadState.success(),
                        ),
                    ),
                    matchMessageState: true,
                    matchAttachments: true,
                    matchAttachmentsUploadState: true,
                  ),
                ],
                // 0th and 1st attachment is successfully uploaded
                [
                  isSameMessageAs(
                    message.copyWith(
                      state: MessageState.sending,
                      attachments: [...attachments]
                        ..[0] = attachments[0].copyWith(
                          uploadState: const UploadState.success(),
                        )
                        ..[1] = attachments[1].copyWith(
                          uploadState: const UploadState.success(),
                        ),
                    ),
                    matchMessageState: true,
                    matchAttachments: true,
                    matchAttachmentsUploadState: true,
                  ),
                ],
                // all the attachments are successfully uploaded
                [
                  isSameMessageAs(
                    message.copyWith(
                      state: MessageState.sending,
                      attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.success()))],
                    ),
                    matchMessageState: true,
                    matchAttachments: true,
                    matchAttachmentsUploadState: true,
                  ),
                ],
                [
                  isSameMessageAs(
                    message.copyWith(
                      state: MessageState.sent,
                      attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.success()))],
                    ),
                    matchMessageState: true,
                    matchAttachments: true,
                    matchAttachmentsUploadState: true,
                  ),
                ],
              ],
            ),
          );

          final res = await tester.channel.sendMessage(message);

          expect(res, isNotNull);
          expect(res.message.id, message.id);
          expect(res.message.attachments.length, message.attachments.length);
          expect(
            res.message.attachments.every(
              (it) => it.uploadState == const UploadState.success(),
            ),
            isTrue,
          );

          tester
            ..verifyApiCalled(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
              times: 2,
            )
            ..verifyApi(
              (api) => api.fileUploader.sendFile(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
            )
            ..verifyApi(
              (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            );

          await messagesEmission;
        },
      );

      channelTest(
        'should not send if the message is invalid',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(id: 'test-message-id');

          await expectLater(
            () => tester.channel.sendMessage(message),
            throwsA(isA<StreamClientException>()),
          );

          tester.verifyNeverCalled(
            (api) => api.message.sendMessage(_channelId, _channelType, any()),
          );
        },
      );

      channelTest(
        'should not send empty message when all attachments are cancelled',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final attachment = Attachment(
            id: 'test-attachment-id',
            type: 'image',
            file: AttachmentFile(size: 100, path: 'test-file-path'),
          );

          final message = Message(
            id: 'test-message-id',
            attachments: [attachment],
          );

          tester.mockApiFailure(
            (api) => api.fileUploader.sendImage(
              any(),
              _channelId,
              _channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
            error: const StreamNetworkException(message: 'Request cancelled', isCancelled: true),
          );

          await expectLater(
            () => tester.channel.sendMessage(message),
            throwsA(isA<StreamClientException>()),
          );

          tester
            ..verifyApi(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
            )
            ..verifyNeverCalled(
              (api) => api.message.sendMessage(_channelId, _channelType, any()),
            );
        },
      );

      channelTest(
        'should send message when attachment is cancelled but text exists',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final attachment = Attachment(
            id: 'test-attachment-id',
            type: 'image',
            file: AttachmentFile(size: 100, path: 'test-file-path'),
          );

          final message = Message(
            id: 'test-message-id',
            text: 'Hello world!',
            attachments: [attachment],
          );

          tester
            ..mockApiFailure(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
              error: const StreamNetworkException(message: 'Request cancelled', isCancelled: true),
            )
            ..mockApi(
              (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
              result: createDefaultSendMessageResponse(
                message: message.copyWith(
                  attachments: [],
                  state: MessageState.sent,
                ),
              ),
            );

          final res = await tester.channel.sendMessage(message);

          expect(res, isNotNull);
          expect(res.message.text, 'Hello world!');

          tester
            ..verifyApi(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
            )
            ..verifyApi(
              (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            );
        },
      );

      channelTest(
        'should send message when attachment is cancelled but quoted message exists',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final attachment = Attachment(
            id: 'test-attachment-id',
            type: 'image',
            file: AttachmentFile(size: 100, path: 'test-file-path'),
          );

          final quotedMessage = Message(
            id: 'quoted-123',
            text: 'Original message',
          );

          final message = Message(
            id: 'test-message-id',
            attachments: [attachment],
            quotedMessageId: quotedMessage.id,
          );

          tester
            ..mockApiFailure(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
              error: const StreamNetworkException(message: 'Request cancelled', isCancelled: true),
            )
            ..mockApi(
              (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
              result: createDefaultSendMessageResponse(
                message: message.copyWith(
                  attachments: [],
                  state: MessageState.sent,
                ),
              ),
            );

          final res = await tester.channel.sendMessage(message);

          expect(res, isNotNull);
          expect(res.message.quotedMessageId, quotedMessage.id);

          tester
            ..verifyApi(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
            )
            ..verifyApi(
              (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            );
        },
      );

      channelTest(
        'should send message when attachment is cancelled but poll exists',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final attachment = Attachment(
            id: 'test-attachment-id',
            type: 'image',
            file: AttachmentFile(size: 100, path: 'test-file-path'),
          );

          final message = Message(
            id: 'test-message-id',
            attachments: [attachment],
            pollId: 'poll-123',
          );

          tester
            ..mockApiFailure(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
              error: const StreamNetworkException(message: 'Request cancelled', isCancelled: true),
            )
            ..mockApi(
              (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
              result: createDefaultSendMessageResponse(
                message: message.copyWith(
                  attachments: [],
                  state: MessageState.sent,
                ),
              ),
            );

          final res = await tester.channel.sendMessage(message);

          expect(res, isNotNull);
          expect(res.message.pollId, 'poll-123');

          tester
            ..verifyApi(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
            )
            ..verifyApi(
              (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(message))),
            );
        },
      );
    });

    group('`.sendStaticLocation`', () {
      const deviceId = 'test-device-id';
      const locationId = 'test-location-id';
      const coordinates = LocationCoordinate(
        latitude: 40.7128,
        longitude: -74.0060,
      );

      channelTest(
        'should create a static location and call sendMessage',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelLocationApi()),
        body: (tester) async {
          tester.mockApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(Message(id: locationId))),
            ),
            result: createDefaultSendMessageResponse(
              message: Message(
                id: locationId,
                text: 'Location shared',
                extraData: const {'custom': 'data'},
                sharedLocation: Location(
                  channelCid: tester.channel.cid,
                  messageId: locationId,
                  userId: tester.currentUser?.id,
                  latitude: coordinates.latitude,
                  longitude: coordinates.longitude,
                  createdByDeviceId: deviceId,
                ),
              ),
            ),
          );

          final response = await tester.channel.sendStaticLocation(
            id: locationId,
            messageText: 'Location shared',
            createdByDeviceId: deviceId,
            location: coordinates,
            extraData: {'custom': 'data'},
          );

          expect(response, isNotNull);
          expect(response.message.id, locationId);
          expect(response.message.text, 'Location shared');
          expect(response.message.extraData['custom'], 'data');
          expect(response.message.sharedLocation, isNotNull);

          tester.verifyApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(Message(id: locationId))),
            ),
          );
        },
      );
    });

    group('`.startLiveLocationSharing`', () {
      const deviceId = 'test-device-id';
      const locationId = 'test-location-id';
      final endSharingAt = DateTime.timestamp().add(const Duration(hours: 1));
      const coordinates = LocationCoordinate(
        latitude: 40.7128,
        longitude: -74.0060,
      );

      channelTest(
        'should create message with live location and call sendMessage',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelLocationApi()),
        body: (tester) async {
          tester.mockApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(Message(id: locationId))),
            ),
            result: createDefaultSendMessageResponse(
              message: Message(
                id: locationId,
                text: 'Location shared',
                extraData: const {'custom': 'data'},
                sharedLocation: Location(
                  channelCid: tester.channel.cid,
                  messageId: locationId,
                  userId: tester.currentUser?.id,
                  latitude: coordinates.latitude,
                  longitude: coordinates.longitude,
                  createdByDeviceId: deviceId,
                  endAt: endSharingAt,
                ),
              ),
            ),
          );

          final response = await tester.channel.startLiveLocationSharing(
            id: locationId,
            messageText: 'Location shared',
            createdByDeviceId: deviceId,
            location: coordinates,
            endSharingAt: endSharingAt,
            extraData: {'custom': 'data'},
          );

          expect(response, isNotNull);
          expect(response.message.id, locationId);
          expect(response.message.text, 'Location shared');
          expect(response.message.extraData['custom'], 'data');
          expect(response.message.sharedLocation, isNotNull);
          expect(response.message.sharedLocation?.endAt, endSharingAt);

          tester.verifyApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(Message(id: locationId))),
            ),
          );
        },
      );
    });

    group('`.createDraft`', () {
      final draftMessage = DraftMessage(text: 'Draft message text');

      channelTest(
        'should call client.createDraft',
        channelType: _channelType,
        channelId: _channelId,
        setUp: _seedChannelDrafts,
        body: (tester) async {
          tester.mockApi(
            (api) => api.message.createDraft(_channelId, _channelType, draftMessage),
            result: createDefaultCreateDraftResponse(
              draft: createDefaultDraft(channelCid: _channelCid, message: draftMessage),
            ),
          );

          final res = await tester.channel.createDraft(draftMessage);

          expect(res, isNotNull);
          expect(res.draft.message, draftMessage);

          tester.verifyApi(
            (api) => api.message.createDraft(_channelId, _channelType, draftMessage),
          );
        },
      );
    });

    group('`.getDraft`', () {
      final draftMessage = DraftMessage(text: 'Draft message text');

      channelTest(
        'should call client.getDraft',
        channelType: _channelType,
        channelId: _channelId,
        setUp: _seedChannelDrafts,
        body: (tester) async {
          tester.mockApi(
            (api) => api.message.getDraft(_channelId, _channelType),
            result: createDefaultGetDraftResponse(
              draft: createDefaultDraft(channelCid: _channelCid, message: draftMessage),
            ),
          );

          final res = await tester.channel.getDraft();

          expect(res, isNotNull);
          expect(res.draft.message, draftMessage);

          tester.verifyApi(
            (api) => api.message.getDraft(_channelId, _channelType),
          );
        },
      );

      channelTest(
        'with parentId should pass parentId to client',
        channelType: _channelType,
        channelId: _channelId,
        setUp: _seedChannelDrafts,
        body: (tester) async {
          const parentId = 'parent-123';
          tester.mockApi(
            (api) => api.message.getDraft(_channelId, _channelType, parentId: parentId),
            result: createDefaultGetDraftResponse(
              draft: createDefaultDraft(channelCid: _channelCid, message: draftMessage),
            ),
          );

          final res = await tester.channel.getDraft(parentId: parentId);

          expect(res, isNotNull);
          expect(res.draft.message, draftMessage);

          tester.verifyApi(
            (api) => api.message.getDraft(_channelId, _channelType, parentId: parentId),
          );
        },
      );
    });

    group('`.deleteDraft`', () {
      channelTest(
        'should call client.deleteDraft',
        channelType: _channelType,
        channelId: _channelId,
        setUp: _seedChannelDrafts,
        body: (tester) async {
          tester.mockApi(
            (api) => api.message.deleteDraft(_channelId, _channelType),
            result: createDefaultEmptyResponse(),
          );

          final res = await tester.channel.deleteDraft();

          expect(res, isNotNull);

          tester.verifyApi(
            (api) => api.message.deleteDraft(_channelId, _channelType),
          );
        },
      );

      channelTest(
        'with parentId should pass parentId to client',
        channelType: _channelType,
        channelId: _channelId,
        setUp: _seedChannelDrafts,
        body: (tester) async {
          const parentId = 'parent-123';
          tester.mockApi(
            (api) => api.message.deleteDraft(_channelId, _channelType, parentId: parentId),
            result: createDefaultEmptyResponse(),
          );

          final res = await tester.channel.deleteDraft(parentId: parentId);

          expect(res, isNotNull);

          tester.verifyApi(
            (api) => api.message.deleteDraft(_channelId, _channelType, parentId: parentId),
          );
        },
      );
    });

    group('`.createReminder`', () {
      const messageId = 'test-message-id';
      final reminderRemindAt = DateTime.utc(2024, 6, 15, 14, 30);

      channelTest(
        'should call client.createReminder',
        channelType: _channelType,
        channelId: _channelId,
        setUp: _seedChannelReminders,
        body: (tester) async {
          tester.mockApi(
            (api) => api.reminders.createReminder(messageId),
            result: createDefaultCreateReminderResponse(
              reminder: createDefaultMessageReminder(
                messageId: messageId,
                channelCid: _channelCid,
                remindAt: reminderRemindAt,
              ),
            ),
          );

          final res = await tester.channel.createReminder(messageId);

          expect(res, isNotNull);
          expect(res.reminder.messageId, messageId);

          tester.verifyApi(
            (api) => api.reminders.createReminder(messageId),
          );
        },
      );

      channelTest(
        'with remindAt should pass remindAt to client',
        channelType: _channelType,
        channelId: _channelId,
        setUp: _seedChannelReminders,
        body: (tester) async {
          final remindAt = DateTime.utc(2024, 6, 15, 14, 30);
          tester.mockApi(
            (api) => api.reminders.createReminder(messageId, remindAt: remindAt),
            result: createDefaultCreateReminderResponse(
              reminder: createDefaultMessageReminder(
                messageId: messageId,
                channelCid: _channelCid,
                remindAt: reminderRemindAt,
              ),
            ),
          );

          final res = await tester.channel.createReminder(messageId, remindAt: remindAt);

          expect(res, isNotNull);
          expect(res.reminder.messageId, messageId);
          expect(res.reminder.remindAt, remindAt);

          tester.verifyApi(
            (api) => api.reminders.createReminder(messageId, remindAt: remindAt),
          );
        },
      );
    });

    group('`.updateReminder`', () {
      const messageId = 'test-message-id';
      final reminderRemindAt = DateTime.utc(2024, 8, 20, 16, 45);

      channelTest(
        'should call client.updateReminder',
        channelType: _channelType,
        channelId: _channelId,
        setUp: _seedChannelReminders,
        body: (tester) async {
          tester.mockApi(
            (api) => api.reminders.updateReminder(messageId),
            result: createDefaultUpdateReminderResponse(
              reminder: createDefaultMessageReminder(
                messageId: messageId,
                channelCid: _channelCid,
                remindAt: reminderRemindAt,
              ),
            ),
          );

          final res = await tester.channel.updateReminder(messageId);

          expect(res, isNotNull);
          expect(res.reminder.messageId, messageId);

          tester.verifyApi(
            (api) => api.reminders.updateReminder(messageId),
          );
        },
      );

      channelTest(
        'with remindAt should pass remindAt to client',
        channelType: _channelType,
        channelId: _channelId,
        setUp: _seedChannelReminders,
        body: (tester) async {
          final remindAt = DateTime.utc(2024, 8, 20, 16, 45);
          tester.mockApi(
            (api) => api.reminders.updateReminder(messageId, remindAt: remindAt),
            result: createDefaultUpdateReminderResponse(
              reminder: createDefaultMessageReminder(
                messageId: messageId,
                channelCid: _channelCid,
                remindAt: reminderRemindAt,
              ),
            ),
          );

          final res = await tester.channel.updateReminder(messageId, remindAt: remindAt);

          expect(res, isNotNull);
          expect(res.reminder.messageId, messageId);
          expect(res.reminder.remindAt, remindAt);

          tester.verifyApi(
            (api) => api.reminders.updateReminder(messageId, remindAt: remindAt),
          );
        },
      );
    });

    group('`.deleteReminder`', () {
      const messageId = 'test-message-id';

      channelTest(
        'should call client.deleteReminder',
        channelType: _channelType,
        channelId: _channelId,
        setUp: _seedChannelReminders,
        body: (tester) async {
          tester.mockApi(
            (api) => api.reminders.deleteReminder(messageId),
            result: createDefaultEmptyResponse(),
          );

          final res = await tester.channel.deleteReminder(messageId);

          expect(res, isNotNull);

          tester.verifyApi(
            (api) => api.reminders.deleteReminder(messageId),
          );
        },
      );
    });

    group('`.updateMessage`', () {
      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            state: MessageState.sent,
          );

          tester.mockApi(
            (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
            result: createDefaultUpdateMessageResponse(message: message),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updated),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.updateMessage(message);

          expect(res, isNotNull);
          expect(res.message.id, message.id);

          await messagesEmits;

          tester.verifyApi(
            (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
          );
        },
      );

      channelTest(
        'with attachments should work just fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final attachments = List.generate(
            3,
            (index) => Attachment(
              id: 'test-attachment-id-$index',
              type: index.isEven ? 'image' : 'file',
              file: AttachmentFile(size: index * 33, path: 'test-file-path'),
            ),
          );

          final message = Message(
            id: 'test-message-id',
            attachments: attachments,
          );

          tester
            ..mockApi(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
              result: SendImageResponse()..file = 'test-image-url',
            )
            ..mockApi(
              (api) => api.fileUploader.sendFile(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
              result: SendFileResponse()..file = 'test-file-url',
            )
            ..mockApi(
              (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
              result: createDefaultUpdateMessageResponse(
                message: message.copyWith(
                  state: MessageState.sent,
                  attachments: attachments
                      .map((it) => it.copyWith(uploadState: const UploadState.success()))
                      .toList(growable: false),
                ),
              ),
            );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder(
              [
                // preparing attachments to upload
                [
                  isSameMessageAs(
                    message.copyWith(
                      state: MessageState.updating,
                      attachments: [
                        ...attachments.map((it) => it.copyWith(uploadState: const UploadState.preparing())),
                      ],
                    ),
                    matchMessageState: true,
                    matchAttachments: true,
                    matchAttachmentsUploadState: true,
                  ),
                ],
                // 0th attachment is successfully uploaded
                [
                  isSameMessageAs(
                    message.copyWith(
                      state: MessageState.updating,
                      attachments: [...attachments]
                        ..[0] = attachments[0].copyWith(
                          uploadState: const UploadState.success(),
                        ),
                    ),
                    matchMessageState: true,
                    matchAttachments: true,
                    matchAttachmentsUploadState: true,
                  ),
                ],
                // 0th and 1st attachment is successfully uploaded
                [
                  isSameMessageAs(
                    message.copyWith(
                      state: MessageState.updating,
                      attachments: [...attachments]
                        ..[0] = attachments[0].copyWith(
                          uploadState: const UploadState.success(),
                        )
                        ..[1] = attachments[1].copyWith(
                          uploadState: const UploadState.success(),
                        ),
                    ),
                    matchMessageState: true,
                    matchAttachments: true,
                    matchAttachmentsUploadState: true,
                  ),
                ],
                // all the attachments are successfully uploaded
                [
                  isSameMessageAs(
                    message.copyWith(
                      state: MessageState.updating,
                      attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.success()))],
                    ),
                    matchMessageState: true,
                    matchAttachments: true,
                    matchAttachmentsUploadState: true,
                  ),
                ],
                [
                  isSameMessageAs(
                    message.copyWith(
                      state: MessageState.updated,
                      attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.success()))],
                    ),
                    matchMessageState: true,
                    matchAttachments: true,
                    matchAttachmentsUploadState: true,
                  ),
                ],
              ],
            ),
          );

          final res = await tester.channel.updateMessage(message);

          expect(res, isNotNull);
          expect(res.message.id, message.id);
          expect(res.message.attachments.length, message.attachments.length);
          expect(
            res.message.attachments.every(
              (it) => it.uploadState == const UploadState.success(),
            ),
            isTrue,
          );

          await messagesEmits;

          tester
            ..verifyApiCalled(
              (api) => api.fileUploader.sendImage(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
              times: 2,
            )
            ..verifyApi(
              (api) => api.fileUploader.sendFile(
                any(),
                _channelId,
                _channelType,
                onSendProgress: any(named: 'onSendProgress'),
                cancelToken: any(named: 'cancelToken'),
                extraData: any(named: 'extraData'),
              ),
            )
            ..verifyApi(
              (api) => api.message.updateMessage(any(that: isSameMessageAs(message))),
            );
        },
      );

      channelTest(
        'should update message state even when the error is not a StreamChatException',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-error-1',
            state: MessageState.sent,
          );

          tester.mockApiFailure(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
              skipEnrichUrl: true,
            ),
            error: ArgumentError('Invalid argument'),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updatingFailed(
                      skipPush: false,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.updateMessage(message, skipEnrichUrl: true);
          } catch (e) {
            expect(e, isA<ArgumentError>());
          }

          await messagesEmits;
        },
      );

      channelTest(
        'should mark the message failed and report the failure as retriable with skipPush: false, skipEnrichUrl: true',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-retry-1',
            state: MessageState.sent,
          );

          // Create a retriable error (data == null). The retriable failure arms
          // the live retry queue; its immediate retry attempt succeeds, so the
          // queue drains without waiting on backoff timers.
          tester.mockApiFailureOnce(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
              skipEnrichUrl: true,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.requestTimeout, statusCode: 408),
            result: createDefaultUpdateMessageResponse(message: message),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updatingFailed(
                      skipPush: false,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
              // The retry queue retries the queued update with the same flags.
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updated),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.updateMessage(message, skipEnrichUrl: true);
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.requestTimeout));
            expect(networkError.isRetriable, isTrue);
          }

          await messagesEmits;

          // Initial attempt + the retry-queue retry, both with the same flags.
          tester.verifyApiCalled(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
              skipEnrichUrl: true,
            ),
            times: 2,
          );
        },
      );

      channelTest(
        'should mark the message failed and report the failure as retriable with skipPush: true, skipEnrichUrl: false',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-retry-2',
            state: MessageState.sent,
          );

          // Create a retriable error (data == null). The retriable failure arms
          // the live retry queue; its immediate retry attempt succeeds, so the
          // queue drains without waiting on backoff timers.
          tester.mockApiFailureOnce(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
              skipPush: true,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.internalError, statusCode: 500),
            result: createDefaultUpdateMessageResponse(message: message),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updatingFailed(
                      skipPush: true,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
              // The retry queue retries the queued update with the same flags.
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updated),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.updateMessage(message, skipPush: true);
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.internalError));
            expect(networkError.isRetriable, isTrue);
          }

          await messagesEmits;

          // Initial attempt + the retry-queue retry, both with the same flags.
          tester.verifyApiCalled(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
              skipPush: true,
            ),
            times: 2,
          );
        },
      );

      channelTest(
        'should handle a non-retriable failure with skipPush: true, skipEnrichUrl: true',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-error-2',
            state: MessageState.sent,
          );

          tester.mockApiFailure(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.notAllowed, statusCode: 403),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updatingFailed(
                      skipPush: true,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.updateMessage(
              message,
              skipPush: true,
              skipEnrichUrl: true,
            );
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.notAllowed));
          }

          await messagesEmits;
        },
      );

      channelTest(
        'should handle a non-retriable failure with skipPush: false, skipEnrichUrl: false',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-error-3',
            state: MessageState.sent,
          );

          tester.mockApiFailure(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.notAllowed, statusCode: 403),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updatingFailed(
                      skipPush: false,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.updateMessage(message);
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.notAllowed));
          }

          await messagesEmits;
        },
      );
    });

    group('`ChannelClientState.updateMessage`', () {
      channelTest(
        'upsert: true (default) adds an unknown message',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'unknown-message',
            user: tester.currentUser,
            text: 'hello',
            createdAt: DateTime.utc(2026),
          );

          expect(tester.channelState!.messages, isEmpty);

          tester.channelState!.updateMessage(message);

          expect(tester.channelState!.messages.map((m) => m.id), ['unknown-message']);
        },
      );

      channelTest(
        'upsert: false does NOT add an unknown message',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'unknown-message',
            user: tester.currentUser,
            text: 'hello',
            createdAt: DateTime.utc(2026),
          );

          expect(tester.channelState!.messages, isEmpty);

          tester.channelState!.updateMessage(message, upsert: false);

          expect(tester.channelState!.messages, isEmpty);
        },
      );

      channelTest(
        'upsert: false updates a message already in the window',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          const messageId = 'known-message';
          final seeded = Message(
            id: messageId,
            user: tester.currentUser,
            text: 'old',
            createdAt: DateTime.utc(2026),
          );
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(messages: [seeded]),
          );

          tester.channelState!.updateMessage(
            seeded.copyWith(text: 'new'),
            upsert: false,
          );

          final stored = tester.channelState!.messages.single;
          expect(stored.id, equals(messageId));
          expect(stored.text, equals('new'));
        },
      );
    });

    channelTest(
      '`.partialUpdateMessage`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
      body: (tester) async {
        final message = Message(
          id: 'test-message-id',
          state: MessageState.sent,
        );

        const set = {'text': 'Update Message text'};
        const unset = ['pinExpires'];

        final updateMessageResponse = createDefaultUpdateMessageResponse(
          message: message.copyWith(text: set['text'], pinExpires: null),
        );

        tester.mockApi(
          (api) => api.message.partialUpdateMessage(message.id, set: set, unset: unset),
          result: updateMessageResponse,
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updating,
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                updateMessageResponse.message.copyWith(
                  state: MessageState.updated,
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await tester.channel.partialUpdateMessage(
          message,
          set: set,
          unset: unset,
        );

        expect(res, isNotNull);
        expect(res.message.id, message.id);
        expect(res.message.id, message.id);
        expect(res.message.text, set['text']);
        expect(res.message.pinExpires, isNull);

        await messagesEmits;

        tester.verifyApi(
          (api) => api.message.partialUpdateMessage(message.id, set: set, unset: unset),
        );
      },
    );

    group('`.partialUpdateMessage` error handling', () {
      channelTest(
        'should update message state even when the error is not a StreamChatException',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-error-partial-1',
            state: MessageState.sent,
          );

          // Add message to channel state first
          tester.channelState?.updateMessage(message);

          const set = {'text': 'Update Message text'};
          const unset = ['pinExpires'];

          tester.mockApiFailure(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: set,
              unset: unset,
            ),
            error: ArgumentError('Invalid argument'),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.partialUpdatingFailed(
                      set: set,
                      unset: unset,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.partialUpdateMessage(
              message,
              set: set,
              unset: unset,
            );
          } catch (e) {
            expect(e, isA<ArgumentError>());
          }

          await messagesEmits;
        },
      );

      channelTest(
        'should mark the message failed and report the failure as retriable with skipEnrichUrl: true',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-retry-partial-1',
            state: MessageState.sent,
          );

          // Add message to channel state first
          tester.channelState?.updateMessage(message);

          const set = {'text': 'Update Message text'};
          const unset = ['pinExpires'];

          // Create a retriable error (data == null). The retriable failure arms
          // the live retry queue; its immediate retry attempt succeeds, so the
          // queue drains without waiting on backoff timers.
          tester.mockApiFailureOnce(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: set,
              unset: unset,
              skipEnrichUrl: true,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.requestTimeout, statusCode: 408),
            result: createDefaultUpdateMessageResponse(message: message),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.partialUpdatingFailed(
                      set: set,
                      unset: unset,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              // The retry queue retries the queued partial update with the same
              // set/unset and flags.
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updated),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.partialUpdateMessage(
              message,
              set: set,
              unset: unset,
              skipEnrichUrl: true,
            );
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.requestTimeout));
            expect(networkError.isRetriable, isTrue);
          }

          await messagesEmits;

          // Initial attempt + the retry-queue retry, both with the same
          // set/unset and flags.
          tester.verifyApiCalled(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: set,
              unset: unset,
              skipEnrichUrl: true,
            ),
            times: 2,
          );
        },
      );

      channelTest(
        'should mark the message failed and report the failure as retriable with skipEnrichUrl: false',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-retry-partial-2',
            state: MessageState.sent,
          );

          // Add message to channel state first
          tester.channelState?.updateMessage(message);

          const set = {'text': 'Update Message text'};
          const unset = ['pinExpires'];

          // Create a retriable error (data == null). The retriable failure arms
          // the live retry queue; its immediate retry attempt succeeds, so the
          // queue drains without waiting on backoff timers.
          tester.mockApiFailureOnce(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: set,
              unset: unset,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.internalError, statusCode: 500),
            result: createDefaultUpdateMessageResponse(message: message),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.partialUpdatingFailed(
                      set: set,
                      unset: unset,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              // The retry queue retries the queued partial update with the same
              // set/unset and flags.
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updated),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.partialUpdateMessage(
              message,
              set: set,
              unset: unset,
            );
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.internalError));
            expect(networkError.isRetriable, isTrue);
          }

          await messagesEmits;

          // Initial attempt + the retry-queue retry, both with the same
          // set/unset and flags.
          tester.verifyApiCalled(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: set,
              unset: unset,
            ),
            times: 2,
          );
        },
      );

      channelTest(
        'should handle a non-retriable failure with skipEnrichUrl: true',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-error-partial-2',
            state: MessageState.sent,
          );

          // Add message to channel state first
          tester.channelState?.updateMessage(message);

          const set = {'text': 'Update Message text'};
          const unset = ['pinExpires'];

          tester.mockApiFailure(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: set,
              unset: unset,
              skipEnrichUrl: true,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.notAllowed, statusCode: 403),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.partialUpdatingFailed(
                      set: set,
                      unset: unset,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.partialUpdateMessage(
              message,
              set: set,
              unset: unset,
              skipEnrichUrl: true,
            );
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.notAllowed));
          }

          await messagesEmits;
        },
      );

      channelTest(
        'should handle a non-retriable failure with skipEnrichUrl: false',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelUpdateMessage()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id-error-partial-3',
            state: MessageState.sent,
          );

          // Add message to channel state first
          tester.channelState?.updateMessage(message);

          const set = {'text': 'Update Message text'};
          const unset = ['pinExpires'];

          tester.mockApiFailure(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: set,
              unset: unset,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.notAllowed, statusCode: 403),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.partialUpdatingFailed(
                      set: set,
                      unset: unset,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.partialUpdateMessage(
              message,
              set: set,
              unset: unset,
            );
          } catch (e) {
            expect(e, isA<StreamApiException>());

            final networkError = e as StreamApiException;
            expect(networkError.code, equals(StreamErrorCode.notAllowed));
          }

          await messagesEmits;
        },
      );
    });

    group('`.deleteMessage`', () {
      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelDeleteMessage()),
        body: (tester) async {
          const messageId = 'test-message-id';
          final message = Message(
            id: messageId,
            createdAt: DateTime.utc(2021, 3),
            state: MessageState.sent,
          );

          tester.mockApi(
            (api) => api.message.deleteMessage(messageId, hard: false),
            result: createDefaultEmptyResponse(),
          );

          // A soft delete only updates a message already in the loaded window,
          // so seed it first — a delete must never insert a phantom record.
          tester.channelState?.addNewMessage(message);

          final messagesEmits = expectLater(
            // skip the seeded message -> [message]
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.softDeleting),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.softDeleted),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.deleteMessage(message);

          expect(res, isNotNull);

          await messagesEmits;

          tester.verifyApi(
            (api) => api.message.deleteMessage(messageId, hard: false),
          );
        },
      );

      channelTest(
        'should delete attachments for hard delete',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelDeleteMessage()),
        body: (tester) async {
          final attachments = List.generate(
            3,
            (index) => Attachment(
              id: 'test-attachment-id-$index',
              type: index.isEven ? 'image' : 'file',
              file: AttachmentFile(size: index * 33, path: 'test-file-path'),
              imageUrl: index.isEven ? 'test-image-url-$index' : null,
              assetUrl: index.isOdd ? 'test-asset-url-$index' : null,
              uploadState: const UploadState.success(),
            ),
          );

          const messageId = 'test-message-id';
          final message = Message(
            id: messageId,
            attachments: attachments,
            createdAt: DateTime.utc(2021, 3),
            state: MessageState.sent,
          );

          tester
            ..mockApi(
              (api) => api.message.deleteMessage(messageId, hard: true),
              result: createDefaultEmptyResponse(),
            )
            ..mockApi(
              (api) => api.fileUploader.deleteImage(any(), _channelId, _channelType),
              result: createDefaultEmptyResponse(),
            )
            ..mockApi(
              (api) => api.fileUploader.deleteFile(any(), _channelId, _channelType),
              result: createDefaultEmptyResponse(),
            );

          final res = await tester.channel.deleteMessage(message, hard: true);
          expect(res, isNotNull);

          tester
            ..verifyApi(
              (api) => api.message.deleteMessage(messageId, hard: true),
            )
            ..verifyApiCalled(
              (api) => api.fileUploader.deleteImage(any(), _channelId, _channelType),
              times: 2,
            )
            ..verifyApi(
              (api) => api.fileUploader.deleteFile(any(), _channelId, _channelType),
            );
        },
      );

      channelTest(
        'should hard delete the message if the state is sending or failed',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelDeleteMessage()),
        body: (tester) async {
          const messageId = 'test-message-id';
          final message = Message(
            id: messageId,
            text: 'Hello World!',
            state: MessageState.sending,
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              const [], // message is hard deleted from state
            ]),
          );

          // Add message to channel state first
          tester.channelState?.addNewMessage(message);

          final res = await tester.channel.deleteMessage(message);

          expect(res, isNotNull);

          await messagesEmits;

          tester.verifyNeverCalled(
            (api) => api.message.deleteMessage(messageId, hard: false),
          );
        },
      );
    });

    group('`.deleteMessageForMe`', () {
      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelDeleteMessage()),
        body: (tester) async {
          const messageId = 'test-message-id';
          final message = Message(
            id: messageId,
            createdAt: DateTime.utc(2021, 3),
            state: MessageState.sent,
          );

          tester.mockApi(
            (api) => api.message.deleteMessage(messageId, deleteForMe: true),
            result: createDefaultEmptyResponse(),
          );

          // A soft delete only updates a message already in the loaded window,
          // so seed it first — a delete must never insert a phantom record.
          tester.channelState?.addNewMessage(message);

          final messagesEmits = expectLater(
            // skip the seeded message -> [message]
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.deletingForMe),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.deletedForMe),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.deleteMessageForMe(message);

          expect(res, isNotNull);

          await messagesEmits;

          tester.verifyApi(
            (api) => api.message.deleteMessage(messageId, deleteForMe: true),
          );
        },
      );

      channelTest(
        'should hard delete the message if the state is sending or failed',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelDeleteMessage()),
        body: (tester) async {
          const messageId = 'test-message-id';
          final message = Message(
            id: messageId,
            text: 'Hello World!',
            state: MessageState.sending,
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              const [], // message is hard deleted from state
            ]),
          );

          // Add message to channel state first
          tester.channelState?.addNewMessage(message);

          final res = await tester.channel.deleteMessageForMe(message);

          expect(res, isNotNull);

          await messagesEmits;

          tester.verifyNeverCalled(
            (api) => api.message.deleteMessage(messageId, deleteForMe: true),
          );
        },
      );
    });

    group('`.pinMessage`', () {
      channelTest(
        'should work fine without passing timeoutOrExpirationDate',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelPinMessage()),
        body: (tester) async {
          final message = Message(id: 'test-message-id');

          tester.mockApi(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: {'pinned': true, 'pin_expires': null},
            ),
            result: createDefaultUpdateMessageResponse(
              message: message.copyWith(
                pinned: true,
                pinExpires: null,
              ),
            ),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updated),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.pinMessage(message);

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNull);

          await messagesEmits;

          tester.verifyApi(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: {'pinned': true, 'pin_expires': null},
            ),
          );
        },
      );

      channelTest(
        'should work fine if passed timeoutOrExpirationDate as num(seconds)',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelPinMessage()),
        body: (tester) async {
          final message = Message(id: 'test-message-id');
          const timeoutOrExpirationDate = 300; // 300 seconds

          // The channel computes `pin_expires` from the current time, so the
          // stub cannot match the exact `set` map.
          tester.mockApi(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
            ),
            result: createDefaultUpdateMessageResponse(
              message: message.copyWith(
                pinned: true,
                pinExpires: DateTime.utc(2021, 3).add(
                  const Duration(seconds: timeoutOrExpirationDate),
                ),
              ),
            ),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updated),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.pinMessage(
            message,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);

          await messagesEmits;

          tester.verifyApi(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
            ),
          );
        },
      );

      channelTest(
        'should work fine if passed timeoutOrExpirationDate as DateTime',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelPinMessage()),
        body: (tester) async {
          final message = Message(id: 'test-message-id');
          final timeoutOrExpirationDate = DateTime.utc(2021, 3).add(const Duration(days: 3)); // 3 days

          tester.mockApi(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: {
                'pinned': true,
                'pin_expires': timeoutOrExpirationDate.toUtc().toIso8601String(),
              },
            ),
            result: createDefaultUpdateMessageResponse(
              message: message.copyWith(
                pinned: true,
                pinExpires: timeoutOrExpirationDate,
              ),
            ),
          );

          final messagesEmits = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updated),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.pinMessage(
            message,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);
          expect(res.message.pinExpires, timeoutOrExpirationDate.toUtc());

          await messagesEmits;

          tester.verifyApi(
            (api) => api.message.partialUpdateMessage(
              message.id,
              set: {
                'pinned': true,
                'pin_expires': timeoutOrExpirationDate.toUtc().toIso8601String(),
              },
            ),
          );
        },
      );

      chatClientTest(
        'should throw if invalid timeoutOrExpirationDate is passed',
        body: (tester) async {
          const messageId = 'test-message-id';
          const timeoutOrExpirationDate = 'invalid-value';

          try {
            await tester.client.pinMessage(
              messageId,
              timeoutOrExpirationDate: timeoutOrExpirationDate,
            );
          } catch (e) {
            expect(e, isA<ArgumentError>());
          }
        },
      );
    });

    channelTest(
      '`.unpinMessage`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelPinMessage()),
      body: (tester) async {
        final message = Message(id: 'test-message-id', pinned: true);

        tester.mockApi(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: {'pinned': false},
          ),
          result: createDefaultUpdateMessageResponse(
            message: message.copyWith(pinned: false),
          ),
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await tester.channel.unpinMessage(message);

        expect(res, isNotNull);
        expect(res.message.pinned, isFalse);

        await messagesEmits;

        tester.verifyApi(
          (api) => api.message.partialUpdateMessage(
            message.id,
            set: {'pinned': false},
          ),
        );
      },
    );

    group('`.search`', () {
      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: const [ChannelCapability.readEvents],
          ),
        );
      }

      // The channel builds this filter itself, and a filter compares by
      // identity, so the stubs below match on what it sends.
      final filter = ChannelFilter.in_(ChannelFilterField.cid, const [_channelCid]);

      channelTest(
        'should work fine with `query`',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const query = 'test-search-query';
          final sort = [MessageSearchSort.asc(MessageSearchSortField.custom('test-sort-field'))];
          const pagination = PaginationParams();

          final results = List.generate(3, (index) => createDefaultGetMessageResponse());

          tester.mockApi(
            (api) => api.general.searchMessages(
              any(that: isSameFilterAs(filter)),
              query: query,
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
            result: createDefaultSearchMessagesResponse(results: results),
          );

          final res = await tester.channel.search(
            query: query,
            sort: sort,
            paginationParams: pagination,
          );

          expect(res, isNotNull);
          expect(res.results.length, results.length);

          tester.verifyApi(
            (api) => api.general.searchMessages(
              any(that: isSameFilterAs(filter)),
              query: query,
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          );
        },
      );

      channelTest(
        'should work fine with `messageFilters`',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final messageFilters = MessageSearchFilter.query(MessageSearchFilterField.text, 'text');
          final sort = [MessageSearchSort.desc(MessageSearchSortField.custom('test-sort-field'))];
          const pagination = PaginationParams();

          final results = List.generate(3, (index) => createDefaultGetMessageResponse());

          tester.mockApi(
            (api) => api.general.searchMessages(
              any(that: isSameFilterAs(filter)),
              messageFilters: messageFilters,
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
            result: createDefaultSearchMessagesResponse(results: results),
          );

          final res = await tester.channel.search(
            sort: sort,
            paginationParams: pagination,
            messageFilters: messageFilters,
          );

          expect(res, isNotNull);
          expect(res.results.length, results.length);

          tester.verifyApi(
            (api) => api.general.searchMessages(
              any(that: isSameFilterAs(filter)),
              messageFilters: messageFilters,
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          );
        },
      );
    });

    channelTest(
      '`.deleteFile`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelMiscOperations()),
      body: (tester) async {
        const url = 'test-file-url';

        tester.mockApi(
          (api) => api.fileUploader.deleteFile(url, _channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.deleteFile(url);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.fileUploader.deleteFile(url, _channelId, _channelType),
        );
      },
    );

    channelTest(
      '`.deleteImage`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelMiscOperations()),
      body: (tester) async {
        const url = 'test-image-url';

        tester.mockApi(
          (api) => api.fileUploader.deleteImage(url, _channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.deleteImage(url);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.fileUploader.deleteImage(url, _channelId, _channelType),
        );
      },
    );

    channelTest(
      '`.stopAIResponse`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelMiscOperations()),
      body: (tester) async {
        final stopAIEvent = Event(type: EventType.aiIndicatorStop);

        tester.mockApi(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(stopAIEvent)),
          ),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.stopAIResponse();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(stopAIEvent)),
          ),
        );
      },
    );

    channelTest(
      '`.sendEvent`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelMiscOperations()),
      body: (tester) async {
        final event = Event(type: 'event.local');

        // Pinned by value, not by matcher: `sendEvent` forwards the caller's
        // event untouched, so the stub only answering on the exact instance is
        // itself the assertion that nothing rewrote it on the way out.
        tester.mockApi(
          (api) => api.channel.sendEvent(_channelId, _channelType, event),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.sendEvent(event);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.sendEvent(_channelId, _channelType, event),
        );
      },
    );

    group('`.sendReaction`', () {
      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelReactions()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            state: MessageState.sent,
          );

          const type = 'like';
          const emojiCode = '👍';
          const score = 4;

          final reaction = Reaction(
            type: type,
            messageId: message.id,
            emojiCode: emojiCode,
            score: score,
            user: tester.currentUser,
          );

          tester.mockApi(
            (api) => api.message.sendReaction(message.id, reaction),
            result: createDefaultSendReactionResponse(message: message, reaction: reaction),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    reactionGroups: {type: ReactionGroup(count: 1, sumScores: 1)},
                    latestReactions: [reaction],
                    ownReactions: [reaction],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.sendReaction(message, reaction);

          expect(res, isNotNull);
          expect(res.reaction.type, type);
          expect(res.reaction.messageId, message.id);
          expect(res.reaction.emojiCode, emojiCode);
          expect(res.reaction.score, score);

          tester.verifyApi((api) => api.message.sendReaction(message.id, reaction));

          await messagesEmission;
        },
      );

      channelTest(
        'should restore previous message if `client.sendReaction` throws',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelReactions()),
        body: (tester) async {
          const type = 'test-reaction-type';
          final message = Message(
            id: 'test-message-id',
            state: MessageState.sent,
          );

          final reaction = Reaction(
            type: type,
            messageId: message.id,
            user: tester.currentUser,
          );

          tester.mockApiFailure(
            (api) => api.message.sendReaction(message.id, reaction),
            error: createDefaultNetworkError(code: StreamErrorCode.inputError, statusCode: 400),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    reactionGroups: {
                      type: ReactionGroup(
                        count: 1,
                        sumScores: 1,
                      ),
                    },
                    latestReactions: [reaction],
                    ownReactions: [reaction],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message,
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.sendReaction(message, reaction);
          } catch (e) {
            expect(e, isA<StreamApiException>());
          }

          tester.verifyApi((api) => api.message.sendReaction(message.id, reaction));

          await messagesEmission;
        },
      );

      channelTest(
        '''should override previous reaction if present and `enforceUnique` is true''',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelReactions()),
        body: (tester) async {
          const messageId = 'test-message-id';
          const prevType = 'test-reaction-type';
          final prevReaction = Reaction(
            type: prevType,
            messageId: messageId,
            user: tester.currentUser,
          );
          final message = Message(
            id: messageId,
            ownReactions: [prevReaction],
            latestReactions: [prevReaction],
            reactionGroups: {
              prevType: ReactionGroup(
                count: 1,
                sumScores: 1,
              ),
            },
            state: MessageState.sent,
          );

          const type = 'test-reaction-type-2';
          final newReaction = Reaction(
            type: type,
            messageId: messageId,
            user: tester.currentUser,
          );
          final newMessage = message.copyWith(
            ownReactions: [newReaction],
            latestReactions: [newReaction],
          );

          const enforceUnique = true;

          tester.mockApi(
            (api) => api.message.sendReaction(
              messageId,
              newReaction,
              enforceUnique: enforceUnique,
            ),
            result: createDefaultSendReactionResponse(message: newMessage, reaction: newReaction),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  newMessage,
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.sendReaction(
            message,
            newReaction,
            enforceUnique: enforceUnique,
          );

          expect(res, isNotNull);
          expect(res.reaction.type, type);
          expect(res.reaction.messageId, messageId);

          tester.verifyApi(
            (api) => api.message.sendReaction(
              messageId,
              newReaction,
              enforceUnique: enforceUnique,
            ),
          );

          await messagesEmission;
        },
      );
    });

    group('`.sendReaction in thread`', () {
      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelReactions()),
        body: (tester) async {
          const type = 'test-reaction-type';
          final message = Message(
            id: 'test-message-id',
            parentId: 'test-parent-id', // is thread message
            state: MessageState.sent,
          );

          final reaction = Reaction(
            type: type,
            messageId: message.id,
            user: tester.currentUser,
          );

          tester.mockApi(
            (api) => api.message.sendReaction(message.id, reaction),
            result: createDefaultSendReactionResponse(message: message, reaction: reaction),
          );

          final threadsEmission = expectLater(
            tester.channelState?.threadsStream
                // skipping first seed message list -> [] messages
                .skip(1)
                .map((event) => event['test-parent-id']),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    reactionGroups: {
                      type: ReactionGroup(
                        count: 1,
                        sumScores: 1,
                      ),
                    },
                    latestReactions: [reaction],
                    ownReactions: [reaction],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.sendReaction(message, reaction);

          expect(res, isNotNull);
          expect(res.reaction.type, type);
          expect(res.reaction.messageId, message.id);

          tester.verifyApi((api) => api.message.sendReaction(message.id, reaction));

          await threadsEmission;
        },
      );

      channelTest(
        '''should restore previous thread message if `client.sendReaction` throws''',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelReactions()),
        body: (tester) async {
          const type = 'test-reaction-type';
          final message = Message(
            id: 'test-message-id',
            parentId: 'test-parent-id', // is thread message
            state: MessageState.sent,
            // `Message.createdAt` falls back to `DateTime.now()` per call
            // when not provided, which breaks merge/sort keyed on createdAt.
            createdAt: DateTime.utc(2021, 3),
          );

          final reaction = Reaction(
            type: type,
            messageId: message.id,
            user: tester.currentUser,
          );

          tester.mockApiFailure(
            (api) => api.message.sendReaction(message.id, reaction),
            error: createDefaultNetworkError(code: StreamErrorCode.inputError, statusCode: 400),
          );

          final threadsEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.threadsStream.skip(1).map((event) => event['test-parent-id']),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    reactionGroups: {
                      type: ReactionGroup(
                        count: 1,
                        sumScores: 1,
                      ),
                    },
                    latestReactions: [reaction],
                    ownReactions: [reaction],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
              [
                isSameMessageAs(
                  message,
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.sendReaction(message, reaction);
          } catch (e) {
            expect(e, isA<StreamApiException>());
          }

          tester.verifyApi((api) => api.message.sendReaction(message.id, reaction));

          await threadsEmission;
        },
      );

      channelTest(
        '''should override previous thread reaction if present and `enforceUnique` is true''',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelReactions()),
        body: (tester) async {
          const messageId = 'test-message-id';
          const parentId = 'test-parent-id';
          const prevType = 'test-reaction-type';
          final prevReaction = Reaction(
            type: prevType,
            messageId: messageId,
            user: tester.currentUser,
          );
          final message = Message(
            id: messageId,
            parentId: parentId,
            ownReactions: [prevReaction],
            latestReactions: [prevReaction],
            reactionGroups: {
              prevType: ReactionGroup(
                count: 1,
                sumScores: 1,
              ),
            },
            state: MessageState.sent,
          );

          const type = 'test-reaction-type-2';
          final newReaction = Reaction(
            type: type,
            messageId: messageId,
            user: tester.currentUser,
          );
          final newMessage = message.copyWith(
            ownReactions: [newReaction],
            latestReactions: [newReaction],
          );

          const enforceUnique = true;

          tester.mockApi(
            (api) => api.message.sendReaction(
              messageId,
              newReaction,
              enforceUnique: enforceUnique,
            ),
            result: createDefaultSendReactionResponse(message: newMessage, reaction: newReaction),
          );

          final threadsEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.threadsStream.skip(1).map((event) => event['test-parent-id']),
            emitsInOrder([
              [
                isSameMessageAs(
                  newMessage.copyWith(state: MessageState.sent),
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.sendReaction(
            message,
            newReaction,
            enforceUnique: enforceUnique,
          );

          expect(res, isNotNull);
          expect(res.reaction.type, type);
          expect(res.reaction.messageId, messageId);

          tester.verifyApi(
            (api) => api.message.sendReaction(
              messageId,
              newReaction,
              enforceUnique: enforceUnique,
            ),
          );

          await threadsEmission;
        },
      );
    });

    group('`.deleteReaction`', () {
      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelReactions()),
        body: (tester) async {
          const userId = 'test-user-id';
          const messageId = 'test-message-id';
          const type = 'test-reaction-type';
          final reaction = Reaction(
            type: type,
            messageId: messageId,
            userId: userId,
          );
          final message = Message(
            id: messageId,
            ownReactions: [reaction],
            latestReactions: [reaction],
            reactionGroups: {
              type: ReactionGroup(
                count: 1,
                sumScores: 1,
              ),
            },
            state: MessageState.sent,
          );

          tester.mockApi(
            (api) => api.message.deleteReaction(messageId, type),
            result: createDefaultEmptyResponse(),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    latestReactions: [],
                    ownReactions: [],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.deleteReaction(message, reaction);

          expect(res, isNotNull);

          tester.verifyApi((api) => api.message.deleteReaction(messageId, type));

          await messagesEmission;
        },
      );

      channelTest(
        'should restore prev message state if `client.deleteReaction` throws',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelReactions()),
        body: (tester) async {
          const userId = 'test-user-id';
          const messageId = 'test-message-id';
          const type = 'test-reaction-type';
          final reaction = Reaction(
            type: type,
            messageId: messageId,
            userId: userId,
          );
          final message = Message(
            id: messageId,
            ownReactions: [reaction],
            latestReactions: [reaction],
            reactionGroups: {
              type: ReactionGroup(
                count: 1,
                sumScores: 1,
              ),
            },
            state: MessageState.sent,
          );

          tester.mockApiFailure(
            (api) => api.message.deleteReaction(messageId, type),
            error: createDefaultNetworkError(code: StreamErrorCode.inputError, statusCode: 400),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    latestReactions: [],
                    ownReactions: [],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message,
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.deleteReaction(message, reaction);
          } catch (e) {
            expect(e, isA<StreamApiException>());
          }

          tester.verifyApi((api) => api.message.deleteReaction(messageId, type));

          await messagesEmission;
        },
      );
    });

    group('`.deleteReaction in thread`', () {
      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelReactions()),
        body: (tester) async {
          const userId = 'test-user-id';
          const messageId = 'test-message-id';
          const parentId = 'test-parent-id';
          const type = 'test-reaction-type';
          final reaction = Reaction(
            type: type,
            messageId: messageId,
            userId: userId,
          );
          final message = Message(
            id: messageId,
            parentId: parentId,
            // is thread
            ownReactions: [reaction],
            latestReactions: [reaction],
            reactionGroups: {
              type: ReactionGroup(
                count: 1,
                sumScores: 1,
              ),
            },
            state: MessageState.sent,
            // `Message.createdAt` falls back to `DateTime.now()` per call when
            // not provided, which breaks merge/sort keyed on createdAt.
            createdAt: DateTime.utc(2021, 3),
          );

          tester.mockApi(
            (api) => api.message.deleteReaction(messageId, type),
            result: createDefaultEmptyResponse(),
          );

          final threadsEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.threadsStream.skip(1).map((event) => event['test-parent-id']),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    latestReactions: [],
                    ownReactions: [],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.deleteReaction(message, reaction);

          expect(res, isNotNull);

          tester.verifyApi((api) => api.message.deleteReaction(messageId, type));

          await threadsEmission;
        },
      );

      channelTest(
        'should restore prev message state if `client.deleteReaction` throws',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelReactions()),
        body: (tester) async {
          const userId = 'test-user-id';
          const messageId = 'test-message-id';
          const parentId = 'test-parent-id';
          const type = 'test-reaction-type';
          final reaction = Reaction(
            type: type,
            messageId: messageId,
            userId: userId,
          );
          final message = Message(
            id: messageId,
            parentId: parentId,
            ownReactions: [reaction],
            latestReactions: [reaction],
            reactionGroups: {
              type: ReactionGroup(
                count: 1,
                sumScores: 1,
              ),
            },
            state: MessageState.sent,
            // `Message.createdAt` falls back to `DateTime.now()` per call
            // when not provided, which breaks merge/sort keyed on createdAt.
            createdAt: DateTime.utc(2021, 3),
          );

          tester.mockApiFailure(
            (api) => api.message.deleteReaction(messageId, type),
            error: createDefaultNetworkError(code: StreamErrorCode.inputError, statusCode: 400),
          );

          final threadsEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.threadsStream.skip(1).map((event) => event['test-parent-id']),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    latestReactions: [],
                    ownReactions: [],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
              [
                isSameMessageAs(
                  message,
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
            ]),
          );

          try {
            await tester.channel.deleteReaction(message, reaction);
          } catch (e) {
            expect(e, isA<StreamApiException>());
          }

          tester.verifyApi((api) => api.message.deleteReaction(messageId, type));

          await threadsEmission;
        },
      );
    });

    channelTest(
      '`.update`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelUpdateApi,
      body: (tester) async {
        const channelData = {
          'name': 'Stream Team',
          'profile_image': 'test-profile-image',
        };
        final updateMessage = Message(
          id: 'test-message-id',
          text: 'updated channel',
        );

        final channelModel = createDefaultChannelModel(
          cid: _channelCid,
          extraData: channelData,
        );

        tester.mockApi(
          (api) => api.channel.updateChannel(_channelId, _channelType, channelData, message: updateMessage),
          result: UpdateChannelResponse()
            ..channel = channelModel
            ..message = updateMessage,
        );

        final res = await tester.channel.update(
          channelData,
          updateMessage: updateMessage,
        );

        expect(res, isNotNull);
        expect(res.channel.cid, channelModel.cid);
        expect(res.channel.extraData, channelData);
        expect(res.message?.id, updateMessage.id);

        tester.verifyApi(
          (api) => api.channel.updateChannel(_channelId, _channelType, channelData, message: updateMessage),
        );
      },
    );

    channelTest(
      '`.updateImage`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelUpdateApi,
      body: (tester) async {
        const image = 'https://getstream.io/new-image';

        final channelModel = createDefaultChannelModel(
          cid: _channelCid,
          extraData: {'image': image},
        );

        tester.mockApi(
          (api) => api.channel.updateChannelPartial(
            _channelId,
            _channelType,
            set: {'image': image},
          ),
          result: createDefaultPartialUpdateChannelResponse(channel: channelModel),
        );

        final res = await tester.channel.updateImage(image);

        expect(res, isNotNull);
        expect(res.channel.extraData['image'], image);

        tester.verifyApi(
          (api) => api.channel.updateChannelPartial(
            _channelId,
            _channelType,
            set: {'image': image},
          ),
        );
      },
    );

    channelTest(
      '`.updateName`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelUpdateApi,
      body: (tester) async {
        const name = 'Name';

        final channelModel = createDefaultChannelModel(
          cid: _channelCid,
          extraData: {'name': name},
        );

        tester.mockApi(
          (api) => api.channel.updateChannelPartial(
            _channelId,
            _channelType,
            set: {'name': name},
          ),
          result: createDefaultPartialUpdateChannelResponse(channel: channelModel),
        );

        final res = await tester.channel.updateName(name);

        expect(res, isNotNull);
        expect(res.channel.extraData['name'], name);

        tester.verifyApi(
          (api) => api.channel.updateChannelPartial(
            _channelId,
            _channelType,
            set: {'name': name},
          ),
        );
      },
    );

    channelTest(
      '`.updatePartial`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelUpdateApi,
      body: (tester) async {
        const set = {
          'name': 'Stream Team',
          'profile_image': 'test-profile-image',
        };

        const unset = ['tag', 'last_name'];

        final channelModel = createDefaultChannelModel(
          cid: _channelCid,
          extraData: {
            'coolness': 999,
            ...set,
          },
        );

        tester.mockApi(
          (api) => api.channel.updateChannelPartial(
            _channelId,
            _channelType,
            set: set,
            unset: unset,
          ),
          result: createDefaultPartialUpdateChannelResponse(channel: channelModel),
        );

        final res = await tester.channel.updatePartial(set: set, unset: unset);

        expect(res, isNotNull);
        expect(res.channel.cid, channelModel.cid);
        expect(
          res.channel.extraData,
          {'coolness': 999, ...set},
        );

        tester.verifyApi(
          (api) => api.channel.updateChannelPartial(
            _channelId,
            _channelType,
            set: set,
            unset: unset,
          ),
        );
      },
    );

    channelTest(
      '`.delete`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelUpdateApi,
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.deleteChannel(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.delete();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.deleteChannel(_channelId, _channelType),
        );
      },
    );

    channelTest(
      '`.truncate`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelUpdateApi,
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.truncateChannel(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.truncate();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.truncateChannel(_channelId, _channelType),
        );
      },
    );

    channelTest(
      '`.acceptInvite`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelMemberApi,
      body: (tester) async {
        final message = Message(id: 'test-message-id', text: 'Invite Accepted');

        final channelModel = createDefaultChannelModel(cid: _channelCid);

        tester.mockApi(
          (api) => api.channel.acceptChannelInvite(_channelId, _channelType, message: message),
          result: AcceptInviteResponse()
            ..channel = channelModel
            ..message = message,
        );

        final res = await tester.channel.acceptInvite(message);

        expect(res, isNotNull);
        expect(res.channel.cid, channelModel.cid);
        expect(res.message?.id, message.id);

        tester.verifyApi(
          (api) => api.channel.acceptChannelInvite(_channelId, _channelType, message: message),
        );
      },
    );

    channelTest(
      '`.rejectInvite`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelMemberApi,
      body: (tester) async {
        final message = Message(id: 'test-message-id', text: 'Invite Rejected');

        final channelModel = createDefaultChannelModel(cid: _channelCid);

        tester.mockApi(
          (api) => api.channel.rejectChannelInvite(_channelId, _channelType, message: message),
          result: RejectInviteResponse()
            ..channel = channelModel
            ..message = message,
        );

        final res = await tester.channel.rejectInvite(message);

        expect(res, isNotNull);
        expect(res.channel.cid, channelModel.cid);
        expect(res.message?.id, message.id);

        tester.verifyApi(
          (api) => api.channel.rejectChannelInvite(_channelId, _channelType, message: message),
        );
      },
    );

    channelTest(
      '`.addMembers`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelMemberApi,
      body: (tester) async {
        final members = List.generate(
          3,
          (index) => Member(userId: 'test-member-id-$index'),
        );
        final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
        final message = Message(id: 'test-message-id', text: 'Members Added');

        final channelModel = createDefaultChannelModel(cid: _channelCid);

        tester.mockApi(
          (api) => api.channel.addMembers(_channelId, _channelType, memberIds, message: message),
          result: createDefaultAddMembersResponse(
            channel: channelModel,
            members: members,
            message: message,
          ),
        );

        final res = await tester.channel.addMembers(memberIds, message: message);

        expect(res, isNotNull);
        expect(res.channel.cid, channelModel.cid);
        expect(res.members.length, members.length);
        expect(res.message?.id, message.id);

        tester.verifyApi(
          (api) => api.channel.addMembers(_channelId, _channelType, memberIds, message: message),
        );
      },
    );

    channelTest(
      '`.addMembers` with hideHistoryBefore',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelMemberApi,
      body: (tester) async {
        final members = List.generate(
          3,
          (index) => Member(userId: 'test-member-id-$index'),
        );
        final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
        final message = Message(id: 'test-message-id', text: 'Members Added');
        final hideHistoryBefore = DateTime.parse('2024-01-01T00:00:00Z');

        final channelModel = createDefaultChannelModel(cid: _channelCid);

        tester.mockApi(
          (api) => api.channel.addMembers(
            _channelId,
            _channelType,
            memberIds,
            message: message,
            hideHistoryBefore: hideHistoryBefore,
          ),
          result: createDefaultAddMembersResponse(
            channel: channelModel,
            members: members,
            message: message,
          ),
        );

        final res = await tester.channel.addMembers(
          memberIds,
          message: message,
          hideHistoryBefore: hideHistoryBefore,
        );

        expect(res, isNotNull);
        expect(res.channel.cid, channelModel.cid);
        expect(res.members.length, members.length);
        expect(res.message?.id, message.id);

        tester.verifyApi(
          (api) => api.channel.addMembers(
            _channelId,
            _channelType,
            memberIds,
            message: message,
            hideHistoryBefore: hideHistoryBefore,
          ),
        );
      },
    );

    channelTest(
      '`.inviteMembers`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelMemberApi,
      body: (tester) async {
        final members = List.generate(
          3,
          (index) => Member(userId: 'test-member-id-$index'),
        );
        final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
        final message = Message(id: 'test-message-id', text: 'Members Invited');

        final channelModel = createDefaultChannelModel(cid: _channelCid);

        tester.mockApi(
          (api) => api.channel.inviteChannelMembers(_channelId, _channelType, memberIds, message: message),
          result: InviteMembersResponse()
            ..channel = channelModel
            ..members = members
            ..message = message,
        );

        final res = await tester.channel.inviteMembers(memberIds, message: message);

        expect(res, isNotNull);
        expect(res.channel.cid, channelModel.cid);
        expect(res.members.length, members.length);
        expect(res.message?.id, message.id);

        tester.verifyApi(
          (api) => api.channel.inviteChannelMembers(_channelId, _channelType, memberIds, message: message),
        );
      },
    );

    channelTest(
      '`.removeMembers`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannelMemberApi,
      body: (tester) async {
        final members = List.generate(
          3,
          (index) => Member(userId: 'test-member-id-$index'),
        );
        final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
        final message = Message(id: 'test-message-id', text: 'Members Removed');

        final channelModel = createDefaultChannelModel(cid: _channelCid);

        tester.mockApi(
          (api) => api.channel.removeMembers(_channelId, _channelType, memberIds, message: message),
          result: RemoveMembersResponse()
            ..channel = channelModel
            ..members = members
            ..message = message,
        );

        final res = await tester.channel.removeMembers(memberIds, message: message);

        expect(res, isNotNull);
        expect(res.channel.cid, channelModel.cid);
        expect(res.members.length, members.length);
        expect(res.message?.id, message.id);

        tester.verifyApi(
          (api) => api.channel.removeMembers(_channelId, _channelType, memberIds, message: message),
        );
      },
    );

    group('`.sendAction`', () {
      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: const [ChannelCapability.readEvents],
          ),
        );
      }

      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(id: 'test-message-id', text: 'Action Sent');
          const formData = {'key': 'value'};

          tester.mockApi(
            (api) => api.message.sendAction(_channelId, _channelType, message.id, formData),
            result: createDefaultSendActionResponse(),
          );

          final res = await tester.channel.sendAction(message, formData);

          expect(res, isNotNull);

          tester.verifyApi(
            (api) => api.message.sendAction(_channelId, _channelType, message.id, formData),
          );
        },
      );

      channelTest(
        'should emit received message if not null',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(id: 'test-message-id', text: 'Action Sent');
          const formData = {'key': 'value'};

          tester.mockApi(
            (api) => api.message.sendAction(_channelId, _channelType, message.id, formData),
            result: createDefaultSendActionResponse(message: message),
          );

          final messagesEmission = expectLater(
            // skipping first seed message list -> [] messages
            tester.channelState?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await tester.channel.sendAction(message, formData);

          expect(res, isNotNull);
          expect(res.message?.id, message.id);

          tester.verifyApi(
            (api) => api.message.sendAction(_channelId, _channelType, message.id, formData),
          );

          await messagesEmission;
        },
      );
    });

    group('`.watch`', () {
      // Builds the channel already initialized from state — the `.watch` tests
      // exercise `queryChannel` themselves, so they cannot seed through
      // `tester.watch()` without polluting the call counts they verify.
      Channel _buildInitializedChannel(StreamChatClient client) {
        return Channel.fromState(
          client,
          createDefaultChannelState(
            channel: createDefaultChannelModel(
              cid: _channelCid,
              config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
              ownCapabilities: [ChannelCapability.readEvents],
            ),
          ),
        );
      }

      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        build: _buildInitializedChannel,
        body: (tester) async {
          tester.mockApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
              state: true,
              watch: true,
              presence: false,
            ),
            result: createDefaultChannelState(
              channel: createDefaultChannelModel(cid: _channelCid),
            ),
          );

          final res = await tester.channel.watch();

          expect(res, isNotNull);
          expect(res.channel, isNotNull);
          expect(res.channel?.cid, _channelCid);

          tester.verifyApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
              state: true,
              watch: true,
              presence: false,
            ),
          );
        },
      );

      channelTest(
        'a successful retry after a failed init reconciles '
        '`initialized` and `state`',
        channelType: _channelType,
        channelId: _channelId,
        body: (tester) async {
          final freshChannel = tester.channel;

          tester.mockApiFailureOnce(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: freshChannel.extraData,
              state: true,
              watch: true,
              presence: false,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.inputError, statusCode: 400),
            result: createDefaultChannelState(
              channel: createDefaultChannelModel(cid: _channelCid),
            ),
          );

          // First init fails: `initialized` errors and `state` stays null.
          // Attach the expectation before watch() so the error is handled.
          final firstInit = expectLater(
            freshChannel.initialized,
            throwsA(isA<StreamApiException>()),
          );
          await expectLater(
            freshChannel.watch(),
            throwsA(isA<StreamApiException>()),
          );
          await firstInit;
          expect(freshChannel.state, isNull);

          // Retrying resets the completer; the successful watch initializes the
          // channel and `initialized`/`state` agree again.
          await freshChannel.watch();
          expect(freshChannel.state, isNotNull);
          await expectLater(freshChannel.initialized, completion(isTrue));
        },
      );

      channelTest(
        'should rethrow if `.query` throws',
        channelType: _channelType,
        channelId: _channelId,
        build: _buildInitializedChannel,
        body: (tester) async {
          tester.mockApiFailure(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
              state: true,
              watch: true,
              presence: false,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.inputError, statusCode: 400),
          );

          try {
            await tester.channel.watch();
          } catch (e) {
            expect(e, isA<StreamApiException>());
          }

          tester.verifyApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
              state: true,
              watch: true,
              presence: false,
            ),
          );
        },
      );
    });

    channelTest(
      '`.stopWatching`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelWatch()),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.stopWatching(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.stopWatching();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.stopWatching(_channelId, _channelType),
        );
      },
    );

    channelTest(
      '`.getReplies`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelMessageQueries()),
      body: (tester) async {
        const parentId = 'test-parent-id';

        final messages = List.generate(
          3,
          (index) => Message(
            id: 'test-message-id-$index',
            parentId: parentId,
          ),
        );

        tester.mockApi(
          (api) => api.message.getReplies(parentId),
          result: createDefaultQueryRepliesResponse(messages: messages),
        );

        final res = await tester.channel.getReplies(parentId);

        expect(res, isNotNull);
        expect(res.messages.length, messages.length);
        expect(res.messages.every((it) => it.parentId == parentId), isTrue);

        tester.verifyApi((api) => api.message.getReplies(parentId));
      },
    );

    channelTest(
      '`.getReplies` keeps the parent message out of the thread',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelMessageQueries()),
      body: (tester) async {
        const parentId = 'test-parent-id';

        // Some backends return the parent as the first message of the oldest
        // page. It is rendered from its own copy, so it must not also become a
        // reply — otherwise the thread shows its root twice.
        final messages = [
          Message(id: parentId),
          ...List.generate(
            3,
            (index) => Message(id: 'test-message-id-$index', parentId: parentId),
          ),
        ];

        tester.mockApi(
          (api) => api.message.getReplies(parentId),
          result: createDefaultQueryRepliesResponse(messages: messages),
        );

        await tester.channel.getReplies(parentId);

        final threadMessages = tester.channelState!.threads[parentId];
        expect(threadMessages, isNotNull);
        expect(threadMessages!.length, messages.length - 1);
        expect(threadMessages.any((it) => it.id == parentId), isFalse);
      },
    );

    channelTest(
      '`.getReactions`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelMessageQueries()),
      body: (tester) async {
        const messageId = 'test-message-id';

        final reactions = List.generate(
          3,
          (index) => Reaction(
            type: 'test-reaction-type-$index',
            messageId: messageId,
          ),
        );

        tester.mockApi(
          (api) => api.message.getReactions(messageId),
          result: createDefaultQueryReactionsResponse(reactions: reactions),
        );

        final res = await tester.channel.getReactions(messageId);

        expect(res, isNotNull);
        expect(res.reactions.length, reactions.length);
        expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

        tester.verifyApi((api) => api.message.getReactions(messageId));
      },
    );

    channelTest(
      '`.getMessagesById`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelMessageQueries()),
      body: (tester) async {
        final messages = List.generate(
          3,
          (index) => Message(id: 'test-message-id-$index'),
        );

        final messageIds = messages.map((it) => it.id).toList(growable: false);

        tester.mockApi(
          (api) => api.message.getMessagesById(_channelId, _channelType, messageIds),
          result: createDefaultGetMessagesByIdResponse(messages: messages),
        );

        final res = await tester.channel.getMessagesById(messageIds);

        expect(res, isNotNull);
        expect(res.messages.length, messageIds.length);

        tester.verifyApi(
          (api) => api.message.getMessagesById(_channelId, _channelType, messageIds),
        );
      },
    );

    channelTest(
      '`.translateMessage`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelMessageQueries()),
      body: (tester) async {
        const messageId = 'test-message-id';
        const language = 'hi'; // Hindi
        const translatedMessageText = 'नमस्ते';

        final message = Message(id: messageId, text: 'Hello');
        tester.channelState!.updateMessage(message);

        final translatedMessage = message.copyWith(
          i18n: {'language': 'en', '${language}_text': translatedMessageText},
        );

        tester.mockApi(
          (api) => api.message.translateMessage(messageId, language),
          result: createDefaultTranslateMessageResponse(message: translatedMessage),
        );

        final res = await tester.channel.translateMessage(messageId, language);

        expect(res, isNotNull);
        expect(res.message.i18n, translatedMessage.i18n);

        // The translation is merged into the channel state, so callers don't
        // have to apply the response themselves.
        final stateMessage = tester.channelState!.messages.firstWhere((it) => it.id == messageId);
        expect(stateMessage.i18n, translatedMessage.i18n);

        tester.verifyApi((api) => api.message.translateMessage(messageId, language));
      },
    );

    group('`.query`', () {
      channelTest(
        'should work fine',
        channelType: _channelType,
        channelId: _channelId,
        build: _buildInitializedChannel,
        body: (tester) async {
          tester.mockApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
            ),
            result: createDefaultChannelState(
              channel: createDefaultChannelModel(cid: _channelCid),
            ),
          );

          final res = await tester.channel.query();

          expect(res, isNotNull);

          tester.verifyApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
            ),
          );
        },
      );

      channelTest(
        'should rethrow if `client.queryChannel` throws',
        channelType: _channelType,
        channelId: _channelId,
        build: _buildInitializedChannel,
        body: (tester) async {
          tester.mockApiFailure(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
            ),
            error: createDefaultNetworkError(code: StreamErrorCode.inputError, statusCode: 400),
          );

          try {
            await tester.channel.query();
          } catch (e) {
            expect(e, isA<StreamApiException>());
          }

          tester.verifyApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
            ),
          );
        },
      );

      channelTest(
        'should truncate state when querying around message id',
        channelType: _channelType,
        channelId: _channelId,
        build: _buildInitializedChannel,
        body: (tester) async {
          final initialMessages = [
            Message(id: 'msg1', text: 'Hello 1'),
            Message(id: 'msg2', text: 'Hello 2'),
            Message(id: 'msg3', text: 'Hello 3'),
          ];

          final stateWithMessages = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
            messages: initialMessages,
          );

          tester.channelState!.updateChannelState(stateWithMessages);
          expect(tester.channelState!.messages, hasLength(3));

          final newState = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
            messages: [
              Message(id: 'msg-before-1', text: 'Message before 1'),
              Message(id: 'msg-before-2', text: 'Message before 2'),
              Message(id: 'target-message-id', text: 'Target message'),
              Message(id: 'msg-after-1', text: 'Message after 1'),
              Message(id: 'msg-after-2', text: 'Message after 2'),
            ],
          );

          const pagination = PaginationParams(idAround: 'target-message-id');

          tester.mockApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
              messagesPagination: pagination,
            ),
            result: newState,
          );

          final res = await tester.channel.query(messagesPagination: pagination);

          expect(res, isNotNull);
          expect(tester.channelState!.messages, hasLength(5));
          expect(tester.channelState!.messages[2].id, 'target-message-id');

          tester.verifyApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
              messagesPagination: pagination,
            ),
          );
        },
      );

      channelTest(
        'should truncate state when querying around created date',
        channelType: _channelType,
        channelId: _channelId,
        build: _buildInitializedChannel,
        body: (tester) async {
          final initialMessages = [
            Message(id: 'msg1', text: 'Hello 1'),
            Message(id: 'msg2', text: 'Hello 2'),
            Message(id: 'msg3', text: 'Hello 3'),
          ];

          final stateWithMessages = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
            messages: initialMessages,
          );

          tester.channelState!.updateChannelState(stateWithMessages);
          expect(tester.channelState!.messages, hasLength(3));

          final targetDate = DateTime.utc(2021, 3);
          final newState = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
            messages: [
              Message(id: 'msg-before-1', text: 'Message before 1'),
              Message(id: 'msg-before-2', text: 'Message before 2'),
              Message(id: 'target-message', text: 'Target message'),
              Message(id: 'msg-after-1', text: 'Message after 1'),
              Message(id: 'msg-after-2', text: 'Message after 2'),
            ],
          );

          final pagination = PaginationParams(createdAtAround: targetDate);

          tester.mockApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
              messagesPagination: pagination,
            ),
            result: newState,
          );

          final res = await tester.channel.query(messagesPagination: pagination);

          expect(res, isNotNull);
          expect(tester.channelState!.messages, hasLength(5));
          expect(tester.channelState!.messages[2].id, 'target-message');

          tester.verifyApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
              messagesPagination: pagination,
            ),
          );
        },
      );

      channelTest(
        'should submit for delivery when querying latest messages (no pagination)',
        channelType: _channelType,
        channelId: _channelId,
        // The delivery reporter is real in the harness: it only records a
        // channel whose last message qualifies for a receipt, so the channel is
        // seeded with the `deliveryEvents` capability and a message from
        // another user.
        build: (client) => _buildInitializedChannel(
          client,
          ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
          messages: [
            Message(
              id: 'test-message-id',
              user: User(id: 'other-user'),
              createdAt: DateTime.utc(2021, 1, 2),
            ),
          ],
        ),
        body: (tester) async {
          tester.mockApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
            ),
            result: createDefaultChannelState(
              channel: createDefaultChannelModel(cid: _channelCid),
            ),
          );

          registerFallbackValue(<MessageDelivery>[]);
          tester.mockApi(
            (api) => api.channel.markChannelsDelivered(any()),
            result: createDefaultEmptyResponse(),
          );

          // Query without pagination params (fetching latest messages)
          await tester.channel.query();

          // The delivery reporter batches receipts behind a 1s trailing
          // throttle.
          await Future.delayed(const Duration(milliseconds: 1100));

          // Verify the channel's last message was marked as delivered
          final captured = tester.captureApi(
            (api) => api.channel.markChannelsDelivered(captureAny()),
          );
          final deliveries = captured.single! as List<MessageDelivery>;
          expect(deliveries.single.channelCid, _channelCid);
          expect(deliveries.single.messageId, 'test-message-id');
        },
      );

      channelTest(
        'should NOT submit for delivery when querying with pagination (older messages)',
        channelType: _channelType,
        channelId: _channelId,
        // Seeded so a receipt would be submitted on a plain query: the absence
        // of one can then only come from the pagination params.
        build: (client) => _buildInitializedChannel(
          client,
          ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
          messages: [
            Message(
              id: 'test-message-id',
              user: User(id: 'other-user'),
              createdAt: DateTime.utc(2021, 1, 2),
            ),
          ],
        ),
        body: (tester) async {
          registerFallbackValue(<MessageDelivery>[]);
          tester.mockApi(
            (api) => api.channel.markChannelsDelivered(any()),
            result: createDefaultEmptyResponse(),
          );

          const pagination = PaginationParams(limit: 20, lessThan: 'some-message-id');

          tester.mockApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: _channelId,
              channelData: tester.channel.extraData,
              messagesPagination: pagination,
            ),
            result: createDefaultChannelState(
              channel: createDefaultChannelModel(cid: _channelCid),
            ),
          );

          // Query with pagination params (fetching older messages)
          await tester.channel.query(messagesPagination: pagination);

          // Wait out the reporter's 1s trailing throttle so a receipt would
          // have been sent by now if the channel had been submitted.
          await Future.delayed(const Duration(milliseconds: 1100));

          // Verify no delivery receipt was sent
          tester.verifyNeverCalled(
            (api) => api.channel.markChannelsDelivered(any()),
          );
        },
      );
    });

    channelTest(
      '`.queryMembers`',
      channelType: _channelType,
      channelId: _channelId,
      build: _buildInitializedChannel,
      body: (tester) async {
        final filter = MemberFilter.in_(MemberFilterField.userId, const ['test-user-id-0']);

        final members = List.generate(
          3,
          (index) => Member(userId: 'test-user-id-$index'),
        );

        tester.mockApi(
          // The seeded channel state holds no members, so the SDK forwards an
          // empty list.
          (api) => api.general.queryMembers(
            _channelType,
            channelId: _channelId,
            filter: filter,
            members: const <Member>[],
          ),
          result: QueryMembersResponse()..members = members,
        );

        final res = await tester.channel.queryMembers(filter: filter);

        expect(res, isNotNull);
        expect(res.members.length, members.length);

        tester.verifyApi(
          (api) => api.general.queryMembers(
            _channelType,
            channelId: _channelId,
            filter: filter,
            members: const <Member>[],
          ),
        );
      },
    );

    channelTest(
      '`.queryBannedUsers`',
      channelType: _channelType,
      channelId: _channelId,
      build: _buildInitializedChannel,
      body: (tester) async {
        // Built by the channel rather than passed in, and a filter compares
        // by identity, so the stubs below match on what it sends.
        final filter = BannedUserFilter.equal(BannedUserFilterField.channelCid, _channelCid);

        final bans = List.generate(
          3,
          (index) => BannedUser(
            user: User(id: 'test-user-id-$index'),
            bannedBy: User(id: 'test-user-id-${index + 1}'),
          ),
        );

        tester.mockApi(
          (api) => api.moderation.queryBannedUsers(
            filter: any(named: 'filter', that: isSameFilterAs(filter)),
          ),
          result: QueryBannedUsersResponse()..bans = bans,
        );

        final res = await tester.channel.queryBannedUsers();

        expect(res, isNotNull);
        expect(res.bans.length, bans.length);

        tester.verifyApi(
          (api) => api.moderation.queryBannedUsers(
            filter: any(named: 'filter', that: isSameFilterAs(filter)),
          ),
        );
      },
    );

    channelTest(
      '`.mute`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelModerationApi()),
      body: (tester) async {
        tester.mockApi(
          (api) => api.moderation.muteChannel(_channelCid),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.mute();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.moderation.muteChannel(_channelCid),
        );
      },
    );

    channelTest(
      '`.mute with expiration`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelModerationApi()),
      body: (tester) async {
        const expiration = Duration(seconds: 3);

        tester
          ..mockApi(
            (api) => api.moderation.muteChannel(_channelCid, expiration: expiration),
            result: createDefaultEmptyResponse(),
          )
          ..mockApi(
            (api) => api.moderation.unmuteChannel(_channelCid),
            result: createDefaultEmptyResponse(),
          );

        final res = await tester.channel.mute(expiration: expiration);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.moderation.muteChannel(_channelCid, expiration: expiration),
        );

        // wait for expiration
        await Future.delayed(expiration);
        tester.verifyApi((api) => api.moderation.unmuteChannel(_channelCid));
      },
    );

    channelTest(
      '`.unmute`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelModerationApi()),
      body: (tester) async {
        tester.mockApi(
          (api) => api.moderation.unmuteChannel(_channelCid),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.unmute();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.moderation.unmuteChannel(_channelCid),
        );
      },
    );

    channelTest(
      '`.enableSlowMode`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelModerationApi()),
      body: (tester) async {
        const cooldown = 10;

        final channelModel = ChannelModel(
          cid: _channelCid,
          cooldown: cooldown,
        );

        tester.mockApi(
          (api) => api.channel.enableSlowdown(_channelId, _channelType, cooldown),
          result: createDefaultPartialUpdateChannelResponse(channel: channelModel),
        );

        final res = await tester.channel.enableSlowMode(cooldownInterval: 10);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.enableSlowdown(_channelId, _channelType, cooldown),
        );
      },
    );

    channelTest(
      '`.disableSlowMode`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelModerationApi()),
      body: (tester) async {
        final channelModel = ChannelModel(
          cid: _channelCid,
        );

        tester.mockApi(
          (api) => api.channel.disableSlowdown(_channelId, _channelType),
          result: createDefaultPartialUpdateChannelResponse(channel: channelModel),
        );

        final res = await tester.channel.disableSlowMode();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.disableSlowdown(_channelId, _channelType),
        );
      },
    );

    channelTest(
      '`.banUser`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelModerationApi()),
      body: (tester) async {
        const userId = 'test-user-id';
        const options = {'key': 'value'};

        tester.mockApi(
          (api) => api.moderation.banUser(
            userId,
            options: {'type': _channelType, 'id': _channelId, ...options},
          ),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.banMember(userId, options);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.moderation.banUser(
            userId,
            options: {'type': _channelType, 'id': _channelId, ...options},
          ),
        );
      },
    );

    channelTest(
      '`.unbanUser`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelModerationApi()),
      body: (tester) async {
        const userId = 'test-user-id';

        tester.mockApi(
          (api) => api.moderation.unbanUser(
            userId,
            options: {'type': _channelType, 'id': _channelId},
          ),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.unbanMember(userId);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.moderation.unbanUser(
            userId,
            options: {'type': _channelType, 'id': _channelId},
          ),
        );
      },
    );

    channelTest(
      '`.shadowBan`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelModerationApi()),
      body: (tester) async {
        const userId = 'test-user-id';
        const options = {'key': 'value'};

        tester.mockApi(
          (api) => api.moderation.banUser(
            userId,
            options: {'shadow': true, 'type': _channelType, 'id': _channelId, ...options},
          ),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.shadowBan(userId, options);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.moderation.banUser(
            userId,
            options: {'shadow': true, 'type': _channelType, 'id': _channelId, ...options},
          ),
        );
      },
    );

    channelTest(
      '`.removeShadowBan`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelModerationApi()),
      body: (tester) async {
        const userId = 'test-user-id';

        tester.mockApi(
          (api) => api.moderation.unbanUser(
            userId,
            options: {'shadow': true, 'type': _channelType, 'id': _channelId},
          ),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.removeShadowBan(userId);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.moderation.unbanUser(
            userId,
            options: {'shadow': true, 'type': _channelType, 'id': _channelId},
          ),
        );
      },
    );

    channelTest(
      '`.hide`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelDisplayApi()),
      body: (tester) async {
        const clearHistory = true;

        tester.mockApi(
          (api) => api.channel.hideChannel(
            _channelId,
            _channelType,
            clearHistory: clearHistory,
          ),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.hide(clearHistory: clearHistory);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.hideChannel(
            _channelId,
            _channelType,
            clearHistory: clearHistory,
          ),
        );
      },
    );

    channelTest(
      '`.show`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelDisplayApi()),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.showChannel(_channelId, _channelType),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.show();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.showChannel(_channelId, _channelType),
        );
      },
    );

    // testing archiving
    channelTest(
      '`.archive`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelDisplayApi()),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: {'archived': true},
          ),
          result: createDefaultPartialUpdateMemberResponse(),
        );

        final res = await tester.channel.archive();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: {'archived': true},
          ),
        );
      },
    );

    channelTest(
      '`.unarchive`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelDisplayApi()),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            unset: ['archived'],
          ),
          result: createDefaultPartialUpdateMemberResponse(),
        );

        final res = await tester.channel.unarchive();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            unset: ['archived'],
          ),
        );
      },
    );

    // testing pinning
    channelTest(
      '`.pin`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelDisplayApi()),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: {'pinned': true},
          ),
          result: createDefaultPartialUpdateMemberResponse(),
        );

        final res = await tester.channel.pin();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            set: {'pinned': true},
          ),
        );
      },
    );

    channelTest(
      '`.unpin`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelDisplayApi()),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            unset: ['pinned'],
          ),
          result: createDefaultPartialUpdateMemberResponse(),
        );

        final res = await tester.channel.unpin();

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.channel.updateMemberPartial(
            channelId: _channelId,
            channelType: _channelType,
            unset: ['pinned'],
          ),
        );
      },
    );

    channelTest(
      '`.on`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannelDisplayApi()),
      body: (tester) async {
        const eventType = 'test.event';
        final event = createDefaultEvent(type: eventType, cid: _channelCid);

        final eventReceived = expectLater(
          tester.channel.on(eventType),
          // The event round-trips through the real wire decode, so the
          // delivered instance is never identical to `event`; pin every field it
          // carries instead.
          emitsInOrder([
            isA<Event>()
                .having((it) => it.type, 'type', event.type)
                .having((it) => it.cid, 'cid', event.cid)
                .having((it) => it.createdAt, 'createdAt', event.createdAt),
          ]),
        );

        await tester.emitEvent(event);

        await eventReceived;
      },
    );

    group('stale error message cleanup', () {
      final errorMessage = Message(type: MessageType.error);
      final bouncedErrorMessage = Message(
        type: MessageType.error,
        moderation: const Moderation(
          action: ModerationAction.bounce,
          originalText: 'original text',
        ),
      );

      // Test case: sending a message cleans up stale error messages

      // Test case: sending a message cleans up stale error messages
      channelTest(
        'when sending a new message',
        channelType: _channelType,
        channelId: _channelId,
        // Channel with 2 error messages
        setUp: (tester) => tester.watch(
          modifyResponse: (_) => _channelStateWith(
            messages: [errorMessage, bouncedErrorMessage],
          ),
        ),
        body: (tester) async {
          // Set up the mock response for sending message
          final newMessage = Message(text: 'New message');

          tester.mockApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(newMessage))),
            result: createDefaultSendMessageResponse(message: newMessage.copyWith(state: MessageState.sent)),
          );

          // Send a new message
          await tester.channel.sendMessage(newMessage);
          final messages = tester.channelState!.messages;

          // Verify the cleanup
          expect(messages.length, 2);
          expect(messages.any((m) => m.id == errorMessage.id), false);
          expect(messages.any((m) => m.id == bouncedErrorMessage.id), true);
          expect(messages.any((m) => m.id == newMessage.id), true);

          tester.verifyApi(
            (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(newMessage))),
          );
        },
      );
    });

    group('`.state.pruneOldest`', () {
      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: [ChannelCapability.readEvents],
          ),
        );
      }

      List<Message> _generateMessages(int count) => List.generate(
        count,
        (i) => Message(
          id: 'msg-$i',
          text: 'Hello $i',
          createdAt: DateTime.utc(2024).add(Duration(seconds: i)),
        ),
      );

      channelTest(
        'keeps only the [maxMessages] most recent messages',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final initial = _generateMessages(10);
          tester.channelState!.updateChannelState(_channelStateWith(messages: initial));
          expect(tester.channelState!.messages, hasLength(10));

          tester.channelState!.pruneOldest(4);

          final pruned = tester.channelState!.messages;
          expect(pruned, hasLength(4));
          expect(pruned.map((m) => m.id), ['msg-6', 'msg-7', 'msg-8', 'msg-9']);
        },
      );

      channelTest(
        'emits the pruned list on `messagesStream`',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final initial = _generateMessages(6);
          tester.channelState!.updateChannelState(_channelStateWith(messages: initial));

          final next = tester.channelState!.messagesStream.firstWhere((messages) => messages.length == 3);

          tester.channelState!.pruneOldest(3);

          final emitted = await next;
          expect(emitted.map((m) => m.id), ['msg-3', 'msg-4', 'msg-5']);
        },
      );

      channelTest(
        'is a no-op when message count is within the limit',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final initial = _generateMessages(3);
          tester.channelState!.updateChannelState(_channelStateWith(messages: initial));

          tester.channelState!.pruneOldest(5);
          expect(tester.channelState!.messages, hasLength(3));

          tester.channelState!.pruneOldest(3);
          expect(tester.channelState!.messages, hasLength(3));
        },
      );

      channelTest(
        'is a no-op when [maxMessages] is zero or negative',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final initial = _generateMessages(5);
          tester.channelState!.updateChannelState(_channelStateWith(messages: initial));

          tester.channelState!.pruneOldest(0);
          expect(tester.channelState!.messages, hasLength(5));

          tester.channelState!.pruneOldest(-1);
          expect(tester.channelState!.messages, hasLength(5));
        },
      );

      channelTest(
        'is a no-op when `isUpToDate` is false',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final initial = _generateMessages(10);
          tester.channelState!.updateChannelState(_channelStateWith(messages: initial));

          tester.channelState!.isUpToDate = false;
          tester.channelState!.pruneOldest(3);
          expect(tester.channelState!.messages, hasLength(10));
        },
      );

      channelTest(
        'only mutates `messages`; other channel state fields untouched',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final initial = _generateMessages(10);
          final pinned = [
            Message(
              id: 'pinned-1',
              text: 'pinned message',
              createdAt: DateTime.utc(2024),
            ),
          ];

          tester.channelState!.updateChannelState(
            _channelStateWith(messages: initial, pinnedMessages: pinned),
          );

          tester.channelState!.pruneOldest(3);

          expect(tester.channelState!.messages, hasLength(3));
          expect(tester.channelState!.pinnedMessages, equals(pinned));
        },
      );

      channelTest(
        'does not emit on `messagesStream` for no-op calls',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final initial = _generateMessages(5);
          tester.channelState!.updateChannelState(_channelStateWith(messages: initial));

          // Skip the seeded emission from updateChannelState.
          await pumpEventQueue();

          final emissions = <List<Message>>[];
          final sub = tester.channelState!.messagesStream.skip(1).listen(emissions.add);
          addTearDown(sub.cancel);

          tester.channelState!.pruneOldest(0); // non-positive guard
          tester.channelState!.pruneOldest(-1); // non-positive guard
          tester.channelState!.pruneOldest(10); // within limit guard
          tester.channelState!.isUpToDate = false;
          tester.channelState!.pruneOldest(2); // !isUpToDate guard

          await pumpEventQueue();
          expect(emissions, isEmpty);
        },
      );
    });
  });

  group('Channel State Validation and Cooldown', () {
    // seconds

    // A bare channel state (no config, no capabilities).
    ChannelState Function(ChannelState) _seedChannel() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
      );
    }

    // A bare channel state (no config, no capabilities).
    ChannelState Function(ChannelState) _seedChannelCountEvents() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
      );
    }

    group('Non-initialized channel state validation', () {
      channelTest(
        'should throw StateError when accessing cooldown on non-initialized channel',
        channelType: _channelType,
        channelId: _channelId,
        body: (tester) async {
          final channel = tester.channel;
          expect(() => channel.cooldown, throwsA(isA<StateError>()));
        },
      );

      channelTest(
        'should throw StateError when accessing getRemainingCooldown on non-initialized channel',
        channelType: _channelType,
        channelId: _channelId,
        body: (tester) async {
          final channel = tester.channel;
          expect(channel.getRemainingCooldown, throwsA(isA<StateError>()));
        },
      );

      channelTest(
        'should throw StateError when accessing cooldownStream on non-initialized channel',
        channelType: _channelType,
        channelId: _channelId,
        body: (tester) async {
          final channel = tester.channel;
          expect(() => channel.cooldownStream, throwsA(isA<StateError>()));
        },
      );
    });

    group('Initialized channel cooldown functionality', () {
      channelTest(
        'should return default cooldown value of 0 for initialized channel',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) => expect(tester.channel.cooldown, equals(0)),
      );

      channelTest(
        'should return custom cooldown value when set in channel model',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final channelWithCooldown = ChannelModel(
            id: _channelId,
            type: _channelType,
            cooldown: 30,
          );

          final stateWithCooldown = ChannelState(channel: channelWithCooldown);
          final testChannel = Channel.fromState(tester.client, stateWithCooldown);
          addTearDown(testChannel.dispose);

          expect(testChannel.cooldown, equals(30));
        },
      );

      channelTest(
        'should return 0 remaining cooldown when no cooldown is set',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channel.getRemainingCooldown(), equals(0));
        },
      );

      channelTest(
        'should return cooldown stream with default value',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          await expectLater(tester.channel.cooldownStream.take(1), emits(0));
        },
      );
    });

    group('Thread reply cooldown', () {
      const _cooldownDuration = 30;

      // A channel with an active cooldown and the slow-mode capability.
      // `isUpToDate` is seeded true by default.
      ChannelState Function(ChannelState) _seedChannelWithCooldown() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            cooldown: _cooldownDuration,
            ownCapabilities: [ChannelCapability.slowMode],
          ),
        );
      }

      channelTest(
        'should return positive cooldown after current user sends a thread reply',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          // Simulate a thread reply by the current user sent just now.
          final threadReply = Message(
            id: 'thread-reply-1',
            parentId: 'parent-msg-1',
            showInChannel: false,
            createdAt: DateTime.timestamp(),
            user: User(id: tester.currentUser!.id),
          );
          tester.channelState!.updateThreadInfo('parent-msg-1', [threadReply]);

          expect(tester.channel.getRemainingCooldown(), greaterThan(0));
        },
      );

      channelTest(
        'should return 0 cooldown when thread reply was sent outside the cooldown window',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          // Reply sent cooldownDuration+5 seconds ago — outside the window.
          final oldReply = Message(
            id: 'thread-reply-old',
            parentId: 'parent-msg-1',
            showInChannel: false,
            createdAt: DateTime.timestamp().subtract(
              const Duration(seconds: _cooldownDuration + 5),
            ),
            user: User(id: tester.currentUser!.id),
          );
          tester.channelState!.updateThreadInfo('parent-msg-1', [oldReply]);

          expect(tester.channel.getRemainingCooldown(), equals(0));
        },
      );

      channelTest(
        'should not trigger cooldown for a thread reply from another user',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          final otherUserReply = Message(
            id: 'thread-reply-other',
            parentId: 'parent-msg-1',
            showInChannel: false,
            createdAt: DateTime.timestamp(),
            user: User(id: 'other-user-id'),
          );
          tester.channelState!.updateThreadInfo('parent-msg-1', [otherUserReply]);

          expect(tester.channel.getRemainingCooldown(), equals(0));
        },
      );

      channelTest(
        'should clear cooldown when the most-recent own message is hard-deleted',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          final ownMessage = Message(
            id: 'msg-1',
            createdAt: DateTime.timestamp(),
            user: User(id: tester.currentUser!.id),
          );
          tester.channelState!.updateMessage(ownMessage);
          expect(tester.channel.getRemainingCooldown(), greaterThan(0));

          tester.channelState!.deleteMessage(ownMessage, hardDelete: true);
          expect(tester.channel.getRemainingCooldown(), equals(0));
        },
      );

      channelTest(
        'currentUserLastMessageAtStream emits a new timestamp when own message is added',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          final emissions = <DateTime?>[];
          final sub = tester.channel.currentUserLastMessageAtStream.listen(emissions.add);
          addTearDown(sub.cancel);

          // Let the seed emission settle.
          await Future<void>.delayed(Duration.zero);
          final seededLast = emissions.last;

          tester.channelState!.updateMessage(
            Message(
              id: 'msg-1',
              createdAt: DateTime.timestamp(),
              user: User(id: tester.currentUser!.id),
            ),
          );
          await Future<void>.delayed(Duration.zero);

          expect(emissions.last, isNotNull);
          expect(emissions.last, isNot(equals(seededLast)));
        },
      );

      channelTest(
        'getRemainingCooldown uses the explicit [lastMessageAt] override',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          // No messages in state, so the default path returns 0.
          expect(tester.channel.getRemainingCooldown(), equals(0));

          // Override pointing inside the cooldown window → positive remaining.
          final recent = DateTime.timestamp().subtract(const Duration(seconds: 5));
          expect(tester.channel.getRemainingCooldown(lastMessageAt: recent), greaterThan(0));

          // Override pointing outside the window → 0.
          final old = DateTime.timestamp().subtract(
            const Duration(seconds: _cooldownDuration + 5),
          );
          expect(tester.channel.getRemainingCooldown(lastMessageAt: old), equals(0));
        },
      );

      channelTest(
        'currentUserLastMessageAt picks the latest across channel messages and threads',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelWithCooldown()),
        body: (tester) async {
          final older = DateTime.timestamp().subtract(const Duration(seconds: 20));
          final newer = DateTime.timestamp().subtract(const Duration(seconds: 5));

          // Older message in the main channel.
          tester.channelState!.updateMessage(
            Message(
              id: 'msg-1',
              createdAt: older,
              user: User(id: tester.currentUser!.id),
            ),
          );
          // Newer reply in a thread.
          tester.channelState!.updateThreadInfo('parent-msg-1', [
            Message(
              id: 'thread-reply-1',
              parentId: 'parent-msg-1',
              showInChannel: false,
              createdAt: newer,
              user: User(id: tester.currentUser!.id),
            ),
          ]);

          // Should pick the newer thread reply, not the older channel message.
          final result = tester.channel.currentUserLastMessageAt;
          expect(result, isNotNull);
          expect(result!.isAtSameMomentAs(newer), isTrue);
        },
      );
    });

    group('Disposed channel state validation', () {
      channelTest(
        'should throw StateError when accessing cooldown after disposal',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final channel = tester.channel;

          // First verify it works when initialized
          expect(channel.cooldown, equals(0));

          // Dispose the channel
          channel.dispose();

          // Now accessing cooldown should throw
          expect(() => channel.cooldown, throwsA(isA<StateError>()));
        },
      );

      channelTest(
        'should throw StateError when accessing getRemainingCooldown after disposal',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final channel = tester.channel;

          // First verify it works when initialized
          expect(channel.getRemainingCooldown(), equals(0));

          // Dispose the channel
          channel.dispose();

          // Now accessing getRemainingCooldown should throw
          expect(channel.getRemainingCooldown, throwsA(isA<StateError>()));
        },
      );

      channelTest(
        'should throw StateError when accessing cooldownStream after disposal',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final channel = tester.channel;

          // First verify it works when initialized
          await expectLater(channel.cooldownStream.take(1), emits(0));

          // Dispose the channel
          channel.dispose();

          // Now accessing cooldownStream should throw
          expect(() => channel.cooldownStream, throwsA(isA<StateError>()));
        },
      );

      channelTest(
        'should handle race condition scenario - initialization then quick disposal',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          // This test simulates the race condition that was causing the production crash
          final channelState = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
          );
          final raceChannel = Channel.fromState(tester.client, channelState);

          // Verify it works initially
          expect(raceChannel.cooldown, equals(0));

          // Simulate quick disposal (like what happens with rapid navigation)
          raceChannel.dispose();

          // This should throw StateError instead of crashing with null check operator
          expect(() => raceChannel.cooldown, throwsA(isA<StateError>()));

          expect(raceChannel.getRemainingCooldown, throwsA(isA<StateError>()));
        },
      );
    });

    group('Channel message count events', () {
      channelTest(
        'should update channel messageCount when event contains channelMessageCount',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelCountEvents()),
        body: (tester) async {
          // Verify initial state - no messageCount
          expect(tester.channel.messageCount, isNull);

          // Create event with channelMessageCount
          final messageCountEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageNew,
            channelMessageCount: 42,
          );

          // Dispatch event and wait for it to be processed
          await tester.emitEvent(messageCountEvent);

          // Verify channel messageCount was updated
          expect(tester.channel.messageCount, equals(42));
        },
      );

      channelTest(
        'should update channel messageCount from message.new and message.deleted events',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelCountEvents()),
        body: (tester) async {
          // Test with message.new event - count increases
          final messageNewEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageNew,
            message: createDefaultMessage(
              id: 'new-message-1',
              text: 'Hello world!',
              user: User(id: 'user-1'),
            ),
            channelMessageCount: 1,
          );

          await tester.emitEvent(messageNewEvent);
          expect(tester.channel.messageCount, equals(1));

          // Test with another message.new event - count increases
          final messageNewEvent2 = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageNew,
            message: createDefaultMessage(
              id: 'new-message-2',
              text: 'Second message',
              user: User(id: 'user-2'),
            ),
            channelMessageCount: 2,
          );

          await tester.emitEvent(messageNewEvent2);
          expect(tester.channel.messageCount, equals(2));

          // Test with message.deleted event - count decreases
          final messageDeletedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageDeleted,
            message: createDefaultMessage(
              id: 'new-message-1',
              text: 'Hello world!',
              user: User(id: 'user-1'),
            ),
            channelMessageCount: 1,
          );

          await tester.emitEvent(messageDeletedEvent);
          expect(tester.channel.messageCount, equals(1));
        },
      );

      channelTest(
        'should preserve other channel properties when updating messageCount',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelCountEvents()),
        body: (tester) async {
          // Set initial channel state with some properties
          final initialChannel = tester.channelState?.channelState.channel?.copyWith(
            extraData: {'name': 'Test Channel'},
            memberCount: 5,
            frozen: true,
          );

          if (initialChannel != null) {
            tester.channelState?.updateChannelState(
              tester.channelState!.channelState.copyWith(channel: initialChannel),
            );
          }

          // Verify initial state
          expect(tester.channel.name, 'Test Channel');
          expect(tester.channel.memberCount, equals(5));
          expect(tester.channel.frozen, equals(true));
          expect(tester.channel.messageCount, isNull);

          // Update messageCount via event
          final messageCountEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageNew,
            channelMessageCount: 100,
          );

          await tester.emitEvent(messageCountEvent);

          // Verify messageCount was updated while preserving other properties
          expect(tester.channel.messageCount, equals(100));
          expect(tester.channel.name, 'Test Channel');
          expect(tester.channel.memberCount, equals(5));
          expect(tester.channel.frozen, equals(true));
        },
      );

      channelTest(
        'should provide messageCountStream for reactive updates',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelCountEvents()),
        body: (tester) async {
          final emitted = <int?>[];
          final subscription = tester.channel.messageCountStream.listen(emitted.add);
          addTearDown(subscription.cancel);
          await Future.delayed(Duration.zero);

          // Update messageCount multiple times, repeating one of the counts.
          final counts = [1, 5, 5, 10];
          for (final (index, count) in counts.indexed) {
            final event = createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.messageNew,
              message: createDefaultMessage(
                id: 'msg-$index',
                text: 'Message $count',
                user: User(id: 'user-1'),
              ),
              channelMessageCount: count,
            );

            await tester.emitEvent(event);
          }

          // The repeated count should not be emitted twice.
          expect(emitted, equals([null, 1, 5, 10]));
        },
      );
    });

    group('Channel member count events', () {
      channelTest(
        'should update channel memberCount when event contains channelMemberCount',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelCountEvents()),
        body: (tester) async {
          // Verify initial state - default memberCount
          expect(tester.channel.memberCount, equals(0));

          // Create event with channelMemberCount
          final memberCountEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberAdded,
            member: createDefaultMember(user: User(id: 'user-1')),
            channelMemberCount: 42,
          );

          // Dispatch event and wait for it to be processed
          await tester.emitEvent(memberCountEvent);

          // Verify channel memberCount was updated
          expect(tester.channel.memberCount, equals(42));
        },
      );

      channelTest(
        'should update channel memberCount from member.added and member.removed events',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelCountEvents()),
        body: (tester) async {
          // Test with member.added event - count increases
          final memberAddedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberAdded,
            member: createDefaultMember(user: User(id: 'user-1')),
            channelMemberCount: 1,
          );

          await tester.emitEvent(memberAddedEvent);
          expect(tester.channel.memberCount, equals(1));
          expect(tester.channelState?.channelState.members?.map((it) => it.userId), equals(['user-1']));

          // Test with another member.added event - count increases
          final memberAddedEvent2 = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberAdded,
            member: createDefaultMember(user: User(id: 'user-2')),
            channelMemberCount: 2,
          );

          await tester.emitEvent(memberAddedEvent2);
          expect(tester.channel.memberCount, equals(2));
          expect(
            tester.channelState?.channelState.members?.map((it) => it.userId),
            equals(['user-1', 'user-2']),
          );

          // Test with member.removed event - count decreases
          final memberRemovedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberRemoved,
            user: User(id: 'user-1'),
            channelMemberCount: 1,
          );

          await tester.emitEvent(memberRemovedEvent);
          expect(tester.channel.memberCount, equals(1));
          expect(tester.channelState?.channelState.members?.map((it) => it.userId), equals(['user-2']));
        },
      );

      channelTest(
        'should preserve other channel properties when updating memberCount',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelCountEvents()),
        body: (tester) async {
          // Set initial channel state with some properties
          final initialChannel = tester.channelState?.channelState.channel?.copyWith(
            extraData: {'name': 'Test Channel'},
            messageCount: 7,
            frozen: true,
          );

          if (initialChannel != null) {
            tester.channelState?.updateChannelState(
              tester.channelState!.channelState.copyWith(channel: initialChannel),
            );
          }

          // Verify initial state
          expect(tester.channel.name, 'Test Channel');
          expect(tester.channel.messageCount, equals(7));
          expect(tester.channel.frozen, equals(true));
          expect(tester.channel.memberCount, equals(0));

          // Update memberCount via event
          final memberCountEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberAdded,
            member: createDefaultMember(user: User(id: 'user-1')),
            channelMemberCount: 100,
          );

          await tester.emitEvent(memberCountEvent);

          // Verify memberCount was updated while preserving other properties
          expect(tester.channel.memberCount, equals(100));
          expect(tester.channel.name, 'Test Channel');
          expect(tester.channel.messageCount, equals(7));
          expect(tester.channel.frozen, equals(true));
        },
      );

      channelTest(
        'should not update memberCount when the event omits channelMemberCount',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelCountEvents()),
        body: (tester) async {
          // Seed a known member count.
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.memberAdded,
              member: createDefaultMember(user: User(id: 'user-1')),
              channelMemberCount: 5,
            ),
          );

          expect(tester.channel.memberCount, equals(5));

          // An event without the field should leave the count untouched.
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.memberAdded,
              member: createDefaultMember(user: User(id: 'user-2')),
            ),
          );

          expect(tester.channel.memberCount, equals(5));
        },
      );

      channelTest(
        'should provide memberCountStream for reactive updates',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannelCountEvents()),
        body: (tester) async {
          final emitted = <int?>[];
          final subscription = tester.channel.memberCountStream.listen(emitted.add);
          addTearDown(subscription.cancel);
          await Future.delayed(Duration.zero);

          // Update memberCount multiple times, repeating one of the counts.
          final counts = [1, 5, 5, 10];
          for (final (index, count) in counts.indexed) {
            final event = createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.memberAdded,
              member: createDefaultMember(user: User(id: 'user-$index')),
              channelMemberCount: count,
            );

            await tester.emitEvent(event);
          }

          // The repeated count should not be emitted twice.
          expect(emitted, equals([0, 1, 5, 10]));
        },
      );
    });

    channelTest(
      'should throw StateError when accessing config on non-initialized channel',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final channel = tester.channel;
        expect(() => channel.config, throwsA(isA<StateError>()));
      },
    );

    channelTest(
      'should return the config of an initialized channel',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
          ),
        ),
      ),
      body: (tester) async {
        expect(tester.channel.config?.readEvents, isTrue);
        expect(tester.channel.config?.typingEvents, isTrue);
      },
    );
  });

  group('Channel filterTags', () {
    ChannelState Function(ChannelState) _seedChannel({
      List<String>? filterTags,
    }) {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          filterTags: filterTags,
        ),
      );
    }

    channelTest(
      'should return filterTags from channel state',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(filterTags: ['tag1', 'tag2']),
      ),
      body: (tester) async {
        expect(tester.channel.filterTags, equals(['tag1', 'tag2']));
      },
    );

    channelTest(
      'should update filterTags when channel state is updated',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(filterTags: ['tag1', 'tag2']),
      ),
      body: (tester) async {
        expect(tester.channel.filterTags, equals(['tag1', 'tag2']));

        final channelModel = tester.channelState!.channelState.channel!;
        final updatedChannel = channelModel.copyWith(
          filterTags: ['tag3', 'tag4', 'tag5'],
        );

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(channel: updatedChannel),
        );

        expect(tester.channel.filterTags, equals(['tag3', 'tag4', 'tag5']));
      },
    );
  });

  group('Typing Indicator', () {
    ChannelState Function(ChannelState) _seedChannel({
      List<ChannelCapability> ownCapabilities = const [],
    }) {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          ownCapabilities: ownCapabilities,
        ),
      );
    }

    // Reconnects the current user with typing indicators disabled in their
    // privacy settings, the way a server-sent `health.check` frame would.
    Future<void> _disableTypingIndicators(ChannelTester tester) {
      return tester.emitEvent(
        createDefaultConnectedEvent(
          me: createDefaultOwnUser(
            privacySettings: const PrivacySettings(
              typingIndicators: TypingIndicators(enabled: false),
            ),
          ),
        ),
      );
    }

    channelTest(
      ".keystore should return if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no typingEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        final typingEvent = Event(type: EventType.typingStart);

        await expectLater(tester.channel.keyStroke(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      '.keystore should return when user privacy settings is disabled',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        await _disableTypingIndicators(tester);

        final typingEvent = Event(type: EventType.typingStart);

        await expectLater(tester.channel.keyStroke(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      ".keystore should send 'typingStart' event if there is not already a typingEvent or the difference between the two is > 3 seconds",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        final startTypingEvent = Event(type: EventType.typingStart);
        final stopTypingEvent = Event(type: EventType.typingStop);

        tester
          ..mockApi(
            (api) => api.channel.sendEvent(
              _channelId,
              _channelType,
              any(that: isSameEventAs(startTypingEvent, matchParentId: true)),
            ),
            result: createDefaultEmptyResponse(),
          )
          ..mockApi(
            (api) => api.channel.sendEvent(
              _channelId,
              _channelType,
              any(that: isSameEventAs(stopTypingEvent, matchParentId: true)),
            ),
            result: createDefaultEmptyResponse(),
          );

        await expectLater(tester.channel.keyStroke(), completes);

        tester
          ..verifyApi(
            (api) => api.channel.sendEvent(
              _channelId,
              _channelType,
              any(that: isSameEventAs(startTypingEvent, matchParentId: true)),
            ),
          )
          ..verifyApi(
            (api) => api.channel.sendEvent(
              _channelId,
              _channelType,
              any(that: isSameEventAs(stopTypingEvent, matchParentId: true)),
            ),
          );
      },
    );

    channelTest(
      ".startTyping should return if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no typingEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        final typingStartEvent = Event(type: EventType.typingStart);

        await expectLater(tester.channel.startTyping(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStartEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      '.startTyping should return when user privacy settings is disabled',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        await _disableTypingIndicators(tester);

        final typingStartEvent = Event(type: EventType.typingStart);

        await expectLater(tester.channel.startTyping(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStartEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      ".startTyping should send 'typingStart' successfully",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        final typingStartEvent = Event(type: EventType.typingStart);

        tester.mockApi(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStartEvent, matchParentId: true)),
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(tester.channel.startTyping(), completes);

        tester.verifyApi(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStartEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      ".stopTyping should return if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no typingEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        final typingStopEvent = Event(type: EventType.typingStop);

        await expectLater(tester.channel.stopTyping(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStopEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      '.stopTyping should return when user privacy settings is disabled',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        await _disableTypingIndicators(tester);

        final typingStopEvent = Event(type: EventType.typingStop);

        await expectLater(tester.channel.stopTyping(), completes);

        tester.verifyNeverCalled(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStopEvent, matchParentId: true)),
          ),
        );
      },
    );

    channelTest(
      ".stopTyping should send 'typingStop' successfully",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.typingEvents],
        ),
      ),
      body: (tester) async {
        final typingStopEvent = Event(type: EventType.typingStop);

        tester.mockApi(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStopEvent, matchParentId: true)),
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(tester.channel.stopTyping(), completes);

        tester.verifyApi(
          (api) => api.channel.sendEvent(
            _channelId,
            _channelType,
            any(that: isSameEventAs(typingStopEvent, matchParentId: true)),
          ),
        );
      },
    );
  });

  group('Read Receipts', () {
    ChannelState Function(ChannelState) _seedChannel({
      List<ChannelCapability> ownCapabilities = const [],
    }) {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(
          cid: _channelCid,
          ownCapabilities: ownCapabilities,
        ),
      );
    }

    channelTest(
      ".markRead should throw if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no readEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        await expectLater(
          tester.channel.markRead(messageId: 'message-id-123'),
          throwsA(isA<StreamClientException>()),
        );
      },
    );

    channelTest(
      '.markRead should succeed if we have the capability',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      ),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.markRead(
            _channelId,
            _channelType,
            messageId: 'message-id-123',
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(
          tester.channel.markRead(messageId: 'message-id-123'),
          completes,
        );

        tester.verifyApi(
          (api) => api.channel.markRead(
            _channelId,
            _channelType,
            messageId: 'message-id-123',
          ),
        );
      },
    );

    channelTest(
      ".markUnread should throw if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no readEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        await expectLater(
          tester.channel.markUnread('message-id-123'),
          throwsA(isA<StreamClientException>()),
        );
      },
    );

    channelTest(
      '.markUnread should succeed if we have the capability',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      ),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.markUnread(
            _channelId,
            _channelType,
            'message-id-123',
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(
          tester.channel.markUnread('message-id-123'),
          completes,
        );

        tester.verifyApi(
          (api) => api.channel.markUnread(
            _channelId,
            _channelType,
            'message-id-123',
          ),
        );
      },
    );

    channelTest(
      ".markUnreadByTimestamp should throw if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no readEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        final timestamp = DateTime.parse('2024-01-01T00:00:00Z');

        await expectLater(
          tester.channel.markUnreadByTimestamp(timestamp),
          throwsA(isA<StreamClientException>()),
        );
      },
    );

    channelTest(
      '.markUnreadByTimestamp should succeed if we have the capability',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      ),
      body: (tester) async {
        final timestamp = DateTime.parse('2024-01-01T00:00:00Z');

        tester.mockApi(
          (api) => api.channel.markUnreadByTimestamp(
            _channelId,
            _channelType,
            timestamp,
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(
          tester.channel.markUnreadByTimestamp(timestamp),
          completes,
        );

        tester.verifyApi(
          (api) => api.channel.markUnreadByTimestamp(
            _channelId,
            _channelType,
            timestamp,
          ),
        );
      },
    );

    channelTest(
      ".markThreadRead should throw if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no readEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        await expectLater(
          tester.channel.markThreadRead('thread-id-123'),
          throwsA(isA<StreamClientException>()),
        );
      },
    );

    channelTest(
      '.markThreadRead should succeed if we have the capability',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      ),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.markThreadRead(
            _channelId,
            _channelType,
            'thread-id-123',
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(
          tester.channel.markThreadRead('thread-id-123'),
          completes,
        );

        tester.verifyApi(
          (api) => api.channel.markThreadRead(
            _channelId,
            _channelType,
            'thread-id-123',
          ),
        );
      },
    );

    channelTest(
      ".markThreadUnread should throw if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no readEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        await expectLater(
          tester.channel.markThreadUnread('thread-id-123'),
          throwsA(isA<StreamClientException>()),
        );
      },
    );

    channelTest(
      '.markThreadUnread should succeed if we have the capability',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      ),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.markThreadUnread(
            _channelId,
            _channelType,
            'thread-id-123',
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(
          tester.channel.markThreadUnread('thread-id-123'),
          completes,
        );

        tester.verifyApi(
          (api) => api.channel.markThreadUnread(
            _channelId,
            _channelType,
            'thread-id-123',
          ),
        );
      },
    );
  });

  group('Retry functionality with parameter preservation', () {
    group('retryMessage method', () {
      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid),
        );
      }

      channelTest(
        'should call sendMessage with preserved skipPush and skipEnrichUrl parameters',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello, World!',
            state: MessageState.sendingFailed(
              skipPush: true,
              skipEnrichUrl: true,
            ),
          );

          tester.mockApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
            result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<SendMessageResponse>());

          tester.verifyApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
          );
        },
      );

      channelTest(
        'should call sendMessage with preserved skipPush parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello, World!',
            state: MessageState.sendingFailed(
              skipPush: true,
              skipEnrichUrl: false,
            ),
          );

          tester.mockApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
            ),
            result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<SendMessageResponse>());

          tester.verifyApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipPush: true,
            ),
          );
        },
      );

      channelTest(
        'should call sendMessage with preserved skipEnrichUrl parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello, World!',
            state: MessageState.sendingFailed(
              skipPush: false,
              skipEnrichUrl: true,
            ),
          );

          tester.mockApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipEnrichUrl: true,
            ),
            result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<SendMessageResponse>());

          tester.verifyApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
              skipEnrichUrl: true,
            ),
          );
        },
      );

      channelTest(
        'should call sendMessage with preserved false skipPush and skipEnrichUrl parameters',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello, World!',
            state: MessageState.sendingFailed(
              skipPush: false,
              skipEnrichUrl: false,
            ),
          );

          tester.mockApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
            ),
            result: createDefaultSendMessageResponse(message: message.copyWith(state: MessageState.sent)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<SendMessageResponse>());

          tester.verifyApi(
            (api) => api.message.sendMessage(
              _channelId,
              _channelType,
              any(that: isSameMessageAs(message)),
            ),
          );
        },
      );

      channelTest(
        'should call updateMessage with preserved skipPush, skipEnrichUrl parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello, World!',
            state: MessageState.updatingFailed(
              skipPush: true,
              skipEnrichUrl: true,
            ),
          );

          tester.mockApi(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
            result: createDefaultUpdateMessageResponse(message: message.copyWith(state: MessageState.updated)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<UpdateMessageResponse>());

          tester.verifyApi(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
              skipPush: true,
              skipEnrichUrl: true,
            ),
          );
        },
      );

      channelTest(
        'should call updateMessage with preserved false skipPush, skipEnrichUrl parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            state: MessageState.updatingFailed(
              skipPush: false,
              skipEnrichUrl: false,
            ),
          );

          tester.mockApi(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
            ),
            result: createDefaultUpdateMessageResponse(message: message.copyWith(state: MessageState.updated)),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<UpdateMessageResponse>());

          tester.verifyApi(
            (api) => api.message.updateMessage(
              any(that: isSameMessageAs(message)),
            ),
          );
        },
      );

      channelTest(
        'should call deleteMessage with preserved hard parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            createdAt: DateTime.utc(2021, 3),
            state: MessageState.hardDeletingFailed,
          );

          tester.mockApi(
            (api) => api.message.deleteMessage(message.id, hard: true),
            result: createDefaultEmptyResponse(),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<EmptyResponse>());

          tester.verifyApi(
            (api) => api.message.deleteMessage(message.id, hard: true),
          );
        },
      );

      channelTest(
        'should call deleteMessage with preserved false hard parameter',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            createdAt: DateTime.utc(2021, 3),
            state: MessageState.softDeletingFailed,
          );

          tester.mockApi(
            (api) => api.message.deleteMessage(message.id, hard: false),
            result: createDefaultEmptyResponse(),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<EmptyResponse>());

          tester.verifyApi(
            (api) => api.message.deleteMessage(message.id, hard: false),
          );
        },
      );

      channelTest(
        'should call deleteMessageForMe for deletingForMeFailed state',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            createdAt: DateTime.utc(2021, 3),
            state: MessageState.deletingForMeFailed,
          );

          tester.mockApi(
            (api) => api.message.deleteMessage(message.id, deleteForMe: true),
            result: createDefaultEmptyResponse(),
          );

          final result = await tester.channel.retryMessage(message);

          expect(result, isNotNull);
          expect(result, isA<EmptyResponse>());

          tester.verifyApi(
            (api) => api.message.deleteMessage(message.id, deleteForMe: true),
          );
        },
      );

      channelTest(
        'should throw AssertionError when message state is not failed',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'test-message-id',
            state: MessageState.sent,
          );

          expect(() => tester.channel.retryMessage(message), throwsA(isA<AssertionError>()));
        },
      );
    });
  });
}
