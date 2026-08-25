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

    // Both backends hand the SDK a signed URL, but they sign it differently:
    // CloudFront uses URL-safe base64 (`-`, `~`, `_` padding) while GCP Cloud
    // CDN uses standard base64, which is padded with `=`. Rebuilding the query
    // through `Uri.replace(queryParameters:)` re-encodes `=` as `%3D`, so only
    // the GCP-signed URLs break — the signature no longer matches and the CDN
    // answers 403. These two tests pin that difference.
    group('signed CDN URLs', () {
      test('preserves a CloudFront-signed URL (production backend)', () {
        const policy =
            'eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly91cy1lYX'
            'N0LnN0cmVhbS1pby1jZG4uY29tIn1dfQ__';
        const signature =
            'YNQTx6dJ4utuWCBN8HiXX1y~WwnD1n5a4er5xz5d6lqR03WVvH9'
            '1zYOEFXANuRoTgdGdX5ud0Gs8UTOcSgQU3Sg__';
        const url =
            'https://us-east.stream-io-cdn.com/102400/images/photo.jpg'
            '?Key-Pair-Id=APKAIHG36VEWPDULE23Q'
            '&Policy=$policy'
            '&Signature=$signature'
            '&oh=1920&ow=1440';

        final result = cdn.resolveUrl(
          url,
          resize: const ImageResize(width: 200, height: 300),
        );

        // CloudFront pads with `_`, so nothing here needs escaping.
        expect(result, contains('Policy=$policy'));
        expect(result, contains('Signature=$signature'));
        expect(Uri.parse(result).queryParameters['Policy'], equals(policy));
        expect(
          Uri.parse(result).queryParameters['Signature'],
          equals(signature),
        );
        expect(result, contains('w=200'));
        expect(result, contains('h=300'));
      });

      test('preserves a GCP Cloud CDN-signed URL (staging backend)', () {
        // Standard base64 — note the `==` and `=` padding.
        const urlPrefix =
            'aHR0cHM6Ly91cy1lYXN0MS5nY3Auc3RyZWFtLWlvLWNkbi5jb20'
            'vMTcxNjgxOS9pbWFnZXMvcGhvdG8uanBlZw==';
        const signature = 'kQATRhlxwyG6Uvz3D6-R61GefTA=';
        const url =
            'https://us-east1.gcp.stream-io-cdn.com/1716819/images/photo.jpeg'
            '?oh=447&ow=447'
            '&URLPrefix=$urlPrefix'
            '&Expires=1787660573'
            '&KeyName=chat-us-east1-cdn-key'
            '&Signature=$signature';

        final result = cdn.resolveUrl(
          url,
          resize: const ImageResize(width: 200, height: 300),
        );

        // The regression: `=` must not come back as `%3D`.
        expect(result, isNot(contains('%3D')));
        expect(result, contains('URLPrefix=$urlPrefix'));
        expect(result, contains('Signature=$signature'));
        expect(
          Uri.parse(result).queryParameters['URLPrefix'],
          equals(urlPrefix),
        );
        expect(
          Uri.parse(result).queryParameters['Signature'],
          equals(signature),
        );
        expect(result, contains('w=200'));
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
