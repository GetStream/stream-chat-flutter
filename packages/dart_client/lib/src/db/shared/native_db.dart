//ignore_for_file: public_member_api_docs
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:moor/ffi.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat/src/db/offline_storage.dart';

class SharedDB {
  static Future<VmDatabase> constructDatabase(dbName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, dbName);
    final file = File(path);
    return VmDatabase(file);
  }

  static Future<MoorIsolate> createMoorIsolate(String userId) async {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'db_$userId.sqlite');

    final receivePort = ReceivePort();
    await Isolate.spawn(
      startBackground,
      _IsolateStartRequest(receivePort.sendPort, path),
    );

    return (await receivePort.first as MoorIsolate);
  }

  static void startBackground(_IsolateStartRequest request) {
    final executor = LazyDatabase(() async {
      return VmDatabase(File(request.targetPath));
    });
    final moorIsolate = MoorIsolate.inCurrent(
      () => DatabaseConnection.fromExecutor(executor),
    );
    request.sendMoorIsolate.send(moorIsolate);
  }

  static Future<OfflineStorage> constructOfflineStorage({
    userId,
    logger,
  }) async {
    logger.info('Connecting on background isolate');
    final isolate = await createMoorIsolate(userId);
    final connection = await isolate.connect();
    return OfflineStorage.connect(
      connection,
      userId,
      isolate,
      logger,
    );
  }
}

class _IsolateStartRequest {
  final SendPort sendMoorIsolate;
  final String targetPath;

  _IsolateStartRequest(this.sendMoorIsolate, this.targetPath);
}
