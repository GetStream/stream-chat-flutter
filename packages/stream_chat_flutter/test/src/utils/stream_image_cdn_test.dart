import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/utils/stream_image_cdn.dart';

void main() {
  const cdn = StreamImageCDN();

  // Every host shape the CDN legitimately serves from.
  const streamHosts = [
    'us-east.stream-io-cdn.com', // region subdomain
    'stream-io-cdn.com', // apex
    'ohio.stream-io-cdn.com.', // absolute form
  ];

  // Hosts that merely contain the CDN name and must not be treated as ours.
  const lookalikeHosts = [
    'stream-io-cdn.com.example', // ours as a prefix
    'evilstream-io-cdn.com', // ours without the separating dot
  ];

  group('StreamImageCDN.resolveUrl', () {
    group('Stream CDN URLs', () {
      test('returns unchanged URL when resize is null', () {
        const url =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?Policy=abc&Signature=xyz&Key-Pair-Id=123';

        expect(cdn.resolveUrl(url), equals(url));
      });

      test('adds resize params when none exist', () {
        const url = 'https://us-east.stream-io-cdn.com/102400/images/photo.jpg';
        const resize = ImageResize(width: 200, height: 300);

        final result = cdn.resolveUrl(url, resize: resize);

        expect(result, contains('w=200'));
        expect(result, contains('h=300'));
        expect(result, contains('resize=clip'));
        expect(result, contains('ro=0'));
        expect(result, isNot(contains('crop=')));
      });

      test('includes crop param only when mode is crop', () {
        const url = 'https://us-east.stream-io-cdn.com/102400/images/photo.jpg';
        const resize = ImageResize(
          width: 400,
          height: 400,
          mode: ResizeMode.crop,
          crop: CropMode.top,
        );

        final result = cdn.resolveUrl(url, resize: resize);

        expect(result, contains('resize=crop'));
        expect(result, contains('crop=top'));
        expect(result, contains('ro=0'));
      });

      test('does not include crop param when mode is not crop', () {
        const url = 'https://us-east.stream-io-cdn.com/102400/images/photo.jpg';

        for (final mode in [
          ResizeMode.clip,
          ResizeMode.scale,
          ResizeMode.fill,
        ]) {
          final result = cdn.resolveUrl(
            url,
            resize: ImageResize(width: 200, height: 200, mode: mode),
          );

          expect(
            result,
            isNot(contains('crop=')),
            reason: 'crop should not be present for mode ${mode.value}',
          );
        }
      });

      test('drops a crop already on the URL when the mode is not crop', () {
        const url = 'https://us-east.stream-io-cdn.com/102400/images/photo.jpg?crop=*';

        final result = cdn.resolveUrl(
          url,
          resize: const ImageResize(width: 200, height: 300),
        );

        expect(result, isNot(contains('crop=')));
      });

      test('leaves a URL that already asks for a size alone', () {
        const url = 'https://us-east.stream-io-cdn.com/102400/images/photo.jpg?w=100&h=100&resize=fill';
        const resize = ImageResize(width: 200, height: 300);

        expect(cdn.resolveUrl(url, resize: resize), equals(url));
      });

      test('resizes every legitimate form of the CDN host', () {
        const resize = ImageResize(width: 200, height: 300);

        for (final host in streamHosts) {
          expect(
            cdn.resolveUrl('https://$host/photo.jpg', resize: resize),
            contains('w=200'),
            reason: '$host should be resized',
          );
        }
      });

      test('treats wildcard placeholders as unsized and resizes them', () {
        const url = 'https://us-east.stream-io-cdn.com/102400/images/photo.jpg?crop=*&h=*&resize=*&w=*';

        final result = cdn.resolveUrl(
          url,
          resize: const ImageResize(width: 200, height: 300),
        );

        expect(result, contains('w=200'));
        expect(result, contains('h=300'));
        expect(result, contains('resize=clip'));
      });

      test('preserves existing non-resize query parameters', () {
        const url =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?Policy=abc&Signature=xyz&Key-Pair-Id=123';
        const resize = ImageResize(width: 200, height: 300);

        final result = cdn.resolveUrl(url, resize: resize);

        expect(result, contains('Policy=abc'));
        expect(result, contains('Signature=xyz'));
        expect(result, contains('Key-Pair-Id=123'));
        expect(result, contains('w=200'));
      });

      test('floors fractional dimensions', () {
        const url = 'https://us-east.stream-io-cdn.com/102400/images/photo.jpg';
        const resize = ImageResize(width: 199.7, height: 300.3);

        final result = cdn.resolveUrl(url, resize: resize);

        expect(result, contains('w=199'));
        expect(result, contains('h=300'));
      });

      test('uses wildcard for zero dimensions', () {
        const url = 'https://us-east.stream-io-cdn.com/102400/images/photo.jpg';
        const resize = ImageResize(width: 0, height: 300);

        final result = cdn.resolveUrl(url, resize: resize);

        expect(result, contains('w=%2A'));
        expect(result, contains('h=300'));
      });
    });

    group('non-Stream URLs', () {
      test('returns URL unchanged regardless of resize', () {
        const url = 'https://example.com/photo.jpg';
        const resize = ImageResize(width: 200, height: 300);

        expect(cdn.resolveUrl(url, resize: resize), equals(url));
      });

      test('returns URL unchanged when resize is null', () {
        const url = 'https://example.com/photo.jpg?token=abc';

        expect(cdn.resolveUrl(url), equals(url));
      });

      test('does not treat a lookalike host as ours', () {
        const resize = ImageResize(width: 200, height: 300);

        for (final host in lookalikeHosts) {
          final url = 'https://$host/photo.jpg';

          expect(
            cdn.resolveUrl(url, resize: resize),
            equals(url),
            reason: '$host should not be resized',
          );
        }
      });
    });
  });

  group('StreamImageCDN.cacheKey', () {
    group('Stream CDN URLs', () {
      test('strips signing parameters', () {
        const url =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?Key-Pair-Id=APKAIHG&Policy=eyJTdGF0&Signature=OeMK5'
            '&w=200&h=300&resize=clip&crop=center';

        final key = cdn.cacheKey(url);

        expect(key, contains('w=200'));
        expect(key, contains('h=300'));
        expect(key, contains('resize=clip'));
        expect(key, contains('crop=center'));
        expect(key, isNot(contains('Key-Pair-Id')));
        expect(key, isNot(contains('Policy')));
        expect(key, isNot(contains('Signature')));
      });

      test('returns URL path only when no resize params exist', () {
        const url =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?Key-Pair-Id=APKAIHG&Policy=eyJTdGF0&Signature=OeMK5';

        final key = cdn.cacheKey(url);

        expect(key, isNot(contains('Key-Pair-Id')));
        expect(key, isNot(contains('Policy')));
        expect(key, isNot(contains('Signature')));
        expect(
          key,
          'https://us-east.stream-io-cdn.com/102400/images/photo.jpg?',
        );
      });

      test('produces same key for same image with different signatures', () {
        const url1 =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?Key-Pair-Id=APKAIHG&Policy=policy1&Signature=sig1'
            '&w=200&h=300';
        const url2 =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?Key-Pair-Id=APKAIHG&Policy=policy2&Signature=sig2'
            '&w=200&h=300';

        expect(cdn.cacheKey(url1), equals(cdn.cacheKey(url2)));
      });

      test('produces different keys for different resize dimensions', () {
        const url1 =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?w=200&h=300';
        const url2 =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?w=400&h=600';

        expect(cdn.cacheKey(url1), isNot(equals(cdn.cacheKey(url2))));
      });

      test('strips oh and ow parameters', () {
        const url =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?oh=4032&ow=3024&w=200&h=300';

        final key = cdn.cacheKey(url);

        expect(key, isNot(contains('oh=')));
        expect(key, isNot(contains('ow=')));
        expect(key, contains('w=200'));
        expect(key, contains('h=300'));
      });

      test('strips signing parameters for every form of the CDN host', () {
        for (final host in streamHosts) {
          final key = cdn.cacheKey('https://$host/a.jpg?Policy=abc&w=200');

          expect(
            key,
            isNot(contains('Policy')),
            reason:
                '$host kept its signing tokens, so every re-sign is a new '
                'cache entry',
          );
        }
      });

      test('is identical whatever order the source URL lists params in', () {
        const signed = 'Key-Pair-Id=APK&Policy=POL&Signature=SIG';
        const path = 'https://us-east.stream-io-cdn.com/1/images/a.jpg';
        const resize = ImageResize(width: 450, height: 600);

        final bare = cdn.resolveUrl('$path?$signed', resize: resize);
        // The wildcard shape real signed URLs arrive in.
        final wildcards = cdn.resolveUrl(
          '$path?crop=*&h=*&resize=*&ro=0&w=*&$signed',
          resize: resize,
        );

        expect(cdn.cacheKey(bare), cdn.cacheKey(wildcards));
      });

      test('orders the persisted parameters by name', () {
        const path = 'https://us-east.stream-io-cdn.com/1/images/a.jpg';

        final url = cdn.resolveUrl(
          '$path?crop=*&h=*&resize=*&w=*',
          resize: const ImageResize(width: 450, height: 600, mode: ResizeMode.crop),
        );

        expect(cdn.cacheKey(url), endsWith('?crop=center&h=600&resize=crop&w=450'));
      });
    });

    group('non-Stream URLs', () {
      test('returns full URL string unchanged', () {
        const url = 'https://example.com/photo.jpg?token=abc';

        expect(cdn.cacheKey(url), equals(url));
      });

      test('keeps the whole query for a lookalike host', () {
        for (final host in lookalikeHosts) {
          final url = 'https://$host/photo.jpg?w=200&token=abc';

          expect(
            cdn.cacheKey(url),
            equals(url),
            reason: '$host should keep its full query',
          );
        }
      });
    });
  });

  group('ResizeMode', () {
    test('all modes have correct string values', () {
      expect(ResizeMode.clip.value, 'clip');
      expect(ResizeMode.crop.value, 'crop');
      expect(ResizeMode.scale.value, 'scale');
      expect(ResizeMode.fill.value, 'fill');
    });
  });

  group('CropMode', () {
    test('all modes have correct string values', () {
      expect(CropMode.center.value, 'center');
      expect(CropMode.top.value, 'top');
      expect(CropMode.bottom.value, 'bottom');
      expect(CropMode.left.value, 'left');
      expect(CropMode.right.value, 'right');
    });
  });
}
