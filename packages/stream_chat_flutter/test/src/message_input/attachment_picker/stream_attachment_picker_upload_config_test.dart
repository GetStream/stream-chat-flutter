import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_file_picker.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_picker/options/stream_gallery_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets(
    'mobileAttachmentPickerBuilder offers only the allowed extensions to the '
    'file picker',
    (tester) async {
      const validator = StreamAttachmentValidator(
        fileUploadConfig: UploadConfig(allowedFileExtensions: ['.PDF', 'csv']),
      );

      final filePicker = await _buildMobileFilePicker(tester, validator);

      expect(filePicker.type, FileType.custom);
      expect(filePicker.allowedExtensions, ['pdf', 'csv']);
    },
  );

  testWidgets(
    'mobileAttachmentPickerBuilder leaves compound allow-list entries out of '
    'the file picker',
    (tester) async {
      const validator = StreamAttachmentValidator(
        fileUploadConfig: UploadConfig(
          allowedFileExtensions: ['.pdf', '.tar.gz'],
        ),
      );

      final filePicker = await _buildMobileFilePicker(tester, validator);

      expect(filePicker.allowedExtensions, ['pdf']);
    },
  );

  testWidgets(
    'mobileAttachmentPickerBuilder offers any file when no extension '
    'allow-list is set',
    (tester) async {
      const validator = StreamAttachmentValidator(
        fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
      );

      final filePicker = await _buildMobileFilePicker(tester, validator);

      expect(filePicker.type, FileType.any);
      expect(filePicker.allowedExtensions, isNull);
    },
  );

  testWidgets(
    'mobileAttachmentPickerBuilder closes the gallery before reporting a '
    'rejected photo',
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

      Object? error;
      await _pushMobilePicker(
        tester,
        controller: controller,
        onError: (e, _) => error = e,
      );

      final gallery = tester.widget<StreamGalleryPicker>(
        find.byType(StreamGalleryPicker),
      );
      await tester.runAsync(() async {
        gallery.onMediaItemSelected(_FakeAssetEntity(photo!));
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

  testWidgets(
    'the system attachment picker offers only the allowed extensions to the '
    'file picker',
    (tester) async {
      final filePicker = _useFakeFilePicker();

      await _openSystemPicker(tester);
      await tester.tap(find.text('Upload a file'));
      await tester.pumpAndSettle();

      final (type, extensions) = filePicker.calls.single;
      expect(type, FileType.custom);
      expect(extensions, ['pdf']);
    },
  );

  testWidgets(
    'the system attachment picker does not narrow photos to the allowed '
    'image extensions',
    (tester) async {
      final filePicker = _useFakeFilePicker();

      await _openSystemPicker(tester);
      await tester.tap(find.text('Upload a photo'));
      await tester.pumpAndSettle();

      final (type, extensions) = filePicker.calls.single;
      expect(type, FileType.image);
      expect(extensions, isNull);
    },
  );

  testWidgets(
    'the system attachment picker does not narrow videos to the allowed file '
    'extensions',
    (tester) async {
      final filePicker = _useFakeFilePicker();

      await _openSystemPicker(tester);
      await tester.tap(find.text('Upload a video'));
      await tester.pumpAndSettle();

      final (type, extensions) = filePicker.calls.single;
      expect(type, FileType.video);
      expect(extensions, isNull);
    },
  );
}

Future<StreamFilePicker> _buildMobileFilePicker(
  WidgetTester tester,
  StreamAttachmentValidator validator,
) async {
  final controller = StreamAttachmentPickerController(validator: validator);
  addTearDown(controller.dispose);

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: Scaffold(
          body: Builder(
            builder: (context) => mobileAttachmentPickerBuilder(
              context: context,
              controller: controller,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final finder = find.byType(StreamMobileAttachmentPickerBottomSheet);
  final picker = tester.widget<StreamMobileAttachmentPickerBottomSheet>(
    finder,
  );
  final option = picker.options.firstWhere((it) => it.key == 'file-picker');
  final view = option.optionViewBuilder!(tester.element(finder), controller);

  return view as StreamFilePicker;
}

Future<void> _pushMobilePicker(
  WidgetTester tester, {
  required StreamAttachmentPickerController controller,
  required ErrorListener onError,
}) async {
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
                  onError: onError,
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
}

Future<void> _openSystemPicker(WidgetTester tester) async {
  const validator = StreamAttachmentValidator(
    fileUploadConfig: UploadConfig(allowedFileExtensions: ['.pdf']),
    imageUploadConfig: UploadConfig(allowedFileExtensions: ['.png']),
  );

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => showStreamAttachmentPickerModalBottomSheet(
                  context: context,
                  validator: validator,
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

// One fake for the whole file, since `StreamAttachmentHandler.instance` keeps
// the first `FilePicker.platform` it reads.
final _filePicker = _FakeFilePicker();

_FakeFilePicker _useFakeFilePicker() {
  FilePicker.platform = _filePicker;
  _filePicker.calls.clear();
  return _filePicker;
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

// Serves the photo's file directly, since photo_manager only loads files on
// the platforms it supports.
class _FakeAssetEntity extends AssetEntity {
  _FakeAssetEntity(this._file)
      : super(id: 'photo', typeInt: 1, width: 100, height: 100);

  final File _file;

  @override
  Future<File?> get originFile async => _file;
}
