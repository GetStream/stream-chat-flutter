import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('StreamAttachmentHandler.pickFile returns null when the picker is closed without a selection', () async {
    _useFilePicker(_FakeFilePickerPlatform());

    final attachment = await StreamAttachmentHandler.instance.pickFile();

    expect(attachment, isNull);
  });

  test('StreamAttachmentHandler.pickFile builds an attachment from the picked file', () async {
    final bytes = Uint8List.fromList(utf8.encode('file_picker 12'));
    _useFilePicker(_FakeFilePickerPlatform(pickedFile: _FakePlatformFile(bytes, name: 'notes.txt')));

    final attachment = await StreamAttachmentHandler.instance.pickFile();

    expect(attachment?.type, AttachmentType.file);
    expect(attachment?.file?.name, 'notes.txt');
    expect(attachment?.file?.bytes, bytes);
    expect(attachment?.fileSize, bytes.length);
  });

  test('StreamAttachmentHandler.pickFile locks the parent window on Windows and Linux by default', () async {
    final platform = _FakeFilePickerPlatform();
    _useFilePicker(platform);

    await StreamAttachmentHandler.instance.pickFile();

    expect(platform.windowsOptions?.lockParentWindow, isTrue);
    expect(platform.linuxOptions?.lockParentWindow, isTrue);
  });

  test('PlatformFileX.toAttachment builds an attachment of the given type from the file content', () async {
    final bytes = Uint8List.fromList(utf8.encode('file_picker 12'));
    final file = _FakePlatformFile(bytes, name: 'notes.txt');

    final attachment = await file.toAttachment(type: AttachmentType.file);

    expect(attachment.type, AttachmentType.file);
    expect(attachment.file?.bytes, bytes);
    expect(attachment.mimeType, 'text/plain');
    expect(attachment.fileSize, bytes.length);
  });
}

void _useFilePicker(FilePickerPlatform platform) {
  final previous = FilePickerPlatform.instance;
  FilePickerPlatform.instance = platform;
  addTearDown(() => FilePickerPlatform.instance = previous);
}

class _FakeFilePickerPlatform extends FilePickerPlatform {
  _FakeFilePickerPlatform({this.pickedFile});

  final PlatformFile? pickedFile;

  WindowsOptions? windowsOptions;
  LinuxOptions? linuxOptions;

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
    this.windowsOptions = windowsOptions;
    this.linuxOptions = linuxOptions;
    return pickedFile;
  }
}

final class _FakePlatformFile extends PlatformFile {
  _FakePlatformFile(this._bytes, {required this.name});

  final Uint8List _bytes;

  @override
  final String name;

  @override
  Uri get uri => Uri.file('/picked/$name');

  @override
  XFile get xFile => XFile.fromData(_bytes, name: name, path: uri.toFilePath());

  @override
  int? lengthSync() => _bytes.length;

  @override
  Future<int> length() async => _bytes.length;

  @override
  Future<Uint8List> readAsBytes() async => _bytes;

  @override
  Stream<Uint8List> readAsByteStream() => Stream.value(_bytes);
}
