// coverage:ignore-file
import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/stream_chat_persistence_client.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

/// A Helper class to construct new instances of [DriftChatDatabase]
/// specifically for native platform applications.
class SharedDB {
  /// Returns a new instance of [DriftChatDatabase].
  static Future<DriftChatDatabase> constructDatabase(
    String userId, {
    bool logStatements = false,
    ConnectionMode connectionMode = ConnectionMode.regular,
    bool webUseIndexedDbIfSupported = false, // Ignored on native
  }) async {
    final dbName = 'db_$userId';
    if (connectionMode == ConnectionMode.background) {
      return DriftChatDatabase.connect(
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
    return DriftChatDatabase(
      userId,
      LazyDatabase(
        () async => _constructDatabase(
          dbName,
          logStatements: logStatements,
        ),
      ),
    );
  }

  static Future<NativeDatabase> _constructDatabase(
    String dbName, {
    bool logStatements = false,
  }) async {
    if (Platform.isIOS || Platform.isAndroid) {
      final dir = await getApplicationDocumentsDirectory();
      final path = join(dir.path, '$dbName.sqlite');
      final file = File(path);
      return NativeDatabase(file, logStatements: logStatements);
    }
    if (Platform.isMacOS || Platform.isLinux) {
      final file = File('$dbName.sqlite');
      return NativeDatabase(file, logStatements: logStatements);
    }
    return NativeDatabase.memory(logStatements: logStatements);
  }

  static void _startBackground(_IsolateStartRequest request) {
    final executor = LazyDatabase(() async => NativeDatabase(
          File(request.targetPath),
          logStatements: request.logStatements,
        ));
    final moorIsolate = DriftIsolate.inCurrent(
      () => DatabaseConnection.fromExecutor(executor),
    );
    request.sendMoorIsolate.send(moorIsolate);
  }

  static Future<DriftIsolate> _createMoorIsolate(
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

    return await receivePort.first as DriftIsolate;
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
