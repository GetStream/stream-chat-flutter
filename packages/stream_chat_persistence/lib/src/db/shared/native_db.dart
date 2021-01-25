//ignore_for_file: public_member_api_docs

import 'dart:io';
import 'dart:isolate';
import 'package:moor/ffi.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../moor_chat_database.dart';

class SharedDB {
  static Future<VmDatabase> constructDatabase(
    String dbName, {
    bool logStatements = false,
  }) async {
    if (Platform.isIOS || Platform.isAndroid) {
      final dir = await getApplicationDocumentsDirectory();
      final path = join(dir.path, '$dbName.sqlite');
      final file = File(path);
      return VmDatabase(file, logStatements: logStatements);
    }
    if (Platform.isMacOS || Platform.isLinux) {
      final file = File('$dbName.sqlite');
      return VmDatabase(file, logStatements: logStatements);
    }
    return VmDatabase.memory(logStatements: logStatements);
  }

  static void _startBackground(_IsolateStartRequest request) {
    final executor = LazyDatabase(() async {
      return VmDatabase(
        File(request.targetPath),
        logStatements: request.logStatements,
      );
    });
    final moorIsolate = MoorIsolate.inCurrent(
      () => DatabaseConnection.fromExecutor(executor),
    );
    request.sendMoorIsolate.send(moorIsolate);
  }

  static Future<MoorIsolate> _createMoorIsolate(
    String dbName, {
    bool logStatements = false,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, '$dbName.sqlite');

    final receivePort = ReceivePort();
    await Isolate.spawn(
      _startBackground,
      _IsolateStartRequest(
        receivePort.sendPort,
        path,
        logStatements: logStatements,
      ),
    );

    return (await receivePort.first as MoorIsolate);
  }

  static Future<MoorChatDatabase> constructOfflineStorage(
    String dbName, {
    bool logStatements = false,
  }) async {
    final isolate = await _createMoorIsolate(
      dbName,
      logStatements: logStatements,
    );
    final connection = await isolate.connect();
    return MoorChatDatabase.connect(isolate, connection);
  }
}

class _IsolateStartRequest {
  final SendPort sendMoorIsolate;
  final String targetPath;
  final bool logStatements;

  const _IsolateStartRequest(
    this.sendMoorIsolate,
    this.targetPath, {
    this.logStatements = false,
  });
}
