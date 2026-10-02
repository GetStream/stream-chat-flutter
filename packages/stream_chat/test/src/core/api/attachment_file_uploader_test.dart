import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/cdn/cdn_api.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

void main() {
  const channelId = 'general';
  const channelType = 'messaging';
  const error = StreamClientException(message: 'boom');

  late MockCdnApi cdnApi;
  late StreamChatClient client;

  setUpAll(() => registerFallbackValue(MultipartFile.fromBytes(const [])));

  setUp(() {
    cdnApi = MockCdnApi();
    client = _client(cdnApi);
  });

  test('StreamChatClient.sendImage answers with the URL the channel upload returns', () async {
    _stubChannelImageUpload(cdnApi, const Result.success(api.UploadChannelResponse(duration: '1ms', file: 'url')));

    final result = await client.sendImage(_file(), channelId, channelType);

    expect(result.getOrNull()?.fileUrl, 'url');
  });

  test('StreamChatClient.sendImage uploads to the channel it is given', () async {
    _stubChannelImageUpload(cdnApi, const Result.success(api.UploadChannelResponse(duration: '1ms')));

    await client.sendImage(_file(), channelId, channelType);

    verify(
      () => cdnApi.uploadChannelImage(
        type: channelType,
        id: channelId,
        file: any(named: 'file'),
        onUploadProgress: any(named: 'onUploadProgress'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).called(1);
  });

  test('StreamChatClient.sendImage reports upload progress to onSendProgress', () async {
    when(
      () => cdnApi.uploadChannelImage(
        type: any(named: 'type'),
        id: any(named: 'id'),
        file: any(named: 'file'),
        onUploadProgress: any(named: 'onUploadProgress'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((invocation) async {
      final onProgress = invocation.namedArguments[#onUploadProgress] as ProgressCallback;
      onProgress(5, 10);
      return const Result.success(api.UploadChannelResponse(duration: '1ms'));
    });

    final progress = <(int, int)>[];
    await client.sendImage(
      _file(),
      channelId,
      channelType,
      onSendProgress: (sent, total) => progress.add((sent, total)),
    );

    expect(progress, [(5, 10)]);
  });

  test('StreamChatClient.sendImage passes the cancelToken it is given to the upload', () async {
    _stubChannelImageUpload(cdnApi, const Result.success(api.UploadChannelResponse(duration: '1ms')));
    final cancelToken = CancelToken();

    await client.sendImage(_file(), channelId, channelType, cancelToken: cancelToken);

    verify(
      () => cdnApi.uploadChannelImage(
        type: any(named: 'type'),
        id: any(named: 'id'),
        file: any(named: 'file'),
        onUploadProgress: any(named: 'onUploadProgress'),
        cancelToken: cancelToken,
      ),
    ).called(1);
  });

  test('StreamChatClient.sendImage returns the failure without throwing', () async {
    _stubChannelImageUpload(cdnApi, const Result.failure(error));

    final result = await client.sendImage(_file(), channelId, channelType);

    expect(result.exceptionOrNull(), error);
  });

  test('StreamChatClient.sendImage answers with a failure when the file cannot be read', () async {
    final missing = AttachmentFile(size: 3, path: '/does/not/exist/photo.jpg');

    final result = await client.sendImage(missing, channelId, channelType);

    expect(result.exceptionOrNull(), isA<StateError>());
  });

  test(
    'StreamChatClient.sendFile answers with the URL and thumbnail the channel upload returns',
    () async {
      when(
        () => cdnApi.uploadChannelFile(
          type: channelType,
          id: channelId,
          file: any(named: 'file'),
          onUploadProgress: any(named: 'onUploadProgress'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => const Result.success(
          api.UploadChannelFileResponse(duration: '1ms', file: 'clip-url', thumbUrl: 'thumb-url'),
        ),
      );

      final result = await client.sendFile(_file(name: 'clip.mp4'), channelId, channelType);

      expect(
        result.getOrNull(),
        isA<UploadedFile>()
            .having((it) => it.fileUrl, 'fileUrl', 'clip-url')
            .having((it) => it.thumbUrl, 'thumbUrl', 'thumb-url'),
      );
    },
  );

  test('StreamChatClient.deleteImage deletes the image from the channel it is given', () async {
    when(
      () => cdnApi.deleteChannelImage(
        type: channelType,
        id: channelId,
        url: 'url',
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '1ms')));

    final result = await client.deleteImage('url', channelId, channelType);

    expect(result.isSuccess, isTrue);
  });

  test('StreamChatClient.deleteFile deletes the file from the channel it is given', () async {
    when(
      () => cdnApi.deleteChannelFile(
        type: channelType,
        id: channelId,
        url: 'url',
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '1ms')));

    final result = await client.deleteFile('url', channelId, channelType);

    expect(result.isSuccess, isTrue);
  });

  test('StreamChatClient.deleteFile returns the failure without throwing', () async {
    when(
      () => cdnApi.deleteChannelFile(
        type: any(named: 'type'),
        id: any(named: 'id'),
        url: any(named: 'url'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));

    final result = await client.deleteFile('url', channelId, channelType);

    expect(result.exceptionOrNull(), error);
  });

  test('StreamChatClient.uploadImage answers with the URL the standalone upload returns', () async {
    when(
      () => cdnApi.uploadImage(
        file: any(named: 'file'),
        onUploadProgress: any(named: 'onUploadProgress'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => const Result.success(api.ImageUploadResponse(duration: '1ms', file: 'avatar-url')));

    final result = await client.uploadImage(_file());

    expect(result.getOrNull()?.fileUrl, 'avatar-url');
  });

  test('StreamChatClient.uploadFile answers with the URL the standalone upload returns', () async {
    when(
      () => cdnApi.uploadFile(
        file: any(named: 'file'),
        onUploadProgress: any(named: 'onUploadProgress'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => const Result.success(api.FileUploadResponse(duration: '1ms', file: 'doc-url')));

    final result = await client.uploadFile(_file(name: 'doc.pdf'));

    expect(result.getOrNull()?.fileUrl, 'doc-url');
  });

  test('StreamChatClient.removeImage deletes an image uploaded outside of any channel', () async {
    when(
      () => cdnApi.deleteImage(
        url: 'url',
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '1ms')));

    final result = await client.removeImage('url');

    expect(result.isSuccess, isTrue);
  });

  test('StreamChatClient.removeFile deletes a file uploaded outside of any channel', () async {
    when(
      () => cdnApi.deleteFile(
        url: 'url',
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '1ms')));

    final result = await client.removeFile('url');

    expect(result.isSuccess, isTrue);
  });

  test('StreamChatClient uploads through the uploader its provider builds', () async {
    final uploader = MockAttachmentFileUploader();
    final file = _file();
    when(
      () => uploader.uploadImage(file),
    ).thenAnswer((_) async => const Result.success(UploadedFile(fileUrl: 'custom-url')));

    final client = StreamChatClient(
      'test-api-key',
      chatApi: FakeChatApi(),
      defaultApi: FakeDefaultApi(),
      attachmentFileUploaderProvider: (_) => uploader,
    );
    final result = await client.uploadImage(file);

    expect(result.getOrNull()?.fileUrl, 'custom-url');
  });
}

class MockCdnApi extends Mock implements CdnApi {}

StreamChatClient _client(CdnApi cdnApi) {
  return StreamChatClient(
    'test-api-key',
    chatApi: FakeChatApi(),
    defaultApi: FakeDefaultApi(),
    attachmentFileUploaderProvider: (_) => StreamAttachmentFileUploader.fromApi(cdnApi),
  );
}

AttachmentFile _file({String name = 'photo.jpg'}) {
  final bytes = Uint8List.fromList([1, 2, 3]);
  return AttachmentFile(size: bytes.length, bytes: bytes, name: name);
}

void _stubChannelImageUpload(MockCdnApi cdnApi, Result<api.UploadChannelResponse> result) {
  when(
    () => cdnApi.uploadChannelImage(
      type: any(named: 'type'),
      id: any(named: 'id'),
      file: any(named: 'file'),
      onUploadProgress: any(named: 'onUploadProgress'),
      cancelToken: any(named: 'cancelToken'),
    ),
  ).thenAnswer((_) async => result);
}
