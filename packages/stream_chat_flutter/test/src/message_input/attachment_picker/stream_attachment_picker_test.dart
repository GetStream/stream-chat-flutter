import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      'should enable only the gallery when a video is already attached',
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
