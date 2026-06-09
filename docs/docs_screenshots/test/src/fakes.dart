import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:record/record.dart';

class FakeRecordPlatform extends Fake with MockPlatformInterfaceMixin implements RecordPlatform {
  @override
  Future<void> create(String recorderId) async {}

  @override
  Future<bool> hasPermission(String recorderId, {bool request = true}) async {
    return true;
  }

  @override
  Future<bool> isPaused(String recorderId) async {
    return false;
  }

  @override
  Future<bool> isRecording(String recorderId) async {
    return false;
  }

  @override
  Future<void> pause(String recorderId) async {}

  @override
  Future<void> resume(String recorderId) async {}

  @override
  Future<String?> stop(String recorderId) async {
    return 'path';
  }

  @override
  Future<void> cancel(String recorderId) async {}

  @override
  Future<void> dispose(String recorderId) async {}
}
