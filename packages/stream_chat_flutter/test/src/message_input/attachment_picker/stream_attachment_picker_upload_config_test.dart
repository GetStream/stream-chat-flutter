import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets(
    'tabbedAttachmentPickerBuilder offers only the allowed extensions to the file picker',
    (tester) async {
      final filePicker = _useFakeFilePicker();
      final controller = _controllerAllowing(['.PDF', 'csv']);

      await _pumpTabbedFilePicker(tester, controller: controller);

      final [(type, extensions)] = filePicker.calls;
      expect(type, FileType.custom);
      expect(extensions, ['pdf', 'csv']);
    },
  );

  testWidgets(
    'tabbedAttachmentPickerBuilder offers any file when no extension allow-list is set',
    (tester) async {
      final filePicker = _useFakeFilePicker();
      final controller = StreamAttachmentPickerController();
      addTearDown(controller.dispose);

      await _pumpTabbedFilePicker(tester, controller: controller);

      final [(type, extensions)] = filePicker.calls;
      expect(type, FileType.any);
      expect(extensions, isNull);
    },
  );

  testWidgets(
    'systemAttachmentPickerBuilder offers only the allowed extensions to the file picker',
    (tester) async {
      final filePicker = _useFakeFilePicker();
      final controller = _controllerAllowing(['.PDF', 'csv']);

      await _tapSystemOption(tester, controller: controller, key: 'file-picker');

      final [(type, extensions)] = filePicker.calls;
      expect(type, FileType.custom);
      expect(extensions, ['pdf', 'csv']);
    },
  );

  testWidgets(
    'systemAttachmentPickerBuilder offers any file when no extension allow-list is set',
    (tester) async {
      final filePicker = _useFakeFilePicker();
      final controller = StreamAttachmentPickerController();
      addTearDown(controller.dispose);

      await _tapSystemOption(tester, controller: controller, key: 'file-picker');

      final [(type, extensions)] = filePicker.calls;
      expect(type, FileType.any);
      expect(extensions, isNull);
    },
  );

  testWidgets(
    'systemAttachmentPickerBuilder does not narrow the photo picker to the allowed file extensions',
    (tester) async {
      final filePicker = _useFakeFilePicker();
      final controller = _controllerAllowing(['.pdf']);

      await _tapSystemOption(tester, controller: controller, key: 'image-picker');

      final [(type, extensions)] = filePicker.calls;
      expect(type, FileType.image);
      expect(extensions, isNull);
    },
  );
}

StreamAttachmentPickerController _controllerAllowing(List<String> fileExtensions) {
  final controller = StreamAttachmentPickerController(
    validator: StreamAttachmentValidator(
      fileUploadConfig: UploadConfig(allowedFileExtensions: fileExtensions),
    ),
  );
  addTearDown(controller.dispose);
  return controller;
}

Future<void> _pumpTabbedFilePicker(
  WidgetTester tester, {
  required StreamAttachmentPickerController controller,
}) async {
  await tester.pumpWidget(
    _wrapWithStreamChatApp(
      Builder(
        builder: (context) {
          return SizedBox(
            height: 400,
            child: tabbedAttachmentPickerBuilder(
              context: context,
              controller: controller,
              allowedTypes: [AttachmentPickerType.files],
            ),
          );
        },
      ),
    ),
  );

  await tester.pumpAndSettle();
}

Future<void> _tapSystemOption(
  WidgetTester tester, {
  required StreamAttachmentPickerController controller,
  required String key,
}) async {
  await tester.pumpWidget(
    _wrapWithStreamChatApp(
      Builder(
        builder: (context) {
          return systemAttachmentPickerBuilder(
            context: context,
            controller: controller,
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  final picker = tester.widget<StreamSystemAttachmentPicker>(
    find.byType(StreamSystemAttachmentPicker),
  );
  final option = picker.options.firstWhere((it) => it.key == key);
  final context = tester.element(find.byType(StreamSystemAttachmentPicker));
  await option.onTap(context, controller);
}

Widget _wrapWithStreamChatApp(Widget widget) {
  return MaterialApp(
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Scaffold(body: widget),
    ),
  );
}

_FakeFilePickerPlatform _useFakeFilePicker() {
  final previous = FilePickerPlatform.instance;
  final fake = _FakeFilePickerPlatform();
  FilePickerPlatform.instance = fake;
  addTearDown(() => FilePickerPlatform.instance = previous);
  return fake;
}

class _FakeFilePickerPlatform extends FilePickerPlatform {
  final calls = <(FileType, List<String>?)>[];

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    calls.add((type, allowedExtensions));
    return null;
  }
}
