// coverage:ignore-file
import 'dart:io';
import 'dart:isolate';

import 'package:moor/ffi.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// A Helper class to construct new instances of [MoorChatDatabase] specifically
/// for native platform applications
class SharedDB {
  /// Returns a new instance of [MoorChatDatabase].
  static MoorChatDatabase constructDatabase(
    String userId, {
    bool logStatements = false,
    ConnectionMode connectionMode = ConnectionMode.regular,
  }) {
    final dbName = 'db_$userId';
    if (connectionMode == ConnectionMode.background) {
      return MoorChatDatabase.connect(
        userId,
        DatabaseConnection.delayed(Future(() async {
          final isolate = await _createMoorIsolate(
            dbName,
            logStatements: logStatements,
          );
          return isolate.connect();
        })),
      );
    }
    return MoorChatDatabase(
      userId,
      LazyDatabase(
        () async => _constructDatabase(
          dbName,
          logStatements: logStatements,
        ),
      ),
    );
  }

  static Future<VmDatabase> _constructDatabase(
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
    final executor = LazyDatabase(() async => VmDatabase(
          File(request.targetPath),
          logStatements: request.logStatements,
        ));
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

    return await receivePort.first as MoorIsolate;
  }
}

class _IsolateStartRequest {
  const _IsolateStartRequest(
    this.sendMoorIsolate,
    this.targetPath, {
    this.logStatements = false,
  });

  final SendPort sendMoorIsolate;
  final String targetPath;
  final bool logStatements;
}
