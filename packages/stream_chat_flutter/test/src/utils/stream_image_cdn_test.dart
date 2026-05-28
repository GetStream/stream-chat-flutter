import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/utils/stream_image_cdn.dart';

void main() {
  const cdn = StreamImageCDN();

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

      test('always overrides existing resize params', () {
        const url =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?w=100&h=100&resize=fill';
        const resize = ImageResize(
          width: 200,
          height: 300,
          mode: ResizeMode.crop,
          crop: CropMode.left,
        );

        final result = cdn.resolveUrl(url, resize: resize);

        expect(result, contains('w=200'));
        expect(result, contains('h=300'));
        expect(result, contains('resize=crop'));
        expect(result, contains('crop=left'));
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
    });

    group('non-Stream URLs', () {
      test('returns full URL string unchanged', () {
        const url = 'https://example.com/photo.jpg?token=abc';

        expect(cdn.cacheKey(url), equals(url));
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
