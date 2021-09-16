import 'package:stream_chat/src/core/models/action.dart';
import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/attachment_file.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/attachment', () {
    test('should parse json correctly', () {
      final attachment = Attachment.fromJson(jsonFixture('attachment.json'));
      expect(attachment.type, 'giphy');
      expect(attachment.title, 'awesome');
      expect(
        attachment.titleLink,
        'https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti',
      );
      expect(
        attachment.thumbUrl,
        'https://media0.giphy.com/media/3o7TKnCdBx5cMg0qti/giphy.gif',
      );
      expect(attachment.actions, hasLength(3));
      expect(attachment.actions[0], isA<Action>());
    });

    test('should serialize to json correctly', () {
      final channel = Attachment(
        type: 'image',
        title: 'soo',
        titleLink:
            'https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti',
      );

      expect(
        channel.toJson(),
        {
          'type': 'image',
          'title': 'soo',
          'title_link':
              'https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti',
          'actions': [],
        },
      );
    });

    test('name property and extraData manipulation', () {
      final file = AttachmentFile(size: 3, path: 'myfolder/myfile.txt');
      final attachment = Attachment(file: file);

      expect(attachment.fileSize, 3);
      expect(attachment.mimeType, 'text/plain');
      expect(attachment.toJson(), {
        'title': 'myfile.txt',
        'actions': [],
        'file_size': 3,
        'mime_type': 'text/plain'
      });
      expect(Attachment.fromJson(attachment.toJson()).toJson(), {
        'title': 'myfile.txt',
        'actions': [],
        'file_size': 3,
        'mime_type': 'text/plain'
      });

      // Setting the size and mimeType using extraData should work fine
      var newAttachment = Attachment(
        extraData: const {
          'file_size': 6,
          'mime_type': 'application/pdf',
        },
      );

      expect(newAttachment.extraData['file_size'], 6);
      expect(newAttachment.extraData['mime_type'], 'application/pdf');
      expect(newAttachment.fileSize, 6);
      expect(newAttachment.mimeType, 'application/pdf');

      // switching a new file should update size and mimeType
      final fileTwo = AttachmentFile(size: 12, path: 'myfolder/fileTwo.pdf');
      newAttachment = attachment.copyWith(file: fileTwo);

      expect(newAttachment.extraData['file_size'], 12);
      expect(newAttachment.extraData['mime_type'], 'application/pdf');
      expect(newAttachment.fileSize, 12);
      expect(newAttachment.mimeType, 'application/pdf');

      // if file is available, should override size and mimeType.
      final fileThree = AttachmentFile(size: 9, path: 'myfolder/fileThree.png');
      newAttachment = attachment.copyWith(file: fileThree, extraData: {
        'file_size': 88,
        'mime_type': 'application/pdf',
      });

      expect(newAttachment.extraData['file_size'], 9);
      expect(newAttachment.extraData['mime_type'], 'image/png');
      expect(newAttachment.fileSize, 9);
      expect(newAttachment.mimeType, 'image/png');
    });
  });
}
