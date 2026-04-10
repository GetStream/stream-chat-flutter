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
      expect(attachment.actions, isNotNull);
      expect(attachment.actions, isNotEmpty);
      expect(attachment.actions, hasLength(3));
      expect(attachment.actions![0], isA<Action>());
    });

    test('should serialize to json correctly', () {
      final channel = Attachment(
        type: 'giphy',
        title: 'soo',
        titleLink: 'https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti',
      );

      expect(
        channel.toJson(),
        {
          'type': 'giphy',
          'title': 'soo',
          'title_link': 'https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti',
          'actions': [],
        },
      );
    });

    test('fileName, mimeType property and extraData manipulation', () {
      final file = AttachmentFile(size: 3, path: 'myfolder/myfile.txt');
      final attachment = Attachment(file: file);

      expect(attachment.fileSize, 3);
      expect(attachment.mimeType, 'text/plain');
      expect(attachment.toJson(), {'title': 'myfile.txt', 'actions': [], 'file_size': 3, 'mime_type': 'text/plain'});
      expect(Attachment.fromJson(attachment.toJson()).toJson(), {
        'title': 'myfile.txt',
        'actions': [],
        'file_size': 3,
        'mime_type': 'text/plain',
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
      newAttachment = attachment.copyWith(
        file: fileThree,
        extraData: {
          'file_size': 88,
          'mime_type': 'application/pdf',
        },
      );

      expect(newAttachment.extraData['file_size'], 9);
      expect(newAttachment.extraData['mime_type'], 'image/png');
      expect(newAttachment.fileSize, 9);
      expect(newAttachment.mimeType, 'image/png');
    });

    group('AttachmentType', () {
      test('should work with string equality', () {
        expect(AttachmentType.image == 'image', isTrue);
        expect(AttachmentType.file == 'file', isTrue);
        expect(AttachmentType.giphy == 'giphy', isTrue);
        expect(AttachmentType.video == 'video', isTrue);
        expect(AttachmentType.audio == 'audio', isTrue);
        expect(AttachmentType.voiceRecording == 'voiceRecording', isTrue);
        expect(AttachmentType.urlPreview == 'url_preview', isTrue);
      });

      test('should create from string correctly', () {
        expect(AttachmentType.fromJson('image'), AttachmentType.image);
        expect(AttachmentType.fromJson('file'), AttachmentType.file);
        expect(AttachmentType.fromJson('new'), const AttachmentType('new'));
      });

      test('should work in switch statements', () {
        const type = AttachmentType.image;

        final result = switch (type) {
          AttachmentType.image => 'image',
          AttachmentType.file => 'file',
          _ => 'other',
        };

        expect(result, 'image');
      });
    });

    group('AttachmentTypeHelper', () {
      test('should identify attachment types correctly', () {
        final imageAttachment = Attachment(type: 'image');
        expect(imageAttachment.isImage, isTrue);
        expect(imageAttachment.isFile, isFalse);

        final fileAttachment = Attachment(type: 'file');
        expect(fileAttachment.isFile, isTrue);
        expect(fileAttachment.isImage, isFalse);

        final giphyAttachment = Attachment(type: 'giphy');
        expect(giphyAttachment.isGiphy, isTrue);

        final videoAttachment = Attachment(type: 'video');
        expect(videoAttachment.isVideo, isTrue);

        final audioAttachment = Attachment(type: 'audio');
        expect(audioAttachment.isAudio, isTrue);

        final voiceAttachment = Attachment(type: 'voiceRecording');
        expect(voiceAttachment.isVoiceRecording, isTrue);

        // Test URL preview detection
        final urlAttachment = Attachment(
          type: 'url_preview',
          titleLink: 'https://example.com',
        );
        expect(urlAttachment.isUrlPreview, isTrue);

        // Test automatic URL preview detection
        final autoUrlAttachment = Attachment(
          ogScrapeUrl: 'https://example.com',
          titleLink: 'https://example.com',
        );
        expect(autoUrlAttachment.isUrlPreview, isTrue);
      });
    });
  });
}
