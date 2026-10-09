import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.CreateDraftRequest(message: api.MessageRequest())));

  test('StreamChatClient.createDraft sends the draft message and returns the saved draft', () async {
    const request = api.CreateDraftRequest(
      message: api.MessageRequest(
        id: 'draft-id',
        text: 'Meet @mentioned at noon',
        type: api.MessageRequestType.regular,
        attachments: [api.Attachment(type: 'file', title: 'notes.pdf', actions: [], custom: {})],
        parentId: 'parent-id',
        showInChannel: true,
        mentionedUsers: ['mentioned'],
        quotedMessageId: 'quoted-id',
        silent: true,
        pollId: 'poll-id',
        custom: {'mood': 'busy'},
      ),
    );

    final defaultApi = _defaultApiAnswering(request);
    final client = _client(defaultApi);

    final res = await client.createDraft(
      DraftMessage(
        id: 'draft-id',
        text: 'Meet @mentioned at noon',
        attachments: [Attachment(type: 'file', title: 'notes.pdf', uploadState: const UploadState.success())],
        parentId: 'parent-id',
        showInChannel: true,
        mentionedUsers: [User(id: 'mentioned')],
        quotedMessageId: 'quoted-id',
        silent: true,
        pollId: 'poll-id',
        extraData: const {'mood': 'busy'},
      ),
      'general',
      'messaging',
    );

    final response = res.getOrNull()!;
    final draft = response.draft;
    // A channel compares by identity, so it is checked on its own.
    expect(draft.channel?.cid, 'messaging:general');
    expect(
      response,
      CreateDraftResponse(
        duration: '0.01ms',
        draft: expectedDraft(attachmentId: draft.message.attachments.single.id, channel: draft.channel),
      ),
    );
    verify(() => defaultApi.createDraft(type: 'messaging', id: 'general', createDraftRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.createDraft sends the command written into the text', () async {
    const request = api.CreateDraftRequest(
      message: api.MessageRequest(
        id: 'draft-id',
        text: '/giphy cats',
        type: api.MessageRequestType.regular,
        attachments: [],
        mentionedUsers: [],
        silent: false,
      ),
    );

    final defaultApi = _defaultApiAnswering(request);
    final client = _client(defaultApi);

    await client.createDraft(DraftMessage(id: 'draft-id', text: 'cats', command: 'giphy'), 'general', 'messaging');

    verify(() => defaultApi.createDraft(type: 'messaging', id: 'general', createDraftRequest: request)).called(1);
  });

  test('StreamChatClient.createDraft sends only the users the text still mentions', () async {
    const request = api.CreateDraftRequest(
      message: api.MessageRequest(
        id: 'draft-id',
        text: 'Thanks @Leia',
        type: api.MessageRequestType.regular,
        attachments: [],
        mentionedUsers: ['leia'],
        silent: false,
      ),
    );

    final defaultApi = _defaultApiAnswering(request);
    final client = _client(defaultApi);

    await client.createDraft(
      DraftMessage(
        id: 'draft-id',
        text: 'Thanks @Leia',
        mentionedUsers: [
          User(id: 'leia', name: 'Leia'),
          User(id: 'han', name: 'Han'),
        ],
      ),
      'general',
      'messaging',
    );

    verify(() => defaultApi.createDraft(type: 'messaging', id: 'general', createDraftRequest: request)).called(1);
  });

  test(
    "StreamChatClient.createDraft sends an uploaded attachment's file size and type as custom data, without its file",
    () async {
      const request = api.CreateDraftRequest(
        message: api.MessageRequest(
          id: 'draft-id',
          text: 'The photo',
          type: api.MessageRequestType.regular,
          attachments: [
            api.Attachment(
              type: 'image',
              title: 'cat.png',
              imageUrl: 'https://example.com/cat.png',
              actions: [],
              custom: {'file_size': 1024, 'mime_type': 'image/png'},
            ),
          ],
          mentionedUsers: [],
          silent: false,
        ),
      );

      final defaultApi = _defaultApiAnswering(request);
      final client = _client(defaultApi);

      await client.createDraft(
        DraftMessage(
          id: 'draft-id',
          text: 'The photo',
          attachments: [
            Attachment(
              type: 'image',
              imageUrl: 'https://example.com/cat.png',
              file: AttachmentFile(size: 1024, path: '/photos/cat.png', name: 'cat.png'),
              uploadState: const UploadState.success(),
            ),
          ],
        ),
        'general',
        'messaging',
      );

      verify(() => defaultApi.createDraft(type: 'messaging', id: 'general', createDraftRequest: request)).called(1);
    },
  );

  test(
    "StreamChatClient.createDraft sends a received attachment's Giphy renditions, fields and actions as their own fields",
    () async {
      final request = api.CreateDraftRequest(
        message: api.MessageRequest(
          id: 'draft-id',
          text: 'This one',
          type: api.MessageRequestType.regular,
          attachments: [
            api.Attachment(
              type: 'giphy',
              title: 'Cat',
              thumbUrl: 'https://example.com/thumb.gif',
              fields: const [api.Field(short: true, title: 'Size', value: 'L')],
              actions: const [api.Action(name: 'answer', style: 'primary', text: 'Send', type: 'button', value: 'yes')],
              giphy: api.Images(
                original: _imageData('original'),
                fixedHeight: _imageData('fixed_height'),
                fixedHeightStill: _imageData('fixed_height_still'),
                fixedHeightDownsampled: _imageData('fixed_height_downsampled'),
                fixedWidth: _imageData('fixed_width'),
                fixedWidthStill: _imageData('fixed_width_still'),
                fixedWidthDownsampled: _imageData('fixed_width_downsampled'),
              ),
              custom: const {'caption': 'A cat'},
            ),
          ],
          mentionedUsers: const [],
          silent: false,
        ),
      );

      final defaultApi = _defaultApiAnswering(request);
      final client = _client(defaultApi);

      await client.createDraft(
        DraftMessage(
          id: 'draft-id',
          text: 'This one',
          attachments: [
            Attachment(
              type: 'giphy',
              title: 'Cat',
              thumbUrl: 'https://example.com/thumb.gif',
              fields: const [
                {'short': true, 'title': 'Size', 'value': 'L'},
              ],
              actions: const [Action(name: 'answer', style: 'primary', text: 'Send', type: 'button', value: 'yes')],
              // The id it was received with stays in the extra data, beside the custom data and the renditions.
              extraData: {
                'id': 'received-id',
                'caption': 'A cat',
                'giphy': {
                  for (final rendition in _renditions)
                    rendition: {
                      'frames': '12',
                      'height': '200',
                      'size': '1024',
                      'url': 'https://example.com/$rendition.gif',
                      'width': '300',
                    },
                },
              },
              uploadState: const UploadState.success(),
            ),
          ],
        ),
        'general',
        'messaging',
      );

      verify(() => defaultApi.createDraft(type: 'messaging', id: 'general', createDraftRequest: request)).called(1);
    },
  );

  test(
    'StreamChatClient.createDraft sends the markup in its own field and leaves the fields of a received message out of the custom data',
    () async {
      const request = api.CreateDraftRequest(
        message: api.MessageRequest(
          id: 'draft-id',
          text: 'Draft',
          type: api.MessageRequestType.regular,
          attachments: [],
          mentionedUsers: [],
          silent: false,
          mml: '<mml>Draft</mml>',
          custom: {'mood': 'busy'},
        ),
      );

      final defaultApi = _defaultApiAnswering(request);
      final client = _client(defaultApi);

      // The extra data a draft message carries when it is made from a received message.
      await client.createDraft(
        DraftMessage(
          id: 'draft-id',
          text: 'Draft',
          extraData: const {
            'mood': 'busy',
            'cid': 'messaging:general',
            'html': '<p>Draft</p>',
            'mml': '<mml>Draft</mml>',
            'image_labels': {
              'cat.png': ['cat'],
            },
            'deleted_reply_count': 2,
          },
        ),
        'general',
        'messaging',
      );

      verify(() => defaultApi.createDraft(type: 'messaging', id: 'general', createDraftRequest: request)).called(1);
    },
  );

  test('StreamChatClient.createDraft returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.createDraft(
        type: any(named: 'type'),
        id: any(named: 'id'),
        createDraftRequest: any(named: 'createDraftRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.createDraft(DraftMessage(text: 'Draft'), 'general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

const _renditions = [
  'original',
  'fixed_height',
  'fixed_height_still',
  'fixed_height_downsampled',
  'fixed_width',
  'fixed_width_still',
  'fixed_width_downsampled',
];

api.ImageData _imageData(String rendition) => api.ImageData(
  frames: '12',
  height: '200',
  size: '1024',
  url: 'https://example.com/$rendition.gif',
  width: '300',
);

MockDefaultApi _defaultApiAnswering(api.CreateDraftRequest request) {
  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.createDraft(type: 'messaging', id: 'general', createDraftRequest: request),
  ).thenAnswer((_) async => Result.success(api.CreateDraftResponse(duration: '0.01ms', draft: generatedDraft)));
  return defaultApi;
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
