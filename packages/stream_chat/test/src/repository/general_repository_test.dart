import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/og_attachment_response.dart';
import 'package:stream_chat/src/repository/general_repository.dart';
import 'package:stream_core/stream_core.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  const url = 'https://getstream.io/chat/';

  test('GeneralRepository.enrichUrl forwards the url to the generated client', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.getOG(url: url)).thenAnswer(
      (_) async => const Result.success(api.GetOGResponse(duration: '0.01ms', custom: {})),
    );

    await GeneralRepository(defaultApi).enrichUrl(url);

    verify(() => defaultApi.getOG(url: url)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('GeneralRepository.enrichUrl returns the mapped response', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.getOG(url: url)).thenAnswer(
      (_) async => const Result.success(
        api.GetOGResponse(duration: '0.01ms', custom: {}, ogScrapeUrl: url, title: 'Chat API & SDKs'),
      ),
    );

    final res = await GeneralRepository(defaultApi).enrichUrl(url);

    expect(
      res.getOrNull(),
      const OGAttachmentResponse(duration: '0.01ms', ogScrapeUrl: url, title: 'Chat API & SDKs'),
    );
  });

  test('GeneralRepository.enrichUrl returns the failure without throwing', () async {
    final defaultApi = MockDefaultApi();
    const error = StreamApiException(
      code: StreamErrorCode.inputError,
      message: 'url is not reachable',
      statusCode: 400,
    );
    when(() => defaultApi.getOG(url: url)).thenAnswer((_) async => const Result.failure(error));

    final res = await GeneralRepository(defaultApi).enrichUrl(url);

    expect(res.exceptionOrNull(), error);
  });
}
