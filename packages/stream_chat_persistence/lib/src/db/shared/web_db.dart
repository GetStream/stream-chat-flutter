//ignore_for_file: public_member_api_docs
//ignore_for_file: always_declare_return_types
import 'package:moor/moor_web.dart';

import '../moor_chat_database.dart';

class SharedDB {
  static constructDatabase(
    String userId, {
    bool logStatements = false,
  }) async {
    final dbName = 'db_$userId';
    return WebDatabase(dbName, logStatements: logStatements);
  }

  static Future<MoorChatDatabase> constructOfflineStorage(
    String userId, {
    bool logStatements = false,
  }) async {
    final dbName = 'db_$userId';
    return MoorChatDatabase(dbName, logStatements: logStatements);
  }
}
