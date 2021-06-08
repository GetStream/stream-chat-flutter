import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/attachment_file_uploader.dart';
import 'package:stream_chat/src/core/models/attachment_file.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../matchers.dart';
import '../../mocks.dart';
import '../../utils.dart';

void main() {
  late final client = MockHttpClient();
  late StreamAttachmentFileUploader fileUploader;

  setUp(() {
    fileUploader = StreamAttachmentFileUploader(client);
    registerFallbackValue<MultipartFile>(FakeMultiPartFile());
  });

  Response successResponse(String path, {Object? data}) => Response(
        data: data,
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  test('sendImage', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    const path = '/channels/$channelType/$channelId/image';
    final file = assetFile('test_image.jpeg');
    final attachmentFile = AttachmentFile(
      size: 333,
      path: file.path,
      bytes: file.readAsBytesSync(),
    );
    final multipartFile = await attachmentFile.toMultipartFile();

    when(() => client.postFile(
          path,
          any(that: isSameMultipartFileAs(multipartFile)),
        )).thenAnswer((_) async => successResponse(path, data: {
          'file': 'test-file-url',
        }));

    final res = await fileUploader.sendImage(
      attachmentFile,
      channelId,
      channelType,
    );

    expect(res, isNotNull);
    expect(res.file, isNotNull);
    expect(res.file, isNotEmpty);

    verify(() => client.postFile(
          path,
          any(that: isSameMultipartFileAs(multipartFile)),
        )).called(1);
    verifyNoMoreInteractions(client);
  });

  test('sendFile', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    const path = '/channels/$channelType/$channelId/file';
    final file = assetFile('example.pdf');
    final attachmentFile = AttachmentFile(
      size: 333,
      path: file.path,
      bytes: file.readAsBytesSync(),
    );
    final multipartFile = await attachmentFile.toMultipartFile();

    when(() => client.postFile(
          path,
          any(that: isSameMultipartFileAs(multipartFile)),
        )).thenAnswer((_) async => successResponse(path, data: {
          'file': 'test-file-url',
        }));

    final res = await fileUploader.sendFile(
      attachmentFile,
      channelId,
      channelType,
    );

    expect(res, isNotNull);
    expect(res.file, isNotNull);
    expect(res.file, isNotEmpty);

    verify(() => client.postFile(
          path,
          any(that: isSameMultipartFileAs(multipartFile)),
        )).called(1);
    verifyNoMoreInteractions(client);
  });

  test('deleteImage', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const path = '/channels/$channelType/$channelId/image';

    const url = 'test-image-url';

    when(() => client.delete(path, queryParameters: {'url': url})).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await fileUploader.deleteImage(url, channelId, channelType);

    expect(res, isNotNull);

    verify(() => client.delete(path, queryParameters: {'url': url})).called(1);
    verifyNoMoreInteractions(client);
  });

  test('deleteFile', () async {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const path = '/channels/$channelType/$channelId/file';

    const url = 'test-file-url';

    when(() => client.delete(path, queryParameters: {'url': url})).thenAnswer(
        (_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await fileUploader.deleteFile(url, channelId, channelType);

    expect(res, isNotNull);

    verify(() => client.delete(path, queryParameters: {'url': url})).called(1);
    verifyNoMoreInteractions(client);
  });
}
