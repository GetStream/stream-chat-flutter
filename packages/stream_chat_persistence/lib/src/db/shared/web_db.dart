//ignore_for_file: public_member_api_docs
//ignore_for_file: always_declare_return_types
import 'package:moor/moor_web.dart';

import '../moor_chat_database.dart';

class SharedDB {
  static constructDatabase(
    String dbName, {
    bool logStatements = false,
  }) async {
    return WebDatabase(dbName, logStatements: logStatements);
  }

  static Future<MoorChatDatabase> constructOfflineStorage(
    String dbName, {
    bool logStatements = false,
  }) async {
    return MoorChatDatabase(dbName, logStatements: logStatements);
  }
}
