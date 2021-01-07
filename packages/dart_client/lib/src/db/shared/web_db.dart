import 'package:moor/moor_web.dart';
import 'package:stream_chat/src/db/offline_storage.dart';

class SharedDB {
  static constructDatabase(dbName) async {
    return WebDatabase(dbName);
  }

  static Future<OfflineStorage> constructOfflineStorage({
    userId,
    logger,
  }) async {
    return OfflineStorage(
      userId,
      logger,
    );
  }
}
