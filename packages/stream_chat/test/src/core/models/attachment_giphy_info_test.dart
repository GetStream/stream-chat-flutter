import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/attachment_giphy_info.dart';
import 'package:test/test.dart';

void main() {
  group('GiphyInfoType', () {
    test('enum values should have correct string representation', () {
      expect(GiphyInfoType.original.value, 'original');
      expect(GiphyInfoType.fixedHeight.value, 'fixed_height');
      expect(GiphyInfoType.fixedHeightStill.value, 'fixed_height_still');
      expect(
        GiphyInfoType.fixedHeightDownsampled.value,
        'fixed_height_downsampled',
      );
    });
  });

  group('GiphyInfoX', () {
    test('giphyInfo returns valid GiphyInfo object when data is valid', () {
      final attachment = Attachment(extraData: const {
        'giphy': {
          'original': {
            'url': 'https://example.com/original.gif',
            'width': '200',
            'height': '150',
          }
        }
      });

      final giphyInfo = attachment.giphyInfo(GiphyInfoType.original);

      expect(giphyInfo, isNotNull);
      expect(giphyInfo!.url, 'https://example.com/original.gif');
      expect(giphyInfo.width, 200);
      expect(giphyInfo.height, 150);
    });

    test('giphyInfo returns null when giphy data is missing', () {
      final attachment = Attachment();

      final giphyInfo = attachment.giphyInfo(GiphyInfoType.original);

      expect(giphyInfo, isNull);
    });

    test('giphyInfo returns null when the specific GiphyInfoType is missing',
        () {
      final attachment = Attachment(extraData: const {
        'giphy': {
          'fixed_height': {
            'url': 'https://example.com/fixed_height.gif',
            'width': '100',
            'height': '100',
          }
        }
      });

      final giphyInfo = attachment.giphyInfo(GiphyInfoType.original);

      expect(giphyInfo, isNull);
    });
  });
}
