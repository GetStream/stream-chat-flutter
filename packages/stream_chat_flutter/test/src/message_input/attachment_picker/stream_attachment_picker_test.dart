import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_file_picker.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_gallery_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('mobileAttachmentPickerBuilder allowedTypes', () {
    testWidgets(
      'should keep the gallery option when only images are allowed',
      (tester) async {
        final controller = StreamAttachmentPickerController();
        addTearDown(controller.dispose);

        await _pumpMobilePicker(
          tester,
          controller: controller,
          allowedTypes: [
            AttachmentPickerType.images,
            AttachmentPickerType.files,
          ],
        );

        final picker = tester.widget<StreamMobileAttachmentPickerBottomSheet>(
          find.byType(StreamMobileAttachmentPickerBottomSheet),
        );

        expect(picker.options.map((it) => it.key), contains('gallery-picker'));
      },
    );

    testWidgets(
      'should drop the options supporting none of the allowed types',
      (tester) async {
        final controller = StreamAttachmentPickerController();
        addTearDown(controller.dispose);

        await _pumpMobilePicker(
          tester,
          controller: controller,
          allowedTypes: [
            AttachmentPickerType.images,
            AttachmentPickerType.files,
          ],
        );

        final picker = tester.widget<StreamMobileAttachmentPickerBottomSheet>(
          find.byType(StreamMobileAttachmentPickerBottomSheet),
        );

        expect(
          picker.options.map((it) => it.key),
          isNot(contains('video-picker')),
        );
      },
    );

    testWidgets(
      'should load only images in the gallery when videos are not allowed',
      (tester) async {
        final controller = StreamAttachmentPickerController();
        addTearDown(controller.dispose);

        await _pumpMobilePicker(
          tester,
          controller: controller,
          allowedTypes: [
            AttachmentPickerType.images,
            AttachmentPickerType.files,
          ],
        );

        final gallery = tester.widget<StreamGalleryPicker>(
          find.byType(StreamGalleryPicker),
        );

        expect(gallery.mediaType, RequestType.image);
      },
    );

    testWidgets(
      'should load only videos in the gallery when images are not allowed',
      (tester) async {
        final controller = StreamAttachmentPickerController();
        addTearDown(controller.dispose);

        await _pumpMobilePicker(
          tester,
          controller: controller,
          allowedTypes: [
            AttachmentPickerType.videos,
            AttachmentPickerType.files,
          ],
        );

        final gallery = tester.widget<StreamGalleryPicker>(
          find.byType(StreamGalleryPicker),
        );

        expect(gallery.mediaType, RequestType.video);
      },
    );

    testWidgets(
      'should load images and videos in the gallery when both are allowed',
      (tester) async {
        final controller = StreamAttachmentPickerController();
        addTearDown(controller.dispose);

        await _pumpMobilePicker(
          tester,
          controller: controller,
          allowedTypes: [
            AttachmentPickerType.images,
            AttachmentPickerType.videos,
          ],
        );

        final gallery = tester.widget<StreamGalleryPicker>(
          find.byType(StreamGalleryPicker),
        );

        expect(gallery.mediaType, RequestType.common);
      },
    );

    testWidgets(
      'should keep a custom option declaring no supported type',
      (tester) async {
        final controller = StreamAttachmentPickerController();
        addTearDown(controller.dispose);

        await _pumpMobilePicker(
          tester,
          controller: controller,
          allowedTypes: [AttachmentPickerType.images],
          customOptions: [
            const AttachmentPickerOption(
              key: 'custom-picker',
              icon: StreamSvgIcon(icon: StreamSvgIcons.search),
              supportedTypes: [],
            ),
          ],
        );

        final picker = tester.widget<StreamMobileAttachmentPickerBottomSheet>(
          find.byType(StreamMobileAttachmentPickerBottomSheet),
        );

        expect(picker.options.map((it) => it.key), contains('custom-picker'));
      },
    );

    testWidgets(
      'should enable videos when a video is attached but videos is not allowed',
      (tester) async {
        final controller = StreamAttachmentPickerController(
          initialAttachments: [
            Attachment(
              id: 'video-attachment',
              type: AttachmentType.video,
              title: 'video.mp4',
            ),
          ],
        );
        addTearDown(controller.dispose);

        await _pumpMobilePicker(
          tester,
          controller: controller,
          allowedTypes: [
            AttachmentPickerType.images,
            AttachmentPickerType.files,
          ],
        );

        final picker = tester.widget<StreamMobileAttachmentPickerBottomSheet>(
          find.byType(StreamMobileAttachmentPickerBottomSheet),
        );

        expect(
          controller.filterEnabledTypes(options: picker.options),
          {AttachmentPickerType.images, AttachmentPickerType.videos},
        );
      },
    );
  });

  group('mobileAttachmentPickerBuilder gallery picker', () {
    testWidgets(
      'should close the picker before reporting a rejected photo',
      (tester) async {
        final controller = StreamAttachmentPickerController(
          validator: const StreamAttachmentValidator(
            imageUploadConfig: UploadConfig(allowedFileExtensions: ['.png']),
          ),
        );
        addTearDown(controller.dispose);

        final photo = await tester.runAsync(() async {
          final dir = await Directory.systemTemp.createTemp();
          return File('${dir.path}/photo.jpg').writeAsBytes([1, 2, 3]);
        });

        // Serve the photo's file the way photo_manager does on a device.
        const photoManager = MethodChannel('com.fluttercandies/photo_manager');
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          photoManager,
          (call) async => call.method == 'getFullFile' ? photo!.path : null,
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger
              .setMockMethodCallHandler(photoManager, null),
        );

        Object? error;
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamChatTheme(
              data: StreamChatThemeData.light(),
              child: child!,
            ),
            home: Builder(
              builder: (context) => TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => Scaffold(
                      body: mobileAttachmentPickerBuilder(
                        context: context,
                        controller: controller,
                        onError: (e, _) => error = e,
                      ),
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        final gallery = tester.widget<StreamGalleryPicker>(
          find.byType(StreamGalleryPicker),
        );

        await tester.runAsync(() async {
          gallery.onMediaItemSelected(
            AssetEntity(id: 'photo', typeInt: 1, width: 100, height: 100),
          );
          await Future<void>.delayed(const Duration(milliseconds: 100));
        });
        await tester.pumpAndSettle();

        expect(error, isA<AttachmentBlockedError>());
        expect(
          find.byType(StreamMobileAttachmentPickerBottomSheet),
          findsNothing,
        );
      },
    );
  });

  group('StreamAttachmentPickerController.addAttachment', () {
    AttachmentFile file(String name, {int size = 1024}) {
      return AttachmentFile(path: '/tmp/$name', size: size);
    }

    test('should throw when the upload config blocks the file', () async {
      final controller = StreamAttachmentPickerController(
        validator: const StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
        ),
      );
      addTearDown(controller.dispose);

      final attachment = Attachment(
        type: AttachmentType.file,
        file: file('setup.exe'),
      );

      await expectLater(
        controller.addAttachment(attachment),
        throwsA(isA<AttachmentBlockedError>()),
      );
      expect(controller.value.attachments, isEmpty);
    });

    test('should apply the validator size limit', () async {
      final controller = StreamAttachmentPickerController(
        validator: const StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(sizeLimit: 500),
        ),
      );
      addTearDown(controller.dispose);

      final attachment = Attachment(
        type: AttachmentType.file,
        file: file('report.pdf', size: 600),
      );

      await expectLater(
        controller.addAttachment(attachment),
        throwsA(const AttachmentTooLargeError(fileSize: 600, maxSize: 500)),
      );
    });

    test('should apply the validator count limit', () {
      final controller = StreamAttachmentPickerController(
        validator: const StreamAttachmentValidator(maxAttachmentCount: 1),
      );
      addTearDown(controller.dispose);

      final attachments = [
        Attachment(type: AttachmentType.file, file: file('a.pdf')),
        Attachment(type: AttachmentType.file, file: file('b.pdf')),
      ];

      expect(
        () => controller.value = controller.value.copyWith(
          attachments: attachments,
        ),
        throwsA(const AttachmentLimitReachedError(maxCount: 1)),
      );
    });

    test('should keep the default attachment count of 10', () {
      final controller = StreamAttachmentPickerController();
      addTearDown(controller.dispose);

      expect(controller.validator.maxAttachmentCount, 10);
    });

    test('should still apply the deprecated limits', () async {
      final controller = StreamAttachmentPickerController(
        maxAttachmentSize: 500,
        maxAttachmentCount: 3,
      );
      addTearDown(controller.dispose);

      expect(controller.validator.fileUploadConfig.sizeLimit, 500);
      expect(controller.validator.imageUploadConfig.sizeLimit, 500);
      expect(controller.validator.maxAttachmentCount, 3);
      expect(controller.maxAttachmentSize, 500);
      expect(controller.maxAttachmentCount, 3);

      final attachment = Attachment(
        type: AttachmentType.file,
        file: file('report.pdf', size: 600),
      );

      await expectLater(
        controller.addAttachment(attachment),
        throwsA(const AttachmentTooLargeError(fileSize: 600, maxSize: 500)),
      );
    });
  });

  group('mobileAttachmentPickerBuilder file picker', () {
    Future<StreamFilePicker> pumpFilePicker(
      WidgetTester tester, {
      required StreamAttachmentValidator validator,
    }) async {
      final controller = StreamAttachmentPickerController(validator: validator);
      addTearDown(controller.dispose);

      await _pumpMobilePicker(
        tester,
        controller: controller,
        allowedTypes: AttachmentPickerType.values,
      );

      final finder = find.byType(StreamMobileAttachmentPickerBottomSheet);
      final picker = tester.widget<StreamMobileAttachmentPickerBottomSheet>(
        finder,
      );

      final option = picker.options.firstWhere(
        (it) => it.key == 'file-picker',
      );

      final view =
          option.optionViewBuilder!(tester.element(finder), controller);
      return view as StreamFilePicker;
    }

    testWidgets(
      'should only offer the allowed file extensions',
      (tester) async {
        final filePicker = await pumpFilePicker(
          tester,
          validator: const StreamAttachmentValidator(
            // With and without the leading dot, in any case.
            fileUploadConfig: UploadConfig(
              allowedFileExtensions: ['.PDF', 'csv'],
            ),
          ),
        );

        expect(filePicker.type, FileType.custom);
        expect(filePicker.allowedExtensions, ['pdf', 'csv']);
      },
    );

    testWidgets(
      'should offer any file when no allow-list is configured',
      (tester) async {
        final filePicker = await pumpFilePicker(
          tester,
          validator: const StreamAttachmentValidator(
            fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
          ),
        );

        expect(filePicker.type, FileType.any);
        expect(filePicker.allowedExtensions, isNull);
      },
    );
  });

  group('system attachment picker', () {
    final filePicker = _FakeFilePicker();

    setUpAll(() => FilePicker.platform = filePicker);
    setUp(filePicker.calls.clear);

    const validator = StreamAttachmentValidator(
      fileUploadConfig: UploadConfig(allowedFileExtensions: ['.pdf']),
      imageUploadConfig: UploadConfig(allowedFileExtensions: ['.png']),
    );

    testWidgets(
      'should only offer the allowed file extensions',
      (tester) async {
        await _openSystemPicker(tester, validator: validator);

        await tester.tap(find.text('Upload a file'));
        await tester.pumpAndSettle();

        final (type, extensions) = filePicker.calls.single;
        expect(type, FileType.custom);
        expect(extensions, ['pdf']);
      },
    );

    testWidgets(
      'should not narrow photos to the image extensions',
      (tester) async {
        await _openSystemPicker(tester, validator: validator);

        await tester.tap(find.text('Upload a photo'));
        await tester.pumpAndSettle();

        final (type, extensions) = filePicker.calls.single;
        expect(type, FileType.image);
        expect(extensions, isNull);
      },
    );

    testWidgets(
      'should not narrow videos to the file extensions',
      (tester) async {
        await _openSystemPicker(tester, validator: validator);

        await tester.tap(find.text('Upload a video'));
        await tester.pumpAndSettle();

        final (type, extensions) = filePicker.calls.single;
        expect(type, FileType.video);
        expect(extensions, isNull);
      },
    );
  });
}

Future<void> _pumpMobilePicker(
  WidgetTester tester, {
  required StreamAttachmentPickerController controller,
  required List<AttachmentPickerType> allowedTypes,
  Iterable<AttachmentPickerOption>? customOptions,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return mobileAttachmentPickerBuilder(
                context: context,
                controller: controller,
                allowedTypes: allowedTypes,
                customOptions: customOptions,
              );
            },
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

Future<void> _openSystemPicker(
  WidgetTester tester, {
  required StreamAttachmentValidator validator,
  Iterable<AttachmentPickerOption>? customOptions,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => showStreamAttachmentPickerModalBottomSheet(
                  context: context,
                  validator: validator,
                  customOptions: customOptions,
                  useSystemAttachmentPicker: true,
                ),
                child: const Text('Open'),
              );
            },
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

class _FakeFilePicker extends FilePicker with MockPlatformInterfaceMixin {
  final calls = <(FileType, List<String>?)>[];

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    calls.add((type, allowedExtensions));
    return null;
  }
}
